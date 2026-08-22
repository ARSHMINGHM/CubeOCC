---
project: CubeOCC
type: checklist
status: active
last_reviewed: 2026-08-22
---
# Verification Checklist

## Protocol
- [ ] 8×8 = 64 cells.
- [ ] DATA has 4 white corner markers.
- [ ] DATA has 1 dedicated CLK cell.
- [ ] DATA has 59 payload+ECC symbol cells.
- [ ] 59 × 3 = 177 coded bits.
- [ ] START = full bright white.
- [ ] END ordinary cells = black/off.
- [ ] END TL = white.
- [ ] END TR = white.
- [ ] END BL = white.
- [ ] END BR = off.
- [ ] END CLK = off.
- [ ] No note/report still says END has four white markers.
- [ ] No note/report still says END is simply fully black.
- [ ] CLK coordinate remains TBD until explicitly decided.

## Cameras
- [ ] Camera 1 = low-quality grayscale ROI/marker feedback.
- [ ] Camera 2 = RGB data path.
- [ ] Cross-camera offset/mapping is accounted for.
- [ ] Camera feedback can influence processing parameters.

## FPGA/image path
- [ ] Buffer/FIFO policy defined.
- [ ] Scheduler knows worker free/busy state.
- [ ] Scheduler assigns waiting images to workers.
- [ ] Denoise baseline/bypass exists.
- [ ] Glare/lighting baseline/bypass exists.
- [ ] Perspective/grid geometry is handled.
- [ ] Grid size is configurable.
- [ ] Center/radius RGB averaging is implemented.
- [ ] All 8 RGB symbols are classifiable.

## ECC/output
- [ ] Hamming tested.
- [ ] BCH tested.
- [ ] Multiple ECC strengths tested.
- [ ] Raw BER logged.
- [ ] Post-ECC BER logged.
- [ ] Throughput/goodput logged.
- [ ] Recovered bits are compared to ground truth.

## Simulation
- [ ] Simulated button exists.
- [ ] Camera-like pixel stream/timing exists.
- [ ] Labeled phone-capture dataset supported.
- [ ] CSV/TXT results generated.
- [ ] Duplicate/skipped frames tested.
- [ ] Special END pattern tested.

## Scope
- [ ] MVP fits two people / about one month.
- [ ] Stretch work separated from MVP.
