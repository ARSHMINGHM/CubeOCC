---
project: CubeOCC
type: roadmap
status: active
last_reviewed: 2026-08-28
---

# Version Roadmap

This note orders CubeOCC work from sender to receiver, based on the streaming pipeline.

## End-to-End Order

```text
Sender data
  -> frame encoder
  -> optical cube display
  -> camera capture
  -> camera ROI/window stream
  -> DVP input
  -> DVP-to-AXI bridge
  -> HLS/streaming processing
  -> grid/symbol recovery
  -> payload/ECC decode
  -> receiver output
```

## 1. Sender Data

- [ ] V1: choose simple grayscale payload source.
- [ ] V1: define first test messages / bitstreams.
- [ ] V1.5: expand payload source to RGB symbol data.
- [ ] V2: add packet/header structure for larger transfers.

## 2. Frame Encoder

- [ ] V1: generate grayscale/on-off DATA frames.
- [ ] V1: generate START and END frames.
- [ ] V1: include corner markers and CLK toggle.
- [ ] V1.5: add direct RGB-to-bit mapping:
  - R = bit 2
  - G = bit 1
  - B = bit 0
- [ ] V2: add optional sequence number or stronger frame metadata.

## 3. Optical Cube Display

- [ ] V1: simulate 8x8 grayscale frames as image files.
- [ ] V1: create image-folder dataset for sender frames.
- [ ] V1.5: generate RGB image frames for all 8 legal symbols.
- [ ] V2: benchmark larger grids such as 16x16 and 32x32.

## 4. Camera Capture / Simulation Input

- [ ] V1: convert sender images from folder to `.mem` files.
- [ ] V1: stream real image pixels through `dvp_camera_model`.
- [ ] V1: keep math pattern only for timing/ROI regression.
- [ ] V1.5: extend image memory format to RGB/channel-aware input.
- [ ] V2: add labeled datasets for distance, angle, blur, glare, exposure, and brightness.

## 5. Camera Control And ROI

- [ ] V1: use DVP as the primary physical camera interface.
- [ ] V1: keep both DVP and MIPI-style simulation paths available for camera comparison.
- [ ] V1: use I2C register writes for ROI/window setup.
- [ ] V1: verify fake camera ACK behavior in testbench.
- [ ] V1: confirm target real sensor supports required hardware ROI/windowing.
- [ ] V4: add SCCB compatibility if the chosen camera requires it.

## 6. DVP Input

- [ ] V1: receive `pclk`, `vsync`, `href`, and 8-bit `pixel_data`.
- [ ] V1: follow camera-model rule: drive simulated DVP outputs on `negedge pclk`.
- [ ] V1: verify pixel count, frame count, and line timing.

## 7. DVP-To-AXI Bridge

- [ ] V1: stream pixels through `dvp_to_axis`.
- [ ] V1: preserve `tvalid`, `tready`, `tuser`, and `tlast`.
- [ ] V1: avoid full raw-frame buffering.
- [ ] V1: verify 128x720 gives 92,160 pixels and 720 `tlast` line markers.

## 8. HLS / Streaming Processing

- [ ] V1: feed HLS pipeline through AXI4-Stream.
- [ ] V1: implement grayscale processing first.
- [ ] V1: measure bypass first, then sharpening/Gaussian only if needed.
- [ ] V1.5: add RGB threshold/classification logic.
- [ ] V2: decide whether one pipeline meets target frame rate after synthesis.
- [ ] V2: add optional parallel workers if one pipeline is not enough.

## 9. Grid / Symbol Recovery

- [ ] V1: detect 8x8 grid in grayscale.
- [ ] V1: sample each cube/cell from the ROI stream.
- [ ] V1: sweep sampling radius and document default.
- [ ] V1.5: recover RGB symbols using direct 3-bit mapping.
- [ ] V2: support larger static grids through 64x64.
- [ ] V3: extend large-grid benchmarks beyond 64x64.
- [ ] V4: add active grid-size detection.

## 10. Payload / ECC Decode

- [ ] V1: recover ordered grayscale payload bits.
- [ ] V1: verify START, DATA, CLK toggle, and END handling.
- [ ] V1.5: recover ordered RGB symbol bitstream.
- [ ] V2: compare Hamming, BCH, and shortened-code candidates.
- [ ] V2: revisit CRC only if ECC tests show extra detection is needed.

## 11. Receiver Output

- [ ] V1: output recovered bitstream or text payload.
- [ ] V1: report basic frame/pixel/symbol metrics.
- [ ] V1.5: report RGB symbol error rate.
- [ ] V2: report ECC correction statistics and missed-frame behavior.

## Ordered To-Do By Version

### V1 — Grayscale Baseline

Ordered from sender to receiver:

