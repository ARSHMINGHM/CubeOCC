---
project: CubeOCC
type: how-to
status: verified
last_reviewed: 2026-10-13
parent: 15_TASK_BACKLOG
---

# V2 Training and Validation Commands

Exact commands to reproduce the entire path from raw data to RTL coefficients. Each step lists the goal, inputs, outputs, and what it proves.

## Prerequisites

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
frames 806  cells 51584  cell errors 1993  rate 3.86 %
black read as white: 1943   white read as black: 50
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
  --preprocess none \
  --out svm_cv_none
```

**Expected output (summary):**

```text
62 capture sets, 40920 payload cells, preprocess=none
method                              all   worst 10  others
A current sampler                   4.72    25.91    0.65
B per-frame 2-means threshold       1.39     6.42    0.43
E SVM 5 features / frame white ref  1.09     5.23    0.29
I SVM mean/white + nb/white         1.14     5.64    0.27
```

Conclusion: method I (linear, 2 features, no kernel) matches the best methods and is FPGA-friendly.

Detailed per-set output in `svm_cv_none/per_set.csv`.

---

## Step 3 — Export the rule as integer constants

Goal: convert float coefficients into 12-bit signed constants for RTL.

```bash
# white_ref = mean4 (old, 1.14 % CV error)
python dataset/export_linear_rule.py \
  --frames sim/cubeocc_top_all/symbols_review/symbols_review.json \
  --image-dir sim/cubeocc_top_all_guard/camera_gray \
  --white-ref mean4 --bits 12 \
  --out linear_rule

# white_ref = start (current, 0.91 % CV error) ← chosen
python dataset/export_linear_rule.py \
  --frames sim/cubeocc_top_all/symbols_review/symbols_review.json \
  --image-dir sim/cubeocc_top_all_guard/camera_gray \
  --white-ref start --bits 12 \
  --out linear_rule_start

# white_ref = bilinear (rejected, 1.32 %)
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
  "float_coef_mean_nb_white": [5.7529, -1.529, -3.1647],
  "int_bits": 12,
  "int_constants": {
    "Wc": 2047,
    "Wn2": -272,
    "Wn3": -181,
    "Wn4": -136,
    "Ww": -1126
  }
}
```

These 5 numbers are the `linear_rule_sampler.sv` parameters:

```systemverilog
parameter signed [11:0] WC  = 12'sd2047;
parameter signed [11:0] WN2 = -12'sd272;
parameter signed [11:0] WN3 = -12'sd181;
parameter signed [11:0] WN4 = -12'sd136;
parameter signed [11:0] WW  = -12'sd1126;
```

---

## Step 4 — Run XSim with the new RTL

Goal: run the full pipeline over 806 frames.

```bash
python dataset/run_cubeocc_top_image_sim.py \
  --out sim/cubeocc_top_all_start
```

**Expected output:**

```text
sim/cubeocc_top_all_start/
  results.json
  camera_gray/
  xsim_build/
    symbols_results.csv     ← includes the symbols_kind column
```

---

## Step 5 — Bit-exact confirmation of RTL vs integer model

Goal: prove the RTL computes exactly the same thing as the Python model.

```bash
python dataset/check_linear_rule_rtl.py \
  --sim-dir sim/cubeocc_top_all_start \
  --rule linear_rule_start/rule.json
```

**Expected output:**

```text
rule mode: start  constants: {'Wc': 2047, 'Wn2': -272, 'Wn3': -181, 'Wn4': -136, 'Ww': -1126}

kind counts / mismatches:
  0 ignored          frames    1   mismatches 0
  1 START            frames   62   mismatches 0
  2 DATA             frames  660   mismatches 0
  3 END              frames   61   mismatches 0
  4 discarded DATA   frames   22   mismatches 0
  5 ambiguous DATA   frames   61   mismatches 0

PASS: RTL words and ambiguity flags match the integer model
```

**This PASS is critical.** It means the RTL exactly matches the model, so the training results and the FPGA results are the same.

---

## Step 6 — Cell error on RTL output

Goal: final error number on the FPGA output.

```bash
python dataset/cell_error_report.py \
  --frames sim/cubeocc_top_all_start/results.json \
  --grades sim/cubeocc_top_all/symbols_review/symbols_review.json \
  --out cell_errors_start
```

**Expected output:**

```text
frames 806  cells 51584  cell errors 327  rate 0.63 %
black read as white: 244   white read as black: 83
worst sets:
  MLCAP_048_...         7.9 %
  MLCAP_026_...         6.0 %
  MLCAP_038_...         4.9 %
  ...
```

Reduction from **3.86 % to 0.63 %** on all cells.

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
  --errors cell_errors_ambig/per_frame.csv \
  --sim-dir sim/cubeocc_top_all_ambig \
  --exclude MLCAP_048
```

**Expected output:**

```text
--- Ambiguous Flag (kind=5) ---
Recall (Bad frames caught): 34 / 38 = 89.5%
Precision (Flagged frames that are bad): 34 / 61 = 55.7%
False Positive Rate (Good DATA frames lost): 19 / 624 = 3.0%

--- Discarded Flag (kind=4, by Guard) ---
Recall (Bad frames caught): 1 / 38 = 2.6%
False Positive Rate (Good DATA frames lost): 15 / 624 = 2.4%
```

Conclusion: kind=5 is useful (89 % of bad frames caught at 3 % cost). kind=4 (guard discard) does not help identify bad frames.

---

## Command summary table

| #   | Command                                   | Output                        | Result                   |
| --- | ----------------------------------------- | ----------------------------- | ------------------------ |
| 1   | `cell_error_report.py` (baseline)         | `cell_errors/`                | 3.86 %                   |
| 2   | `svm_cv_report.py --preprocess none`      | `svm_cv_none/per_set.csv`     | method I = 1.14 %        |
| 3   | `export_linear_rule.py --white-ref start` | `linear_rule_start/rule.json` | 5 constants              |
| 4   | `run_cubeocc_top_image_sim.py`            | `sim/cubeocc_top_all_start/`  | 806 frames               |
| 5   | `check_linear_rule_rtl.py`                | —                             | PASS, 0 mismatches       |
| 6   | `cell_error_report.py` (RTL)              | `cell_errors_start/`          | **0.63 %**               |
| 7   | `ambiguity_report.py --cv-splits 50`      | `ambiguity_cv/per_frame.csv`  | generalization confirmed |
| 8   | `evaluate_ambiguous_flag.py`              | —                             | recall 89 %              |

## Scripts that must NOT be committed

These three files are on the repo but their results are misleading because train and test cells come from the same capture set (data leakage):

- `dataset/test_svm_eval.py` — random 80/20 split at the **cell** level. The 98.5 % accuracy number comes from here.
- `dataset/train_v2_svm.py` — same problem with a different random split.
- `dataset/export_svm_weights.py` — still uses StandardScaler and 5 features, not RTL-ready.

**Valid number: 0.91 % CV error (= 99.09 % accuracy).**
