# Additional FPGA-friendly feature search

Date: 2026-10-16

This is an exploratory search on the current RTL-derived 40,800-cell corpus.
Every reported error uses leave-one-capture-set-out validation, but the feature
choice itself used this corpus. Any winner must be frozen and checked once on a
new exact-ground-truth capture session.

## Features tested

| Family | Features |
| --- | --- |
| Sampling radius | circular means with radius 3, 4, 5, and 6 |
| Core/ring | inner-core mean, outer-ring mean, core-minus-ring |
| Robust mean | radius-5 mean after removing minimum and maximum |
| Distribution | variance, range, dark-pixel fraction, bright-pixel fraction |
| Sharpness | horizontal and vertical absolute-gradient energy |
| Compact center | 5x5 center-square mean |
| Context | existing orthogonal-neighbor mean |

All brightness features use the same cell's START-frame white reference.

## Result

![[assets/hardware_features/feature_candidate_errors.png]]

| Candidate | Errors / 40,800 | Error |
| --- | ---: | ---: |
| Current mean + neighbor | 336 | 0.8235% |
| Mean + neighbor + dark fraction below 37.5% START | 330 | 0.8088% |
| Mean + neighbor + dark fractions below 20% and 30% START | 329 | 0.8064% |
| Mean + neighbor + dark 20% + dark 30% + trimmed mean | 327 | 0.8015% |
| Mean + neighbor + variance | 335 | 0.8211% |
| Radius-4 mean + current neighbor | 335 | 0.8211% |
| Mean only | 402 | 0.9853% |

Bright-pixel fractions, gradients, range, larger radius, and core/ring contrast
did not improve the baseline.

## Why dark occupancy can help

Mean brightness can be raised by bloom, glare, or a bright edge. A dark symbol
may still contain a useful population of genuinely dark pixels. Counting pixels
below a START-relative threshold gives the classifier that distribution shape
without needing a histogram memory or a square root.

## Is the improvement trustworthy?

Not yet. The best exploratory candidate changed the errors as follows:

| Paired result | Cells/sets |
| --- | ---: |
| Baseline wrong, candidate correct | 38 cells |
| Baseline correct, candidate wrong | 29 cells |
| Capture sets improved | 12 |
| Capture sets worsened | 5 |
| Capture sets unchanged | 45 |
| Exact paired McNemar/binomial p-value | 0.328 |

The change from 336 to 327 errors is not statistically convincing on this
corpus. One defocus set became 10 cells worse. It is a promising diagnostic
feature, not a justified production replacement.

## FPGA cost ranking

| Feature | Approximate extra hardware |
| --- | --- |
| Dark fraction at one threshold | one comparator and one 7-bit count per cell |
| Dark fractions at two thresholds | two comparators and 14 count bits per cell |
| Trimmed mean | per-cell minimum and maximum trackers plus subtraction |
| Variance | sum-of-squares accumulator and square/multiply arithmetic |
| Horizontal gradient | previous-pixel register, subtract/absolute value, accumulator |
| Vertical gradient | line storage plus subtract/absolute value, accumulator |

For the present 8x8 grid, two dark-count features require approximately
`64 x 2 x 7 = 896` count bits before control and score arithmetic. Trimmed mean
adds approximately `64 x 2 x 8 = 1,024` min/max state bits. Those costs are too
large for an unconfirmed nine-cell improvement.

The hardware-friendliest candidate is the single `37.5%` dark occupancy feature:
its threshold can be represented by shift/add arithmetic (`3/8`) and it improves
six cells in the current exploratory report. It still requires untouched-data
confirmation before RTL implementation.

## Decision

Keep the production `mean + neighbor` model for now.

For the next new capture session, record dark occupancy at `3/8` of the per-cell
START reference as an evaluation-only third feature. Freeze the model first,
then compare it once against the current baseline. Do not add variance,
min/max, gradient, or multiple histogram bins unless that untouched test shows
a repeatable improvement.

## Reproduce

```powershell
cd C:\Users\arshm\Desktop\CubeOCC
& C:\Users\arshm\anaconda3\python.exe dataset\explore_hardware_features.py `
  --frames sim\my_svm_full_test\results.json `
  --grades sim\cubeocc_top_all\symbols_review\symbols_review.json `
  --image-dir sim\my_svm_full_test\camera_gray `
  --out sim\my_svm_full_test\analysis\hardware_feature_exploration
```

Tracked outputs are in `hardware_feature_exploration_latest/`.

## Related notes

- [[15_22_DIRECTIONAL_NEIGHBOR_FEATURE_SEARCH]]
- [[15_20_FEATURE_REDUCTION_PCA_LDA_DECISION]]
- [[15_19_SVM_LEAKAGE_FEATURE_FPGA_AUDIT]]
- [[15_18_LATEST_GRID_SVM_RETRAIN]]
