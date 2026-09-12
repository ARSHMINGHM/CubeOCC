---
project: CubeOCC
type: dataset-tool
status: active
last_reviewed: 2026-08-31
parent: 15_TASK_BACKLOG
---

# ROI Warp And Degradation Tool

This note documents the offline dataset-preparation tool for real monitor-capture images.

Parent task tree:

- [[15_TASK_BACKLOG]]

Related notes:

- [[15_01_MONITOR_CAPTURE_DATASET_LABELING]]
- [[09_IMAGE_PROCESSING_EXPERIMENTS]]
- [[08_SIMULATION_CAMERA_MODEL]]
- [[15_04_MANUAL_ROI_CORNER_REVIEW]]

## Purpose

Prepare captured sender-display images for receiver testing and later ML/SVM-style analysis.

The tool takes real monitor-capture images, finds or reads the four CubeOCC corner markers, warps the image to a regular ROI, then creates lower-visibility variants through downsampling and Gaussian blur.

This is an offline dataset step. It is not FPGA V1 receiver logic.

## Flow

```text
raw monitor-capture image
-> four corner markers
-> perspective warp to regular ROI
-> downsample/upscale variants
-> Gaussian blur variants
-> prepared image dataset for receiver/ML tests
```

## Python Tool

```text
dataset/prepare_monitor_capture.py
```

## Recommended Auto-Corner Run

```powershell
cd C:\Users\arshm\Desktop\CubeOCC
python dataset\prepare_monitor_capture.py --input-dir captures\MLCAP_001_Baseline_30fps --auto-corners --corner-method quadrants --out dataset_prepared\MLCAP_001_Baseline_30fps --roi-width 512 --roi-height 512
```

Recommended defaults:

```text
--threshold 0
--corner-method quadrants
--min-area 20
--detect-width 640
```

`--threshold 0` means adaptive thresholding. The tool tries multiple brightness thresholds and records the threshold that worked for each image in `prepared_manifest.json`.

## Manual Corner Fallback

If auto-detection is unstable, provide a `corners.json` file.

Run:

```powershell
python dataset\prepare_monitor_capture.py --input-dir captures\MLCAP_001_Baseline_30fps --corners captures\MLCAP_001_Baseline_30fps\corners.json --out dataset_prepared\MLCAP_001_Baseline_30fps --roi-width 512 --roi-height 512
```

Corner JSON example:

```json
{
  "capture_0001.png": {
    "tl": [120, 80],
    "tr": [900, 95],
    "br": [880, 700],
    "bl": [140, 690]
  }
}
```

Corner order:

```text
TL, TR, BR, BL
```

## Output

For each input image, the tool writes:

```text
<capture_name>_warped_roi.png
<capture_name>_roi_scale1_blur0.png
<capture_name>_roi_scale0.75_blur0.75.png
<capture_name>_roi_scale0.5_blur1.5.png
...
prepared_manifest.json
```

Default degradation set:

```text
scales: 1.0, 0.75, 0.5, 0.25
Gaussian blur radius: 0, 0.75, 1.5, 2.5
```

Use smaller ROI sizes such as `256x256` when the prepared image should look less visible or closer to lower-resolution camera input.

## Auto-Corner Methods

### `quadrants`

Recommended for real camera captures. It finds bright marker components and chooses one marker in each corner quadrant.

### `bounds`

Best for clean generated sender images or tightly cropped frames. It uses the outer bright-pixel extent as the four corners.

### `components`

Chooses bright components nearest the four corners. This is available as an experiment, but `quadrants` is usually safer for real captures.

## Stress Test Result

Synthetic hard-picture test:

```text
PASS: 11 / 11 hard captures produced warped ROI outputs
```

Tested cases:

- clean sender frame
- dim + blur
- heavy blur
- rotation
- dim + heavy rotation
- center glare
- corner glare
- noise
- low-resolution image
- low-resolution + blur + dim

Known risk:

- strong glare near a corner can pull that detected corner inward
- use manual `corners.json` for those dataset rows if auto-corners look wrong

## Current Status

Implemented:

- auto-corner detection
- manual corner fallback
- perspective warp
- downsample/upscale degradation
- Gaussian blur degradation
- prepared output manifest

Current tool path:

```text
dataset/prepare_monitor_capture.py
```
