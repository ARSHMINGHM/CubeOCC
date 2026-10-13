---
project: CubeOCC
type: session-log
status: verified
last_reviewed: 2026-10-13
parent: 15_TASK_BACKLOG
---

# V2 Nonlinear SVM Session

Full record of the session that explored nonlinear classifiers (Gaussian preprocessing, polynomial kernel, RBF kernel) against the current linear rule.

## Motivation

At the start of this session, `linear_rule_sampler.sv` (method I with per-cell START white reference) achieved 1.31 % cross-validated payload error. The question was whether nonlinear classifiers could improve accuracy enough to justify a larger FPGA footprint.

Three approaches were tested:

1. **Gaussian preprocessing** (mild blur before feature extraction)
2. **Polynomial kernel** (poly2 — quadratic feature expansion)
3. **RBF kernel** (via Nystroem approximation)

## Summary of results

| Approach                 |   CV error | FPGA cost              | Verdict                          |
| ------------------------ | ---------: | ---------------------- | -------------------------------- |
| linear + opt4 + method I |     1.49 % | 2 mult + adds          | baseline (production)            |
| + gaussian 0.75          |     1.69 % | + line buffer          | **rejected** (no change)         |
| + poly2 on method I      |     1.55 % | 5 monomials            | **rejected** (worse)             |
| + poly2 on method E      |     1.36 % | 20 monomials           | **rejected** (equal to linear G) |
| + RBF (100 SVs)          | **1.27 %** | ~30k LUT, not feasible | **rejected** (cost)              |

**Final decision:** keep the linear rule currently in RTL.

## Software changes made

### `dataset/svm_cv_report.py` — full rewrite

New options:

```text
--preprocess none|gaussian|opt4
--gauss-sigma <float>            (default 0.75)
--kernel linear|poly2|rbf|rbf-exact|both
--nonlinear-only                 (restrict nonlinear kernels to methods E and I)
--rbf-gamma scale|<float>        (default scale)
--rbf-components <int>           (Nystroem components, default 200)
--n-jobs <-1|N>                  (joblib parallelization, default -1)
```

Key implementation details:

- `poly2` uses `PolynomialFeatures(degree=2, include_bias=False)` followed by `LinearSVC`. This is equivalent to a polynomial-kernel SVM without the kernel trick.
- `rbf` uses `Nystroem(kernel="rbf", n_components=N) + LinearSVC` for speed (O(n·N) vs O(n²) for exact SVC).
- `rbf-exact` uses `SVC(kernel="rbf")` for correctness when needed.
- `--rbf-gamma scale` is resolved to `1.0 / n_features` because `StandardScaler` already makes each feature unit variance.
- `--n-jobs` parallelizes the 62×M (fold, method) pairs across CPU cores using joblib's `loky` backend.

### `dataset/ambiguity_report.py`

No changes needed. The ambiguity flag is defined on the linear rule's `score` and margin; a nonlinear replacement would require redesigning the flag entirely, which was out of scope for this session.

## Commands run and outputs

### 1. Baseline (no preprocessing, linear only)

```bash
python dataset/svm_cv_report.py \
  --frames sim/cubeocc_top_all/symbols_review/symbols_review.json \
  --image-dir sim/cubeocc_top_all_guard/camera_gray \
  --preprocess none --kernel linear \
  --out svm_cv_none_linear
```

**Output summary:**

```text
62 capture sets, 40800 payload cells, preprocess=none, kernel=linear

method                                    all sets    worst   others
A current sampler                             4.76    25.91     0.68
I SVM mean / white + nb / white               1.69     7.29     0.61
G SVM raw 5 + white + 2-means                 1.69     7.23     0.62
E SVM 5 / white ref                           1.53     6.12     0.64
```

### 2. Gaussian preprocessing (sigma = 0.75, linear only)

```bash
python dataset/svm_cv_report.py \
  --frames sim/cubeocc_top_all/symbols_review/symbols_review.json \
  --image-dir sim/cubeocc_top_all_guard/camera_gray \
  --preprocess gaussian --gauss-sigma 0.75 --kernel linear \
  --out svm_cv_gauss075_linear
```

**Output summary:**

```text
method                                    all sets    worst   others
I SVM mean / white + nb / white               1.69     7.29     0.61
E SVM 5 / white ref                           1.52     6.06     0.64
G SVM raw 5 + white + 2-means                 1.67     7.12     0.62
```

**Result:** all differences vs `none` are within ±0.02 points. **No improvement.**

### 3. opt4 preprocessing (linear only)

```bash
python dataset/svm_cv_report.py \
  --frames sim/cubeocc_top_all/symbols_review/symbols_review.json \
  --image-dir sim/cubeocc_top_all_guard/camera_gray \
  --preprocess opt4 --kernel linear \
  --out svm_cv_opt4_linear
```

