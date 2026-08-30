---
project: CubeOCC
type: ecc-child-note
parent: 07_ECC_AND_METRICS
status: active
last_reviewed: 2026-08-30
---

# 07.02 — Sender Bitstream Testing

Parent: [[07_ECC_AND_METRICS]]

Related tool note: [[07_01_SENDER_BITSTREAM_TOOL]]

## Purpose

Verify that sender-generated `.bin` bitstream files and their related `.json` metadata can be decoded back to the original input.

This testing note is only for the bitstream/ECC stage. It does not test optical image-frame generation.

## Testing Folder

```text
sender/Testing/
```

Current checker:

```text
sender/Testing/check_sender_bitstream.py
```

The checker reads:

- original input file
- generated `.bin` bitstream
- companion `.json` metadata file

The metadata file is found automatically when it has the same stem as the `.bin` file.

## Supported Checks

Current supported checks:

- `no_ecc`: packed output bits must match the original input bits exactly
- `hamming_15_11`: encoded bits must decode back to the original input bits

Not yet supported:

- BCH decode/checking
- sequence-number validation
- shortened-code validation
- CRC/checksum validation

Those belong to later ECC comparison work.

## Generate V1 Test Bitstreams

```powershell
cd C:\Users\arshm\Desktop\CubeOCC
python sender\cubeocc_sender_gui.py --file input.txt sim\sender_bitstreams --modes v1 --format bin
```

V1 mode generates:

- `no_ecc`
- `hamming_15_11`

## Check No-ECC Output

```powershell
python sender\Testing\check_sender_bitstream.py --input input.txt --bitstream sim\sender_bitstreams\<generated>_no_ecc.bin
```

Expected result:

```text
PASS: no-ECC bitstream matches original input
```

## Check Hamming Output

```powershell
python sender\Testing\check_sender_bitstream.py --input input.txt --bitstream sim\sender_bitstreams\<generated>_hamming_15_11.bin
```

Expected result:

```text
PASS: Hamming bitstream decodes cleanly
```

## Current Result

### Small V1 Smoke Test

Last checked: 2026-08-30.

Test input:

```text
hello cubeocc sender
```

Generation command:

```powershell
python sender/cubeocc_sender_gui.py --file sim/sender_test_tmp/input.txt sim/sender_test_tmp/out --modes v1 --format bin
```

Checker results:

```text
Generated 5 files in sim\sender_test_tmp\out
PASS: no-ECC bitstream matches original input
PASS: Hamming bitstream decodes cleanly (15 codewords)
```

Status:

- `no_ecc` V1 check: PASS
- `hamming_15_11` V1 check: PASS

### Generated MP3 Bitstream Test

Last checked: 2026-08-30.

Generated set:

```text
Happier_Than_Ever_Shawn_mendes_Cover_20260830_125941
```

Manifest input name:

```text
Happier Than Ever(Shawn mendes Cover).mp3
```

Manifest summary:

- input bytes: `4,192,740`
- input bits: `33,541,920`
- generated with `--modes all`
- output format: `bin`

Reference used for checking:

```text
sim/sender_bitstreams/Happier_Than_Ever_Shawn_mendes_Cover_20260830_125941_no_ecc.bin
```

The original MP3 source file was not found inside the repository during this check, so the generated `no_ecc.bin` raw packed bitstream was used as the reference for Hamming decode validation.

Checker results:

```text
PASS: no-ECC bitstream matches original input
PASS: Hamming bitstream decodes cleanly (8385480 codewords)
PASS: Hamming bitstream decodes cleanly (3049266 codewords)
PASS: Hamming bitstream decodes cleanly (1290074 codewords)
PASS: Hamming bitstream decodes cleanly (8385480 codewords)
PASS: Hamming bitstream decodes cleanly (3049266 codewords)
PASS: Hamming bitstream decodes cleanly (1290074 codewords)
```

Status:

- `no_ecc`: PASS
- `hamming_7_4`: PASS
- `hamming_15_11`: PASS
- `hamming_31_26`: PASS
- `extended_hamming_8_4`: PASS
- `extended_hamming_16_11`: PASS
- `extended_hamming_32_26`: PASS
- BCH generated files: not decoded by the current checker yet

## Next Testing Step

Run the same checker against the original source file path when available, not only against `no_ecc.bin` as the recovered raw-bit reference.

Add BCH decode/check support later when BCH moves from generated comparison output to verified ECC path.
