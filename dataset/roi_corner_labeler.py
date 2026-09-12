#!/usr/bin/env python3
"""Manually mark and grade CubeOCC sender ROI corners in monitor captures.

The reviewer works on a small monochrome camera representation. It writes the
four selected ROI points, a true/mid/false grade, and a red-dot annotation for
every labeled image. This becomes ground truth for improving ROI detection.
"""

from __future__ import annotations

import argparse
import json
import shutil
import sys
import tkinter as tk
from datetime import datetime, timezone
from pathlib import Path
from tkinter import filedialog, messagebox
from typing import Any, Iterable

from PIL import Image, ImageDraw, ImageTk

try:
    from .roi_start_detector_model import detect_frame_roi
except ImportError:
    from roi_start_detector_model import detect_frame_roi


IMAGE_SUFFIXES = {".png", ".jpg", ".jpeg", ".bmp", ".tif", ".tiff"}
CAMERA_SIZE = (640, 480)
DOT_RADIUS = 10
CORNER_NAMES = ("tl", "tr", "br", "bl")


def iter_images(input_dir: Path, excluded_dir: Path | None = None) -> Iterable[Path]:
    for path in sorted(input_dir.rglob("*")):
        if excluded_dir is not None and excluded_dir in path.parents:
            continue
        if path.is_file() and path.suffix.lower() in IMAGE_SUFFIXES:
            yield path


def letterbox_grayscale(image: Image.Image, size: tuple[int, int] = CAMERA_SIZE) -> tuple[Image.Image, dict[str, float]]:
    """Fit an image inside a monochrome camera frame, preserving aspect ratio."""
    source = image.convert("L")
    scale = min(size[0] / source.width, size[1] / source.height)
    fitted_size = (max(1, round(source.width * scale)), max(1, round(source.height * scale)))
    # Nearest-neighbour sampling is intentionally used here: a physical
    # monochrome camera already emits pixels at its native resolution, and it
    # is far cheaper to reproduce than a multi-tap resize filter in FPGA RTL.
    fitted = source.resize(fitted_size, Image.Resampling.NEAREST)
    canvas = Image.new("L", size, 0)
    offset_x = (size[0] - fitted.width) // 2
    offset_y = (size[1] - fitted.height) // 2
    canvas.paste(fitted, (offset_x, offset_y))
    return canvas, {
        "source_width": source.width,
        "source_height": source.height,
        "camera_width": size[0],
        "camera_height": size[1],
        "scale": scale,
        "offset_x": offset_x,
        "offset_y": offset_y,
    }


def original_point(point: tuple[int, int], transform: dict[str, float]) -> list[float]:
    x = (point[0] - transform["offset_x"]) / transform["scale"]
    y = (point[1] - transform["offset_y"]) / transform["scale"]
    x = min(max(x, 0.0), transform["source_width"] - 1)
    y = min(max(y, 0.0), transform["source_height"] - 1)
    return [round(x, 2), round(y, 2)]


def annotated_image(camera_image: Image.Image, corners: list[tuple[int, int] | None]) -> Image.Image:
    overlay = camera_image.convert("RGB")
    draw = ImageDraw.Draw(overlay)
    valid = [point for point in corners if point is not None]
    if len(valid) == 4:
        draw.line(valid + [valid[0]], fill=(255, 0, 0), width=2)
    for index, point in enumerate(corners):
        if point is None:
            continue
        x, y = point
        draw.ellipse((x - DOT_RADIUS, y - DOT_RADIUS, x + DOT_RADIUS, y + DOT_RADIUS), outline=(255, 0, 0), width=3)
        draw.text((x + DOT_RADIUS + 3, y - DOT_RADIUS - 2), str(index + 1), fill=(255, 0, 0))
    return overlay


def prepare_fresh_review_output(input_dir: Path, output_dir: Path) -> None:
    """Clear only a prior CubeOCC review folder before starting a new run."""
    if output_dir == input_dir:
        raise ValueError("review output folder cannot be the same as the capture folder")
    if output_dir.exists():
        manifest_path = output_dir / "roi_review.json"
        if not manifest_path.is_file():
            raise ValueError(f"refusing to clear an unknown output folder: {output_dir}")
        shutil.rmtree(output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)


