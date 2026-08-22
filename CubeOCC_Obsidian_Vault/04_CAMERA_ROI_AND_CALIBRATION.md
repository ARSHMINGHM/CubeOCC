---
project: CubeOCC
type: camera
status: confirmed-draft
last_reviewed: 2026-08-22
---

# Camera ROI and Calibration

## Camera 1 — tracking/feedback

Target example: ~60 FPS.

Outputs:

- current four marker coordinates
- ROI geometry
- mapping to Camera 2 coordinates
- simple average brightness
- tracking/marker confidence
- processing-control metadata

Does **not** perform V1 glare detection.

## Camera 2 — RGB DATA camera

Target example: ~30 FPS.

- receives ROI/window coordinates
- uses sensor-level crop/windowing
- outputs only the cropped RGB ROI pixel stream to the FPGA

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
