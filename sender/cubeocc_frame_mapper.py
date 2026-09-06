#!/usr/bin/env python3
"""
Map CubeOCC sender bitstreams into logical optical frames.

The mapper follows CubeOCC_Obsidian_Vault/03_FRAME_AND_LINK_PROTOCOL.md:
  - START frame: all 64 cells are white/on.
  - DATA frames: four white corner markers, one CLK/toggle cell, and
    59 grayscale payload cells in row-major order.
  - END frame: TL/TR/BL white, BR off, CLK off, all payload cells off.

The defaults are the confirmed V1 protocol. Extra grid, RGB, and sequence
options are experimental knobs for V1.5/V2 exploration.
"""

from __future__ import annotations

import argparse
import json
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable, Iterator, List, Sequence, Tuple

try:
    from PIL import Image, ImageDraw
except Exception:  # pragma: no cover - image rendering is optional.
    Image = None
    ImageDraw = None

try:
    import tkinter as tk
    from tkinter import filedialog, messagebox, ttk
except Exception:  # pragma: no cover - GUI is optional in headless runs.
    tk = None
    filedialog = None
    messagebox = None
    ttk = None


DEFAULT_ROWS = 8
DEFAULT_COLS = 8
DEFAULT_CLK_ROW = 0
DEFAULT_CLK_COL = 1
SYMBOL_BITS = {"grayscale": 1, "rgb": 3}
SYNC_MODES = ("clk", "sequence", "clk_sequence")
IMAGE_MODES = ("none", "preview", "all")
DEFAULT_PRESET = "8x8:grayscale:clk:0"


Cell = Tuple[int, int]


@dataclass(frozen=True)
class MappingConfig:
    rows: int
    cols: int
    clk_row: int = DEFAULT_CLK_ROW
    clk_col: int = DEFAULT_CLK_COL
    symbol_mode: str = "grayscale"
    sync_mode: str = "clk"
    sequence_bits: int = 0

    @property
    def clk(self) -> Cell:
        return (self.clk_row, self.clk_col)

    @property
    def variant(self) -> str:
        name = f"{self.rows}x{self.cols}_{self.symbol_mode}_{self.sync_mode}"
        if self.sequence_bits and self.sync_mode in ("sequence", "clk_sequence"):
            name += f"_seq{self.sequence_bits}"
        return name


def load_metadata(path: Path) -> dict:
    return json.loads(path.read_text(encoding="ascii"))


def is_sender_metadata(path: Path) -> bool:
    try:
        meta = load_metadata(path)
    except Exception:
        return False
    return "output_bits" in meta and "mode" in meta


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


def chunk_bits(bits: Iterable[int], width: int) -> Iterator[Tuple[List[int], int]]:
    chunk: List[int] = []
    for bit in bits:
        chunk.append(int(bit))
        if len(chunk) == width:
            yield chunk, width
            chunk = []
    if chunk:
        valid = len(chunk)
        chunk.extend([0] * (width - len(chunk)))
        yield chunk, valid


def corner_cells(rows: int, cols: int) -> Tuple[Cell, Cell, Cell, Cell]:
    return ((0, 0), (0, cols - 1), (rows - 1, 0), (rows - 1, cols - 1))


def validate_grid(rows: int, cols: int, clk: Cell, sync_mode: str, sequence_bits: int, symbol_mode: str) -> None:
    if rows < 3 or cols < 3:
        raise ValueError("grid must be at least 3x3 so four corner markers are distinct")
    if not (0 <= clk[0] < rows and 0 <= clk[1] < cols):
        raise ValueError(f"CLK cell {clk} is outside the {rows}x{cols} grid")
    if clk in corner_cells(rows, cols):
        raise ValueError("CLK cell cannot be one of the four corner markers")
    if sync_mode not in SYNC_MODES:
        raise ValueError(f"sync mode must be one of: {', '.join(SYNC_MODES)}")
    if sequence_bits < 0:
        raise ValueError("sequence bits cannot be negative")
    if sync_mode == "sequence" and sequence_bits <= 0:
        raise ValueError("sequence sync requires at least one sequence bit")
    if symbol_mode not in SYMBOL_BITS:
        raise ValueError("symbol mode must be grayscale or rgb")


