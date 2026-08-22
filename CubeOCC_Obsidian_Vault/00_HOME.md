---
project: CubeOCC
type: hub
status: active
last_reviewed: 2026-08-22
---
# CubeOCC — Project Source of Truth

> [!important]
> This vault separates **confirmed requirements**, **assistant recommendations**, and **open questions** so assumptions cannot silently become requirements.

## Navigation
- [[01_CONFIRMED_REQUIREMENTS]]
- [[02_OPEN_QUESTIONS_AND_AMBIGUITIES]]
- [[03_FRAME_AND_LINK_PROTOCOL]]
- [[04_TWO_CAMERA_FEEDBACK_SYSTEM]]
- [[05_FPGA_PROCESSING_PIPELINE]]
- [[06_SIMULATION_AND_TESTBENCH]]
- [[07_ECC_AND_METRICS]]
- [[08_ARCHITECTURE_RECOMMENDATIONS]]
- [[09_VERIFICATION_CHECKLIST]]
- [[10_DECISION_LOG]]
- [[11_MONTH_PLAN]]

## Whole-system view
```mermaid
flowchart LR
TX[Payload/file] --> ECC[Packet + ECC]
ECC --> RGB[3-bit RGB cube symbols]
RGB --> LED[LED/display grid]
LED --> G[Camera 1 grayscale]
LED --> C[Camera 2 RGB]
G --> TRACK[4-marker ROI/geometry feedback]
TRACK --> C
TRACK --> P[Processing-control feedback]
C --> BUF[Frame/ROI buffers]
BUF --> SCH[Scheduler]
SCH --> W1[Worker 1]
SCH --> W2[Worker 2]
SCH --> W3[Worker 3]
W1 --> IP[Denoise / glare / warp]
W2 --> IP
W3 --> IP
IP --> GRID[Grid extraction]
GRID --> CLS[RGB symbol classifier]
CLS --> LINK[START/DATA/END decoder]
LINK --> DEC[ECC decode]
DEC --> OUT[Recovered bitstream/file + metrics]
```

## Update rule
1. Only put agreed facts in [[01_CONFIRMED_REQUIREMENTS]].
2. Put uncertain items in [[02_OPEN_QUESTIONS_AND_AMBIGUITIES]].
3. Record design changes in [[10_DECISION_LOG]].
4. Re-run [[09_VERIFICATION_CHECKLIST]] after changes.
