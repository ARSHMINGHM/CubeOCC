---
project: CubeOCC
type: task-backlog
status: active
last_reviewed: 2026-08-28
---

# Task Backlog

This note is for user-defined project tasks. Do not auto-fill it from open questions; tasks should be added only after Armin describes them.

Tasks are organized by V1 pipeline units. Add and refine tasks progressively as we walk through each unit in conversation, from sender side to camera units, image processing, link/payload decode, ECC, regression, and reporting.

## Inbox

### V1 Unit — Sender Side

#### Sender frame generator

- [ ] Generate V1 grayscale/on-off START frame images.
- [ ] Generate V1 grayscale/on-off DATA frame images.
- [ ] Generate V1 END frame images.
- [ ] Include four white corner markers in normal DATA frames.
- [ ] Include a configurable CLK/toggle cell in DATA frames.
- [ ] Build the sender output as an image folder that the camera simulation can consume.
- [ ] Display sender frames on the monitor so the ROI camera can capture realistic test photos.

#### Sender ECC encoder

- [ ] Keep no-ECC mode for raw BPS/throughput testing.
- [ ] Add the simple/fast Hamming encoder baseline.
- [ ] Leave BCH, sequence numbers, shortened codes, CRC, and SVM calibration for later versions.

### V1 Unit — Camera Simulation

#### Shared camera model

- [ ] Build V1 simulation camera model behavior close to physical hardware.
- [ ] Add image-folder input for V1 grayscale sender frames.
- [ ] Convert folder images into `.mem` files for simulation.
- [ ] Stream image-backed pixels through the camera model using camera timing signals.
- [ ] Use real or generated image files for protocol testing; do not use random patterns for ROI validation.
- [ ] Verify camera output with pass/fail testbenches for pixel count, line count, frame start, and ROI crop behavior.
- [ ] Compare DVP and MIPI-style simulation paths before choosing a physical camera direction.

#### Camera 1 unit — ROI / tracking camera

- [ ] Model Camera 1 as the full-scene low-resolution grayscale ROI/tracking camera.
- [ ] Capture real monitor photos with another camera for ROI/tracking tests.
- [ ] Use those monitor-capture images as the ROI test dataset.
- [ ] Detect the four corner markers from Camera 1 input.
- [ ] Estimate marker confidence and basic brightness from Camera 1.
- [ ] Compute ROI/window geometry for Camera 2 from Camera 1 marker positions.
- [ ] Keep Camera 1 as a feedback/tracking source, not the main data receiver.

#### Camera 2 unit — data camera ROI path

- [ ] Model Camera 2 as the data camera with sensor-side ROI/windowing.
- [ ] Configure Camera 2 ROI registers through I2C writes.
- [ ] Make Camera 2 output only the selected ROI pixels, not the full frame.
- [ ] Verify fake camera ACK behavior for ROI register writes.

### V1 Unit — Dataset

- [ ] Label each monitor-capture image set with distance.
- [ ] Label each monitor-capture image set with viewing angle.
- [ ] Label each monitor-capture image set with brightness and screen brightness.
- [ ] Label each monitor-capture image set with blur, glare/reflection, and exposure.
- [ ] Label each monitor-capture image set with grid size, camera FPS, and optical frame rate.

### V1 Unit — Image Processing

#### Input and geometry

- [ ] Receive Camera 2 cropped ROI pixels as the V1 image-processing input stream.
- [ ] Use four detected corners to map the active grid.
- [ ] Implement warp or coordinate mapping from marker geometry.
- [ ] Extract the static 8x8 grid from the ROI.
- [ ] Find each cell center and estimate average cell size.

#### Circular sampling and averaging

- [ ] Test small, medium, and large circular sampling regions around each cell center:
  - find the center of each detected grid cell
  - estimate each cell's width and height from the detected grid geometry
  - calculate the average cell size for the active grid
  - choose circle radii as fractions of that average cell size
  - compare small, medium, and large radii for each supported grid size
  - use the radius that gives the most stable grayscale/on-off recovery across the monitor-capture dataset
- [ ] Average grayscale pixels inside each sampling circle.
- [ ] Recover grayscale/on-off DATA symbols from per-cell averages.
- [ ] Report image-processing metrics: pixels, lines, cells, symbols, errors, and recovered bits.

#### Streaming / no full raw-frame storage

- [ ] Keep V1 as a streaming pipeline from camera input to recovered bits.
- [ ] Avoid storing a complete raw frame unless a later measurement proves it is needed.
- [ ] Use only required line/local buffers for filtering or coordinate mapping.
- [ ] Store reduced grid metadata instead of full image data.
- [ ] Store per-cell sums, pixel counts, cell averages, recovered symbols, and decoded bits.
- [ ] Confirm the design can process the ROI stream without a full-frame RAM/FF buffer in the baseline.

### V1 Unit — Link / Payload Decoder

#### Frame decoder

- [ ] Decode START, DATA with CLK toggle, and END.
- [ ] Recover ordered grayscale payload bits.

#### ECC decoder

- [ ] Add the simple/fast Hamming decoder baseline.
- [ ] Keep no-ECC decode path for raw BPS/throughput testing.
- [ ] Leave BCH, sequence numbers, shortened codes, CRC, and SVM calibration for later versions.

### V1 Unit — Testbench / Regression

- [ ] Check pixel count for each camera/path simulation.
- [ ] Check line count and end-of-line markers.
- [ ] Check frame start markers and frame count.
- [ ] Check ROI crop size and ROI crop position.
- [ ] Check START frame detection.
- [ ] Check DATA frame detection with CLK toggle.
- [ ] Check END frame detection.
- [ ] Check repeated captures of the same optical frame do not create duplicate DATA frames.

### V1 Unit — Reporting Output

- [ ] Write CSV or TXT logs for recovered bits.
- [ ] Write CSV or TXT logs for frame status.
- [ ] Write CSV or TXT logs for symbol errors and raw BER.
- [ ] Write CSV or TXT logs for pixel count, line count, and basic timing metrics.
- [ ] Capture basic synthesis/resource notes when V1 reaches implementation.

## GitHub Issue Candidates

Move reviewed tasks here when they are ready to become GitHub issues.

- [ ] 
