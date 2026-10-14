---
project: CubeOCC
type: architecture
status: confirmed-architecture
last_reviewed: 2026-10-14
parent: 15_TASK_BACKLOG
---

# V2 Classifier Pipeline Architecture

Exact placement of the classifier inside the pipeline, what changed, and what did not.

## Classifier position in the pipeline

```text
camera pixels
  └─► roi_start_detector          (Armin)
       └─► projective_warp_160x120  (Armin)
            └─► grayscale_grid_8x8   (Armin)   ← unchanged
                 │  grid_pixel_gray[7:0]
                 │  grid_cell[5:0]
                 │  grid_col[2:0]
                 │  grid_row[2:0]
                 │  grid_frame_done
                 ▼
            grid_corner_frame_guard  (Armin)  ← kind = START/DATA/END/discard
                 │
                 ▼
            linear_rule_sampler      (new, replaces dynamic_threshold_sampler)
                 │
                 ▼
            symbols_data[63:0], symbols_kind[2:0]
```

## Important: what stayed exactly the same

- `rtl/grayscale_grid_8x8.sv` — literally Armin's file. No modifications.
- `rtl/roi_warp_grid_pipeline.sv` — the same module that wires ROI, warp, and grid.
- `rtl/projective_warp_160x120.sv` — the projective warp from commit `70d96ec`.
- `rtl/roi_start_detector.sv` — the V11 detector.

The `grid_pixel_gray` and `grid_cell` signals that reach the classifier are **literally Armin's RTL output**. There is no preprocessing stage between gridding and the classifier.

## The only thing that changed: the per-cell decision

| Aspect           | Old: `dynamic_threshold_sampler.sv` | New: `linear_rule_sampler.sv`                               |
| ---------------- | ----------------------------------- | ----------------------------------------------------------- |
| White reference  | `(mean of 4 corners) / 2`           | Per-cell map learned from the START frame (`start_sum[64]`) |
| Decision rule    | `sum_acc[c] > thresh * 81`          | `WC*S_c + WN[n]*sum(S_nb) + WW*S_start[c] > 0`              |
| Coefficients     | none (single threshold)             | 5 signed 12-bit constants: WC, WN2, WN3, WN4, WW           |
| Ambiguity flag   | none                                | kind=5 when at least 3 cells have a low absolute score      |
| Learning source  | none (rule-based)                   | LinearSVC trained on 62 capture sets                        |
| CV payload error | 4.72 %                              | **0.85 % after retraining on the latest RTL grid output**    |

## What the new algorithm actually is

This is **not a neural network**. It is a LinearSVC that has been rewritten as a division-free integer rule.

### Training stage (offline, Python)

For each cell in each DATA frame, three values are extracted:

- `mean` = average of the 81 pixels inside the central circular sampling region
- `nb` = average `mean` of the four neighbors (up/down/left/right)
- `white` = average of the 4 corners (mean4) or the same-cell value from the START frame

Feature vector = `[mean/white, nb/white]`

Then `StandardScaler` → `LinearSVC(C=1.0)` is trained with leave-one-capture-set-out over 62 capture sets.

### RTL stage (online, FPGA)

The float coefficients are rewritten as `sign(a*mean + b*nb + g*white)` (all divisions folded into the coefficients), then rounded to signed 12-bit integers:

```systemverilog
parameter signed [11:0] WC  = 12'sd2047;
parameter signed [11:0] WN2 = -12'sd255;   // corner, 2 neighbors
parameter signed [11:0] WN3 = -12'sd170;   // edge,   3 neighbors
parameter signed [11:0] WN4 = -12'sd127;   // center, 4 neighbors
parameter signed [11:0] WW  = -12'sd1168;  // white reference weight
```

Per-cell computation:

```text
score = WC * S_cell + WN[n] * Σ S_nb + WW * S_start[c]
bit   = (score > 0) ? 1 : 0
```

Where `S_*` are raw 81-pixel circle sums (not averages). The 1/81 and 1/n divisions are folded into WC and WN so no FPGA divider is needed.

## What `start_sum[64]` really is

That 64-register array is **not a neural network weight**. It is the per-cell white reference learned from the START frame:

```systemverilog
logic [14:0] start_sum [0:63];   // 64 registers, not 64 weights

// When a START frame is accepted:
if (lat_start) begin
    for (i = 0; i < 64; i = i + 1)
        start_sum[i] <= sum_acc[i];
    start_valid <= 1'b1;
end
```

**Why it's needed:** brightness gradients across the screen (viewing angle, vignetting) make the left and right sides of the display have different white levels. Example MLCAP_022: right side 223, left side 148. A single global threshold misses this. The START map calibrates the gradient per cell.

So the actual coefficients are the 5 signed integers above; `start_sum` is only a reference map used in one multiplication (`WW * S_start[c]`).

## FPGA resources after this change

Synthesis of `cubeocc_top` on `xc7a35tcpg236-1`:

| Resource        |  Used | Available | Percent |
| --------------- | ----: | --------: | ------: |
| Slice LUTs      | 9,233 |    20,800 |  44.4 % |
| Slice Registers | 4,308 |    41,600 |  10.4 % |
| Block RAM Tiles |     8 |        50 |  16.0 % |
| DSPs            |    17 |        90 |  18.9 % |

LUT split before merging, from `.vds`:

| Module                    | Raw LUT |
| ------------------------- | ------: |
| `projective_warp_160x120` |   6,350 |
| `roi_start_detector`      |   4,139 |
| `linear_rule_sampler`     |   3,416 |
| `grid_corner_frame_guard` |   2,494 |
| `grayscale_grid_8x8`      |     386 |

**DSP: 0 → 17.** 14 belong to the projective warp; 3 belong to the three `linear_rule_sampler` multipliers (WC, WN, WW). `grayscale_grid_8x8` added nothing since it is the same file.

## What is still not confirmed

- **Exact Fmax of `linear_rule_sampler`**: synthesis completed but timing report is not finalized. HDL ADVISOR emitted one warning: "operator resource `<adder>` is shared" at `linear_rule_sampler.sv:191`. Worth investigating.
- **Downstream use of kind=5**: ECC only sees the cell bits; the ambiguity flag must be handled by the control layer (retransmit or accept-with-warning).
- **Accurate golden**: current labels come from per-index majority of frames graded `true`, which means the golden is scored on the same frames it was built from. Must be replaced by the sender `*_frames.jsonl`.

## References

- `rtl/linear_rule_sampler.sv` — RTL implementation
- `linear_rule_start/rule.json` — official model output
- `dataset/export_linear_rule.py` — integer-coefficient exporter
- `dataset/check_linear_rule_rtl.py` — bit-exact RTL-vs-integer-model checker
- [[15_09_V2_DYNAMIC_THRESHOLD_BASELINE_FINDINGS]] — full baseline and comparison history
- [[15_11_V2_TRAINING_VALIDATION_COMMANDS]] — reproduction commands
- [[15_12_V2_WORK_LOG_DECISIONS_AND_REJECTIONS]] — what was tried and rejected
- [[15_18_LATEST_GRID_SVM_RETRAIN]] — latest dataset retraining and full RTL result
