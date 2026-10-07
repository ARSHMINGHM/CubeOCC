---
project: CubeOCC
type: working-notes
status: working-notes (not source-of-truth; does not change 01_CONFIRMED_REQUIREMENTS)
last_reviewed: 2026-10-07
---

# V2 dynamic_threshold_sampler: baseline findings (working notes)

Purpose: let anyone retrace how the first cell-level baseline of
`dynamic_threshold_sampler.sv` was obtained and what is still unverified.
No RTL was changed in this step.

## Data

- 62 capture sets, 807 grayscale frames (61 sets x 13 frames, one set x 14).
- Manual frame-level labels (`symbols_review.json`): true 669, mid 19, false 119.
  A few labels are known to be wrong (the review tool has no undo).
- Golden message per frame index is **approximate**: per-index majority of
  frames graded `true`. It is consistent with the sender mapper (START all 1,
  4 white corners in DATA, CLK cell at row 0 / col 1 toggling 0,1,0,1..., END with
  BR and CLK off). The sender `*_frames.jsonl` was not available yet; replace the
  golden with it via `--golden-jsonl` as soon as it is found.

## Cell-level baseline (`dataset/cell_error_report.py`, approximate golden)

- 51,648 cells, 1,926 errors = 3.73 %.
- 1,883 black-read-as-white vs 43 white-read-as-black (98 % one direction).
- 28 of 62 sets have zero errors; the 10 worst sets hold 84 % of the errors.
- Worst sets: 055, 038, 039, 037, 026 (28-34 %), 048 (16 %), 020 (6.4 %),
  022, 054, 044.
- Frame alignment uses a monotonic DP. Six false-labeled frames in 026/038/039
  may be mis-aligned (nearly all cells read white); do not trust them until the
  sender golden is available.

## Observations about the sampler (from RTL reading + Python replay of results.json)

1. Threshold = (mean of the 4 corner **full-cell** averages of the first valid
   frame after reset) / 2, then frozen. Assumes black level = 0.
2. The learning (START) frame is classified with the reset threshold (128),
   not the learned one (non-blocking update). Seen on `MLCAP_002` (learned 65,
   START read as 63 ones). To be confirmed with the new `thresh_used` column.
3. `sampler_state` / `dynamic_thresh` in `results.json` are logged after the
   update, so the learning frame shows state 2; the note in
   `run_cubeocc_top_image_sim.py` is misleading.
4. `grid_corner_frame_guard` already learns white from START (5/8 of the weakest
   corner) and flags START/DATA/END, but `dynamic_threshold_sampler` does not use it.
5. Failure modes in the worst sets (replayed from the warped PNGs):
   - strong bloom in 026/037/038/039/055: black cells read ~50-65 % of white and
     overlap with white cells, so no global threshold separates them;
   - fixed glare patch in 020 at cells 27, 28, 35, 36, 59;
   - 048 is Cam30/Opt60 (frame-rate/content mismatch), not a threshold problem.
6. Threshold schemes tried offline on 14 sets (77 DATA frames each group, corner
   cells excluded, approximate golden), bad bits:

   | scheme | sets 001-007 | worst sets (020,026,037,038,039,048,055) |
   |---|---|---|
   | current (START/2, frozen) | 52 | 1618 |
   | 5/8 of weakest START corner, frozen (guard style) | 34 | 1362 |
   | per-frame (min+max)/2 of data cells | 41 | 472 |
   | per-frame 2-means of data cells | 42 | 380 |

   A per-frame threshold helps most; a linear neighbor-bloom model on top of it
   added little (ceiling with true bits still left 54 of 77 frames wrong).
   Not validated on all 62 sets.

## Open items

- [ ] Sender `*_frames.jsonl` to replace the approximate golden.
- [ ] Run the extended testbench (guard columns, `thresh_used`) and confirm item 2.
- [ ] Armin/Mohsen: Defocus sets (037, 038, 039, 055) dropped from training or kept
      as hard test. Current lean: keep as hard test.
- [ ] Feature choice for the SVM stays with the feature document; compare on all
      sets, split by capture set.
