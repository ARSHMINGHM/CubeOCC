---
project: CubeOCC
type: testbench
status: v1-active
last_reviewed: 2026-08-26
---

# Simulation Camera Model

## Goal

The FPGA code should interact with the testbench as if the testbench were an actual camera sensor.
Long-term goal: replace the simulated camera with a real physical camera without redesigning the core FPGA receiver.

## Current Status

- **DVP Model:** Active and passing regression tests. Included in V1 simulation.
- **MIPI Model:** Active and passing regression tests. Included in V1 simulation so DVP and MIPI can be compared before choosing the physical camera path.
- Both models simulate OV5640 behavior, including 16-bit SCCB register addresses (e.g., `0x3800` for HSTART) and true hardware ROI windowing (FPS increases as window shrinks).
- The project uses a protocol-first camera strategy: V1 models both generic DVP behavior and MIPI-style behavior rather than locking to one physical sensor.
- After camera research and ROI/windowing comparison, one physical camera path may be selected and the other path may be dropped.
- ROI/windowing is primarily a sensor/register capability, not only a DVP-vs-MIPI transport feature. The selected physical camera must support the required ROI behavior regardless of which pixel transport is used.

## Dual Camera Simulation Strategy

The CubeOCC architecture uses two cameras (Camera 1 for grayscale tracking, Camera 2 for data recovery). In the simulation environment, both cameras use the exact same `dvp_camera_model` module. There is no need to write a separate module for Camera 1. The distinction is handled by the testbench parameters:

- **Camera 1 (Tracking / ROI camera):** Driven at a higher frame rate (~60 FPS target). It receives the full scene at lower resolution and grayscale. Its job is to find the four corner markers and provide ROI/window feedback for Camera 2.
- **Camera 2 (Data camera):** Driven at a lower frame rate (~30 FPS target). It receives ROI/window settings from the FPGA and should output only the selected data pixels. V1 starts with grayscale data-camera processing; V1.5 upgrades Camera 2 data symbols to RGB.

## Architecture & Philosophy

The camera models are **Behavioral SystemVerilog Testbenches**. They are not synthesizable and do not consume FPGA resources (LUTs/FFs/BRAMs). They run purely in the computer's memory (XSim) to emulate a physical OV5640 sensor. This allows FPGA RTL code to be developed and debugged before physical hardware is available.

## DVP Camera Interface Contract (For FPGA RTL)

When writing the FPGA-side RTL (I2C Master & DVP-to-AXIS), it must connect to these conceptual interfaces:

### 1. Control Bus (SCCB / I2C)

The FPGA I2C Master will write to 16-bit addresses to configure the sensor.

- `REG_STREAM_ENABLE` (`0x3008`): Turns pixel streaming on/off.
- `REG_ROI_HSTART` (`0x3800`): Horizontal start coordinate.
- `REG_ROI_VSTART` (`0x3802`): Vertical start coordinate.
- `REG_ROI_HSIZE` (`0x3804`): ROI Width.
- `REG_ROI_VSIZE` (`0x3806`): ROI Height.

### 2. Pixel Data Stream (DVP)

The DVP-to-AXI4-Stream module will read these signals from the camera:

- `pclk`: Pixel clock (driven by camera).
- `vsync`: Frame start/active (Active Low during frame, High during blanking).
- `href`: Horizontal reference (Active High when pixel data is valid).
- `pixel_data [7:0]`: 8-bit pixel value.
- `sof`: Start of frame marker (convenience signal for simulation).

## Sensor-level crop simulation

Correct conceptual flow:

```text
full source image in testbench
  -> simulated sensor register window
  -> only cropped ROI appears on Camera 2 pixel bus
  -> FPGA receives cropped stream
```

_(Not: FPGA receives full image -> FPGA crops it)_

## Testing & Image Loading Mechanism

### Current State (updated 2026-08-26)

The testbench uses a mathematical test pattern (**`test_pixel(row, col)`**) by default to verify timing, ROI boundaries, and FPS behavior.

**Real-image loading is now implemented** in `camera_sim/dvp_camera_model.sv`:

1. **Image to Memory File:** `camera_sim/image_to_mem.py` converts a photo into an 8-bit grayscale hex file (one pixel per line, row-major):
   ```bash
   python camera_sim/image_to_mem.py led_grid.jpg sim_image.mem 128 720
   ```
   (requires `pip install Pillow`; the width/height arguments resize the image)
