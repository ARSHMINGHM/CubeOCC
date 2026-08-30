#!/usr/bin/env python3
"""
Check CubeOCC frame mapping output.

This validates the START/DATA/END frame shapes from
03_FRAME_AND_LINK_PROTOCOL.md and reconstructs the DATA payload bits back to
the original packed sender bitstream. The default mapper output is confirmed
V1, but this checker also handles experimental larger-grid, RGB, and sequence
metadata variants recorded in the manifest.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from typing import Iterator, List, Sequence, Tuple


Cell = Tuple[int, int]
SYMBOL_BITS = {"grayscale": 1, "rgb": 3}


def iter_packed_bits(path: Path, bit_count: int) -> Iterator[int]:
    emitted = 0
    with path.open("rb") as handle:
        while emitted < bit_count:
            chunk = handle.read(1024 * 1024)
            if not chunk:
                break
            for byte in chunk:
                for shift in range(7, -1, -1):
                    yield (byte >> shift) & 1
                    emitted += 1
                    if emitted == bit_count:
                        return
    if emitted != bit_count:
        raise ValueError(f"{path} ended after {emitted} bits, expected {bit_count}")


def load_json(path: Path) -> dict:
    return json.loads(path.read_text(encoding="ascii"))


def load_frames(path: Path) -> List[dict]:
    frames: List[dict] = []
    with path.open("r", encoding="ascii") as handle:
        for line_no, line in enumerate(handle, start=1):
            line = line.strip()
            if line:
                frame = json.loads(line)
                frame["_line"] = line_no
                frames.append(frame)
    return frames


def cell_symbol(cells: str, cols: int, cell: Cell) -> str:
    return cells[cell[0] * cols + cell[1]]


def int_to_bits(value: int, width: int) -> List[int]:
    return [(value >> shift) & 1 for shift in range(width - 1, -1, -1)]


def symbol_to_bits(symbol: str, symbol_mode: str) -> List[int]:
    value = int(symbol, 16) if symbol_mode == "rgb" else int(symbol)
    return int_to_bits(value, SYMBOL_BITS[symbol_mode])


def on_symbol(symbol_mode: str) -> str:
    return "7" if symbol_mode == "rgb" else "1"


def off_symbol(_symbol_mode: str) -> str:
    return "0"


def check_start(frame: dict, total_cells: int, symbol_mode: str) -> Tuple[bool, str]:
    if frame.get("type") != "START":
        return False, "first frame is not START"
    if frame.get("cells") != on_symbol(symbol_mode) * total_cells:
        return False, "START frame is not all white/on"
    return True, "START ok"


def check_end(frame: dict, rows: int, cols: int, clk: Cell, symbol_mode: str) -> Tuple[bool, str]:
    if frame.get("type") != "END":
        return False, "last frame is not END"
    cells = str(frame.get("cells", ""))
    if len(cells) != rows * cols:
        return False, "END frame has wrong cell count"
    tl, tr, bl, br = (0, 0), (0, cols - 1), (rows - 1, 0), (rows - 1, cols - 1)
    if cell_symbol(cells, cols, tl) != on_symbol(symbol_mode) or cell_symbol(cells, cols, tr) != on_symbol(symbol_mode) or cell_symbol(cells, cols, bl) != on_symbol(symbol_mode):
        return False, "END frame does not keep TL/TR/BL white"
    if cell_symbol(cells, cols, br) != off_symbol(symbol_mode):
        return False, "END frame BR is not black/off"
    if cell_symbol(cells, cols, clk) != off_symbol(symbol_mode):
        return False, "END frame CLK is not black/off"
    for idx, value in enumerate(cells):
        row, col = divmod(idx, cols)
        if (row, col) in (tl, tr, bl):
            continue
        if value != off_symbol(symbol_mode):
            return False, f"END frame has nonzero ordinary cell at row {row}, col {col}"
    return True, "END ok"


def reconstruct_payload(frames: Sequence[dict], manifest: dict) -> Tuple[bool, str, List[int]]:
    rows = int(manifest["rows"])
    cols = int(manifest["cols"])
    symbol_mode = str(manifest.get("symbol_mode", "grayscale"))
    sync_mode = str(manifest.get("sync_mode", "clk"))
    sequence_bits = int(manifest.get("sequence_bits", 0))
    corners = {(item["row"], item["col"]) for item in manifest["corner_markers"]}
    clk = (int(manifest["clk_cell"]["row"]), int(manifest["clk_cell"]["col"]))
    payload_cells = [(int(item["row"]), int(item["col"])) for item in manifest["payload_cells"]]
    payload: List[int] = []
    expected_clk = 0

    for data_index, frame in enumerate(frames, start=1):
        if frame.get("type") != "DATA":
            return False, f"frame {frame.get('index')} is not DATA", payload
        cells = str(frame.get("cells", ""))
        if len(cells) != rows * cols:
            return False, f"DATA frame {data_index} has wrong cell count", payload
        for corner in corners:
            if cell_symbol(cells, cols, corner) != on_symbol(symbol_mode):
                return False, f"DATA frame {data_index} corner marker is not white", payload
        clk_value = symbol_to_bits(cell_symbol(cells, cols, clk), symbol_mode)[0]
        if sync_mode in ("clk", "clk_sequence"):
            if clk_value != expected_clk:
                return False, f"DATA frame {data_index} CLK={clk_value}, expected {expected_clk}", payload
        if int(frame.get("clk")) != clk_value:
            return False, f"DATA frame {data_index} JSON clk field does not match cell", payload
        frame_bits: List[int] = []
        for cell in payload_cells:
            frame_bits.extend(symbol_to_bits(cell_symbol(cells, cols, cell), symbol_mode))
        if sync_mode in ("sequence", "clk_sequence"):
            sequence_value = int(frame.get("sequence"))
            actual_sequence_bits = frame_bits[:sequence_bits]
            expected_sequence_bits = int_to_bits(sequence_value, sequence_bits)
            if actual_sequence_bits != expected_sequence_bits:
                return False, f"DATA frame {data_index} sequence bits do not match JSON sequence", payload
            if sequence_value != (data_index - 1) % (1 << sequence_bits):
                return False, f"DATA frame {data_index} sequence value is not monotonic modulo width", payload
            frame_bits = frame_bits[sequence_bits:]
        payload.extend(frame_bits)
        expected_clk ^= 1

    return True, "DATA frames ok", payload


def check_mapping(bitstream_path: Path, frames_path: Path, manifest_path: Path) -> Tuple[bool, str]:
    manifest = load_json(manifest_path)
    frames = load_frames(frames_path)
    rows = int(manifest["rows"])
    cols = int(manifest["cols"])
    symbol_mode = str(manifest.get("symbol_mode", "grayscale"))
    total_cells = rows * cols
    data_frames = int(manifest["data_frames"])
    bit_count = int(manifest["input_bitstream_bits"])
    clk = (int(manifest["clk_cell"]["row"]), int(manifest["clk_cell"]["col"]))

    if len(frames) != data_frames + 2:
        return False, f"expected {data_frames + 2} frames, found {len(frames)}"
    ok, message = check_start(frames[0], total_cells, symbol_mode)
    if not ok:
        return False, message
    ok, message = check_end(frames[-1], rows, cols, clk, symbol_mode)
    if not ok:
        return False, message
    ok, message, payload = reconstruct_payload(frames[1:-1], manifest)
    if not ok:
        return False, message

    expected = list(iter_packed_bits(bitstream_path, bit_count))
    actual = payload[:bit_count]
    if actual != expected:
        return False, "reconstructed frame payload does not match source bitstream"
    return True, f"frame mapping matches source bitstream ({data_frames} DATA frames, {bit_count} bits)"


def default_manifest_path(frames_path: Path) -> Path:
    if frames_path.name.endswith("_frames.jsonl"):
        return frames_path.with_name(frames_path.name[:-len("_frames.jsonl")] + "_frames_manifest.json")
    return frames_path.with_suffix(".json")


def main(argv: Sequence[str]) -> int:
    parser = argparse.ArgumentParser(description="Check CubeOCC V1 frame JSONL against the source bitstream.")
    parser.add_argument("--bitstream", required=True, type=Path, help="Original packed .bin bitstream.")
    parser.add_argument("--frames", required=True, type=Path, help="Frame JSONL generated by cubeocc_frame_mapper.py.")
    parser.add_argument("--manifest", type=Path, help="Frame manifest. Defaults from --frames name.")
    args = parser.parse_args(argv)

    manifest = args.manifest or default_manifest_path(args.frames)
    ok, message = check_mapping(args.bitstream, args.frames, manifest)
    if ok:
        print(f"PASS: {message}")
        return 0
    print(f"FAIL: {message}")
    return 1


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
