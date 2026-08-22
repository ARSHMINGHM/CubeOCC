---
project: CubeOCC
type: glossary
status: active
last_reviewed: 2026-08-22
---

# Glossary

## OCC
Optical Camera Communication.

## RGB cube
The 8 binary on/off combinations of R, G and B.

## Marker
White corner cell used for frame geometry during DATA.

## CLK
Reserved optical cell whose state toggles for every newly transmitted DATA frame.

## START
One all-white 64-cell frame in 8×8 mode.

## END
TL/TR/BL white; BR off; CLK off; ordinary cells black.

## ROI
Region of Interest.

## Sensor windowing
Programming camera registers so the camera itself transmits only a selected crop.

## SER
Symbol Error Rate.

## Raw BER
Bit Error Rate before ECC.

## Post-ECC BER
Bit Error Rate after error correction.

## Goodput
Correct useful payload bits per second after protocol/ECC overhead.

## Reorder buffer
Output structure that accepts results from parallel workers and releases them in original frame order.

## SEC
Single Error Correction.

## SECDED
Single Error Correction, Double Error Detection.
