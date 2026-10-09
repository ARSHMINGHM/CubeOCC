---
project: CubeOCC
type: working-notes
status: working-notes (not source-of-truth; does not change 01_CONFIRMED_REQUIREMENTS)
last_reviewed: 2026-10-09
---

# V2 dynamic_threshold_sampler: baseline and classifier comparison (working notes)

Purpose: let anyone retrace how the cell-level baseline of
`dynamic_threshold_sampler.sv` was measured and compared with simple
alternatives. No RTL was changed in this step.

## Data

- 62 capture sets x 13 frames = 806 grayscale frames (a stray duplicate
  `frame_9.png` in MLCAP_054 was removed; MLCAP_044 had a non-padded
  `frame_9.png` that sorts after `frame_12.png` in plain string order).
- Manual frame-level labels (`symbols_review.json`): true 669, mid 19, false 119
  (807 labels from the first run). A few labels are known to be wrong.
- Golden message per frame index is **approximate**: per-index majority of frames
  graded `true`. It matches the sender mapper structure (START all 1, 4 white
  corners, CLK cell row 0 / col 1 toggling, END with BR and CLK off). The golden is
  built from the same labels it scores, so "frames graded true have ~0 errors" is
  by construction. Replace it with the sender `*_frames.jsonl`
  (`--golden-jsonl`) when available.

## Cell-level baseline (`dataset/cell_error_report.py`)

- All cells (START/END/corners included): 51,584 cells, 1,993 errors = 3.86 %;
  1,943 black-read-as-white vs 50 white-read-as-black.
- Payload cells of DATA frames only (corners excluded): 4.72 %.
- 29 of 62 sets have zero errors; the 10 worst sets hold 87 % of the errors.
- Worst sets: 038, 039, 026, 055, 037 (30-38 %), 048 (16 %, Cam30/Opt60), 020, 022.

## Sampler observations (new testbench columns, 806/807 frames)

1. Confirmed: in all 62 sets the first frame is classified with state 1 and
   `thresh_used = 128` (reset value); all later frames use the learned threshold.
   One START frame (MLCAP_002) is visibly damaged by it.
2. `grid_corner_frame_guard` works: 49 of 62 sets give START, 11 x DATA, END. It
   discarded 22 frames (reason DARK_CORNER); the weakest corner was BL in 17 of
   them. Cell 56 (bottom-left marker) has a 2.5 % error rate vs 0.1-0.7 % for the
   other corners, so the BL corner is systematically darker (ROI/warp or
   vignetting; not yet investigated).
3. The sampler learns its threshold as (mean of 4 corner full-cell averages) / 2,
   frozen; it ignores the guard's START validation and its 5/8 white threshold.
4. Frame order matters for the guard FSM: the stray `frame_9.png` made the guard
   report START after END in 044 and 054.

## Classifier comparison (`dataset/svm_cv_report.py`)

Leave-one-capture-set-out, 62 sets, 40,920 payload cells (DATA frames, corners
excluded). "Worst" = 10 sets with the largest current-sampler error (chosen
automatically). Payload cell error %:

| method                                         | all  | worst 10 | others | all, with option-4 filter |
| ---------------------------------------------- | ---- | -------- | ------ | ------------------------- |
| A current sampler                              | 4.72 | 25.91    | 0.65   | same                      |
| B per-frame 2-means threshold (no training)    | 1.39 | 6.42     | 0.43   | 1.32                      |
| C SVM raw [mean, var, max, min, neighbor]      | 1.74 | 8.24     | 0.49   | 1.04                      |
| D SVM mean only                                | 3.02 | 14.91    | 0.73   | 1.22                      |
| E SVM 5 features / frame white reference       | 1.09 | 5.23     | 0.29   | 1.15                      |
| F SVM mean + neighbor relative to frame levels | 1.17 | 5.35     | 0.36   | 1.16                      |
| G SVM C + white + 2-means levels               | 1.46 | 7.82     | 0.24   | 0.99                      |
| H SVM mean / white only                        | 1.62 | 8.27     | 0.34   | not run                   |
| I SVM mean / white + neighbor / white          | 1.14 | 5.64     | 0.27   | not run                   |
| J SVM E without the neighbor feature           | 1.32 | 6.53     | 0.32   | not run                   |

Reading (cautious: golden is approximate, errors are clustered by set, and
differences of ~0.2 points are within noise):

- A frame-level reference (per-frame threshold, or features normalised by the
  frame's white level) removes about 75 % of the current error.
- A plain per-frame 2-means threshold already beats the raw-feature SVM (1.39 vs
  1.74 without filter).
- The option-4 filter (median, background subtraction, autocontrast, unsharp)
  helps the raw SVM (1.74 -> 1.04) but not the already-normalised ones: its effect
  looks like frame normalisation. It costs line buffers and a percentile; the
  white-reference normalisation needs only the corner cells.
- The worst 10 sets still sit at ~5 % for the best methods (bloom/defocus).
- The earlier single-split result (2.01 % vs 3.73 %) is not comparable: unseeded
  12-set split vs a baseline over all cells of all 62 sets.
- Paired bootstrap over capture sets (8000 resamples, differences in payload error
  points, 95 % interval), unfiltered run:
  - per-frame 2-means vs current sampler: -3.3 [-6.0, -1.0] (clear);
  - neighbor feature on top of mean/white (I - H): -0.48 [-1.01, -0.05];
  - neighbor feature on top of the 4 other features (E - J): -0.23 [-0.46, -0.05]
    (both stay negative without MLCAP_048 and without 048 and 055: a small but
    consistent gain from the neighbor feature);
  - white-referenced SVM vs plain per-frame 2-means (E - B): -0.31 [-0.70, +0.03],
    not distinguishable; raw SVM vs 2-means (C - B): +0.34 [-0.17, +1.13], not
    distinguishable.
- Hard sets are unstable across variants: MLCAP_055 ranges from 3.5 % (F) to 43 %
  (D), 038 from 3.5 to 27 %, 026 from 8.9 to 24 %, 039 from 4.1 to 19 %. F (two
  features relative to the frame levels) is the most stable on the Defocus sets and
  has the best mean without 048 (0.92 %), but is worse than E on 012/015/020.
- MLCAP_048 (Cam30/Opt60) does not match the golden message; treat its numbers as
  unreliable.

## Open items

- [ ] Decide between a frame-level reference only (white reference or 2-means) and a
      linear classifier with the neighbor feature; the data say the frame-level
      reference is the main gain and the SVM adds little over it (not significant).
- [ ] Sender `*_frames.jsonl` to replace the approximate golden.
- [ ] Investigate the BL corner (cell 56, guard DARK_CORNER).
- [ ] Patch the sim runner with natural frame sorting; confirm MLCAP_044 naming.
- [ ] Armin/Mohsen: Defocus sets (037, 038, 039, 055) dropped from training or kept
      as hard test. Current lean: keep as hard test.
- [ ] Feature choice for the SVM stays with the feature document.
- [ ] RGB later; keep the linear kernel (a Gaussian kernel is expected to overfit).
