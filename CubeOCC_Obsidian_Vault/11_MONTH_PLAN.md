---
project: CubeOCC
type: plan
status: proposed
last_reviewed: 2026-08-22
---
# One-Month / Two-Person Plan

## Week 1 — protocol + golden model
**Person A:** frame generator, START/DATA/END, CLK, ECC harness.  
**Person B:** dataset format, marker/ROI prototype, RGB symbol classifier.

Exit: clean synthetic frame generation and decoding; exact END pattern verified.

## Week 2 — camera-like image path
**Person A:** pixel-stream testbench, buffer FSM, scheduler skeleton.  
**Person B:** perspective/grid logic, denoise/normalization, center-radius sampling.

Exit: phone-captured frames flow through simulated camera timing and recover symbols.

## Week 3 — ECC + robustness + metrics
**Person A:** Hamming/BCH integration, logging, BER/goodput.  
**Person B:** glare/noise/angle dataset and algorithm sweeps.

Exit: complete START→DATA→END transfer with automatic metrics.

## Week 4 — FPGA-oriented optimization + documentation
**Person A:** HLS/dataflow/resource optimization, optional worker replication.  
**Person B:** regression tests, plots/tables, final documentation/demo.

Exit: reproducible simulation, GitHub instructions, benchmark table, documented limitations.
