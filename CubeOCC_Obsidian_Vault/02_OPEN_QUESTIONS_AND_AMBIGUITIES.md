---
project: CubeOCC
type: open-questions
status: active
last_reviewed: 2026-08-22
---
# Open Questions and Ambiguities

## Frame protocol
- [ ] Exact CLK cell coordinate?
- [ ] Does START literally override all 64 cells to white, including the CLK position?
- [ ] Should START and END be repeated for robustness, or exactly one transmitted optical frame each?
- [ ] Are Black and White both legal payload symbols during normal DATA? Current understanding: yes.
- [ ] How is accidental false START/END detection prevented?
- [ ] Is there a sequence/frame number inside the protected 177 coded bits?
- [ ] Is the optical link permanently one-way, or will ACK/retransmission be explored later?

## Cameras
- [ ] Is Camera 1 expected to run faster than Camera 2?
- [ ] Should Camera 1 estimate blur/glare/exposure confidence as well as ROI?
- [ ] Exact calibration method between cameras?
- [ ] Can Camera 2 crop to ROI before most buffering?

## Buffering/parallel workers
- [ ] Exact retained frame depth? Original description appears to imply roughly 3 retained frames.
- [ ] Are all 3 workers complete identical pipelines?
- [ ] Is FF/latch frame storage a hard requirement or only an idea to test?
- [ ] What is the overflow policy if capture is faster than processing?

## Image processing
- [ ] Baseline denoise algorithm?
- [ ] Baseline glare strategy?
- [ ] Recompute warp every frame or reuse it while stable?
- [ ] Fixed or adaptive sampling radius?
- [ ] Color decision metric: raw RGB distance, normalized RGB, or channel thresholds?

## ECC/packetization
- [ ] Exact Hamming variants?
- [ ] Exact BCH code parameters?
- [ ] Does ECC stay within each optical frame or span frames?
- [ ] CRC needed in addition to ECC?
- [ ] How are payload length and file boundaries represented?

## Testbench
- [ ] AXI4-Stream Video, custom pixel timing, or another simulated camera interface?
- [ ] Should skipped/duplicate frames and timing jitter be injected?
- [ ] Final dataset naming and CSV schema?
