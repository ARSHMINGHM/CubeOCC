#!/usr/bin/env python3
"""Run the real roi_start_detector RTL over ordered monitor-capture images.

The script converts every source image to the small grayscale camera raster
used by tb/roi_start_detector_image_tb.sv, drives that raster through XSim,
and writes a manifest that roi_corner_labeler.py can review. The GUI therefore
grades values emitted by RTL, rather than the Python reference model.
"""

from __future__ import annotations

import argparse
import csv
import json
import os
import shutil
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Iterable

from PIL import Image


IMAGE_SUFFIXES = {".png", ".jpg", ".jpeg", ".bmp", ".tif", ".tiff"}
GENERATED_IMAGE_DIRS = {"roi_review", "camera_gray", "annotated", "xsim_build", "mem"}
FRAME_WIDTH = 160
FRAME_HEIGHT = 120
DEFAULT_VIVADO_BIN = Path(os.environ.get("VIVADO_BIN", "X:/xilinx/Vivado/2019.1/bin"))


@dataclass(frozen=True)
class FrameInput:
    source_path: Path
    relative_path: Path
    mem_path: Path
    gray_path: Path
    transform: dict[str, float]


def iter_images(input_dir: Path, excluded_dir: Path) -> Iterable[Path]:
    for path in sorted(input_dir.rglob("*")):
        if excluded_dir in path.parents:
            continue
        if any(parent.name in GENERATED_IMAGE_DIRS for parent in path.parents):
            continue
        if path.is_file() and path.suffix.lower() in IMAGE_SUFFIXES:
            yield path


def letterbox_grayscale(image: Image.Image) -> tuple[Image.Image, dict[str, float]]:
    source = image.convert("L")
    scale = min(FRAME_WIDTH / source.width, FRAME_HEIGHT / source.height)
    fitted_size = (max(1, round(source.width * scale)), max(1, round(source.height * scale)))
    fitted = source.resize(fitted_size, Image.Resampling.NEAREST)
    canvas = Image.new("L", (FRAME_WIDTH, FRAME_HEIGHT), 0)
    offset_x = (FRAME_WIDTH - fitted.width) // 2
    offset_y = (FRAME_HEIGHT - fitted.height) // 2
    canvas.paste(fitted, (offset_x, offset_y))
    return canvas, {
        "source_width": source.width,
        "source_height": source.height,
        "camera_width": FRAME_WIDTH,
        "camera_height": FRAME_HEIGHT,
        "scale": scale,
        "offset_x": offset_x,
        "offset_y": offset_y,
    }


def write_mem(image: Image.Image, path: Path) -> None:
    pixels = list(image.get_flattened_data())
    if len(pixels) != FRAME_WIDTH * FRAME_HEIGHT:
        raise ValueError(f"unexpected camera raster dimensions for {path}")
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("".join(f"{pixel:02x}\n" for pixel in pixels), encoding="ascii")


def prepare_output_dir(output_dir: Path) -> None:
    if output_dir.exists():
        manifest = output_dir / "rtl_results.json"
        if not manifest.is_file():
            raise ValueError(f"refusing to clear an unknown output folder: {output_dir}")
        shutil.rmtree(output_dir)
    output_dir.mkdir(parents=True)


def executable(vivado_bin: Path, name: str) -> Path:
    candidate = vivado_bin / f"{name}.bat"
    if candidate.is_file():
        return candidate
    candidate = vivado_bin / name
    if candidate.is_file():
        return candidate
    raise FileNotFoundError(f"Vivado tool not found: {vivado_bin / (name + '.bat')}")


