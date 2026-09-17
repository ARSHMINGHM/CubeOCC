"""Compare XSim ROI corners with a robust software reference.

The reference is intentionally more capable than the streaming RTL.  For each
capture set it finds the large white START region, extracts its largest connected
component, fits four robust edge lines, and intersects those lines to obtain a
quadrilateral.  That fixed START quadrilateral is then compared with every RTL
frame in the set.  No human label is used to find the reference corners.
"""

from __future__ import annotations

import argparse
import csv
import json
import math
from collections import defaultdict, deque
from pathlib import Path
from typing import Any, Iterable

import numpy as np
from PIL import Image, ImageDraw


CORNER_NAMES = ("tl", "tr", "br", "bl")


def otsu_threshold(gray: np.ndarray) -> int:
    histogram = np.bincount(gray.ravel(), minlength=256).astype(np.float64)
    total = gray.size
    values = np.arange(256, dtype=np.float64)
    sum_total = float(np.dot(values, histogram))
    weight_background = 0.0
    sum_background = 0.0
    best_threshold = 0
    best_variance = -1.0
    for threshold in range(256):
        weight_background += histogram[threshold]
        if weight_background == 0:
            continue
        weight_foreground = total - weight_background
        if weight_foreground == 0:
            break
        sum_background += threshold * histogram[threshold]
        mean_background = sum_background / weight_background
        mean_foreground = (sum_total - sum_background) / weight_foreground
        variance = weight_background * weight_foreground * (mean_background - mean_foreground) ** 2
        if variance > best_variance:
            best_variance = variance
            best_threshold = threshold
    return best_threshold


def close_mask(mask: np.ndarray, passes: int = 1) -> np.ndarray:
    result = mask
    for _ in range(passes):
        padded = np.pad(result, 1, mode="constant")
        dilated = np.zeros_like(result)
        for dy in range(3):
            for dx in range(3):
                dilated |= padded[dy : dy + result.shape[0], dx : dx + result.shape[1]]
        padded = np.pad(dilated, 1, mode="constant", constant_values=True)
        eroded = np.ones_like(result)
        for dy in range(3):
            for dx in range(3):
                eroded &= padded[dy : dy + result.shape[0], dx : dx + result.shape[1]]
        result = eroded
    return result


def largest_component(mask: np.ndarray) -> np.ndarray:
    height, width = mask.shape
    visited = np.zeros_like(mask, dtype=bool)
    best: list[tuple[int, int]] = []
    for y, x in zip(*np.nonzero(mask)):
        if visited[y, x]:
            continue
        queue: deque[tuple[int, int]] = deque([(int(y), int(x))])
        visited[y, x] = True
        component: list[tuple[int, int]] = []
        while queue:
            cy, cx = queue.popleft()
            component.append((cy, cx))
            for dy in (-1, 0, 1):
                for dx in (-1, 0, 1):
                    if dx == 0 and dy == 0:
                        continue
                    ny, nx = cy + dy, cx + dx
                    if 0 <= ny < height and 0 <= nx < width and mask[ny, nx] and not visited[ny, nx]:
                        visited[ny, nx] = True
                        queue.append((ny, nx))
        if len(component) > len(best):
            best = component
    output = np.zeros_like(mask, dtype=bool)
    if best:
        ys, xs = zip(*best)
        output[np.asarray(ys), np.asarray(xs)] = True
    return output


def robust_line(independent: np.ndarray, dependent: np.ndarray) -> tuple[float, float]:
    keep = np.ones(independent.size, dtype=bool)
    for _ in range(4):
        if int(keep.sum()) < 4:
            break
        slope, intercept = np.polyfit(independent[keep], dependent[keep], 1)
        residual = np.abs(dependent - (slope * independent + intercept))
        median = float(np.median(residual[keep]))
        mad = float(np.median(np.abs(residual[keep] - median)))
        limit = max(1.5, median + 3.5 * max(mad, 0.25))
        new_keep = residual <= limit
        if np.array_equal(new_keep, keep):
            break
        keep = new_keep
    slope, intercept = np.polyfit(independent[keep], dependent[keep], 1)
    return float(slope), float(intercept)


def intersect_x_of_y_with_y_of_x(
    x_slope: float,
    x_intercept: float,
    y_slope: float,
    y_intercept: float,
) -> tuple[float, float]:
    denominator = 1.0 - x_slope * y_slope
    if abs(denominator) < 1e-6:
        raise ValueError("nearly parallel fitted edges")
    x = (x_slope * y_intercept + x_intercept) / denominator
    y = y_slope * x + y_intercept
    return x, y


