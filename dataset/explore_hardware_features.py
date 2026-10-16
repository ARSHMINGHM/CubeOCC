#!/usr/bin/env python3
"""Explore additional FPGA-friendly grayscale cell features.

Every learned model is evaluated by leave-one-capture-set-out validation. The
feature search is exploratory and uses the existing corpus, so its winner must
still be confirmed on a new untouched exact-ground-truth capture session.
"""
import argparse
import json
import sys
import time
from pathlib import Path

import numpy as np

sys.path.insert(0, str(Path(__file__).resolve().parent))
import cell_error_report as cer
import svm_cv_report as scv

H, W = 15, 20
YY, XX = np.mgrid[0:H, 0:W]
DIST2 = (XX - 10) ** 2 + (YY - 7) ** 2
MASKS = {
    "r3": DIST2 <= 9,
    "r4": DIST2 <= 16,
    "r5": DIST2 <= 25,
    "r6": DIST2 <= 36,
    "ring35": (DIST2 > 9) & (DIST2 <= 25),
    "square5": (np.abs(XX - 10) <= 2) & (np.abs(YY - 7) <= 2),
}
CORNERS = {0, 7, 56, 63}

FEATURE_COST = {
    "mean_r3": "one alternate circle sum",
    "mean_r4": "one alternate circle sum",
    "mean_r5": "existing cell sum",
    "mean_r6": "one larger circle sum",
    "ring35": "r5 sum minus r3 sum",
    "square5": "one 5x5 box sum",
    "core_ring_delta": "r3 and ring sums plus subtract",
    "trimmed_r5": "existing sum plus min/max trackers",
    "var_r5": "sum of squares plus square arithmetic",
    "range_r5": "min/max trackers",
    "grad_x": "adjacent absolute differences",
    "grad_y": "line delay plus absolute differences",
    "bright_fraction_50": "compare to 50% START threshold plus counter",
    "bright_fraction_60": "compare to 60% START threshold plus counter",
    "bright_fraction_70": "compare to 70% START threshold plus counter",
    "bright_fraction_80": "compare to 80% START threshold plus counter",
    "dark_fraction_20": "compare to 20% START threshold plus counter",
    "dark_fraction_25": "compare to 25% START threshold plus counter (shift only)",
    "dark_fraction_30": "compare to 30% START threshold plus counter",
    "dark_fraction_375": "compare to 37.5% START threshold plus counter (shift/add)",
    "dark_fraction_40": "compare to 40% START threshold plus counter",
    "dark_fraction_50": "compare to 50% START threshold plus counter",
    "neighbor_r5": "existing neighbor sum",
}


def cell_blocks(image):
    return [image[r*H:(r+1)*H, c*W:(c+1)*W].astype(float)
            for r in range(8) for c in range(8)]


def mask_mean(block, mask):
    return float(block[mask].mean())


def raw_features(block, white):
    eps = max(white["r5"], 1.0)
    values = {name: mask_mean(block, mask) for name, mask in MASKS.items()}
    p = block[MASKS["r5"]]
    threshold_white = max(white["r5"], 1.0)
    # Gradients are restricted to pairs whose endpoints are both in r5.
    mx = MASKS["r5"][:, 1:] & MASKS["r5"][:, :-1]
    my = MASKS["r5"][1:, :] & MASKS["r5"][:-1, :]
    gx = np.abs(block[:, 1:] - block[:, :-1])[mx].mean()
    gy = np.abs(block[1:, :] - block[:-1, :])[my].mean()
    return {
        "mean_r3": values["r3"] / max(white["r3"], 1.0),
        "mean_r4": values["r4"] / max(white["r4"], 1.0),
        "mean_r5": values["r5"] / eps,
        "mean_r6": values["r6"] / max(white["r6"], 1.0),
        "ring35": values["ring35"] / max(white["ring35"], 1.0),
        "square5": values["square5"] / max(white["square5"], 1.0),
        "core_ring_delta": values["r3"] / max(white["r3"], 1.0)
                           - values["ring35"] / max(white["ring35"], 1.0),
        "trimmed_r5": (p.sum() - p.min() - p.max()) / max((len(p)-2)*eps, 1.0),
        "var_r5": float(p.var()) / (eps * eps),
        "range_r5": float(p.max() - p.min()) / eps,
        "grad_x": float(gx) / eps,
        "grad_y": float(gy) / eps,
        "bright_fraction_50": float(np.mean(p >= 0.50 * threshold_white)),
        "bright_fraction_60": float(np.mean(p >= 0.60 * threshold_white)),
        "bright_fraction_70": float(np.mean(p >= 0.70 * threshold_white)),
        "bright_fraction_80": float(np.mean(p >= 0.80 * threshold_white)),
        "dark_fraction_20": float(np.mean(p <= 0.20 * threshold_white)),
        "dark_fraction_25": float(np.mean(p <= 0.25 * threshold_white)),
        "dark_fraction_30": float(np.mean(p <= 0.30 * threshold_white)),
        "dark_fraction_375": float(np.mean(p <= 0.375 * threshold_white)),
        "dark_fraction_40": float(np.mean(p <= 0.40 * threshold_white)),
        "dark_fraction_50": float(np.mean(p <= 0.50 * threshold_white)),
    }