def run_command(command: list[str], cwd: Path) -> None:
    print("+", subprocess.list2cmdline(command))
    completed = subprocess.run(command, cwd=cwd, text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    log_path = cwd / f"{Path(command[0]).stem}.log"
    log_path.write_text(completed.stdout, encoding="utf-8", errors="replace")
    if completed.returncode:
        print(completed.stdout, file=sys.stderr)
        raise RuntimeError(f"command failed ({completed.returncode}): {command[0]}")


def build_snapshot(project_root: Path, build_dir: Path, vivado_bin: Path) -> None:
    xvlog = executable(vivado_bin, "xvlog")
    xelab = executable(vivado_bin, "xelab")
    run_command([
        str(xvlog),
        "-sv",
        str(project_root / "rtl" / "roi_start_detector.sv"),
        str(project_root / "tb" / "roi_start_detector_image_tb.sv"),
    ], build_dir)
    run_command([str(xelab), "roi_start_detector_image_tb", "-s", "roi_start_detector_image_tb"], build_dir)


def parse_csv(path: Path) -> list[dict[str, int]]:
    with path.open(newline="", encoding="ascii") as handle:
        return [{key: int(value) for key, value in row.items()} for row in csv.DictReader(handle)]


def run_capture_sets(
    build_dir: Path,
    vivado_bin: Path,
    frame_sets: dict[str, list[FrameInput]],
) -> list[dict[str, int]]:
    file_list = build_dir / "frame_list.txt"
    result_csv = build_dir / "roi_results.csv"
    list_lines: list[str] = []
    for index, frames in enumerate(frame_sets.values()):
        if index:
            list_lines.append("---")
        list_lines.extend(frame.mem_path.resolve().as_posix() for frame in frames)
    file_list.write_text("\n".join(list_lines) + "\n", encoding="ascii")
    xsim = executable(vivado_bin, "xsim")
    run_command([
        str(xsim),
        "-runall",
        "roi_start_detector_image_tb",
    ], build_dir)
    rows = parse_csv(result_csv)
    expected_rows = sum(len(frames) for frames in frame_sets.values())
    if len(rows) != expected_rows:
        raise RuntimeError(f"XSim wrote {len(rows)} results for {expected_rows} input frames")
    return rows


def corners_from_row(row: dict[str, int]) -> dict[str, list[int] | None]:
    if not row["roi_valid"]:
        return {name: None for name in ("tl", "tr", "br", "bl")}
    return {
        "tl": [row["tl_x"], row["tl_y"]],
        "tr": [row["tr_x"], row["tr_y"]],
        "br": [row["br_x"], row["br_y"]],
        "bl": [row["bl_x"], row["bl_y"]],
    }


def main() -> int:
    parser = argparse.ArgumentParser(description="Run CubeOCC ROI RTL in XSim against an ordered monitor-capture folder.")
    parser.add_argument("--input-dir", type=Path, required=True, help="Capture folder; each immediate subfolder is a separate START-to-END sequence.")
    parser.add_argument("--out", type=Path, default=Path("sim/roi_rtl_results"), help="Fresh RTL simulation result folder.")
    parser.add_argument("--vivado-bin", type=Path, default=DEFAULT_VIVADO_BIN, help="Vivado 2019.1 bin directory.")
    args = parser.parse_args()

    input_dir = args.input_dir.resolve()
    output_dir = args.out.resolve()
    project_root = Path(__file__).resolve().parents[1]
    if not input_dir.is_dir():
        print(f"ERROR: input folder does not exist: {input_dir}", file=sys.stderr)
        return 2
    try:
        prepare_output_dir(output_dir)
        all_frames: dict[str, list[FrameInput]] = {}
        for source_path in iter_images(input_dir, output_dir):
            relative = source_path.relative_to(input_dir)
            set_name = relative.parts[0] if len(relative.parts) > 1 else "root"
            gray_path = output_dir / "camera_gray" / relative.with_suffix(".png")
            mem_path = output_dir / "mem" / relative.with_suffix(".mem")
            with Image.open(source_path) as source:
                camera_gray, transform = letterbox_grayscale(source)
            gray_path.parent.mkdir(parents=True, exist_ok=True)
            camera_gray.save(gray_path)
            write_mem(camera_gray, mem_path)
            all_frames.setdefault(set_name, []).append(FrameInput(source_path, relative, mem_path, gray_path, transform))
        if not all_frames:
            raise ValueError(f"no images found in {input_dir}")

        build_dir = output_dir / "xsim_build"
        build_dir.mkdir()
        build_snapshot(project_root, build_dir, args.vivado_bin)
        ordered_sets = dict(sorted(all_frames.items()))
        print(f"Running {len(ordered_sets)} capture set(s), {sum(len(frames) for frames in ordered_sets.values())} frame(s)")
        rows = run_capture_sets(build_dir, args.vivado_bin, ordered_sets)
        results: list[dict[str, Any]] = []
        ordered_frames = [frame for frames in ordered_sets.values() for frame in frames]
        for frame, row in zip(ordered_frames, rows):
            set_name = frame.relative_path.parts[0] if len(frame.relative_path.parts) > 1 else "root"
            corners = corners_from_row(row)
            diagnostics = {
                "engine": "rtl/roi_start_detector.sv executed by XSim",
                "mode": "rtl-active" if row["tracking_active"] else "rtl-waiting-for-start",
                "valid": bool(row["roi_valid"]),
                "tracking_active": bool(row["tracking_active"]),
                "threshold": 180,
                "min_line_run": 8,
                "min_roi_height": 4,
                "roi_box": None if not row["roi_valid"] else {
                    "left": row["roi_x"],
                    "top": row["roi_y"],
                    "right": row["roi_x"] + row["roi_width"] - 1,
                    "bottom": row["roi_y"] + row["roi_height"] - 1,
                },
            }
            results.append({
                "relative_path": frame.relative_path.as_posix(),
                "capture_set": set_name,
                "source_path": str(frame.source_path),
                "camera_gray_path": frame.gray_path.relative_to(output_dir).as_posix(),
                "letterbox_transform": frame.transform,
                "camera_corners": corners,
                "fpga_roi_detector": diagnostics,
            })
        manifest = {
            "format": "cubeocc-xsim-roi-results-v1",
            "input_dir": str(input_dir),
            "camera_model": {"mode": "grayscale", "width": FRAME_WIDTH, "height": FRAME_HEIGHT},
            "rtl": "rtl/roi_start_detector.sv",
            "testbench": "tb/roi_start_detector_image_tb.sv",
            "simulator": "XSim / Vivado 2019.1",
            "tracker_config": {"threshold": 180, "min_line_run": 8, "min_roi_height": 4, "full_off_max_pixels": 0},
            "images": results,
        }
        (output_dir / "rtl_results.json").write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
        valid_count = sum(1 for result in results if result["fpga_roi_detector"]["valid"])
        print(f"Wrote {len(results)} XSim results ({valid_count} valid ROI frame(s)): {output_dir / 'rtl_results.json'}")
        return 0
    except (FileNotFoundError, RuntimeError, ValueError, OSError) as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
