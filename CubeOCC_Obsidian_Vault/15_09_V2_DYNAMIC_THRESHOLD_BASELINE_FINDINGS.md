---
project: CubeOCC
type: working-notes
status: working-notes (not source-of-truth; does not change 01_CONFIRMED_REQUIREMENTS)
last_reviewed: 2026-10-13
---

> [!warning] Numbers in this note are historical
> The statistics below were computed with an **older golden** (before `MLCAP_054/frame_9.png` was removed from `symbols_review.json`) and with the **older RTL coefficients** (`WN2=-272, WN3=-181, WN4=-136, WW=-1126`).
>
> For the current, reproducible numbers — including the coefficient update, the golden change, and the bit-exact PASS — use [[15_14_V2_SCRIPT_OUTPUTS_LOG]].
>
> Quick differences:
>
> | Item                               |                 This file (historical) |                         Current (`15_14`) |
> | ---------------------------------- | -------------------------------------: | ----------------------------------------: |
> | Cell error, linear_rule + start    |                                 0.63 % |                                    0.80 % |
> | CV payload error, method I + start |        1.14 % (mean4) / 0.91 % (start) |           1.69 % (mean4) / 1.31 % (start) |
> | Ambiguity flag recall              |                                   89 % |                                    81.6 % |
> | Ambiguity flag FPR                 |                                  3.0 % |                                     2.7 % |
> | RTL coefficients                   | WN2=-272, WN3=-181, WN4=-136, WW=-1126 |    WN2=-248, WN3=-165, WN4=-124, WW=-1086 |
> | `symbols_review.json` entries      |                                    807 | 806 (one `MLCAP_054/frame_9.png` removed) |
>
> The trends and conclusions below remain valid. The exact percentages shifted because the golden was rebuilt.

# V2 dynamic_threshold_sampler: baseline and classifier comparison (working notes)

Purpose: let anyone retrace how the cell-level baseline of
`dynamic_threshold_sampler.sv` was measured and compared with simple
alternatives. No RTL was changed in this step.

## Data

- 62 capture sets x 13 frames = 806 grayscale frames (MLCAP_054 had both `frame_09.png`
  and `frame_9.png`; one file was removed and `frame_9.png` is the one that remains).
  A non-padded `frame_9.png` sorts after `frame_12.png` in plain string order, which
  scrambled the processing order of MLCAP_044 (renamed since) and MLCAP_054 (not yet).
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

## RTL: linear rule sampler (`rtl/linear_rule_sampler.sv`)

Model I as a division-free integer rule (frame white reference = mean of the 4
corner sums, plus the cell sum and the neighbour sums); corners are forced to 1 in
DATA frames, START and END words are emitted from `grid_corner_frame_guard`
decisions (`m_axis_tuser` = frame kind). Constants (12-bit) come from
`dataset/export_linear_rule.py` trained on all 62 sets (so the RTL numbers below are
in-sample; the cross-validated figure is 1.14 %).

- XSim: compiles and runs on all 806 frames; `check_linear_rule_rtl.py` reports 0
  mismatches against the integer model for every frame kind (START 63, DATA 659,
  END 61, discarded DATA 22, ignored 1).
- `cell_error_report.py` on the RTL output, all cells: 435 errors = 0.84 % (was
  3.86 %), 380 black-as-white and 55 white-as-black; 38 of 62 sets without errors.
  This is not directly comparable with 3.86 %: START, END and the corners (about
  21 % of the cells) are now decided by the guard / protocol. Payload cells only,
  the error is at most 435 / 40,920 = 1.06 % (all errors counted as payload).
- Worst sets now: 026 (10.7 %), 055 (9.1 %), 039 (5.2 %), 048 (4.8 %), 054 (3.7 %),
  038 (3.5 %), 033 (2.9 %), 020 (2.3 %), 022 (2.2 %), 037 (1.7 %).
