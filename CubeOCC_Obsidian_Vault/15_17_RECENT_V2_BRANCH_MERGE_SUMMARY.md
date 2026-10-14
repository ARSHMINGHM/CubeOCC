---
project: CubeOCC
type: merge-guide
status: current
last_reviewed: 2026-10-14
parent: 15_TASK_BACKLOG
---

# V2 Threshold Branch Merge: Complete Guide

This note documents every commit merged from `v2/threshold-baseline-debug` into
`main` on 2026-10-14. The merge was a conflict-free fast-forward from `1f8f624`
to `0a5a0af`.

## What changed in one sentence

The existing RTL camera path was kept, but the old one-threshold cell decision
was replaced by a trained, integer, START-calibrated linear classifier, with
tools to measure errors, train it, export its constants, compare it bit-for-bit
with XSim, and detect unreliable frames.

```text
camera raster
  -> ROI detector
  -> projective warp to 160x120
  -> 8x8 grid
  -> corner frame guard
  -> linear_rule_sampler
  -> 64 recovered bits + frame kind
```

The merge did not replace `roi_start_detector.sv`,
`projective_warp_160x120.sv`, or `grayscale_grid_8x8.sv`.

## Environment

The simulation runner needs Vivado/XSim 2019.1. The analysis programs need:

```text
Pillow
NumPy
pandas
scikit-learn
joblib
```

The normal `python` currently available on this PC does not include all these
packages. In PowerShell, either install them into your own Python:

```powershell
py -m pip install pillow numpy pandas scikit-learn joblib
$PY = "py"
```

or use the Codex bundled environment already available on this PC:

```powershell
$PY = "C:\Users\arshm\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe"
```

Run all following commands from:

```text
C:\Users\arshm\Desktop\CubeOCC
```

## Commit-by-commit explanation

### 1. `be62504` - compile the corner guard in the image simulation

Changed:

- `dataset/run_cubeocc_top_image_sim.py`

`roi_warp_grid_pipeline.sv` instantiates `grid_corner_frame_guard.sv`. The
runner previously omitted that source from `xvlog`, so compilation could fail
with an unresolved module. This commit adds the guard RTL to the compile list.

There is no separate command for this commit. It makes the normal full-pipeline
simulation command compile correctly.

### 2. `076f0f9` - baseline error measurement and guard logging

Added or changed:

- `dataset/cell_error_report.py`
- `tb/cubeocc_top_image_tb.sv`
- `15_09_V2_DYNAMIC_THRESHOLD_BASELINE_FINDINGS.md`

The testbench gained CSV columns for the corner guard, including START, DATA,
END, discarded, discard reason, learned white level, threshold, and four corner
averages. This lets us determine why a frame was accepted or rejected.

`cell_error_report.py` compares each recovered 64-bit word with a 13-frame
golden sequence. It uses monotonic dynamic-programming alignment, so duplicated
or skipped optical frames do not shift every later comparison.

Run the old-classifier baseline:

```powershell
& $PY dataset/cell_error_report.py `
  --frames sim/cubeocc_top_all/symbols_review/symbols_review.json `
  --out cell_errors
```

It creates:

```text
cell_errors/per_frame.csv
cell_errors/summary.json
```

Current reproduced baseline:

```text
806 frames
51,584 cells
1,998 wrong cells
3.87% all-cell error
```

The preferred golden input is the exact sender `*_frames.jsonl`:

```powershell
& $PY dataset/cell_error_report.py `
  --frames sim/cubeocc_top_all_start_v2/results.json `
  --grades sim/cubeocc_top_all/symbols_review/symbols_review.json `
  --golden-jsonl PATH_TO_SENDER_frames.jsonl `
  --out cell_errors_exact_golden
```

Without `--golden-jsonl`, the script builds an approximate golden by majority
vote from frames manually graded `true`.

### 3. `242d8dd` - dataset correction, preprocessing views, and SVM evaluation

Added or changed:

- fixed the `MLCAP_054` frame sequence and removed duplicate `frame_9.jpg`
- `dataset/cell_error_report.py`: natural frame-number sorting and START-gated alignment
- `dataset/svm_cv_report.py`
- `dataset/train_v2_svm.py`
- `dataset/preprocess_dashboard.py`
- `dataset/preprocess_visualize.py`
- `sim/cubeocc_top_all/symbols_review/symbols_review.json`

