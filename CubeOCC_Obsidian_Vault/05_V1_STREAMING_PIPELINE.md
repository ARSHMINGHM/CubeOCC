---
project: CubeOCC
type: architecture
status: v1
last_reviewed: 2026-08-22
---

# V1 Streaming Pipeline

## Core rule

**Do not store full raw RGB frames in V1 unless a specific stage proves it unavoidable.**

```mermaid
flowchart LR
    S[Camera 2 cropped ROI pixel stream] --> D[Denoise or bypass]
    D --> W[Warp / coordinate mapping]
    W --> G[Grid extraction]
    G --> A[Per-cell RGB accumulators]
    A --> M[Per-cell averages]
    M --> T[RGB threshold classifier]
    T --> F[Frame/link decoder]
    F --> E[ECC decoder]
    E --> O[Recovered bitstream]
```

## Storage inside V1

Allowed/expected:

- line buffers needed by small spatial filters
- small warp/LUT state
- grid/cell metadata
- R/G/B accumulators per active cell
- pixel count per cell
- final per-cell average
- classified 3-bit symbol
- ECC/codeword buffers
- packet/reassembly metadata

Avoid:

- complete raw frame in FFs
- multiple complete raw frames just to create parallelism

## Per-cell reduction

For pixels inside the selected sampling region:

```text
sum_R += R
sum_G += G
sum_B += B
count += 1
```

Then:

```text
avg_R = sum_R / count
avg_G = sum_G / count
avg_B = sum_B / count
```

After the cell result is finalized, raw pixels are no longer needed.

## Warp

Because current corner geometry is available every frame, V1 updates the grid mapping every frame.

Possible implementations:

- warp pixel coordinates then grid
- inverse-map output grid positions to input pixels
- directly derive cell boundaries from the quadrilateral without materializing a full rectified frame

## Output ordering

With one V1 pipeline, frames are inherently in order. Therefore no input scheduler, reorder buffer or waiting FIFO is needed unless benchmarking proves otherwise.

---
# RTL Implementation Status (2026-08-24)

The synthesizable FPGA-side RTL modules are now implemented and verified via simulation.

## 1. `rtl/i2c_master.v`

**Function:** SCCB/I2C Master to configure the OV5640 sensor.

**Features:**
- Generates SCL and controls SDA.
- True `inout` SDA pin for reading ACK from the slave.
- Writes to 16-bit OV5640 registers (e.g., `0x3800` for HSTART, `0x3008` for Stream Enable).

**Verification:** Successfully programmed the camera model via the I2C monitor in the testbench.

## 2. `rtl/dvp_to_axis.v`

**Function:** Converts raw DVP camera signals (`pclk`, `href`, `vsync`, `pixel_data`) into a standard AXI4-Stream video interface.

**Resource Usage:** **NO RAM/BRAM used.** Strictly follows the V1 streaming philosophy. It only delays signals by 1 clock cycle to detect edges (`href` falling for `tlast`, `vsync` falling for `tuser`).

**Verification:** End-to-end integration test passed. Exactly **92,160 pixels (128×720 window)** were streamed via AXI4-Stream and captured by the testbench.
