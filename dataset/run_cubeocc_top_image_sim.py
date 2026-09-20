#!/usr/bin/env python3
"""Run the full cubeocc_top (ROI + warp + grid + dynamic_threshold_sampler)
against real captured images and build a visual review manifest.

Mirrors run_roi_warp_grid_rtl_sim.py's frame_list.txt / capture-set-boundary
convention so it can be pointed at the same camera_gray folders.
"""

from __future__ import annotations

import argparse
import csv
import json
import os
import shutil
import subprocess
import sys
from pathlib import Path

from PIL import Image, ImageDraw


WIDTH = 160
HEIGHT = 120
PIXELS = WIDTH * HEIGHT
IMAGE_SUFFIXES = {".png", ".jpg", ".jpeg", ".bmp", ".tif", ".tiff"}
DEFAULT_INPUT = Path("sim/roi_rtl_all_v11_independent_edges/camera_gray")
DEFAULT_OUTPUT = Path("sim/cubeocc_top_image_results")
DEFAULT_VIVADO_BIN = Path(os.environ.get("VIVADO_BIN", "X:/xilinx/Vivado/2019.1/bin"))

CELL_W = WIDTH // 8
CELL_H = HEIGHT // 8


def executable(vivado_bin: Path, name: str) -> Path:
    for candidate in (vivado_bin / f"{name}.bat", vivado_bin / name):
        if candidate.is_file():
            return candidate
    raise FileNotFoundError(f"Vivado tool not found: {vivado_bin / (name + '.bat')}")