The important production tool is `svm_cv_report.py`. It performs
leave-one-capture-set-out validation: a complete capture set is either training
or test data, never both. This avoids leakage between almost identical images.

Run the linear comparison:

```powershell
& $PY dataset/svm_cv_report.py `
  --frames sim/cubeocc_top_all/symbols_review/symbols_review.json `
  --image-dir sim/cubeocc_top_all_guard/camera_gray `
  --preprocess none `
  --kernel linear `
  --n-jobs -1 `
  --out svm_cv_none_linear
```

It creates:

```text
svm_cv_none_linear/per_set.csv
svm_cv_none_linear/summary.json
```

`train_v2_svm.py` is a superseded experiment. It uses a random train/test split
after cells have been extracted, so cells from one capture sequence can leak
into both sides. Do not cite its accuracy and do not use it to select RTL.

The preprocessing viewers are exploratory utilities with fixed paths inside
the scripts:

```powershell
& $PY dataset/preprocess_dashboard.py
& $PY dataset/preprocess_visualize.py
```

Before using them, set their `INPUT_DIR` to a folder containing warped
`160x120` grayscale PNGs. They write browser-review files under `sim/postip/`.
They do not change the RTL or train the production model.

### 4. `b845371` - neighbor ablation and bootstrap evidence

Changed only:

- `15_09_V2_DYNAMIC_THRESHOLD_BASELINE_FINDINGS.md`

This commit documented why the neighbor feature was retained. It compared the
same classifier with and without neighbor brightness and used paired bootstrap
resampling over capture sets. The gain is small but consistent. No executable
code or RTL was added by this commit.

### 5. `43a35b9` - first FPGA linear-rule classifier

Added:

- `rtl/linear_rule_sampler.sv`

For every grid cell, the RTL sums the 81 pixels in a radius-5 circular region.
It then applies this integer rule:

```text
score = WC * S_cell
      + WN[n] * sum(S_neighbor)
      + WW * S_white[cell]

bit = 1 when score > 0
```

`n` is 2 for a corner cell, 3 for an edge cell, and 4 for an interior cell.
Separate `WN2`, `WN3`, and `WN4` constants already include the division by the
neighbor count. No runtime division or floating point is used.

The four protocol corner cells are forced white in DATA frames. START and END
words come from the corner guard decision.

This module is synthesizable RTL. It is not a Python image classifier inserted
into the simulation.

### 6. `f1b3ce1` - connect the classifier to the real pipeline

Changed:

- `rtl/cubeocc_top.sv`
- `tb/cubeocc_top_image_tb.sv`
- `dataset/run_cubeocc_top_image_sim.py`

`cubeocc_top` now connects the live FPGA path directly:

```text
ROI -> warp -> grid -> guard -> linear_rule_sampler
```

The guard outputs are passed into the sampler, and the testbench records
`symbols_kind`. The runner compiles the new module.

The post-merge correction documented here also makes the runner use natural
numeric ordering, so `frame_9` is processed before `frame_10`. If both
`frame_09` and `frame_9` exist in one capture set, it warns and keeps the
zero-padded name, preventing the old duplicate from turning the 806-frame run
back into 807 frames. It also stores `symbols_kind` in `results.json`.

Run a small smoke test first:

```powershell
& $PY dataset/run_cubeocc_top_image_sim.py `
  --input-dir sim/roi_rtl_all_v11_independent_edges/camera_gray `
  --capture-set MLCAP_001_Baseline_30fps `
  --out sim/cubeocc_top_linear_smoke
```

Use the exact capture-set folder name that exists under `camera_gray`.

Run all input folders:

```powershell
& $PY dataset/run_cubeocc_top_image_sim.py `
  --input-dir sim/roi_rtl_all_v11_independent_edges/camera_gray `
  --out sim/cubeocc_top_all_start_v2
