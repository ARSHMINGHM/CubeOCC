"""Software reference model for rtl/roi_start_detector.sv.

This model intentionally mirrors the V1 RTL state machine: thresholded pixel
runs, independent coherent left/right edge tracks, and local DATA markers. It
is used by the GUI so labels apply to the FPGA design, not another detector.
"""

from __future__ import annotations

from math import hypot
from typing import Any

from PIL import Image


MAX_ROW_GAP = 2
MAX_EDGE_STEP = 2
MAX_CORNER_SHIFT = 10
THRESHOLD_MARGIN = 32
START_THRESHOLD_MARGIN = 68
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
    current_edges: dict[str, dict[str, int] | None] = {"left": None, "right": None}
    best_edges: dict[str, dict[str, int] | None] = {"left": None, "right": None}

    def keep_longest_edge(side: str) -> None:
        candidate = current_edges[side]
        if candidate is None:
            return
        best = best_edges[side]
        height = candidate["bottom_y"] - candidate["top_y"] + 1
        if best is None or height > best["bottom_y"] - best["top_y"] + 1:
            best_edges[side] = candidate.copy()

    def update_edge(side: str, edge_x: int, y: int) -> None:
        current = current_edges[side]
        coherent = (
            current is not None
            and y - current["last_y"] <= MAX_ROW_GAP + 1
            and abs(edge_x - current["bottom_x"]) <= MAX_EDGE_STEP
        )
        if not coherent:
            keep_longest_edge(side)
            current_edges[side] = {
                "top_x": edge_x, "top_y": y,
                "bottom_x": edge_x, "bottom_y": y,
                "last_y": y,
            }
        else:
            current["bottom_x"] = edge_x
            current["bottom_y"] = y
            current["last_y"] = y

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
            update_edge("left", longest_start, y)
            update_edge("right", line_right, y)
        else:
            for side in ("left", "right"):
                current = current_edges[side]
                if current is not None and y - current["last_y"] > MAX_ROW_GAP:
                    keep_longest_edge(side)
                    current_edges[side] = None

    keep_longest_edge("left")
    keep_longest_edge("right")
    left_edge = best_edges["left"]
    right_edge = best_edges["right"]
    diagnostics: dict[str, Any] = {
        "engine": "rtl/roi_start_detector.sv reference model",
        "algorithm": "independent-coherent-left-right-edge-tracks",
        "threshold": threshold,
        "min_line_run": min_line_run,
        "min_roi_height": min_roi_height,
        "max_row_gap": MAX_ROW_GAP,
        "max_edge_step": MAX_EDGE_STEP,
        "qualifying_row_count": qualifying_rows,
    }
    if (
        left_edge is None
        or right_edge is None
        or right_edge["top_x"] <= left_edge["top_x"]
        or left_edge["bottom_y"] - left_edge["top_y"] + 1 < min_roi_height
        or right_edge["bottom_y"] - right_edge["top_y"] + 1 < min_roi_height
    ):
        diagnostics["valid"] = False
        diagnostics["reason"] = "no tall enough continuous bright row band"
        return [None, None, None, None], diagnostics

    corners = [
        (left_edge["top_x"], left_edge["top_y"]),
        (right_edge["top_x"], right_edge["top_y"]),
        (right_edge["bottom_x"], right_edge["bottom_y"]),
        (left_edge["bottom_x"], left_edge["bottom_y"]),
    ]
    left = min(point[0] for point in corners)
    right = max(point[0] for point in corners)
    top = min(point[1] for point in corners)
    bottom = max(point[1] for point in corners)
    diagnostics.update({
        "valid": True,
        "roi_box": {"left": left, "top": top, "right": right, "bottom": bottom},
        "roi_width": right - left + 1,
        "roi_height": bottom - top + 1,
    })
    return corners, diagnostics


def effective_threshold(camera_image: Image.Image, configured_threshold: int, peak_margin: int = THRESHOLD_MARGIN) -> int:
    """Mirror the RTL's fixed low-cost threshold margin, not image statistics."""
    del camera_image
    return max(1, configured_threshold - peak_margin)


def _bright_mask(camera_image: Image.Image, threshold: int) -> Image.Image:
    return camera_image.convert("L").point(lambda value: 255 if value >= threshold else 0)