def build(args):
    import pandas as pd
    from PIL import Image

    by = cer.load_frames(args.frames, args.grades)
    gold = cer.golden_from_jsonl(args.golden_jsonl) if args.golden_jsonl else cer.golden_from_votes(by)
    gold_cells = [np.array([int(ch) for ch in g[::-1]]) for g in gold]
    rows = []
    for capture_set, frames in by.items():
        alignment = cer.align(frames, gold)
        start_refs = None
        for frame, gidx in zip(frames, alignment):
            p = Path(args.image_dir) / frame["key"]
            if gidx == 0 and p.exists():
                start_blocks = cell_blocks(np.array(Image.open(p).convert("L")))
                start_refs = [{name: mask_mean(b, mask) for name, mask in MASKS.items()}
                              for b in start_blocks]
                break
        if start_refs is None:
            continue
        for frame, gidx in zip(frames, alignment):
            p = Path(args.image_dir) / frame["key"]
            if not p.exists() or not (1 <= gidx <= 11):
                continue
            blocks = cell_blocks(np.array(Image.open(p).convert("L")))
            frame_features = [raw_features(blocks[c], start_refs[c]) for c in range(64)]
            raw_means = np.array([mask_mean(blocks[c], MASKS["r5"]) for c in range(64)])
            raw_neighbors = scv.neighbor_mean(raw_means)
            for cell in range(64):
                if cell in CORNERS:
                    continue
                rows.append({"set": capture_set, "key": frame["key"], "gidx": gidx,
                             "cell": cell, "y": int(gold_cells[gidx][cell]),
                             **frame_features[cell],
                             "neighbor_r5": raw_neighbors[cell] / max(start_refs[cell]["r5"], 1.0)})
    return pd.DataFrame(rows)


