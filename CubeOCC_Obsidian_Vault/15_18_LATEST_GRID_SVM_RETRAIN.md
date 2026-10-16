---
project: CubeOCC
type: validation
status: verified
last_reviewed: 2026-10-15
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

## FPGA integration and synthesis check

The production classifier is connected directly in `cubeocc_top`:

```text
camera pixels
  -> roi_start_detector
  -> projective_warp_160x120
  -> grayscale_grid_8x8
  -> grid_corner_frame_guard
  -> linear_rule_sampler
  -> symbols_data / symbols_kind
```

`vivado_create_project.tcl` now includes both `grid_corner_frame_guard.sv` and
`linear_rule_sampler.sv`. The resource-report script also synthesizes the
integrated `cubeocc_top` and applies a 10 ns clock for a 100 MHz stress check.

Fresh difficult-set XSim result (`MLCAP_048_Cam30_Opt60`):

```text
13 frames, zero ROI rejects
zero RTL word mismatches
zero frame-kind mismatches
9 frames flagged ambiguous because camera 30 FPS samples optical 60 FPS
```

Synthesis for `xc7a35tcpg236-1`:

| Design | LUT | FF | BRAM tiles | DSP | 100 MHz timing |
| --- | ---: | ---: | ---: | ---: | --- |
| Complete `cubeocc_top` | 9,622 (46.26%) | 5,374 (12.92%) | 8 (16.00%) | 17 (18.89%) | Fails, WNS -11.810 ns |
| `linear_rule_sampler` only | 1,883 (9.05%) | 2,234 (5.37%) | 0 | 3 (3.33%) | Passes, WNS +1.931 ns |

The SVM classifier therefore meets 100 MHz on its own. The complete design's
100 MHz failure is in the existing projective-warp path, whose worst synthesized
data path is 21.755 ns. This corresponds to roughly 45.9 MHz before additional
place-and-route margin. The classifier integration is valid, but the warp must
be pipelined or run in a slower clock domain before claiming a 100 MHz complete
pipeline.

## Run and inspect it yourself

Run these commands from PowerShell in the repository root:

```powershell
cd C:\Users\arshm\Desktop\CubeOCC
$PY = "python"
```

If `python` is not found, replace `$PY` with the full path to your Python
executable. Vivado 2019.1 must remain installed under
`X:\xilinx\Vivado\2019.1`.

### 1. Quick difficult-case FPGA simulation

This runs the complete RTL pipeline on the most difficult capture set:

```powershell
& $PY dataset/run_cubeocc_top_image_sim.py `
  --input-dir sim/roi_rtl_all_v11_independent_edges/camera_gray `
  --capture-set MLCAP_048_Cam30_Opt60 `
  --out sim/my_svm_quick_test `
  --vivado-bin X:/xilinx/Vivado/2019.1/bin
```

Expected final line:

```text
Wrote 13 classified frame(s), 0 rejected
```

The output folder contains:

| File | Meaning |
| --- | --- |
| `results.json` | ROI corners, frame kind, and classified 64-bit word for every frame |
| `symbols_preview.png` | quick combined preview |
| `camera_gray/` | grayscale frames used by XSim |
| `xsim_build/symbols_results.csv` | raw RTL output captured by the testbench |

Open `sim\my_svm_quick_test\symbols_preview.png` for the fastest visual check.

### 2. Confirm RTL equals the trained integer model

```powershell
& $PY dataset/check_linear_rule_rtl.py `
  --sim-dir sim/my_svm_quick_test `
  --rule linear_rule_start/rule.json
```

The important result is:

```text
PASS: RTL words and ambiguity flags match the integer model
```

`MLCAP_048` is intentionally difficult. Its camera runs at 30 FPS while the
optical data changes at 60 FPS, so several frames should be reported as kind 5
(`ambiguous DATA`). That is protection working, not an RTL mismatch.

### 3. Inspect and label every frame in the browser

Start the local review page:

```powershell
& $PY dataset/serve_symbols_review.py --port 8768
```

The browser opens:

```text
http://127.0.0.1:8768/dataset/symbols_review.html
```

