---
project: CubeOCC
type: how-to
status: verified
last_reviewed: 2026-10-14
parent: 15_TASK_BACKLOG
---

# V2 Training and Validation Commands

Exact commands to reproduce the entire path from raw data to RTL coefficients. Each step lists the goal, inputs, outputs, and what it proves.

For a description of every commit and every utility added by the merged branch,
including exploratory scripts and cleanup behavior, see
[[15_17_RECENT_V2_BRANCH_MERGE_SUMMARY]].

> [!important] Latest dataset
> The older examples below use the pre-merge generated image folder for
> historical reproducibility. The current model was retrained from the latest
> live RTL ROI/projective-warp/grid output. Use the commands and current numbers
> in [[15_18_LATEST_GRID_SVM_RETRAIN]] for new work.

## Prerequisites

Python packages:

```text
Pillow, NumPy, pandas, scikit-learn, joblib
```

The plain `python` on this PC currently lacks some of these packages. In
PowerShell either install them with `py -m pip install pillow numpy pandas
scikit-learn joblib`, or set `$PY` to the bundled environment:

```powershell
$PY = "C:\Users\arshm\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe"
```

Replace `python` in the commands below with `& $PY` when using that variable.

Files and folders that must exist:

```text
sim/cubeocc_top_all_guard/
  results.json                    ← runner output, includes relative_path per frame
  camera_gray/                    ← 160x120 images (warp output)
  xsim_build/symbols_results.csv  ← per-frame word + kind

sim/cubeocc_top_all/
  symbols_review/symbols_review.json   ← manual true/mid/false labels

dataset/
  cell_error_report.py
  svm_cv_report.py
  export_linear_rule.py
  ambiguity_report.py
  check_linear_rule_rtl.py
  evaluate_ambiguous_flag.py
```

---

## Step 1 — Baseline cell error

Goal: establish the reference number with no new classifier.

```bash
python dataset/cell_error_report.py \
  --frames sim/cubeocc_top_all/symbols_review/symbols_review.json \
  --out cell_errors
```

**Expected output:**

```text
frames 806  cells 51584  cell errors 1998  rate 3.87 %
black read as white: 1955   white read as black: 43
```

This was the reference number for `dynamic_threshold_sampler`.

---

## Step 2 — Compare classifiers with leave-one-capture-set-out

Goal: pick the right feature set and classifier without data leakage.

```bash
# No preprocessing
python dataset/svm_cv_report.py \
  --frames sim/cubeocc_top_all/symbols_review/symbols_review.json \
  --image-dir sim/cubeocc_top_all_guard/camera_gray \
  --preprocess none --kernel linear \
  --out svm_cv_none_linear
```

**Expected output (summary):**

```text
62 capture sets, 40800 payload cells, preprocess=none, kernel=linear
method                              all   worst 10  others
A current sampler                   4.76    25.91    0.68
B per-frame 2-means threshold       1.67     6.42    0.76
E SVM 5 features / frame white ref  1.53     6.12    0.64
I SVM mean/white + nb/white         1.69     7.29    0.61
```

Conclusion: method I is not the absolute lowest-error linear candidate in this
table, but it gives the selected resource/accuracy tradeoff: two features and a
division-free RTL rule. The small accuracy gains of larger models did not
justify their extra multipliers.

Detailed per-set output is written to `svm_cv_none_linear/per_set.csv`. The separately exported START-reference rule reaches 1.31 % CV payload error.

---

## Step 3 — Export the rule as integer constants

Goal: convert float coefficients into 12-bit signed constants for RTL.

```bash
# white_ref = mean4 (current golden: 1.69 % CV error)
python dataset/export_linear_rule.py \
  --frames sim/cubeocc_top_all/symbols_review/symbols_review.json \
  --image-dir sim/cubeocc_top_all_guard/camera_gray \
  --white-ref mean4 --bits 12 \
  --out linear_rule

# white_ref = start (latest RTL grid dataset: 0.85 % CV error) ← chosen
python dataset/export_linear_rule.py \
  --frames sim/cubeocc_top_all/symbols_review/symbols_review.json \
  --image-dir sim/cubeocc_top_all_guard/camera_gray \
  --white-ref start --bits 12 \
  --out linear_rule_start

# white_ref = bilinear (rejected, 1.72 %)
python dataset/export_linear_rule.py \
  --frames sim/cubeocc_top_all/symbols_review/symbols_review.json \
  --image-dir sim/cubeocc_top_all_guard/camera_gray \
  --white-ref bilinear --bits 12 \
  --out linear_rule_bilinear
```