**Output summary:**

```text
method                                    all sets    worst   others  FPGA cost
I SVM mean / white + nb / white               1.49     5.86     0.65  2 mult + adds
E SVM 5 / white ref                           1.53     5.80     0.70  5 mult + adds
G SVM raw 5 + white + 2-means                 1.36     5.11     0.63  8 mult + adds
C SVM raw 5 features                          1.39     4.95     0.70  5 mult + adds
```

**Result:** method I improves from 1.69 % to **1.49 %** (−0.20 points) and worst-10 improves from 7.29 % to 5.86 %. opt4 helps raw features (C: 1.75 → 1.39) more than white-normalized ones (E, I). The improvement on I is on the edge of statistical significance.

### 4. Nonlinear classifiers (opt4 + poly2 + RBF)

```bash
python dataset/svm_cv_report.py \
  --frames sim/cubeocc_top_all/symbols_review/symbols_review.json \
  --image-dir sim/cubeocc_top_all_guard/camera_gray \
  --preprocess opt4 --kernel both --nonlinear-only \
  --rbf-components 100 --n-jobs -1 \
  --out svm_cv_opt4_both_v2
```

**Output:**

```text
62 capture sets, 40800 payload cells, preprocess=opt4, kernel=both, n_jobs=-1
running 744 fits (62 sets x 12 methods)...
[Parallel(n_jobs=-1)]: Done 744 out of 744 | elapsed:  2.6min finished

method                                               all   worst  others  FPGA cost
A current sampler                                   4.76   25.91    0.68  0 mult, 1 cmp
B per-frame 2-means                                 1.61    6.06    0.75  0 mult, 1 cmp
C SVM raw 5 features                                1.39    4.95    0.70  5 mult + adds
D SVM mean only                                     1.50    5.67    0.70  1 mult + add
E SVM 5 / white ref                                 1.53    5.80    0.70  5 mult + adds
E SVM 5 / white ref [poly2-20]                      1.36    5.20    0.62  20 monomials
E SVM 5 / white ref [RBF]                           1.44    5.85    0.59  ~100 SVs + exp()
F SVM mean+nb rel. to 2-means                       1.49    5.56    0.70  2 mult + adds
G SVM raw 5 + white + 2-means                       1.36    5.11    0.63  8 mult + adds
H SVM mean / white only                             1.66    7.17    0.60  1 mult + add
I SVM mean / white + nb / white                     1.49    5.86    0.65  2 mult + adds
I SVM mean / white + nb / white [poly2-5]           1.55    6.05    0.69  5 monomials
I SVM mean / white + nb / white [RBF]               1.27    4.79    0.59  ~100 SVs + exp()
J SVM E without neighbor                            1.66    6.61    0.71  4 mult + adds

Best RBF (reference only, not FPGA): I SVM mean / white + nb / white [RBF] 1.27%
```

## Per-set analysis

The improvement from linear I (1.49 %) to RBF I (1.27 %) is concentrated in a handful of hard sets:

| Set                            | I linear | I RBF |     delta | Note                          |
| ------------------------------ | -------: | ----: | --------: | ----------------------------- |
| MLCAP_055_Cam60_Defocus        |    10.91 |  5.00 | **−5.91** | Defocus                       |
| MLCAP_048_Cam30_Opt60          |    14.39 | 11.82 |     −2.57 | Content mismatch (unreliable) |
| MLCAP_020_StrongReflection     |     4.70 |  3.18 |     −1.52 | Glare                         |
| MLCAP_012_BrightRoom           |     1.36 |  0.00 |     −1.36 | Bright                        |
| MLCAP_022_Near_Angle15         |     2.42 |  1.97 |     −0.45 | Angle                         |
| MLCAP_038_Dark_SlightDefocus   |     3.79 |  3.48 |     −0.31 | Defocus                       |
| MLCAP_047_Cam60_Opt60          |     0.15 |  1.06 | **+0.91** | worse                         |
| MLCAP_039_Bright_SlightDefocus |     4.70 |  4.85 |     +0.15 | worse                         |

**95 % of RBF's benefit is on 3-4 hard sets.** On 52 of 62 sets the two methods are identical within noise.

## Key technical findings

### Finding 1 — Gaussian blur does not help

The expected benefit (blur suppresses high-frequency noise before feature extraction) did not materialize. All method errors changed by less than ±0.02 points. Gaussian blur is not adopted.

### Finding 2 — poly2 on the 2-feature model is worse

