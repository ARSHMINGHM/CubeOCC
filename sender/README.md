# CubeOCC Sender Bitstream Generator

`cubeocc_sender_gui.py` creates sender-side bitstreams from either typed text or a file.

It generates one output for each mode documented in `CubeOCC_Obsidian_Vault/07_ECC_AND_METRICS.md`:

- `no_ecc`
- `hamming_7_4`
- `hamming_15_11`
- `hamming_31_26`
- `extended_hamming_8_4`
- `extended_hamming_16_11`
- `extended_hamming_32_26`
- `bch_15_7_5`
- `bch_15_5_7`
- `bch_31_21_5`
- `bch_31_16_7`
- `bch_31_11_11`

## GUI

```powershell
cd C:\Users\arshm\Desktop\CubeOCC
python sender\cubeocc_sender_gui.py --gui
```

Use either:

- typed text in the text box
- `Choose File`
- drag and drop, if `tkinterdnd2` is installed

The default output folder is:

```text
sim/sender_bitstreams/
```

For large files, keep the GUI defaults:

- ECC modes: `v1`
- Output format: `bin`

That generates only `no_ecc` and `hamming_15_11`, which matches the V1 baseline direction and avoids every expensive BCH candidate unless you actually need the full ECC comparison.

## CLI Test

```powershell
cd C:\Users\arshm\Desktop\CubeOCC
python sender\cubeocc_sender_gui.py --text "hello cubeocc" sim\sender_bitstreams --modes v1 --format bin
```

For a file:

```powershell
python sender\cubeocc_sender_gui.py --file input.txt sim\sender_bitstreams --modes v1 --format bin
```

Each ECC mode writes:

- `.bin` file: packed encoded bits, fastest and smallest
- `.bits` file: encoded bitstream text when `--format bits` is selected
- `.json` file: metadata, including input bits, output bits, padding bits, and codeword count

Each generation also writes one manifest:

```text
<input>_<timestamp>_manifest.json
```

## Notes

- Text input is encoded as UTF-8 bytes, then converted MSB-first to bits.
- File input is read as raw bytes.
- Default CLI/GUI behavior uses `--modes v1 --format bin`.
- `--modes all --format bits` is the slowest option and creates very large files.
- Hamming and Extended Hamming are implemented directly.
- BCH modes are narrow-sense primitive binary BCH encoders for the candidate codes in the Obsidian ECC note.

## Mode Selection

```powershell
--modes no_ecc
--modes v1
--modes fast
--modes hamming
--modes bch
--modes all
--modes hamming_15_11,bch_15_7_5
```

Recommended for a large file such as 12 MB:

```powershell
python sender\cubeocc_sender_gui.py --file big_input.bin sim\sender_bitstreams --modes v1 --format bin
```

Fast comparison set, still bigger than V1:

```powershell
python sender\cubeocc_sender_gui.py --file big_input.bin sim\sender_bitstreams --modes fast --format bin
```

Full comparison, much slower:

```powershell
python sender\cubeocc_sender_gui.py --file big_input.bin sim\sender_bitstreams --modes all --format bin
```
