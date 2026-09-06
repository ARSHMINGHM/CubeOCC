#!/usr/bin/env python3
"""
CubeOCC sender bitstream generator.

Inputs:
  - typed text, or
  - a dragged/dropped or browsed file

Outputs:
  - raw text bitstream with no ECC
  - Hamming and BCH encoded bitstreams matching CubeOCC_Obsidian_Vault/07_ECC_AND_METRICS.md

The generated files are intended for the sender-side pipeline before optical
frame generation. BCH encoding uses narrow-sense primitive binary BCH codes.
"""

from __future__ import annotations

import functools
import json
import re
import sys
import time
import tkinter as tk
from dataclasses import dataclass
from pathlib import Path
from tkinter import filedialog, messagebox, ttk
from typing import Iterable, List, Optional, Sequence, Tuple


try:
    from tkinterdnd2 import DND_FILES, TkinterDnD  # type: ignore

    DND_AVAILABLE = True
except Exception:
    DND_AVAILABLE = False
    DND_FILES = None
    TkinterDnD = None


REPO_ROOT = Path(__file__).resolve().parents[1]
DEFAULT_OUTPUT_DIR = REPO_ROOT / "sim" / "sender_bitstreams"


@dataclass(frozen=True)
class EccMode:
    name: str
    slug: str
    scheme: str
    n: int
    k: int
    dmin: Optional[int] = None
    extended: bool = False


ECC_MODES: Tuple[EccMode, ...] = (
    EccMode("No ECC", "no_ecc", "none", 0, 0),
    EccMode("Hamming (7,4)", "hamming_7_4", "hamming", 7, 4),
    EccMode("Hamming (15,11)", "hamming_15_11", "hamming", 15, 11),
    EccMode("Hamming (31,26)", "hamming_31_26", "hamming", 31, 26),
    EccMode("Extended Hamming (8,4)", "extended_hamming_8_4", "hamming", 8, 4, extended=True),
    EccMode("Extended Hamming (16,11)", "extended_hamming_16_11", "hamming", 16, 11, extended=True),
    EccMode("Extended Hamming (32,26)", "extended_hamming_32_26", "hamming", 32, 26, extended=True),
    EccMode("BCH (15,7,5)", "bch_15_7_5", "bch", 15, 7, 5),
    EccMode("BCH (15,5,7)", "bch_15_5_7", "bch", 15, 5, 7),
    EccMode("BCH (31,21,5)", "bch_31_21_5", "bch", 31, 21, 5),
    EccMode("BCH (31,16,7)", "bch_31_16_7", "bch", 31, 16, 7),
    EccMode("BCH (31,11,11)", "bch_31_11_11", "bch", 31, 11, 11),
)

MODE_SETS = ("v1", "fast", "all", "no_ecc", "hamming", "bch")


def bytes_to_bits(data: bytes) -> List[int]:
    bits: List[int] = []
    for byte in data:
        for shift in range(7, -1, -1):
            bits.append((byte >> shift) & 1)
    return bits


def bits_to_string(bits: Sequence[int], group: int = 8) -> str:
    chars: List[str] = []
    for idx, bit in enumerate(bits):
        if idx and group > 0 and idx % group == 0:
            chars.append("_")
        chars.append("1" if bit else "0")
    return "".join(chars)


def chunk_bits(bits: Sequence[int], width: int) -> Iterable[List[int]]:
    for start in range(0, len(bits), width):
        block = list(bits[start : start + width])
        if len(block) < width:
            block.extend([0] * (width - len(block)))
        yield block


def is_power_of_two(value: int) -> bool:
    return value > 0 and (value & (value - 1)) == 0


def encode_hamming_block(data_bits: Sequence[int], mode: EccMode) -> List[int]:
    if len(data_bits) != mode.k:
        raise ValueError(f"{mode.name} needs exactly {mode.k} data bits")

    base_n = mode.n - 1 if mode.extended else mode.n
    code = [0] * (base_n + 1)  # 1-based indexing.
    data_iter = iter(data_bits)

    for pos in range(1, base_n + 1):
        if not is_power_of_two(pos):
            code[pos] = next(data_iter)

    parity_pos = 1
    while parity_pos <= base_n:
        parity = 0
        for pos in range(1, base_n + 1):
            if pos & parity_pos:
                parity ^= code[pos]
        code[parity_pos] = parity
        parity_pos <<= 1

    out = code[1:]
    if mode.extended:
        out.append(sum(out) & 1)
    return out


