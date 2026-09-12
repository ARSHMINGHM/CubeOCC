---
project: CubeOCC
type: rtl-unit
status: implemented-and-simulated
parent: 15_TASK_BACKLOG
---

# FPGA Start ROI Detector

Parent task tree:

- [[15_TASK_BACKLOG]]

Related notes:

- [[04_CAMERA_ROI_AND_CALIBRATION]]
- [[05_V1_STREAMING_PIPELINE]]
- [[15_04_MANUAL_ROI_CORNER_REVIEW]]

## V1 Decision

V1 uses an axis-aligned Camera 1 ROI detector, not a perspective-corner/warp detector.

Camera 2 sensor ROI registers require exactly this output:

```text
x start, y start, width, height
```

The more expensive perspective correction remains a later image-processing stage after Camera 2 has already received its cropped ROI stream.

## RTL Unit

```text
rtl/roi_start_detector.sv
tb/roi_start_detector_tb.sv
dataset/roi_start_detector_model.py
```

The GUI `dataset/roi_corner_labeler.py` calls the reference model for every monitor capture. This is intentional: running XSim separately for hundreds of photographs would be slow. The model contains the implemented RTL START-acquisition behavior plus a proposed streaming DATA recovery/hold policy and records its settings with every `true`, `mid`, or `false` label.

Inputs are raw DVP timing (`vsync`, `href`, pixel data) and three control values:

```text
bright_threshold
min_line_run
min_roi_height
```

At each pixel clock, the unit compares `pixel_data >= bright_threshold`. For every active row, it keeps only the longest continuous bright run. Consecutive qualifying rows form a candidate band. The tallest candidate band becomes the ROI.

## Resource And Speed Profile

| Item | V1 RTL behavior |
| --- | --- |
| Throughput | One input pixel every `pclk` cycle. |
| Output time | At the end of the camera frame; this is the earliest possible time for a full-frame ROI decision. |
| Frame storage | None. |
| BRAM | None. |
| DSP multipliers | None. |
| Division | None. |
| Main logic | Threshold comparator, run-length counters, min/max registers, and band-control logic. |

More FPGA arithmetic cannot make a one-pixel-per-clock DVP camera deliver a completed full-frame ROI before the final pixel arrives. To reduce end-to-end latency, Camera 1 should use a lower resolution or higher frame/pixel clock, for example `320 x 240` grayscale when its ROI accuracy is sufficient.

## Vivado Test

The standalone testbench includes a short bright reflection and a taller bright START/screen region. The detector must ignore the reflection and select the screen region.

Expected result:

```text
ROI x=10 y=8 width=41 height=28
Result: ROI START DETECTOR PASS
```

To run it in Vivado, set simulation top to `roi_start_detector_tb`, then select **Run Simulation -> Run Behavioral Simulation**. The project-creation Tcl includes both the RTL and testbench files for a newly created project.

## Next RTL Extension

The current `rtl/roi_start_detector.sv` implements START acquisition only. The reference model has been tested over the 807-image monitor-capture corpus with these additional modes:

1. `data-marker-tracking`: four local marker-window counters and coordinate sums, seeded from the prior ROI.
2. `data-footprint-recovery`: a bright-pixel count plus left/right/top/bottom extrema, accepted only when the footprint is large enough to represent a grid.
3. `hold-prior-roi`: retain the last valid ROI for blank/END-style frames.

These modes are deliberately compatible with a streaming FPGA design: no raw frame buffer, image warp, or external vision library is required. They still need to be added to RTL and covered by a Vivado testbench before they are called an FPGA implementation.

## Limits

This V1 detector finds a rectangular sensor crop. It does not compensate for strong glare, non-rectangular optical geometry, or perspective. The `true`, `mid`, and `false` review labels from [[15_04_MANUAL_ROI_CORNER_REVIEW]] determine whether this low-resource baseline is sufficient before adding a more advanced mode.
