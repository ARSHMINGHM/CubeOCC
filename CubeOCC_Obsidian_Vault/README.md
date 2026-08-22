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
- all 8 RGB symbols legal in DATA.
- CLK position configurable.
- sequence number optional/V2.
- Camera 1 ~60 FPS tracking; Camera 2 ~30 FPS RGB example.
- Camera 1 gives ROI/brightness/confidence; glare correction removed.
- four-point Camera 1 -> Camera 2 mapping established at START.
- Camera 2 uses sensor-level ROI windowing.
- testbench emulates sensor registers and pixel stream.
- V1 uses one streaming pipeline and avoids full raw-frame storage.
- scalable N-worker architecture is optional after benchmarking.
- sampling radius is an experimental parameter with visualization.
- V1 classifier = RGB thresholds; normalized RGB = V2.
- ECC note contains multiple Hamming and BCH candidate tables.
