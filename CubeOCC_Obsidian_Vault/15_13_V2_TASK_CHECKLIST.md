---
project: CubeOCC
type: task-checklist
status: active
last_reviewed: 2026-10-13
parent: 15_TASK_BACKLOG
---

# V2 Task Checklist

Status of work completed and remaining, from V2 image processing up to today.

## ✅ Completed

### Data and evaluation infrastructure

- [x] Built `dataset/cell_error_report.py` for cell-level comparison with golden from manual labels
- [x] Natural frame ordering (`frame_9` before `frame_10`)
- [x] Per-set, per-cell, and overall reports (51,584 cells over 806 frames)
- [x] Golden built from majority vote of `true`-graded frames (approximate, until jsonl arrives)
- [x] Warning on duplicate or skipped frame numbers

### Classifier comparison (linear)

- [x] Implemented `dataset/svm_cv_report.py` with leave-one-capture-set-out
- [x] Compared 10 methods: dynamic_threshold, per-frame 2-means, SVMs with various features
- [x] Paired bootstrap over capture sets (8000 resamples, 95 % interval)
- [x] Confirmed the neighbor feature adds value (`I - H` = -0.48, `E - J` = -0.23)
- [x] Identified and rejected `dataset/test_svm_eval.py` due to data leakage
- [x] Identified and rejected `dataset/train_v2_svm.py` for the same reason

### White reference selection

- [x] Implemented `--white-ref mean4|median4|max4|bilinear|start` in `export_linear_rule.py`
- [x] Tested `mean4`: CV payload error **1.69 %** (current golden)
- [x] Tested `bilinear`: **1.72 %**, rejected
- [x] Tested `start`: **1.31 %** CV payload error, **chosen**
- [x] Rationale documented: screen brightness gradient

### Integer rule

- [x] Rewrote LinearSVC as a division-free rule (`sign(a*mean + b*nb + g*white)`)
- [x] Extracted 5 signed 12-bit constants (current): `WC=2047, WN2=-248, WN3=-165, WN4=-124, WW=-1086`
- [x] Tested 8, 10, 12, 16-bit widths; 12-bit matches float bit-for-bit
- [x] Saved in `linear_rule_start/rule.json`

### New RTL

- [x] Implemented `rtl/linear_rule_sampler.sv` with a multi-phase state machine
- [x] Per-cell map from the START frame (`start_sum[64]`)
- [x] Neighbor coefficient selected based on cell position (corner/edge/center)
- [x] Corners forced to 1 on DATA frames
- [x] Emits kind=1 (START), 2 (DATA), 3 (END), 4 (discard), 5 (ambiguous)
- [x] Ambiguity flag without extra multiplier: `(-prod_w) >> 3`
- [x] Replaced `dynamic_threshold_sampler` in `cubeocc_top.sv`
- [x] Removed `dynamic_threshold_sampler` from `.xpr` (file kept as reference)
- [x] Updated RTL coefficients to match the current `linear_rule_start/rule.json` (`WN2=-248, WN3=-165, WN4=-124, WW=-1086`)
- [x] Patched `tb/cubeocc_top_image_tb.sv` to remove references to the removed `dynamic_threshold_sampler` ports (`u_sampler.dynamic_thresh`, `u_sampler.state`)

### Bit-exact validation

- [x] Implemented `dataset/check_linear_rule_rtl.py` as the integer model
- [x] Rerun XSim after coefficient update (`sim/cubeocc_top_all_start_v2/`)
- [x] **RTL matches model: 0 mismatches over 806 frames (PASS)**
- [x] **kind 2/5 matches model: 0 mismatches**

### Ambiguity flag evaluation

- [x] Implemented `dataset/ambiguity_report.py` with `--cv-splits`
- [x] In-sample evaluation: `(0.069, 2)` gives 10.4 % flag, 4.8 % good lost, 90.4 % err removed
- [x] CV over 50 half/half splits
- [x] **Confirmed generalization: train vs held-out difference 0.8 unit in err removed**
- [x] Implemented `dataset/evaluate_ambiguous_flag.py` for final recall/precision
- [x] **Result on current golden (kind=5): recall 81.6 %, precision 66.0 %, FPR 2.7 %**
- [x] **Combined system: bad frames removed 86.8 %, good frames lost 2.7 %**
- [x] Confirmed guard discard (kind=4) does not help identify bad frames