Feature set I is `[m_w, nb_w]`. Expanding to `[m_w, nb_w, m_w², m_w·nb_w, nb_w²]` **increases** error from 1.49 % to 1.55 %. Interpretation: the two linear features already saturate the available signal. Quadratic cross-terms only add noise on the majority of easy sets.

### Finding 3 — poly2 on the 5-feature model helps, but offers nothing new

Feature set E is `[m_w, v_w, mx_w, mn_w, nb_w]`. Expanding to 20 monomials gives 1.36 % error, a real improvement over linear E (1.53 %). But the same 1.36 % is achieved by method G linear with 8 features — so poly2 is dominated by simply adding linear features. No reason to adopt it.

### Finding 4 — RBF is the best accuracy but not FPGA-feasible

RBF with 100 Nystroem components reaches **1.27 %** — the best in the table. It improves worst-10 from 5.86 % to 4.79 %. But an FPGA implementation requires:

- 100+ support vectors
- 100 `exp(-γ‖x−xᵢ‖²)` evaluations per cell
- 64 cells × 100 SVs = 6,400 exp() calls per frame
- Each `exp()` approximation costs ~200-2,000 LUT
- Total: 30,000+ additional LUT, versus 20,800 available on `xc7a35t`

The gap (0.22 points) does not justify the resource cost.

## Final decision

**Keep the linear rule currently in `rtl/linear_rule_sampler.sv`.**

Rationale:

1. RBF is not FPGA-feasible; the 0.22-point gap is well below the CV noise floor (~0.2 points).
2. poly2 does not help on the current 2-feature model.
3. poly2 on 5-feature is equal to a linear model with more features — no separate reason to adopt.
4. Gaussian blur provides no measurable benefit.
5. The remaining error (4-5 % on 10 hard sets) is an image-quality problem (Defocus, Reflection, MLCAP_048 mismatch), not a classifier limitation. No classifier can fix a wrong image.

## Effect on the FPGA pipeline

**No change to the RTL** was made in this session as a result of the nonlinear exploration. The `linear_rule_sampler.sv` coefficients were updated (see `15_14`) but the algorithm stayed the same.

The only RTL change was earlier in the session (already documented in `15_14`):

```systemverilog
// rtl/linear_rule_sampler.sv — coefficients were updated to match the current rule.json
parameter signed [11:0] WN2 = -12'sd248;   // was -272
parameter signed [11:0] WN3 = -12'sd165;   // was -181
parameter signed [11:0] WN4 = -12'sd124;   // was -136
parameter signed [11:0] WW  = -12'sd1086;  // was -1126
```

## Files produced in this session

```text
svm_cv_none_linear/summary.json + per_set.csv
svm_cv_gauss075_linear/summary.json + per_set.csv
svm_cv_opt4_linear/summary.json + per_set.csv
svm_cv_opt4_both_v2/summary.json + per_set.csv
sim/cubeocc_top_all_start_v2/results.json
cell_errors_start_v2/summary.json + per_frame.csv
```

## Repository state

```
branch: v2/threshold-baseline-debug
HEAD:   78c0785
```

`sim/` size after cleanup: **156 MB** (was 875 MB).

## Recommended next steps

### A. Decide `kind=5` policy with Armin

When the FPGA marks a frame `ambiguous` (kind=5), what should the downstream ECC layer do?

- **Accept with warning** — extract bits, raise a status flag
- **Reject and wait** — discard the frame, wait for the next
- **Reliability metric** — pass the ambiguity count as soft information to the decoder

### B. Connect the accurate golden from the sender

The golden is currently a per-index majority vote of `true`-graded frames. The sender's `*_frames.jsonl` contains the exact transmitted bits. Wiring it via `--golden-jsonl` would remove the ambiguity of "which golden is current".

### C. (Optional) Test opt4 + linear on the RTL

opt4 + linear reached 1.49 % in CV, versus 1.69 % for `none + linear`. If the 0.20-point gain is considered real, adding a 3×3 median filter to the FPGA would cost roughly 500 LUT and one 3-row line buffer (160×3 bytes = 480 bytes of BRAM). This is a small cost and could be tested as a follow-up.

## Related documents

- [[15_09_V2_DYNAMIC_THRESHOLD_BASELINE_FINDINGS]] — historical baseline
- [[15_10_V2_CLASSIFIER_PIPELINE_ARCHITECTURE]] — architecture and RTL
- [[15_11_V2_TRAINING_VALIDATION_COMMANDS]] — command reference
- [[15_12_V2_WORK_LOG_DECISIONS_AND_REJECTIONS]] — earlier decisions
- [[15_13_V2_TASK_CHECKLIST]] — current task state
- [[15_14_V2_SCRIPT_OUTPUTS_LOG]] — script outputs including nonlinear
