---
project: CubeOCC
type: checklist
status: active
last_reviewed: 2026-08-22
---

# Verification Checklist

## Protocol

- [ ] 8×8 = 64 total cells.
- [ ] DATA = 4 white corner markers + 1 CLK + 59 coded cells.
- [ ] V1 8x8 grayscale DATA = 59 coded bits.
- [ ] V1.5 8x8 RGB DATA = 59 x 3 = 177 coded bits.
- [ ] CLK position is configurable.
- [ ] START is exactly one all-white frame.
- [ ] START includes white at CLK position.
- [ ] END keeps TL/TR/BL white.
- [ ] END has BR off.
- [ ] END has CLK off.
- [ ] END ordinary cells are black.
- [ ] All 8 RGB states are legal DATA symbols.
- [ ] Sequence number is marked optional/V2.

## Cameras

- [ ] Camera 1 is grayscale tracking/feedback.
- [ ] Camera 1 target example is ~60 FPS.
- [ ] Camera 2 is the DATA camera.
- [ ] Camera 2 V1 path is grayscale.
- [ ] Camera 2 V1.5 path is RGB.
- [ ] Camera 2 target example is ~30 FPS.
- [ ] Camera 1 produces ROI/geometry, brightness and confidence.
- [ ] No V1 glare detector exists.
- [ ] Both cameras establish four-point relationship at START.
- [ ] Camera 2 uses sensor-level ROI/windowing.
- [ ] FPGA receives Camera 2 cropped ROI stream.

## V1 processing

- [ ] One pipeline works before replication.
- [ ] Full raw frame is not stored by default.
- [ ] Required line/local buffers are allowed.
- [ ] Grid geometry updates each frame.
- [ ] Per-cell grayscale values are accumulated in V1.
- [ ] V1.5 adds per-cell RGB accumulation.
- [ ] Sampling radius is configurable in simulation.
- [ ] Debug visualization shows sampling region.
- [ ] V1 recovery is averaging-only grayscale/on-off.
- [ ] V1.5 classifier uses RGB thresholds.
- [ ] V2 classifier uses offline SVM/calibrated decision behavior.

## Denoise / glare

- [ ] No-denoise baseline exists.
- [ ] Sharpening/Gaussian candidates exist if bypass fails.
- [ ] Adaptive denoise is marked optional.
- [ ] Glare is only a labeled impairment/measurement condition in V1.

## ECC

- [ ] No-ECC baseline.
- [ ] Multiple Hamming candidates.
- [ ] Multiple BCH candidates.
- [ ] Correction capability documented.
- [ ] Useful bits per V1 59-bit and V1.5 177-bit DATA frame documented.
- [ ] Raw BER measured.
- [ ] Post-ECC BER measured.
- [ ] Goodput measured.
- [ ] FPGA resources measured.

## Testbench

- [ ] Simulated button.
- [ ] Camera-register model.
- [ ] Camera 2 ROI register/window behavior.
- [ ] Camera-like pixel timing/stream.
- [ ] Dataset full image is cropped by simulated sensor, not DUT.
- [ ] Repeated captures of same optical frame tested.
- [ ] CLK transition tested.
- [ ] START and END tested.
- [ ] CSV/TXT log generated.

## Optional parallelism

- [ ] Benchmark one worker first.
- [ ] Replicated workers use same reusable module.
- [ ] Input scheduler only added if N > 1.
- [ ] Output reorder buffer restores frame order.
- [ ] If all workers busy, one shared one-frame overflow buffer policy is explicit.
- [ ] Overflow flag is raised if that buffer is already full.
