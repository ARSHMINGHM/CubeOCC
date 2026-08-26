---
project: CubeOCC
type: decisions
status: active
last_reviewed: 2026-08-26
---

# Decision Log

## 2026-08-20 — Initial concept

Two-camera OCC receiver, grayscale ROI/feedback camera, RGB DATA camera, image processing + grid extraction + RGB cube symbols, Hamming/BCH testing, simulation-first.

## 2026-08-20 — 8×8 format

64 cells, 4 corner markers, 1 CLK, 59 payload/ECC cells, 177 coded bits.

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

V1 experiment: bypass vs 3×3 median. Adaptive denoise using confidence/ECC behavior is optional research.

## 2026-08-22 — Sampling radius

Configurable testbench parameter. Sweep and visualize it; choose default from BER/SER measurements.

## 2026-08-22 — Color classification

V1 simple RGB thresholds. V2 normalized RGB.

## 2026-08-22 — ECC table expanded

Compare no ECC, multiple Hamming codes and multiple BCH codes. Document useful payload per 177-bit frame and correction capability.

## 2026-08-23 — DVP First, MIPI Deferred

- Decision by Armin: Focus V1 physical implementation strictly on DVP.
- MIPI implementation on FPGA (D-PHY routing/debugging) can be complex and time-consuming.
- MIPI behavioral model is built and passing tests but is marked optional/V2 for physical integration.
- DVP is selected as the primary interface for the one-month V1 baseline.

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