def payload_cells(rows: int, cols: int, clk: Cell) -> List[Cell]:
    reserved = set(corner_cells(rows, cols))
    reserved.add(clk)
    return [(row, col) for row in range(rows) for col in range(cols) if (row, col) not in reserved]


def bits_to_symbol(bits: Sequence[int], symbol_mode: str) -> str:
    if symbol_mode == "grayscale":
        return "1" if int(bits[0]) else "0"
    value = 0
    for bit in bits:
        value = (value << 1) | int(bit)
    return format(value, "X")


def flatten(cells: Sequence[str]) -> str:
    return "".join(str(cell) for cell in cells)


def make_start_frame(rows: int, cols: int, symbol_mode: str) -> str:
    return bits_to_symbol([1] * SYMBOL_BITS[symbol_mode], symbol_mode) * (rows * cols)


def make_end_frame(rows: int, cols: int, clk: Cell, symbol_mode: str) -> str:
    off = bits_to_symbol([0] * SYMBOL_BITS[symbol_mode], symbol_mode)
    on = bits_to_symbol([1] * SYMBOL_BITS[symbol_mode], symbol_mode)
    cells = [off] * (rows * cols)
    tl, tr, bl, _br = corner_cells(rows, cols)
    for row, col in (tl, tr, bl):
        cells[row * cols + col] = on
    cells[clk[0] * cols + clk[1]] = off
    return flatten(cells)


def int_to_bits(value: int, width: int) -> List[int]:
    return [(value >> shift) & 1 for shift in range(width - 1, -1, -1)]


def symbol_to_bits(symbol: str, symbol_mode: str) -> List[int]:
    value = int(symbol, 16) if symbol_mode == "rgb" else int(symbol)
    return int_to_bits(value, SYMBOL_BITS[symbol_mode])


def make_data_frame(
    rows: int,
    cols: int,
    clk: Cell,
    payload_positions: Sequence[Cell],
    payload_bits: Sequence[int],
    clk_value: int,
    symbol_mode: str,
) -> str:
    off = bits_to_symbol([0] * SYMBOL_BITS[symbol_mode], symbol_mode)
    on = bits_to_symbol([1] * SYMBOL_BITS[symbol_mode], symbol_mode)
    cells = [off] * (rows * cols)
    for row, col in corner_cells(rows, cols):
        cells[row * cols + col] = on
    cells[clk[0] * cols + clk[1]] = bits_to_symbol([clk_value] * SYMBOL_BITS[symbol_mode], symbol_mode)

    width = SYMBOL_BITS[symbol_mode]
    for idx, (row, col) in enumerate(payload_positions):
        start = idx * width
        symbol_bits = payload_bits[start : start + width]
        if len(symbol_bits) < width:
            symbol_bits = list(symbol_bits) + [0] * (width - len(symbol_bits))
        cells[row * cols + col] = bits_to_symbol(symbol_bits, symbol_mode)
    return flatten(cells)


def symbol_color(symbol: str, symbol_mode: str) -> Tuple[int, int, int]:
    if symbol_mode == "grayscale":
        return (255, 255, 255) if symbol == "1" else (0, 0, 0)
    value = int(symbol, 16)
    return (
        255 if value & 0b100 else 0,
        255 if value & 0b010 else 0,
        255 if value & 0b001 else 0,
    )


def render_frame_png(cells: str, rows: int, cols: int, symbol_mode: str, path: Path, cell_px: int) -> None:
    if Image is None or ImageDraw is None:
        raise RuntimeError("Pillow is required for PNG rendering")
    width = cols * cell_px
    height = rows * cell_px
    image = Image.new("RGB", (width, height), (0, 0, 0))
    draw = ImageDraw.Draw(image)
    for idx, symbol in enumerate(cells):
        row, col = divmod(idx, cols)
        x0 = col * cell_px
        y0 = row * cell_px
        draw.rectangle((x0, y0, x0 + cell_px - 1, y0 + cell_px - 1), fill=symbol_color(symbol, symbol_mode))
    image.save(path)


