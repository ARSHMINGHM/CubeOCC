---
project: CubeOCC
type: rtl-simulation-review-workflow
status: implemented-and-smoke-tested
parent: 15_TASK_BACKLOG
---

# XSim RTL ROI Review

Parent task tree:

- [[15_TASK_BACKLOG]]

Related notes:

- [[15_04_MANUAL_ROI_CORNER_REVIEW]]
- [[15_05_FPGA_START_ROI_DETECTOR]]
- [[15_06_SOURCES_AND_FPGA_UI]]

## Purpose

This workflow lets a human label **the ROI coordinates produced by the real SystemVerilog RTL in XSim**. It does not need an FPGA board or a physical camera.

```text
monitor-capture image
    -> 160 x 120 grayscale camera raster (.mem)
    -> tb/roi_start_detector_image_tb.sv
    -> rtl/roi_start_detector.sv in XSim
    -> rtl_results.json
    -> ROI review GUI: 1=true, 2=mid, 3=false
```

The review GUI only draws XSim's recorded coordinates in this mode. It does not rerun the Python reference algorithm.

## Files

```text
dataset/run_roi_rtl_sim.py          batch preparation and XSim runner
tb/roi_start_detector_image_tb.sv   grayscale-image DVP testbench
rtl/roi_start_detector.sv           actual synthesizable tracker under test
dataset/roi_rtl_review.html         adjustable browser-based human grading GUI
dataset/serve_roi_rtl_review.py     localhost server that opens the review GUI
```

## Run One Capture Set First

From PowerShell:

```powershell
cd C:\Users\arshm\Desktop\CubeOCC
$python = 'C:\Users\arshm\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe'

& $python dataset\run_roi_rtl_sim.py `
  --input-dir captures\MLCAP_001_Baseline_30fps `
  --out sim\roi_rtl_baseline
```

The runner compiles the ROI RTL once, drives all images in their sorted capture order, and keeps the RTL's START/DATA/full-off state across the set. When the input contains multiple capture folders, it resets the RTL only between folders. It creates:

```text
sim/roi_rtl_baseline/
  camera_gray/          the exact 160 x 120 grayscale images fed to RTL
  mem/                  one hexadecimal pixel memory file per image
  xsim_build/           Vivado/XSim compilation and run logs
  rtl_results.json      XSim output mapped back to source image names
```

Re-running the same command replaces this generated folder only after it contains `rtl_results.json`. This protects unrelated folders from deletion.

## Label The Actual RTL Output

```powershell
& $python dataset\serve_roi_rtl_review.py
```

Chrome or Edge opens at `http://127.0.0.1:8765`. Select **Choose RTL Result Folder**, then choose `sim\roi_rtl_baseline`. The browser reads `rtl_results.json`, loads the exact grayscale images used by XSim, and writes review data back to that selected folder.

For every image:

| Key | Label | Meaning |
| --- | --- | --- |
| `1` | `true` | Red XSim ROI accurately identifies the sender grid. |
| `2` | `mid` | Usable but noticeably imprecise. |
| `3` | `false` | RTL did not identify the sender ROI. |
| `S` | skip | Move on without assigning a label. |

The simulated camera is intentionally small, so the GUI starts at `4x` zoom (`640 x 480` display). Use the **Display zoom** slider to choose `1x` through `6x`; zoom changes only the view and never alters the XSim coordinates or saved labels.

The browser UI writes fresh review evidence under the simulation output folder:

```text
sim/roi_rtl_baseline/roi_review/
  roi_review.json
  annotated/
```

`roi_review.json` records the grade, the exact XSim output, RTL configuration, and paths to the red-dot annotated image. It is the file to inspect when debugging `mid` and `false` results.

## Run The Full Capture Corpus

After the baseline set looks correct, replace the input path with `captures`:

```powershell
& $python dataset\run_roi_rtl_sim.py --input-dir captures --out sim\roi_rtl_all
& $python dataset\serve_roi_rtl_review.py
```

Then choose `sim\roi_rtl_all` in the browser. Each immediate capture directory is simulated as its own ordered transfer. The runner keeps this isolation with an RTL reset between folders, but runs the full corpus in one XSim session to avoid repeated compilation and simulator startup. Generated review folders are excluded from the input scan.

## What "Actual FPGA ROI" Means Here

The detector under test is the synthesizable module used by `cubeocc_top`, so the output is RTL/XSim behavior, not a Python-only estimate. This batch testbench uses a small `160 x 120` grayscale camera raster to keep a large image corpus practical in simulation. Its threshold is `180`, minimum bright run is `8`, minimum ROI height is `4`, and full-off requires zero bright pixels. Those spatial parameters are scaled for the smaller simulation raster; the algorithm and state machine are the same RTL.

This is a unit-level RTL simulation of `roi_start_detector`, not a claim that a complete board-level `cubeocc_top` camera system has been simulated. Use [[15_06_SOURCES_AND_FPGA_UI]] for the physical-hardware boundary.

## Label Review And Algorithm Revision

The first full human review of `sim/roi_rtl_all` recorded 782 labels:

| Grade | Count | Meaning |
| --- | ---: | --- |
| `true` | 508 | ROI is correct. |
| `mid` | 13 | Usable but imprecise. |
| `false` | 261 | Incorrect ROI or no ROI. |

The failures were not evenly distributed. The dominant groups were angled,
near-angle, reflection, and defocus captures. Their original cause was two
parts of the streaming tracker:

1. START seeded an axis-aligned rectangle, so a perspective view of the
   monitor began with the wrong four-corner geometry.
2. DATA chose extrema from every bright pixel in the raster, letting payload
   cells, glare, and screen edges move an ROI corner.

`rtl/roi_start_detector.sv` now records four diagonal extrema during the
dense START frame. During DATA, each expected corner is searched only in a
bounded window around its previously accepted position and must contain a
multi-row bright box, not merely one bright pixel. This rejects a small glare
or noise spot that appears before the actual white corner marker. A warped or
angled marker remains valid because its bright run can shift from row to row.
This remains a one-pixel-per-clock, no-full-frame-buffer implementation. The
focused XSim regression verifies normal START/DATA/full-off behavior, a
slanted START quadrilateral, and rejection of a preceding `2 x 2` noise spot.

## Fresh Review After The Revision

The revised RTL completed another all-capture XSim run:

```text
sim/roi_rtl_all_v4_boxes/
  rtl_results.json
  camera_gray/
  mem/
  xsim_build/
```

It processed all 808 input images and emitted 770 valid RTL ROIs. The box rule
changes the geometry in difficult angled, reflected, and defocused sets. The
older `true`/`mid`/`false` grades are **diagnostic only**, because they were
applied to an earlier RTL output and must not be treated as the new accuracy
score.

Run a fresh human review before reporting an improvement:

```powershell
& $python dataset\serve_roi_rtl_review.py
```

Choose `sim\roi_rtl_all_v4_boxes`, then label the output again with `1`, `2`, and
`3`. Compare its generated `roi_review\roi_review.json` to the prior review;
that is the valid before/after measurement.

## Smoke-Test Evidence

The baseline set `MLCAP_001_Baseline_30fps` completed in XSim with 13 processed frames and wrote `rtl_results.json`. The full 62-folder capture corpus also completed as one 808-frame XSim run, producing 770 valid RTL ROI outputs. This verifies the conversion, DVP stimulus, XSim invocation, CSV-to-manifest conversion, folder-boundary reset, and RTL-result handoff to the labeler. The remaining work is the fresh human `true`/`mid`/`false` grading of the revised difficult capture sets.
