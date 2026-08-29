---
project: CubeOCC
type: decisions
status: active
last_reviewed: 2026-08-26
---

# Decision Log

## 2026-08-20 — Initial concept

Two-camera OCC receiver, grayscale ROI/feedback camera, DATA camera, image processing + grid extraction, Hamming/BCH testing, simulation-first. V1 starts grayscale; V1.5 upgrades the DATA camera to RGB cube symbols.

## 2026-08-20 — 8×8 format

64 cells, 4 corner markers, 1 CLK, 59 payload/ECC cells. Later decisions split this by version: V1 grayscale has 59 coded bits; V1.5 RGB has 177 coded bits.

## 2026-08-20 — END corrected

TL/TR/BL white; BR off; CLK off; ordinary cells black.

## 2026-08-22 — START clarified

One optical frame, all 64 cells white, no payload.

## 2026-08-22 — DATA symbol legality

All 8 RGB states, including black and white, are legal DATA symbols. START/END are reserved complete-frame patterns.

## 2026-08-22 — CLK

Physical CLK cell location is not important; make it configurable. V1 uses CLK toggle. Sequence number is optional/V2.

## 2026-08-22 — Camera rates

Example target: Camera 1 ~60 FPS, Camera 2 ~30 FPS.

## 2026-08-22 — Glare removed from V1

Deleted glare detection, correction and glare-derived feedback. Keep glare only as a labeled impairment for BER testing.

## 2026-08-22 — Camera mapping

At START, detect four corners in both cameras and establish their relationship. Use Camera 1 tracking to drive Camera 2 ROI. Report mapping residual rather than claiming fisheye detection.

## 2026-08-22 — Sensor-level ROI

Camera 2 uses sensor/window registers. FPGA receives only cropped ROI stream. Testbench emulates camera register interface and sensor crop.

## 2026-08-22 — No full raw-frame storage in V1

Supersedes earlier FF-frame-buffer idea. V1 streams image data and reduces it to per-cell averages/symbols.

## 2026-08-22 — Parallel workers optional

V1: one worker, no scheduler/FIFO if performance is enough. If scaling is needed: same pipeline module instantiated N times, input scheduler, optional one shared overflow buffer, output reorder buffer.

## 2026-08-22 — Denoising

V1 starts with bypass/no denoise, then tests simple sharpening or Gaussian-style smoothing only if measured errors need it. Wavelet denoise is V1.5/V2 depending on FPGA resources. Adaptive denoise using confidence/ECC behavior is optional research.

## 2026-08-22 — Sampling radius

Circle-based configurable testbench parameter. Find cell centers and average box/cell size, then sweep small, medium, and large sampling circles per grid size. Choose defaults from BER/SER measurements.

## 2026-08-22 — Color classification

V1 grayscale/on-off averaging only. V1.5 RGB threshold/classification. V2 calibrated classifier using offline Python SVM data and FPGA implementation of learned decision behavior; normalized RGB/chromaticity remains a comparison candidate.

## 2026-08-22 — ECC table expanded

Compare no ECC, multiple Hamming codes and multiple BCH codes. Document useful payload for V1 59-bit grayscale frames and V1.5 177-bit RGB frames, plus correction capability.

## 2026-08-23 — DVP First Implementation, MIPI Investigation Retained

- Decision by Armin: Focus the first physical implementation path on DVP while keeping MIPI investigation alive.
- MIPI implementation on FPGA (D-PHY routing/debugging) can be complex and time-consuming.
- MIPI behavioral model is built and passing tests and should stay available for comparison.
- This is refined by the 2026-08-28 decision: V1 simulation models both DVP and MIPI-style pixel streams before the final physical camera path is chosen.

# 2026-08-24 — Standard I2C Master & DVP-to-AXIS Bridge RTL Verified

- Rewrote i2c_master.v based on standard I2C protocols:
  - Implemented true bidirectional inout SDA pin.
  - Added proper ACK reading/handling after every 8-bit byte.
  - Added OV5640 initialization sequence (Power-On Reset) to the testbench.
- Developed dvp_to_axis.v (Synthesizable RTL) to convert raw DVP signals to standard AXI4-Stream (tvalid, tlast, tuser).

- Strictly followed V1 rule: No full-frame buffering (RAM/BRAM) in the AXIS bridge. Pure streaming with 1-clock pipeline delay.

- End-to-end simulation PASSED: FPGA configures ROI via I2C, camera streams ROI, AXIS bridge outputs exactly 92,160 pixels (128x720).

## 2026-08-26 — Top-Level Integration PASSED (cubeocc_top_tb) & Camera Model Driving Convention