def _outside_corner_points(
    camera_image: Image.Image,
    threshold: int,
) -> tuple[list[tuple[int, int]] | None, dict[str, Any]]:
    """Find grid corners from the four outside bright row/column combinations.

    The top-left point minimizes ``x+y``. Top-right minimizes ``-x+y``;
    bottom-right maximizes ``x+y``; bottom-left minimizes ``x-y``. These are
    the four diagonal forms of "earliest/latest row plus earliest/latest
    column", so they still form a quadrilateral when the camera is angled.
    """
    bright_mask = _bright_mask(camera_image, threshold)
    bounding_box = bright_mask.getbbox()
    bright_count = bright_mask.histogram()[255]
    diagnostics: dict[str, Any] = {
        "algorithm": "outside-bright-diagonal-extrema-corners",
        "threshold": threshold,
        "bright_pixel_count": bright_count,
    }
    if bounding_box is None:
        diagnostics.update({"valid": False, "reason": "no bright pixels"})
        return None, diagnostics

    left, top, exclusive_right, exclusive_bottom = bounding_box
    right = exclusive_right - 1
    bottom = exclusive_bottom - 1
    pixels = bright_mask.load()
    best = {
        "tl": (float("inf"), (0, 0)),
        "tr": (float("inf"), (0, 0)),
        "br": (float("-inf"), (0, 0)),
        "bl": (float("inf"), (0, 0)),
    }
    for y in range(top, bottom + 1):
        for x in range(left, right + 1):
            if pixels[x, y] == 0:
                continue
            score_sum = x + y
            candidates = {
                "tl": score_sum,
                "tr": y - x,
                "br": score_sum,
                "bl": x - y,
            }
            if candidates["tl"] < best["tl"][0]:
                best["tl"] = (candidates["tl"], (x, y))
            if candidates["tr"] < best["tr"][0]:
                best["tr"] = (candidates["tr"], (x, y))
            if candidates["br"] > best["br"][0]:
                best["br"] = (candidates["br"], (x, y))
            if candidates["bl"] < best["bl"][0]:
                best["bl"] = (candidates["bl"], (x, y))

    corners = [best[name][1] for name in ("tl", "tr", "br", "bl")]
    diagnostics.update({
        "roi_box": {"left": left, "top": top, "right": right, "bottom": bottom},
        "roi_width": right - left + 1,
        "roi_height": bottom - top + 1,
        "outside_corners": {name: list(point) for name, point in zip(("tl", "tr", "br", "bl"), corners)},
    })
    return corners, diagnostics