class RoiCornerLabeler(tk.Tk):
    def __init__(self, input_dir: Path, output_dir: Path, threshold: int, min_run: int, min_roi_height: int) -> None:
        super().__init__()
        self.input_dir = input_dir.resolve()
        self.output_dir = output_dir.resolve()
        self.preview_dir = self.output_dir / "camera_gray"
        self.annotated_dir = self.output_dir / "annotated"
        self.manifest_path = self.output_dir / "roi_review.json"
        self.started_at = datetime.now(timezone.utc).isoformat()
        self.results: dict[str, Any] = {}
        self.images = list(iter_images(self.input_dir, self.output_dir))
        self.index = 0
        self.current_camera: Image.Image | None = None
        self.current_transform: dict[str, float] | None = None
        self.photo: ImageTk.PhotoImage | None = None
        self.detected_corners: list[tuple[int, int] | None] = [None, None, None, None]
        self.detector_diagnostics: dict[str, Any] = {}
        self.tracking_roi: dict[str, int] | None = None
        self.current_set: str | None = None
        self.threshold = tk.IntVar(value=threshold)
        self.min_run = tk.IntVar(value=min_run)
        self.min_roi_height = tk.IntVar(value=min_roi_height)

        self.title("CubeOCC ROI Corner Reviewer")
        self.resizable(False, False)
        self.protocol("WM_DELETE_WINDOW", self.destroy)
        self.bind("1", lambda _event: self.grade_current("true"))
        self.bind("2", lambda _event: self.grade_current("mid"))
        self.bind("3", lambda _event: self.grade_current("false"))
        self.bind("s", lambda _event: self.skip_current())
        self.bind("S", lambda _event: self.skip_current())
        self.bind("a", lambda _event: self.run_detector())
        self.bind("A", lambda _event: self.run_detector())

        self.status = tk.StringVar()
        self.help_text = tk.StringVar(value="Automatic FPGA-style ROI shown in red. Press 1=true, 2=mid, or 3=false.")
        tk.Label(self, textvariable=self.status, anchor="w", padx=8).pack(fill="x", pady=(8, 0))
        self.canvas = tk.Canvas(self, width=CAMERA_SIZE[0], height=CAMERA_SIZE[1], highlightthickness=1, highlightbackground="#777777")
        self.canvas.pack(padx=8, pady=8)
        controls = tk.Frame(self)
        controls.pack(fill="x", padx=8)
        tk.Button(controls, text="1  True", width=12, command=lambda: self.grade_current("true")).pack(side="left")
        tk.Button(controls, text="2  Mid", width=12, command=lambda: self.grade_current("mid")).pack(side="left", padx=(6, 0))
        tk.Button(controls, text="3  False", width=12, command=lambda: self.grade_current("false")).pack(side="left", padx=(6, 0))
        tk.Button(controls, text="S  Skip", width=12, command=self.skip_current).pack(side="left", padx=(6, 0))
        tracker_controls = tk.Frame(self)
        tracker_controls.pack(fill="x", padx=8, pady=(6, 0))
        tk.Label(tracker_controls, text="Bright threshold").pack(side="left")
        tk.Spinbox(tracker_controls, from_=0, to=255, width=5, textvariable=self.threshold, command=self.run_detector).pack(side="left", padx=(5, 12))
        tk.Label(tracker_controls, text="Minimum bright run").pack(side="left")
        tk.Spinbox(tracker_controls, from_=1, to=480, width=5, textvariable=self.min_run, command=self.run_detector).pack(side="left", padx=(5, 12))
        tk.Label(tracker_controls, text="Minimum ROI height").pack(side="left")
        tk.Spinbox(tracker_controls, from_=1, to=480, width=5, textvariable=self.min_roi_height, command=self.run_detector).pack(side="left", padx=(5, 12))
        tk.Button(tracker_controls, text="A  Re-run ROI detector", command=self.run_detector).pack(side="left")
        tk.Label(self, textvariable=self.help_text, anchor="w", padx=8, pady=8).pack(fill="x")
        self.load_current()

    def relative_name(self, path: Path) -> str:
        return path.relative_to(self.input_dir).as_posix()

    def save_results(self) -> None:
        grade_paths = {
            grade: sorted(path for path, result in self.results.items() if result["grade"] == grade)
            for grade in ("true", "mid", "false")
        }
        data = {
            "format": "cubeocc-roi-corner-review-v2",
            "review_started_utc": self.started_at,
            "input_dir": str(self.input_dir),
            "camera_model": {"mode": "grayscale", "width": CAMERA_SIZE[0], "height": CAMERA_SIZE[1]},
            "dot_radius_pixels": DOT_RADIUS,
            "grade_definitions": {
                "true": "automatic RTL-equivalent ROI accurately bounds the sender ROI",
                "mid": "ROI is usable but corners or edges are noticeably imprecise",
                "false": "points do not identify the sender ROI",
            },
            "summary": {
                "labeled_count": len(self.results),
                "true_count": len(grade_paths["true"]),
                "mid_count": len(grade_paths["mid"]),
                "false_count": len(grade_paths["false"]),
                "needs_check": grade_paths["mid"] + grade_paths["false"],
            },
            "images": self.results,
        }
        temporary_path = self.manifest_path.with_suffix(".tmp")
        temporary_path.write_text(json.dumps(data, indent=2), encoding="utf-8")
        temporary_path.replace(self.manifest_path)

    def load_current(self) -> None:
        if self.index >= len(self.images):
            self.canvas.delete("all")
            self.status.set(f"Finished. Saved {len(self.results)} labeled image(s) in {self.output_dir}")
            self.help_text.set("Close this window. A new launch starts a fresh review and replaces this run.")
            return
        path = self.images[self.index]
        capture_set = path.parent.name
        if capture_set != self.current_set:
            self.current_set = capture_set
            self.tracking_roi = None
        with Image.open(path) as source:
            self.current_camera, self.current_transform = letterbox_grayscale(source)
        self.detected_corners = [None, None, None, None]
        self.detector_diagnostics = {}
        self.status.set(f"{self.index + 1}/{len(self.images)}  {self.relative_name(path)}")
        self.run_detector()
        self.redraw()

    def redraw(self) -> None:
        if self.current_camera is None:
            return
        display = annotated_image(self.current_camera, self.detected_corners)
        self.photo = ImageTk.PhotoImage(display)
        self.canvas.delete("all")
        self.canvas.create_image(0, 0, image=self.photo, anchor="nw")

    def skip_current(self) -> None:
        if self.index < len(self.images):
            self.index += 1
            self.load_current()

    def run_detector(self) -> None:
        if self.current_camera is None:
            return
        try:
            self.detected_corners, self.detector_diagnostics, _next_roi = detect_frame_roi(
                self.current_camera,
                int(self.threshold.get()),
                int(self.min_run.get()),
                int(self.min_roi_height.get()),
                self.tracking_roi,
            )
        except (tk.TclError, ValueError) as exc:
            self.bell()
            self.help_text.set(f"ROI detector configuration error: {exc}")
            return
        if all(point is not None for point in self.detected_corners):
            mode = self.detector_diagnostics.get("mode", "unknown")
            self.help_text.set(f"{mode}: automatic ROI shown in red. Press 1=true, 2=mid, or 3=false.")
        else:
            self.help_text.set("No valid ROI found. Press 3=false, or tune controls and press A.")
        self.redraw()

    def grade_current(self, grade: str) -> None:
        if self.index >= len(self.images):
            return
        assert self.current_camera is not None and self.current_transform is not None
        path = self.images[self.index]
        relative = self.relative_name(path)
        preview_path = self.preview_dir / Path(relative).with_suffix(".png")
        annotated_path = self.annotated_dir / Path(relative).with_suffix(".png")
        preview_path.parent.mkdir(parents=True, exist_ok=True)
        annotated_path.parent.mkdir(parents=True, exist_ok=True)
        self.current_camera.save(preview_path)
        annotated_image(self.current_camera, self.detected_corners).save(annotated_path)
        self.results[relative] = {
            "grade": grade,
            "source_path": str(path.resolve()),
            "camera_gray_path": preview_path.relative_to(self.output_dir).as_posix(),
            "annotated_path": annotated_path.relative_to(self.output_dir).as_posix(),
            "camera_corners": {name: None if point is None else list(point) for name, point in zip(CORNER_NAMES, self.detected_corners)},
            "original_corners": {name: None if point is None else original_point(point, self.current_transform) for name, point in zip(CORNER_NAMES, self.detected_corners)},
            "letterbox_transform": self.current_transform,
            "fpga_roi_detector": self.detector_diagnostics,
        }
        self.save_results()
        if grade != "false" and self.detector_diagnostics.get("valid"):
            self.tracking_roi = self.detector_diagnostics.get("roi_box")
        self.index += 1
        self.load_current()


