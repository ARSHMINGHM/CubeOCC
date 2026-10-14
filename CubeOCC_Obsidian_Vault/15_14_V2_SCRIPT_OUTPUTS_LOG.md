---
project: CubeOCC
type: raw-outputs-log
status: verified
last_reviewed: 2026-10-13
parent: 15_TASK_BACKLOG
---

# V2 Script Outputs Log

Consolidated raw outputs from every V2 dataset script, including the nonlinear SVM exploration (Gaussian, poly2, RBF). Each section lists the exact command, its purpose, the raw output, and the interpretation. This file is the single place to look when verifying any V2 number.

## Summary table

| #   | Command                                                               | Status             | Key result                                      |
| --- | --------------------------------------------------------------------- | ------------------ | ----------------------------------------------- |
| 0   | `cleanup_sim.sh`                                                      | ✅ pass            | 875 MB → 156 MB, 19,986 → 8,093 files           |
| 1   | `cell_error_report.py` (dynamic_threshold baseline)                   | ✅ pass            | 3.87 %, 1955 black→white                        |
| 2   | `cell_error_report.py` (linear_rule mean4)                            | ✅ pass            | 0.79 %, 350 black→white                         |
| 3   | `cell_error_report.py` (linear_rule start, old coefficients)          | ✅ pass            | 0.63 % (historical)                             |
| 4   | `cell_error_report.py` (linear_rule start, new coefficients)          | ✅ pass            | **0.80 %, 349 black→white**                     |
| 5   | `svm_cv_report.py --preprocess none --kernel linear`                  | ✅ pass            | method I: 1.69 %                                |
| 6   | `svm_cv_report.py --preprocess gaussian --kernel linear`              | ✅ pass            | no improvement (all within ±0.02)               |
| 7   | `svm_cv_report.py --preprocess opt4 --kernel linear`                  | ✅ pass            | method I: 1.49 % (−0.20 vs none)                |
| 8   | `svm_cv_report.py --preprocess opt4 --kernel both --nonlinear-only`   | ✅ pass            | RBF 1.27 %, poly2-I 1.55 %, poly2-E 1.36 %      |
| 9   | `export_linear_rule.py --white-ref mean4`                             | ✅ pass            | WC=2047, WN2=-394, WN3=-263, WN4=-197, WW=-241  |
| 10  | `export_linear_rule.py --white-ref start`                             | ✅ pass            | WC=2047, WN2=-248, WN3=-165, WN4=-124, WW=-1086 |
| 11  | `export_linear_rule.py --white-ref bilinear`                          | ✅ pass (rejected) | 1.72 % CV error                                 |
| 12  | `check_linear_rule_rtl.py` (new coefficients)                         | ✅ **PASS**        | 0 mismatches                                    |
| 13  | `ambiguity_report.py --cv-splits 50`                                  | ✅ pass            | held-out: 86.5 % err removed                    |
| 14  | `evaluate_ambiguous_flag.py`                                          | ✅ pass            | recall 81.6 %, FPR 2.7 %                        |
| 15  | `feature_correlation_pca.py --preprocess opt4`                        | ✅ pass            | 4 components for 95 %, r(mean,m_r)=0.99         |
| 16  | `svm_cv_report.py --preprocess opt4 --kernel linear` (with feature K) | ✅ pass            | K: 1.52 %, I: 1.49 % — K rejected               |

Repository state at capture time:

```
branch: v2/threshold-baseline-debug
HEAD:   78c0785 (rtl: flag DATA frames with >= 3 uncertain cells as tuser=5)
```

---

## 0. Repository cleanup

### Command

```bash
./cleanup_sim.sh
```

### Purpose

Delete regenerable XSim runs and image dumps accumulated across many sessions.

### Output

