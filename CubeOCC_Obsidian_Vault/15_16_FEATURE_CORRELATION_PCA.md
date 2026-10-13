---
project: CubeOCC
type: feature-analysis
status: complete
last_reviewed: 2026-10-13
parent: 15_TASK_BACKLOG
---

# V2 Feature Correlation and PCA Analysis

## Purpose

Test whether the 13 candidate cell-level features contain redundant information, and whether PCA-based reduction can shrink the FPGA footprint. The goal is to reduce multiplier count without losing accuracy.

## Method

`dataset/feature_correlation_pca.py` extracts 13 features per payload cell across all 40,800 cells of the dataset, computes the Pearson correlation matrix, and runs PCA on standardized features.

Feature list:

```
mean, var, mx, mn, nb, white,
m_w (= mean/white), v_w (= var/white²), mx_w, mn_w, nb_w,
m_r (2-means relative mean), nb_r
```

## Correlation matrix (preprocess=opt4)

| Feature pair |      r | Note                                   |
| ------------ | -----: | -------------------------------------- |
| mean ↔ m_r   |  0.991 | Nearly identical                       |
| mx ↔ mn      |  0.931 | Peak and trough correlate              |
| mean ↔ mx    |  0.976 |                                        |
| mean ↔ mn    |  0.973 |                                        |
| mean ↔ m_w   |  0.964 | white is nearly constant across frames |
| m_w ↔ mx_w   |  0.953 |                                        |
| m_w ↔ mn_w   |  0.938 |                                        |
| nb ↔ nb_w    |  0.914 |                                        |
| nb ↔ nb_r    |  0.984 |                                        |
| var ↔ v_w    |  0.930 |                                        |
| white ↔ any  | < 0.42 | **Independent**                        |

## PCA (preprocess=opt4)

|  PC | Var % | Cum % | Top 3 loadings                   |
| --: | ----: | ----: | -------------------------------- |
|   1 | 54.95 | 54.95 | m_w=+0.36, mean=+0.36, m_r=+0.36 |
|   2 | 19.27 | 74.22 | v_w=+0.44, var=+0.44, nb_w=+0.42 |
|   3 | 17.62 | 91.84 | nb_r=+0.47, nb=+0.46, v_w=−0.40  |
|   4 |  6.11 | 97.95 | white=+0.82                      |
|   5 |  0.66 | 98.61 | (noise)                          |

**4 components for 95 % variance.** The 13 features live in a 4-dimensional subspace.

Same numbers for `preprocess=none`: 4 components for 95 %, 6 for 99 %.

## Why PCA does not help the FPGA

Each PCA component is a dense linear combination:

```
PC1 = 0.36·m_w + 0.36·mean + 0.36·m_r + ...  (6+ terms)
```

Computing PC1 in FPGA needs 6 multipliers; four PCs then need 4 more. Total = 10 multipliers — worse than the current 2-multiplier production model.

**PCA is a data-compression technique, not an FPGA-optimization technique.** Feature selection by correlation is what matters here.

## Feature-reduction experiment (feature set K)

Based on the correlation matrix, `mx_w` and `mn_w` are redundant with `m_w` (r > 0.94). A reduced feature set was tested:

| Method         | Features                       | Description                               |
| -------------- | ------------------------------ | ----------------------------------------- |
| E              | `[m_w, v_w, mx_w, mn_w, nb_w]` | Original 5-feature model                  |
| **K (new)**    | **`[m_w, v_w, nb_w]`**         | Drop the two redundant mean-like features |
| I (production) | `[m_w, nb_w]`                  | Current RTL model                         |

## Test command

```bash
python dataset/svm_cv_report.py \
  --frames sim/cubeocc_top_all/symbols_review/symbols_review.json \
  --image-dir sim/cubeocc_top_all_guard/camera_gray \
  --preprocess opt4 --kernel linear --n-jobs -1 \
  --out svm_cv_opt4_linear_v2
```

## Result

```text
method                              all   worst  others  FPGA cost
I SVM mean / white + nb / white     1.49   5.86    0.65  2 mult + adds  (production)
K SVM E-reduced (3 feat)            1.52   6.05    0.65  3 mult + adds  (E-reduced)
E SVM 5 / white ref                 1.53   5.80    0.70  5 mult + adds
G SVM raw 5 + white + 2-means       1.36   5.11    0.63  8 mult + adds
```

## Interpretation

- **K is worse than I** (+0.03 overall, +0.19 worst-10) despite having one more multiplier. Not adopted.
- **K matches E** (1.52 vs 1.53) with two fewer multipliers. So correlation analysis did reduce E correctly, but E was never the production choice.
- **G remains the best linear model** at 1.36 % but costs 8 multipliers. The 0.13-point gain over I does not justify 6 extra multipliers on `xc7a35t`.

The correlation matrix confirmed what was already known: the mean-like features are redundant. But dropping them did not reveal a better feature subset than the current 2-feature model I. Feature set `[m_w, nb_w]` remains the sweet spot.

## Decision

**Keep method I (`[m_w, nb_w]`).** The correlation and PCA analysis is closed.

## Raw files

- `feature_analysis_none/summary.json` + `correlation.csv`
- `feature_analysis_opt4/summary.json` + `correlation.csv`
- `svm_cv_opt4_linear_v2/summary.json` + `per_set.csv`

## Related documents

- [[15_10_V2_CLASSIFIER_PIPELINE_ARCHITECTURE]]
- [[15_13_V2_TASK_CHECKLIST]]
- [[15_14_V2_SCRIPT_OUTPUTS_LOG]]
- [[15_15_V2_NONLINEAR_SVM_SESSION]]