def poly_trim(poly: int) -> int:
    return poly


def poly_degree(poly: int) -> int:
    return poly.bit_length() - 1


def poly_mul(a: int, b: int) -> int:
    out = 0
    while b:
        if b & 1:
            out ^= a
        a <<= 1
        b >>= 1
    return out


def poly_divmod(dividend: int, divisor: int) -> Tuple[int, int]:
    if divisor == 0:
        raise ZeroDivisionError("polynomial divisor is zero")

    quotient = 0
    remainder = dividend
    divisor_degree = poly_degree(divisor)

    while remainder and poly_degree(remainder) >= divisor_degree:
        shift = poly_degree(remainder) - divisor_degree
        quotient ^= 1 << shift
        remainder ^= divisor << shift

    return quotient, remainder


def gf_tables(m: int, primitive_poly: int) -> Tuple[List[int], List[int]]:
    n = (1 << m) - 1
    exp = [0] * (2 * n)
    log = [0] * (1 << m)
    x = 1

    for i in range(n):
        exp[i] = x
        log[x] = i
        x <<= 1
        if x & (1 << m):
            x ^= primitive_poly

    for i in range(n, 2 * n):
        exp[i] = exp[i - n]

    return exp, log


def gf_mul(a: int, b: int, exp: Sequence[int], log: Sequence[int], n: int) -> int:
    if a == 0 or b == 0:
        return 0
    return exp[(log[a] + log[b]) % n]


def gf_pow_alpha(power: int, exp: Sequence[int], n: int) -> int:
    return exp[power % n]


def minimal_polynomial(exponent: int, m: int, primitive_poly: int) -> int:
    n = (1 << m) - 1
    exp, log = gf_tables(m, primitive_poly)
    conjugates = []
    seen = set()
    value = exponent % n

    while value not in seen:
        seen.add(value)
        conjugates.append(value)
        value = (value * 2) % n

    # Polynomial over GF(2^m), low coefficient first.
    coeffs = [1]
    for conj in conjugates:
        root = gf_pow_alpha(conj, exp, n)
        next_coeffs = [0] * (len(coeffs) + 1)
        for idx, coeff in enumerate(coeffs):
            # Multiply by (x + root). In characteristic 2, + and - are equal.
            next_coeffs[idx] ^= gf_mul(coeff, root, exp, log, n)
            next_coeffs[idx + 1] ^= coeff
        coeffs = next_coeffs

    result = 0
    for idx, coeff in enumerate(coeffs):
        if coeff not in (0, 1):
            raise ValueError("minimal polynomial did not collapse to GF(2)")
        if coeff:
            result |= 1 << idx
    return poly_trim(result)


def bch_generator_poly(n: int, dmin: int) -> int:
    if n == 15:
        m = 4
        primitive_poly = 0b10011  # x^4 + x + 1
    elif n == 31:
        m = 5
        primitive_poly = 0b100101  # x^5 + x^2 + 1
    else:
        raise ValueError(f"unsupported BCH length {n}")

    generator = 1
    for exponent in range(1, dmin):
        min_poly = minimal_polynomial(exponent, m, primitive_poly)
        _, remainder = poly_divmod(generator, min_poly)
        if remainder != 0:
            generator = poly_mul(generator, min_poly)

    return generator


bch_generator_poly = functools.lru_cache(maxsize=None)(bch_generator_poly)


def bits_to_int(bits: Sequence[int]) -> int:
    value = 0
    for bit in bits:
        value = (value << 1) | (bit & 1)
    return value


def int_to_bits(value: int, width: int) -> List[int]:
    return [(value >> shift) & 1 for shift in range(width - 1, -1, -1)]


def encode_bch_block(data_bits: Sequence[int], mode: EccMode) -> List[int]:
    if mode.dmin is None:
        raise ValueError(f"{mode.name} is missing dmin")
    if len(data_bits) != mode.k:
        raise ValueError(f"{mode.name} needs exactly {mode.k} data bits")

    generator = bch_generator_poly(mode.n, mode.dmin)
    parity_bits = mode.n - mode.k
    message = bits_to_int(data_bits)
    shifted = message << parity_bits
    _, remainder = poly_divmod(shifted, generator)
    codeword = shifted ^ remainder
    return int_to_bits(codeword, mode.n)


