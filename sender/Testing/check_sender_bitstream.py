#!/usr/bin/env python3
"""
Check CubeOCC sender bitstream outputs.

This verifies generated `.bin` files against their companion `.json` metadata
and the original input file.

Supported checks:
  - No ECC: packed bits match the original input bits.
  - Hamming / Extended Hamming: codewords decode back to the original input bits.

BCH decode is intentionally not included yet; BCH is a later comparison path.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from typing import Iterable, List, Sequence, Tuple


def is_power_of_two(value: int) -> bool:
    return value > 0 and (value & (value - 1)) == 0


def bytes_to_bits(data: bytes, bit_count: int | None = None) -> List[int]:
    bits: List[int] = []
    for byte in data:
        for shift in range(7, -1, -1):
            bits.append((byte >> shift) & 1)
            if bit_count is not None and len(bits) == bit_count:
                return bits
    return bits


def chunk_bits(bits: Sequence[int], width: int) -> Iterable[List[int]]:
    for start in range(0, len(bits), width):
        yield list(bits[start : start + width])


def hamming_data_positions(base_n: int) -> List[int]:
    return [pos for pos in range(1, base_n + 1) if not is_power_of_two(pos)]


def decode_hamming_codeword(codeword: Sequence[int], n: int, k: int) -> Tuple[List[int], bool, int]:
    if len(codeword) != n:
        raise ValueError(f"expected {n} coded bits, got {len(codeword)}")

    extended = n in (8, 16, 32)
    base_n = n - 1 if extended else n
    code = [0] + list(codeword[:base_n])

    syndrome = 0
    parity_pos = 1
    while parity_pos <= base_n:
        parity = 0
        for pos in range(1, base_n + 1):
            if pos & parity_pos:
                parity ^= code[pos]
        if parity:
            syndrome |= parity_pos
        parity_pos <<= 1

    corrected = False
    if 1 <= syndrome <= base_n:
        code[syndrome] ^= 1
        corrected = True

    # Extended Hamming global parity is useful for double-error detection, but
    # this checker is only proving clean generated files round-trip.
    data = [code[pos] for pos in hamming_data_positions(base_n)]
    if len(data) != k:
        raise ValueError(f"decoded {len(data)} data bits, expected {k}")
    return data, corrected, syndrome


def load_metadata(path: Path) -> dict:
    return json.loads(path.read_text(encoding="ascii"))


def check_no_ecc(original_bits: Sequence[int], encoded_bits: Sequence[int], meta: dict) -> Tuple[bool, str]:
    expected_bits = int(meta["input_bits"])
    output_bits = int(meta["output_bits"])
    if expected_bits != len(original_bits):
        return False, f"metadata input_bits={expected_bits}, original has {len(original_bits)} bits"
    if output_bits != len(encoded_bits):
        return False, f"metadata output_bits={output_bits}, encoded file has {len(encoded_bits)} bits"
    if list(original_bits) != list(encoded_bits):
        return False, "no-ECC encoded bits do not match original input bits"
    return True, "no-ECC bitstream matches original input"


def check_hamming(original_bits: Sequence[int], encoded_bits: Sequence[int], meta: dict) -> Tuple[bool, str]:
    n = int(meta["coded_bits_per_codeword"])
    k = int(meta["data_bits_per_codeword"])
    output_bits = int(meta["output_bits"])
    input_bits = int(meta["input_bits"])
    padding_bits = int(meta["padding_bits"])
    codewords = int(meta["codewords"])

    if input_bits != len(original_bits):
        return False, f"metadata input_bits={input_bits}, original has {len(original_bits)} bits"
    if output_bits != len(encoded_bits):
        return False, f"metadata output_bits={output_bits}, encoded file has {len(encoded_bits)} bits"
    if codewords * n != output_bits:
        return False, "metadata codewords and codeword size do not match output_bits"
    if (input_bits + padding_bits) != codewords * k:
        return False, "metadata padding does not match input_bits and codeword count"

    decoded: List[int] = []
    corrections = 0
    for codeword in chunk_bits(encoded_bits, n):
        data, corrected, _syndrome = decode_hamming_codeword(codeword, n, k)
        decoded.extend(data)
        if corrected:
            corrections += 1

    decoded = decoded[:input_bits]
    if decoded != list(original_bits):
        return False, "decoded Hamming bits do not match original input bits"
    if corrections:
        return False, f"clean generated bitstream unexpectedly needed {corrections} corrections"
    return True, f"Hamming bitstream decodes cleanly ({codewords} codewords)"


def check_bitstream(input_path: Path, bitstream_path: Path, metadata_path: Path) -> Tuple[bool, str]:
    original = input_path.read_bytes()
    meta = load_metadata(metadata_path)
    original_bits = bytes_to_bits(original, int(meta["input_bits"]))
    encoded_bits = bytes_to_bits(bitstream_path.read_bytes(), int(meta["output_bits"]))
    mode = str(meta["mode"])

    if mode == "No ECC":
        return check_no_ecc(original_bits, encoded_bits, meta)
    if "Hamming" in mode:
        return check_hamming(original_bits, encoded_bits, meta)
    return False, f"unsupported decode mode for this checker: {mode}"


def find_metadata_for_bitstream(bitstream_path: Path) -> Path:
    return bitstream_path.with_suffix(".json")


def main(argv: Sequence[str]) -> int:
    parser = argparse.ArgumentParser(description="Check CubeOCC sender .bin bitstreams against original input.")
    parser.add_argument("--input", required=True, type=Path, help="Original input file used by the sender generator.")
    parser.add_argument("--bitstream", required=True, type=Path, help="Generated .bin bitstream file.")
    parser.add_argument("--metadata", type=Path, help="Companion .json metadata file. Defaults to same stem as bitstream.")
    args = parser.parse_args(argv)

    metadata = args.metadata or find_metadata_for_bitstream(args.bitstream)
    ok, message = check_bitstream(args.input, args.bitstream, metadata)
    if ok:
        print(f"PASS: {message}")
        return 0
    print(f"FAIL: {message}")
    return 1


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
