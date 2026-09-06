#!/usr/bin/env python3
"""
Prepare monitor-capture images for CubeOCC dataset/ML work.

Input images are real camera photos of the sender display. The tool can either
use a companion corners JSON or auto-detect the four bright sender-grid corner
markers. It warps each capture to a regular ROI image, then writes
lower-visibility variants by downsampling and applying Gaussian blur.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from typing import Iterable, List, Sequence, Tuple

from PIL import Image, ImageFilter


Point = Tuple[float, float]


IMAGE_SUFFIXES = {".png", ".jpg", ".jpeg", ".bmp", ".tif", ".tiff"}


def solve_linear_system(matrix: List[List[float]], vector: List[float]) -> List[float]:
    size = len(vector)
    aug = [row[:] + [value] for row, value in zip(matrix, vector)]
    for col in range(size):
        pivot = max(range(col, size), key=lambda row: abs(aug[row][col]))
        if abs(aug[pivot][col]) < 1e-12:
            raise ValueError("corner transform is singular; check the four points")
        aug[col], aug[pivot] = aug[pivot], aug[col]
        scale = aug[col][col]
        aug[col] = [value / scale for value in aug[col]]
        for row in range(size):
            if row == col:
                continue
            factor = aug[row][col]
            aug[row] = [current - factor * pivot_value for current, pivot_value in zip(aug[row], aug[col])]
    return [aug[row][-1] for row in range(size)]


def perspective_coefficients(src: Sequence[Point], dst: Sequence[Point]) -> Tuple[float, ...]:
    matrix: List[List[float]] = []
    vector: List[float] = []
    for (x, y), (u, v) in zip(dst, src):
        matrix.append([x, y, 1, 0, 0, 0, -u * x, -u * y])
        matrix.append([0, 0, 0, x, y, 1, -v * x, -v * y])
        vector.extend([u, v])
    coeffs = solve_linear_system(matrix, vector)
    return tuple(coeffs)


def load_corners(path: Path, image_name: str) -> List[Point]:
    data = json.loads(path.read_text(encoding="ascii"))
    raw = data.get(image_name) or data.get(Path(image_name).stem) or data.get("corners")
    if raw is None:
        raise ValueError(f"no corners found for {image_name}")
    if isinstance(raw, dict):
        raw = [raw["tl"], raw["tr"], raw["br"], raw["bl"]]
    if len(raw) != 4:
        raise ValueError("corners must contain four points: tl, tr, br, bl")
    return [(float(point[0]), float(point[1])) for point in raw]


def brightness(pixel: Tuple[int, int, int]) -> int:
    return max(pixel)


def component_centroid(component: Sequence[Tuple[int, int]]) -> Point:
    sx = sum(point[0] for point in component)
    sy = sum(point[1] for point in component)
    return sx / len(component), sy / len(component)


def bright_components(image: Image.Image, threshold: int, min_area: int) -> List[List[Tuple[int, int]]]:
    small = image.convert("RGB")
    width, height = small.size
    pixels = small.load()
    visited = set()
    components: List[List[Tuple[int, int]]] = []

    for y in range(height):
        for x in range(width):
            if (x, y) in visited or brightness(pixels[x, y]) < threshold:
                continue
            stack = [(x, y)]
            visited.add((x, y))
            component: List[Tuple[int, int]] = []
            while stack:
                px, py = stack.pop()
                component.append((px, py))
                for nx, ny in ((px + 1, py), (px - 1, py), (px, py + 1), (px, py - 1)):
                    if nx < 0 or ny < 0 or nx >= width or ny >= height or (nx, ny) in visited:
                        continue
                    visited.add((nx, ny))
                    if brightness(pixels[nx, ny]) >= threshold:
                        stack.append((nx, ny))
            if len(component) >= min_area:
                components.append(component)
    return components


def choose_corner_centroids(points: Sequence[Point], width: int, height: int) -> List[Point]:
    if len(points) < 4:
        raise ValueError(f"auto-corner detection found only {len(points)} bright components")

    def unique_pick(scored: Sequence[Tuple[float, Point]], used: set[Point]) -> Point:
        for _score, point in scored:
            if point not in used:
                used.add(point)
                return point
        raise ValueError("could not choose four unique corner markers")

    scored_tl = sorted(((x + y, (x, y)) for x, y in points), key=lambda item: item[0])
    scored_tr = sorted((((width - x) + y, (x, y)) for x, y in points), key=lambda item: item[0])
    scored_br = sorted((((width - x) + (height - y), (x, y)) for x, y in points), key=lambda item: item[0])
    scored_bl = sorted(((x + (height - y), (x, y)) for x, y in points), key=lambda item: item[0])
    used: set[Point] = set()
    tl = unique_pick(scored_tl, used)
    tr = unique_pick(scored_tr, used)
    br = unique_pick(scored_br, used)
    bl = unique_pick(scored_bl, used)
    return [tl, tr, br, bl]


def choose_quadrant_corners(components: Sequence[Sequence[Tuple[int, int]]], width: int, height: int) -> List[Point]:
    candidates = []
    for component in components:
        centroid = component_centroid(component)
        xs = [point[0] for point in component]
        ys = [point[1] for point in component]
        candidates.append(
            {
                "centroid": centroid,
                "area": len(component),
                "left": min(xs),
                "right": max(xs),
                "top": min(ys),
                "bottom": max(ys),
            }
        )
    if len(candidates) < 4:
        raise ValueError(f"auto-corner detection found only {len(candidates)} bright components")

    min_area = max(1, max(item["area"] for item in candidates) // 20)
    candidates = [item for item in candidates if item["area"] >= min_area]
    targets = (
        ("tl", (0.0, 0.0), lambda x, y: x <= width * 0.55 and y <= height * 0.55),
        ("tr", (float(width), 0.0), lambda x, y: x >= width * 0.45 and y <= height * 0.55),
        ("br", (float(width), float(height)), lambda x, y: x >= width * 0.45 and y >= height * 0.45),
        ("bl", (0.0, float(height)), lambda x, y: x <= width * 0.55 and y >= height * 0.45),
    )

    chosen: List[Point] = []
    used: set[Point] = set()
    for _name, target, in_region in targets:
        tx, ty = target
        scored = []
        for item in candidates:
            cx, cy = item["centroid"]
            if not in_region(cx, cy):
                continue
            distance = (cx - tx) ** 2 + (cy - ty) ** 2
            scored.append((distance, item["centroid"]))
        scored.sort(key=lambda item: item[0])
        for _distance, centroid in scored:
            if centroid not in used:
                used.add(centroid)
                chosen.append(centroid)
                break
        else:
            raise ValueError("could not find one bright marker in each corner quadrant")
    return chosen


def bounding_box_corners(image: Image.Image, threshold: int) -> List[Point]:
    rgb = image.convert("RGB")
    width, height = rgb.size
    pixels = rgb.load()
    xs: List[int] = []
    ys: List[int] = []
    for y in range(height):
        for x in range(width):
            if brightness(pixels[x, y]) >= threshold:
                xs.append(x)
                ys.append(y)
    if not xs:
        raise ValueError("auto-corner detection found no bright pixels")
    left, right = min(xs), max(xs)
    top, bottom = min(ys), max(ys)
    return [(left, top), (right, top), (right, bottom), (left, bottom)]


def auto_detect_corners_at_threshold(image: Image.Image, threshold: int, min_area: int, detect_width: int, method: str) -> List[Point]:
    scale = 1.0
    work = image
    if image.width > detect_width:
        scale = detect_width / image.width
        detect_height = max(1, int(image.height * scale))
        work = image.resize((detect_width, detect_height), Image.Resampling.BILINEAR)
    if method == "bounds":
        corners = bounding_box_corners(work, threshold)
        return [(x / scale, y / scale) for x, y in corners]
    if method not in ("components", "quadrants"):
        raise ValueError("corner method must be bounds, components, or quadrants")
    components = bright_components(work, threshold, min_area)
    if method == "quadrants":
        corners = choose_quadrant_corners(components, work.width - 1, work.height - 1)
    else:
        centroids = [component_centroid(component) for component in components]
        corners = choose_corner_centroids(centroids, work.width - 1, work.height - 1)
    return [(x / scale, y / scale) for x, y in corners]


def auto_detect_corners(image: Image.Image, threshold: int, min_area: int, detect_width: int, method: str) -> Tuple[List[Point], int]:
    thresholds = [threshold] if threshold > 0 else [230, 210, 190, 160, 130, 100, 75]
    errors = []
    for candidate in thresholds:
        try:
            return auto_detect_corners_at_threshold(image, candidate, min_area, detect_width, method), candidate
        except Exception as exc:
            errors.append(f"{candidate}: {exc}")
    raise ValueError("auto-corner detection failed at all thresholds; " + "; ".join(errors))


def corner_dict(corners: Sequence[Point]) -> dict:
    names = ("tl", "tr", "br", "bl")
    return {name: [round(point[0], 2), round(point[1], 2)] for name, point in zip(names, corners)}


def iter_images(input_dir: Path) -> Iterable[Path]:
    for path in sorted(input_dir.iterdir()):
        if path.is_file() and path.suffix.lower() in IMAGE_SUFFIXES:
            yield path


def warp_image(image: Image.Image, corners: Sequence[Point], width: int, height: int) -> Image.Image:
    dst = [(0, 0), (width - 1, 0), (width - 1, height - 1), (0, height - 1)]
    coeffs = perspective_coefficients(corners, dst)
    return image.transform((width, height), Image.Transform.PERSPECTIVE, coeffs, Image.Resampling.BICUBIC)


def degrade_image(image: Image.Image, scale: float, blur: float) -> Image.Image:
    if scale <= 0 or scale > 1:
        raise ValueError("scale must be greater than 0 and at most 1")
    work = image
    if scale < 1:
        small_size = (max(1, int(image.width * scale)), max(1, int(image.height * scale)))
        work = image.resize(small_size, Image.Resampling.BICUBIC)
        work = work.resize(image.size, Image.Resampling.BICUBIC)
    if blur > 0:
        work = work.filter(ImageFilter.GaussianBlur(radius=blur))
    return work


def parse_float_list(text: str) -> List[float]:
    return [float(item.strip()) for item in text.split(",") if item.strip()]


def prepare_capture_set(
    input_dir: Path,
    corners_path: Path | None,
    output_dir: Path,
    roi_width: int,
    roi_height: int,
    scales: Sequence[float],
    blurs: Sequence[float],
    auto_corners: bool,
    threshold: int,
    min_area: int,
    detect_width: int,
    corner_method: str,
) -> int:
    output_dir.mkdir(parents=True, exist_ok=True)
    count = 0
    manifest = {
        "tool": "dataset/prepare_monitor_capture.py",
        "input_dir": str(input_dir),
        "corners_json": str(corners_path) if corners_path is not None else None,
        "auto_corners": auto_corners,
        "auto_threshold": threshold if threshold > 0 else "adaptive",
        "auto_min_area": min_area,
        "auto_detect_width": detect_width,
        "auto_corner_method": corner_method,
        "roi_width": roi_width,
        "roi_height": roi_height,
        "scales": list(scales),
        "gaussian_blurs": list(blurs),
        "detected_corners": {},
        "detected_thresholds": {},
        "outputs": [],
        "errors": [],
    }

    for image_path in iter_images(input_dir):
        image = Image.open(image_path).convert("RGB")
        try:
            if corners_path is not None and not auto_corners:
                corners = load_corners(corners_path, image_path.name)
                used_threshold = None
            else:
                corners, used_threshold = auto_detect_corners(image, threshold, min_area, detect_width, corner_method)
        except Exception as exc:
            if corners_path is None:
                manifest["errors"].append(f"{image_path.name}: {exc}")
                continue
            corners = load_corners(corners_path, image_path.name)
            used_threshold = None
        manifest["detected_corners"][image_path.name] = corner_dict(corners)
        manifest["detected_thresholds"][image_path.name] = used_threshold
        warped = warp_image(image, corners, roi_width, roi_height)

        image_out = output_dir / image_path.stem
        image_out.mkdir(parents=True, exist_ok=True)
        warped_path = image_out / f"{image_path.stem}_warped_roi.png"
        warped.save(warped_path)
        manifest["outputs"].append(str(warped_path))
        count += 1

        for scale in scales:
            for blur in blurs:
                variant = degrade_image(warped, scale, blur)
                variant_path = image_out / f"{image_path.stem}_roi_scale{scale:g}_blur{blur:g}.png"
                variant.save(variant_path)
                manifest["outputs"].append(str(variant_path))
                count += 1

    (output_dir / "prepared_manifest.json").write_text(json.dumps(manifest, indent=2) + "\n", encoding="ascii")
    return count


def main(argv: Sequence[str]) -> int:
    parser = argparse.ArgumentParser(description="Warp monitor-capture images and create downsampled/Gaussian-blurred variants.")
    parser.add_argument("--input-dir", required=True, type=Path, help="Folder containing captured monitor images.")
    parser.add_argument("--corners", type=Path, help="Optional JSON with four corners per image: tl,tr,br,bl.")
    parser.add_argument("--auto-corners", action="store_true", help="Auto-detect four bright corner markers. Falls back to --corners if provided.")
    parser.add_argument("--out", required=True, type=Path, help="Output folder for prepared ROI images.")
    parser.add_argument("--roi-width", default=512, type=int)
    parser.add_argument("--roi-height", default=512, type=int)
    parser.add_argument("--scales", default="1,0.75,0.5,0.25", help="Comma-separated downsample scales.")
    parser.add_argument("--blurs", default="0,0.75,1.5,2.5", help="Comma-separated Gaussian blur radii.")
    parser.add_argument("--threshold", default=0, type=int, help="Auto-corner bright-pixel threshold, 0..255. Use 0 for adaptive threshold attempts.")
    parser.add_argument("--min-area", default=20, type=int, help="Minimum bright component area after detection resize.")
    parser.add_argument("--detect-width", default=640, type=int, help="Resize width used for faster auto-corner detection.")
    parser.add_argument("--corner-method", default="quadrants", choices=("bounds", "components", "quadrants"), help="quadrants picks one bright marker per corner; bounds uses bright-pixel extents; components chooses four nearest bright components.")
    args = parser.parse_args(argv)

    if args.corners is None and not args.auto_corners:
        parser.error("provide --corners or use --auto-corners")

    count = prepare_capture_set(
        args.input_dir,
        args.corners,
        args.out,
        args.roi_width,
        args.roi_height,
        parse_float_list(args.scales),
        parse_float_list(args.blurs),
        args.auto_corners,
        args.threshold,
        args.min_area,
        args.detect_width,
        args.corner_method,
    )
    print(f"Wrote {count} prepared image(s) to {args.out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