- [ ] Sender data: choose simple grayscale payload source.
- [ ] Sender data: define first test messages / bitstreams.
- [ ] Frame encoder: generate grayscale/on-off DATA frames.
- [ ] Frame encoder: generate START and END frames.
- [ ] Frame encoder: include corner markers and CLK toggle.
- [ ] Optical cube display: simulate 8x8 grayscale frames as image files.
- [ ] Optical cube display: create image-folder dataset for sender frames.
- [ ] Camera capture: convert sender images from folder to `.mem` files.
- [ ] Camera capture: stream real image pixels through `dvp_camera_model`.
- [ ] Camera capture: keep math pattern only for timing/ROI regression.
- [ ] Camera control: keep both DVP and MIPI-style simulation paths available for comparison.
- [ ] Camera control: use I2C register writes for ROI/window setup.
- [ ] Camera control: verify fake camera ACK behavior in testbench.
- [ ] Camera control: confirm target real sensor supports hardware ROI/windowing.
- [ ] DVP input: receive `pclk`, `vsync`, `href`, and 8-bit `pixel_data`.
- [ ] DVP input: verify pixel count, frame count, and line timing.
- [ ] DVP-to-AXI: stream pixels through `dvp_to_axis`.
- [ ] DVP-to-AXI: preserve `tvalid`, `tready`, `tuser`, and `tlast`.
- [ ] DVP-to-AXI: avoid full raw-frame buffering.
- [ ] HLS/processing: feed HLS pipeline through AXI4-Stream.
- [ ] HLS/processing: implement averaging-only grayscale processing first.
- [ ] HLS/processing: measure bypass first, then sharpening/Gaussian only if needed.
- [ ] Grid recovery: detect 8x8 grid in grayscale.
- [ ] Grid recovery: sample and average each cube/cell from the ROI stream.
- [ ] Grid recovery: sweep sampling radius and document default.
- [ ] Payload decode: recover ordered grayscale payload bits.
- [ ] Payload decode: verify START, DATA, CLK toggle, and END handling.
- [ ] Receiver output: output recovered bitstream or text payload.
- [ ] Receiver output: report basic frame/pixel/symbol metrics.

### V1.5 — RGB Symbols

Ordered from sender to receiver:

- [ ] Sender data: expand payload source to RGB symbol data.
- [ ] Frame encoder: add direct RGB-to-bit mapping.
- [ ] Frame encoder: use R = bit 2, G = bit 1, B = bit 0.
- [ ] Frame encoder: support all 8 legal RGB DATA symbols.
- [ ] Optical cube display: generate RGB image frames for all 8 legal symbols.
- [ ] Camera capture: extend image memory format to RGB/channel-aware input.
- [ ] HLS/processing: add RGB threshold/classification logic.
- [ ] Grid recovery: recover RGB symbols using direct 3-bit mapping.
- [ ] Payload decode: recover ordered RGB symbol bitstream.
- [ ] Receiver output: report RGB symbol error rate.
- [ ] Dataset testing: measure symbol error rate under brightness, blur, angle, and exposure changes.

### V2 — Robust / Scaled System

Ordered from sender to receiver:

- [ ] Sender data: add packet/header structure for larger transfers.
- [ ] Frame encoder: add optional sequence number or stronger frame metadata.
- [ ] Optical cube display: benchmark grid sizes from 8x8 through 64x64.
- [ ] Camera capture: add labeled datasets for distance, angle, blur, glare, exposure, and brightness.
- [ ] HLS/processing: decide whether one pipeline meets target frame rate after synthesis.
- [ ] HLS/processing: add optional parallel workers if one pipeline is not enough.
- [ ] Grid recovery: support larger grids up to 64x64.
- [ ] Payload/ECC decode: compare Hamming, BCH, and shortened-code candidates.
- [ ] Payload/ECC decode: revisit CRC only if ECC tests show extra detection is needed.
- [ ] Payload/ECC decode: evaluate sequence numbers for missed-frame detection.
- [ ] Receiver output: report ECC correction statistics and missed-frame behavior.

## Current Direction

```text
V1   = grayscale, DVP + MIPI-style simulation comparison, I2C ROI, AXI stream, image-backed simulation
V1.5 = RGB symbols and RGB-aware simulation/processing
V2   = robustness, static grid scaling through 64x64, ECC comparisons, parallelism decision, SVM calibration
V3   = extended grid benchmarks beyond 64x64
V4   = active grid detection and SCCB compatibility if needed
```

## V3 — Extended Grid Benchmarks

Goal: compare larger grid sizes after the V1/V2 receiver is stable.

- [ ] Benchmark 16x16, 32x32, 64x64, and larger grids.
- [ ] Extend benchmark range up to about 177x177 if practical.
- [ ] Report throughput, reliability, symbol error rate, and resource usage in tables.
- [ ] Use results to choose practical physical grid sizes.

## V4 — Active Grid Detection

Goal: remove the need to preconfigure the receiver grid size.

- [ ] Detect active grid dimensions automatically from the captured image.
- [ ] Decide whether the observed frame is 8x8, 16x16, 32x32, 64x64, or another supported size.
- [ ] Compare automatic detection against the static configuration used in V1-V3.
- [ ] Keep static configuration available as a fallback/debug mode.

## V4/V5 — Optional Adaptive Grid Size

Goal: investigate whether changing grid size during an active transfer is worth the added complexity.

- [ ] Keep V1-V3 fixed to one grid size per transfer.
- [ ] Study whether mid-transfer grid-size changes are useful enough for V4 or V5.
- [ ] If pursued, define how the sender announces a grid-size change.
- [ ] If pursued, define how the receiver resynchronizes after the change.
