---
project: CubeOCC
type: implementation-and-review
status: active
last_reviewed: 2026-09-18
---

# FPGA Camera 2 Grayscale Grid Review

This is the next V1 stage after [[15_05_FPGA_START_ROI_DETECTOR]] and [[15_07_XSIM_RTL_ROI_REVIEW]]. Camera 1 supplies four detected corners. Camera 2 is programmed to crop at the sensor, then the FPGA divides only that cropped grayscale stream into an 8x8 grid.

## Implemented path

```text
Camera 1 four corners
  -> Camera 1-to-Camera 2 calibration mapping
  -> rtl/camera2_roi_programmer.sv
  -> I2C HSTART, VSTART, HSIZE, VSIZE, stream-enable writes
  -> Camera 2 emits only the selected grayscale ROI bounding box
  -> rtl/perspective_warp_160x120.sv
  -> FPGA four-corner rectification to a regular 160x120 rectangle
  -> rtl/grayscale_grid_8x8.sv
  -> one grayscale pixel and one 8x8 cell tag per clock
  -> XSim grid_results.json
  -> browser review with 1 / 2 / 3 labels
```

The preferred verification path is now directly connected in `rtl/roi_warp_grid_pipeline.sv`. The same XSim snapshot receives a camera frame, computes its four corners with `roi_start_detector`, passes those live FPGA signals to `perspective_warp_160x120`, and sends the resulting pixel stream directly into `grayscale_grid_8x8`. It does not read corners from JSON.

The START detector also includes a conservative fragmented-edge repair. If one detected vertical edge is more than 28 pixels shorter than the opposite edge, its top and bottom Y extent is copied from the reliable edge while its own X positions are retained. This fixes severe reflection/defocus fragmentation without changing ordinary 15-degree and 30-degree perspective cases.

`camera2_roi_programmer.sv` takes four corners already expressed in Camera 2 sensor coordinates. It creates the enclosing axis-aligned sensor window and emits these register transactions:

| Order | Register | Meaning |
|---:|---:|---|
| 1 | `0x3800` | horizontal start |
| 2 | `0x3802` | vertical start |
| 3 | `0x3804` | ROI width |
| 4 | `0x3806` | ROI height |
| 5 | `0x3008` | enable streaming |

> [!important]
> Camera 1 coordinates cannot be copied directly to a physical Camera 2 unless the cameras are aligned. The calibration/mapping stage must convert the four points into Camera 2 sensor coordinates first. The current grid simulation assumes that conversion has already happened.

## FPGA perspective warp

`rtl/perspective_warp_160x120.sv` is the synthesizable warp stage. It:

- captures one 160x120 GRAY8 raster in inferred block RAM;
- accepts the `TL`, `TR`, `BR`, and `BL` points from the FPGA ROI detector;
- walks the left and right quadrilateral edges with Q16 fixed-point accumulators;
- walks between those edges for every output row;
- performs nearest-neighbor source lookup in FPGA block RAM;
- emits a regular 160x120 DVP-style grayscale stream for the grid mapper.

This is a four-corner bilinear quadrilateral rectifier designed for inexpensive FPGA arithmetic. It is not a floating-point Python/OpenCV homography. Python only serializes the real grayscale images into `.mem` files and converts XSim's emitted hex pixels into PNG files for human review; it does not crop or warp the image.

The frame buffer is intentional. A perspective output scan requests source pixels in a non-sequential order, so this implementation stores one low-resolution 160x120 frame. This is an explicit exception to the no-full-raw-frame-buffer V1 baseline, limited to 19,200 grayscale bytes.

## FPGA grid behavior

`rtl/grayscale_grid_8x8.sv` is synthesizable and streaming:

- input is an 8-bit grayscale ROI stream after sensor cropping;
- accepts one pixel every pixel clock;
- emits the original grayscale pixel, `grid_row`, `grid_col`, and `grid_cell`;
- uses phase accumulators instead of division, so ROI sizes not divisible by 8 still map correctly;
- stores no full frame;
- assigns a cell in scan order as `floor(x*8/width)` and `floor(y*8/height)`.

Before the RTL grid mapper, `perspective_warp_160x120` applies nearest-neighbor rectification in `TL`, `TR`, `BR`, `BL` order. The regular output is 160x120, so every 8x8 cell is 20x15 pixels, or 300 pixels. Grayscale averages in the JSON are testbench diagnostics computed from the RTL cell tags. They are not yet the final FPGA circular sampler/classifier.

> [!important]
> The V11 regression feeds the real 160x120 Camera 1 grayscale captures and their FPGA-detected corners into the warp. For a physical Camera 2 sensor crop, rebase the four corners to the crop's local origin and either configure a 160x120 output or parameterize the frame dimensions before connecting the stream to this module.

## Generate RTL results

### Direct connected run

This is the run to use for end-to-end FPGA verification:

