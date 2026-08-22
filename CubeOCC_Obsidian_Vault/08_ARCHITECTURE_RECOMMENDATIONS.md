---
project: CubeOCC
type: recommendations
status: advisory
last_reviewed: 2026-08-22
---
# Architecture Recommendations

> [!warning]
> These are recommendations, not confirmed requirements.

## Use BRAM/URAM/streaming for substantial image storage
The original idea prefers FFs/latches because FPGAs have many registers. For real image-sized RGB data this becomes extremely expensive. Better default: crop ROI early, use BRAM/URAM banks and line buffers, and reserve FFs for control/small metadata.

## Calibrate the two camera coordinate systems
A fixed pixel offset may not cover scale, lens distortion and perspective. Use a calibrated transform/homography if future hardware permits.

## Get one pipeline correct before three full workers
Streaming/dataflow already creates FPGA parallelism. Replicate workers only after a one-worker baseline is measured.

## Use markers as a white reference
The white corner markers can help estimate local brightness/channel gains and detect saturation.

## Handle glare by avoiding bad pixels first
For the MVP: saturation rejection + center sampling + normalization + ECC is more realistic than reconstructing heavily saturated content.

## Add a protected frame sequence number
The optical CLK helps with identical adjacent frames but cannot detect every multi-frame loss pattern.

## Make START/END detection stateful
Use protocol state + marker geometry + brightness pattern + confidence, not image color alone.