def encode_bits(bits: Sequence[int], mode: EccMode) -> Tuple[List[int], dict]:
    if mode.scheme == "none":
        return list(bits), {
            "mode": mode.name,
            "input_bits": len(bits),
            "output_bits": len(bits),
            "data_bits_per_codeword": None,
            "coded_bits_per_codeword": None,
            "padding_bits": 0,
            "codewords": 0,
        }

    output: List[int] = []
    for block in chunk_bits(bits, mode.k):
        if mode.scheme == "hamming":
            output.extend(encode_hamming_block(block, mode))
        elif mode.scheme == "bch":
            output.extend(encode_bch_block(block, mode))
        else:
            raise ValueError(f"unknown ECC scheme {mode.scheme}")

    padding = (mode.k - (len(bits) % mode.k)) % mode.k
    codewords = 0 if len(bits) == 0 else (len(bits) + padding) // mode.k
    return output, {
        "mode": mode.name,
        "input_bits": len(bits),
        "output_bits": len(output),
        "data_bits_per_codeword": mode.k,
        "coded_bits_per_codeword": mode.n,
        "padding_bits": padding,
        "codewords": codewords,
    }


def safe_stem(name: str) -> str:
    stem = Path(name).stem if name else "typed_text"
    stem = re.sub(r"[^A-Za-z0-9_.-]+", "_", stem).strip("._-")
    return stem or "typed_text"


def read_input_file(path: Path) -> bytes:
    return path.read_bytes()


class BitReader:
    def __init__(self, data: bytes) -> None:
        self.data = data
        self.byte_index = 0
        self.bit_index = 0

    def read_block_int(self, width: int) -> Tuple[int, int]:
        value = 0
        actual = 0

        while actual < width and self.byte_index < len(self.data):
            byte = self.data[self.byte_index]
            bit = (byte >> (7 - self.bit_index)) & 1
            value = (value << 1) | bit
            actual += 1

            self.bit_index += 1
            if self.bit_index == 8:
                self.bit_index = 0
                self.byte_index += 1

        if actual < width:
            value <<= width - actual
        return value, actual


class BitTextWriter:
    def __init__(self, path: Path, group: int = 8) -> None:
        self.file = path.open("w", encoding="ascii", newline="\n")
        self.group = group
        self.count = 0
        self.pending: List[str] = []

    def write_int(self, value: int, width: int) -> None:
        for shift in range(width - 1, -1, -1):
            if self.group > 0 and self.count and self.count % self.group == 0:
                self.pending.append("_")
            self.pending.append("1" if ((value >> shift) & 1) else "0")
            self.count += 1
            if len(self.pending) >= 8192:
                self.flush()

    def flush(self) -> None:
        if self.pending:
            self.file.write("".join(self.pending))
            self.pending.clear()

    def close(self) -> None:
        self.flush()
        self.file.write("\n")
        self.file.close()

    def __enter__(self) -> "BitTextWriter":
        return self

    def __exit__(self, exc_type: object, exc: object, tb: object) -> None:
        self.close()


class BitBinaryWriter:
    def __init__(self, path: Path) -> None:
        self.file = path.open("wb")
        self.current_byte = 0
        self.bit_count = 0
        self.pending = bytearray()
        self.total_bits = 0

    def write_int(self, value: int, width: int) -> None:
        for shift in range(width - 1, -1, -1):
            self.current_byte = (self.current_byte << 1) | ((value >> shift) & 1)
            self.bit_count += 1
            self.total_bits += 1
            if self.bit_count == 8:
                self.pending.append(self.current_byte)
                self.current_byte = 0
                self.bit_count = 0
                if len(self.pending) >= 8192:
                    self.flush()

    def flush(self) -> None:
        if self.pending:
            self.file.write(self.pending)
            self.pending.clear()

    def close(self) -> None:
        if self.bit_count:
            self.pending.append(self.current_byte << (8 - self.bit_count))
            self.current_byte = 0
            self.bit_count = 0
        self.flush()
        self.file.close()

    def __enter__(self) -> "BitBinaryWriter":
        return self

    def __exit__(self, exc_type: object, exc: object, tb: object) -> None:
        self.close()


def make_bit_writer(path: Path, output_format: str, group_bits: bool):
    if output_format == "bits":
        return BitTextWriter(path, 8 if group_bits else 0)
    if output_format == "bin":
        return BitBinaryWriter(path)
    raise ValueError(f"unsupported output format: {output_format}")


def encode_hamming_int(data_value: int, mode: EccMode) -> int:
    data_bits = int_to_bits(data_value, mode.k)
    return bits_to_int(encode_hamming_block(data_bits, mode))


