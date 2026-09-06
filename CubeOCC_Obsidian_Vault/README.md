# CubeOCC Obsidian Vault

Open this directory as an Obsidian vault and begin with `00_HOME.md`.

## Authority order

1. `01_CONFIRMED_REQUIREMENTS.md`
2. `12_DECISION_LOG.md`
3. technical notes
4. optional experiments

## Major changes in this revision

- START = one all-white frame.
- END = TL/TR/BL white; BR + CLK + ordinary cells off.
- V1 grayscale symbols first; V1.5 upgrades to all 8 legal RGB DATA symbols.
- CLK position configurable.
- sequence number V2/later if ECC frame budget allows it.
- Camera 1 ~60 FPS tracking; Camera 2 ~30 FPS data-camera example.
- Camera 1 gives ROI/brightness/confidence; glare correction removed.
- four-point Camera 1 -> Camera 2 mapping established at START.
- Camera 2 uses sensor-level ROI windowing.
- testbench emulates sensor registers and pixel stream.
- V1 uses one streaming pipeline and avoids full raw-frame storage.
- scalable N-worker architecture is optional after benchmarking.
- sampling radius is an experimental parameter with visualization.
- V1 classifier = averaging-only grayscale/on-off; V1.5 = RGB thresholds; V2 = offline SVM-calibrated classification.
- ECC note contains multiple Hamming and BCH candidate tables.
- Sender tools now cover bitstream generation, frame mapping, optional PNG image output, and fullscreen sender preview.
- V3 extends grid benchmarks; V4 adds active grid-size detection and possible SCCB compatibility.