```

The output folder contains:

```text
results.json
symbols_preview.png
camera_gray/                  warped 160x120 images
mem/                          temporary XSim memories
xsim_build/pipeline_frames.csv
xsim_build/symbols_results.csv
xsim_build/warped_pixels.hex
```

The runner intentionally refuses to delete an existing output folder unless it
contains `results.json`.

Post-merge smoke verification on `MLCAP_001_Baseline_30fps`:

```text
13 frames emitted, 0 ROI rejects
kind sequence: START, 11 x DATA, END
integer checker: PASS, 0 word mismatches, 0 kind mismatches
```

### 7. `e3deac6` - export FPGA constants and prove bit-exact behavior

Added:

- `dataset/export_linear_rule.py`
- `dataset/check_linear_rule_rtl.py`
- `linear_rule/rule.json`

`export_linear_rule.py` trains method I on:

```text
[cell_mean / white_reference, neighbor_mean / white_reference]
```

It algebraically removes division, quantizes the rule to signed integer
constants, tests 8/10/12/16-bit weights, and writes `rule.json`.

Generate the chosen START-reference rule:

```powershell
& $PY dataset/export_linear_rule.py `
  --frames sim/cubeocc_top_all/symbols_review/symbols_review.json `
  --image-dir sim/cubeocc_top_all_guard/camera_gray `
  --white-ref start `
  --bits 12 `
  --out linear_rule_start
```

Constants at the time of the merge (superseded by the latest-grid retraining in
[[15_18_LATEST_GRID_SVM_RETRAIN]]):

```text
WC  =  2047
WN2 =  -248
WN3 =  -165
WN4 =  -124
WW  = -1086
```

`linear_rule/rule.json` is the older mean-of-four-corners variant.
`linear_rule_start/rule.json` is the production START-map variant.

Compare an XSim run with the integer model:

```powershell
& $PY dataset/check_linear_rule_rtl.py `
  --sim-dir sim/cubeocc_top_all_start_v2 `
  --rule linear_rule_start/rule.json
```

Always pass `--rule` when recording evidence, even though the fallback constants
have now been synchronized. The checker requires
`xsim_build/symbols_results.csv`, which is regenerable and may have been removed
by cleanup.

### 8. `7839f4f` - record first RTL result and frame-kind problems

Changed only:

- `15_09_V2_DYNAMIC_THRESHOLD_BASELINE_FINDINGS.md`

This documented the first linear-rule XSim result and cases where frame ordering
or the corner guard produced unusual START/DATA/END sequences. It is historical
evidence; current numbers are in [[15_14_V2_SCRIPT_OUTPUTS_LOG]].

### 9. `20818a7` - per-cell white calibration from START

Changed or added:

- `rtl/linear_rule_sampler.sv`
- `dataset/export_linear_rule.py`
- `dataset/check_linear_rule_rtl.py`
- `linear_rule_start/rule.json`
- historical updates in `15_09`

The original rule used one white reference from the four corners. This commit
stores all 64 circular cell sums from an accepted all-white START frame:

```text
start_sum[0..63]
```

Each DATA cell is compared with the white level at the same screen location.
This compensates for spatial brightness gradients, viewing angle, and
vignetting without needing a bilinear interpolator.

If no START has been learned yet, the RTL temporarily falls back to the average
of the four current corner sums. A bad frame incorrectly accepted as START will
therefore poison the calibration until reset; this remains a known risk.

### 10. `78c0785` - ambiguous DATA frame flag

Added or changed:

- `dataset/ambiguity_report.py`
- `rtl/linear_rule_sampler.sv`
- `dataset/check_linear_rule_rtl.py`
- `dataset/export_linear_rule.py`
- historical updates in `15_09`

A payload cell is uncertain when its score is close to zero:

```text
abs(score) < abs(WW * S_white[cell]) / 8
```

If at least three payload cells are uncertain, the frame is emitted as
`symbols_kind = 5`. The 64-bit word is unchanged.

Search for an ambiguity threshold and count:

```powershell
& $PY dataset/ambiguity_report.py `
  --frames sim/cubeocc_top_all_guard/results.json `
  --grades sim/cubeocc_top_all/symbols_review/symbols_review.json `
  --image-dir sim/cubeocc_top_all_guard/camera_gray `
  --cv-splits 50 `
  --out ambiguity_cv
