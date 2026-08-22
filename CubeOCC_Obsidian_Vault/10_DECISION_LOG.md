---
project: CubeOCC
type: decisions
status: active
last_reviewed: 2026-08-22
---
# Decision Log

## 2026-08-20 — Initial concept captured
- Two-camera OCC receiver.
- Grayscale tracking/feedback camera and RGB data camera.
- FIFO-like retained frames and multi-worker processing concept.
- Denoise, glare handling, warp, grid extraction, RGB cube classification.
- Hamming/BCH comparison.
- Simulation-first camera-like testbench with labeled images and CSV/TXT metrics.

## 2026-08-20 — 8×8 framing added
- 64 total cells.
- 4 markers + 1 CLK + 59 payload/ECC cells.
- START/END control frames.
- Button-triggered transfer simulated in testbench.

## 2026-08-20 — END frame corrected
**Confirmed and supersedes older visuals:** TL/TR/BL white, BR off, CLK off, all ordinary cells black/off.

## 2026-08-22 — Obsidian source-of-truth vault created
Purpose: make misunderstandings, assumptions, and future changes easy to audit.

---
## Template
### YYYY-MM-DD — Decision title
**Status:** proposed / confirmed / rejected / superseded  
**Decision:** ...  
**Reason:** ...  
**Affected notes/code:** ...
