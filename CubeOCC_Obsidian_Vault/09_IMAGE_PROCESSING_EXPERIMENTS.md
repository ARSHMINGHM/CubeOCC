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
- 3×3 median filter

Possible later comparison:

- 3×3 mean
- small Gaussian

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

Sampling radius is configurable.

Suggested sweep uses several fractions of cell size. Testbench debug overlays should show:

- detected cell boundary
- cell center
- sampling circle/region
- averaged RGB
- classified symbol
- ground-truth symbol
- confidence

Select the V1 radius using raw BER, SER, ECC correction count and stability across conditions. Do not spend V1 FPGA resources auto-detecting an oversized radius.

## 4. Color classification

### V1 — threshold classifier

```text
R_on = avg_R >= T_R
G_on = avg_G >= T_G
B_on = avg_B >= T_B
symbol = {R_on, G_on, B_on}
```

### V2 — normalized RGB

Later compare normalized/chromaticity classification against the simple threshold baseline.