### Nonlinear classifier exploration (2026-10-13)

- [x] Rewrote `dataset/svm_cv_report.py` with new options:
  - `--preprocess none|gaussian|opt4`
  - `--gauss-sigma <float>`
  - `--kernel linear|poly2|rbf|rbf-exact|both`
  - `--nonlinear-only`
  - `--rbf-gamma scale|<float>`
  - `--rbf-components <int>` (Nystroem components)
  - `--n-jobs <-1|N>` (joblib parallelization)
- [x] **Gaussian preprocessing (sigma 0.75):** no improvement over `none`. All methods within ±0.02 points. Rejected.
- [x] **opt4 preprocessing (median + unsharp + autocontrast):** method I: 1.69 → **1.49 %** (−0.20), worst-10: 7.29 → 5.86. Improvement on the edge of significance. Not adopted in RTL because opt4 breaks the linear pixel-sum relationship needed by the FPGA implementation.
- [x] **poly2 on method I (2 features):** 1.55 % — **worse** than linear (1.49 %). The two features already saturate the linear signal.
- [x] **poly2 on method E (5 features):** 1.36 % — real improvement over linear E (1.53 %), but equal to method G linear (8 features). Dominated. Rejected.
- [x] **RBF (Nystroem, 100 components):** method I reaches **1.27 %** — the best accuracy in the table. Improvement concentrated in 4 hard sets (055, 048, 020, 012). Requires ~30,000 additional LUT for `exp()` — **not FPGA-feasible** on `xc7a35t`.
- [x] **Decision: keep the current linear rule.** The 0.22-point gap between linear and RBF is below the CV noise floor (~0.2). Remaining 4-5 % error on the hard sets is an image-quality problem, not a classifier limitation.
- [x] Full session record: `15_15_V2_NONLINEAR_SVM_SESSION`

### Repository cleanup

- [x] Ran `cleanup_sim.sh`: reduced `sim/` from **875 MB / 19,986 files** to **156 MB / 8,093 files** (−82 % size, −60 % files)
- [x] Updated `.gitignore` with patterns for `sim/*/camera_gray/`, `sim/*/mem/`, `sim/*/xsim_build/`, `svm_cv_*/`, `cell_errors*/`, `ambiguity*/`
- [x] Added `~/.bashrc` shortcuts (`occ-cv-both`, `occ-cv-rbf`, `occ-cv-linear`, `occ-check`, `occ-cell`, `occ-status`)

### Script outputs log

- [x] Documented all V2 script commands and outputs in `15_14_V2_SCRIPT_OUTPUTS_LOG.md` (14 sections including nonlinear)
- [x] Documented the full nonlinear session in `15_15_V2_NONLINEAR_SVM_SESSION.md`
- [x] Recorded the coefficient-change history (`WN2=-272 → -248`, etc.) and the golden change (`MLCAP_054/frame_9.png` removed)
- [x] Cross-referenced `15_09`, `15_10`, `15_11`, `15_12`, `15_14`, `15_15`

### Commits and documentation

- [x] Commit `43a35b9` — add `linear_rule_sampler`
- [x] Commit `20818a7` — per-cell START white map
- [x] Commit `78c0785` — flag DATA frames with ≥3 uncertain cells as tuser=5
- [x] Documented in `15_09_V2_DYNAMIC_THRESHOLD_BASELINE_FINDINGS.md`
- [x] Documented in `15_14_V2_SCRIPT_OUTPUTS_LOG.md`
- [x] Documented in `15_15_V2_NONLINEAR_SVM_SESSION.md`

---

### Feature correlation and PCA analysis (2026-10-13)

- [x] Built `dataset/feature_correlation_pca.py`
- [x] Computed Pearson correlation matrix on 40,800 cells (both `none` and `opt4`)
- [x] Ran PCA on 13 standardized features
- [x] Confirmed 4 components capture 95 % variance
- [x] Rejected PCA for FPGA: dense components need ~10 multipliers vs 2 for production
- [x] Tested reduced feature set K = `[m_w, v_w, nb_w]`: 1.52 % CV error, 3 mult — worse than I (1.49 %, 2 mult)
- [x] **Decision: method I (`[m_w, nb_w]`) remains the final feature set**
- [x] Full record in [[15_16_FEATURE_CORRELATION_PCA]]

