---
project: CubeOCC
type: pipeline
status: draft
last_reviewed: 2026-08-22
---
# FPGA Processing Pipeline

```mermaid
flowchart TD
CAM[RGB camera-like pixel stream] --> ROI[ROI crop/gate]
ROI --> BUF[Frame/ROI buffer banks]
BUF --> SCH[Scheduler]
SCH --> W1[Worker 1]
SCH --> W2[Worker 2]
SCH --> W3[Worker 3]
W1 --> IP[Denoise + glare handling + geometry/warp]
W2 --> IP
W3 --> IP
IP --> GRID[Configurable grid partition]
GRID --> SMP[Cell-center radius RGB averaging]
SMP --> CLS[8-state RGB classifier]
CLS --> LINK[START/DATA/END decoder]
LINK --> BITS[177 coded bits in 8×8 DATA]
BITS --> ECC[ECC decode]
ECC --> OUT[Recovered payload + metrics]
```

## Suggested buffer bank lifecycle
`FREE -> FILLING -> READY -> PROCESSING -> FREE`

Scheduler checks:
1. which worker is idle,
2. which image/ROI is READY,
3. which bank should be assigned,
4. when a bank can be freed.

## Processing options
### Denoise
- no-filter baseline
- 3×3 median
- small Gaussian
- bilateral-like approximation

### Glare/lighting
- reject saturated pixels
- local/white-marker normalization
- per-channel gain correction
- advanced restoration only as stretch work

### Geometry
- full homography warp
- direct marker-derived cell coordinates without full-frame warp
- LUT/precomputed mapping

### Classification
- Euclidean RGB distance to 8 ideal cube corners
- normalized RGB distance
- calibrated per-channel thresholding

## Parallelism choices
- **A: one streaming pipeline** — easiest MVP.
- **B: three full workers** — closest to original idea but costly.
- **C: hybrid replicated bottleneck blocks** — compromise.