def run(command: list[str], cwd: Path) -> None:
    print("+", subprocess.list2cmdline(command))
    completed = subprocess.run(command, cwd=cwd, text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    (cwd / f"{Path(command[0]).stem}.log").write_text(completed.stdout, encoding="utf-8", errors="replace")
    if completed.returncode:
        print(completed.stdout, file=sys.stderr)
        raise RuntimeError(f"command failed ({completed.returncode}): {command[0]}")


def prepare_output(output: Path) -> None:
    if output.exists():
        if not (output / "results.json").is_file():
            raise ValueError(f"refusing to clear unknown folder: {output}")
        shutil.rmtree(output)
    output.mkdir(parents=True)


def images_in(input_dir: Path) -> list[Path]:
    return sorted(p for p in input_dir.rglob("*") if p.is_file() and p.suffix.lower() in IMAGE_SUFFIXES)


def write_mem(image: Image.Image, path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("".join(f"{v:02x}\n" for v in image.get_flattened_data()), encoding="ascii")


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(newline="", encoding="ascii") as handle:
        return list(csv.DictReader(handle))


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--input-dir", type=Path, default=DEFAULT_INPUT)
    parser.add_argument("--out", type=Path, default=DEFAULT_OUTPUT)
    parser.add_argument("--limit", type=int, default=0, help="Optional frame limit; zero means all frames.")
    parser.add_argument("--capture-set", action="append", default=[],
                         help="Only run a named capture-set folder; repeat for multiple sets.")
    parser.add_argument("--vivado-bin", type=Path, default=DEFAULT_VIVADO_BIN)
    args = parser.parse_args()

    root = Path(__file__).resolve().parents[1]
    input_dir = args.input_dir.resolve()
    output = args.out.resolve()
    try:
        if not input_dir.is_dir():
            raise ValueError(f"input folder does not exist: {input_dir}")
        source_paths = images_in(input_dir)
        if args.capture_set:
            selected = set(args.capture_set)
            source_paths = [p for p in source_paths if p.relative_to(input_dir).parts[0] in selected]
        if args.limit > 0:
            source_paths = source_paths[: args.limit]
        if not source_paths:
            raise ValueError(f"no camera images found in {input_dir}")
        prepare_output(output)

        mem_dir = output / "mem"
        frame_list: list[str] = []
        sources: list[dict[str, object]] = []
        previous_set = ""
        for index, source_path in enumerate(source_paths):
            relative = source_path.relative_to(input_dir)
            capture_set = relative.parts[0] if len(relative.parts) > 1 else "root"
            if previous_set and capture_set != previous_set:
                frame_list.append("---")
            previous_set = capture_set
            mem_path = mem_dir / relative.with_suffix(".mem")
            with Image.open(source_path) as source:
                gray = source.convert("L")
                if gray.size != (WIDTH, HEIGHT):
                    raise ValueError(f"expected 160x120 camera raster, got {gray.size}: {source_path}")
                write_mem(gray, mem_path)
            frame_list.append(mem_path.resolve().as_posix())
            sources.append({
                "frame": index,
                "relative_path": relative.as_posix(),
                "capture_set": capture_set,
                "source_path": str(source_path),
            })

        build = output / "xsim_build"
        build.mkdir()
        (build / "frame_list.txt").write_text("\n".join(frame_list) + "\n", encoding="ascii")
        run([
            str(executable(args.vivado_bin, "xvlog")), "-sv",
            str(root / "rtl" / "roi_start_detector.sv"),
            str(root / "rtl" / "projective_warp_160x120.sv"),
            str(root / "rtl" / "grayscale_grid_8x8.sv"),
            str(root / "rtl" / "roi_warp_grid_pipeline.sv"),
            str(root / "rtl" / "dynamic_threshold_sampler.sv"),
            str(root / "rtl" / "cubeocc_top.sv"),
            str(root / "tb" / "cubeocc_top_image_tb.sv"),
        ], build)
        run([str(executable(args.vivado_bin, "xelab")), "cubeocc_top_image_tb", "-s", "cubeocc_top_image_tb"], build)
        run([str(executable(args.vivado_bin, "xsim")), "-runall", "cubeocc_top_image_tb"], build)

        frame_rows = read_csv(build / "pipeline_frames.csv")
        symbol_rows = read_csv(build / "symbols_results.csv")
        symbols_by_frame = {int(row["frame"]): row for row in symbol_rows}
        if len(frame_rows) != len(sources):
            raise RuntimeError(f"XSim emitted {len(frame_rows)} frame rows; expected {len(sources)}")

        camera_dir = output / "camera_gray"
        camera_dir.mkdir()
        warped_file = (build / "warped_pixels.hex").open(encoding="ascii")
        records: list[dict[str, object]] = []
        rejected: list[dict[str, object]] = []
        for source, frame_row in zip(sources, frame_rows):
            roi_valid = frame_row["roi_valid"] == "1"
            base = {
                **source,
                "roi_valid": roi_valid,
                "tracking_active": frame_row["tracking_active"] == "1",
                "roi_box": {
                    "x": int(frame_row["roi_x"]), "y": int(frame_row["roi_y"]),
                    "width": int(frame_row["roi_width"]), "height": int(frame_row["roi_height"]),
                } if roi_valid else None,
            }
            if not roi_valid:
                rejected.append(base)
                continue
            symbol_row = symbols_by_frame.get(int(source["frame"]))
            if symbol_row is None:
                raise RuntimeError(f"no symbol result for valid-ROI frame {source['relative_path']}")
            values = []
            for _ in range(PIXELS):
                pixel_line = warped_file.readline()
                if not pixel_line:
                    raise RuntimeError(f"RTL warped stream ended early at {source['relative_path']}")
                values.append(int(pixel_line.strip(), 16))
            warped = Image.new("L", (WIDTH, HEIGHT)); warped.putdata(values)
            camera_gray_path = camera_dir / Path(str(source["relative_path"])).with_suffix(".png")
            camera_gray_path.parent.mkdir(parents=True, exist_ok=True)
            warped.save(camera_gray_path)

            bits = symbol_row["symbols_data_binary"].zfill(64)  # MSB..LSB, bit i = cell i
            records.append({
                **base,
                "camera_gray_path": camera_gray_path.relative_to(output).as_posix(),
                "sampler_state": int(symbol_row["sampler_state"]),
                "dynamic_thresh": int(symbol_row["dynamic_thresh"]),
                "symbols_bits": bits,
            })
        if warped_file.readline():
            raise RuntimeError("RTL emitted more warped pixels than expected")
        warped_file.close()

        if not records:
            raise RuntimeError("no valid-ROI frames were produced — check ROI detector lock before debugging the sampler")

        # One quick-look preview (same spirit as run_roi_warp_grid_rtl_sim.py's
        # grid_preview.png) — the real per-frame review happens in the browser
        # tool (serve_symbols_review.py), which draws the overlay live from
        # results.json so it can be zoomed and labeled.
        preview_record = max(
            records,
            key=lambda r: sum(1 for b in r["symbols_bits"] if b == "1"),
        )
        with Image.open(output / str(preview_record["camera_gray_path"])) as src:
            preview = src.convert("RGB").resize((WIDTH * 4, HEIGHT * 4), Image.Resampling.NEAREST)
        draw = ImageDraw.Draw(preview)
        bits = preview_record["symbols_bits"]
        for cell in range(64):
            r, c = cell // 8, cell % 8
            bit = bits[63 - cell]  # %b prints MSB..LSB, so bit[cell] is at index (63-cell)
            left, top = c * CELL_W * 4, r * CELL_H * 4
            right, bottom = left + CELL_W * 4 - 1, top + CELL_H * 4 - 1
            color = (60, 220, 90) if bit == "1" else (220, 60, 70)
            draw.rectangle((left, top, right, bottom), outline=color, width=2)
            draw.text((left + 4, top + 2), bit, fill=color)
        preview.save(output / "symbols_preview.png")

        manifest = {
            "format": "cubeocc-top-image-tb-v1",
            "input_dir": str(input_dir),
            "source_frame_count": len(sources),
            "valid_roi_frame_count": len(records),
            "rejected_frame_count": len(rejected),
            "rtl": [
                "rtl/roi_start_detector.sv", "rtl/projective_warp_160x120.sv",
                "rtl/grayscale_grid_8x8.sv", "rtl/roi_warp_grid_pipeline.sv",
                "rtl/dynamic_threshold_sampler.sv", "rtl/cubeocc_top.sv",
            ],
            "testbench": "tb/cubeocc_top_image_tb.sv",
            "simulator": "XSim / Vivado 2019.1",
            "note": "sampler_state on the frame where dynamic_thresh was learned is 1 (LEARNING); later frames in the same reset-block show 2 (PROCESSING) with that frozen threshold.",
            "rejected_frames": rejected,
            "frames": records,
        }
        (output / "results.json").write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
        print(f"Wrote {len(records)} classified frame(s), {len(rejected)} rejected: {output / 'results.json'}")
        print(f"Quick-look preview: {output / 'symbols_preview.png'}")
        print("For per-frame review, run: python dataset/serve_symbols_review.py")
        return 0
    except (FileNotFoundError, OSError, RuntimeError, ValueError) as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())