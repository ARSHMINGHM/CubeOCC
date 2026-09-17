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
- [[15_06_SOURCES_AND_FPGA_UI]]
- [[15_07_XSIM_RTL_ROI_REVIEW]]

## V1 Decision

V1 uses four tracked Camera 1 corners and converts their enclosing bounds to
an axis-aligned Camera 2 ROI. It does not warp or perspective-correct pixels.

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

`dataset/roi_start_detector_model.py` mirrors the low-resource protocol state
machine for fast software exploration. The evidence path for actual FPGA RTL
coordinates is the XSim runner and browser review in
[[15_07_XSIM_RTL_ROI_REVIEW]].

Inputs are raw DVP timing (`vsync`, `href`, pixel data) and four control values:

```text
bright_threshold
min_line_run
min_roi_height
full_off_max_pixels
```

At each pixel clock, the unit compares against `bright_threshold - 32`; the
margin lets dim or defocused white screens remain detectable without a
histogram or frame buffer. Before START, each row finds its longest continuous
white run. The first and last qualifying rows provide the top-left, top-right,
bottom-left, and bottom-right bright-to-dark boundaries. This is the hardware
form of searching from the white interior outward, and it preserves a slanted
or trapezoidal START region. During DATA, each corner must form a small
multi-row bright box within a fixed `10 px` window around the bounding corners
captured from the START frame. The fixed START anchors prevent many individually
small updates from accumulating into a large inward drift. The block keeps the
prior geometry if a box is absent or leaves that window. A frame with at most
`full_off_max_pixels` bright pixels
clears tracking.

## Resource And Speed Profile

Vivado 2019.1 technology mapping of `roi_start_detector` by itself for
`xc7a35tcpg236-1` produced the following primitive usage:

| Resource | Used | Device available | Approx. use |
| --- | ---: | ---: | ---: |
| LUT primitives | 2,115 | 20,800 | 10.17% |
| Flip-flops | 912 | 41,600 | 2.19% |
| BRAM tiles | 0 | 50 | 0% |
| DSP blocks | 0 | 90 | 0% |
| CARRY4 | 224 | - | - |
| BUFG | 1 | - | - |

These are standalone synthesis numbers for the ROI detector, not the complete
CubeOCC top. The design stores counters, row-run state, four marker windows,
and coordinates only; it does not infer a frame buffer. Vivado completed
technology mapping with zero synthesis errors, but this Windows installation
then reported a Vivado 2019.1 temporary-folder cleanup error before the normal
packed-utilization and timing report commands could execute. Therefore the LUT
figure above is the sum of mapped `LUT1..LUT6` primitives, not a post-place
slice count. Re-run `vivado/report_roi_start_detector_resources.tcl` on a
working Vivado installation before quoting final timing or placed utilization.

The earlier detector mapped to 2,347 LUT primitives, 994 flip-flops, and 264
`CARRY4` blocks. Removing redundant anchor-distance calculations and unused
corner-scoring state saved 232 LUT primitives (about 9.9%), 82 flip-flops, and
40 `CARRY4` blocks while improving the measured corner geometry.

| Item | V1 RTL behavior |
| --- | --- |
| Throughput | One input pixel every `pclk` cycle. |
| Output time | At the end of the camera frame; this is the earliest possible time for a full-frame ROI decision. |
| Frame storage | None. |
| BRAM | None. |
| DSP multipliers | None. |
| Division | None. |
| Main logic | Threshold comparator, run-length counters, diagonal extrema registers, local-window comparisons, prior-corner registers, bright-pixel counter, and state logic. |

More FPGA arithmetic cannot make a one-pixel-per-clock DVP camera deliver a completed full-frame ROI before the final pixel arrives. To reduce end-to-end latency, Camera 1 should use a lower resolution or higher frame/pixel clock, for example `320 x 240` grayscale when its ROI accuracy is sufficient.

## Vivado Test

The standalone testbench covers START acquisition, local-corner DATA update,
hold on an implausible outlier, full-off stop, idle DATA ignore, START
reacquisition, and a slanted START quadrilateral.

Expected result:

```text
Result: ROI PROTOCOL TRACKER PASS
Result: ANGLED START CORNER PASS
```

To run it in Vivado, set simulation top to `roi_start_detector_tb`, then select **Run Simulation -> Run Behavioral Simulation**. The project-creation Tcl includes both the RTL and testbench files for a newly created project.

## Top-Level Integration

`rtl/cubeocc_top.sv` instantiates `u_roi_tracker` beside `dvp_to_axis`. It exposes `roi_valid`, `roi_tracking_active`, the Camera 2 axis-aligned ROI box, and four tracked corners. The tracker uses the same raw DVP input as the existing HLS stream, so it synthesizes as part of the FPGA top.

The threshold and size constants in `cubeocc_top` are V1 test defaults. Mapping the tracked Camera 1 rectangle to Camera 2 sensor registers and issuing the I2C writes remains the next integration task.

For the paper citation ledger and the precise boundary between the offline Python GUIs, the monitor-based sender experiment, and a future live FPGA control GUI, see [[15_06_SOURCES_AND_FPGA_UI]].

## Limits

This V1 detector outputs an enclosing rectangular sensor crop. It does not
warp pixels, and strong glare, severe blur, or very large motion between frames
can still defeat its thresholded local markers. The actual RTL `true`, `mid`,
and `false` labels from [[15_07_XSIM_RTL_ROI_REVIEW]] determine whether this
low-resource baseline is sufficient before adding a more advanced mode.
