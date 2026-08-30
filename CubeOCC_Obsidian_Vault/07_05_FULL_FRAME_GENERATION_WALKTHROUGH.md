---
project: CubeOCC
type: simulation
status: active
last_reviewed: 2026-08-30
---

# Full Frame Generation Walkthrough

This note gives one full V1 sender-side frame generation test path from input data to visible optical frames.

Related notes:

- [[07_01_SENDER_BITSTREAM_TOOL]]
- [[07_02_SENDER_BITSTREAM_TESTING]]
- [[07_03_SENDER_FRAME_MAPPING]]
- [[07_04_SENDER_FRAME_PLAYER]]
- [[03_FRAME_AND_LINK_PROTOCOL]]

## Goal

Create a V1 sender test example:

```text
input text or file
-> no-ECC / Hamming bitstream
-> protocol DATA frames
-> PNG frame images
-> fullscreen sender preview
```

This is still sender-side simulation. It proves the data-to-frame generation path before the physical monitor/camera/FPGA receiver test.

## Step 1 — Generate V1 Bitstreams

GUI:

```powershell
cd C:\Users\arshm\Desktop\CubeOCC
python sender\cubeocc_sender_gui.py --gui
```

Recommended V1 GUI settings:

- ECC modes: `v1`
- Output format: `bin`
- Output folder: `sim/sender_bitstreams`

CLI text example:

```powershell
python sender\cubeocc_sender_gui.py --text "hello cubeocc" sim\sender_bitstreams --modes v1 --format bin
```

CLI file example:

```powershell
python sender\cubeocc_sender_gui.py --file input.bin sim\sender_bitstreams --modes v1 --format bin
```

Expected output:

```text
<input>_<timestamp>_no_ecc.bin
<input>_<timestamp>_no_ecc.json
<input>_<timestamp>_hamming_15_11.bin
<input>_<timestamp>_hamming_15_11.json
<input>_<timestamp>_manifest.json
```

## Step 2 — Optional Bitstream Check

No ECC:

```powershell
python sender\Testing\check_sender_bitstream.py --input input.bin --bitstream sim\sender_bitstreams\<generated>_no_ecc.bin
```

Hamming baseline:

```powershell
python sender\Testing\check_sender_bitstream.py --input input.bin --bitstream sim\sender_bitstreams\<generated>_hamming_15_11.bin
```

Expected:

```text
PASS
```

## Step 3 — Map Bitstreams To Frame Images

GUI:

```powershell
python sender\cubeocc_frame_mapper.py --gui
```

Easy GUI path:

1. Select `Whole folder batch`.
2. Choose `sim/sender_bitstreams` as the batch folder.
3. Choose an output folder such as `sim/sender_frames_batch`.
4. Click `V1 8x8 Grayscale`.
5. Keep image mode as `preview` for first tests.
6. Click `Generate Frames`.

The V1 preset follows [[03_FRAME_AND_LINK_PROTOCOL]]:

```text
START: all 64 cells white/on
DATA: 4 white corners + CLK toggle + 59 grayscale payload cells
END: TL/TR/BL white, BR off, CLK off, payload off
```

CLI batch example:

```powershell
python sender\cubeocc_frame_mapper.py --input-dir sim\sender_bitstreams --out sim\sender_frames_batch --presets "8x8:grayscale:clk:0" --image-mode preview
```

CLI experimental comparison example:

```powershell
python sender\cubeocc_frame_mapper.py --input-dir sim\sender_bitstreams --out sim\sender_frames_batch --presets "8x8:grayscale:clk:0;8x8:rgb:clk_sequence:8;16x16:grayscale:sequence:8" --image-mode preview
```

Expected output:

```text
sim/sender_frames_batch/
  8x8_grayscale_clk/
    <generated>_8x8_grayscale_clk_frames.jsonl
    <generated>_8x8_grayscale_clk_frames_manifest.json
    <generated>_8x8_grayscale_clk_images/
      frame_000000_start.png
      frame_000001_data.png
      ...
      frame_<last>_end.png
  batch_manifest.json
```

## Step 4 — Optional Frame Mapping Check

```powershell
python sender\Testing\check_frame_mapping.py --bitstream sim\sender_bitstreams\<generated>_hamming_15_11.bin --frames sim\sender_frames_batch\8x8_grayscale_clk\<generated>_8x8_grayscale_clk_frames.jsonl
```

Expected:

```text
PASS: frame mapping matches source bitstream
```

This proves the logical START/DATA/END frames reconstruct back to the original generated bitstream.

## Step 5 — Preview Like A Sender

Run:

```powershell
python sender\cubeocc_frame_player.py
```

GUI path:

1. Click `Browse`.
2. Select the generated `*_images` folder.
3. Choose `Timed FPS`.
4. Choose `30` FPS or `60` FPS.
5. Set START and END hold times, for example:
   - START hold ms: `1000`
   - END hold ms: `1000`
6. Click `Run Fullscreen`.

Manual testing path:

1. Choose `Manual keystroke`.
2. Click `Run Fullscreen`.
3. Use `Space`, `Right`, or `Enter` for the next frame.
4. Use `Left` for the previous frame.
5. Press `Esc` to stop.

## Recommended V1 Test Settings

For first sender tests:

```text
ECC mode: v1
Output format: bin
Mapping preset: 8x8:grayscale:clk:0
Image mode: preview
Playback: 30 FPS
START hold: 1000 ms
END hold: 1000 ms
```

For real monitor/camera tests, use `--image-mode all` only when the number of frames is manageable. Large files can create a very large number of PNG images.

## Current Sender-Side Status

Implemented:

- sender bitstream GUI and CLI
- no-ECC and Hamming bitstream generation
- Hamming/No-ECC bitstream checker
- logical frame mapper
- batch folder frame mapping
- PNG frame rendering
- fullscreen frame player

Current tested result:

```text
PASS: generated V1 bitstreams
PASS: mapped V1 8x8 grayscale frames
PASS: mapped experimental RGB/sequence and 16x16/sequence frames
PASS: checked mapped frames reconstruct to source bitstreams
PASS: frame player discovered START-to-END preview images
```

Next sender-side step:

```text
Use the fullscreen player on a real monitor, capture it with Camera 2 / ROI test camera, and feed those captured images into the camera/image-processing simulation path.
```
