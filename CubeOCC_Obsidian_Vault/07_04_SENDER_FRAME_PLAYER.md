---
project: CubeOCC
type: sender
status: implementation
last_reviewed: 2026-08-30
---

# Sender Frame Player

This note documents the sender-side preview tool for mapped optical frame images.

Parent protocol:

- [[03_FRAME_AND_LINK_PROTOCOL]]

Related notes:

- [[07_03_SENDER_FRAME_MAPPING]]
- [[07_05_FULL_FRAME_GENERATION_WALKTHROUGH]]

## Purpose

`sender/cubeocc_frame_player.py` opens a folder of mapped PNG frames and previews them full screen like a simple sender display.

The player does not create bitstreams and does not change ECC. It only displays already-generated frame images from the mapper.

## Input Folder

Use a generated `*_images` folder from the frame mapper, for example:

```text
sim/sender_frames_batch/
  8x8_grayscale_clk/
    <name>_8x8_grayscale_clk_images/
      frame_000000_start.png
      frame_000001_data.png
      frame_000002_data.png
      frame_000003_end.png
```

The player sorts images by the number in the filename:

```text
frame_000000_start.png
frame_000001_data.png
frame_000002_data.png
...
frame_999999_end.png
```

## Run GUI

```powershell
cd C:\Users\arshm\Desktop\CubeOCC
python sender\cubeocc_frame_player.py
```

GUI steps:

1. Click `Browse`.
2. Select a generated `*_images` folder.
3. Choose `Timed FPS` or `Manual keystroke`.
4. Choose 30 FPS, 60 FPS, or custom FPS.
5. Set `START hold ms` and `END hold ms`.
6. Click `Run Fullscreen`.

## Timing Controls

- `30 FPS`: data frames change every about 33 ms.
- `60 FPS`: data frames change every about 16 ms.
- `custom FPS`: user-selected data-frame rate.
- `START hold ms`: how long to hold the all-white START frame.
- `END hold ms`: how long to hold the END frame.

The START and END hold times are useful because the receiver/camera may need a stable boundary frame before and after the DATA stream.

## Fullscreen Controls

- `Esc`: stop playback and close fullscreen.
- `Space`, `Right`, or `Enter`: next frame in manual mode.
- `Left`: previous frame in manual mode.

## Current Result

Implemented:

- `sender/cubeocc_frame_player.py`

Smoke result:

```text
PASS: player discovered a generated image folder
PASS: player sorted START first and END last
```

Fullscreen playback still needs visual confirmation by running it on the local desktop.