```powershell
cd C:\Users\arshm\Desktop\CubeOCC
python dataset\run_roi_warp_grid_rtl_sim.py --out sim\roi_warp_grid_direct_rtl
```

Input pixels come from the real 160x120 grayscale capture set. Python writes those pixels to `.mem`; inside one XSim design the data path is:

```text
camera pixels -> ROI RTL -> live corner signals -> warp RTL -> grid RTL
```

Open `sim\roi_warp_grid_direct_rtl` in the review GUI. Its status panel must show `Mode: direct-connected-rtl` and displays the four corners produced inside that run.

### Saved-corner regression

Use the current Camera 1 ROI detector manifest. The runner reads the same 807 real grayscale camera frames and the four corners emitted by the FPGA ROI detector, writes the pixels to XSim memory files, and lets the FPGA RTL perform both rectification and 8x8 mapping:

```powershell
cd C:\Users\arshm\Desktop\CubeOCC
python dataset\run_grayscale_grid_rtl_sim.py --roi-results sim\roi_rtl_all_v11_independent_edges\rtl_results.json --out sim\grayscale_grid_rtl_results
```

This older command is useful for reproducing a known corner set, but it is not the direct connection.

To make a quick test, add `--limit 20`.

The result folder contains:

- `camera_input_gray/`: unchanged 160x120 real grayscale inputs supplied to XSim;
- `camera_gray/`: 160x120 pixels emitted by the FPGA perspective-warp RTL, converted from hex to PNG without a software warp;
- `mem/`: GRAY8 memory files read by the SystemVerilog testbench;
- `xsim_build/grid_results.csv`: raw cell boundaries and color diagnostics emitted by the testbench;
- `grid_results.json`: GUI manifest with all 64 RTL cells per frame.
- `grid_preview.png`: immediate 4x preview of one DATA frame with the RTL cell boundaries.

## Review and label

```powershell
python dataset\serve_grayscale_grid_review.py
```

In Chrome or Edge:

1. Click **Open XSim result folder**.
2. Choose `sim\grayscale_grid_rtl_results`.
3. Inspect the FPGA-warped image, red 8x8 boundaries, and 64 average-grayscale swatches.
4. Press `1` for correct, `2` for mostly correct, or `3` for wrong.
5. Press `S` to skip.

The GUI writes `grid_review/grid_review.json` inside the selected result folder. Rerunning a review clears the previous review folder and starts a new grading pass.

## Current verified result

On 2026-09-18, the directly connected XSim pipeline processed all 807 frames from `roi_rtl_all_v11_independent_edges/camera_gray`:

- each frame's four corners were calculated and consumed in the same RTL simulation;
- no JSON corner coordinates were supplied to the testbench;
- each four-corner quadrilateral was perspective-rectified before the RTL 8x8 split;
- XSim emitted exactly 19,200 warped pixels per frame;
- all 64 cells were emitted for every frame, for 51,648 verified cells total;
- every one of the 51,648 cells contained exactly 300 pixels;
- the cropped real monitor captures preserved their grayscale black/white cell levels;
- the Camera 2 ROI programmer test emitted the expected four crop writes and stream-enable write.

Vivado 2019.1 out-of-context synthesis for `xc7a35tcpg236-1` also passed:

| RTL unit | Slice LUTs | Slice registers | BRAM | DSP |
|---|---:|---:|---:|---:|
| Direct `roi_warp_grid_pipeline` top | 4,764 | 1,502 | 8 RAMB36 tiles | 0 |
| `perspective_warp_160x120` | 2,608 | 389 | 8 RAMB36 tiles | 0 |
| `grayscale_grid_8x8` | 118 | 86 | 0 | 0 |
| `camera2_roi_programmer` | 282 | 57 | 0 | 0 |

The warp emits one pixel per clock after buffering and adds one setup/gap clock per row. Capture plus warp takes about 38,520 clocks: about 0.385 ms at 100 MHz or 1.605 ms at 24 MHz, before camera blanking. The downstream grid consumes the warp stream at the same rate and does not add another frame-length wait.

The combined resource row is a real out-of-context synthesis of the connected detector, warp, and grid top, not a sum of separate reports.

Resource reports can be regenerated with:

```powershell
$env:CUBEOCC_ROOT='C:/Users/arshm/Desktop/CubeOCC'
X:/xilinx/Vivado/2019.1/bin/vivado.bat -mode batch -source C:/Users/arshm/Desktop/CubeOCC/vivado/report_camera2_pipeline_resources.tcl
```

## Still required for physical Camera 2

- select the physical sensor and confirm its real ROI register sequence;
- implement Camera 1-to-Camera 2 calibration coordinates;
- add the selected physical sensor unpacker and grayscale conversion if the camera does not output grayscale directly;
- connect `camera2_roi_programmer.sv` to `i2c_master.sv` and the selected board pins;
- add the circular center sampler and grayscale on/off classifier after grid-label review.
