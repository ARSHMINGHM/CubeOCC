---
project: CubeOCC
type: ecc-child-note
parent: 07_ECC_AND_METRICS
status: active
last_reviewed: 2026-08-29
---

# 07.01 — Sender Bitstream Tool

Parent: [[07_ECC_AND_METRICS]]

## Purpose

Generate sender-side bitstreams from either typed text or an input file.

The tool creates:

- no-ECC raw bitstream
- V1 Hamming baseline bitstream
- optional Hamming / Extended Hamming / BCH comparison bitstreams from [[07_ECC_AND_METRICS]]

This tool is for the bitstream and ECC stage only. It does not generate optical image frames.

Downstream sender-side steps:

- [[07_03_SENDER_FRAME_MAPPING]] maps generated `.bin` bitstreams into protocol frames and optional PNG images.
- [[07_04_SENDER_FRAME_PLAYER]] previews generated PNG frame folders full screen like a sender display.
- [[07_05_FULL_FRAME_GENERATION_WALKTHROUGH]] shows the complete V1 example flow.

## Python Tool

```text
sender/cubeocc_sender_gui.py
```

## Run GUI

From PowerShell:

```powershell
cd C:\Users\arshm\Desktop\CubeOCC
python sender\cubeocc_sender_gui.py --gui
```

In the GUI, for normal V1 work use:

- ECC modes: `v1`
- Output format: `bin`

## Fast V1 CLI

For large files, such as a 12 MB input, use:

```powershell
cd C:\Users\arshm\Desktop\CubeOCC
python sender\cubeocc_sender_gui.py --file input.bin sim\sender_bitstreams --modes v1 --format bin
```

`--modes v1` generates:

- `no_ecc`
- `hamming_15_11`

`--format bin` writes packed binary output, which is faster and smaller than text `.bits` output.

## Other CLI Examples

Typed text:

```powershell
python sender\cubeocc_sender_gui.py --text "hello cubeocc" sim\sender_bitstreams --modes v1 --format bin
```

Only raw/no-ECC:

```powershell
python sender\cubeocc_sender_gui.py --file input.bin sim\sender_bitstreams --modes no_ecc --format bin
```

All Hamming candidates:

```powershell
python sender\cubeocc_sender_gui.py --file input.bin sim\sender_bitstreams --modes hamming --format bin
```

All ECC candidates from the ECC note:

```powershell
python sender\cubeocc_sender_gui.py --file input.bin sim\sender_bitstreams --modes all --format bin
```

## Output Files

Each generated mode writes:

- `<input>_<timestamp>_<mode>.bin` for packed bitstream output
- `<input>_<timestamp>_<mode>.json` for metadata

Each generation also writes:

- `<input>_<timestamp>_manifest.json`

The metadata records:

- ECC mode
- input bit count
- output bit count
- data bits per codeword
- coded bits per codeword
- padding bits
- codeword count

## Speed Notes

Recommended for large files:

```powershell
--modes v1 --format bin
```

Avoid this for large files unless doing a full comparison:

```powershell
--modes all --format bits
```

Text `.bits` files are useful for inspection, but they are much larger and slower than packed `.bin` files.
