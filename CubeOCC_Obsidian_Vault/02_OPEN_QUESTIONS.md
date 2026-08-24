---
project: CubeOCC
type: open-questions
status: active
last_reviewed: 2026-08-22
---

# Open Questions

## Frame/protocol

- [ ] Exact bit mapping of the 8 RGB cube symbols, if not using direct `RGB = 3-bit value`.
- [ ] Exact optical DATA frame rate for the main experiments.
- [ ] Whether START/END should later gain extra robustness variants for comparison.
- [ ] Whether sequence number should be implemented in V2.
- [ ] Exact policy if Camera 2 completely misses one or more transmitted frames.

## Grid scaling

- [ ] Main grid sizes to benchmark: likely 8×8, 16×16, 32×32.
- [ ] How the receiver is told which grid size is active.
- [ ] Whether grid size changes only between transfers or may adapt during a transfer.

## Camera interface

- [ ] Exact real camera/sensor model to target later.
- [ ] Exact control bus for camera registers, e.g. I2C/SCCB/custom model.
- [ ] Exact pixel-stream pins/protocol to emulate.
- [ ] Confirm target sensor supports required hardware ROI/windowing behavior.

## Processing

- [ ] Final V1 denoise choice after measurement.
- [ ] Best sampling-radius fraction after dataset sweeps.
- [ ] Final RGB threshold values and whether thresholds are global or calibrated.

## ECC

- [ ] Final Hamming set.
- [ ] Final BCH set.
- [ ] Whether shortened block codes are worth implementing to use more of the 177-bit frame.
- [ ] Exact packet/header format inside ECC-protected payload.
- [ ] Whether CRC is included in addition to ECC.

## Optional parallel architecture

- [ ] Does one pipeline meet the target frame rate after synthesis?
- [ ] If not, how many workers are needed?
- [ ] If every worker is busy when a new frame begins, use shared overflow buffering, sensor/backpressure, or frame drop?

## 2026-08-24 — Camera Output Bit-Width Benchmarking (Optional / V2)

- **Idea by:** Armin
- **Goal:** Test different camera output data formats (e.g., RAW8, RGB565, YUV422) to evaluate their impact on overall speed and throughput.
- **Current V1 State:** V1 uses standard 8-bit DVP streaming.
- **Future Work:** Run a benchmark matrix comparing:
  - FPS
  - Resource usage
  - Image processing latency
  - Overall throughput
