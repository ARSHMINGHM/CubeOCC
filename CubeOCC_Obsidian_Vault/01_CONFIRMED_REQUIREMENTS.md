---
project: CubeOCC
type: requirements
status: source-of-truth
last_reviewed: 2026-08-22
---
# Confirmed Requirements

## Scope
- Two-person GitHub project, roughly one month.
- FPGA-oriented Optical Camera Communication receiver using cubic RGB on/off symbols on an LED/pixel grid.
- Initial implementation is simulation-first because FPGA/cameras are not currently available.
- Main tests are expected to use text, while the receiver ultimately produces a generic bitstream.

## 8-symbol RGB cube alphabet
The symbol set is: **R, G, B, R+G, R+B, G+B, White, Black**. This is naturally 3 bits per symbol. The exact bit-to-color numbering is not yet locked.

## 8×8 DATA frame
- 64 cells total.
- 4 fixed white corner markers during normal DATA frames.
- 1 dedicated CLK/frame-change cell.
- 59 remaining cells carry payload + ECC symbols.
- 59 × 3 = **177 coded bits per DATA frame** before deciding the payload/ECC split.

## START frame
- Full bright white frame.
- Used as start/preamble of a transfer.
- Transfer begins from a button action in future hardware; the button is simulated in the testbench.

## END frame — latest correction
- All ordinary data cells are black/off.
- Top-left marker = white/on.
- Top-right marker = white/on.
- Bottom-left marker = white/on.
- Bottom-right marker = off.
- CLK = off.

> [!important]
> This supersedes any older diagram/text showing END as fully black or showing the bottom-right marker still white.

## CLK behavior
- CLK allows two visually identical consecutive DATA frames to still be recognized as different frames.
- Exact CLK grid coordinate has **not** been explicitly confirmed.

## Camera 1 — grayscale feedback/tracking
- Lower quality, grayscale.
- Detects ROI and the white corner markers.
- Feeds marker/position information toward the RGB camera path.
- Must account for physical offset between the two cameras.
- Can suggest processing parameters such as denoising/other correction.

## Camera 2 — RGB data path
- RGB and allowed to be lower speed.
- Used for the actual data image.
- Uses ROI so processing focuses on the optical grid.

## Requested buffering/parallelism concept
- Keep several recent frames in FIFO-like order.
- New frames push older frames back; oldest is discarded after buffer depth is exceeded.
- Multiple image-processing units operate in parallel.
- A scheduler checks worker free/busy state, waiting images, and maps images to workers.
- Original proposal preferred latches/FFs rather than RAM; this implementation choice is separated into [[08_ARCHITECTURE_RECOMMENDATIONS]].

## Image processing
- Denoising.
- Reduce effects of sun glare/lighting.
- Perspective correction/warp so the grid becomes box-like rather than diagonal.
- Configurable grid size such as 8×8, 10×10, etc.
- Separate cells.
- For each cell: find center, choose a radius, average R/G/B inside that radius, map to nearest 8-symbol RGB cube state.
- Convert symbols back to bits.

## ECC
- Compare Hamming and BCH.
- Test multiple strengths (low/medium/strong conceptually).
- Compare error rate and speed.

## Output
- Main goal is the recovered bitstream/file.
- Future hardware interfaces mentioned: UART, USB-C, I2C, other FPGA pins/interfaces.

## Simulation/testbench
- Vivado/Vitis HLS style simulation.
- Use phone captures of a laptop/display, labeled by conditions.
- Testbench should behave like a camera source, not just pass a perfect image array.
- Read labeled image folders, compare output to ground truth, and write CSV/TXT results.

## Evaluation
- BER.
- Speed/throughput.
- Condition labels.
- Effect of processing and ECC choices.