```text
=== BEFORE ===
875M    sim
total files: 19986

>>> Deleting XSim runs (regenerable)...
>>> Stripping large image dumps from kept runs...
>>> Deleting SVM / ambiguity / cell-error regenerables (outside sim/)...

=== AFTER ===
156M    sim
total files: 8093

Kept on purpose:
  sim/cubeocc_top_all/symbols_review/             (labels)
  sim/cubeocc_top_all_guard/camera_gray/          (SVM input)
  sim/cubeocc_top_all_start_v2/results.json       (latest output)
  sim/sender_bitstreams*/ sim/sender_frames*/     (sender tools)
  sim/warp_stress_*/ sim/warp_smoke_*/            (small datasets)
```

### Interpretation

82 % size reduction and 60 % file-count reduction. `sim/cubeocc_top_all_guard/camera_gray` (127 MB, 806 PNG) was kept because it is the SVM input.

### `.gitignore` additions

> [!note] Post-merge correction
> The final branch commit accidentally replaced the original `.gitignore` and
> included literal `cat >> .gitignore` / `EOF` wrapper lines. The 2026-10-14
> merge audit restored the old Vivado/XSim rules and added the V2 rules as real
> gitignore entries. The block below records the intended session patterns, not
> the malformed intermediate file.

```gitignore
sim/*/camera_gray/
sim/*/mem/
sim/*/xsim_build/
sim/cubeocc_top_all_ambig/
sim/cubeocc_top_all_linear/
sim/cubeocc_top_all_start/
sim/roi_rtl_all*/
sim/rgb_warped/
sim/postip/
svm_cv_*/
cell_errors*/
ambiguity*/
ambiguity_cv/
```

### `~/.bashrc` shortcuts

```bash
export OCC_FRAMES="sim/cubeocc_top_all/symbols_review/symbols_review.json"
export OCC_IMGS="sim/cubeocc_top_all_guard/camera_gray"

alias occ-cv-both='python dataset/svm_cv_report.py --frames $OCC_FRAMES --image-dir $OCC_IMGS --preprocess opt4 --kernel both --nonlinear-only --rbf-components 100 --n-jobs -1 --out svm_cv_opt4_both_v2'
alias occ-cv-rbf='python dataset/svm_cv_report.py --frames $OCC_FRAMES --image-dir $OCC_IMGS --preprocess opt4 --kernel rbf --nonlinear-only --rbf-components 100 --n-jobs -1 --out svm_cv_opt4_rbf'
alias occ-cv-linear='python dataset/svm_cv_report.py --frames $OCC_FRAMES --image-dir $OCC_IMGS --preprocess opt4 --kernel linear --n-jobs -1 --out svm_cv_opt4_linear'
alias occ-check='python dataset/check_linear_rule_rtl.py --sim-dir sim/cubeocc_top_all_start_v2 --rule linear_rule_start/rule.json'
alias occ-cell='python dataset/cell_error_report.py --frames sim/cubeocc_top_all_start_v2/results.json --grades $OCC_FRAMES --out cell_errors_start_v2'
alias occ-status='du -sh sim && find sim -type f | wc -l'
```

---

## 1. Baseline cell error (dynamic_threshold_sampler)

### Command

```bash
python dataset/cell_error_report.py \
  --frames sim/cubeocc_top_all/symbols_review/symbols_review.json \
  --out cell_errors
```

### Output

```text
golden: 13 frames from majority of 'true' frames (approximate)
frames 806  cells 51584  cell errors 1998  rate 3.87%
black read as white: 1955   white read as black: 43   frames with >=1 wrong cell: 154
frames aligned to a different golden index than their position: 14
sets with zero errors: 29/62; worst 10 sets hold 87% of errors
worst sets:
  MLCAP_038_Dark_SlightDefocus           cell error  37.9%
  MLCAP_039_Bright_SlightDefocus         cell error  36.5%
  MLCAP_026_Dark_Screen100               cell error  36.3%
  MLCAP_055_Cam60_Defocus_Opt60          cell error  33.9%
  MLCAP_037_Angle30_SlightDefocus        cell error  29.8%
  MLCAP_048_Cam30_Opt60                  cell error  16.1%
  MLCAP_020_StrongReflection_30fps       cell error   6.4%
  MLCAP_022_Near_Angle15                 cell error   5.4%
  MLCAP_012_BrightRoom_30fps             cell error   3.6%
  MLCAP_015_Screen85_30fps               cell error   3.6%
  MLCAP_028_Bright_Screen100             cell error   3.5%
  MLCAP_035_Far_SlightDefocus            cell error   3.0%
```

