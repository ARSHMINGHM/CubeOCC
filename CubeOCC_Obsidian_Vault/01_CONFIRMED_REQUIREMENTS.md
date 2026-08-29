---
project: CubeOCC
type: requirements
status: source-of-truth
last_reviewed: 2026-08-22
---

# Confirmed Requirements

## Project scope

- Two-person GitHub project.
- Approximate duration: one month.
- FPGA-oriented Optical Camera Communication receiver.
- Simulation-first because the physical FPGA/camera setup is not currently available.
- Main initial payload is text, but the receiver should recover a generic bitstream.
- The testbench should behave like real camera hardware as closely as practical so the FPGA-side code can later be connected to a real sensor with minimal or no redesign.

## Versioned Symbol Alphabet

V1 starts with grayscale/on-off symbols so the first receiver can prove the full streaming path with averaging only.

V1.5 upgrades to RGB symbols:

All **8 binary RGB combinations are legal DATA symbols**:

| RGB state | Example bit mapping |
|---|---|
| Black | 000 |
| Blue | 001 |
| Green | 010 |
| Green + Blue | 011 |
| Red | 100 |
| Red + Blue | 101 |
| Red + Green | 110 |
| White | 111 |

## 8×8 DATA frame

- 64 total optical cells.
- 4 corner markers are white during normal DATA.
- 1 dedicated CLK/toggle cell.
- 59 remaining cells carry payload + ECC symbols.
- V1 grayscale mode: each of those 59 cells carries one on/off bit.
- V1.5 RGB mode: each of those 59 cells carries one of 8 RGB states = 3 bits.
- Therefore V1 has **59 coded bits per 8×8 DATA frame**, and V1.5 RGB mode has **177 coded bits per 8×8 DATA frame**, before payload/ECC packing is chosen.

## CLK cell

- Exact physical cell coordinate is not important.
- It may be first row/second column, last row, or another reserved cell.
- It should be configurable in code.
- CLK toggles between successive transmitted DATA frames.
- This lets identical consecutive payload layouts still represent different transmitted frames.

## START frame

- Exactly one transmitted optical frame in the current baseline.
- **All 64 cells are white**, including the CLK position.
- Carries no payload.

## END frame

Exactly one transmitted optical frame:

- TL marker = white
- TR marker = white
- BL marker = white
- BR marker = off/black
- CLK = off/black
- all ordinary data cells = off/black

This supersedes earlier generated diagrams that showed END incorrectly.

## Control-frame policy

- Black and white remain legal DATA cell symbols.
- START and END are reserved **whole-frame patterns**, not reserved individual colors.
- No two-frame persistence requirement in V1.
- Sequence number is **V2/later only**, not required in V1. Revisit placement when ECC modes and padding bits are tested.

## Capture/transmit-rate concept

Example target relationship:

- Camera 1 / tracking camera: about **60 FPS**
- Camera 2 / data camera: about **30 FPS**
- A camera may capture the same displayed optical frame multiple times.
- CLK distinguishes a genuinely new transmitted DATA frame from repeated camera captures of the same displayed frame.

## Camera 1

- grayscale
- lower quality is acceptable
- faster than Camera 2
- continuously tracks ROI
- detects marker positions
- computes/updates geometry
- estimates simple brightness
- outputs tracking/frame confidence
- sends feedback/parameters to the processing path

### Explicitly removed from V1

- no glare-detection algorithm
- no glare-compensation algorithm

Glare remains a test condition whose effect on BER can be measured.

## Camera 2

- data camera
- V1 grayscale processing
- V1.5 RGB symbols
- slower than Camera 1
- used for DATA recovery
- configured using ROI information from Camera 1
- uses sensor-level ROI/windowing
- FPGA receives the cropped ROI stream rather than the full raw sensor frame

## Camera calibration at transfer start

At START:

1. Both cameras observe the START/marker geometry.
2. Detect the four corresponding corner positions in Camera 1.
3. Detect the four corresponding corner positions in Camera 2.
4. Compute the relationship/per-corner coordinate differences between both views.
5. Use that mapping during the transfer to translate Camera 1 ROI information into Camera 2 sensor-window coordinates.

Large residuals should be reported as mapping/calibration error rather than claimed as a specific defect such as fisheye distortion.

## Warp

- Marker geometry is available every frame.
- Warp/geometric correction is updated from current marker positions every frame.
- No V1 optimization that reuses an old warp is required.

## V1 image-processing flow

- sensor-cropped grayscale ROI stream
- denoise/bypass experiment
- perspective/geometric correction
- configurable grid extraction
- per-cell circular-region grayscale accumulation/averaging
- grayscale/on-off recovery
- frame/link decode
- ECC decode
- recovered bitstream

## Storage philosophy

V1 should **not** store complete raw images merely to process them later.

Instead:

- stream pixels through image processing
- use only required line/local buffers
- accumulate per-cell grayscale information in V1, then per-cell RGB information in V1.5
- retain reduced results such as averages, symbols, metadata or decoded bits

Full-frame FF storage is no longer a V1 requirement.

## Sampling radius

- configurable circle-based experiment parameter
- estimate each grid box/cell center and the average box/cell size
- test small, medium, and large sampling circles per supported grid size
- visualize the sampling region during validation
- choose defaults using measured BER/SER/classification results

## Color decision

V1: grayscale/on-off averaging only.

V1.5: RGB threshold/classification logic.

V2: calibrated classifier experiment, including offline Python SVM training and FPGA implementation of the learned decision behavior. Normalized RGB/chromaticity remains a comparison candidate.

## ECC

Compare:

- no-ECC baseline
- multiple Hamming candidates
- multiple BCH candidates
- different correction strengths
- payload efficiency
- raw BER
- post-ECC BER
- goodput
- latency
- FPGA resources

## Simulation

- simulated start button
- testbench emulates camera register behavior and pixel-stream behavior
- Camera 2 ROI/windowing registers are modeled
- DUT interacts with simulated sensor as if it were hardware
- real phone captures from a laptop/display are used as dataset inputs
- images are labeled by conditions
- CSV/TXT results are generated

## Parallelism policy

V1:

- one reusable processing pipeline
- no scheduler required if one pipeline keeps up
- no input FIFO required if there is only one worker and it can sustain sensor rate

Optional optimization:

- instantiate the same pipeline module N times
- input scheduler chooses a free worker
- one shared one-frame overflow buffer only if needed
- raise an overflow flag if another frame arrives while that buffer is full
- output reorder buffer restores frame order
