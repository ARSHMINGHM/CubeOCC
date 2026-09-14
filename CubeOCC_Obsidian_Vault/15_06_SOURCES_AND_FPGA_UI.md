---
project: CubeOCC
type: paper-sources-and-hardware-integration
status: current-v1-boundary
parent: 15_TASK_BACKLOG
---

# Sources And FPGA UI Boundary

Parent task tree:

- [[15_TASK_BACKLOG]]

Related notes:

- [[01_CONFIRMED_REQUIREMENTS]]
- [[03_FRAME_AND_LINK_PROTOCOL]]
- [[07_ECC_AND_METRICS]]
- [[15_04_MANUAL_ROI_CORNER_REVIEW]]
- [[15_05_FPGA_START_ROI_DETECTOR]]

## What Was Actually Used

The V1 START/DATA/full-off ROI tracker, sender tools, monitor-capture workflow, and tests are original CubeOCC project work. They are not copied from an external ROI-detector paper. Cite the repository as the implementation artifact, then describe the algorithm in the paper.

| Artifact | Role in the work | How to cite it |
| --- | --- | --- |
| [[01_CONFIRMED_REQUIREMENTS]] and [[03_FRAME_AND_LINK_PROTOCOL]] | Project-defined optical-frame and link protocol: START, DATA, CLK, and END rules. | Cite the CubeOCC repository/software artifact. |
| `rtl/roi_start_detector.sv` | Synthesizable V1 Camera 1 START/DATA/full-off ROI tracker. | Cite the CubeOCC repository/software artifact. |
| `tb/roi_start_detector_tb.sv` | RTL verification of START acquisition, DATA tracking, prior-ROI hold, full-off stop, idle ignore, and START reacquisition. | Cite the CubeOCC repository/software artifact and Vivado Logic Simulation guide. |
| `dataset/roi_start_detector_model.py` | Offline reference model with the same state flow as the RTL tracker. | Cite the CubeOCC repository/software artifact. |
| `dataset/roi_corner_labeler.py` | Offline GUI for reviewing Camera 1 monitor captures and labeling ROI quality `true`, `mid`, or `false`. | Describe under dataset annotation/reproducibility; normally no separate scholarly citation is needed. |
| `sender/cubeocc_sender_gui.py`, `sender/cubeocc_frame_mapper.py`, `sender/cubeocc_frame_player.py` | V1 bitstream generation, logical-frame/image mapping, and monitor preview. | Cite the CubeOCC repository/software artifact. |
| `captures/MLCAP_*` and `captures/roi_review/roi_review.json` | Your own monitor-capture evaluation data and review labels. | Cite as an author-created experimental dataset, or state its availability in the paper's Data Availability section. |

> [!important]
> Do not present a third-party source as the origin of this V1 detector. The design was made in this project: thresholded bright-pixel runs acquire START; outside diagonal extrema track four DATA corners; implausible candidate movement holds the prior ROI; a full-off frame resets tracking.

## Paper References

Use the following references when they match a claim in the paper. The first is the primary citation for the code and data created in this project. The Vivado documents support claims about synthesis and XSim simulation, not claims that the detector is novel.

```bibtex
@software{cubeocc_software,
  author  = {{CubeOCC Contributors}},
  title   = {CubeOCC: FPGA Optical Camera Communication Software and RTL},
  url     = {https://github.com/ARSHMINGHM/CubeOCC},
  note    = {Project repository, accessed 2026-09-13}
}

@manual{xilinx_ug901_2019_1,
  author       = {{Xilinx, Inc.}},
  title        = {Vivado Design Suite User Guide: Synthesis},
  number       = {UG901},
  edition      = {2019.1},
  year         = {2019},
  organization = {Xilinx, Inc.},
  url          = {https://docs.amd.com/r/en-US/ug901-vivado-synthesis}
}

@manual{xilinx_ug900_2019_1,
  author       = {{Xilinx, Inc.}},
  title        = {Vivado Design Suite User Guide: Logic Simulation},
  number       = {UG900},
  edition      = {2019.1},
  year         = {2019},
  organization = {Xilinx, Inc.},
  url          = {https://docs.amd.com/r/en-US/ug900-vivado-logic-simulation}
}
```

Suggested prose:

```text
The proposed tracker and its software reference model were implemented as part of CubeOCC [cubeocc_software]. RTL functionality was verified with XSim in Vivado 2019.1 [xilinx_ug900_2019_1], and the implementation was synthesized using Vivado 2019.1 [xilinx_ug901_2019_1].
```

## Software Dependencies: Reproducibility, Not Method Citations

The offline Python GUIs use the Python standard library (`tkinter`, `json`, `pathlib`) and Pillow for image loading, resizing, drawing, and display. List their versions in an appendix, environment file, or reproducibility section. They are usually not paper references unless the venue requires software citations.

