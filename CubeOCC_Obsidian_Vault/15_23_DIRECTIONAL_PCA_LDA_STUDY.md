# Directional PCA and LDA Study

## Selected feature combination

The study uses the strongest directional combination from the exhaustive
neighbor search:

1. current cell mean
2. north (`N`)
3. southeast (`SE`)
4. south (`S`)
5. southwest (`SW`)
6. west (`W`)
7. northwest (`NW`)

All values are normalized with the current cell's START-frame white reference.

## Validation rule

- 40,800 tested non-corner cells
- 62 complete capture sets
- leave-one-capture-set-out validation
- scaling, polynomial expansion, PCA, and LDA are fitted inside each training fold
- visual-only PC plots are fitted to all samples and are not used for error reporting
- ground truth remains the all-capture majority sequence, so the frozen winner
  still needs an untouched randomized capture with exact sender JSONL

## PC1 and PC2 of the seven original features

![[assets/directional_reduction/raw_pc1_pc2_biplot.png]]

- PC1 explains 31.85% of variance.
- PC2 explains 18.82%.
- Together they explain 50.67%.
- Arrows show feature loadings.
- `X` marks show class centroids.
- Dashed ellipses are two-standard-deviation visual guides, not decision boundaries.

The classes have visible structure in PC1/PC2, but they still overlap. The
low-variance components contain important difficult-cell information.

## Polynomial PC1 and PC2

The seven inputs expand to 35 degree-2 terms: seven linear terms, seven squares,
and 21 pairwise interactions.

![[assets/directional_reduction/polynomial_pc1_pc2_density.png]]

- Polynomial PC1 explains 14.22%.
- Polynomial PC2 explains 8.21%.
- Together they explain only 22.44%.
- Hexagon color shows logarithmic sample density.

PC1 and PC2 are useful for visualization, but they are not sufficient for the
classifier.

## Explained variance

![[assets/directional_reduction/pca_explained_variance.png]]

For the original seven features, all seven components are needed to preserve the
working classifier. For the 35 polynomial features, PCA30 retains 95.73% of total
variance.

## Classification result

| Case | Errors / 40,800 | Error |
|---|---:|---:|
| Seven raw features, linear SVM | 315 | 0.7721% |
| Seven raw features, PCA7, SVM | 315 | 0.7721% |
| Seven raw features, LDA | 941 | 2.3064% |
| Existing degree-2 directional SVM | 293 | 0.7181% |
| Standardized degree-2 PCA35 SVM | 294 | 0.7206% |
| Degree-2 PCA30 SVM | **253** | **0.6201%** |
| Degree-2 PCA31 SVM | 254 | 0.6225% |
| Degree-2 PCA32 SVM | 254 | 0.6225% |
| Degree-2 PCA33 SVM | 254 | 0.6225% |
| Best LDA case: degree-2 PCA31 | 299 | 0.7328% |

![[assets/directional_reduction/pca_component_error.png]]

PCA is not useful as heavy compression. Below approximately 25 polynomial
components, error rises sharply. PCA30 works as a mild noise-removal and
regularization step by removing five low-value directions.

Compared with the existing 293-error polynomial model, PCA30:

- corrects 52 previously wrong cells
- makes 12 previously correct cells wrong
- reduces total errors by 40
- gives an unadjusted paired exact `p = 4.57e-7`

This p-value is descriptive because component count 30 was selected on this
corpus. Independent confirmation is still required.

## LDA result

![[assets/directional_reduction/lda_score_distribution.png]]

Binary LDA produces one discriminant axis. Its all-data visualization appears
well separated, but grouped validation is worse than SVM:

- raw LDA: 2.3064%
- best polynomial/PCA LDA: 0.7328%
- PCA30 SVM: 0.6201%

LDA is therefore not the selected classifier.

## FPGA interpretation

A literal PCA implementation would be expensive: 30 principal components from
35 polynomial features would require a large matrix-vector multiplication.
It is not necessary.

For a linear SVM after PCA:

```text
score = w_pca^T * P * (z - mean) + bias
```

The trained constants can be multiplied offline:

```text
w_fused = P^T * w_pca
bias_fused = bias - w_pca^T * P * mean
score = w_fused^T * z + bias_fused
```

Therefore PCA30 can remain a training-time regularizer. FPGA inference can use
one fused linear rule over the 35 degree-2 features without calculating or
storing 30 principal-component outputs.

This is still substantially more expensive than the production two-feature
linear rule because the degree-2 model needs squares and pairwise products.

## Decision

The current research winner is:

```text
center + N + SE + S + SW + W + NW
-> degree-2 expansion (35 terms)
-> standardization
-> PCA30 during training
-> linear SVM
-> fuse PCA and SVM weights for inference
```

Do not replace production RTL yet. Freeze PCA30 and test it without retuning on
a new randomized payload capture with exact sender ground truth. Compare it with
the low-cost pooled directional model and the current production classifier.

The two degree-2 models now also have a shared experimental FPGA implementation:
[[15_24_DUAL_POLYNOMIAL_FPGA_CLASSIFIERS]].

## Reproduce

```powershell
cd C:\Users\arshm\Desktop\CubeOCC
& C:\Users\arshm\anaconda3\python.exe dataset\compare_directional_pca_lda.py `
  --frames sim\my_svm_full_test\results.json `
  --grades sim\cubeocc_top_all\symbols_review\symbols_review.json `
  --image-dir sim\my_svm_full_test\camera_gray `
  --out sim\my_svm_full_test\analysis\directional_reduction `
  --jobs 8
```

Tracked results are in `directional_reduction_latest/`.

## Output guide

- `pca_lda_cases.csv`: all tested PCA/LDA cases
- `raw_pc1_pc2_biplot.png`: raw feature PC1/PC2 with loadings and ellipses
- `polynomial_pc1_pc2_density.png`: polynomial PC1/PC2 class densities
- `pca_explained_variance.png`: individual and cumulative variance
- `pca_component_error.png`: grouped error versus component count
- `lda_score_distribution.png`: one-dimensional LDA class separation
- `best_reduction_cases.png`: ranked best cases
- `paired_best_pca.json`: PCA30 versus prior polynomial winner
- `best_pca_predictions.csv`: paired cell-level decisions

## Related notes

- [[15_22_DIRECTIONAL_NEIGHBOR_FEATURE_SEARCH]]
- [[15_21_ADDITIONAL_HARDWARE_FEATURE_SEARCH]]
- [[15_20_FEATURE_REDUCTION_PCA_LDA_DECISION]]
- [[15_19_SVM_LEAKAGE_FEATURE_FPGA_AUDIT]]