def maybe_render_frame(
    cells: str,
    frame_type: str,
    frame_index: int,
    rows: int,
    cols: int,
    symbol_mode: str,
    image_dir: Path | None,
    image_mode: str,
    preview_count: int,
    cell_px: int,
    data_frames: int,
) -> None:
    if image_dir is None or image_mode == "none":
        return
    should_write = image_mode == "all"
    if image_mode == "preview":
        if frame_type in ("START", "END"):
            should_write = True
        elif frame_type == "DATA" and 1 <= frame_index <= preview_count:
            should_write = True
        elif frame_type == "DATA" and frame_index == data_frames:
            should_write = True
    if not should_write:
        return
    image_dir.mkdir(parents=True, exist_ok=True)
    render_frame_png(cells, rows, cols, symbol_mode, image_dir / f"frame_{frame_index:06d}_{frame_type.lower()}.png", cell_px)


def write_frames(
    bitstream_path: Path,
    metadata_path: Path,
    out_dir: Path,
    rows: int,
    cols: int,
    clk: Cell,
    symbol_mode: str = "grayscale",
    sync_mode: str = "clk",
    sequence_bits: int = 0,
    image_mode: str = "none",
    preview_count: int = 5,
    cell_px: int = 32,
) -> Tuple[Path, Path]:
    if image_mode not in IMAGE_MODES:
        raise ValueError(f"image mode must be one of: {', '.join(IMAGE_MODES)}")
    validate_grid(rows, cols, clk, sync_mode, sequence_bits, symbol_mode)
    metadata = load_metadata(metadata_path)
    output_bits = int(metadata["output_bits"])
    payload_positions = payload_cells(rows, cols, clk)
    symbol_bits = SYMBOL_BITS[symbol_mode]
    payload_symbol_bits = len(payload_positions) * symbol_bits
    metadata_bits = sequence_bits if sync_mode in ("sequence", "clk_sequence") else 0
    if metadata_bits >= payload_symbol_bits:
        raise ValueError("sequence bits must leave at least one bitstream payload bit per DATA frame")
    bits_per_data_frame = payload_symbol_bits - metadata_bits
    data_frames = (output_bits + bits_per_data_frame - 1) // bits_per_data_frame

    out_dir.mkdir(parents=True, exist_ok=True)
    base = bitstream_path.stem
    variant = MappingConfig(rows, cols, clk[0], clk[1], symbol_mode, sync_mode, sequence_bits).variant
    frames_path = out_dir / f"{base}_{variant}_frames.jsonl"
    manifest_path = out_dir / f"{base}_{variant}_frames_manifest.json"
    image_dir = out_dir / f"{base}_{variant}_images" if image_mode != "none" else None

    with frames_path.open("w", encoding="ascii", newline="\n") as frames:
        start_cells = make_start_frame(rows, cols, symbol_mode)
        frames.write(json.dumps({"index": 0, "type": "START", "clk": None, "sequence": None, "cells": start_cells}, separators=(",", ":")) + "\n")
        maybe_render_frame(start_cells, "START", 0, rows, cols, symbol_mode, image_dir, image_mode, preview_count, cell_px, data_frames)
        clk_value = 0
        for idx, (payload, valid_payload_bits) in enumerate(chunk_bits(iter_packed_bits(bitstream_path, output_bits), bits_per_data_frame), start=1):
            sequence_value = (idx - 1) % (1 << sequence_bits) if metadata_bits else None
            frame_bits = []
            if metadata_bits:
                frame_bits.extend(int_to_bits(int(sequence_value), sequence_bits))
            frame_bits.extend(payload)
            cells = make_data_frame(rows, cols, clk, payload_positions, frame_bits, clk_value, symbol_mode)
            maybe_render_frame(cells, "DATA", idx, rows, cols, symbol_mode, image_dir, image_mode, preview_count, cell_px, data_frames)
            frames.write(
                json.dumps(
                    {
                        "index": idx,
                        "type": "DATA",
                        "clk": clk_value,
                        "sequence": sequence_value,
                        "valid_payload_bits": valid_payload_bits,
                        "cells": cells,
                    },
                    separators=(",", ":"),
                )
                + "\n"
            )
            clk_value ^= 1
        end_cells = make_end_frame(rows, cols, clk, symbol_mode)
        frames.write(json.dumps({"index": data_frames + 1, "type": "END", "clk": 0, "sequence": None, "cells": end_cells}, separators=(",", ":")) + "\n")
        maybe_render_frame(end_cells, "END", data_frames + 1, rows, cols, symbol_mode, image_dir, image_mode, preview_count, cell_px, data_frames)

    manifest = {
        "tool": "cubeocc_frame_mapper.py",
        "protocol_note": "CubeOCC_Obsidian_Vault/03_FRAME_AND_LINK_PROTOCOL.md",
        "version": "V1" if rows == 8 and cols == 8 and symbol_mode == "grayscale" and sync_mode == "clk" and sequence_bits == 0 else "experimental",
        "source_bitstream": str(bitstream_path),
        "source_metadata": str(metadata_path),
        "frame_file": frames_path.name,
        "image_mode": image_mode,
        "image_dir": image_dir.name if image_dir is not None else None,
        "preview_count": preview_count,
        "cell_px": cell_px,
        "rows": rows,
        "cols": cols,
        "symbol_mode": symbol_mode,
        "bits_per_symbol": symbol_bits,
        "sync_mode": sync_mode,
        "sequence_bits": sequence_bits,
        "cell_order": "row-major",
        "corner_markers": [{"row": row, "col": col} for row, col in corner_cells(rows, cols)],
        "clk_cell": {"row": clk[0], "col": clk[1]},
        "payload_cells": [{"row": row, "col": col} for row, col in payload_positions],
        "payload_symbol_bits_per_data_frame": payload_symbol_bits,
        "metadata_bits_per_data_frame": metadata_bits,
        "bitstream_bits_per_data_frame": bits_per_data_frame,
        "input_bitstream_bits": output_bits,
        "padding_payload_bits": data_frames * bits_per_data_frame - output_bits,
        "data_frames": data_frames,
        "total_frames": data_frames + 2,
        "start_frame": "all cells white/on",
        "data_frame": "4 white corners + optional CLK toggle + optional sequence bits + bitstream payload cells",
        "end_frame": "TL/TR/BL white, BR off, CLK off, payload cells off",
        "bitstream_metadata": metadata,
    }
    manifest_path.write_text(json.dumps(manifest, indent=2) + "\n", encoding="ascii")
    return frames_path, manifest_path


