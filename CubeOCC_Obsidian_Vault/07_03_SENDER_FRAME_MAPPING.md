---
project: CubeOCC
type: sender
status: implementation
last_reviewed: 2026-08-30
---

# Sender Frame Mapping

This note tracks the sender-side mapping step after the bitstream/ECC generator.

Parent protocol:

- [[03_FRAME_AND_LINK_PROTOCOL]]

Related sender notes:

- [[07_01_SENDER_BITSTREAM_TOOL]]
- [[07_02_SENDER_BITSTREAM_TESTING]]
- [[07_04_SENDER_FRAME_PLAYER]]
- [[07_05_FULL_FRAME_GENERATION_WALKTHROUGH]]

## Purpose

Convert a generated sender `.bin` bitstream into logical optical frame data that matches the CubeOCC frame protocol.

The mapper is not doing image rendering yet. It creates the logical 8x8 cell frames that the later sender display/image stage can render on the monitor.

## V1 Mapping Rules

V1 uses grayscale/on-off symbols:

```text
8x8 = 64 cells
4 corner marker cells
1 CLK/toggle cell
59 payload/ECC cells
```

Frame order:

1. START frame: all 64 cells white/on.
2. DATA frames: TL/TR/BL/BR are white, CLK toggles on each new DATA frame, and the 59 remaining cells carry one coded bit each.
3. END frame: TL/TR/BL white, BR off, CLK off, and all payload cells off.

The default CLK cell in the current tool is row 0, column 1. This is allowed by the protocol because the CLK location is configurable and not architecturally important.

Payload cells are filled row-major, skipping the four corners and the CLK cell. The last DATA frame is zero-padded if the bitstream does not end exactly on a 59-bit boundary.

## Experimental Mapping Options

The default settings are the confirmed V1 protocol. The tool also exposes options for later experiments:

- grid size: choose rows and columns, such as 8x8, 16x16, 32x32, or 64x64
- symbol mode: `grayscale` uses 1 bit per payload cell, `rgb` uses 3 bits per payload cell as the V1.5 RGB mapping
- sync mode: `clk`, `sequence`, or `clk_sequence`
- sequence bits: reserve the first N payload bits in each DATA frame for a frame sequence number

When sequence mode is enabled, the sequence number increments once per DATA frame and wraps modulo the selected bit width. This is for later V2-style missed/duplicated frame detection. It is not required for the V1 baseline.

## Tool

```powershell
cd C:\Users\arshm\Desktop\CubeOCC
python sender\cubeocc_frame_mapper.py --bitstream sim\sender_bitstreams\<generated>_hamming_15_11.bin --out sim\sender_frames
```

GUI:

```powershell
python sender\cubeocc_frame_mapper.py --gui
```

GUI workflow:

1. Select `One bitstream file` or `Whole folder batch`.
2. Choose the `.bin` file, or choose the folder that contains many `.bin` / `.json` pairs.
3. Choose the output folder.
4. Use the preset buttons for common mappings:
   - `V1 8x8 Grayscale`
   - `RGB + CLK + Seq`
   - `16x16 Seq`
5. Or change the custom settings and click `Add Current Settings`.
6. Choose image mode:
   - `preview` for normal testing
   - `all` only when every frame should become a PNG
7. Click `Generate Frames`.

Batch folder mapping:

```powershell
python sender\cubeocc_frame_mapper.py --input-dir sim\sender_bitstreams --out sim\sender_frames_batch --presets "8x8:grayscale:clk:0;8x8:rgb:clk_sequence:8;16x16:grayscale:sequence:8" --image-mode preview
```

The batch mode finds every `.bin` file in the selected folder that has a matching sender `.json` metadata file.

Batch output is grouped by mapping preset:

```text
sim/sender_frames_batch/
  8x8_grayscale_clk/
  8x8_rgb_clk_sequence_seq8/
  16x16_grayscale_sequence_seq8/
  batch_manifest.json
```

Image output options:

- `--image-mode none`: write only JSONL logical frames and manifests
- `--image-mode preview`: write START, END, first DATA frames, and last DATA frame as PNG previews
- `--image-mode all`: write every optical frame as a PNG image

For large files, use `preview` first. `all` can create a very large number of PNGs.

## Frame Image Player

Mapped PNG frame folders can be previewed full screen with:

```powershell
cd C:\Users\arshm\Desktop\CubeOCC
python sender\cubeocc_frame_player.py
```

Use the GUI to choose a generated `*_images` folder. The player can run at 30 FPS, 60 FPS, custom FPS, or manual keystroke stepping. START and END frames have separate hold-time controls so the receiver/camera can settle on the transfer boundaries.

Fullscreen controls:

- `Esc`: stop
- `Space`, `Right`, or `Enter`: next frame in manual mode
- `Left`: previous frame in manual mode

Experimental RGB plus sequence example:

```powershell
python sender\cubeocc_frame_mapper.py --bitstream sim\sender_bitstreams\<generated>_hamming_15_11.bin --out sim\sender_frames --symbol-mode rgb --sync-mode clk_sequence --sequence-bits 8
```

Outputs:

- `<name>_<mapping>_frames.jsonl`: one JSON object per optical frame.
- `<name>_<mapping>_frames_manifest.json`: protocol settings, reserved cells, payload cell order, and source bitstream metadata.

## Checker

```powershell
python sender\Testing\check_frame_mapping.py --bitstream sim\sender_bitstreams\<generated>_hamming_15_11.bin --frames sim\sender_frames\<generated>_hamming_15_11_8x8_grayscale_clk_frames.jsonl
```

The checker verifies:

- START is all white/on.
- END matches TL/TR/BL white, BR/CLK/payload off.
- Every DATA frame has four white corners.
- CLK toggles 0, 1, 0, 1 across DATA frames when CLK sync is enabled.
- Sequence bits increment per DATA frame when sequence sync is enabled.
- Reconstructed payload bits match the original `.bin` bitstream after removing final frame padding.

## Current Result

Implemented sender logical-frame mapping:

- `sender/cubeocc_frame_mapper.py`
- `sender/Testing/check_frame_mapping.py`

Current smoke status:

```text
PASS: 8x8 grayscale + CLK mapping round-trips to source bitstream
PASS: 8x8 RGB + CLK + 8-bit sequence mapping round-trips to source bitstream
PASS: 16x16 grayscale + 8-bit sequence mapping round-trips to source bitstream
PASS: batch folder mapping generated and checked 6 mappings from 2 bitstreams x 3 presets
```

Smoke input:

```text
mapping protocol smoke
```