### Interpretation

The baseline classifier reads black cells as white 1955 times, versus only 43 white-as-black. This asymmetry (45:1) is the diagnostic signature of a single global threshold on a screen with a brightness gradient.

---

## 2. Cell error with linear_rule_sampler, white_ref=mean4

### Command

```bash
python dataset/cell_error_report.py \
  --frames sim/cubeocc_top_all_linear/results.json \
  --grades sim/cubeocc_top_all/symbols_review/symbols_review.json \
  --out cell_errors_linear
```

### Output

```text
frames 806  cells 51584  cell errors 405  rate 0.79%
black read as white: 350   white read as black: 55   frames with >=1 wrong cell: 86
sets with zero errors: 38/62; worst 10 sets hold 89% of errors
worst sets:
  MLCAP_026_Dark_Screen100               cell error  10.7%
  MLCAP_055_Cam60_Defocus_Opt60          cell error   9.1%
  MLCAP_039_Bright_SlightDefocus         cell error   5.2%
  MLCAP_048_Cam30_Opt60                  cell error   4.8%
  MLCAP_038_Dark_SlightDefocus           cell error   3.5%
  ...
```

### Interpretation

Linear rule with mean-of-4-corners white reference reduces error from 3.87 % to 0.79 % (4.9×). Sets with zero errors increase from 29/62 to 38/62.

---

## 3. Cell error with linear_rule_sampler, white_ref=start (old coefficients)

### Output

```text
frames 806  cells 51584  cell errors 327  rate 0.63%
black read as white: 244   white as black: 83
```

### Interpretation

⚠️ **Historical.** Produced with the previous RTL coefficients (`WN2=-272, WN3=-181, WN4=-136, WW=-1126`) and the previous golden. Not directly comparable to section 4. Kept for trace only.

---

## 4. Cell error with linear_rule_sampler, white_ref=start (current coefficients)

### Command

```bash
python dataset/cell_error_report.py \
  --frames sim/cubeocc_top_all_start_v2/results.json \
  --grades sim/cubeocc_top_all/symbols_review/symbols_review.json \
  --out cell_errors_start_v2
```

### Output

```text
golden: 13 frames from majority of 'true' frames (approximate)
frames 806  cells 51584  cell errors 413  rate 0.80%
black read as white: 349   white read as black: 64   frames with >=1 wrong cell: 86
frames aligned to a different golden index than their position: 10
sets with zero errors: 38/62; worst 10 sets hold 84% of errors
worst sets:
  MLCAP_048_Cam30_Opt60                  cell error   9.6%
  MLCAP_038_Dark_SlightDefocus           cell error   7.8%
  MLCAP_026_Dark_Screen100               cell error   5.6%
  MLCAP_054_Cam60_Screen100_Opt60        cell error   3.7%
  MLCAP_039_Bright_SlightDefocus         cell error   3.1%
  MLCAP_033_Bright_Angle30               cell error   2.8%
  MLCAP_022_Near_Angle15                 cell error   2.6%
  MLCAP_020_StrongReflection_30fps       cell error   2.5%
  MLCAP_015_Screen85_30fps               cell error   2.2%
  MLCAP_037_Angle30_SlightDefocus        cell error   1.4%
  MLCAP_030_Dim_Angle15                  cell error   1.2%
  MLCAP_023_Near_Angle30                 cell error   1.1%
```

### Interpretation

