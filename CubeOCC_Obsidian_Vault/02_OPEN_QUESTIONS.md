---
project: CubeOCC
type: open-questions
status: active
last_reviewed: 2026-08-22
---

# Open Questions

## Frame/protocol

- [x] Exact bit mapping plan: V1 starts with grayscale; V1.5 adds direct `RGB = 3-bit value`.
- [ ] Exact optical DATA frame rate for the main experiments: candidate rates include 30 FPS, 60 FPS, and other measured options; final value deferred to future experiments.
- [x] Whether START/END should later gain extra robustness variants for comparison: not needed; keep simple START/END frames.
- [x] Whether sequence number should be implemented in V2: yes, if the ECC-protected frame budget allows it.
- [x] Exact policy if Camera 2 completely misses one or more transmitted frames: UDP-like; ignore missing data, no retransmit request, report/debug via serial output or status pin.

## Grid scaling

- [x] Main grid sizes to benchmark: V1 starts with 8x8; V2 benchmarks 8x8 through 64x64; V3 extends larger benchmarks up to about 177x177 and reports results in tables.
- [x] How the receiver is told which grid size is active: V1-V3 use static configuration; V4 adds active grid-size detection.
- [ ] Whether grid size changes only between transfers or may adapt during a transfer: V1-V3 keep grid size fixed per transfer; mid-transfer adaptation is deferred as possible V4/V5 research.

## Camera interface

- [x] Exact real camera/sensor model to target later: protocol-first approach; no fixed sensor yet. V1 starts with generic DVP, but MIPI is a required investigation for later camera selection.
- [x] Exact control bus for camera registers: V1 uses I2C; SCCB compatibility may be added in V4.
- [x] Exact pixel-stream pins/protocol to emulate: V1 models both DVP and MIPI-style streams; later choose one physical path based on camera availability and ROI flexibility.
- [x] Confirm target sensor supports required hardware ROI/windowing behavior: required. FPGA sends ROI settings to the camera, and the camera outputs only those selected pixels.

## Processing

- [x] Final V1 denoise choice after measurement: V1 starts simple; use sharpening or Gaussian-style filtering only if tests show errors. V1.5/V2 may investigate wavelet methods depending on post-V1 resource budget.
- [x] Best sampling-radius fraction after dataset sweeps: V1 finds each box/cell center and average box size, then tests small, medium, and large circular sampling regions based on that box size.
- [x] Final RGB threshold values and whether thresholds are global or calibrated: V1 uses averaging only; V1.5 uses RGB threshold/classification; V2 adds calibrated SVM classification trained offline in Python from image/cell statistics.

## ECC

- [x] Final Hamming set: V1 uses a normal/simple fast Hamming mode first; do not block progress on choosing a fixed final Hamming mode.
- [x] Final BCH set: test all BCH candidates listed in `07_ECC_AND_METRICS.md`, then choose the best trusted/reliable mode from future results.
- [x] Whether shortened block codes are worth implementing to use more of the 177-bit frame: test candidates later; first consider using padding bits for frame numbers/sequence metadata before adding shortened-code complexity.
- [x] Exact packet/header format inside ECC-protected payload: V1 uses no extra header; START/DATA/END frames plus ECC are enough. Revisit sequence number when testing other ECC methods.
- [x] Whether CRC is included in addition to ECC: no CRC/checksum for V1 with Hamming ECC; revisit only if later ECC tests show a need.

## Optional parallel architecture

- [ ] Does one pipeline meet the target frame rate after synthesis? Deferred until one full pipeline is implemented and synthesized.
- [ ] If not, how many workers are needed? Same deferred decision as single-pipeline performance; decide only after synthesis shows whether one pipeline is enough.
- [x] If every worker is busy when a new frame begins, use shared overflow buffering, sensor/backpressure, or frame drop? Use one shared one-frame overflow buffer; save only one incoming image/frame until a worker becomes free, then offer that frame to the free worker. If the buffer is already full, raise an overflow flag.

## 2026-08-24 — Camera Output Bit-Width Benchmarking (Optional / V2)

- **Idea by:** Armin
- **Goal:** Test different camera output data formats (e.g., RAW8, RGB565, YUV422) to evaluate their impact on overall speed and throughput.
- **Current V1 State:** V1 uses standard 8-bit DVP streaming.
- **Future Work:** Run a benchmark matrix comparing:
  - FPS
  - Resource usage
  - Image processing latency
  - Overall throughput