**Output of `linear_rule_start/rule.json`:**

```json
{
  "white_ref": "start",
  "float_coef_mean_nb_white": [6.2359070314, -1.5516291727, -3.5583315599],
  "int_bits": 12,
  "int_constants": {
    "Wc": 2047,
    "Wn2": -255,
    "Wn3": -170,
    "Wn4": -127,
    "Ww": -1168
  }
}
```

These 5 numbers are the `linear_rule_sampler.sv` parameters:

```systemverilog
parameter signed [11:0] WC  = 12'sd2047;
parameter signed [11:0] WN2 = -12'sd255;
parameter signed [11:0] WN3 = -12'sd170;
parameter signed [11:0] WN4 = -12'sd127;
parameter signed [11:0] WW  = -12'sd1168;
```

---

## Step 4 — Run XSim with the new RTL

Goal: run the full pipeline over 806 frames.

```bash
python dataset/run_cubeocc_top_image_sim.py \
  --input-dir sim/roi_rtl_all_v11_independent_edges/camera_gray \
  --out sim/cubeocc_top_all_start_v2
```

**Expected output:**

```text
sim/cubeocc_top_all_start_v2/
  results.json
  camera_gray/
  xsim_build/
    symbols_results.csv     ← includes the symbols_kind column
```

The runner now uses natural numeric sorting (`frame_9` before `frame_10`) and
deduplicates equivalent names such as `frame_09` and `frame_9` by keeping the
zero-padded file. It also writes `symbols_kind` into each emitted
`results.json` frame record.

---

## Step 5 — Bit-exact confirmation of RTL vs integer model

Goal: prove the RTL computes exactly the same thing as the Python model.

```bash
python dataset/check_linear_rule_rtl.py \
  --sim-dir sim/cubeocc_top_all_start_v2 \
  --rule linear_rule_start/rule.json
```

**Expected output:**

```text
rule mode: start  constants: {'Wc': 2047, 'Wn2': -255, 'Wn3': -170, 'Wn4': -127, 'Ww': -1168}

kind counts / mismatches:
  0 ignored          frames    1   mismatches 0
  1 START            frames   63   mismatches 0
  2 DATA             frames  594   mismatches 0
  3 END              frames   61   mismatches 0
  4 discarded DATA   frames   24   mismatches 0
  5 ambiguous DATA   frames   63   mismatches 0

PASS: RTL words and ambiguity flags match the integer model
```

**This PASS is critical.** It means the RTL exactly matches the model, so the training results and the FPGA results are the same.

---

## Step 6 — Cell error on RTL output

Goal: final error number on the FPGA output.

```bash
python dataset/cell_error_report.py \
  --frames sim/cubeocc_top_all_start_v2/results.json \
  --grades sim/cubeocc_top_all/symbols_review/symbols_review.json \
  --out cell_errors_start_v2
```

**Expected output:**

```text
frames 806  cells 51584  cell errors 413  rate 0.80 %
black read as white: 349   white read as black: 64
worst sets:
  MLCAP_048_...         7.9 %
  MLCAP_026_...         6.0 %
  MLCAP_038_...         4.9 %
  ...
```

Reduction from **3.87 % to 0.80 %** on all cells, a **4.8x reduction**.

---

## Step 7 — Ambiguous flag evaluation (kind=5)

### 7.1 In-sample

```bash
python dataset/ambiguity_report.py \
  --frames sim/cubeocc_top_all_guard/results.json \
  --grades sim/cubeocc_top_all/symbols_review/symbols_review.json \
  --image-dir sim/cubeocc_top_all_guard/camera_gray \
  --out ambiguity
```