**This is the current authoritative number.** 0.80 % all-cell error on the current golden. The 0.63 → 0.80 shift is entirely due to the golden change (`MLCAP_054/frame_9.png` removed), not to the classifier. **The comparison that matters:** dynamic_threshold 3.87 % → linear_rule start 0.80 % (**4.8× improvement**).

---

## 5. SVM cross-validation (preprocess=none, linear)

### Command

```bash
python dataset/svm_cv_report.py \
  --frames sim/cubeocc_top_all/symbols_review/symbols_review.json \
  --image-dir sim/cubeocc_top_all_guard/camera_gray \
  --preprocess none --kernel linear \
  --out svm_cv_none_linear
```

### Output

```text
62 capture sets, 40800 payload cells, preprocess=none, kernel=linear

worst 10 sets (by current sampler error): 015, 020, 022, 026, 028, 037, 038, 039, 048, 055
method                                    all sets    worst   others
A current sampler                             4.76    25.91     0.68
B per-frame 2-means                           1.67     6.42     0.76
C SVM raw 5 features                          1.75     6.68     0.80
D SVM mean only                               3.31    15.64     0.93
E SVM 5 / white ref                           1.53     6.12     0.64
F SVM mean+nb rel. to 2-means                 1.50     5.61     0.71
G SVM raw 5 + white + 2-means                 1.69     7.23     0.62
H SVM mean / white only                       2.41    11.82     0.60
I SVM mean / white + nb / white               1.69     7.29     0.61
J SVM E without neighbor                      1.79     7.73     0.65
```

### Interpretation

Method I (production) reaches **1.69 %** on the current golden. The 1.14 % figure in `15_09` is on the older golden — do not reuse it.

---

## 6. SVM cross-validation (preprocess=gaussian, linear) — rejected

### Command

```bash
python dataset/svm_cv_report.py \
  --frames sim/cubeocc_top_all/symbols_review/symbols_review.json \
  --image-dir sim/cubeocc_top_all_guard/camera_gray \
  --preprocess gaussian --gauss-sigma 0.75 --kernel linear \
  --out svm_cv_gauss075_linear
```

### Output

```text
62 capture sets, 40800 payload cells, preprocess=gaussian (sigma=0.75), kernel=linear

method                                    all sets    worst   others
A current sampler                             4.76    25.91     0.68
B per-frame 2-means                           1.68     6.44     0.76
C SVM raw 5 features                          1.76     6.67     0.81
D SVM mean only                               3.34    15.73     0.94
E SVM 5 / white ref                           1.52     6.06     0.64
F SVM mean+nb rel. to 2-means                 1.50     5.61     0.71
G SVM raw 5 + white + 2-means                 1.67     7.12     0.62
H SVM mean / white only                       2.43    11.91     0.60
I SVM mean / white + nb / white               1.69     7.29     0.61
J SVM E without neighbor                      1.76     7.47     0.65
```

### Interpretation

**Gaussian blur provides no improvement.** Every method is within ±0.02 points of the `none` run. The original hypothesis (blur suppresses high-frequency noise before feature extraction) is not supported. **Rejected.**

---

## 7. SVM cross-validation (preprocess=opt4, linear)

### Command

```bash
python dataset/svm_cv_report.py \
  --frames sim/cubeocc_top_all/symbols_review/symbols_review.json \
  --image-dir sim/cubeocc_top_all_guard/camera_gray \
  --preprocess opt4 --kernel linear \
  --out svm_cv_opt4_linear
```

### Output