---

## ⏳ Remaining

### High priority (do soon)

- [ ] **`git push`** commit `78c0785` and new documentation commits on branch `v2/threshold-baseline-debug`

  ```bash
  git push -u origin v2/threshold-baseline-debug
  ```

- [ ] **Remove dead code from the Vivado project:** `dynamic_threshold_sampler.sv` is still registered in `.xpr` but is not instantiated. Remove it from the project (keep the file in the repo).

- [ ] **Decide kind=5 with Armin:** how should the ambiguity flag be consumed downstream?
  - Accept with warning (bits extracted, flag raised)
  - Reject and wait for the next frame
  - Use as a reliability metric in the decoder

### Medium priority

- [ ] **Connect accurate golden from sender:** wire `--golden-jsonl` in `cell_error_report.py` and `ambiguity_report.py` to `sender/*_frames.jsonl`.

  ```bash
  python dataset/cell_error_report.py --frames ... --golden-jsonl sender/frames.jsonl
  ```

- [ ] **Decide on Defocus sets:** do MLCAP_037, 038, 039, 055 stay in training or become a hard test set? (Current lean: hard test.)

- [ ] **Investigate MLCAP_048:** Content mismatch — is the sender message actually the same as the golden? Currently excluded from `ambiguity_report.py` and `evaluate_ambiguous_flag.py`.

- [ ] **Investigate MLCAP_033:** END frame is not detected. Is it bright room or a truly missed END capture?

- [ ] **Decide opt4 adoption:** is the 0.20-point gain of opt4 + linear (1.69 → 1.49 %) worth the ~500 LUT + 3-row line buffer required for a 3×3 median filter in FPGA?

### Low priority (exploratory)

- [ ] **Test Haar denoise:** Given resources (44 % LUT free), Haar fits but must justify the extra cost. Gaussian was tested and provided no benefit; Haar may behave differently because it is multiscale.

- [ ] **Test multiple `--cv-splits` seeds:** run with `--seed 1,2,3` to confirm the `(δ, N)` choice is stable.

- [ ] **SVM with gradient feature:** add cell gradient to the feature set and test in CV. Not tested in the current session.

- [ ] **RBF with exact SVC** on a small subset (e.g., 10 sets) to confirm the Nystroem approximation (100 components) does not underestimate the true RBF advantage.

- [ ] **Report Fmax of `linear_rule_sampler`:** standalone OOC synthesis with `create_clock -period 10.0` on `clk`. Investigate the HDL ADVISOR warning about shared adder at line 191. Functional verification is complete; only timing closure remains.

### Undecided (needs discussion)

- [ ] **Remove `test_svm_eval.py`, `train_v2_svm.py`, `export_svm_weights.py` from the repo** or document that these are experimental and their results are invalid (data leakage).

- [ ] **Document `cell_errors_rgb` and `sim/rgb_warped`:** these are for the future RGB experiment. Start now or wait for V2.5?

- [ ] **Improve `grid_corner_frame_guard`:** on MLCAP_054, a DATA frame with a black payload is misdetected as END. Test a stricter guard.

- [ ] **START guard hardening:** currently any frame with average ≥ 96 and bright corners is accepted as START. Tested: 115 of 143 local DATA frames pass this. Needs a stricter condition (e.g., all cells bright).

---

## Files that should be committed

```bash
git add dataset/ambiguity_report.py
git add dataset/evaluate_ambiguous_flag.py
git add dataset/check_linear_rule_rtl.py
git add dataset/export_linear_rule.py
git add dataset/svm_cv_report.py
git add dataset/cell_error_report.py
git add rtl/linear_rule_sampler.sv
git add rtl/cubeocc_top.sv
git add tb/cubeocc_top_image_tb.sv
git add sim/cubeocc_top_all/symbols_review/symbols_review.json
git add CubeOCC_Obsidian_Vault/15_09_V2_DYNAMIC_THRESHOLD_BASELINE_FINDINGS.md
git add CubeOCC_Obsidian_Vault/15_10_V2_CLASSIFIER_PIPELINE_ARCHITECTURE.md
git add CubeOCC_Obsidian_Vault/15_11_V2_TRAINING_VALIDATION_COMMANDS.md
git add CubeOCC_Obsidian_Vault/15_12_V2_WORK_LOG_DECISIONS_AND_REJECTIONS.md
git add CubeOCC_Obsidian_Vault/15_13_V2_TASK_CHECKLIST.md
git add CubeOCC_Obsidian_Vault/15_14_V2_SCRIPT_OUTPUTS_LOG.md
git add CubeOCC_Obsidian_Vault/15_15_V2_NONLINEAR_SVM_SESSION.md
git add linear_rule_start/rule.json
git add cell_errors_start_v2/summary.json
git add cell_errors_start_v2/per_frame.csv
git add svm_cv_opt4_both_v2/summary.json
git add svm_cv_opt4_both_v2/per_set.csv
git add ambiguity_cv/per_frame.csv
```

