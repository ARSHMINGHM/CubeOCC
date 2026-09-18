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
sim/roi_rtl_all_v7_bounded_edges/
  rtl_results.json
  camera_gray/
  mem/
  xsim_build/
```

The original photograph folders were no longer present during this replay, so
the runner used the exact cached `160 x 120` grayscale camera rasters from the
previous XSim run. It processed all 807 unique cached rasters and emitted 807
valid RTL ROIs. The earlier 808-entry manifest contained two source images
with the same converted basename, leaving 807 unique cached raster files.

This run also fixed cumulative inward corner drift. Corner searches remain in
a fixed `10 px` window around the full START-frame bounding edges instead of
following each last accepted point. Across the final replay, ROI width was
`63..129 px` with median `108 px`, and ROI height was `63..120 px` with median
`111 px`. The prior experimental run had collapsed some angled ROIs to only
`14 px` wide.

The three formerly silent sets now each produce `13/13` valid outputs:

| Capture set | Before | Inside-out revision |
| --- | ---: | ---: |
| `MLCAP_002_Near_30fps` | `0/13` | `13/13` |
| `MLCAP_055_Cam60_Defocus_Opt60` | `1/13` | `13/13` |
| `MLCAP_060_Locked_Bright` | `0/13` | `13/13` |

Validity only means RTL emitted coordinates. The new corner placement still
requires human `true`/`mid`/`false` review before it is an accuracy result.

## Python Corner Reference And RTL Comparison

`dataset/compare_roi_reference.py` provides an independent, higher-quality
software reference. For each capture folder it selects the brightest START
frame, applies an Otsu-derived threshold, closes small mask gaps, keeps the
largest connected bright component, robustly fits its left/right/top/bottom
edges, and intersects those edge lines to obtain four perspective-aware ROI
corners. It freezes those START corners for the remaining frames in that
capture set and compares them with the four points emitted by XSim.

Run it after XSim and optional human labeling:

```powershell
$python = "C:\Users\arshm\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe"
& $python dataset\compare_roi_reference.py sim\roi_rtl_all_v7_bounded_edges
```

Outputs are written under `python_reference/` in the selected result folder:

```text
comparison.json       complete corners, metrics, thresholds, and summary
comparison.csv        compact per-frame table
annotated/             cyan Python corners overlaid with red RTL corners
```

The default problem rule is maximum corner error above `10 px` or bounding-box
IoU below `0.80`. On the current 131 human-labeled frames, it flags 57 of 60
`mid`/`false` labels and accepts 70 of 71 `true` labels. The four disagreements
are `MLCAP_002_Near_30fps/frame_00.png`,
`MLCAP_007_AngleNeg15_30fps/frame_01.png`,
`MLCAP_007_AngleNeg15_30fps/frame_02.png`, and
`MLCAP_011_DimRoom_30fps/frame_01.png`. Their overlays should be relabeled or
confirmed manually rather than using them to tune either detector blindly.

The comparison exposed the main RTL problem: `roi_x/y/width/height` can still
bound the display while `roi_tl/tr/br/bl` come from a short bright scanline or
corner-marker run and collapse toward the center. The next RTL algorithm should
accumulate the longest qualifying run endpoints per START row, fit or
piecewise-approximate the four outer edges, and use the resulting fixed START
quadrilateral as the reference for bounded per-frame tracking.

### Improved Low-LUT RTL Run

The corrected detector initializes all four reported START points from the
full detected START bounding edges. DATA marker searches remain constrained to
fixed 10-pixel START-anchor windows. Because no collected marker can be outside
those windows, the duplicated eight-coordinate anchor-distance calculation was
removed.

The new complete replay is:

```text
sim/roi_rtl_all_v8_python_compared/
```

Compared with V7 on the same 807 cached camera rasters:

| Metric | V7 | V8 |
| --- | ---: | ---: |
| Mean maximum corner error | 29.13 px | 6.98 px |
| Median maximum corner error | 4.18 px | 3.11 px |
| Mean bounding-box IoU | 0.784 | 0.942 |
| Automatically flagged frames | 326 | 264 |

All 71 previously `true` labeled frames remain within the automatic limits.
Eighteen previously `mid`/`false` frames changed from flagged to geometrically
acceptable. They still require a new manual review because those labels describe
the old V7 RTL output.

Two earlier perspective experiments were measured and rejected as the active
implementation. V9 used four diagonal endpoint scores and improved mean maximum
corner error to `5.22 px`, but increased mapped LUT primitives to `2,443`, above
the original detector. V10 replaced those sums with first/last edge spans, but
performed worse on the real corpus with `486/807` frames flagged. V8 remains the
low-resource comparison point.

### V11 Independent Perspective Edges

The warped-image failure was caused by V8 reporting an axis-aligned START
rectangle even when the monitor was a trapezoid. V11 tracks the left and right
longest-run endpoints as separate coherent vertical edges. Each side may start
and stop on a different row, so the four outputs retain perspective. A looser
START-only threshold recovers dim and defocused boundaries; DATA markers keep
the stricter threshold and fixed START-anchor windows.

The complete XSim replay and Python overlays are in:

```text
sim/roi_rtl_all_v11_independent_edges/
```

| Metric | V8 | V11 |
| --- | ---: | ---: |
| Valid RTL outputs | 807/807 | 807/807 |
| Mean maximum corner error | 6.98 px | 3.83 px |
| Median maximum corner error | 3.11 px | 1.94 px |
| Mean bounding-box IoU | 0.942 | 0.948 |
| Automatically flagged frames | 264 | 44 |
| Mapped LUT primitives | 2,115 | 2,635 |
| Flip-flops | 912 | 1,035 |
| CARRY4 | 224 | 291 |
| BRAM / DSP | 0 / 0 | 0 / 0 |

Of the 203 V8 frames previously graded `mid` or `false`, 182 now fall within
the automatic V11 geometry limits. Those old grades describe the V8 red
outline, so this is evidence of changed geometry, not a substitute for a new
human V11 review. The remaining dominant outliers are
`MLCAP_036_Angle15_SlightDefocus` and
`MLCAP_038_Dark_SlightDefocus`.

### Review Python And FPGA Together

Run the combined viewer:

```powershell
$python = "C:\Users\arshm\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe"
& $python dataset\serve_roi_comparison_review.py
```

Choose `sim\roi_rtl_all_v11_independent_edges`. The viewer draws the Python
reference in cyan and the FPGA/XSim result in red, displays all eight corner
coordinates, per-corner distance, maximum error, IoU, and the automatic problem
flag. Either outline can be hidden, and display zoom can be changed from 1x to
8x. Rate the FPGA result with `1=true`, `2=mid`, `3=false`, or `S=skip`.

Fast review mode is enabled by default. It opens only the 44 automatically
flagged V11 frames, preloads the next five images, advances immediately after
each rating, and checkpoints the JSON after a short pause or every 20 labels.
Uncheck **Only automatically flagged frames** before choosing the folder to
review all 807 frames. PNG encoding is no longer performed for every label;
press `E` only when a particular combined overlay should be saved.

Ratings and the visible combined overlays are saved under:

```text
sim/roi_rtl_all_v11_independent_edges/comparison_review/
  comparison_review.json
  annotated/
```

Run a fresh human review before reporting an improvement:

```powershell
& $python dataset\serve_roi_rtl_review.py
```

Choose `sim\roi_rtl_all_v7_bounded_edges`, then label the output again with `1`, `2`, and
`3`. Compare its generated `roi_review\roi_review.json` to the prior review;
that is the valid before/after measurement.

## Smoke-Test Evidence

The baseline set `MLCAP_001_Baseline_30fps` completed in XSim with 13 processed frames and wrote `rtl_results.json`. The full 62-folder capture corpus also completed as one 808-frame XSim run, producing 770 valid RTL ROI outputs. This verifies the conversion, DVP stimulus, XSim invocation, CSV-to-manifest conversion, folder-boundary reset, and RTL-result handoff to the labeler. The remaining work is the fresh human `true`/`mid`/`false` grading of the revised difficult capture sets.