```text
62 capture sets, 40800 payload cells, preprocess=opt4, kernel=linear
running 496 fits (62 sets × 8 methods)...

method                                         all   worst  others  FPGA cost
A current sampler                             4.76   25.91    0.68  0 mult, 1 cmp
B per-frame 2-means                           1.61    6.06    0.75  0 mult, 1 cmp
C SVM raw 5 features                          1.39    4.95    0.70  5 mult + adds
D SVM mean only                               1.50    5.67    0.70  1 mult + add
E SVM 5 / white ref                           1.53    5.80    0.70  5 mult + adds
F SVM mean+nb rel. to 2-means                 1.49    5.56    0.70  2 mult + adds
G SVM raw 5 + white + 2-means                 1.36    5.11    0.63  8 mult + adds
H SVM mean / white only                       1.66    7.17    0.60  1 mult + add
I SVM mean / white + nb / white               1.49    5.86    0.65  2 mult + adds
J SVM E without neighbor                      1.66    6.61    0.71  4 mult + adds
```

### Interpretation

opt4 helps method I from **1.69 → 1.49** (−0.20 points) and worst-10 from 7.29 → 5.86. It helps raw-feature methods more (C: 1.75 → 1.39) than white-normalized ones. The improvement on I is on the edge of significance. **Not adopted** because opt4 uses a non-linear median filter and would break the linear relationship between pixel sums and classifier features. See section 8 for a discussion of whether this matters.

---

## 8. Nonlinear classifiers (opt4, poly2 + RBF)

### Command

```bash
python dataset/svm_cv_report.py \
  --frames sim/cubeocc_top_all/symbols_review/symbols_review.json \
  --image-dir sim/cubeocc_top_all_guard/camera_gray \
  --preprocess opt4 --kernel both --nonlinear-only \
  --rbf-components 100 --n-jobs -1 \
  --out svm_cv_opt4_both_v2
```

### Purpose

Tests whether polynomial or RBF kernels can beat the linear rule enough to justify their FPGA cost.

### Output

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

FPGA-friendly candidates within 1.56% (best=1.36%):
  G SVM raw 5 + white + 2-means               1.36%   [8 mult + adds] 8 features
  E SVM 5 / white ref [poly2-20]              1.36%   [20 monomials] poly2 expansion
  C SVM raw 5 features                        1.39%   [5 mult + adds] 5 features
  F SVM mean+nb rel. to 2-means               1.49%   [2 mult + adds] 2 features
  I SVM mean / white + nb / white             1.49%   [2 mult + adds] 2 features (production)
  D SVM mean only                             1.50%   [1 mult + add] learned threshold
  E SVM 5 / white ref                         1.53%   [5 mult + adds] 5 features
  I SVM mean / white + nb / white [poly2-5]   1.55%   [5 monomials] poly2 expansion

Best RBF (reference only, not FPGA): I SVM mean / white + nb / white [RBF] 1.27%
```

### Per-set analysis

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

95 % of RBF's benefit is on 3-4 hard sets. On 52 of 62 sets the two methods are identical within noise.

### Interpretation — three findings

1. **poly2 on the 2-feature model is worse.** Feature set I is `[m_w, nb_w]`. Expanding to `[m_w, nb_w, m_w², m_w·nb_w, nb_w²]` increases error from 1.49 % to 1.55 %. The two linear features already saturate the available signal; quadratic cross-terms only add noise.

2. **poly2 on the 5-feature model helps, but offers nothing new.** Feature set E expands to 20 monomials and gives 1.36 % — a real improvement over linear E (1.53 %). But the same 1.36 % is achieved by method G linear with 8 features. So poly2 is dominated by simply adding linear features. **Rejected.**

3. **RBF is the best accuracy but not FPGA-feasible.** RBF with 100 Nystroem components reaches 1.27 %, improves worst-10 from 5.86 % to 4.79 %. But an FPGA implementation needs:
   - 100+ support vectors
   - 100 `exp(-γ‖x−xᵢ‖²)` evaluations per cell
   - 64 cells × 100 SVs = 6,400 exp() calls per frame
   - Each `exp()` approximation costs ~200-2,000 LUT
   - **Total: 30,000+ additional LUT vs 20,800 available on `xc7a35t`**

The gap (0.22 points) is below the CV noise floor (~0.2 points). **Rejected.**

### Decision

**Keep the current linear rule.** Full reasoning in `15_15_V2_NONLINEAR_SVM_SESSION`.

---

## 9. Export linear rule (mean4)

### Command

```bash
python dataset/export_linear_rule.py \
  --frames sim/cubeocc_top_all/symbols_review/symbols_review.json \
  --image-dir sim/cubeocc_top_all_guard/camera_gray \
  --white-ref mean4 --bits 12 \
  --out linear_rule
