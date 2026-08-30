# CubeOCC Sender Bitstream Generator

`cubeocc_sender_gui.py` creates sender-side bitstreams from either typed text or a file.

It generates one output for each mode documented in `CubeOCC_Obsidian_Vault/07_ECC_AND_METRICS.md`:

- `no_ecc`
- `hamming_7_4`
- `hamming_15_11`
- `hamming_31_26`
- `extended_hamming_8_4`
- `extended_hamming_16_11`
- `extended_hamming_32_26`
- `bch_15_7_5`
- `bch_15_5_7`
- `bch_31_21_5`
- `bch_31_16_7`
- `bch_31_11_11`

## GUI

```powershell
cd C:\Users\arshm\Desktop\CubeOCC
python sender\cubeocc_sender_gui.py --gui
```

Use either:

- typed text in the text box
- `Choose File`
- drag and drop, if `tkinterdnd2` is installed

The default output folder is:

```text
sim/sender_bitstreams/
```

For large files, keep the GUI defaults:

- ECC modes: `v1`
- Output format: `bin`

That generates only `no_ecc` and `hamming_15_11`, which matches the V1 baseline direction and avoids every expensive BCH candidate unless you actually need the full ECC comparison.

## CLI Test

```powershell
cd C:\Users\arshm\Desktop\CubeOCC
python sender\cubeocc_sender_gui.py --text "hello cubeocc" sim\sender_bitstreams --modes v1 --format bin
```

For a file:

```powershell
python sender\cubeocc_sender_gui.py --file input.txt sim\sender_bitstreams --modes v1 --format bin
```

Each ECC mode writes:

- `.bin` file: packed encoded bits, fastest and smallest
- `.bits` file: encoded bitstream text when `--format bits` is selected
- `.json` file: metadata, including input bits, output bits, padding bits, and codeword count

Each generation also writes one manifest:

```text
<input>_<timestamp>_manifest.json
```

## Notes

- Text input is encoded as UTF-8 bytes, then converted MSB-first to bits.
- File input is read as raw bytes.
- Default CLI/GUI behavior uses `--modes v1 --format bin`.
- `--modes all --format bits` is the slowest option and creates very large files.
- Hamming and Extended Hamming are implemented directly.
- BCH modes are narrow-sense primitive binary BCH encoders for the candidate codes in the Obsidian ECC note.

## Mode Selection

```powershell
--modes no_ecc
--modes v1
--modes fast
--modes hamming
--modes bch
--modes all
--modes hamming_15_11,bch_15_7_5
```

Recommended for a large file such as 12 MB:

```powershell
python sender\cubeocc_sender_gui.py --file big_input.bin sim\sender_bitstreams --modes v1 --format bin
```

Fast comparison set, still bigger than V1:

```powershell
python sender\cubeocc_sender_gui.py --file big_input.bin sim\sender_bitstreams --modes fast --format bin
```

Full comparison, much slower:

```powershell
python sender\cubeocc_sender_gui.py --file big_input.bin sim\sender_bitstreams --modes all --format bin
```

## Map Bitstreams To V1 Frames

After generating a `.bin` bitstream, map it into logical optical frames:

```powershell
python sender\cubeocc_frame_mapper.py --bitstream sim\sender_bitstreams\<generated>_hamming_15_11.bin --out sim\sender_frames
```

The mapper follows `CubeOCC_Obsidian_Vault/03_FRAME_AND_LINK_PROTOCOL.md`:

- START frame: all 64 cells white/on
- DATA frames: four white corners, one toggling CLK cell, 59 grayscale payload cells
- END frame: TL/TR/BL white, BR off, CLK off, payload cells off

It writes:

- `<generated>_<mapping>_frames.jsonl`
- `<generated>_<mapping>_frames_manifest.json`

Open the mapper GUI:

```powershell
python sender\cubeocc_frame_mapper.py --gui
```

GUI workflow:

1. Choose `One bitstream file` or `Whole folder batch`.
2. Browse to the `.bin` file, or browse to the folder with many `.bin` / `.json` pairs.
3. Choose the output folder.
4. Add mappings with the preset buttons:
   - `V1 8x8 Grayscale`
   - `RGB + CLK + Seq`
   - `16x16 Seq`
5. Or change the custom settings and click `Add Current Settings`.
6. Use `preview` image mode first. Use `all` only when you want every frame as PNG.
7. Click `Generate Frames`.

The custom settings can choose:

- grid rows and columns
- CLK cell position
- grayscale or RGB cell symbols
- CLK-only sync, sequence-number sync, or both
- sequence-number bit width

Experimental RGB plus sequence example:

```powershell
python sender\cubeocc_frame_mapper.py --bitstream sim\sender_bitstreams\<generated>_hamming_15_11.bin --out sim\sender_frames --symbol-mode rgb --sync-mode clk_sequence --sequence-bits 8
```

Batch-map every `.bin` / `.json` pair in a folder:

```powershell
python sender\cubeocc_frame_mapper.py --input-dir sim\sender_bitstreams --out sim\sender_frames_batch --presets "8x8:grayscale:clk:0;8x8:rgb:clk_sequence:8;16x16:grayscale:sequence:8" --image-mode preview
```

Each preset gets its own output folder:

```text
sim/sender_frames_batch/
  8x8_grayscale_clk/
  8x8_rgb_clk_sequence_seq8/
  16x16_grayscale_sequence_seq8/
```

Image modes:

- `--image-mode none`: JSONL and manifests only
- `--image-mode preview`: START/END plus a few DATA frame PNGs
- `--image-mode all`: every frame as PNG images

For big files, start with `preview`. Use `all` only when you really want all mapped images.

## Preview Mapped Frame Images

After mapping with `--image-mode preview` or `--image-mode all`, open the frame player:

```powershell
python sender\cubeocc_frame_player.py
```

Choose the generated `*_images` folder, then click `Run Fullscreen`.

Playback options:

- `30` FPS
- `60` FPS
- custom FPS
- manual keystroke mode
- separate START and END hold times in milliseconds

Fullscreen controls:

- `Esc`: stop and close fullscreen
- `Space`, `Right`, or `Enter`: next frame in manual mode
- `Left`: previous frame in manual mode
