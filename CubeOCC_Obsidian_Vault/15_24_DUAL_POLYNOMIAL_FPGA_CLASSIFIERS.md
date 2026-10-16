# Selectable Directional FPGA Classifiers

## Purpose

This is an alternate research top. It keeps the working production
`cubeocc_top` unchanged and adds two selectable experimental classifier
branches after one shared ROI, projective warp, and 8x8 grid:

```text
camera -> RTL ROI -> RTL projective warp -> RTL 8x8 grid
       -> shared seven directional features
       -> shared 35-term degree-2 generator
          |-> old polynomial SVM word
          `-> PCA30-trained fused SVM word
```

These are not two copies of the camera pipeline. ROI, warp, grid, feature
extraction, and the 35-term generator are shared. Only the final coefficient
ROM, multiplier/accumulator path, and result word can be duplicated.

## Exact model names

| Friendly name | Code name | Output | `MODEL_SELECT` | Grouped-CV cell error |
|---|---|---|---:|---:|
| Directional Degree-2 SVM | `old_poly` | `symbols_old_poly` | 1 | 0.7181% |
| Directional Degree-2 PCA30-Fused SVM | `pca30_fused` | `symbols_pca30` | 2 | 0.6201% |
| Both branches | `both` | both outputs | 0 | compare both |

The alternate FPGA top is `rtl/cubeocc_dual_classifier_top.sv`. The word
"regular" below means `old_poly`; it is an SVM, not "SCM". Also, the 0.7181%
result is not the current production classifier. The unchanged production
`cubeocc_top` uses an earlier, simpler classifier with a different result.

Its two classifier outputs are:

- `symbols_old_poly`: older degree-2 directional model
- `symbols_pca30`: PCA30-trained model fused back onto the same polynomial terms

PCA30 is not calculated as 30 separate outputs in FPGA. During Python training,
PCA reduced the 35 polynomial terms to 30 principal components before fitting
the SVM. Export then multiplied the PCA, standardization, and SVM constants
together offline. The FPGA therefore evaluates a single fused score directly
from the original 35 terms. Selecting PCA30 does not instantiate a 30-output
PCA matrix.

## Choose which model is implemented

`MODEL_SELECT` is a synthesis-time parameter:

| Value | Implemented hardware | Disabled output |
|---:|---|---|
| 0 | both `old_poly` and `pca30_fused` | none |
| 1 | `old_poly` only | `symbols_pca30` is zero |
| 2 | `pca30_fused` only | `symbols_old_poly` is zero |

The recommended way to "delete" one model is to select the other model and
resynthesize. Do not delete coefficient files or edit the RTL by hand. Vivado
constant propagation removes the disabled coefficient ROM, multiplier,
accumulator, and result path from the synthesized netlist.

In the Vivado Tcl Console, use exactly one of these commands:

```tcl
# Keep both models for comparison.
source C:/Users/arshm/Desktop/CubeOCC/vivado/use_both_directional_models.tcl

# Implement only the 0.7181% old polynomial model.
source C:/Users/arshm/Desktop/CubeOCC/vivado/use_old_poly_model.tcl