def _local_marker_corners(
    camera_image: Image.Image,
    threshold: int,
    previous_corners: list[tuple[int, int]],
    roi_box: dict[str, int],
) -> tuple[list[tuple[int, int]] | None, dict[str, Any]]:
    """Mirror the RTL's bounded multi-row bright-box marker searches.

    A marker is accepted only when several nearby rows contain a sufficiently
    long bright run. That rejects isolated specks that appear before a real
    corner box while still allowing a skewed box to move its horizontal run
    gradually from row to row.
    """
    image = camera_image.convert("L")
    pixels = image.load()
    allowed_shift = MAX_CORNER_SHIFT
    marker_min_span = max(3, min(roi_box["right"] - roi_box["left"] + 1, roi_box["bottom"] - roi_box["top"] + 1) // 32)

    def largest_marker_band(old_x: int, old_y: int) -> dict[str, int] | None:
        left_limit = max(0, old_x - allowed_shift)
        right_limit = min(image.width - 1, old_x + allowed_shift)
        top_limit = max(0, old_y - allowed_shift)
        bottom_limit = min(image.height - 1, old_y + allowed_shift)
        active: dict[str, int] | None = None
        best: dict[str, int] | None = None

        def retain(candidate: dict[str, int] | None) -> None:
            nonlocal best
            if candidate is not None and (best is None or candidate["rows"] > best["rows"]):
                best = candidate.copy()

        for y in range(top_limit, bottom_limit + 1):
            longest_start = 0
            longest_length = 0
            run_start = 0
            run_length = 0
            for x in range(left_limit, right_limit + 1):
                if pixels[x, y] >= threshold:
                    if run_length == 0:
                        run_start = x
                    run_length += 1
                    if run_length >= longest_length:
                        longest_start = run_start
                        longest_length = run_length
                else:
                    run_length = 0

            if longest_length >= marker_min_span:
                right = longest_start + longest_length - 1
                if active is None or y - active["last_y"] > MAX_ROW_GAP + 1:
                    retain(active)
                    active = {"left": longest_start, "right": right, "top": y, "bottom": y, "last_y": y, "rows": 1}
                else:
                    active["left"] = min(active["left"], longest_start)
                    active["right"] = max(active["right"], right)
                    active["bottom"] = y
                    active["last_y"] = y
                    active["rows"] += 1
            elif active is not None and y - active["last_y"] > MAX_ROW_GAP:
                retain(active)
                active = None
        retain(active)
        if best is None:
            return None
        width = best["right"] - best["left"] + 1
        height = best["bottom"] - best["top"] + 1
        if best["rows"] < marker_min_span or width < marker_min_span or height < marker_min_span:
            return None
        return best

    boxes = {name: largest_marker_band(*point) for name, point in zip(("tl", "tr", "br", "bl"), previous_corners)}
    missing = [name for name, value in boxes.items() if value is None]
    diagnostics: dict[str, Any] = {
        "algorithm": "prior-roi-local-multi-row-bright-boxes",
        "threshold": threshold,
        "allowed_shift": allowed_shift,
        "minimum_marker_span": marker_min_span,
        "corner_boxes_seen": {name: value is not None for name, value in boxes.items()},
    }
    if missing:
        diagnostics.update({"valid": False, "reason": f"missing bright marker in local window(s): {', '.join(missing)}"})
        return None, diagnostics

    corners = [
        (boxes["tl"]["left"], boxes["tl"]["top"]),
        (boxes["tr"]["right"], boxes["tr"]["top"]),
        (boxes["br"]["right"], boxes["br"]["bottom"]),
        (boxes["bl"]["left"], boxes["bl"]["bottom"]),
    ]
    left = min(point[0] for point in corners)
    right = max(point[0] for point in corners)
    top = min(point[1] for point in corners)
    bottom = max(point[1] for point in corners)
    diagnostics.update({
        "valid": True,
        "roi_box": {"left": left, "top": top, "right": right, "bottom": bottom},
        "roi_width": right - left + 1,
        "roi_height": bottom - top + 1,
        "local_corners": {name: list(point) for name, point in zip(("tl", "tr", "br", "bl"), corners)},
    })
    return corners, diagnostics


def _full_white_start(
    camera_image: Image.Image,
    threshold: int,
    min_line_run: int,
    min_roi_height: int,
) -> tuple[list[tuple[int, int] | None], dict[str, Any]]:
    corners, diagnostics = detect_roi(camera_image, threshold, min_line_run, min_roi_height)
    roi_box = diagnostics.get("roi_box")
    if roi_box is None:
        diagnostics.update({"is_start": False, "white_coverage": 0.0})
        return corners, diagnostics
    mask = _bright_mask(camera_image, threshold)
    # A DATA pattern may contain one dense white row band. A valid START must
    # be dense *and* span a substantial width and height. This preserves
    # angled START screens, whose enclosing axis-aligned box includes black
    # triangular regions outside the perspective quadrilateral.
    crop = mask.crop((roi_box["left"], roi_box["top"], roi_box["right"] + 1, roi_box["bottom"] + 1))
    coverage = crop.histogram()[255] / max(1, diagnostics["roi_width"] * diagnostics["roi_height"])
    spans_screen = diagnostics["roi_width"] >= camera_image.width * 35 // 100 and diagnostics["roi_height"] >= camera_image.height * 35 // 100
    diagnostics.update({
        "white_coverage": round(coverage, 4),
        "spans_screen": spans_screen,
        "is_start": bool(diagnostics.get("valid") and coverage >= 0.75 and spans_screen),
    })
    return corners, diagnostics


def _full_off(camera_image: Image.Image, threshold: int, roi_box: dict[str, int]) -> bool:
    del roi_box
    return _bright_mask(camera_image, threshold).histogram()[255] == 0


def _corners_from_box(roi_box: dict[str, int]) -> list[tuple[int, int]]:
    return [
        (roi_box["left"], roi_box["top"]),
        (roi_box["right"], roi_box["top"]),
        (roi_box["right"], roi_box["bottom"]),
        (roi_box["left"], roi_box["bottom"]),
    ]


def _cell_radius(corners: list[tuple[int, int]]) -> int:
    perimeter = sum(
        hypot(
            corners[(index + 1) % 4][0] - point[0],
            corners[(index + 1) % 4][1] - point[1],
        )
        for index, point in enumerate(corners)
    )
    return max(4, round(perimeter / (GRID_SIZE * 8)))


def _plausible_corner_update(previous: list[tuple[int, int]], current: list[tuple[int, int]]) -> tuple[bool, float, int]:
    largest_shift = max(hypot(current[index][0] - point[0], current[index][1] - point[1]) for index, point in enumerate(previous))
    return largest_shift <= MAX_CORNER_SHIFT, round(largest_shift, 2), MAX_CORNER_SHIFT


def _tracker_state(previous: dict[str, Any] | None) -> dict[str, Any]:
    if previous is None:
        return {"phase": "waiting-for-start", "roi_box": None, "corners": None, "anchor_corners": None}
    if "phase" in previous:
        corners = previous.get("corners")
        anchors = previous.get("anchor_corners", corners)
        return {
            "phase": previous["phase"],
            "roi_box": previous.get("roi_box"),
            "corners": None if corners is None else [tuple(point) for point in corners],
            "anchor_corners": None if anchors is None else [tuple(point) for point in anchors],
        }
    # Compatibility with saved callers that previously passed only an ROI.
    if {"left", "top", "right", "bottom"}.issubset(previous):
        roi_box = dict(previous)
        corners = _corners_from_box(roi_box)
        return {"phase": "active", "roi_box": roi_box, "corners": corners, "anchor_corners": corners}
    return {"phase": "waiting-for-start", "roi_box": None, "corners": None, "anchor_corners": None}


def detect_frame_roi(
    camera_image: Image.Image,
    configured_threshold: int,
    min_line_run: int,
    min_roi_height: int,
    previous_state: dict[str, Any] | None,
) -> tuple[list[tuple[int, int] | None], dict[str, Any], dict[str, Any]]:
    """Track only one START-to-END transfer using outer marker boxes.

    Frames before a full-white START and frames after END/full-off are ignored.
    While active, the extrema of the four outside white marker boxes define
    the grid, and the prior accepted ROI is retained if a frame is ambiguous.
    """
    state = _tracker_state(previous_state)
    margin = START_THRESHOLD_MARGIN if state["phase"] != "active" else THRESHOLD_MARGIN
    threshold = effective_threshold(camera_image, configured_threshold, margin)
    start_corners, start = _full_white_start(camera_image, threshold, min_line_run, min_roi_height)
    common = {
        "engine": "START/DATA/END protocol-state outer-marker reference model",
        "configured_threshold": configured_threshold,
        "effective_threshold": threshold,
        "previous_phase": state["phase"],
    }

    # START is the only frame that may arm tracking from IDLE or after END.
    if state["phase"] != "active":
        if start.get("is_start"):
            # START is a dense bright rectangle. The row-band result is less
            # sensitive than diagonal extrema to a small bright reflection
            # outside the screen, so use it as the initial geometry seed.
            corners = start_corners
            start.update(common | {
                "valid": True,
                "mode": "start-acquisition",
                "phase": "active",
            })
            return corners, start, {
                "phase": "active",
                "roi_box": start["roi_box"],
                "corners": corners,
                "anchor_corners": corners,
            }
        ignored = common | {
            "valid": False,
            "mode": "ignored-waiting-for-full-white-start",
            "phase": "waiting-for-start",
            "reason": "frame is ignored until a full-white START is detected",
            "start_attempt": start,
        }
        return [None, None, None, None], ignored, {
            "phase": "waiting-for-start",
            "roi_box": None,
            "corners": None,
            "anchor_corners": None,
        }

    prior_roi = state["roi_box"]
    prior_corners = state["corners"]
    anchor_corners = state["anchor_corners"]
    assert prior_roi is not None and prior_corners is not None and anchor_corners is not None
    if _full_off(camera_image, threshold, prior_roi):
        stopped = common | {
            "valid": False,
            "mode": "full-off-end",
            "phase": "waiting-for-start",
            "reason": "full-off frame ended the active transfer",
            "roi_box": prior_roi,
        }
        return [None, None, None, None], stopped, {
            "phase": "waiting-for-start",
            "roi_box": None,
            "corners": None,
            "anchor_corners": None,
        }

    corners, outer = _local_marker_corners(camera_image, threshold, anchor_corners, prior_roi)
    outer.update(common)
    if corners is not None:
        plausible, largest_shift, tolerance = _plausible_corner_update(anchor_corners, corners)
        outer.update({"largest_anchor_shift": largest_shift, "anchor_tolerance": tolerance})
        if plausible:
            roi_box = outer["roi_box"]
            outer.update({"valid": True, "mode": "data-local-marker-corners", "phase": "active"})
            return corners, outer, {
                "phase": "active",
                "roi_box": roi_box,
                "corners": corners,
                "anchor_corners": anchor_corners,
            }

    held = dict(prior_roi)
    outer.update({
        "valid": True,
        "mode": "hold-prior-roi",
        "phase": "active",
        "roi_box": held,
        "roi_width": held["right"] - held["left"] + 1,
        "roi_height": held["bottom"] - held["top"] + 1,
        "reason": "local marker-corner update was absent or implausible; retained the prior accepted ROI",
    })
    return prior_corners, outer, {
        "phase": "active",
        "roi_box": held,
        "corners": prior_corners,
        "anchor_corners": anchor_corners,
    }