def evaluate(df, columns, return_predictions=False):
    from sklearn.pipeline import make_pipeline
    from sklearn.preprocessing import StandardScaler
    from sklearn.svm import LinearSVC

    X = df[list(columns)].to_numpy(float)
    y = df["y"].to_numpy(int)
    pred = np.zeros(len(df), dtype=int)
    start = time.perf_counter()
    for held in sorted(df["set"].unique()):
        train = (df["set"] != held).to_numpy()
        test = ~train
        model = make_pipeline(StandardScaler(), LinearSVC(C=1.0, max_iter=20000))
        model.fit(X[train], y[train])
        pred[test] = model.predict(X[test])
    errors = int(np.sum(pred != y))
    result = {"errors": errors, "cells": int(len(y)),
              "error_percent": 100.0 * errors / len(y),
              "host_cv_seconds": time.perf_counter() - start}
    return (result, pred, y) if return_predictions else result


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--frames", required=True)
    ap.add_argument("--grades")
    ap.add_argument("--image-dir", required=True)
    ap.add_argument("--golden-jsonl")
    ap.add_argument("--out", default="hardware_feature_exploration")
    args = ap.parse_args()
    out = Path(args.out); out.mkdir(parents=True, exist_ok=True)

    df = build(args).reset_index(drop=True)
    base = ["mean_r5", "neighbor_r5"]
    candidates = [c for c in FEATURE_COST if c not in base]
    cases = []

    def run(name, columns, family):
        print(f"evaluating {name}")
        cases.append({"name": name, "features": list(columns), "family": family,
                      **evaluate(df, columns),
                      "feature_cost": [FEATURE_COST[c] for c in columns]})

    run("baseline mean_r5 + neighbor", base, "baseline")
    for feature in candidates:
        run(f"baseline + {feature}", base + [feature], "single_addition")
    for radius in ("mean_r3", "mean_r4", "mean_r5", "mean_r6", "square5"):
        run(f"{radius} only", [radius], "single_radius")
        run(f"{radius} + neighbor", [radius, "neighbor_r5"], "radius_neighbor")

    histogram_sets = [
        ["dark_fraction_20", "dark_fraction_30"],
        ["dark_fraction_20", "dark_fraction_30", "trimmed_r5"],
        ["dark_fraction_20", "dark_fraction_30", "dark_fraction_40"],
        ["dark_fraction_20", "dark_fraction_30", "dark_fraction_375"],
        ["dark_fraction_20", "dark_fraction_30", "dark_fraction_40", "trimmed_r5"],
    ]
    for additions in histogram_sets:
        run("baseline + " + " + ".join(additions), base + additions, "dark_histogram")

    # Greedy forward selection from the baseline, using this corpus only as an
    # exploratory ranking. The final choice still needs untouched validation.
    selected = list(base)
    remaining = set(candidates)
    best_error = next(c["error_percent"] for c in cases if c["family"] == "baseline")
    for step in range(1, 4):
        scored = []
        for feature in sorted(remaining):
            metric = evaluate(df, selected + [feature])
            scored.append((metric["error_percent"], feature, metric))
        candidate_error, best, metric = min(scored, key=lambda x: x[0])
        if candidate_error >= best_error:
            break
        selected.append(best); remaining.remove(best)
        best_error = candidate_error
        cases.append({"name": f"greedy step {step}: {' + '.join(selected)}",
                      "features": list(selected), "family": "greedy", **metric,
                      "feature_cost": [FEATURE_COST[c] for c in selected]})

    import matplotlib
    matplotlib.use("Agg")
    import matplotlib.pyplot as plt
    import pandas as pd

    table = pd.DataFrame(cases).sort_values("error_percent")
    table.to_csv(out / "feature_cases.csv", index=False)
    corr = df[list(FEATURE_COST)].corr()
    corr.to_csv(out / "feature_correlation.csv")

    labels = [name.replace("_fraction_", "\nfrac ").replace("_", "\n")
              for name in FEATURE_COST]
    fig, ax = plt.subplots(figsize=(17, 15), dpi=150)
    image = ax.imshow(corr.to_numpy(), cmap="coolwarm", vmin=-1.0, vmax=1.0)
    ax.set_xticks(range(len(labels)), labels, rotation=90, fontsize=7)
    ax.set_yticks(range(len(labels)), labels, fontsize=7)
    ax.set_title("Correlation of all 23 FPGA-friendly candidate features")
    colorbar = fig.colorbar(image, ax=ax, fraction=0.046, pad=0.04)
    colorbar.set_label("Pearson correlation")
    fig.tight_layout()
    fig.savefig(out / "feature_correlation_heatmap.png", bbox_inches="tight")
    plt.close(fig)

    (out / "summary.json").write_text(json.dumps({
        "cells": int(len(df)), "capture_sets": int(df["set"].nunique()),
        "golden_source": "sender_jsonl" if args.golden_jsonl else "all-set majority vote",
        "feature_cost": FEATURE_COST, "cases": cases,
        "warning": "Exploratory feature selection on the existing corpus; confirm once on untouched exact truth."
    }, indent=2), encoding="utf-8")

    shown = table.head(18).sort_values("error_percent", ascending=False)
    fig, ax = plt.subplots(figsize=(12, 8), dpi=140)
    ax.barh(shown["name"], shown["error_percent"], color="#1976d2")
    ax.set(xlabel="LOCO cell error (%)", title="FPGA-friendly feature candidates")
    for i, value in enumerate(shown["error_percent"]):
        ax.text(value + .003, i, f"{value:.3f}%", va="center", fontsize=9)
    fig.tight_layout(); fig.savefig(out / "feature_candidate_errors.png", bbox_inches="tight")
    plt.close(fig)
    print(table[["name", "errors", "error_percent"]].head(20).to_string(index=False))
    print(f"wrote {out}")


if __name__ == "__main__":
    main()