def parse_preset(text: str, defaults: MappingConfig | None = None) -> MappingConfig:
    defaults = defaults or MappingConfig(DEFAULT_ROWS, DEFAULT_COLS)
    parts = [part.strip() for part in text.split(":")]
    if len(parts) < 1 or not parts[0]:
        raise ValueError("preset cannot be empty")
    if "x" not in parts[0].lower():
        raise ValueError("preset grid must look like 8x8")
    rows_text, cols_text = parts[0].lower().split("x", 1)
    rows = int(rows_text)
    cols = int(cols_text)
    symbol_mode = parts[1] if len(parts) > 1 and parts[1] else defaults.symbol_mode
    sync_mode = parts[2] if len(parts) > 2 and parts[2] else defaults.sync_mode
    sequence_bits = int(parts[3]) if len(parts) > 3 and parts[3] else defaults.sequence_bits
    clk_row = int(parts[4]) if len(parts) > 4 and parts[4] else defaults.clk_row
    clk_col = int(parts[5]) if len(parts) > 5 and parts[5] else defaults.clk_col
    return MappingConfig(rows, cols, clk_row, clk_col, symbol_mode, sync_mode, sequence_bits)


def parse_presets(text: str, defaults: MappingConfig | None = None) -> List[MappingConfig]:
    presets = []
    for raw in text.replace("\n", ";").split(";"):
        raw = raw.strip()
        if raw:
            presets.append(parse_preset(raw, defaults))
    if not presets:
        raise ValueError("at least one mapping preset is required")
    return presets


def find_bitstream_pairs(folder: Path) -> List[Tuple[Path, Path]]:
    pairs: List[Tuple[Path, Path]] = []
    for bitstream in sorted(folder.glob("*.bin")):
        metadata = bitstream.with_suffix(".json")
        if metadata.exists() and is_sender_metadata(metadata):
            pairs.append((bitstream, metadata))
    return pairs