def encode_bch_int(data_value: int, mode: EccMode) -> int:
    if mode.dmin is None:
        raise ValueError(f"{mode.name} is missing dmin")

    generator = bch_generator_poly(mode.n, mode.dmin)
    parity_bits = mode.n - mode.k
    shifted = data_value << parity_bits
    _, remainder = poly_divmod(shifted, generator)
    return shifted ^ remainder


@functools.lru_cache(maxsize=None)
def encoding_table(mode: EccMode) -> Optional[Tuple[int, ...]]:
    if mode.scheme == "none" or mode.k > 16:
        return None

    values: List[int] = []
    for data_value in range(1 << mode.k):
        if mode.scheme == "hamming":
            values.append(encode_hamming_int(data_value, mode))
        elif mode.scheme == "bch":
            values.append(encode_bch_int(data_value, mode))
        else:
            return None
    return tuple(values)


def write_no_ecc_stream(input_bytes: bytes, bit_file: Path, group_bits: bool, output_format: str) -> dict:
    with make_bit_writer(bit_file, output_format, group_bits) as writer:
        for byte in input_bytes:
            writer.write_int(byte, 8)

    input_bits = len(input_bytes) * 8
    return {
        "mode": "No ECC",
        "input_bits": input_bits,
        "output_bits": input_bits,
        "data_bits_per_codeword": None,
        "coded_bits_per_codeword": None,
        "padding_bits": 0,
        "codewords": 0,
        "output_format": output_format,
    }


def write_ecc_stream(input_bytes: bytes, mode: EccMode, bit_file: Path, group_bits: bool, output_format: str) -> dict:
    input_bits = len(input_bytes) * 8
    padding = (mode.k - (input_bits % mode.k)) % mode.k
    codewords = 0 if input_bits == 0 else (input_bits + padding) // mode.k
    reader = BitReader(input_bytes)
    table = encoding_table(mode)

    with make_bit_writer(bit_file, output_format, group_bits) as writer:
        for _ in range(codewords):
            data_value, _actual = reader.read_block_int(mode.k)
            if table is not None:
                encoded = table[data_value]
            elif mode.scheme == "hamming":
                encoded = encode_hamming_int(data_value, mode)
            elif mode.scheme == "bch":
                encoded = encode_bch_int(data_value, mode)
            else:
                raise ValueError(f"unknown ECC scheme {mode.scheme}")
            writer.write_int(encoded, mode.n)

    return {
        "mode": mode.name,
        "input_bits": input_bits,
        "output_bits": codewords * mode.n,
        "data_bits_per_codeword": mode.k,
        "coded_bits_per_codeword": mode.n,
        "padding_bits": padding,
        "codewords": codewords,
        "output_format": output_format,
    }


def select_modes(mode_selector: str) -> Tuple[EccMode, ...]:
    selected = mode_selector.strip().lower()
    by_slug = {mode.slug: mode for mode in ECC_MODES}

    if selected == "all":
        return ECC_MODES
    if selected == "v1":
        return tuple(mode for mode in ECC_MODES if mode.slug in {"no_ecc", "hamming_15_11"})
    if selected == "fast":
        return tuple(mode for mode in ECC_MODES if mode.slug in {"no_ecc", "hamming_7_4", "hamming_15_11", "extended_hamming_8_4", "extended_hamming_16_11"})
    if selected == "no_ecc":
        return (by_slug["no_ecc"],)
    if selected == "hamming":
        return tuple(mode for mode in ECC_MODES if mode.scheme in {"none", "hamming"})
    if selected == "bch":
        return tuple(mode for mode in ECC_MODES if mode.scheme in {"none", "bch"})

    slugs = [item.strip() for item in selected.split(",") if item.strip()]
    if slugs:
        unknown = [slug for slug in slugs if slug not in by_slug]
        if unknown:
            raise ValueError(f"unknown ECC mode(s): {', '.join(unknown)}")
        return tuple(by_slug[slug] for slug in slugs)

    raise ValueError("no ECC modes selected")