# Implement only the 0.6201% PCA30-fused model.
source C:/Users/arshm/Desktop/CubeOCC/vivado/use_pca30_fused_model.tcl
```

Each selector also adds the alternate RTL files to an older Vivado project if
they are missing. Then reset and rerun Synthesis. A previous synthesized netlist
does not change just because the Tcl script was sourced.

For a physical bitstream, the selected classifier must also be placed behind a
board-level wrapper with the real camera, clock, reset, and result-output pins,
plus a matching XDC. This repository currently verifies and synthesizes the
alternate research top, but does not yet provide that physical pin wrapper. Do
not attempt Generate Bitstream with its large debug buses directly exposed as
package pins.

The equivalent direct Tcl setting is:

```tcl
set_property top cubeocc_dual_classifier_top [get_filesets sources_1]
set_property generic {MODEL_SELECT=2} [get_filesets sources_1]
update_compile_order -fileset sources_1
reset_run synth_1
launch_runs synth_1
```

Change `2` to `1` for `old_poly`, or `0` for both. This is compile-time
selection. Runtime switching would require keeping both branches and adding a
control register or input mux; that is not part of the current top.

## What features changed

The older production experiment used the center cell and a pooled axial-neighbor
summary. The new feature search stopped pooling every direction together. For
every non-corner grid cell, both selectable models now use seven separate raw
directional values:

```text
center, north, southeast, south, southwest, west, northwest
```

A missing neighbor at a grid edge falls back to the center value, exactly like
the Python training code. The search selected `N, SE, S, SW, W, NW`; east and
northeast were not selected. These seven values produce 35 terms:

- 7 linear terms
- 7 square terms
- 21 pairwise products

The two models use the same seven inputs and the same 35 generated terms. What
changes is the learned coefficient set. `old_poly` fits the SVM directly on the
standardized 35 terms. `pca30_fused` was trained after PCA30 and then fused back
onto those same terms for FPGA implementation.

All features use the accepted START frame as the per-cell white reference.
Division is removed from RTL by multiplying the whole decision equation by the
positive white-reference squared.

## Error results

These are leave-one-capture-set-out results from 40,800 payload cells and 62
capture sets. They estimate generalization; they are not the training error of
the final exported model.

| Model | LOCO errors | LOCO cell error |
|---|---:|---:|
| Older degree-2 directional SVM | 293 / 40,800 | 0.7181% |
| PCA30-trained fused SVM | 253 / 40,800 | 0.6201% |

The final all-data models are used to create hardware constants. Their
resubstitution results are only implementation checks:

| Final exported model | Float errors | Fixed-point errors | Fixed/float changed decisions |
|---|---:|---:|---:|
| Older polynomial | 252 | 252 | 2 |
| PCA30 fused | 239 | 239 | 0 |

The corpus currently uses majority-derived truth. Before replacing production
RTL, freeze these constants and test a new untouched capture with exact sender
JSONL ground truth.

## RTL verification

`tb/directional_dual_polynomial_sampler_tb.sv` tests all 806 available frames.
It resets between capture sets, learns each START map, reconstructs the actual
cell sums from the latest warped images, and compares both 64-bit RTL outputs
with the fixed-point reference.

```text
DUAL_SAMPLER_RESULT frames=806 failures=0
```

A second XSim smoke test drives 13 original camera rasters through the complete
alternate top, including live RTL ROI detection, warp, grid, and classification:

```text
DUAL_TOP_SMOKE_RESULT frames=13
FULL_TOP_COMPARE frames=13 mismatches=0
```

Across the complete generated corpus, the two model words differ on 24 of the
680 DATA frames. Identical words on easy frames are expected; the two
coefficient sets mainly differ around difficult decision margins.

Classifier latency is 7,489 clocks per 8x8 frame, or 74.89 us at 100 MHz. This
is longer than the production linear classifier, but still small compared with
the full ROI/warp processing time and well inside 30/60 FPS budgets.

## Measured Vivado resources

Device: `xc7a35tcpg236-1`, Vivado 2019.1, out-of-context synthesis.

| Design | LUT | FF | BRAM | DSP |
|---|---:|---:|---:|---:|
| Current `cubeocc_top` | 9,622 | 5,374 | 8 | 17 |
| Alternate top, both models (`MODEL_SELECT=0`) | 9,795 | 5,378 | 8 | 17 |
| Alternate top, `old_poly` only (`MODEL_SELECT=1`) | 9,575 | 5,193 | 8 | 16 |
| Alternate top, `pca30_fused` only (`MODEL_SELECT=2`) | 9,569 | 5,195 | 8 | 16 |
| Both-model increase over production | **173 (1.80%)** | **4 (0.07%)** | **0** | **0** |

Compared with keeping both branches, `old_poly`-only removes 220 LUT, 185 FF,
and one DSP. `pca30_fused`-only removes 226 LUT, 183 FF, and one DSP. This is
evidence that Vivado really trimmed the disabled model rather than merely
ignoring its output.

The both-model classifier alone meets 100 MHz with `WNS = +1.986 ns`. The complete
alternate top still misses 100 MHz with `WNS = -11.808 ns` because the unchanged
projective warp has the same approximately 21.753 ns critical path as the
production top. The new classifier is not the full-pipeline timing bottleneck.

## Regenerate models

From PowerShell in the repository root:

```powershell
& C:\Users\arshm\anaconda3\python.exe dataset\export_directional_dual_rtl.py `
  --frames sim\my_svm_full_test\results.json `
  --grades sim\cubeocc_top_all\symbols_review\symbols_review.json `
  --image-dir sim\my_svm_full_test\camera_gray `
  --out rtl\generated
```

This recreates:

- `dual_directional_coefficients.svh`: synthesizable coefficient functions
- `dual_directional_models.json`: preprocessing, coefficients, and parity data
- `dual_sampler_vectors.txt`: all-frame XSim regression vectors

## Run XSim regression

```powershell
X:\xilinx\Vivado\2019.1\bin\xvlog.bat -sv -i rtl `
  rtl\directional_dual_polynomial_sampler.sv `
  tb\directional_dual_polynomial_sampler_tb.sv

X:\xilinx\Vivado\2019.1\bin\xelab.bat `
  directional_dual_polynomial_sampler_tb -s dual_sampler_behav

X:\xilinx\Vivado\2019.1\bin\xsim.bat dual_sampler_behav -runall
```

## Regenerate resource reports

```powershell
X:\xilinx\Vivado\2019.1\bin\vivado.bat -mode batch `
  -source vivado\report_dual_classifier_resources.tcl -nojournal -nolog
```

Reports are written under `sim/dual_classifier_resource_reports`. The compact
tracked summary is `rtl/generated/dual_classifier_resource_summary.json`.

The report script synthesizes all three choices: both, `old_poly` only, and
`pca30_fused` only. Their report prefixes are respectively
`cubeocc_dual_classifier_top`, `cubeocc_old_poly_only`, and
`cubeocc_pca30_only`.

## Which model should be used?

- Use `pca30_fused` (`MODEL_SELECT=2`) for the current lowest measured grouped
  error and the slightly smallest synthesized top.
- Use `old_poly` (`MODEL_SELECT=1`) as the non-PCA experimental baseline.
- Use `both` (`MODEL_SELECT=0`) only when comparing model decisions on the same
  live frame. It costs more hardware and produces two words.

The 0.7181% and 0.6201% values are grouped cross-validation estimates from the
existing corpus, whose truth is majority-derived. They are not a guarantee for
new physical captures. Before treating either as production accuracy, evaluate
a fresh untouched capture with exact sender JSONL truth.

## Related notes

- [[15_22_DIRECTIONAL_NEIGHBOR_FEATURE_SEARCH]]
- [[15_23_DIRECTIONAL_PCA_LDA_STUDY]]
- [[15_25_FPGA_UART_OUTPUT_AND_SIM_DECODER]]
