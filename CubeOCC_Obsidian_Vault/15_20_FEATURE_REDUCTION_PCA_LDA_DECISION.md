# Feature reduction, PCA, and LDA decision

Date: 2026-10-16

This comparison uses the latest RTL-derived warped/grid images, the same
per-cell START calibration as the production classifier, 40,800 payload cells,
and 62-fold leave-one-capture-set-out validation. Scaling, PCA, LDA, and SVM
fitting happen inside each training fold.

The approximate-golden and alignment limitations in
[[15_19_SVM_LEAKAGE_FEATURE_FPGA_AUDIT]] still apply.

## Candidate features

| Name | Definition | Main FPGA work |
| --- | --- | --- |
| `mean_w` | cell circular mean / same-cell START white | cell sum |
| `var_w2` | cell variance / START white squared | sum of squares and square term |
| `max_w` | maximum circular pixel / START white | maximum tracker |
| `min_w` | minimum circular pixel / START white | minimum tracker |
| `neighbor_w` | orthogonal-neighbor mean / START white | neighbor sum |

## Correlation matrix

![[assets/feature_reduction/correlation_matrix.png]]

Important correlations:

- `mean_w` and `max_w`: `0.985`
- `mean_w` and `min_w`: `0.986`
- `max_w` and `min_w`: `0.961`
- `mean_w` and `neighbor_w`: `0.358`
- `mean_w` and `var_w2`: `0.039`

Mean, minimum, and maximum are nearly duplicates. Variance is independent, but
independence alone does not mean it improves classification.

## PCA graphics

![[assets/feature_reduction/pca_variance_and_pc1_pc2.png]]

| Component | Variance | Cumulative |
| --- | ---: | ---: |
| PC1 | 62.752% | 62.752% |
| PC2 | 20.489% | 83.241% |
| PC3 | 16.258% | 99.499% |
| PC4 | 0.372% | 99.872% |
| PC5 | 0.128% | 100.000% |

PC1 and PC2 preserve variance, not necessarily the bit-separating direction.
That is why PCA1/PCA2 can explain much of the dataset variance while increasing
classification error.

## LDA graphic

![[assets/feature_reduction/lda_score_distribution.png]]

Binary LDA can produce only one discriminant component because there are two
classes. There is no meaningful LDA2 or LDA3 for this binary bit classifier.
The graph shows good visual separation overall, but the difficult tails overlap
more than with the margin-optimized linear SVM.

## Error comparison

![[assets/feature_reduction/model_error_comparison.png]]

| Case | Errors / 40,800 | Error |
| --- | ---: | ---: |
| Current mean + neighbor | 336 | 0.8235% |
| Full five features, no PCA | 334 | 0.8186% |
| PCA1 + SVM | 838 | 2.0539% |
| PCA2 + SVM | 854 | 2.0931% |
| PCA3 + SVM | 444 | 1.0882% |
| PCA4 + SVM | 461 | 1.1299% |
| PCA5 + SVM | 334 | 0.8186% |
| Full five-feature LDA | 729 | 1.7868% |
| PCA1 + LDA | 1,477 | 3.6201% |
| PCA2 + LDA | 1,465 | 3.5907% |
| PCA3 + LDA | 1,105 | 2.7083% |
| PCA4 + LDA | 949 | 2.3260% |
| PCA5 + LDA | 729 | 1.7868% |
| Mean only | 402 | 0.9853% |
| Best three: mean + variance + neighbor | 335 | 0.8211% |

PCA5 matches the full model because all five components retain all information.
It is a coordinate rotation, not compression.

## FPGA timing and BPS

PCA or LDA followed by a linear classifier can be algebraically folded into one
linear boundary. Therefore a sensible FPGA implementation does not calculate
PCA or LDA at runtime. Its timing is controlled by the original features that
still need to be extracted.

### Unlimited-camera assumption

If the camera can provide frames without any FPS limit, the current FPGA is the
only limiter. The design is not double-buffered: it captures one frame, uses the
single frame buffer for projective warp, emits the grid, classifies it, and only
then accepts the next complete frame. The measured average is about `269,750`
clocks per accepted frame.

Approximate cycle distribution:

| Stage | Clocks/frame | Notes |
| --- | ---: | --- |
| Input raster | about 19,320 | 160x120 pixels plus one line-gap clock per row |
| ROI detection | concurrent | runs while the input raster arrives |
| Projective warp + rectified output + grid | about 249,915 | dominant iterative-coordinate stage |
| Classifier tail after grid completion | about 515 | 64 cells x 8 phases plus setup/output |
| Complete measured average | about 269,750 | includes the complete accepted-frame path |

For any folded linear candidate that stays parallel:

| Clock assumption | Whole-pipeline time/frame | Payload processing capacity |
| --- | ---: | ---: |
| 100 MHz simulation target, currently fails top timing | 2.6975 ms | 22.24 kbit/s |
| 45.97 MHz current delay-derived estimate | 5.868 ms | 10.22 kbit/s |
| 40 MHz conservative intermediate point | 6.744 ms | 8.90 kbit/s |
| 24 MHz practical camera clock | 11.240 ms | 5.34 kbit/s |

These rates use 60 variable payload cells per DATA frame and assume continuous
DATA. With the current 13-frame test sequence (1 START, 11 DATA, 1 END), multiply
them by `11/13`: `18.82`, `8.65`, `7.53`, and `4.52 kbit/s`, respectively.
PCA/LDA does not improve this because warp, not classification, is dominant.

## Resource comparison

Exact measured Vivado resources exist only for the current two-feature RTL:

| Scope | LUT | FF | BRAM36 | DSP |
| --- | ---: | ---: | ---: | ---: |
| Whole `cubeocc_top` | 9,622 | 5,374 | 8 | 17 |
| Current sampler/classifier | 1,883 | 2,234 | 0 | 3 |

The alternatives are trained software candidates, not implemented RTL blocks,
so claiming exact LUT/FF/DSP numbers for them would be false. Their required
hardware is known:

| Case | Original features still extracted | Relative hardware conclusion |
| --- | --- | --- |
| Mean only | mean | cheaper than current; loses 66 cells |
| Current two | mean, neighbor | measured baseline |
| Best three | mean, variance, neighbor | adds sum-of-squares/square hardware for one corrected cell |
| Full five, no PCA | all five | adds variance, min, and max hardware for two corrected cells |
| PCA1/PCA2/PCA3 | all five | same source-feature cost as full five; worse error |
| PCA5 | all five | same information and error as full five; no benefit |
| LDA | all five | same source-feature cost class as full five; worse error |

PCA1 is not a one-feature FPGA design: it still needs all five original features
to calculate PC1. Folding removes PCA runtime stages but cannot remove the
original feature extraction.

## Decision

Keep the current `mean_w + neighbor_w` linear SVM.

- Full five features correct only 2 additional cells out of 40,800.
- Adding variance to the current pair corrects only 1 additional cell.
- PCA1 through PCA4 are less accurate and do not avoid five-feature extraction.
- PCA5 is not compression.
- LDA is less accurate than the current SVM.
- Mean only is a valid future smallest-resource option, but increases error from
  `0.8235%` to `0.9853%`.

It is not worth building variance/min/max/PCA/LDA RTL for the current dataset.
The next useful hardware experiment is a mean-only sampler versus the current
two-feature sampler, followed by synthesis and an untouched exact-ground-truth
test.

## Reproduce

```powershell
cd C:\Users\arshm\Desktop\CubeOCC
& C:\Users\arshm\anaconda3\python.exe dataset\compare_feature_reduction.py `
  --frames sim\my_svm_full_test\results.json `
  --grades sim\cubeocc_top_all\symbols_review\symbols_review.json `
  --image-dir sim\my_svm_full_test\camera_gray `
  --out sim\my_svm_full_test\analysis\feature_reduction
```

Tracked result files are in `feature_reduction_latest/`.

## Related notes

- [[15_21_ADDITIONAL_HARDWARE_FEATURE_SEARCH]]
- [[15_19_SVM_LEAKAGE_FEATURE_FPGA_AUDIT]]
- [[15_18_LATEST_GRID_SVM_RETRAIN]]
- [[15_10_V2_CLASSIFIER_PIPELINE_ARCHITECTURE]]