def write_mode_outputs(
    input_name: str,
    input_bytes: bytes,
    out_dir: Path,
    group_bits: bool = True,
    mode_selector: str = "all",
    output_format: str = "bits",
) -> List[Path]:
    out_dir.mkdir(parents=True, exist_ok=True)
    input_bit_count = len(input_bytes) * 8
    timestamp = time.strftime("%Y%m%d_%H%M%S")
    prefix = f"{safe_stem(input_name)}_{timestamp}"
    written: List[Path] = []
    modes = select_modes(mode_selector)
    output_format = output_format.lower()
    suffix = ".bits" if output_format == "bits" else ".bin"

    manifest = {
        "input_name": input_name,
        "input_bytes": len(input_bytes),
        "input_bits": input_bit_count,
        "created_at_local": timestamp,
        "source_note": "CubeOCC_Obsidian_Vault/07_ECC_AND_METRICS.md",
        "mode_selector": mode_selector,
        "output_format": output_format,
        "files": [],
    }

    for mode in modes:
        bit_file = out_dir / f"{prefix}_{mode.slug}{suffix}"
        json_file = out_dir / f"{prefix}_{mode.slug}.json"

        if mode.scheme == "none":
            meta = write_no_ecc_stream(input_bytes, bit_file, group_bits, output_format)
        else:
            meta = write_ecc_stream(input_bytes, mode, bit_file, group_bits, output_format)

        json_file.write_text(json.dumps(meta, indent=2) + "\n", encoding="ascii")

        manifest["files"].append(
            {
                "mode": mode.name,
                "bitstream": bit_file.name,
                "metadata": json_file.name,
                **meta,
            }
        )
        written.extend([bit_file, json_file])

    manifest_file = out_dir / f"{prefix}_manifest.json"
    manifest_file.write_text(json.dumps(manifest, indent=2) + "\n", encoding="ascii")
    written.append(manifest_file)
    return written


class SenderGui:
    def __init__(self, root: tk.Tk) -> None:
        self.root = root
        self.root.title("CubeOCC Sender Bitstream Generator")
        self.input_file: Optional[Path] = None
        self.output_dir = tk.StringVar(value=str(DEFAULT_OUTPUT_DIR))
        self.mode_selector = tk.StringVar(value="v1")
        self.output_format = tk.StringVar(value="bin")
        self.status = tk.StringVar(value="Type text or choose a file, then generate bitstreams.")

        self._build_ui()

    def _build_ui(self) -> None:
        frame = ttk.Frame(self.root, padding=12)
        frame.grid(row=0, column=0, sticky="nsew")
        self.root.columnconfigure(0, weight=1)
        self.root.rowconfigure(0, weight=1)
        frame.columnconfigure(0, weight=1)
        frame.rowconfigure(2, weight=1)

        ttk.Label(frame, text="Typed text input").grid(row=0, column=0, sticky="w")
        self.text = tk.Text(frame, height=8, wrap="word")
        self.text.grid(row=1, column=0, columnspan=4, sticky="nsew", pady=(4, 12))

        drop_text = "Drop a file here" if DND_AVAILABLE else "File input"
        self.drop_label = ttk.Label(frame, text=drop_text, relief="groove", padding=18, anchor="center")
        self.drop_label.grid(row=2, column=0, columnspan=4, sticky="nsew", pady=(0, 12))

        if DND_AVAILABLE:
            self.drop_label.drop_target_register(DND_FILES)  # type: ignore[attr-defined]
            self.drop_label.dnd_bind("<<Drop>>", self._handle_drop)  # type: ignore[attr-defined]

        ttk.Button(frame, text="Choose File", command=self.choose_file).grid(row=3, column=0, sticky="w")
        ttk.Button(frame, text="Clear File", command=self.clear_file).grid(row=3, column=1, sticky="w", padx=(8, 0))

        ttk.Label(frame, text="Output folder").grid(row=4, column=0, sticky="w", pady=(12, 0))
        ttk.Entry(frame, textvariable=self.output_dir).grid(row=5, column=0, columnspan=3, sticky="ew", pady=(4, 0))
        ttk.Button(frame, text="Browse", command=self.choose_output_dir).grid(row=5, column=3, sticky="e", padx=(8, 0), pady=(4, 0))

        ttk.Label(frame, text="ECC modes").grid(row=6, column=0, sticky="w", pady=(12, 0))
        ttk.Combobox(frame, textvariable=self.mode_selector, values=MODE_SETS, state="readonly", width=18).grid(row=7, column=0, sticky="w", pady=(4, 0))
        ttk.Label(frame, text="Output format").grid(row=6, column=1, sticky="w", padx=(8, 0), pady=(12, 0))
        ttk.Combobox(frame, textvariable=self.output_format, values=("bin", "bits"), state="readonly", width=10).grid(row=7, column=1, sticky="w", padx=(8, 0), pady=(4, 0))

        ttk.Button(frame, text="Generate Bitstreams", command=self.generate).grid(row=8, column=0, sticky="w", pady=(12, 0))
        ttk.Label(frame, textvariable=self.status, foreground="#16537e").grid(row=9, column=0, columnspan=4, sticky="w", pady=(12, 0))

        modes = ", ".join(mode.slug for mode in ECC_MODES)
        ttk.Label(frame, text=f"Available mode slugs: {modes}", wraplength=760).grid(row=10, column=0, columnspan=4, sticky="w", pady=(8, 0))

    def _handle_drop(self, event: object) -> None:
        data = getattr(event, "data", "")
        paths = self.root.tk.splitlist(data)
        if paths:
            self.set_input_file(Path(paths[0]))

    def set_input_file(self, path: Path) -> None:
        self.input_file = path
        self.drop_label.configure(text=f"Selected file: {path}")
        self.status.set("File selected. File input will be used instead of typed text.")

    def choose_file(self) -> None:
        selected = filedialog.askopenfilename(title="Choose input file")
        if selected:
            self.set_input_file(Path(selected))

    def clear_file(self) -> None:
        self.input_file = None
        self.drop_label.configure(text="Drop a file here" if DND_AVAILABLE else "File input")
        self.status.set("File cleared. Typed text will be used.")

    def choose_output_dir(self) -> None:
        selected = filedialog.askdirectory(title="Choose output folder")
        if selected:
            self.output_dir.set(selected)

    def generate(self) -> None:
        try:
            if self.input_file:
                input_name = self.input_file.name
                input_bytes = read_input_file(self.input_file)
            else:
                text_value = self.text.get("1.0", "end-1c")
                if not text_value:
                    messagebox.showwarning("No input", "Type text or choose a file first.")
                    return
                input_name = "typed_text"
                input_bytes = text_value.encode("utf-8")

            written = write_mode_outputs(
                input_name,
                input_bytes,
                Path(self.output_dir.get()),
                mode_selector=self.mode_selector.get(),
                output_format=self.output_format.get(),
            )
            self.status.set(f"Generated {len(written)} files in {self.output_dir.get()}")
            messagebox.showinfo("Done", f"Generated {len(written)} files.")
        except Exception as exc:
            messagebox.showerror("Generation failed", str(exc))
            self.status.set(f"Error: {exc}")