### 7.2 Cross-validated (this is the important one)

```bash
python dataset/ambiguity_report.py \
  --frames sim/cubeocc_top_all_guard/results.json \
  --grades sim/cubeocc_top_all/symbols_review/symbols_review.json \
  --image-dir sim/cubeocc_top_all_guard/camera_gray \
  --cv-splits 50 \
  --out ambiguity_cv
```

**Expected output (CV):**

```text
[CV] 50 random half/half splits of the capture sets;
     (delta, N) chosen on the train half (good lost <= 5.0%),
     measured on the held-out half
              flagged%  good lost%  err removed%  bad caught%
train half         9.4         4.1          87.3         91.1
held-out          10.7         5.4          86.5         91.0
held-out sd        4.9         4.0          10.1         11.3
most chosen (delta, N): [((0.05, 2), 16), ((0.069, 2), 10), ((0.05, 1), 7), ((0.069, 3), 5)]
```

**Interpretation:** train and held-out are nearly identical → the `(δ, N)` choice generalizes. The in-sample choice `(0.069, 2)` implemented in RTL is the second-most-common CV pick.

---

## Step 8 — Flag evaluation on RTL output

Goal: measure real-world behavior of kind=4 (discarded) and kind=5 (ambiguous).

```bash
python dataset/evaluate_ambiguous_flag.py \
  --errors cell_errors_start_v2/per_frame.csv \
  --sim-dir sim/cubeocc_top_all_start_v2 \
  --exclude MLCAP_048
```

**Expected output:**

```text
--- Ambiguous Flag (kind=5) ---
Recall (Bad frames caught): 31 / 38 = 81.6%
Precision (Flagged frames that are bad): 31 / 47 = 66.0%
False Positive Rate (Good DATA frames lost): 16 / 594 = 2.7%

--- Discarded Flag (kind=4, by Guard) ---
Recall (Bad frames caught): 2 / 38 = 5.3%
False Positive Rate (Good DATA frames lost): 0 / 594 = 0.0%
```

Conclusion: kind=5 is useful (81.6 % of bad frames caught at 2.7 % cost). Combined with kind=4, the system removes 86.8 % of bad frames at the same measured good-frame loss.

---

## Command summary table

| #   | Command                                   | Output                        | Result                   |
| --- | ----------------------------------------- | ----------------------------- | ------------------------ |
| 1   | `cell_error_report.py` (baseline)         | `cell_errors/`                | 3.87 %                   |
| 2   | `svm_cv_report.py --preprocess none`      | `svm_cv_none_linear/per_set.csv` | method I mean4 = 1.69 %; START export = 1.31 % |
| 3   | `export_linear_rule.py --white-ref start` | `linear_rule_start/rule.json` | 5 constants              |
| 4   | `run_cubeocc_top_image_sim.py`            | `sim/cubeocc_top_all_start_v2/` | 806 frames             |
| 5   | `check_linear_rule_rtl.py`                | —                             | PASS, 0 mismatches       |
| 6   | `cell_error_report.py` (RTL)              | `cell_errors_start_v2/`       | **0.80 %**               |
| 7   | `ambiguity_report.py --cv-splits 50`      | `ambiguity_cv/per_frame.csv`  | generalization confirmed |
| 8   | `evaluate_ambiguous_flag.py`              | —                             | recall 81.6 %, FPR 2.7 % |

## Superseded scripts that must not be used for reported accuracy

Some of these files are already tracked or may exist locally. Their results are
misleading because train and test cells can come from the same capture set
(data leakage):

- `dataset/test_svm_eval.py` — random 80/20 split at the **cell** level. The 98.5 % accuracy number comes from here.
- `dataset/train_v2_svm.py` — same problem with a different random split.
- `dataset/export_svm_weights.py` — still uses StandardScaler and 5 features, not RTL-ready.

**Current valid number: 0.85 % CV payload error (= 99.15 % accuracy) for method I with the START white map trained from the latest live RTL grid output. The final RTL all-cell error is 0.63 %.**