- Not measured: FPGA resources (no synthesis run yet), timing closure.
- Frame kinds per set (`check_linear_rule_rtl.py`): 50 of 62 sets give S, 11 x D, E.
  The 63 START / 61 END counts come from two sets:
  - MLCAP_033: the END frame is not recognised (kind x, discarded DATA);
  - MLCAP_054: S D x9 E i S is a processing-order artefact. The sim runner still sorts
    file names as plain strings, so `frame_9.png` is processed after `frame_12.png`:
    frame_11 -> END, frame_12 -> ignored, frame_9 (a DATA frame) -> START. The forced
    all-ones START word then gives 30 wrong cells for that frame. Evidence: per-frame
    errors (frame_9: 30 black-as-white, frame_11 equals the END word, frame_12 has one
    wrong cell) and the string-sort order reproduces the S D x9 E i S sequence exactly.
    The guard accepts any frame as START while inactive if its average is >= 96 and the
    corners are bright; on the 14 local sets 115 of 143 DATA frames pass that test, so only
    the frame order protects the START decision.
- The 22 discarded DATA frames (kind 4) are spread over 11 sets (002, 012, 022, 023,
  025, 026, 029, 039, 043, 055 and the END of 033); the weakest corner was BL in 17
  of them. Whether their payload is as accurate as accepted frames is not measured
  yet (needs per-frame errors joined with `symbols_kind`).

## After renaming 054 `frame_9.png` -> `frame_09.png` (second linear run)

- Frame kinds for MLCAP_054 are now S D x10 E i: the trailing START is gone, but
  frame_11 (a DATA frame with a mostly black payload) is still taken as END and the
  real END (frame_12) is ignored. In the previous run frame_11 had corner averages
  160 / 87 / 88 / 64 (TL / TR / BL / BR) with a learned white of 210, i.e. a
  `dynamic_white_threshold >> 1` of 65: BR was one count below the END limit. The
  cell-error report can hide this because its alignment matches frame_11 to the END
  word. The END test uses an absolute limit (about 0.31 x white); true END frames
  in this run have BR / min(other corners) <= 0.19, the false one 0.73.
- MLCAP_033: the END capture itself is partial (TL average 7), so its x is not a
  guard threshold problem.
- `--white-ref bilinear` (white reference interpolated from the 4 corners per cell)
  is worse than the mean of the 4 corners on all 62 sets: 1.32 % vs 1.14 %
  cross-validated payload error. Not adopted; the RTL keeps mean4.

## What the photos show (MLCAP_022 frame_03, MLCAP_054 frame_11)

Luminance measured on the original JPGs (not on the warped 160x120 frames):

- MLCAP_054 frame_11: TL / TR / BL markers 227 / 225 / 224, BR marker 173, data cells
  that should be white 123-132, black 8. This looks like a display update caught
  half-way from DATA 11 to END: cells white in 11 but black in END (BR and the top-row
  data cells) are partly dark, the top more (0.55) than the bottom (0.77 at BR), and the
  markers that stay white are full white. The guard calling it END is therefore not a
  plain threshold error; a blended frame is neither DATA nor END. The earlier proposal
  of a relative-BR END test is withdrawn: it would turn this frame into DATA with
  unreliable cells.
- MLCAP_022 frame_03: white is 223 on the right, 148 / 142 on the left (TL cell, BL
  block), BR marker 178; cells that should be black read 5 to 70. The left side is
  about 0.65 of the right: a viewing-angle brightness gradient. With the mean of the 4
  corners as white reference (about 173) a white cell with white neighbours needs about
  154, so white cells on the left (about 145) read black. This matches the errors at
  cells 48-50 and 57-59 in 022 and 023.
- Probe on the 14 local sets (black cells misread as white with a fixed 0.5 x white
  threshold): in the hard sets 67 % when the cell was white in the previous frame vs 67 %
  when it was black, so temporal ghosting does not explain the hard sets (they look like
  a global black-level lift, weakly neighbour dependent); in the easy sets 2.1 % vs 0.4 %.
