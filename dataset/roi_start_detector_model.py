"""Software reference model for rtl/roi_start_detector.sv.

This model intentionally mirrors the V1 RTL state machine: thresholded pixel
runs, largest bright row band, and an axis-aligned ROI. It is used by the GUI
so human labels apply to the FPGA design, not a separate vision algorithm.
"""

from __future__ import annotations

from typing import Any

from PIL import Image


MAX_ROW_GAP = 2
GRID_SIZE = 8


def detect_roi(
    camera_image: Image.Image,
    threshold: int,
    min_line_run: int,
    min_roi_height: int,
) -> tuple[list[tuple[int, int] | None], dict[str, Any]]:
    if not 0 <= threshold <= 255:
        raise ValueError("threshold must be between 0 and 255")
    if min_line_run < 1 or min_roi_height < 1:
        raise ValueError("minimum line run and ROI height must be positive")

    image = camera_image.convert("L")
    pixels = image.load()
    qualifying_rows = 0
    current_band: dict[str, int] | None = None
    best_band: dict[str, int] | None = None

    def keep_tallest_band() -> None:
        nonlocal best_band
        if current_band is None:
            return
        height = current_band["bottom"] - current_band["top"] + 1
        if best_band is None or height > best_band["bottom"] - best_band["top"] + 1:
            best_band = current_band.copy()

    for y in range(image.height):
        run_start = 0
        run_length = 0
        longest_start = 0
        longest_length = 0
        for x in range(image.width):
            if pixels[x, y] >= threshold:
                if run_length == 0:
                    run_start = x
                run_length += 1
                if run_length > longest_length:
                    longest_start = run_start
                    longest_length = run_length
            else:
                run_length = 0

        if longest_length >= min_line_run:
            qualifying_rows += 1
            line_right = longest_start + longest_length - 1
            if current_band is None or y - current_band["last_y"] > MAX_ROW_GAP + 1:
                keep_tallest_band()
                current_band = {"left": longest_start, "right": line_right, "top": y, "bottom": y, "last_y": y}
            else:
                current_band["left"] = min(current_band["left"], longest_start)
                current_band["right"] = max(current_band["right"], line_right)
                current_band["bottom"] = y
                current_band["last_y"] = y
        elif current_band is not None and y - current_band["last_y"] > MAX_ROW_GAP:
            keep_tallest_band()
            current_band = None

    keep_tallest_band()
    diagnostics: dict[str, Any] = {
        "engine": "rtl/roi_start_detector.sv reference model",
        "algorithm": "thresholded-longest-bright-run-largest-row-band",
        "threshold": threshold,
        "min_line_run": min_line_run,
        "min_roi_height": min_roi_height,
        "max_row_gap": MAX_ROW_GAP,
        "qualifying_row_count": qualifying_rows,
    }
    if (
        best_band is None
        or best_band["right"] <= best_band["left"]
        or best_band["bottom"] - best_band["top"] + 1 < min_roi_height
    ):
        diagnostics["valid"] = False
        diagnostics["reason"] = "no tall enough continuous bright row band"
        return [None, None, None, None], diagnostics

    diagnostics.update({
        "valid": True,
        "roi_box": {"left": best_band["left"], "top": best_band["top"], "right": best_band["right"], "bottom": best_band["bottom"]},
        "roi_width": best_band["right"] - best_band["left"] + 1,
        "roi_height": best_band["bottom"] - best_band["top"] + 1,
    })
    return [
        (best_band["left"], best_band["top"]),
        (best_band["right"], best_band["top"]),
        (best_band["right"], best_band["bottom"]),
        (best_band["left"], best_band["bottom"]),
    ], diagnostics


def effective_threshold(camera_image: Image.Image, configured_threshold: int, peak_margin: int = 20) -> int:
    """Use a cheap per-frame peak estimate to tolerate a darker camera setup."""
    peak = camera_image.convert("L").getextrema()[1]
    return max(1, min(configured_threshold, peak - peak_margin))