def write_batch(
    input_dir: Path,
    out_dir: Path,
    configs: Sequence[MappingConfig],
    image_mode: str,
    preview_count: int,
    cell_px: int,
) -> Tuple[List[Tuple[Path, Path]], List[str]]:
    pairs = find_bitstream_pairs(input_dir)
    if not pairs:
        raise ValueError(f"no .bin/.json sender bitstream pairs found in {input_dir}")
    written: List[Tuple[Path, Path]] = []
    errors: List[str] = []
    for config in configs:
        variant_dir = out_dir / config.variant
        for bitstream, metadata in pairs:
            try:
                written.append(
                    write_frames(
                        bitstream,
                        metadata,
                        variant_dir,
                        config.rows,
                        config.cols,
                        config.clk,
                        config.symbol_mode,
                        config.sync_mode,
                        config.sequence_bits,
                        image_mode,
                        preview_count,
                        cell_px,
                    )
                )
            except Exception as exc:
                errors.append(f"{bitstream.name} / {config.variant}: {exc}")
    manifest = {
        "tool": "cubeocc_frame_mapper.py",
        "batch_input_dir": str(input_dir),
        "batch_output_dir": str(out_dir),
        "bitstream_pairs": len(pairs),
        "presets": [config.variant for config in configs],
        "image_mode": image_mode,
        "preview_count": preview_count,
        "cell_px": cell_px,
        "written_outputs": len(written),
        "errors": errors,
    }
    out_dir.mkdir(parents=True, exist_ok=True)
    (out_dir / "batch_manifest.json").write_text(json.dumps(manifest, indent=2) + "\n", encoding="ascii")
    return written, errors


def default_metadata_path(bitstream_path: Path) -> Path:
    return bitstream_path.with_suffix(".json")


