---
project: CubeOCC
type: verification
status: draft
last_reviewed: 2026-08-22
---
# Simulation and Testbench

## Objective
Make the testbench act like a real button + two camera sources rather than a perfect image-function caller.

## Initial dataset
Use phone captures of a generated LED/screen grid on a laptop/display under labeled conditions such as angle, distance, glare, brightness, blur, exposure, and color shift.

## Suggested flow
```mermaid
sequenceDiagram
participant TB as Testbench
participant DUT as FPGA/HLS DUT
participant LOG as Results logger
TB->>DUT: simulated button press
TB->>DUT: grayscale camera pixel stream + timing
TB->>DUT: RGB camera pixel stream + timing
DUT->>LOG: decoded symbols/bits/status
TB->>LOG: ground truth + condition labels
LOG->>LOG: BER / frame errors / throughput / accuracy
```

## Camera-like interface options
- AXI4-Stream Video style.
- Custom `pixel_valid`, `line_valid`, `frame_valid`, `frame_start`.
- HLS streams preserving real pixel order and frame boundaries.

## Faults to simulate
- [ ] repeated payload image with CLK change
- [ ] duplicate capture
- [ ] skipped capture
- [ ] camera timing offset
- [ ] noisy/missing marker
- [ ] false dark/END-like frame
- [ ] saturated/glare cells
- [ ] severe perspective
- [ ] wrong white balance
- [ ] slightly wrong ROI

## Suggested CSV columns
```csv
run_id,frame_id,condition,grid_size,ecc_mode,denoise_mode,warp_mode,marker_ok,start_ok,end_ok,tx_bits,rx_bits,bit_errors,ber,symbol_errors,latency_cycles
```