def run_cli(argv: Sequence[str]) -> int:
    if len(argv) < 2:
        print("Usage:")
        print("  python sender/cubeocc_sender_gui.py --gui")
        print("  python sender/cubeocc_sender_gui.py --text \"hello\" [output_dir] [--modes v1|fast|all|hamming|bch|no_ecc|slug,...] [--format bin|bits]")
        print("  python sender/cubeocc_sender_gui.py --file input.bin [output_dir] [--modes v1|fast|all|hamming|bch|no_ecc|slug,...] [--format bin|bits]")
        return 2

    command = argv[1]
    output_dir = DEFAULT_OUTPUT_DIR
    mode_selector = "v1"
    output_format = "bin"

    def parse_extra(start_index: int) -> None:
        nonlocal output_dir, mode_selector, output_format
        idx = start_index
        if idx < len(argv) and not argv[idx].startswith("--"):
            output_dir = Path(argv[idx])
            idx += 1
        while idx < len(argv):
            option = argv[idx]
            if option == "--modes" and idx + 1 < len(argv):
                mode_selector = argv[idx + 1]
                idx += 2
            elif option == "--format" and idx + 1 < len(argv):
                output_format = argv[idx + 1].lower()
                idx += 2
            else:
                raise ValueError(f"unknown or incomplete option: {option}")

    if command == "--gui":
        main()
        return 0
    if command == "--text" and len(argv) >= 3:
        parse_extra(3)
        written = write_mode_outputs("typed_text", argv[2].encode("utf-8"), output_dir, mode_selector=mode_selector, output_format=output_format)
        print(f"Generated {len(written)} files in {output_dir}")
        return 0
    if command == "--file" and len(argv) >= 3:
        parse_extra(3)
        path = Path(argv[2])
        written = write_mode_outputs(path.name, read_input_file(path), output_dir, mode_selector=mode_selector, output_format=output_format)
        print(f"Generated {len(written)} files in {output_dir}")
        return 0

    print(f"Unknown or incomplete command: {command}")
    return 2


def main() -> None:
    if DND_AVAILABLE and TkinterDnD is not None:
        root = TkinterDnD.Tk()
    else:
        root = tk.Tk()
    SenderGui(root)
    root.minsize(820, 520)
    root.mainloop()


if __name__ == "__main__":
    raise SystemExit(run_cli(sys.argv))
