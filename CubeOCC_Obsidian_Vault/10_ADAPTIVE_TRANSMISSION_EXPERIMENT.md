---
project: CubeOCC
type: optional-experiment
status: future
last_reviewed: 2026-08-22
---

# Adaptive Transmission Experiment

Optional research work, not core V1-V3.

## Goal

Explore grid-size selection depending on channel quality.

Version boundary:

- V1 starts with static 8x8.
- V2 benchmarks static grid sizes from 8x8 through 64x64.
- V3 extends larger static benchmarks up to about 177x177 if practical.
- V4 adds active grid-size detection.
- V4/V5 may investigate changing grid size during a transfer.

Larger grids increase bits per optical frame but reduce camera pixels per optical cell and can increase classification error.

## Known reference payload

Before real DATA, optionally transmit a known test pattern that both sides already know.

Receiver/testbench can calculate:

- raw BER
- symbol confidence
- ECC correction count

Then select grid size using simple rules, no machine learning required.

Example:

```text
if quality >= HIGH_THRESHOLD:
    use 32x32
elif quality >= MEDIUM_THRESHOLD:
    use 16x16
else:
    use 8x8
```

## Compare

- fixed 8×8
- fixed 16×16
- fixed 32×32
- fixed 64×64
- larger V3 benchmark grids
- optional adaptive mode

Measure throughput, goodput, BER, post-ECC BER, distance, angle, brightness and camera resolution/FPS.