- `cubeocc_top_tb` (DVP camera model → dvp_to_axis → cubeocc_hls_0 → AXIS) PASSED: 92,160 pixels (128x720) and 720 lines (tlast) counted per frame.
- Bug found & fixed: the DVP camera model drove `href`/`pixel_data` with blocking assignments in the same time step as `posedge pclk`. When the model's update won the race, `dvp_to_axis` sampled the already-fallen `href`, so `m_axis_tlast` (end-of-line) never asserted. Pixel count was unaffected, which is why earlier regressions passed.
- **Driving convention (rule for all camera models):** DVP outputs (`vsync`, `href`, `sof`, `pixel_data`) must be driven on `negedge pclk`, never with blocking assigns concurrent to `posedge pclk`. Applied to `camera_sim/dvp_camera_model.sv`.
- Lesson: `axis_cam_tb` never checked the line count, so the broken tlast was invisible. Verification must check tlast/tuser (lines/frames), not just pixel totals.

## 2026-08-26 — Real Image Folder Input for Camera Simulation

- Direction confirmed: CubeOCC simulation should feed the FPGA from a folder of image frames, not only from random/math pixel patterns.
- Planned flow: source image folder → `.mem` conversion → `dvp_camera_model` `$readmemh` → DVP pixel stream → FPGA DUT.
- Purpose: make the simulated camera behave closer to physical testing, where the FPGA receives actual image content through camera timing signals instead of synthetic counter/random values.
- The math pattern remains useful for timing and ROI regression, but protocol/image-processing validation should use folder-based CubeOCC grid images.

## 2026-08-28 — V1 Grayscale, V1.5 RGB Symbol Mapping

- V1 starts with grayscale symbols for the first receiver implementation.
- V1.5 adds direct RGB-to-bit mapping for all 8 legal DATA symbols.
- V1.5 mapping: R = bit 2, G = bit 1, B = bit 0.
- This keeps the first receiver implementation simple while preserving a clear upgrade path to RGB.

## 2026-08-28 — Optical DATA Frame Rate Deferred

- Exact optical DATA frame rate is not fixed yet.
- Candidate experiment rates include 30 FPS, 60 FPS, and other measured options.
- Final selection is deferred until future tests compare reliability, throughput, and camera capture behavior.

## 2026-08-28 — No START/END Robustness Variants

- Extra START/END robustness variants are not needed for the planned baseline.
- Keep the simple START and END frame definitions.
- Do not spend V1/V1.5 work on comparing repeated or redundant START/END patterns unless later test results show a real need.

## 2026-08-28 — V2 Sequence Number

- V2 should include a sequence number in DATA frames if the ECC-protected frame budget allows it.
- The sequence number is used to detect missed or repeated DATA frames.
- Exact bit width and placement should be decided together with the ECC/header layout.

## 2026-08-28 — UDP-Like Missed Frame Policy

- CubeOCC remains one-way, like UDP rather than TCP.
- If Camera 2 misses one or more DATA frames, the receiver ignores the missing data and continues.
- The receiver does not request retransmission and does not send feedback to the transmitter.
- Missed-frame events should be exposed through diagnostics, such as FPGA serial output or a status/debug pin.

## 2026-08-28 — Grid Benchmark Version Plan

- V1 starts with the 8x8 grid.
- V2 benchmarks grid sizes from 8x8 through 64x64.
- V3 extends larger grid benchmarks, potentially up to about 177x177.
- Benchmark results should be reported in tables, including throughput, reliability, symbol error rate, and resource usage.

## 2026-08-28 — Grid Size Configuration Plan

- V1 through V3 use static receiver grid-size configuration.
- The receiver is told ahead of time whether to decode 8x8, 16x16, 32x32, 64x64, etc.
- V4 adds active grid-size detection so the receiver can infer the grid dimensions from the captured image.
- Static configuration remains useful as a fallback/debug mode.

## 2026-08-28 — Grid Size Fixed Per Transfer For V1-V3

- V1 through V3 keep one grid size for an entire transfer.
- Changing grid size during a transfer is considered too complex for the near-term versions.
- Mid-transfer grid-size adaptation is deferred as possible V4/V5 research.

## 2026-08-28 — Protocol-First Camera Target

- Do not lock the design to one physical camera sensor yet.
- V1 starts with generic DVP image-transfer behavior.
- MIPI is not optional/dismissed; it is a required later investigation for physical camera selection.
- ROI/windowing is primarily a camera sensor/register capability, not only a DVP-vs-MIPI transport feature.
- The physical camera module can be chosen later if it matches the required protocol, timing, voltage, register control, and ROI/window behavior.