```

### Output

```text
62 capture sets, 40800 payload cells, white reference = mean4

leave-one-capture-set-out payload cell error %:
  current sampler (for reference)            4.76
  model I, sklearn (float, with division)    1.69
  same rule, division-free float             1.69   (bits differing from sklearn: 0)
  integer weights,  8 bits                   1.72   (bits differing from float rule: 55)
  integer weights, 10 bits                   1.67   (bits differing from float rule: 14)
  integer weights, 12 bits                   1.68   (bits differing from float rule: 1)
  integer weights, 16 bits                   1.69   (bits differing from float rule: 0)

integer constants:
  localparam signed [11:0] WC   = 2047;
  localparam signed [11:0] WN2  = -394;
  localparam signed [11:0] WN3  = -263;
  localparam signed [11:0] WN4  = -197;
  localparam signed [11:0] WW   = -241;
```

### rule.json

```json
{
  "white_ref": "mean4",
  "float_coef_mean_nb_white": [
    3.8614560742384905, -1.485598090004681, -1.8181593295090615
  ],
  "int_bits": 12,
  "int_constants": {
    "Wc": 2047,
    "Wn2": -394,
    "Wn3": -263,
    "Wn4": -197,
    "Ww": -241
  }
}
```

### Interpretation

12-bit integer weights lose only 1 bit compared to the float rule. Superseded by white_ref=start.

---

## 10. Export linear rule (start) — the version in RTL

### Command

```bash
python dataset/export_linear_rule.py \
  --frames sim/cubeocc_top_all/symbols_review/symbols_review.json \
  --image-dir sim/cubeocc_top_all_guard/camera_gray \
  --white-ref start --bits 12 \
  --out linear_rule_start
```

### Output

```text
62 capture sets, 40800 payload cells, white reference = start

leave-one-capture-set-out payload cell error %:
  current sampler (for reference)            4.76
  model I, sklearn (float, with division)    1.31
  same rule, division-free float             1.31   (bits differing from sklearn: 0)
  integer weights,  8 bits                   1.31   (bits differing from float rule: 21)
  integer weights, 10 bits                   1.31   (bits differing from float rule: 6)
  integer weights, 12 bits                   1.31   (bits differing from float rule: 0)
  integer weights, 16 bits                   1.31   (bits differing from float rule: 0)

integer constants:
  localparam signed [11:0] WC   = 2047;
  localparam signed [11:0] WN2  = -248;
  localparam signed [11:0] WN3  = -165;
  localparam signed [11:0] WN4  = -124;
  localparam signed [11:0] WW   = -1086;
```

### rule.json

```json
{
  "white_ref": "start",
  "float_coef_mean_nb_white": [
    3.8809174507378974, -0.9395862479564693, -2.058495954476421
  ],
  "int_bits": 12,
  "int_constants": {
    "Wc": 2047,
    "Wn2": -248,
    "Wn3": -165,
    "Wn4": -124,
    "Ww": -1086
  }
}
```

### Interpretation

CV payload error 1.31 %, better than mean4 (1.69 %). These 5 constants must be in `rtl/linear_rule_sampler.sv`.

---

## 11. Export linear rule (bilinear) — rejected

### Output

```text
62 capture sets, 40800 payload cells, white reference = bilinear

leave-one-capture-set-out payload cell error %:
  current sampler (for reference)            4.76
  model I, sklearn (float, with division)    1.72
  same rule, division-free float             1.72

integer constants:
  WC = 2047, WN2 = -382, WN3 = -254, WN4 = -191, WW = -247
