# SVM leakage, feature, and FPGA audit

Date: 2026-10-16

This audit uses the current live RTL route and the fresh output under
`sim/my_svm_full_test`. Python is used only to inspect the RTL-derived cells and
train/evaluate the coefficients. ROI, warp, grid, START calibration, guard, and
classification remain synthesizable RTL.

## Short conclusion

The current result is useful engineering evidence, but it is **not yet a clean
publication-quality independent test**.

- Good: leave-one-capture-set-out (LOCO) keeps all cells from the held capture
  set out of its training fold.
- Good: scaling and the new PCA/LDA checks are fitted on training folds only.
- Remaining leakage: the approximate golden words are voted from all graded
  capture sets, including the held-out set.
- Remaining optimism: dynamic frame alignment compares held-out outputs with
  the golden sequence before classification scoring.
- Coverage gap: every set repeats the same 11 DATA patterns, so a completely new
  transmitted message has not been tested.
- Small direct duplicate: one identical warped PNG occurs in two capture sets.
- Model-selection bias: features, START reference, coefficient width, and the
  ambiguity rule were selected after looking at this same corpus.

The safe paper result requires a new untouched capture session containing new,
random payload patterns and exact sender `*_frames.jsonl` truth. Do not use
majority voting or output-dependent alignment on that final test.

## Current image-processing chain

1. Camera input is converted to grayscale `GRAY8`.
2. `roi_start_detector` finds the four bright corner markers.
3. `projective_warp_160x120` stores the camera frame in 8 BRAM tiles and emits a
   rectified `160x120` image.
4. `grayscale_grid_8x8` maps the rectified pixels into 64 cells of `20x15`.
5. `grid_corner_frame_guard` validates START/DATA/END and corner brightness.
6. `linear_rule_sampler` samples an 81-pixel circle, radius 5, around each cell
   center, accumulates cell sums, and classifies the 64 symbols.

There is no Gaussian filter, Haar wavelet, PCA, or LDA in the production RTL.

## Production features and SVM

The production classifier has two features:

1. `m_w = cell circle mean / same-cell START circle mean`
2. `nb_w = orthogonal-neighbor mean / same-cell START circle mean`

The model is a linear SVM (`LinearSVC`, `C=1.0`), not RBF or polynomial.
Training uses `StandardScaler`; the scaler is folded into the exported linear
coefficients. The floating decision is:

`6.235907*m - 1.551629*neighbor_mean - 3.558332*START_white > 0`

The 12-bit RTL constants are:

| Constant | Value |
| --- | ---: |
| `WC` | 2047 |
| `WN2` | -255 |
| `WN3` | -170 |
| `WN4` | -127 |
| `WW` | -1168 |

There is **no runtime divider**. Normalization is removed algebraically and the
RTL calculates a weighted integer sum of `S_cell`, neighbor sums, and the stored
per-cell START sum. Corner, edge, and interior cells use 2, 3, or 4 neighbors.

## Were bad frames dropped?

No. The latest audited training/evaluation table contains 680 payload frames:

| RTL/manual status | Frames used |
| --- | ---: |
| Clean RTL DATA (`kind=2`) | 595 |
| Guard-discarded (`kind=4`) | 21 |
| Ambiguous (`kind=5`) | 64 |
| Manually true | 555 |
| Manually mid | 17 |
| Manually false | 108 |

ROI-rejected frames were absent because the fresh run had `0/806` ROI rejects.
START and END frames and the four protocol corner cells are excluded from SVM
training. Bad-looking DATA frames are not excluded.

Hard but correctly synchronized frames can be useful training examples when
exact sender truth exists. Frames with failed geometry or uncertain alignment
must not be used as ordinary labeled cells in a publication model.

## Leakage details

| Check | Result |
| --- | --- |
| Cell-level random split | Not used |
| Capture set separated in CV | Yes, 62-fold LOCO |
| Scaler fitted on training only | Yes |
| PCA/LDA fitted on training only | Yes |
| Golden independent of held-out set | No, current fallback uses all-set votes |
| Alignment independent of expected output | No, DP cost compares to golden bits |
| New payload patterns in test | No, the same 11 patterns repeat |
| Exact duplicates across capture sets | One group |

The duplicate is:

- `MLCAP_043_Bright_MildReflection/frame_11.png`
- `MLCAP_044_Near_MildReflection/frame_11.png`

Also, `MLCAP_047_Cam60_Opt60` and `MLCAP_048_Cam30_Opt60` contribute only 10
payload frames each because golden-aware alignment does not map their final
captured frame to DATA index 11.

## Correlation, PCA, and LDA

Latest exact-production-feature audit over 40,800 cells:

| Measurement | Result |
| --- | ---: |
| Correlation `m_w` vs `nb_w` | 0.358 |
| Correlation `m_w` vs class | 0.953 |
| Correlation `nb_w` vs class | 0.283 |
| PCA PC1 variance | 67.89% |
| PCA PC2 variance | 32.11% |

The two features are not redundant enough to keep only one PCA component.
PC1 is approximately `(m_w + nb_w)/sqrt(2)`, while the useful SVM boundary
needs a strong positive cell term and a negative neighbor term.

Grouped LOCO comparison:

| Model | Cell errors | Error rate |
| --- | ---: | ---: |
| Mean-only linear SVM | 402 / 40,800 | 0.985% |
| Current two-feature linear SVM | 336 / 40,800 | 0.824% |
| PCA(1) then linear SVM | 5,479 / 40,800 | 13.429% |
| LDA on two features | 976 / 40,800 | 2.392% |

Conclusion: PCA and LDA are possible, but neither should replace the present
two-feature linear SVM. PCA with both components changes nothing and adds
hardware. One-component PCA and LDA are both less accurate.

## FPGA resource results

Vivado 2019.1, `xc7a35tcpg236-1`, out-of-context synthesis:

| Unit | LUT | FF | BRAM36 | DSP |
| --- | ---: | ---: | ---: | ---: |
| Complete `cubeocc_top` | 9,622 (46.26%) | 5,374 (12.92%) | 8 (16.00%) | 17 (18.89%) |
| ROI + warp + grid pipeline | 7,759 | 3,188 | 8 | 14 |
| Projective warp alone | 4,593 | 887 | 8 | 14 |
| Grid mapping alone | 118 | 86 | 0 | 0 |
| Linear sampler/classifier alone | 1,883 | 2,234 | 0 | 3 |

These separate module rows are standalone synthesis estimates and must not be
added to reconstruct the top row, because synthesis shares and removes logic.

## FPGA timing and throughput

The classifier alone meets 100 MHz with `+1.931 ns` WNS. It needs approximately
515 clocks after `grid_frame_done`, or `5.15 us` at 100 MHz and `21.46 us` at
24 MHz.

The complete top does **not** meet 100 MHz yet. Its worst path is in the
projective warp: `-11.810 ns` WNS, `21.755 ns` data-path delay, corresponding to
about 45.97 MHz before implementation margin.

The 806-frame XSim run finished at virtual time `2.174188726 s`, averaging about
269,750 clocks per input frame:

| Assumed clock | Processing time/frame | Processing capacity | 60 payload bits/frame |
| --- | ---: | ---: | ---: |
| 100 MHz, simulation only, timing fails | 2.6975 ms | 370.7 frames/s | 22.24 kbit/s |
| 45.97 MHz, delay-derived upper estimate | 5.868 ms | 170.4 frames/s | 10.22 kbit/s |
| 24 MHz practical camera clock | 11.240 ms | 89.0 frames/s | 5.34 kbit/s |

The physical optical link is slower than this processing capacity. With four
corner cells reserved, each DATA image carries 60 payload bits:

- continuous DATA at 30 FPS: `1,800 bit/s`
- continuous DATA at 60 FPS: `3,600 bit/s`
- current 13-frame test transfer (START + 11 DATA + END): `660 bits`, which is
  about `1,523 bit/s` at 30 FPS or `3,046 bit/s` at 60 FPS.

These are raw pre-ECC payload rates. ECC and any additional headers reduce user
file throughput.

## Reproduce the audit

```powershell
cd C:\Users\arshm\Desktop\CubeOCC
& C:\Users\arshm\anaconda3\python.exe dataset\audit_svm_pipeline.py `
  --frames sim\my_svm_full_test\results.json `
  --grades sim\cubeocc_top_all\symbols_review\symbols_review.json `
  --image-dir sim\my_svm_full_test\camera_gray `
  --out sim\my_svm_full_test\analysis\svm_pipeline_audit
```

Outputs:

- `summary.json`: leakage, correlation, PCA/LDA, and grouped CV summary
- `production_feature_correlation.csv`: production feature correlation matrix
- `payload_frames_used.csv`: every DATA frame actually included in the model

## Required next clean test

1. Generate at least one new random message not present in these 11 patterns.
2. Save its exact sender `*_frames.jsonl`.
3. Capture a new camera session and keep it untouched until model selection is
   frozen.
4. Map frames by sender sequence/timestamp, not predicted bit similarity.
5. Train only on the old 62 sets.
6. Report the untouched session once, including every ROI reject and discard.

## Related notes

- [[15_20_FEATURE_REDUCTION_PCA_LDA_DECISION]]
- [[15_18_LATEST_GRID_SVM_RETRAIN]]
- [[15_10_V2_CLASSIFIER_PIPELINE_ARCHITECTURE]]
- [[15_11_V2_TRAINING_VALIDATION_COMMANDS]]
