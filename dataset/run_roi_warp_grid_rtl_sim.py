#!/usr/bin/env python3
"""Run the directly connected FPGA ROI detector, warp, and 8x8 grid."""

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
DEFAULT_OUTPUT = Path("sim/roi_warp_grid_projective_rtl")
DEFAULT_VIVADO_BIN = Path(os.environ.get("VIVADO_BIN", "X:/xilinx/Vivado/2019.1/bin"))


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
        if not (output / "grid_results.json").is_file():
            raise ValueError(f"refusing to clear unknown folder: {output}")
        shutil.rmtree(output)
    output.mkdir(parents=True)


def images_in(input_dir: Path) -> list[Path]:
    return sorted(path for path in input_dir.rglob("*") if path.is_file() and path.suffix.lower() in IMAGE_SUFFIXES)


def write_mem(image: Image.Image, path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("".join(f"{value:02x}\n" for value in image.get_flattened_data()), encoding="ascii")


def read_csv(path: Path) -> list[dict[str, int]]:
    with path.open(newline="", encoding="ascii") as handle:
        return [{key: int(value) for key, value in row.items()} for row in csv.DictReader(handle)]


def corners(row: dict[str, int]) -> dict[str, list[int]]:
    return {
        "tl": [row["tl_x"], row["tl_y"]],
        "tr": [row["tr_x"], row["tr_y"]],
        "br": [row["br_x"], row["br_y"]],
        "bl": [row["bl_x"], row["bl_y"]],
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--input-dir", type=Path, default=DEFAULT_INPUT)
    parser.add_argument("--out", type=Path, default=DEFAULT_OUTPUT)
    parser.add_argument("--limit", type=int, default=0, help="Optional frame limit; zero means all frames.")
    parser.add_argument(
        "--capture-set", action="append", default=[],
        help="Only run a named capture-set folder; repeat for multiple sets.",
    )
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
            source_paths = [
                path for path in source_paths
                if path.relative_to(input_dir).parts[0] in selected
            ]
        if args.limit > 0:
            source_paths = source_paths[: args.limit]
        if not source_paths:
            raise ValueError(f"no camera images found in {input_dir}")
        prepare_output(output)

        input_copy_dir = output / "camera_input_gray"
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
            copied_path = input_copy_dir / relative.with_suffix(".png")
            mem_path = mem_dir / relative.with_suffix(".mem")
            with Image.open(source_path) as source:
                gray = source.convert("L")
                if gray.size != (WIDTH, HEIGHT):
                    raise ValueError(f"expected 160x120 camera raster, got {gray.size}: {source_path}")
                copied_path.parent.mkdir(parents=True, exist_ok=True)
                gray.save(copied_path)
                write_mem(gray, mem_path)
            frame_list.append(mem_path.resolve().as_posix())
            sources.append({
                "frame": index,
                "relative_path": relative.as_posix(),
                "capture_set": capture_set,
                "source_path": str(source_path),
                "camera_input_gray_path": copied_path.relative_to(output).as_posix(),
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
            str(root / "tb" / "roi_warp_grid_pipeline_image_tb.sv"),
        ], build)
        run([str(executable(args.vivado_bin, "xelab")), "roi_warp_grid_pipeline_image_tb", "-s", "roi_warp_grid_pipeline_image_tb"], build)
        run([str(executable(args.vivado_bin, "xsim")), "-runall", "roi_warp_grid_pipeline_image_tb"], build)

        frame_rows = read_csv(build / "pipeline_frames.csv")
        grid_rows = read_csv(build / "grid_results.csv")
        if len(frame_rows) != len(sources):
            raise RuntimeError(f"XSim emitted {len(frame_rows)} frame rows; expected {len(sources)}")
        grids: dict[int, list[dict[str, int]]] = {}
        for row in grid_rows:
            grids.setdefault(row.pop("frame"), []).append(row)

        warped_file = (build / "warped_pixels.hex").open(encoding="ascii")
        records: list[dict[str, object]] = []
        rejected: list[dict[str, object]] = []
        for source, row in zip(sources, frame_rows):
            base = {
                **source,
                "roi_valid": bool(row["roi_valid"]),
                "tracking_active": bool(row["tracking_active"]),
                "roi_corners": corners(row) if row["roi_valid"] else None,
                "roi_box": None if not row["roi_valid"] else {
                    "x": row["roi_x"], "y": row["roi_y"],
                    "width": row["roi_width"], "height": row["roi_height"],
                },
            }
            if not row["grid_emitted"]:
                rejected.append(base)
                continue
            cells = grids.get(row["frame"], [])
            if len(cells) != 64 or any(cell["pixels"] != 300 for cell in cells):
                raise RuntimeError(f"invalid RTL grid for {source['relative_path']}")
            values = []
            for _ in range(PIXELS):
                line = warped_file.readline()
                if not line:
                    raise RuntimeError(f"RTL warped stream ended early at {source['relative_path']}")
                values.append(int(line.strip(), 16))
            output_path = output / "camera_gray" / Path(str(source["relative_path"])).with_suffix(".png")
            output_path.parent.mkdir(parents=True, exist_ok=True)
            warped = Image.new("L", (WIDTH, HEIGHT)); warped.putdata(values); warped.save(output_path)
            records.append({
                **base,
                "camera_gray_path": output_path.relative_to(output).as_posix(),
                "perspective_rectified": True,
                "perspective_engine": "rtl/projective_warp_160x120.sv",
                "cells": cells,
            })
        if warped_file.readline():
            raise RuntimeError("RTL emitted more warped pixels than expected")
        warped_file.close()

        if not records:
            raise RuntimeError("direct RTL pipeline did not emit any valid ROI grids")
        preview_record = max(records, key=lambda record: max(cell["avg_gray"] for cell in record["cells"]) - min(cell["avg_gray"] for cell in record["cells"]))
        with Image.open(output / str(preview_record["camera_gray_path"])) as source:
            preview = source.convert("RGB").resize((WIDTH * 4, HEIGHT * 4), Image.Resampling.NEAREST)
        draw = ImageDraw.Draw(preview)
        for cell in preview_record["cells"]:
            draw.rectangle((cell["left"] * 4, cell["top"] * 4, (cell["right"] + 1) * 4 - 1, (cell["bottom"] + 1) * 4 - 1), outline=(255, 40, 48), width=2)
        preview.save(output / "grid_preview.png")

        manifest = {
            "format": "cubeocc-grayscale-grid-rtl-v1",
            "mode": "direct-connected-rtl",
            "input_dir": str(input_dir),
            "source_frame_count": len(sources),
            "valid_roi_frame_count": len(records),
            "rejected_frame_count": len(rejected),
            "camera_model": {
                "format": "GRAY8", "width": WIDTH, "height": HEIGHT,
                "perspective_rectified": True, "perspective_engine": "rtl/projective_warp_160x120.sv",
                "warp_resampling": "projective-nearest",
            },
            "rtl": [
                "rtl/roi_start_detector.sv", "rtl/projective_warp_160x120.sv",
                "rtl/grayscale_grid_8x8.sv", "rtl/roi_warp_grid_pipeline.sv",
            ],
            "testbench": "tb/roi_warp_grid_pipeline_image_tb.sv",
            "simulator": "XSim / Vivado 2019.1",
            "preview": "grid_preview.png",
            "rejected_frames": rejected,
            "frames": records,
        }
        (output / "grid_results.json").write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
        print(f"Direct FPGA pipeline: {len(records)} emitted, {len(rejected)} rejected: {output / 'grid_results.json'}")
        return 0
    except (FileNotFoundError, OSError, RuntimeError, ValueError) as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