def choose_input_dir() -> Path | None:
    selected = filedialog.askdirectory(title="Choose a CubeOCC capture folder")
    return Path(selected) if selected else None


def main() -> int:
    parser = argparse.ArgumentParser(description="Click, annotate, and grade ROI corners in CubeOCC captures.")
    parser.add_argument("--input-dir", type=Path, help="Capture folder; subfolders are included.")
    parser.add_argument("--out", type=Path, help="Output folder; default is <input-dir>/roi_review.")
    parser.add_argument("--threshold", type=int, default=180, help="Fixed grayscale threshold for the FPGA-style ROI detector (0 to 255).")
    parser.add_argument("--min-run", type=int, default=32, help="RTL min_line_run: minimum bright pixels on a qualifying image row.")
    parser.add_argument("--min-roi-height", type=int, default=16, help="RTL min_roi_height: minimum height of the accepted bright band.")
    args = parser.parse_args()

    root = tk.Tk()
    root.withdraw()
    input_dir = args.input_dir or choose_input_dir()
    root.destroy()
    if input_dir is None:
        return 0
    if not input_dir.is_dir():
        print(f"ERROR: input folder does not exist: {input_dir}", file=sys.stderr)
        return 2
    if not 0 <= args.threshold <= 255 or args.min_run < 1 or args.min_roi_height < 1:
        print("ERROR: threshold must be 0..255 and both minimum dimensions must be positive", file=sys.stderr)
        return 2
    output_dir = args.out or input_dir / "roi_review"
    try:
        prepare_fresh_review_output(input_dir.resolve(), output_dir.resolve())
    except ValueError as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 2
    app = RoiCornerLabeler(input_dir, output_dir, args.threshold, args.min_run, args.min_roi_height)
    if not app.images:
        messagebox.showinfo("CubeOCC ROI Corner Reviewer", "No images found in the selected folder.")
        app.destroy()
        return 0
    app.mainloop()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