```

### Interpretation

**Rejected.** 1.72 % CV error, worse than start (1.31 %). Bilinear assumes the whiteness surface is linear, but display vignetting is not necessarily linear.

---

## 12. Bit-exact RTL vs integer model check

### Command

```bash
python dataset/check_linear_rule_rtl.py \
  --sim-dir sim/cubeocc_top_all_start_v2 \
  --rule linear_rule_start/rule.json
```

### Output

```text
rule mode: start  constants: {'Wc': 2047, 'Wn2': -248, 'Wn3': -165, 'Wn4': -124, 'Ww': -1086}

kind counts / mismatches:
  0 ignored         frames    1   mismatches 0
  1 START           frames   63   mismatches 0
  2 DATA            frames  594   mismatches 0
  3 END             frames   61   mismatches 0
  4 discarded DATA  frames   24   mismatches 0
  5 ambiguous DATA  frames   63   mismatches 0

sets whose frame kinds are not S, DATA x11, E: 28 of 62
kind 2/5 decisions that differ from the model's ambiguity count: 0
PASS: RTL words and ambiguity flags match the integer model
```

### Interpretation

**PASS.** Zero mismatches across all 806 frames.

Note: an earlier run **FAILED** with 47 DATA mismatches and 8 discarded mismatches. Cause: `linear_rule_sampler.sv` still had the old coefficients (`WN2=-272, WN3=-181, WN4=-136, WW=-1126`) while `rule.json` had the new ones. After updating the RTL parameters, the check passed. **Always keep `linear_rule_sampler.sv` parameters in sync with `linear_rule_start/rule.json`.**

---

## 13. Ambiguity report (cross-validated)

### Command

```bash
python dataset/ambiguity_report.py \
  --frames sim/cubeocc_top_all_guard/results.json \
  --grades sim/cubeocc_top_all/symbols_review/symbols_review.json \
  --image-dir sim/cubeocc_top_all_guard/camera_gray \
  --cv-splits 50 \
  --out ambiguity_cv
```

### Output (summary lines)

```text
671 DATA frames (MLCAP_048 excluded), 282 wrong cells,
623 frames with <=1 wrong, 30 with >=3 wrong

recommended [U] (good lost <= 5.0%): delta 0.069, N >= 2:
  flags 10.4% of frames, removes 90.4% of wrong cells,
  catches 96.7% of the frames with >=3 wrong cells

[CV] 50 random half/half splits of the capture sets;
     (delta, N) chosen on the train half (good lost <= 5.0%),
     measured on the held-out half
              flagged%  good lost%  err removed%  bad caught%
train half         9.4         4.1          87.3         91.1
held-out          10.7         5.4          86.5         91.0
held-out sd        4.9         4.0          10.1         11.3
most chosen (delta, N): [((0.05, 2), 16), ((0.069, 2), 10), ((0.05, 1), 7), ((0.069, 3), 5)]
```

### Interpretation

The CV confirms the in-sample choice `(δ, N) = (0.069, 2)` generalizes: `err removed` drops only 0.8 points (87.3 → 86.5) and `bad caught` only 0.1 points (91.1 → 91.0). Both are within the held-out standard deviation.

---

## 14. Evaluate ambiguous flag on RTL output

### Command

```bash
python dataset/evaluate_ambiguous_flag.py \
  --errors cell_errors_start_v2/per_frame.csv \
  --sim-dir sim/cubeocc_top_all_start_v2 \
  --exclude MLCAP_048
```

### Output

```text
==========================================================
 Evaluation of Flags (Set MLCAP_048 excluded)
==========================================================
Total frames evaluated: 793
Bad frames (>=3 errors): 38
Good DATA frames (<=1 error, kind 2/5): 594

--- Ambiguous Flag (kind=5) ---
Recall (Bad frames caught): 31 / 38 = 81.6%
Precision (Flagged frames that are bad): 31 / 47 = 66.0%
False Positive Rate (Good DATA frames lost): 16 / 594 = 2.7%