2. **Testbench Loading:** the camera model loads it at time 0 via **`$readmemh`**. Instantiate the model with:
   ```systemverilog
   dvp_camera_model #(
     .IMAGE_FILE  ("sim_image.mem"),
     .IMAGE_WIDTH (128),
     .IMAGE_HEIGHT(720)
   ) cam ( ... );
   ```
3. **ROI Streaming:** when the FPGA configures the ROI registers, the camera model reads only the corresponding pixels from the image memory and outputs them on the DVP interface. Without `IMAGE_FILE`, the model falls back to the math test pattern.

### Folder-Based Image Dataset Plan

The next simulation direction is to feed the FPGA with real or generated CubeOCC frame images from a folder instead of relying only on random/math pixel values.

Planned flow:

```text
image folder
  -> convert each image to .mem
  -> testbench selects one or more .mem frames
  -> dvp_camera_model streams the image pixels like a camera sensor
  -> FPGA DUT receives the image through DVP/AXI as if it came from hardware
```

This keeps the simulation closer to the physical system: the FPGA sees camera-style `pclk`, `vsync`, `href`, and `pixel_data`, while the source content comes from actual image files. The math pattern remains useful for timing/regression tests, but CubeOCC protocol testing should increasingly use folder-based images of LED/grid frames.

Target folder convention:

```text
sim/image_inputs/       # source PNG/JPG frames
sim/image_mem/          # generated .mem files
sim/image_test/         # xsim output and temporary run files
```

The first V1 image tests may use grayscale `.mem` files. Later tests should extend this to RGB/channel-aware input when the receiver pipeline needs color classification.

```mermaid
sequenceDiagram
    participant TB as Testbench
    participant C1 as Camera 1 model
    participant C2 as Camera 2 model
    participant DUT as FPGA DUT

    TB->>DUT: simulated button press
    TB->>C1: START image
    TB->>C2: START image
    C1->>DUT: grayscale stream
    C2->>DUT: RGB startup stream
    DUT->>DUT: detect both four-corner sets
    DUT->>DUT: calculate C1-to-C2 mapping
    DUT->>C2: write ROI/window registers
    C2->>DUT: cropped RGB ROI stream
```

## Dataset conditions (For V1/V2 Testing)

Dataset labeling task note:

- [[15_01_MONITOR_CAPTURE_DATASET_LABELING]]

- source image folder / dataset id
- distance
- viewing angle
- brightness
- glare/reflection
- blur
- exposure
- screen brightness
- grid size
- capture FPS
- optical frame rate

Glare is included as a condition, not a correction feature.

## Faults to simulate (For V1/V2 Testing)

- repeated captures of same CLK
- new optical frame / CLK toggle
- skipped optical frame
- bad marker confidence
- mapping error
- wrong ROI
- low brightness
- blur
- glare as impairment
- START
- END
- all 8 legal RGB DATA symbols

## System Integration Flow

```mermaid
flowchart LR
    subgraph Testbench_Domain["Testbench Domain"]
        IMG[Image File .mem] --> CAM[DVP Camera Model]
    end

    subgraph FPGA_Domain["FPGA Domain (DUT)"]
        I2C[I2C Master] -->|SCCB| CAM
        CAM -->|pclk, href, vsync| D2A[DVP to AXI-Stream]
        D2A -->|AXI4-Stream| HLS[HLS Pixel Pipeline]
    end
```

## Regression Test Results (2026-08-23)

| **Case**   | **Resolution** | **DVP FPS** | **MIPI FPS** | **Status** |
| ---------- | -------------- | ----------- | ------------ | ---------- |
| A (Full)   | 2592x1944      | 16          | 78           | PASS       |
| B (Half)   | 2592x972       | 31          | 156          | PASS       |
| C (Narrow) | 128x720        | 168         | 3343         | PASS       |

## Regression Update (2026-08-26) — Top-Level Integration

| **Case** | **Chain** | **Check** | **Status** |
| -------- | --------- | --------- | ---------- |
| `cubeocc_top_tb` | DVP model → dvp_to_axis → cubeocc_hls_0 → AXIS | 92,160 pixels (128x720) **and** 720 lines (tlast) | PASS |

- Fixed a simulation race: the DVP model used to drive `href`/`pixel_data` with blocking assigns concurrent to `posedge pclk`, which could suppress `m_axis_tlast` (end-of-line) in `dvp_to_axis`. Outputs are now driven on `negedge pclk`.
- **Driving convention:** all camera models must drive DVP outputs on `negedge pclk` (see Decision Log 2026-08-26). The MIPI model must be audited for the same pattern before V2 use.
