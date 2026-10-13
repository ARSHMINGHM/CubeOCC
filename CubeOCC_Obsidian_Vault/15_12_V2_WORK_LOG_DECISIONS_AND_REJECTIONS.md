---
project: CubeOCC
type: work-log
status: working-notes
last_reviewed: 2026-10-13
parent: 15_TASK_BACKLOG
---

# V2 Work Log, Decisions, and Rejections

Chronological work record from image processing through the final algorithm, including what was tried and rejected.

## Timeline

### Phase 1 — Image processing with kernel filters

Initial goal: sharpen the input image so cell boundaries become clearer.

The `opt4` preprocessing was implemented in `svm_cv_report.py`:

```text
median filter 3x3
  → 10th-percentile background subtraction
  → autocontrast (cutoff 2)
  → unsharp mask (radius 2, percent 150)
```

**Result:**

| Method                      | without opt4 | with opt4 |
| --------------------------- | -----------: | --------: |
| C SVM raw 5 features        |       1.74 % |    1.04 % |
| E SVM 5 / white ref         |       1.09 % |    1.15 % |
| I SVM mean/white + nb/white |       1.14 % |    1.15 % |

**Interpretation and decision:** opt4 only helps the raw SVM. Its effect is basically normalization, and for features that are already divided by white it adds nothing. More important: opt4 is a **non-linear** transform on pixels (median and autocontrast). After opt4, the `mean` feature is no longer a linear combination of raw pixels, so a linear SVM trained on these features no longer corresponds to a linear rule on pixel sums and cannot be implemented in FPGA with 5 multiplications and additions.

**Decision: opt4 was removed.** In its place, the `white reference` — which is a linear transform — was used.

### Phase 2 — White reference selection

Three options were evaluated:

| white_ref                                | CV payload error | Decision        |
| ---------------------------------------- | ---------------: | --------------- |
| `mean4` (mean of 4 corners)              |           1.14 % | simple baseline |
| `bilinear` (interpolated from 4 corners) |           1.32 % | **rejected**    |
| `start` (per-cell map from START frame)  |       **0.91 %** | **chosen**      |

**Why start is best:** brightness gradients across the screen (viewing angle, vignetting) make a global threshold see left and right differently. Example MLCAP_022: right 223, left 148. A global reference misses this; the START map calibrates per cell.

**Why bilinear was rejected:** interpolating linearly from 4 corners assumes the whiteness surface is smooth. But display vignetting is not necessarily linear. Result: worse than mean4 on some sets.

### Phase 3 — Classifier selection

Comparison of 10 methods with leave-one-capture-set-out over 62 capture sets:

| Method                      |   all sets |
| --------------------------- | ---------: |
| A dynamic_threshold_sampler |     4.72 % |
| B per-frame 2-means         |     1.39 % |
| C SVM raw 5 features        |     1.74 % |
| E SVM 5 / white ref         |     1.09 % |
| I SVM mean/white + nb/white | **1.14 %** |
| J SVM E without neighbor    |     1.32 % |

**Decision:** method I was chosen. Reason: 2 linear features (mean and nb), both divided by white → on FPGA only 3 multipliers and a few additions. `export_linear_rule.py` converts this into an integer rule.

**After white_ref=start:** error dropped from 1.14 % to **0.91 %**.

### Phase 4 — Ambiguity flag (kind=5)

Transition frames (when the display changes halfway from DATA to END) are neither DATA nor END. It was decided to mark these with a `kind=5` flag so a higher layer can decide what to do.

Rule: if ≥3 payload cells in a DATA frame have `|score| < (|WW| * S_start) >> 3` (about 0.069 × white), the frame becomes kind=5.

**Implementation note:** this check needs no extra multiplier because `prod_w = WW * w_cell` is already computed, and `(-prod_w) >> 3` gives the threshold.

### Phase 5 — Validation of the `(δ, N)` choice

The `--cv-splits 50` option was added to test whether the in-sample `(δ, N)` choice generalizes.

Result:

|              | flagged% | good lost% | err removed% | bad caught% |
| ------------ | -------: | ---------: | -----------: | ----------: |
| train half   |      9.4 |        4.1 |         87.3 |        91.1 |
| **held-out** | **10.7** |    **5.4** |     **86.5** |    **91.0** |

**Interpretation:** err removed drops from 87.3 to 86.5 (less than 1 unit). bad caught stays constant. Conclusion: **it generalizes.** The `(0.069, 2)` choice implemented in RTL is the second-most-common CV pick.

---

## Things that were rejected

### 1. `bilinear` white reference (rejected)

Error of 1.32 % vs 0.91 % for start. Reason: it assumes whiteness is linear across the screen.

### 2. Kernel filter `opt4` (rejected)

Same or worse error on normalized features. Reason: non-linear transform, blocks linear FPGA implementation. Also costs line buffers and a percentile computation.

### 3. The 98.5 % accuracy number (rejected)

Came from `test_svm_eval.py` which used a random split at the **cell** level, meaning cells from the same frame ended up in both train and test. **Data leakage.**

Valid number: **0.91 % CV error (= 99.09 % accuracy)** from `svm_cv_report.py` with leave-one-capture-set-out.

### 4. Dynamic threshold with learned threshold (rejected)

Previous method: `(mean of 4 corners) / 2` as threshold. Error 4.72 %. Problem: a single global threshold misses the brightness gradient across the screen.

### 5. SVM with 5 features (method E) as RTL (rejected)

Same 1.09 % error as method I, but needs 5 multipliers and 5 accumulators. Method I works with 2 features and has the same error.

---

## Corrections to earlier statements

### Correction 1: "Armin's griding was not replaced"

Earlier statement: "I did my own griding".
Reality: `rtl/grayscale_grid_8x8.sv` is Armin's file, unchanged. Only the classifier after it changed (`dynamic_threshold_sampler` → `linear_rule_sampler`). The classifier inputs, `grid_pixel_gray` and `grid_cell`, come directly from Armin's RTL.

### Correction 2: "It's not a neural network"

`linear_rule_sampler.sv` is a LinearSVC, not a neural network. `start_sum[64]` is a white-reference map (registers), not weights.

### Correction 3: Accuracy number

The correct number is `0.91 % CV error`, not `2 %` or `98.5 %`. The other numbers come from incorrect splits.

---

## Note for the meeting with Armin

If you want to explain this in the meeting:

> I used your griding output directly. I only replaced the classifier after it. The new algorithm is a LinearSVC trained on two features (cell mean and neighbor mean, both divided by white), rewritten as a division-free rule with 5 signed 12-bit integer coefficients in `linear_rule_sampler.sv`. Additionally, I changed the white reference from "mean of 4 corners" to "per-cell map from the START frame" to compensate for the screen's brightness gradient. Cross-validated payload error dropped from 4.72 % (dynamic_threshold) to 0.91 %. The 98.5 % number came from an old split with data leakage and is not valid.

## Suggested next steps

- **Test Gaussian filter + linear/RBF SVM:** add a mild Gaussian preprocessing and see whether error improves. If the RBF kernel is significantly better, investigate an FPGA approximation; otherwise keep linear.
- **Connect accurate golden:** wire up the sender `*_frames.jsonl` so that the `true` frame labels are not used as their own reference.
- **Fmax of `linear_rule_sampler`:** standalone OOC synthesis with `create_clock -period 10.0` on `clk` to see whether 100 MHz closes.
- **Decide kind=5 with Armin:** ECC only sees bits; the ambiguity flag must be handled by the control layer.
