# Directional Neighbor Feature Search

## Purpose

The production classifier currently combines the four axial neighbors into one
mean. This experiment asks whether keeping `N`, `NE`, `E`, `SE`, `S`, `SW`, `W`,
and `NW` separate, or pooling selected subsets, improves grayscale cell recovery.

This is Python model research only. The production RTL has not been changed.

## Evaluation data

- 40,800 non-corner cell decisions
- 62 camera capture sets
- Images come from the latest RTL ROI, warp, and 8x8 grid path
- Primary validation: leave one complete capture set out (LOCO)
- Secondary audit: leave one payload-frame index out
- Current ground truth is the all-capture majority sequence, not exact sender JSONL

The last point matters: a frozen winner must still be tested on a new randomized
payload capture with exact sender ground truth.

## Features

Every brightness value is divided by the START-frame white reference for the
current cell.

Directional inputs:

- `N`: cell above
- `NE`: upper-right diagonal
- `E`: cell to the right
- `SE`: lower-right diagonal
- `S`: cell below
- `SW`: lower-left diagonal
- `W`: cell to the left
- `NW`: upper-left diagonal

For a missing neighbor at the outer grid boundary, a separate directional input
falls back to the current-cell value. A pooled subset ignores unavailable
directions and averages only real neighbors. This avoids creating fake zero-valued
neighbors around the grid border.

Two exhaustive representations were tested:

1. **Separate inputs:** current-cell mean plus every selected direction as its own SVM feature.
2. **Pooled mean:** current-cell mean plus one equal-weight average of the selected directions.

There are `2^8 - 1 = 255` non-empty directional subsets, so the two
representations produce 510 directional models.

## Nonlinear and summary features

Thirty additional models tested:

- axial, diagonal, and all-neighbor means
- axial, diagonal, and all-neighbor variance
- axial, diagonal, and all-neighbor range
- north/south, east/west, and diagonal opposite-pair contrasts
- axial-minus-diagonal mean
- center-minus-neighbor mean
- mean absolute and squared center-neighbor disagreement
- center multiplied by neighbor mean
- fraction of neighbors above the center
- fraction of neighbors below half the START white level
- top, right, bottom, and left three-neighbor fan means
- grouped variance, contrast, fan, and nonlinear-disagreement bundles

Selected directional models were also expanded with degree-2 polynomial terms.

Total evaluated model records: 545.

## Main LOCO results

| Model | Inputs | Errors | Cell error |
|---|---|---:|---:|
| Current baseline | center + axial-neighbor mean | 336 | 0.8235% |
| Best pooled linear | center + `N NE SE S SW W NW` mean; excludes `E` | 314 | 0.7696% |
| Best separate linear | center + `N SE S SW W NW` | 315 | 0.7721% |
| All directional summaries | center + summary bank | 316 | 0.7745% |
| Best degree-2 model | center + `N SE S SW W NW`, polynomial | **293** | **0.7181%** |
| All eight, degree 2 | center + all eight directions, polynomial | 298 | 0.7304% |

The best degree-2 model fixes 78 baseline mistakes and introduces 35 new ones.
The unadjusted paired exact test gives `p = 6.45e-5`, but this is descriptive,
not confirmatory, because the winner was selected from hundreds of models on the
same corpus.

Relative to the baseline, the observed reductions are:

- best pooled linear: about 6.5% fewer errors
- best degree-2 directional: about 12.8% fewer errors

## Payload-pattern audit

The camera captures repeat the same payload sequence, so a directional model
could accidentally learn spatial relationships specific to those words. To test
that risk, each payload frame index was withheld in turn.

| Model | Leave-one-payload-frame-out error |
|---|---:|
| Baseline | 317 / 40,800 = 0.7770% |
| Best pooled linear | 301 / 40,800 = 0.7377% |
| Best separate linear | 305 / 40,800 = 0.7475% |
| Best separate degree 2 | **274 / 40,800 = 0.6716%** |
| All eight degree 2 | 277 / 40,800 = 0.6789% |

This is reassuring, but it is not a fully independent test because the capture
conditions remain represented in training.

## Correlation result

The raw directional features are not duplicates. Their correlations with the
center range from about `0.19` to `0.40`, and most direction-to-direction
correlations are between approximately `-0.06` and `0.37`.

The strongest center correlations are north (`0.40`) and south (`0.38`). The
top 32 subset models also favor `S`, `N`, `NW`, and `SW`. East, northeast, and
southeast appear much less often. This asymmetry may describe camera/display
update direction or directional blur, but it needs a fresh randomized test before
being treated as a physical effect.

## FPGA implications

The pooled seven-direction model is the practical candidate:

- still only two classifier inputs
- reuses the 64 cell sums already produced by the grid sampler
- needs diagonal-cell addressing and a wider neighbor accumulator
- should not require a new image buffer
- cheaper than separate direction weights or polynomial features

The best polynomial model expands seven original inputs (center plus six
directions) into 35 degree-2 features. A direct parallel RTL implementation would
need many products and weighted accumulations. It should not be implemented until
independent data proves that its extra 43 corrected decisions are repeatable.

## Decision

Do not replace the production classifier yet. Freeze these two candidates:

1. low-cost: pooled `N NE SE S SW W NW`, excluding `E`
2. research: degree-2 `center + N SE S SW W NW`

Capture a new test video with randomized 64-bit DATA frames that were not used
during model selection. Preserve the sender JSONL and evaluate the frozen models
without retuning. Prefer the pooled model if its improvement survives; only
consider the polynomial model if its additional gain is large enough to justify
the FPGA cost.

## Reproduce

```powershell
cd C:\Users\arshm\Desktop\CubeOCC
& C:\Users\arshm\anaconda3\python.exe dataset\explore_directional_neighbors.py `
  --frames sim\my_svm_full_test\results.json `
  --grades sim\cubeocc_top_all\symbols_review\symbols_review.json `
  --image-dir sim\my_svm_full_test\camera_gray `
  --out sim\my_svm_full_test\analysis\directional_neighbor_exploration `
  --jobs 8
```

Add `--reuse-subsets` when `directional_subset_results.csv` already exists and
the input dataset has not changed. This skips the expensive 510-model subset
search and regenerates the later diagnostics. Without the flag, the subset search
is rebuilt so an old table cannot silently survive a changed dataset.

Tracked results are in `directional_neighbor_latest/`.

## Output guide

- `directional_subset_results.csv`: all 510 subset models
- `engineered_neighbor_results.csv`: nonlinear and summary features
- `selected_nonlinear_models.csv`: selected degree-2 comparisons
- `directional_feature_correlation.png`: center plus eight raw directions
- `engineered_feature_correlation.png`: full engineered correlation heatmap
- `best_directional_models.png`: top linear subsets
- `model_family_comparison.png`: baseline versus winning families
- `error_by_subset_size.png`: error versus number of selected directions
- `top_model_direction_frequency.png`: direction frequency in the top 32
- `payload_generalization.png`: unseen-payload-frame audit
- `paired_winner_comparison.json`: per-capture paired baseline comparison
- `winner_predictions.csv`: baseline and winner decision for every tested cell

## Related notes

- [[15_23_DIRECTIONAL_PCA_LDA_STUDY]]
- [[15_21_ADDITIONAL_HARDWARE_FEATURE_SEARCH]]
- [[15_20_FEATURE_REDUCTION_PCA_LDA_DECISION]]
- [[15_19_SVM_LEAKAGE_FEATURE_FPGA_AUDIT]]
- [[15_18_LATEST_GRID_SVM_RETRAIN]]
