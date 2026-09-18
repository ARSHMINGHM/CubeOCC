---
project: CubeOCC
type: camera
status: confirmed-draft
last_reviewed: 2026-09-19
---

# Camera ROI and Calibration

## Camera 1 — tracking/feedback

Target example: ~60 FPS.

Camera 1 is the ROI/tracking camera. It receives the full scene at lower resolution and in grayscale. It is not the main data camera.

Outputs:

- current four marker coordinates
- ROI geometry
- mapping to Camera 2 coordinates
- simple average brightness
- tracking/marker confidence
- processing-control metadata

Does **not** perform V1 glare detection.

## Camera 2 — DATA camera

Target example: ~30 FPS.

Camera 2 is the data camera. It receives ROI/window coordinates derived from Camera 1 tracking and should output only the selected ROI pixels.

- receives ROI/window coordinates
- uses sensor-level crop/windowing
- outputs only the cropped ROI pixel stream to the FPGA
- V1 uses grayscale data-camera processing
- V1.5 upgrades Camera 2 data symbols to RGB

## Confirmed ROI Rule

Cropping for Camera 2 must happen on the camera/sensor side, not inside the FPGA after receiving a full frame.

Required flow:

```text
Camera 1 captures full low-resolution grayscale scene
  -> FPGA finds a V1 axis-aligned START-frame ROI window
  -> FPGA computes Camera 2 ROI/window
  -> FPGA writes ROI/window registers to Camera 2
  -> Camera 2 sensor applies ROI
  -> Camera 2 outputs only selected data pixels
  -> FPGA receives cropped stream
```

The FPGA should not be designed around receiving the full Camera 2 frame and cropping it internally for V1.

V1 detector implementation: [[15_05_FPGA_START_ROI_DETECTOR]]. It uses a grayscale threshold and bright-run bands to produce four corner points and an enclosing Camera 2 `x`, `y`, `width`, and `height` without frame storage. The sensor crop remains axis-aligned; the implemented FPGA four-point rectifier is documented in [[15_08_FPGA_CAMERA2_GRAYSCALE_GRID_REVIEW]].

V1 starts with grayscale data-camera processing to prove the pipeline. V1.5 upgrades Camera 2 data symbols to RGB.

Camera 2 FPGA implementation and grayscale 8x8 review: [[15_08_FPGA_CAMERA2_GRAYSCALE_GRID_REVIEW]].

## Current RTL status

Simulation now has a direct FPGA path from Camera 1 pixels through ROI detection, four-corner projective rectification, and 8x8 grayscale grid tagging. The Camera 2 ROI programmer also generates the expected `HSTART`, `VSTART`, `HSIZE`, `VSIZE`, and stream-enable register transactions in its testbench.

Still open before physical Camera 2 use:

- calibrate Camera 1 coordinates into Camera 2 sensor coordinates;
- connect the ROI programmer command interface to `i2c_master.sv`;
- replace the generic register assumptions with the selected sensor's real register map and timing;
- verify that the chosen sensor applies ROI/windowing and emits only the requested pixels.

## Startup mapping

At START, both cameras see the same known optical object.

```text
C1_TL <-> C2_TL
C1_TR <-> C2_TR
C1_BL <-> C2_BL
C1_BR <-> C2_BR
```

Store a four-point relationship.

Simple first implementation:

- compare corresponding coordinates
- derive per-corner offset/relationship
- interpolate/predict Camera 2 ROI from current Camera 1 marker geometry

More formal implementation if needed:

- compute a 2D projective transform/homography from the four correspondences

## Every-frame tracking

Camera 1 continues to detect current marker geometry. That current geometry feeds:

1. Camera 2 sensor-window coordinates
2. image warp/geometric correction
3. frame confidence
4. simple brightness feedback

## Mapping residual

If predicted and observed coordinates disagree significantly:

- report high geometric residual / poor calibration confidence
- do not call it “fisheye detected” unless a lens-distortion model is actually implemented

## Brightness

Simple V1 metric: average grayscale intensity over the selected tracking region or marker-related region.

## Glare

V1 decision: **no glare detection or compensation**.

Reason: white is itself a valid symbol, so saturated/white DATA regions can be ambiguous with glare.

Instead:

- label glare conditions in the dataset
- measure BER/SER impact
- document mitigation as future work