- Open: `export_linear_rule.py --white-ref start` (per-cell white map taken from the
  START frame, no interpolation) is implemented; on the 14 local sets it gives 2.75 %
  vs 2.77 % for mean4 (they have no strong gradient); the 62-set run decides.

## RTL with the per-cell START white map (`--white-ref start`)

> [!note] Historical coefficients
> The RTL coefficients quoted in this section are the **old set** (`WN2=-272, WN3=-181, WN4=-136, WW=-1126`). The current RTL uses (`WN2=-248, WN3=-165, WN4=-124, WW=-1086`) from [[15_14_V2_SCRIPT_OUTPUTS_LOG]]. The qualitative behavior is the same; only the exact numbers below are historical.

- Cross-validated payload error (62 sets, leave-one-set-out): 0.91 % vs 1.14 % for mean4
  and 1.32 % for bilinear corners.
- XSim run on all 806 frames, `check_linear_rule_rtl.py`: 0 mismatches against the
  integer model for every kind (START 62, DATA 660, END 61, discarded DATA 22, ignored 1).
  Constants (12-bit): WC 2047, WN2 -272, WN3 -181, WN4 -136, WW -1126 (WW multiplies the
  START sum of the same cell).
- `cell_error_report.py` on the RTL output: 327 wrong cells of 51,584 = 0.63 % (0.84 %
  with the mean4 reference, 3.86 % with the original sampler); 244 black-as-white, 83
  white-as-black; 38 of 62 sets without errors. Payload cells only: at most
  327 / 40,920 = 0.80 % (the RTL constants are fitted on the same sets, so this is
  in-sample; the cross-validated figure is 0.91 %).
- Worst sets: 048 (7.9 %), 026 (6.0 %), 038 (4.9 %), 033 (2.9 %), 039 (2.5 %), 037 (2.4 %),
  015 (2.0 %), 020 (1.9 %), 022 (1.7 %). 055 fell from 9.1 % to 0.12 %; 037 and 038 got a
  little worse than with mean4.
- Where the remaining errors are: MLCAP_048 (content mismatch) 66 of 327; eight frames with
  9 or more wrong cells hold about 116 more (015 f3, 026 f8 and f10, 030 f3, 033 f9, 037 f2,
  038 f1, 047 f11). Several of these are transition captures: 038 f1 is closer to the START
  word (13 cells) than to its own golden frame (25), 033 f9 is closer to frame 8 (10) than
  to frame 9 (21), and 047 f11 is 2 bits from END (an alignment artefact, not a decoding
  error). Cells 1, 2, 3, 12, 21, ... are wrong in frame_03 of three different sets (015,
  030, 048) for an unknown reason.
- Risk: the START map is copied from whatever frame the guard accepts as START.

## Ambiguous-frame flag (kind 5) in `linear_rule_sampler.sv`

Rule: a DATA frame with at least 3 payload cells whose |score| < (|WW| x S_white) >> 3
(about 0.069 x white) is reported with `m_axis_tuser = 5` instead of 2; the 64-bit word is
unchanged, so the cell errors are the same as before (327 wrong cells, 0.63 %).

- `ambiguity_report.py` on the 62 sets (048 excluded): counting all uncertain cells (U)
  beats counting only cells that changed since the previous frame (T), the opposite of
  what the 13 local sets suggested. U at delta 0.07, N >= 3: 8.3 % of frames flagged,
  3.2 % of good frames lost, 83 % of wrong cells removed, 73 % of the frames with >= 3 wrong
  cells caught (T: 5.2 %, 2.1 %, 64 %, 63 %).
- XSim run (`sim/cubeocc_top_all_ambig`): `check_linear_rule_rtl.py` reports 0 word
  mismatches (kinds: START 62, DATA 599, END 61, discarded 22, ambiguous 61). Counts
  rebuilt from the printed kind sequences and per-frame errors, all 62 sets: 61 of