class FrameMapperGui:
    def __init__(self) -> None:
        if tk is None or ttk is None:
            raise RuntimeError("tkinter is not available in this Python environment")
        self.root = tk.Tk()
        self.root.title("CubeOCC Frame Mapper")

        self.bitstream = tk.StringVar()
        self.input_dir = tk.StringVar()
        self.metadata = tk.StringVar()
        self.output_dir = tk.StringVar(value="sim/sender_frames")
        self.rows = tk.IntVar(value=DEFAULT_ROWS)
        self.cols = tk.IntVar(value=DEFAULT_COLS)
        self.clk_row = tk.IntVar(value=DEFAULT_CLK_ROW)
        self.clk_col = tk.IntVar(value=DEFAULT_CLK_COL)
        self.symbol_mode = tk.StringVar(value="grayscale")
        self.sync_mode = tk.StringVar(value="clk")
        self.sequence_bits = tk.IntVar(value=0)
        self.batch = tk.BooleanVar(value=False)
        self.presets = tk.StringVar(value=DEFAULT_PRESET)
        self.image_mode = tk.StringVar(value="preview")
        self.preview_count = tk.IntVar(value=5)
        self.cell_px = tk.IntVar(value=32)
        self.preset_list: tk.Listbox | None = None
        self.status = tk.StringVar(value="Choose a generated .bin bitstream.")
        self._build()

    def _build(self) -> None:
        frame = ttk.Frame(self.root, padding=12)
        frame.grid(row=0, column=0, sticky="nsew")
        self.root.columnconfigure(0, weight=1)
        self.root.rowconfigure(0, weight=1)
        frame.columnconfigure(1, weight=1)

        mode = ttk.LabelFrame(frame, text="Input mode")
        mode.grid(row=0, column=0, columnspan=3, sticky="ew")
        ttk.Radiobutton(mode, text="One bitstream file", variable=self.batch, value=False).grid(row=0, column=0, sticky="w", padx=(0, 16))
        ttk.Radiobutton(mode, text="Whole folder batch", variable=self.batch, value=True).grid(row=0, column=1, sticky="w")

        ttk.Label(frame, text="Bitstream .bin").grid(row=1, column=0, sticky="w", pady=(8, 0))
        ttk.Entry(frame, textvariable=self.bitstream).grid(row=1, column=1, sticky="ew", padx=6, pady=(8, 0))
        ttk.Button(frame, text="Browse", command=self._choose_bitstream).grid(row=1, column=2, pady=(8, 0))

        ttk.Label(frame, text="Batch folder").grid(row=2, column=0, sticky="w", pady=(6, 0))
        ttk.Entry(frame, textvariable=self.input_dir).grid(row=2, column=1, sticky="ew", padx=6, pady=(6, 0))
        ttk.Button(frame, text="Browse", command=self._choose_input_dir).grid(row=2, column=2, pady=(6, 0))

        ttk.Label(frame, text="Metadata .json").grid(row=3, column=0, sticky="w", pady=(6, 0))
        ttk.Entry(frame, textvariable=self.metadata).grid(row=3, column=1, sticky="ew", padx=6, pady=(6, 0))
        ttk.Button(frame, text="Browse", command=self._choose_metadata).grid(row=3, column=2, pady=(6, 0))

        ttk.Label(frame, text="Output folder").grid(row=4, column=0, sticky="w", pady=(6, 0))
        ttk.Entry(frame, textvariable=self.output_dir).grid(row=4, column=1, sticky="ew", padx=6, pady=(6, 0))
        ttk.Button(frame, text="Browse", command=self._choose_output).grid(row=4, column=2, pady=(6, 0))

        grid = ttk.LabelFrame(frame, text="Custom mapping settings")
        grid.grid(row=5, column=0, columnspan=3, sticky="ew", pady=(12, 0))
        for col in range(8):
            grid.columnconfigure(col, weight=1)
        ttk.Label(grid, text="Rows").grid(row=0, column=0, sticky="w")
        ttk.Spinbox(grid, from_=3, to=256, textvariable=self.rows, width=8).grid(row=1, column=0, sticky="w")
        ttk.Label(grid, text="Cols").grid(row=0, column=1, sticky="w")
        ttk.Spinbox(grid, from_=3, to=256, textvariable=self.cols, width=8).grid(row=1, column=1, sticky="w")
        ttk.Label(grid, text="CLK row").grid(row=0, column=2, sticky="w")
        ttk.Spinbox(grid, from_=0, to=255, textvariable=self.clk_row, width=8).grid(row=1, column=2, sticky="w")
        ttk.Label(grid, text="CLK col").grid(row=0, column=3, sticky="w")
        ttk.Spinbox(grid, from_=0, to=255, textvariable=self.clk_col, width=8).grid(row=1, column=3, sticky="w")
        ttk.Label(grid, text="Symbols").grid(row=0, column=4, sticky="w")
        ttk.Combobox(grid, textvariable=self.symbol_mode, values=("grayscale", "rgb"), state="readonly", width=12).grid(row=1, column=4, sticky="w")
        ttk.Label(grid, text="Sync").grid(row=0, column=5, sticky="w")
        ttk.Combobox(grid, textvariable=self.sync_mode, values=SYNC_MODES, state="readonly", width=14).grid(row=1, column=5, sticky="w")
        ttk.Label(grid, text="Seq bits").grid(row=0, column=6, sticky="w")
        ttk.Spinbox(grid, from_=0, to=32, textvariable=self.sequence_bits, width=8).grid(row=1, column=6, sticky="w")

        presets = ttk.LabelFrame(frame, text="Mapping presets")
        presets.grid(row=6, column=0, columnspan=3, sticky="nsew", pady=(12, 0))
        presets.columnconfigure(1, weight=1)
        ttk.Button(presets, text="Add Current Settings", command=self._add_current_preset).grid(row=0, column=0, sticky="ew", padx=(0, 6))
        ttk.Button(presets, text="V1 8x8 Grayscale", command=lambda: self._add_preset("8x8:grayscale:clk:0")).grid(row=1, column=0, sticky="ew", padx=(0, 6), pady=(4, 0))
        ttk.Button(presets, text="RGB + CLK + Seq", command=lambda: self._add_preset("8x8:rgb:clk_sequence:8")).grid(row=2, column=0, sticky="ew", padx=(0, 6), pady=(4, 0))
        ttk.Button(presets, text="16x16 Seq", command=lambda: self._add_preset("16x16:grayscale:sequence:8")).grid(row=3, column=0, sticky="ew", padx=(0, 6), pady=(4, 0))
        ttk.Button(presets, text="Remove Selected", command=self._remove_selected_preset).grid(row=4, column=0, sticky="ew", padx=(0, 6), pady=(4, 0))
        ttk.Button(presets, text="Clear List", command=self._clear_presets).grid(row=5, column=0, sticky="ew", padx=(0, 6), pady=(4, 0))
        self.preset_list = tk.Listbox(presets, height=6, exportselection=False)
        self.preset_list.grid(row=0, column=1, rowspan=6, sticky="nsew")
        self._add_preset(DEFAULT_PRESET)

        batch = ttk.LabelFrame(frame, text="Images")
        batch.grid(row=7, column=0, columnspan=3, sticky="ew", pady=(12, 0))
        batch.columnconfigure(1, weight=1)
        ttk.Label(batch, text="Image mode").grid(row=0, column=0, sticky="w")
        ttk.Combobox(batch, textvariable=self.image_mode, values=IMAGE_MODES, state="readonly", width=10).grid(row=0, column=1, sticky="w", padx=6)
        ttk.Label(batch, text="Preview data frames").grid(row=0, column=2, sticky="w", padx=(12, 0))
        ttk.Spinbox(batch, from_=0, to=1000000, textvariable=self.preview_count, width=8).grid(row=0, column=3, sticky="w")
        ttk.Label(batch, text="Cell px").grid(row=0, column=4, sticky="w", padx=(12, 0))
        ttk.Spinbox(batch, from_=4, to=256, textvariable=self.cell_px, width=8).grid(row=0, column=5, sticky="w")

        ttk.Button(frame, text="Generate Frames", command=self._run).grid(row=8, column=0, sticky="w", pady=(12, 0))
        ttk.Label(frame, textvariable=self.status, wraplength=760).grid(row=8, column=1, columnspan=2, sticky="w", padx=6, pady=(12, 0))

    def _current_preset_text(self) -> str:
        return f"{int(self.rows.get())}x{int(self.cols.get())}:{self.symbol_mode.get()}:{self.sync_mode.get()}:{int(self.sequence_bits.get())}:{int(self.clk_row.get())}:{int(self.clk_col.get())}"

    def _all_preset_text(self) -> str:
        if self.preset_list is None:
            return self.presets.get()
        values = [self.preset_list.get(idx) for idx in range(self.preset_list.size())]
        return ";".join(values)

    def _add_current_preset(self) -> None:
        self._add_preset(self._current_preset_text())

    def _add_preset(self, text: str) -> None:
        parse_preset(text)
        if self.preset_list is not None:
            existing = {self.preset_list.get(idx) for idx in range(self.preset_list.size())}
            if text not in existing:
                self.preset_list.insert(tk.END, text)
        self.presets.set(self._all_preset_text())

    def _remove_selected_preset(self) -> None:
        if self.preset_list is None:
            return
        for idx in reversed(self.preset_list.curselection()):
            self.preset_list.delete(idx)
        self.presets.set(self._all_preset_text())

    def _clear_presets(self) -> None:
        if self.preset_list is not None:
            self.preset_list.delete(0, tk.END)
        self.presets.set("")

    def _choose_bitstream(self) -> None:
        path = filedialog.askopenfilename(filetypes=[("Packed bitstream", "*.bin"), ("All files", "*.*")])
        if path:
            self.bitstream.set(path)
            self.batch.set(False)
            meta = str(Path(path).with_suffix(".json"))
            if Path(meta).exists():
                self.metadata.set(meta)

    def _choose_metadata(self) -> None:
        path = filedialog.askopenfilename(filetypes=[("Metadata", "*.json"), ("All files", "*.*")])
        if path:
            self.metadata.set(path)

    def _choose_input_dir(self) -> None:
        path = filedialog.askdirectory()
        if path:
            self.input_dir.set(path)
            self.batch.set(True)

    def _choose_output(self) -> None:
        path = filedialog.askdirectory()
        if path:
            self.output_dir.set(path)

    def _run(self) -> None:
        try:
            if self.batch.get():
                configs = parse_presets(self._all_preset_text())
                written, errors = write_batch(
                    Path(self.input_dir.get()),
                    Path(self.output_dir.get()),
                    configs,
                    self.image_mode.get(),
                    int(self.preview_count.get()),
                    int(self.cell_px.get()),
                )
                self.status.set(f"Batch wrote {len(written)} mappings with {len(errors)} errors.")
                if messagebox is not None:
                    messagebox.showinfo("CubeOCC Frame Mapper", f"Batch wrote {len(written)} mappings.\nErrors: {len(errors)}")
                return
            bitstream = Path(self.bitstream.get())
            metadata = Path(self.metadata.get()) if self.metadata.get() else default_metadata_path(bitstream)
            configs = parse_presets(self._all_preset_text() or self._current_preset_text())
            written = []
            for config in configs:
                written.append(
                    write_frames(
                        bitstream,
                        metadata,
                        Path(self.output_dir.get()) / config.variant if len(configs) > 1 else Path(self.output_dir.get()),
                        config.rows,
                        config.cols,
                        config.clk,
                        config.symbol_mode,
                        config.sync_mode,
                        config.sequence_bits,
                        self.image_mode.get(),
                        int(self.preview_count.get()),
                        int(self.cell_px.get()),
                    )
                )
        except Exception as exc:
            self.status.set(f"Error: {exc}")
            if messagebox is not None:
                messagebox.showerror("CubeOCC Frame Mapper", str(exc))
            return
        self.status.set(f"Wrote {len(written)} mapping result(s).")
        if messagebox is not None:
            messagebox.showinfo("CubeOCC Frame Mapper", f"Wrote {len(written)} mapping result(s).")

    def run(self) -> None:
        self.root.mainloop()


