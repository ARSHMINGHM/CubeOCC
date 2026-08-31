---
project: CubeOCC
type: experiments
status: active
last_reviewed: 2026-08-22
---

# Image Processing Experiments

## 1. Denoising

V1 should not assume denoising is always beneficial.

### Baseline comparison

- bypass / no denoise
- simple sharpening, if edges/cell separation need help
- small Gaussian-style smoothing, if noise causes symbol errors

Possible V1.5/V2 comparison:

- wavelet-based denoise, only if the post-V1 FPGA resource budget allows it

Measure:

- symbol error rate
- raw BER
- ECC corrections
- post-ECC BER
- FPGA resources
- latency

### Optional adaptive denoising

Not V1-required.

Idea:

- first frame uses baseline setting
- observe downstream symbol confidence/ECC statistics
- only if several frames show both low symbol confidence and high ECC correction activity, switch denoise mode/strength

Do not switch based on one noisy frame. Validate this experimentally because denoising can also damage boundaries/colors.

## 2. Glare

V1:

- no detection
- no compensation

Experiment only:

- label glare severity
- report BER/SER degradation

## 3. Sampling radius sweep

Sampling radius is configurable and circle-based.

V1 will first estimate the grid boxes/cells:

- find each box/cell center
- estimate the average box/cell size for the active grid
- place a sampling circle around each cell center
- choose the circle radius as a fraction of the average box size

For each supported grid size, V1 will test small, medium, and large circular sampling regions. The selected default may depend on grid size and measured error behavior.

Testbench debug overlays should show:

- detected cell boundary
- cell center
- sampling circle/region around the cell center
- averaged RGB
- classified symbol
- ground-truth symbol
- confidence

Select the V1 radius using raw BER, SER, ECC correction count and stability across conditions. Do not spend V1 FPGA resources auto-detecting an oversized radius.

## 3.5 Offline ROI warp and degradation

Tool note:

- [[15_02_ROI_WARP_AND_DEGRADATION_TOOL]]

For captured monitor images, use the given four corner points to make a regular ROI dataset before ML training or receiver testing.

Offline preparation flow:

- take real monitor-capture images
- use four corners: TL, TR, BR, BL
- prefer auto-detecting bright corner markers first, using quadrant-based marker selection for real captures
- use bright-pixel bounds only for clean generated images or tightly cropped frames
- fall back to manual corner labels when auto-detection is unstable
- perspective-warp the capture to a regular ROI image
- create downsampled variants to simulate lower-resolution ROI/camera input
- create Gaussian-blurred variants to simulate less visible / softer camera images
- keep labels from [[15_01_MONITOR_CAPTURE_DATASET_LABELING]]

This is not FPGA V1 processing. It is dataset preparation for experiments and ML. The FPGA-side V1 receiver still starts with streaming ROI pixels and averaging-only grayscale/on-off recovery.

Current stress result is recorded in [[15_02_ROI_WARP_AND_DEGRADATION_TOOL]].

## 4. Color classification

### V1 — grayscale baseline

V1 uses averaging only. The receiver averages pixels inside the selected circular sampling region for each cell/box, then uses that average for grayscale/on-off recovery.

### V1.5 — RGB threshold/classification

V1.5 upgrades from grayscale to RGB symbols and uses practical RGB threshold/classification logic.

Initial threshold-style baseline:

```text
R_on = avg_R >= T_R
G_on = avg_G >= T_G
B_on = avg_B >= T_B
symbol = {R_on, G_on, B_on}
```

### V2 — calibrated SVM classifier

V2 should investigate calibrated RGB classification instead of only fixed global thresholds.

Proposed training flow:

- collect labeled image-backed simulation and/or camera data
- calculate whole-image statistics, such as average brightness
- calculate per-cell statistics, such as average value and variance
- train a predetermined SVM model offline in Python
- export the learned decision parameters/behavior for FPGA implementation

The FPGA should not run Python. Python is used for offline training and calibration. The FPGA receives the final trained model representation or equivalent decision thresholds/coefficients.

### V2+ — normalized RGB / expanded classifier comparison

Later compare normalized/chromaticity classification and other lightweight classifiers against the V2 calibrated SVM approach.