## 2026-08-28 — Camera Register Control Bus

- V1 uses I2C for camera register control.
- SCCB compatibility may be added in V4 if the chosen physical camera requires it.
- Pixel transport remains separate: DVP for the first path, with MIPI investigated later if needed.

## 2026-08-28 — V1 Models Both DVP And MIPI Pixel Streams

- V1 simulation should include both DVP and MIPI-style camera pixel streams.
- The project will compare camera/module availability and ROI/windowing flexibility before choosing the final physical path.
- After that choice, the unused physical path can be dropped to keep implementation focused.

## 2026-08-28 — Camera-Side ROI Required

- ROI/windowing must happen on the camera/sensor side.
- Camera 1 is the ROI/tracking camera: it captures the full scene at lower resolution in grayscale and finds the four corner markers.
- Camera 1 feedback is used to compute ROI/window settings for Camera 2.
- Camera 2 is the data camera: it applies ROI/windowing on the sensor side and outputs only selected data pixels.
- V1 starts with grayscale data-camera processing; V1.5 upgrades Camera 2 data symbols to RGB.
- V1 should not depend on full Camera 2 frame capture followed by FPGA-side cropping.

## 2026-08-28 — Denoise Plan

- V1 starts with simple processing and only adds filtering if measured errors require it.
- Candidate V1 options: bypass, simple sharpening, or Gaussian-style smoothing.
- V1.5/V2 may investigate wavelet-based denoise depending on the resource budget after V1.

## 2026-08-28 — Sampling Radius Sweep

- V1 sampling uses circles centered on detected box/cell centers.
- Circle radius is based on the average box/cell size for the active grid.
- V1 will test small, medium, and large circular sampling regions.
- Sweeps should be run per supported grid size.
- Defaults should be selected from measured error results rather than fixed by assumption.

## 2026-08-29 — V2 Calibrated RGB Classification

- V1 remains grayscale/on-off for the baseline receiver.
- V1 processing is averaging-only over the selected cell sampling circle.
- V1.5 upgrades to RGB threshold/classification logic.
- V2 should investigate calibrated RGB classification using an offline-trained SVM.
- Train the SVM in Python using whole-image statistics and per-cell statistics such as average value and variance.
- The FPGA should not run Python; it should implement the trained model representation or equivalent learned decision behavior.

## 2026-08-29 — Hamming ECC Starting Point

- V1 should use a normal/simple fast Hamming baseline first.
- Do not block progress on selecting one fixed final Hamming mode.
- Broader Hamming/BCH comparisons remain useful later after the sender/receiver pipeline is stable.

## 2026-08-29 — ECC Mode Roles

- No ECC is used to test the raw BPS/throughput limit of the FPGA/data path.
- Hamming is the faster ECC path.
- BCH is the more trusted/reliable ECC family.
- Test all BCH candidates listed in `07_ECC_AND_METRICS.md`, then choose the best BCH mode from future results.

## 2026-08-29 — Shortened Codes And Padding Use

- Shortened ECC candidates can be tested later, but they should not be the first complexity added.
- First check whether padding bits from standard ECC packing can carry frame numbers, sequence metadata, headers, or experiment flags.
- This may provide better use of the 177-bit frame without immediately implementing shortened block codes.

## 2026-08-29 — V1 Packet/Header Format

- V1 uses no extra packet/header format inside the ECC-protected payload.
- START, DATA, and END frames are enough for message framing.
- Do not add CRC/checksum in V1 if Hamming ECC is already used.
- Revisit sequence number placement when testing other ECC methods.

## 2026-08-29 — No V1 CRC

- CRC/checksum is not included in V1 when Hamming ECC is used.
- Revisit CRC only if later ECC tests show extra detection is needed.

## 2026-08-29 — Single Pipeline Performance Deferred

- It is not known yet whether one processing pipeline meets the target frame rate.
- Decide after one full streaming pipeline is implemented and synthesized.
- Use synthesis timing/resource results before deciding whether parallel workers are needed or how many workers would be required.

## 2026-08-29 — Overflow Buffering Direction

- If every worker is busy when a new frame begins, use one shared one-frame overflow buffer.
- The overflow buffer saves only one incoming picture/frame.
- Hold the buffered frame until a worker becomes free, then offer/release it to that worker.
- If another frame arrives while the one-frame overflow buffer is already full, raise an overflow flag.
- Exact memory type and overflow-flag reporting path are deferred to a later phase.
- Sensor/backpressure and frame drop remain fallback options if buffering is not practical.
