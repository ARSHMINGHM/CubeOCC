#!/usr/bin/env python3
"""Run FPGA perspective warp and grayscale 8x8 mapping on the V11 ROI set."""

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
DEFAULT_VIVADO_BIN = Path(os.environ.get("VIVADO_BIN", "X:/xilinx/Vivado/2019.1/bin"))
DEFAULT_ROI_RESULTS = Path("sim/roi_rtl_all_v11_independent_edges/rtl_results.json")


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


def roi_box(source: Image.Image, corners: dict[str, list[int]]) -> list[int]:
    points = [corners[name] for name in ("tl", "tr", "br", "bl")]
    left = max(0, min(point[0] for point in points))
    top = max(0, min(point[1] for point in points))
    right = min(source.width - 1, max(point[0] for point in points))
    bottom = min(source.height - 1, max(point[1] for point in points))
    if right <= left or bottom <= top:
        raise ValueError(f"invalid ROI box: {(left, top, right, bottom)}")
    return [left, top, right, bottom]


def write_mem(image: Image.Image, path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("".join(f"{value:02x}\n" for value in image.get_flattened_data()), encoding="ascii")


def prepare_output(output: Path) -> None:
    if output.exists():
        if not (output / "grid_results.json").is_file():
            raise ValueError(f"refusing to clear unknown folder: {output}")
        shutil.rmtree(output)
    output.mkdir(parents=True)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--roi-results", type=Path, default=DEFAULT_ROI_RESULTS, help="Current roi_start_detector RTL result manifest.")
    parser.add_argument("--out", type=Path, default=Path("sim/grayscale_grid_rtl_results"))
    parser.add_argument("--match", default="", help="Optional case-insensitive substring filter for ROI relative paths.")
    parser.add_argument("--limit", type=int, default=0, help="Optional maximum number of images; zero means all.")
    parser.add_argument("--vivado-bin", type=Path, default=DEFAULT_VIVADO_BIN)
    args = parser.parse_args()

    root = Path(__file__).resolve().parents[1]
    roi_results_path = args.roi_results.resolve()
    output = args.out.resolve()
    try:
        if not roi_results_path.is_file():
            raise ValueError(f"ROI result manifest does not exist: {roi_results_path}")
        roi_report = json.loads(roi_results_path.read_text(encoding="utf-8"))
        images = [item for item in roi_report.get("images", []) if item.get("camera_corners") and all(item["camera_corners"].values())]
        if args.match:
            images = [item for item in images if args.match.lower() in item["relative_path"].lower()]
        if args.limit > 0:
            images = images[: args.limit]
        if not images:
            raise ValueError(f"no valid FPGA ROI frames found in {roi_results_path}")
        prepare_output(output)

        input_dir = output / "camera_input_gray"
        camera_dir = output / "camera_gray"
        mem_dir = output / "mem"
        file_list: list[str] = []
        records: list[dict[str, object]] = []
        for index, roi_item in enumerate(images):
            relative = Path(roi_item["relative_path"])
            source_path = roi_results_path.parent / roi_item["camera_gray_path"]
            flat_name = f"{index:06d}_{relative.stem}"
            input_path = input_dir / f"{flat_name}.png"
            gray_path = camera_dir / f"{flat_name}.png"
            mem_path = mem_dir / f"{flat_name}.mem"
            with Image.open(source_path) as source:
                raster = source.convert("L")
                source_size = list(source.size)
                if raster.size != (WIDTH, HEIGHT):
                    raise ValueError(f"expected 160x120 V11 camera image, got {raster.size}: {source_path}")
                frame_roi_box = roi_box(source, roi_item["camera_corners"])
            input_dir.mkdir(parents=True, exist_ok=True)
            raster.save(input_path)
            write_mem(raster, mem_path)
            corner_values = [str(value) for name in ("tl", "tr", "br", "bl") for value in roi_item["camera_corners"][name]]
            file_list.append(" ".join([mem_path.resolve().as_posix(), *corner_values]))
            records.append({
                "index": index,
                "relative_path": relative.as_posix(),
                "source_path": str(source_path),
                "camera_input_gray_path": input_path.relative_to(output).as_posix(),
                "camera_gray_path": gray_path.relative_to(output).as_posix(),
                "source_size": source_size,
                "roi_corners": roi_item["camera_corners"],
                "sensor_roi_box": frame_roi_box,
                "perspective_rectified": True,
                "perspective_engine": "rtl/perspective_warp_160x120.sv",
                "warp_resampling": "nearest",
                "capture_set": roi_item.get("capture_set"),
                "cells": [],
            })

        build = output / "xsim_build"
        build.mkdir()
        (build / "frame_list.txt").write_text("\n".join(file_list) + "\n", encoding="ascii")
        run([
            str(executable(args.vivado_bin, "xvlog")), "-sv",
            str(root / "rtl" / "perspective_warp_160x120.sv"),
            str(root / "rtl" / "grayscale_grid_8x8.sv"),
            str(root / "tb" / "grayscale_grid_8x8_image_tb.sv"),
        ], build)
        run([str(executable(args.vivado_bin, "xelab")), "grayscale_grid_8x8_image_tb", "-s", "grayscale_grid_8x8_image_tb"], build)
        run([str(executable(args.vivado_bin, "xsim")), "-runall", "grayscale_grid_8x8_image_tb"], build)

        with (build / "grid_results.csv").open(newline="", encoding="ascii") as handle:
            rows = list(csv.DictReader(handle))
        if len(rows) != len(records) * 64:
            raise RuntimeError(f"XSim returned {len(rows)} cells; expected {len(records) * 64}")
        for row in rows:
            frame = records[int(row["frame"])]
            frame["cells"].append({key: int(value) for key, value in row.items() if key != "frame"})

        camera_dir.mkdir(parents=True, exist_ok=True)
        warped_path = build / "warped_pixels.hex"
        with warped_path.open(encoding="ascii") as warped_file:
            for frame in records:
                values = []
                for _ in range(WIDTH * HEIGHT):
                    line = warped_file.readline()
                    if not line:
                        raise RuntimeError(f"RTL warped stream ended early at {frame['relative_path']}")
                    values.append(int(line.strip(), 16))
                warped = Image.new("L", (WIDTH, HEIGHT))
                warped.putdata(values)
                warped.save(output / str(frame["camera_gray_path"]))
            if warped_file.readline():
                raise RuntimeError("RTL emitted more warped pixels than expected")

        angle_frames = [record for record in records if "angle30" in str(record["relative_path"]).lower()]
        preview_frame = max(
            angle_frames or records,
            key=lambda record: max(cell["avg_gray"] for cell in record["cells"])
            - min(cell["avg_gray"] for cell in record["cells"]),
        )
        with Image.open(output / str(preview_frame["camera_gray_path"])) as preview_source:
            preview = preview_source.convert("RGB").resize((WIDTH * 4, HEIGHT * 4), Image.Resampling.NEAREST)
        draw = ImageDraw.Draw(preview)
        for cell in preview_frame["cells"]:
            draw.rectangle((cell["left"] * 4, cell["top"] * 4, (cell["right"] + 1) * 4 - 1, (cell["bottom"] + 1) * 4 - 1), outline=(255, 40, 48), width=2)
        preview.save(output / "grid_preview.png")

        manifest = {
            "format": "cubeocc-grayscale-grid-rtl-v1",
            "source_roi_results": str(roi_results_path),
            "source_roi_frame_count": len(roi_report.get("images", [])),
            "valid_roi_frame_count": len(images),
            "camera_model": {
                "format": "GRAY8",
                "width": WIDTH,
                "height": HEIGHT,
                "sensor_roi_already_applied": False,
                "perspective_rectified": True,
                "perspective_engine": "rtl/perspective_warp_160x120.sv",
                "warp_resampling": "nearest",
            },
            "rtl": ["rtl/perspective_warp_160x120.sv", "rtl/grayscale_grid_8x8.sv"],
            "testbench": "tb/grayscale_grid_8x8_image_tb.sv",
            "simulator": "XSim / Vivado 2019.1",
            "preview": "grid_preview.png",
            "frames": records,
        }
        (output / "grid_results.json").write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
        print(f"Wrote {len(records)} grayscale RTL-gridded frame(s): {output / 'grid_results.json'}")
        return 0
    except (FileNotFoundError, OSError, RuntimeError, ValueError) as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