1. Click **Choose run folder**.
2. Select `C:\Users\arshm\Desktop\CubeOCC\sim\my_svm_quick_test`.
3. Inspect the image, ROI/grid overlay, 64 cell decisions, and frame kind.
4. Press `1` for correct, `2` for mostly correct, or `3` for wrong.
5. The review is written under `sim\my_svm_quick_test\symbols_review\`.
6. Keep the PowerShell window open while reviewing; press `Ctrl+C` to stop the server.

Selecting the run folder recreates that run's review directory, so move or copy
an older review first if you need to preserve it.

### 4. Run all 806 frames

This is the complete regression and takes much longer than the quick test:

```powershell
& $PY dataset/run_cubeocc_top_image_sim.py `
  --input-dir sim/roi_rtl_all_v11_independent_edges/camera_gray `
  --out sim/my_svm_full_test `
  --vivado-bin X:/xilinx/Vivado/2019.1/bin

& $PY dataset/check_linear_rule_rtl.py `
  --sim-dir sim/my_svm_full_test `
  --rule linear_rule_start/rule.json
```

Expected regression result:

```text
806 frames
0 RTL word mismatches
0 frame-kind mismatches
PASS
```

To reproduce the approximate cell-error report using the existing reviewed
labels:

```powershell
& $PY dataset/cell_error_report.py `
  --frames sim/my_svm_full_test/results.json `
  --grades sim/cubeocc_top_all/symbols_review/symbols_review.json `
  --out sim/my_svm_full_test/analysis/cell_errors
```

Expected result: `325 / 51,584 = 0.63%` cell error. This number uses the
majority-derived approximate golden; use sender `*_frames.jsonl` with
`--golden-jsonl` when exact ground truth is available.

### 5. Synthesize and inspect FPGA resources

```powershell
$env:CUBEOCC_ROOT = (Get-Location).Path
& "X:\xilinx\Vivado\2019.1\bin\vivado.bat" `
  -mode batch `
  -source vivado/report_camera2_pipeline_resources.tcl `
  -notrace
```

Reports are written to:

```text
sim/camera2_resource_reports/cubeocc_top_utilization.rpt
sim/camera2_resource_reports/cubeocc_top_timing.rpt
sim/camera2_resource_reports/linear_rule_sampler_utilization.rpt
sim/camera2_resource_reports/linear_rule_sampler_timing.rpt
```

The report script applies a 10 ns clock. Expect the classifier alone to pass
100 MHz, while the current complete top fails 100 MHz because of the existing
projective-warp path. This does not mean the classifier failed.

### Measured full run on 2026-10-16

The complete walkthrough was rerun into `sim/my_svm_full_test` using the current
RTL and current SVM coefficients.

| Measurement | Result |
| --- | ---: |
| Input/captured frames | 806 |
| ROI rejected frames | 0 |
| Complete command wall time | 12 min 43.075 s |
| XSim `run -all` wall time | 12 min 16 s |
| Compile, conversion, and report overhead | about 27.1 s |
| Average host wall time | about 0.947 s/frame |
| Simulated FPGA time at ideal 100 MHz | 2.174188726 s total |
| Simulated FPGA time per frame | about 2.6975 ms/frame |
| Bit-exact checker time | 4.161 s |
| Error-report time | 0.167 s |
| RTL/model word mismatches | 0 |
| RTL/model kind mismatches | 0 |
| Approximate all-cell error | 325 / 51,584 = 0.63% |

Frame kinds from the fresh run:

| Kind | Meaning | Count |
| ---: | --- | ---: |
| 1 | START | 62 |
| 2 | clean DATA | 596 |
| 3 | END | 61 |
| 4 | discarded DATA | 22 |
| 5 | ambiguous DATA | 65 |

The 2.6975 ms/frame value is functional simulation time using the testbench's
10 ns clock. It is not proof that the synthesized complete top meets 100 MHz;
the synthesis timing report shows that the warp currently does not. If clocked
at 24 MHz with otherwise identical cycle counts, the corresponding estimate is
about 11.24 ms/frame. Actual board timing must be confirmed after constraints,
placement, and routing.

The review server for this run is:

```text
http://127.0.0.1:8768/dataset/symbols_review.html
```

Choose `C:\Users\arshm\Desktop\CubeOCC\sim\my_svm_full_test` in the page.

### Result checklist

- [ ] Simulation writes 13 quick-test frames or 806 full-test frames.
- [ ] ROI rejected count is zero.
- [ ] Bit-exact checker prints `PASS`.
- [ ] Browser preview shows the projectively rectified 8×8 grid.
- [ ] START is kind 1, clean DATA is kind 2, END is kind 3.
- [ ] Unsafe transition frames may be kind 5 and should not be consumed as clean DATA.
- [ ] Vivado synthesis finishes with zero errors and zero critical warnings.

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
- [[15_19_SVM_LEAKAGE_FEATURE_FPGA_AUDIT]]
