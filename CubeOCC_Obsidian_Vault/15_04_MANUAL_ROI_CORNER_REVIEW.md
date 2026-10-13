---
project: CubeOCC
type: dataset-tool
status: active
parent: 15_TASK_BACKLOG
---

# Manual ROI Corner Review

Parent task tree:

- [[15_TASK_BACKLOG]]
- [[15_07_XSIM_RTL_ROI_REVIEW]]

Related notes:

- [[15_01_MONITOR_CAPTURE_DATASET_LABELING]]
- [[15_02_ROI_WARP_AND_DEGRADATION_TOOL]]
- [[09_IMAGE_PROCESSING_EXPERIMENTS]]

## Purpose

Review automatically detected four-corner ROI results from real monitor-capture images. This review set is used to inspect and improve automatic ROI detection.

The reviewer first fits each source image into a simulated fast monochrome camera frame: `640 x 480`, grayscale, with black letterboxing when needed. It does not stretch the image.

It runs `dataset/roi_start_detector_model.py`. This is not an edge/Hough/OpenCV-style method. It uses low-resource streaming-style operations: grayscale thresholding, row runs, pixel extrema, counters, and retained ROI registers. The output is an axis-aligned rectangle for Camera 2 sensor ROI registers.

## Run

```powershell
cd C:\Users\arshm\Desktop\CubeOCC
python dataset\roi_corner_labeler.py --input-dir captures
```

To review one capture set instead:

```powershell
python dataset\roi_corner_labeler.py --input-dir captures\MLCAP_025_Far_Angle30
```

## Review Workflow

For each image, inspect the automatically detected four red corners and red ROI outline. Then press one key. The result saves immediately and the next image opens.

| Key | Label           | Meaning                                                                           |
| --- | --------------- | --------------------------------------------------------------------------------- |
| `1` | `true`          | The automatic red ROI accurately bounds the sender screen/START frame.            |
| `2` | `mid`           | The automatic ROI is usable, but one or more corners are visibly imprecise.       |
| `3` | `false`         | The automatic result does not identify the sender screen/START frame.             |
| `S` | skip            | Leave this image unlabelled and advance.                                          |
| `A` | re-run detector | Recalculate after changing the brightness threshold or minimum bright-run length. |

Each automatically detected corner is painted as a red circle with a `10 px` radius in the simulated camera image. The numbers `1` through `4` show the corner order, and the red outline joins the four detected points. The `Bright threshold`, `Minimum bright run`, and `Minimum ROI height` fields map directly to the three V1 RTL detector inputs.

## FPGA-Oriented Detector Modes

```text
START / bright screen acquisition
-> compare gray pixel against an adaptive-capped threshold
-> for each image row, keep its longest continuous bright run
-> accept rows with runs longer than configured minimum
-> join nearby accepted rows into bands
-> retain the tallest band and output left/top/right/bottom bounds

DATA recovery when corner cells are black
-> threshold the pixel stream
-> keep bright-pixel count plus left/right/top/bottom extrema
-> accept the footprint only when it spans at least 45 percent of both camera dimensions
-> output its bounds as the new ROI

END marker / incomplete geometry
-> retain the most recent accepted ROI

Full-off screen after END
-> stop tracking and ignore frames until another full-white START
```

The detector needs no manually clicked seed point. It waits for the all-white START frame, then tracks the four mandatory DATA corner markers using the outside bright row/column combinations. The model keeps the previous accepted geometry when a marker is weak or the END pattern appears. Only a full-off screen returns it to waiting mode, where later frames are ignored until another all-white START. It uses no full-frame storage, convolution, global edge accumulator, BRAM, DSP multiplier, or divider. The DATA output is a four-point quadrilateral; the current V1 sensor-control output remains an axis-aligned `x`, `y`, `width`, and `height` box.

The default threshold is `180`, but the model caps it at `brightest_pixel - 20` for a dim capture. This explains why the original fixed threshold missed `MLCAP_002_Near_30fps`: its brightest grayscale sample was only `168`.

## Output

With `--input-dir captures`, outputs are written to:

```text
captures/roi_review/
  camera_gray/                 # 640x480 grayscale camera inputs
  annotated/                   # red corner circles and ROI outline
  roi_review.json              # grade plus camera and original coordinates
```

`roi_review.json` is the single review record. Every `1`, `2`, or `3` keypress updates it immediately. It stores both coordinate spaces: `camera_corners` are the automatically detected points used by the small black-and-white camera image; `original_corners` map them back to the untouched source capture.

Its `summary` section contains `true_count`, `mid_count`, `false_count`, and `needs_check`. `needs_check` lists every `mid` and `false` capture path, so it is the first place to look when diagnosing warping, distance, glare, or ROI failures.

It also stores the selected detector mode, configured and effective threshold, minimum bright-run length, minimum ROI height, intermediate marker or footprint diagnostics, and final ROI bounds. These are the measurements needed to tune and replay an RTL implementation.

## Failure Analysis

The first review found three distinct failure classes: a partial white payload band was mistaken for an ROI, dim frames fell below the fixed threshold, and angled frames displaced the physical corner boxes from the axis-aligned bounding-box corners. The current stateful model fixes these with START acquisition, diagonal outside-corner extrema, previous-frame plausibility checks, and full-off reset behavior. This is a software-model result, not yet a claim that the extension is synthesized in Vivado.

After review, share the remaining `false` and `mid` annotated images plus `roi_review.json`. We can compare them with the diagnostics to identify likely causes: distance, angle, glare, low contrast, blur, or a geometry change larger than the retained-ROI policy can tolerate.

## Start A New Review

Each GUI launch starts a new review. Before opening, it deletes the previous `roi_review` output folder, including its old annotations and manifest, then creates a fresh `roi_review.json`. It never changes the original images in `captures`.

This is intentional: each run produces one clean label file for analysis. To begin again, run the same command:

```powershell
python dataset\roi_corner_labeler.py --input-dir captures
```

For safety, the tool refuses to clear an existing `--out` folder unless that folder already contains a CubeOCC `roi_review.json` manifest.