Do not cite a perspective-warp or machine-learning paper for V1 unless that method is actually implemented and evaluated. V1 uses an axis-aligned sensor ROI, not a perspective warp, Hough transform, neural detector, or SVM classifier.

## UI And FPGA: Current Reality

There are two different user interfaces in the repository.

| Interface | What it does now | Direct physical-FPGA connection? |
| --- | --- | --- |
| Sender GUIs | Generate bitstreams, map them to optical frames/PNG images, and play the frames fullscreen on a monitor. A physical camera connected to the FPGA can observe that monitor. | Indirect optical connection only. The GUI displays the sender output; the FPGA receives it through a camera. |
| RTL ROI review UI | Opens saved Camera 1 images, draws ROI coordinates emitted by XSim, and records `true`/`mid`/`false` labels. | No. It is an offline dataset-review UI. |
| `roi_start_detector` RTL | Runs in FPGA fabric from the Camera 1 DVP stream and produces ROI status, a rectangle, and four corners. | Yes, after it is synthesized, constrained, placed on the board, and given physical Camera 1 DVP pins. |

The current top-level RTL exposes these signals from `cubeocc_top`:

```text
roi_valid, roi_tracking_active
roi_x, roi_y, roi_width, roi_height
roi_tl_x/y, roi_tr_x/y, roi_br_x/y, roi_bl_x/y
```

It does **not** yet contain a UART/USB protocol, AXI-Lite control/status registers, board pin constraints, a Camera 2 ROI-register mapper, or a live desktop GUI connection. Therefore the desktop GUI cannot presently alter FPGA thresholds or read live ROI results.

## Use The Existing UI With A Physical FPGA

### A. Optical sender path available now

1. Run `py sender\\cubeocc_sender_gui.py --gui` to create the `.bin` and JSON bitstream files.
2. Run `py sender\\cubeocc_frame_mapper.py --gui` and map the chosen bitstream into grayscale V1 frame PNGs.
3. Run `py sender\\cubeocc_frame_player.py`, choose the mapped image folder, set 30, 60, or a custom FPS, and select **Run Fullscreen**.
4. Point the physical Camera 1 or Camera 2 at that monitor. The camera, not a USB data path, carries the frames to the FPGA.
5. Program a bitstream containing `cubeocc_top`; use Vivado ILA or an external output/debug interface to observe the ROI signals.

This is the correct first end-to-end experiment: GUI -> monitor -> camera -> FPGA. It tests the real optical link while keeping the sender software separate from the board.

### B. Put The ROI tracker on the board

1. In Vivado, make `cubeocc_top` the synthesis top. The project Tcl already includes `rtl/roi_start_detector.sv`.
2. Add board-specific XDC constraints for the Camera 1 DVP inputs (`pclk`, `vsync`, `href`, and `pixel_data`), reset, and clock. Pin names and I/O voltage cannot be supplied safely until the exact FPGA board and camera module are known.
3. Run synthesis and implementation. Fix all unconstrained-clock and I/O-standard warnings before generating a bitstream.
4. Add an ILA probe for `roi_valid`, `roi_tracking_active`, the ROI rectangle, and the DVP timing. Program the FPGA and compare those values against an image labeled in the offline ROI GUI.
5. Only after Camera 1 results are stable, add a sensor-specific Camera 2 I2C writer that converts the Camera 1 rectangle into Camera 2 register coordinates.

### C. Make A Live Control UI: next implementation

To let a desktop GUI control or read the FPGA directly, add this bridge. It is deliberately not claimed as completed.

```text
Desktop GUI
    <-> USB-UART / serial COM port
    <-> FPGA UART register bridge
    <-> ROI tracker control/status registers
    <-> Camera 2 I2C ROI-register writer
```

Minimum writable registers:

```text
bright_threshold
min_line_run
min_roi_height
full_off_max_pixels
```

Minimum readable registers:

```text
roi_valid, roi_tracking_active
roi_x, roi_y, roi_width, roi_height
four corner coordinates, frame counter, overflow/error flags
```

Start this hardware interface with a simple line-based UART protocol and a serial status window in Python. Use AXI-Lite instead only if the selected board has a processor or an established USB-to-AXI bridge. The Camera 2 I2C register map must be written for the actual purchased sensor; DVP/MIPI pixel transport does not determine that map.

## Evidence Boundary For The Paper

- State as verified now: standalone ROI RTL protocol test passes in XSim; sender/image/ROI-review tools run offline; existing top instantiates the tracker.
- State as future hardware validation: board-level camera pin constraints, ILA capture, live Camera 1 data, Camera 2 I2C ROI writes, and desktop-to-FPGA serial control.
- Do not report real-camera accuracy, resource utilization, maximum FPS, or live GUI control until those measurements are collected on the selected board and camera.