def main(argv: Sequence[str]) -> int:
    parser = argparse.ArgumentParser(description="Map CubeOCC .bin bitstreams into logical optical frame JSONL and optional PNG images.")
    parser.add_argument("--gui", action="store_true", help="Open the frame mapper GUI.")
    parser.add_argument("--bitstream", type=Path, help="Packed .bin bitstream generated by cubeocc_sender_gui.py.")
    parser.add_argument("--input-dir", type=Path, help="Batch mode: folder containing .bin files and companion .json metadata.")
    parser.add_argument("--metadata", type=Path, help="Companion .json metadata. Defaults to the same stem as --bitstream.")
    parser.add_argument("--out", default=Path("sim/sender_frames"), type=Path, help="Output directory for frame JSONL and manifest.")
    parser.add_argument("--rows", default=DEFAULT_ROWS, type=int)
    parser.add_argument("--cols", default=DEFAULT_COLS, type=int)
    parser.add_argument("--clk-row", default=DEFAULT_CLK_ROW, type=int)
    parser.add_argument("--clk-col", default=DEFAULT_CLK_COL, type=int)
    parser.add_argument("--symbol-mode", default="grayscale", choices=tuple(SYMBOL_BITS), help="grayscale uses 1 bit/cell; rgb uses 3 bits/cell encoded as 0..7 symbols.")
    parser.add_argument("--sync-mode", default="clk", choices=SYNC_MODES, help="clk is V1; sequence or clk_sequence reserve payload bits for a per-frame sequence number.")
    parser.add_argument("--sequence-bits", default=0, type=int, help="Bits reserved at the start of each DATA frame for sequence number.")
    parser.add_argument("--presets", default="", help="Batch presets separated by semicolon/newline, e.g. 8x8:grayscale:clk:0;8x8:rgb:clk_sequence:8;16x16:grayscale:sequence:8")
    parser.add_argument("--image-mode", default="none", choices=IMAGE_MODES, help="none writes only JSONL; preview writes START/END plus first/last DATA PNGs; all writes every frame PNG.")
    parser.add_argument("--preview-count", default=5, type=int, help="Number of first DATA frames rendered when --image-mode preview is used.")
    parser.add_argument("--cell-px", default=32, type=int, help="Rendered PNG cell size in pixels.")
    args = parser.parse_args(argv)

    if args.gui:
        FrameMapperGui().run()
        return 0
    defaults = MappingConfig(args.rows, args.cols, args.clk_row, args.clk_col, args.symbol_mode, args.sync_mode, args.sequence_bits)
    if args.input_dir is not None:
        presets = parse_presets(args.presets or DEFAULT_PRESET, defaults)
        written, errors = write_batch(args.input_dir, args.out, presets, args.image_mode, args.preview_count, args.cell_px)
        print(f"Batch wrote {len(written)} mappings in {args.out}")
        if errors:
            print("Errors:")
            for error in errors:
                print(f"  {error}")
            return 1
        return 0
    if args.bitstream is None:
        parser.error("--bitstream is required unless --gui is used")
    metadata = args.metadata or default_metadata_path(args.bitstream)
    frames_path, manifest_path = write_frames(
        args.bitstream,
        metadata,
        args.out,
        args.rows,
        args.cols,
        (args.clk_row, args.clk_col),
        args.symbol_mode,
        args.sync_mode,
        args.sequence_bits,
        args.image_mode,
        args.preview_count,
        args.cell_px,
    )
    print(f"Wrote frames:   {frames_path}")
    print(f"Wrote manifest: {manifest_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
