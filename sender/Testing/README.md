# Sender Bitstream Testing

This folder contains checkers for the sender bitstream/ECC files and the sender V1 frame mapping files.

It validates generated bits and logical 8x8 frame mapping. It does not test final monitor image rendering yet.

## Generate Test Bitstreams

```powershell
cd C:\Users\arshm\Desktop\CubeOCC
python sender\cubeocc_sender_gui.py --file input.txt sim\sender_bitstreams --modes v1 --format bin
```

V1 mode creates:

- `no_ecc`
- `hamming_15_11`

Each generated `.bin` file has a companion `.json` metadata file.

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

## Notes

- The checker reads the `.json` metadata automatically when it has the same filename stem as the `.bin` file.
- Use `--metadata path\to\file.json` if the metadata file is somewhere else.
- BCH decode is not checked here yet because BCH is a later comparison path.

## Map And Check V1 Frames

Generate logical protocol frames from a sender `.bin` bitstream:

```powershell
python sender\cubeocc_frame_mapper.py --bitstream sim\sender_bitstreams\<generated>_hamming_15_11.bin --out sim\sender_frames
```

For experimental RGB symbols with a per-frame sequence number:

```powershell
python sender\cubeocc_frame_mapper.py --bitstream sim\sender_bitstreams\<generated>_hamming_15_11.bin --out sim\sender_frames --symbol-mode rgb --sync-mode clk_sequence --sequence-bits 8
```

Batch mode maps every `.bin` file in a folder that has a matching sender `.json` metadata file:

```powershell
python sender\cubeocc_frame_mapper.py --input-dir sim\sender_bitstreams --out sim\sender_frames_batch --presets "8x8:grayscale:clk:0;8x8:rgb:clk_sequence:8;16x16:grayscale:sequence:8" --image-mode preview
```

Check that the frames match `03_FRAME_AND_LINK_PROTOCOL.md` and reconstruct back to the source bitstream:

```powershell
python sender\Testing\check_frame_mapping.py --bitstream sim\sender_bitstreams\<generated>_hamming_15_11.bin --frames sim\sender_frames\<generated>_hamming_15_11_8x8_grayscale_clk_frames.jsonl
```

Expected result:

```text
PASS: frame mapping matches source bitstream
```