## Files that must NOT be committed

```bash
# Vivado auto-generated
vivado/CubeOCC/CubeOCC.runs/impl_1/
vivado/CubeOCC/CubeOCC.runs/synth_1/*.rpt
vivado/CubeOCC/CubeOCC.cache/
vivado/CubeOCC/CubeOCC.xpr  # only inspect manual changes

# Experimental scripts with invalid results (data leakage)
dataset/test_svm_eval.py
dataset/train_v2_svm.py
dataset/export_svm_weights.py

# Temporary output
evidence.txt
hs_err_pid*.dmp
repomix-output.xml
tb/cubeocc_top_image_tb.sv.bak
dataset/svm_cv_report.py.bak

# Large image folders / intermediate results
sim/rgb_warped/
sim/cubeocc_top_all_start/      # superseded by _start_v2
sim/cubeocc_top_all_start_v2/   # regenerable; keep only results.json if needed
sim/roi_rtl_all*/               # regenerate via runner
cell_errors*/                   # regenerate via scripts
svm_cv_none/ svm_cv_opt4/ svm_cv_none_linear/ svm_cv_opt4_linear/ svm_cv_gauss075_linear/   # regenerate
svm_cv_none_both/ svm_cv_opt4_rbf/ svm_cv_none_rbf/                                         # regenerate
ambiguity/                      # regenerate
```

---

## Quick reference

| File                                 | Role                                              |
| ------------------------------------ | ------------------------------------------------- |
| `rtl/linear_rule_sampler.sv`         | RTL classifier implementation                     |
| `linear_rule_start/rule.json`        | Trained model output (coefficients)               |
| `dataset/export_linear_rule.py`      | Integer coefficient exporter from SVM             |
| `dataset/svm_cv_report.py`           | Compare classifier methods (linear, poly2, rbf)   |
| `dataset/ambiguity_report.py`        | Evaluate kind=5 flag with CV                      |
| `dataset/check_linear_rule_rtl.py`   | Bit-exact RTL vs model check                      |
| `dataset/evaluate_ambiguous_flag.py` | Final recall/precision evaluation                 |
| `dataset/cell_error_report.py`       | Per-cell error on RTL output                      |
| `15_14_V2_SCRIPT_OUTPUTS_LOG.md`     | Consolidated raw outputs from all scripts         |
| `15_15_V2_NONLINEAR_SVM_SESSION.md`  | Full record of the Gaussian/poly2/RBF exploration |

## Current authoritative numbers

| Metric                                           |              Value |
| ------------------------------------------------ | -----------------: |
| Cell error, dynamic_threshold baseline           |             3.87 % |
| Cell error, linear_rule + start (current golden) |             0.80 % |
| CV payload error, method I + start (no preproc)  |             1.31 % |
| CV payload error, method I + opt4 (linear)       |             1.49 % |
| CV payload error, method I + RBF (rejected)      |             1.27 % |
| RTL bit-exact vs model                           |   PASS, 0 mismatch |
| Ambiguity flag recall (kind=5)                   |             81.6 % |
| Ambiguity flag FPR (kind=5)                      |              2.7 % |
| Combined bad frames removed                      |             86.8 % |
| Repository size (`sim/`)                         | 156 MB, 8093 files |

**Number to cite for improvement:** linear rule with START white map reduces cell error from 3.87 % to 0.80 %, a **4.8× reduction**.

**Number to cite for the nonlinear exploration:** RBF with 100 Nystroem components reaches 1.27 % (0.22 points better than the current linear rule) but requires ~30,000 additional LUT for `exp()` and is not FPGA-feasible on `xc7a35t`. The current linear rule is the final classifier for V2.
