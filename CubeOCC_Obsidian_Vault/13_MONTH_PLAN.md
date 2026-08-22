---
project: CubeOCC
type: plan
status: proposed
last_reviewed: 2026-08-22
---

# Two-Person / One-Month Plan

## Week 1 — Protocol + golden model

**Person A:** frame generator, START/DATA/END, CLK, RGB bit mapping, no-ECC + Hamming baseline.

**Person B:** dataset tooling, four-marker detector, ROI geometry, threshold RGB classifier software model.

Exit: clean synthetic frame decodes, END verified, 177-bit packing understood.

## Week 2 — Sensor/testbench + streaming pipeline

**Person A:** camera register model, pixel-stream model, sensor ROI/window simulation.

**Person B:** streaming image processing, warp/grid extraction, RGB accumulators, sampling-radius debug visualization.

Exit: phone-captured input travels through simulated camera interface and DUT receives cropped ROI only.

## Week 3 — ECC + dataset experiments

**Person A:** multiple Hamming/BCH candidates, BER/post-ECC BER/goodput logging, synthesis resources.

**Person B:** bypass vs median, radius sweep, brightness/angle/blur/glare conditions, threshold tuning.

Exit: full START -> DATA -> END transfer and automatic CSV results.

## Week 4 — Optimize + paper material

- benchmark one pipeline
- only then test optional N-worker scaling if needed
- prepare ECC comparison table
- prepare radius/denoise/grid-size results
- test 8×8 and, if time permits, 16×16/32×32
- document limitations
- reproducible GitHub instructions
