---
project: CubeOCC
type: validation
status: verified
last_reviewed: 2026-10-14
parent: 15_TASK_BACKLOG
---

# Latest RTL Grid SVM Retraining

## Why this rerun was required

The previous V2 SVM was trained from `sim/cubeocc_top_all_guard/camera_gray`,
which came from an older ROI/warp result. This rerun generated a new dataset
directly through the current live RTL chain:

```text
roi_start_detector
  -> projective_warp_160x120
  -> grayscale_grid_8x8
  -> grid_corner_frame_guard
  -> linear_rule_sampler
```

No saved Python corners or Python warp were used.

## Dataset generation

```powershell
& $PY dataset/run_cubeocc_top_image_sim.py `
  --input-dir sim/roi_rtl_all_v11_independent_edges/camera_gray `
  --out sim/cubeocc_top_latest_grid_v2
```

The runner found both `frame_09.png` and `frame_9.png` in MLCAP_054, warned,
and retained the zero-padded file. Result: 806 frames, 62 capture sets, zero ROI
rejects.

## Leakage-safe training and test

The split was leave-one-capture-set-out. Cells from one capture sequence never
appear in both training and testing.

```powershell
& $PY dataset/svm_cv_report.py `
  --frames sim/cubeocc_top_latest_grid_v2/results.json `
  --grades sim/cubeocc_top_all/symbols_review/symbols_review.json `
  --image-dir sim/cubeocc_top_latest_grid_v2/camera_gray `
  --preprocess none --kernel linear --n-jobs -1 `
  --out sim/cubeocc_top_latest_grid_v2/analysis/svm_cv_none_linear
```

Key payload-cell CV results over 40,860 cells:

| Method | CV error |
| --- | ---: |
| Existing RTL rule before retraining | 0.94% |
| E: five white-normalized features | 0.98% |
| I: mean/white + neighbor/white | 1.01% |
| K: reduced three-feature model | 1.06% |
| Per-frame 2-means | 1.44% |

The table above uses the ordinary per-frame corner white reference. The
production architecture uses the same-cell START white map, so it was trained
and cross-validated separately.

## START-map model export

```powershell
& $PY dataset/export_linear_rule.py `
  --frames sim/cubeocc_top_latest_grid_v2/results.json `
  --grades sim/cubeocc_top_all/symbols_review/symbols_review.json `
  --image-dir sim/cubeocc_top_latest_grid_v2/camera_gray `
  --white-ref start --bits 12 `
  --out sim/cubeocc_top_latest_grid_v2/analysis/linear_rule_start_latest
```

Result:

```text
START-map float CV payload error: 0.85%
12-bit integer CV payload error:  0.85%
integer decisions differing from float: 0
```

New production constants:

```text
WC  =  2047
WN2 =  -255
WN3 =  -170
WN4 =  -127
WW  = -1168
```

These values are now in `linear_rule_start/rule.json`,
`rtl/linear_rule_sampler.sv`, and the checker's fallback constants.

## Full RTL test after retraining

The complete 806-frame XSim run was repeated with the new constants:

```powershell
& $PY dataset/run_cubeocc_top_image_sim.py `
  --input-dir sim/roi_rtl_all_v11_independent_edges/camera_gray `
  --out sim/cubeocc_top_latest_grid_retrained_v2

& $PY dataset/check_linear_rule_rtl.py `
  --sim-dir sim/cubeocc_top_latest_grid_retrained_v2 `
  --rule linear_rule_start/rule.json
```

Bit-exact result:

```text
806 frames
62 START, 596 DATA, 61 END, 22 discarded, 65 ambiguous
0 word mismatches
0 kind mismatches
PASS
```

Final RTL error:

```text
325 wrong cells / 51,584 = 0.63% all-cell error
240 black read as white
85 white read as black
38 of 62 capture sets have zero errors
```

Comparison:

| Checkpoint | All-cell error |
| --- | ---: |
| Original dynamic threshold | 3.87% |
| Previous weights on latest ROI/warp/grid | 0.75% |
| Retrained weights on latest ROI/warp/grid | **0.63%** |

The retrained model reduces the original baseline error by about 6.1x.

## Ambiguity flag after retraining

With MLCAP_048 excluded because its content does not match the approximate
golden:

| Metric | Result |
| --- | ---: |
| Bad frames caught by kind 5 | 25 / 28 = 89.3% |
| Kind-5 precision | 52.1% |
| Good DATA frames flagged | 23 / 608 = 3.8% |
| Kind 4 + 5 bad-frame removal | 26 / 28 = 92.9% |

## Stored evidence

- `linear_rule_start/rule.json` - current production model
- `svm_cv_latest_grid_linear_v2/summary.json` - retained CV summary
- `svm_cv_latest_grid_linear_v2/per_set.csv` - retained per-set results
- `sim/cubeocc_top_latest_grid_v2/` - generated pre-retrain run and training images
- `sim/cubeocc_top_latest_grid_retrained_v2/` - generated post-retrain RTL run

The two `sim/` folders are large and ignored. Regenerate them with the commands
above when needed.

## Remaining limitation

The labels are still based on the approximate majority-derived golden. Before
paper publication, repeat the reports with the exact sender `*_frames.jsonl`
using `--golden-jsonl`.

## Related notes

- [[15_10_V2_CLASSIFIER_PIPELINE_ARCHITECTURE]]
- [[15_11_V2_TRAINING_VALIDATION_COMMANDS]]
- [[15_17_RECENT_V2_BRANCH_MERGE_SUMMARY]]