def recover_data_roi(
    camera_image: Image.Image,
    threshold: int,
) -> tuple[list[tuple[int, int] | None], dict[str, Any]]:
    """Recover a DATA-frame grid from its overall bright-pixel footprint.

    DATA frames may have black corner cells, so they cannot rely on corner
    markers. This streaming-friendly fallback keeps only a bright-pixel count
    and four extrema registers. It deliberately rejects thin bright bands:
    those are payload fragments, not a full 8x8 grid.
    """
    image = camera_image.convert("L")
    # PIL executes these image-wide operations in native code. The equivalent
    # RTL remains a single streaming threshold/min/max datapath.
    bright_mask = image.point(lambda value: 255 if value >= threshold else 0)
    bounding_box = bright_mask.getbbox()
    bright_count = bright_mask.histogram()[255]

    diagnostics: dict[str, Any] = {
        "algorithm": "thresholded-bright-footprint-extrema",
        "threshold": threshold,
        "bright_pixel_count": bright_count,
    }
    if bounding_box is None:
        diagnostics.update({"valid": False, "reason": "no bright pixels"})
        return [None, None, None, None], diagnostics

    left, top, exclusive_right, exclusive_bottom = bounding_box
    right = exclusive_right - 1
    bottom = exclusive_bottom - 1

    width = right - left + 1
    height = bottom - top + 1
    min_width = max(1, image.width * 45 // 100)
    min_height = max(1, image.height * 45 // 100)
    diagnostics.update({
        "roi_box": {"left": left, "top": top, "right": right, "bottom": bottom},
        "roi_width": width,
        "roi_height": height,
        "minimum_width": min_width,
        "minimum_height": min_height,
    })
    if width < min_width or height < min_height:
        diagnostics.update({
            "valid": False,
            "reason": "bright footprint is too small for a full 8x8 data grid",
        })
        return [None, None, None, None], diagnostics

    diagnostics["valid"] = True
    return [(left, top), (right, top), (right, bottom), (left, bottom)], diagnostics


def track_corner_markers(
    camera_image: Image.Image,
    prior_roi: dict[str, int],
    threshold: int,
) -> tuple[list[tuple[int, int] | None], dict[str, Any]]:
    """Track white 8x8 grid corner cells using four fixed local windows.

    The hardware form is four non-overlapping counters plus sum-x/sum-y
    accumulators. It needs no frame buffer and uses the START ROI as its seed.
    """
    image = camera_image.convert("L")
    cell_width = max(1, (prior_roi["right"] - prior_roi["left"] + 1) // GRID_SIZE)
    cell_height = max(1, (prior_roi["bottom"] - prior_roi["top"] + 1) // GRID_SIZE)
    windows = (
        (prior_roi["left"], prior_roi["top"], prior_roi["left"] + cell_width - 1, prior_roi["top"] + cell_height - 1),
        (prior_roi["right"] - cell_width + 1, prior_roi["top"], prior_roi["right"], prior_roi["top"] + cell_height - 1),
        (prior_roi["right"] - cell_width + 1, prior_roi["bottom"] - cell_height + 1, prior_roi["right"], prior_roi["bottom"]),
        (prior_roi["left"], prior_roi["bottom"] - cell_height + 1, prior_roi["left"] + cell_width - 1, prior_roi["bottom"]),
    )
    pixels = image.load()
    accumulators = [{"count": 0, "sum_x": 0, "sum_y": 0} for _ in windows]
    for index, (left, top, right, bottom) in enumerate(windows):
        for y in range(max(0, top), min(image.height - 1, bottom) + 1):
            for x in range(max(0, left), min(image.width - 1, right) + 1):
                if pixels[x, y] >= threshold:
                    accumulators[index]["count"] += 1
                    accumulators[index]["sum_x"] += x
                    accumulators[index]["sum_y"] += y

    min_marker_pixels = max(4, (cell_width * cell_height) // 20)
    centers: list[tuple[int, int] | None] = []
    for accumulator in accumulators:
        if accumulator["count"] < min_marker_pixels:
            centers.append(None)
        else:
            centers.append((accumulator["sum_x"] // accumulator["count"], accumulator["sum_y"] // accumulator["count"]))

    left_centers = [point[0] for point in (centers[0], centers[3]) if point is not None]
    right_centers = [point[0] for point in (centers[1], centers[2]) if point is not None]
    top_centers = [point[1] for point in (centers[0], centers[1]) if point is not None]
    bottom_centers = [point[1] for point in (centers[2], centers[3]) if point is not None]
    diagnostics: dict[str, Any] = {
        "algorithm": "four-fixed-corner-marker-windows",
        "threshold": threshold,
        "prior_roi": prior_roi,
        "cell_width": cell_width,
        "cell_height": cell_height,
        "minimum_marker_pixels": min_marker_pixels,
        "accumulators": accumulators,
        "marker_centers": {name: None if point is None else list(point) for name, point in zip(("tl", "tr", "br", "bl"), centers)},
    }
    if not left_centers or not right_centers or not top_centers or not bottom_centers:
        diagnostics["valid"] = False
        diagnostics["reason"] = "fewer than one usable marker on a required ROI side"
        return [None, None, None, None], diagnostics

    estimated_cell_width = max(1, round((sum(right_centers) / len(right_centers) - sum(left_centers) / len(left_centers)) / (GRID_SIZE - 1)))
    estimated_cell_height = max(1, round((sum(bottom_centers) / len(bottom_centers) - sum(top_centers) / len(top_centers)) / (GRID_SIZE - 1)))
    left = round(sum(left_centers) / len(left_centers) - estimated_cell_width / 2)
    right = round(sum(right_centers) / len(right_centers) + estimated_cell_width / 2)
    top = round(sum(top_centers) / len(top_centers) - estimated_cell_height / 2)
    bottom = round(sum(bottom_centers) / len(bottom_centers) + estimated_cell_height / 2)
    diagnostics.update({
        "valid": True,
        "roi_box": {"left": left, "top": top, "right": right, "bottom": bottom},
        "roi_width": right - left + 1,
        "roi_height": bottom - top + 1,
    })
    return [(left, top), (right, top), (right, bottom), (left, bottom)], diagnostics


def detect_frame_roi(
    camera_image: Image.Image,
    configured_threshold: int,
    min_line_run: int,
    min_roi_height: int,
    prior_roi: dict[str, int] | None,
) -> tuple[list[tuple[int, int] | None], dict[str, Any], dict[str, int] | None]:
    """Choose START-frame acquisition or DATA/END marker tracking."""
    threshold = effective_threshold(camera_image, configured_threshold)
    start_corners, start = detect_roi(camera_image, threshold, min_line_run, min_roi_height)
    start_area = start.get("roi_width", 0) * start.get("roi_height", 0)
    large_start = start.get("valid", False) and start_area >= camera_image.width * camera_image.height // 3
    if prior_roi is None or large_start:
        start["mode"] = "start-acquisition"
        start["configured_threshold"] = configured_threshold
        start["effective_threshold"] = threshold
        return start_corners, start, start.get("roi_box") if start.get("valid") else prior_roi

    corners, marker = track_corner_markers(camera_image, prior_roi, threshold)
    marker.update({
        "engine": "rtl/roi_start_detector.sv reference model plus corner-marker tracker",
        "mode": "data-marker-tracking",
        "configured_threshold": configured_threshold,
        "effective_threshold": threshold,
    })
    if marker.get("valid"):
        return corners, marker, marker["roi_box"]

    recovered_corners, recovery = recover_data_roi(camera_image, threshold)
    recovery.update({
        "engine": "streaming DATA footprint recovery after corner-marker tracking",
        "mode": "data-footprint-recovery",
        "configured_threshold": configured_threshold,
        "effective_threshold": threshold,
        "corner_marker_attempt": marker,
    })
    if recovery.get("valid"):
        return recovered_corners, recovery, recovery["roi_box"]

    held = dict(prior_roi)
    recovery.update({
        "valid": True,
        "mode": "hold-prior-roi",
        "roi_box": held,
        "roi_width": held["right"] - held["left"] + 1,
        "roi_height": held["bottom"] - held["top"] + 1,
        "reason": "no reliable DATA footprint; retained the START-calibrated ROI",
    })
    held_corners = [
        (held["left"], held["top"]),
        (held["right"], held["top"]),
        (held["right"], held["bottom"]),
        (held["left"], held["bottom"]),
    ]
    return held_corners, recovery, held