```

This produces `ambiguity_cv/per_frame.csv`. The script compares:

- `U`: all low-margin cells
- `T`: low-margin cells that also changed from the previous frame

The simpler `U` count was selected.

### 11. `0a5a0af` - nonlinear experiments, feature analysis, final docs, cleanup

Added or changed:

- nonlinear options and CPU parallelism in `dataset/svm_cv_report.py`
- `dataset/evaluate_ambiguous_flag.py`
- `dataset/feature_correlation_pca.py`
- `feature_analysis_none/`
- `feature_analysis_opt4/`
- `svm_cv_opt4_linear_v2/`
- `svm_cv_opt4_both_v2/`
- `sim/cubeocc_top_all_start_v2/results.json`
- updated production constants in RTL and JSON
- Obsidian notes `15_10` through `15_16`
- `cleanup_sim.sh`
- expanded `.gitignore`

Run linear, polynomial, and approximate RBF comparisons:

```powershell
& $PY dataset/svm_cv_report.py `
  --frames sim/cubeocc_top_all/symbols_review/symbols_review.json `
  --image-dir sim/cubeocc_top_all_guard/camera_gray `
  --preprocess opt4 `
  --kernel both `
  --nonlinear-only `
  --rbf-components 100 `
  --n-jobs -1 `
  --out svm_cv_opt4_both_v2
```

Results:

- Gaussian preprocessing: no meaningful benefit.
- Poly2 method I: worse than linear method I.
- RBF method I: 1.27% CV error, but estimated FPGA cost is too high.
- Production decision: retain the two-feature linear rule.

Run feature correlation and PCA:

```powershell
& $PY dataset/feature_correlation_pca.py `
  --frames sim/cubeocc_top_all/symbols_review/symbols_review.json `
  --image-dir sim/cubeocc_top_all_guard/camera_gray `
  --preprocess none `
  --out feature_analysis_none

& $PY dataset/feature_correlation_pca.py `
  --frames sim/cubeocc_top_all/symbols_review/symbols_review.json `
  --image-dir sim/cubeocc_top_all_guard/camera_gray `
  --preprocess opt4 `
  --out feature_analysis_opt4
```

It writes `correlation.csv` and `summary.json`. PCA needed four dense
components for 95% variance and would consume more multipliers than directly
using `[mean/white, neighbor/white]`, so PCA was rejected for RTL.

Evaluate kinds 4 and 5 from an actual XSim run:

```powershell
& $PY dataset/evaluate_ambiguous_flag.py `
  --errors cell_errors_start_v2/per_frame.csv `
  --sim-dir sim/cubeocc_top_all_start_v2 `
  --exclude MLCAP_048
```

Current recorded result:

```text
kind 5 recall:       81.6%
kind 5 precision:    66.0%
kind 5 false alarm:   2.7%
kind 4 + 5 bad-frame removal: 86.8%
```

`cleanup_sim.sh` deletes large regenerable XSim and analysis folders while
keeping selected labels and summaries. It is a Bash script, so run it only from
Git Bash or WSL, from the repository root:

```bash
./cleanup_sim.sh
```

Review its `rm -rf` list before running it. It removes the raw XSim CSV needed
by `check_linear_rule_rtl.py`; regenerate the simulation before rerunning that
checker.

## Frame-kind interface

| Kind | Meaning | Recommended interpretation |
| ---: | --- | --- |
| 0 | ignored or unknown | do not decode as normal DATA |
| 1 | START | store the 64-cell white map and begin transfer |
| 2 | normal DATA | send the 64 recovered bits downstream |
| 3 | END | close the current one-way transfer |
| 4 | discarded by corner guard | log/drop; guard rejected the frame |
| 5 | ambiguous DATA | bits are present, but reliability is low |

The protocol is one-way. No retransmission path was added. The final downstream
policy for kind 5 is still open: accept with warning, drop, or pass reliability
information to ECC.

## Authoritative files versus regenerated files

### Source and model files

| File | Role | Use it? |
| --- | --- | --- |
| `rtl/linear_rule_sampler.sv` | production classifier RTL | yes |
| `rtl/cubeocc_top.sv` | live ROI/warp/grid/guard/classifier connection | yes |
| `linear_rule_start/rule.json` | production START-reference coefficients | yes |
| `linear_rule/rule.json` | mean-of-four-corners comparison | reference only |
| `dataset/svm_cv_report.py` | leakage-safe classifier comparison | yes |
| `dataset/export_linear_rule.py` | train and quantize production rule | yes |
| `dataset/check_linear_rule_rtl.py` | bit-exact RTL/model test | yes |
| `dataset/train_v2_svm.py` | random-split legacy experiment | no |
| `dataset/preprocess_dashboard.py` | fixed-path visual experiment | optional |
| `dataset/preprocess_visualize.py` | fixed-path sharpen visual experiment | optional |