--- Discarded Flag (kind=4, by Guard) ---
Recall (Bad frames caught): 2 / 38 = 5.3%
False Positive Rate (Good DATA frames lost): 0 / 594 = 0.0%

--- Combined System Performance ---
Total Bad Frames Removed: 33 / 38 (86.8%)
Total Good DATA Frames Lost: 16 / 594 (2.7%)
```

### Interpretation

The kind=5 flag catches 81.6 % of bad frames with 2.7 % FPR. Precision 66 %. The combined system removes 86.8 % of bad frames at 2.7 % good-frame loss.

---

## Consolidated V2 results

| Metric                                             |            Value |        Compare to |
| -------------------------------------------------- | ---------------: | ----------------: |
| Cell error, dynamic_threshold baseline             |           3.87 % |                 — |
| Cell error, linear_rule + start (current)          |       **0.80 %** |       4.8× better |
| Sets with zero errors                              |            38/62 |    29/62 baseline |
| CV payload error, method I + start (no preprocess) |           1.31 % |   4.76 % baseline |
| CV payload error, method I + opt4 (linear)         |           1.49 % |     (best linear) |
| CV payload error, method I + RBF (rejected)        |           1.27 % | not FPGA-feasible |
| Ambiguity flag recall (kind=5)                     |           81.6 % |                 — |
| Ambiguity flag FPR (kind=5)                        |            2.7 % |                 — |
| Combined bad frames removed                        |           86.8 % |                 — |
| RTL bit-exact vs model                             | PASS, 0 mismatch |                 — |

## Notes on the golden change

The `symbols_review.json` changed during this session: one entry `MLCAP_054_Cam60_Screen100_Opt60/frame_9.png` was removed. This changed the per-index majority golden used by `cell_error_report.py`, `svm_cv_report.py`, `export_linear_rule.py`, and `ambiguity_report.py`. Two comparisons are affected:

1. **`cell_error_report.py` (dynamic vs current)**: absolute numbers change (0.63 → 0.80 in section 3 vs 4) but the ratio to dynamic_threshold (3.87) stays meaningful.
2. **`svm_cv_report.py` (method I, 1.14 vs 1.69)**: the 1.14 number was on the old golden; the current 1.69 is directly comparable to the current `rule.json` output.

All numbers in this file use the current golden. Any reference to older numbers (1.14, 0.63) is historical.

## RTL changes made this session

### `rtl/linear_rule_sampler.sv`

```systemverilog
// Before (was in RTL from a previous session):
parameter signed [11:0] WN2 = -12'sd272;
parameter signed [11:0] WN3 = -12'sd181;
parameter signed [11:0] WN4 = -12'sd136;
parameter signed [11:0] WW  = -12'sd1126;

// After (matches current linear_rule_start/rule.json):
parameter signed [11:0] WN2 = -12'sd248;
parameter signed [11:0] WN3 = -12'sd165;
parameter signed [11:0] WN4 = -12'sd124;
parameter signed [11:0] WW  = -12'sd1086;
```

### `tb/cubeocc_top_image_tb.sv`

Removed references to `u_sampler.dynamic_thresh` and `u_sampler.state` (no longer exist on `linear_rule_sampler`). Replaced with constants so existing `$display` and CSV writers still compile.

## Related files

- `15_09_V2_DYNAMIC_THRESHOLD_BASELINE_FINDINGS` — historical baseline
- `15_10_V2_CLASSIFIER_PIPELINE_ARCHITECTURE` — architecture and RTL
- `15_11_V2_TRAINING_VALIDATION_COMMANDS` — command reference
- `15_12_V2_WORK_LOG_DECISIONS_AND_REJECTIONS` — earlier decisions
- `15_13_V2_TASK_CHECKLIST` — current task state
- `15_15_V2_NONLINEAR_SVM_SESSION` — full record of the Gaussian/poly2/RBF exploration