def detect_start_quad(image_path: Path) -> tuple[list[tuple[float, float]], dict[str, Any]]:
    gray = np.asarray(Image.open(image_path).convert("L"), dtype=np.uint8)
    otsu = otsu_threshold(gray)
    # Otsu separates the illuminated display from the dark room/monitor.  A
    # small margin rejects frame texture without clipping the dimmer side of a
    # perspective-skewed display, which a high percentile threshold can do.
    threshold = max(24, min(200, otsu + 10))
    component = largest_component(close_mask(gray >= threshold))
    area = int(component.sum())
    if area < max(64, gray.size // 100):
        raise ValueError(f"largest bright component is too small ({area} pixels)")

    row_y: list[int] = []
    row_left: list[int] = []
    row_right: list[int] = []
    widths: list[int] = []
    for y in range(component.shape[0]):
        xs = np.flatnonzero(component[y])
        if xs.size:
            row_y.append(y)
            row_left.append(int(xs[0]))
            row_right.append(int(xs[-1]))
            widths.append(int(xs[-1] - xs[0] + 1))
    width_cutoff = max(6, int(np.percentile(widths, 65) * 0.55))
    row_keep = np.asarray(widths) >= width_cutoff
    ys = np.asarray(row_y, dtype=np.float64)[row_keep]
    lefts = np.asarray(row_left, dtype=np.float64)[row_keep]
    rights = np.asarray(row_right, dtype=np.float64)[row_keep]

    col_x: list[int] = []
    col_top: list[int] = []
    col_bottom: list[int] = []
    heights: list[int] = []
    for x in range(component.shape[1]):
        ys_at_x = np.flatnonzero(component[:, x])
        if ys_at_x.size:
            col_x.append(x)
            col_top.append(int(ys_at_x[0]))
            col_bottom.append(int(ys_at_x[-1]))
            heights.append(int(ys_at_x[-1] - ys_at_x[0] + 1))
    height_cutoff = max(6, int(np.percentile(heights, 65) * 0.55))
    col_keep = np.asarray(heights) >= height_cutoff
    xs = np.asarray(col_x, dtype=np.float64)[col_keep]
    tops = np.asarray(col_top, dtype=np.float64)[col_keep]
    bottoms = np.asarray(col_bottom, dtype=np.float64)[col_keep]

    if min(ys.size, xs.size) < 8:
        raise ValueError("not enough edge samples for a quadrilateral")

    left_line = robust_line(ys, lefts)
    right_line = robust_line(ys, rights)
    top_line = robust_line(xs, tops)
    bottom_line = robust_line(xs, bottoms)
    corners = [
        intersect_x_of_y_with_y_of_x(*left_line, *top_line),
        intersect_x_of_y_with_y_of_x(*right_line, *top_line),
        intersect_x_of_y_with_y_of_x(*right_line, *bottom_line),
        intersect_x_of_y_with_y_of_x(*left_line, *bottom_line),
    ]
    height, width = gray.shape
    corners = [
        (float(np.clip(x, 0, width - 1)), float(np.clip(y, 0, height - 1)))
        for x, y in corners
    ]
    diagnostics = {
        "threshold": threshold,
        "otsu_threshold": otsu,
        "component_area": area,
        "component_fraction": area / gray.size,
        "row_edge_samples": int(ys.size),
        "column_edge_samples": int(xs.size),
    }
    return corners, diagnostics


def rtl_corners(record: dict[str, Any]) -> list[tuple[float, float]] | None:
    raw = record.get("camera_corners")
    if not raw or any(raw.get(name) is None for name in CORNER_NAMES):
        return None
    return [(float(raw[name][0]), float(raw[name][1])) for name in CORNER_NAMES]


def bounding_box(corners: Iterable[tuple[float, float]]) -> tuple[float, float, float, float]:
    points = list(corners)
    xs = [point[0] for point in points]
    ys = [point[1] for point in points]
    return min(xs), min(ys), max(xs), max(ys)


def box_iou(first: tuple[float, float, float, float], second: tuple[float, float, float, float]) -> float:
    left = max(first[0], second[0])
    top = max(first[1], second[1])
    right = min(first[2], second[2])
    bottom = min(first[3], second[3])
    intersection = max(0.0, right - left + 1.0) * max(0.0, bottom - top + 1.0)
    first_area = max(0.0, first[2] - first[0] + 1.0) * max(0.0, first[3] - first[1] + 1.0)
    second_area = max(0.0, second[2] - second[0] + 1.0) * max(0.0, second[3] - second[1] + 1.0)
    union = first_area + second_area - intersection
    return intersection / union if union else 0.0


def load_labels(path: Path | None) -> dict[str, str]:
    if path is None or not path.exists():
        return {}
    data = json.loads(path.read_text(encoding="utf-8"))
    images = data.get("images", {})
    if isinstance(images, list):
        return {item["relative_path"]: item["grade"] for item in images}
    return {key.replace("\\", "/"): value["grade"] for key, value in images.items()}


def annotate(
    source: Path,
    destination: Path,
    reference: list[tuple[float, float]],
    rtl: list[tuple[float, float]] | None,
) -> None:
    image = Image.open(source).convert("RGB")
    draw = ImageDraw.Draw(image)
    for points, color, label in ((reference, "cyan", "PY"), (rtl, "red", "RTL")):
        if points is None:
            continue
        draw.line(points + [points[0]], fill=color, width=2)
        for index, (x, y) in enumerate(points):
            radius = 3
            draw.ellipse((x - radius, y - radius, x + radius, y + radius), outline=color, width=2)
            draw.text((x + 4, y + 2), f"{label}{index + 1}", fill=color)
    destination.parent.mkdir(parents=True, exist_ok=True)
    image.save(destination)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("result_dir", type=Path, help="XSim result folder containing rtl_results.json")
    parser.add_argument("--review", type=Path, help="Optional roi_review.json with human labels")
    parser.add_argument("--max-corner-error", type=float, default=10.0)
    parser.add_argument("--min-box-iou", type=float, default=0.80)
    args = parser.parse_args()

    result_dir = args.result_dir.resolve()
    manifest = json.loads((result_dir / "rtl_results.json").read_text(encoding="utf-8"))
    records = manifest["images"]
    review_path = args.review or result_dir / "roi_review" / "roi_review.json"
    labels = load_labels(review_path)
    groups: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for record in records:
        groups[record["capture_set"]].append(record)

    output_dir = result_dir / "python_reference"
    rows: list[dict[str, Any]] = []
    set_references: dict[str, Any] = {}
    for capture_set, group in sorted(groups.items()):
        group.sort(key=lambda item: item["relative_path"])
        start_record = max(
            group,
            key=lambda item: np.asarray(
                Image.open(result_dir / item["camera_gray_path"]).convert("L"), dtype=np.uint8
            ).mean(),
        )
        start_path = result_dir / start_record["camera_gray_path"]
        reference, diagnostics = detect_start_quad(start_path)
        set_references[capture_set] = {
            "start_frame": start_record["relative_path"],
            "corners": {name: [round(point[0], 3), round(point[1], 3)] for name, point in zip(CORNER_NAMES, reference)},
            "diagnostics": diagnostics,
        }
        for record in group:
            rtl = rtl_corners(record)
            distances = None if rtl is None else [math.dist(actual, expected) for actual, expected in zip(rtl, reference)]
            mean_error = None if distances is None else float(np.mean(distances))
            max_error = None if distances is None else max(distances)
            iou = 0.0 if rtl is None else box_iou(bounding_box(rtl), bounding_box(reference))
            problem = rtl is None or max_error > args.max_corner_error or iou < args.min_box_iou
            relative_path = record["relative_path"].replace("\\", "/")
            label = labels.get(relative_path)
            row = {
                "relative_path": relative_path,
                "capture_set": capture_set,
                "human_grade": label,
                "rtl_valid": rtl is not None,
                "mean_corner_error_px": mean_error,
                "max_corner_error_px": max_error,
                "box_iou": iou,
                "problem": problem,
                "python_corners": {name: list(point) for name, point in zip(CORNER_NAMES, reference)},
                "rtl_corners": None if rtl is None else {name: list(point) for name, point in zip(CORNER_NAMES, rtl)},
            }
            rows.append(row)
            annotate(
                result_dir / record["camera_gray_path"],
                output_dir / "annotated" / relative_path,
                reference,
                rtl,
            )

    labeled = [row for row in rows if row["human_grade"] is not None]
    expected_problem = [row for row in labeled if row["human_grade"] != "true"]
    expected_good = [row for row in labeled if row["human_grade"] == "true"]
    true_positive = sum(row["problem"] for row in expected_problem)
    true_negative = sum(not row["problem"] for row in expected_good)
    summary = {
        "capture_sets": len(groups),
        "frames": len(rows),
        "reference_failures": 0,
        "problems_flagged": sum(row["problem"] for row in rows),
        "labeled_frames": len(labeled),
        "human_true": len(expected_good),
        "human_mid_or_false": len(expected_problem),
        "problem_recall_on_mid_or_false": true_positive / len(expected_problem) if expected_problem else None,
        "good_acceptance_on_true": true_negative / len(expected_good) if expected_good else None,
        "max_corner_error_px": args.max_corner_error,
        "min_box_iou": args.min_box_iou,
    }
    output_dir.mkdir(parents=True, exist_ok=True)
    report = {
        "format": "cubeocc-python-roi-reference-v1",
        "source_manifest": str(result_dir / "rtl_results.json"),
        "review_manifest": str(review_path) if review_path.exists() else None,
        "summary": summary,
        "capture_references": set_references,
        "frames": rows,
    }
    (output_dir / "comparison.json").write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    with (output_dir / "comparison.csv").open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=[
            "relative_path", "capture_set", "human_grade", "rtl_valid",
            "mean_corner_error_px", "max_corner_error_px", "box_iou", "problem",
        ])
        writer.writeheader()
        writer.writerows({key: row[key] for key in writer.fieldnames} for row in rows)
    print(json.dumps(summary, indent=2))
    print(f"Wrote {output_dir / 'comparison.json'}")


if __name__ == "__main__":
    main()