### Tracked evidence

| Path | Meaning |
| --- | --- |
| `sim/cubeocc_top_all/symbols_review/symbols_review.json` | manual frame review and approximate-golden source |
| `sim/cubeocc_top_all_start_v2/results.json` | retained current RTL manifest, without bulky XSim files |
| `svm_cv_opt4_linear_v2/` | saved linear CV summaries |
| `svm_cv_opt4_both_v2/` | saved nonlinear CV summaries |
| `feature_analysis_none/` | raw-feature correlation/PCA output |
| `feature_analysis_opt4/` | opt4-feature correlation/PCA output |

Folders such as `cell_errors_*`, `ambiguity*`, and most XSim build folders are
regenerable and normally ignored.

## Verified checkpoint at merge time

| Metric | Result |
| --- | ---: |
| Current golden | 806 frames, approximate majority-derived truth |
| Old dynamic-threshold all-cell error | 1,998 / 51,584 = 3.87% |
| New linear START-map all-cell error | 413 / 51,584 = 0.80% |
| Error reduction | 4.8x |
| START-reference CV payload error | 1.31% |
| RTL versus integer model | recorded PASS, 0 mismatches |
| Combined LUT | 9,233 / 20,800 = 44.4% |
| Combined registers | 4,308 / 41,600 = 10.4% |
| BRAM36 | 8 / 50 = 16.0% |
| DSP48 | 17 / 90 = 18.9% |

> [!important] Newer result
> After this merge audit, the SVM was retrained on images regenerated through
> the latest live RTL ROI/projective-warp/grid path. The current result is 0.85%
> capture-set CV payload error and 0.63% RTL all-cell error, with constants
> `WC=2047, WN2=-255, WN3=-170, WN4=-127, WW=-1168`. See
> [[15_18_LATEST_GRID_SVM_RETRAIN]].

The all-cell result was reproduced after the merge. A fresh bit-exact run needs
the XSim CSV regenerated because cleanup intentionally removed it.

The runner correction was also verified with a fresh 13-frame XSim smoke test;
its RTL output and frame kinds matched the integer model exactly.

## Known limitations

- The current golden is inferred from manually graded frames. Connect the exact
  sender `*_frames.jsonl` through `--golden-jsonl` before publication.
- `MLCAP_048` appears to contain content that does not match the approximate
  golden and is excluded from ambiguity statistics.
- A wrongly accepted START frame corrupts the white map until reset.
- Kind-5 downstream policy is not finalized.
- Final 100 MHz post-synthesis timing evidence is still open.
- RGB and RGB cell-level labels remain future work; this branch is grayscale.

## Recommended normal workflow

```text
1. Run full XSim pipeline with run_cubeocc_top_image_sim.py.
2. Measure final words with cell_error_report.py.
3. Train/compare only with svm_cv_report.py.
4. Export production constants with export_linear_rule.py --white-ref start.
5. Copy/verify the constants in linear_rule_sampler.sv.
6. Rerun XSim.
7. Run check_linear_rule_rtl.py with --rule.
8. Run evaluate_ambiguous_flag.py.
9. Save summaries; clean bulky outputs only after verification.
```

## Related notes

- [[15_09_V2_DYNAMIC_THRESHOLD_BASELINE_FINDINGS]] - historical experiments
- [[15_10_V2_CLASSIFIER_PIPELINE_ARCHITECTURE]] - RTL architecture and resources
- [[15_11_V2_TRAINING_VALIDATION_COMMANDS]] - concise reproduction commands
- [[15_12_V2_WORK_LOG_DECISIONS_AND_REJECTIONS]] - chronological decisions
- [[15_13_V2_TASK_CHECKLIST]] - completed and open tasks
- [[15_14_V2_SCRIPT_OUTPUTS_LOG]] - raw command outputs
- [[15_15_V2_NONLINEAR_SVM_SESSION]] - nonlinear comparison
- [[15_16_FEATURE_CORRELATION_PCA]] - feature correlation and PCA
