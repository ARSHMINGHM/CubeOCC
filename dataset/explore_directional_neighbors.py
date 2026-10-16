#!/usr/bin/env python3
"""Exhaustive directional-neighbor feature search for CubeOCC grayscale cells.

The search keeps capture sets intact during leave-one-capture-set-out (LOCO)
validation. It evaluates all 255 non-empty subsets of the eight surrounding
cells in two forms: separate directional SVM inputs and one pooled mean input.
The search is exploratory; a selected winner still needs a new untouched
capture session with exact sender ground truth.
"""
import argparse
import itertools
import json
import os
import time
from pathlib import Path

import numpy as np

import cell_error_report as cer
from explore_hardware_features import CORNERS, MASKS, cell_blocks, mask_mean


DIRECTIONS = {
    "n": (-1, 0), "ne": (-1, 1), "e": (0, 1), "se": (1, 1),
    "s": (1, 0), "sw": (1, -1), "w": (0, -1), "nw": (-1, -1),
}
AXIAL = ["n", "e", "s", "w"]
DIAGONAL = ["ne", "se", "sw", "nw"]


def directional_values(values, cell):
    """Return neighbor values and validity; absent directions fall back to self."""
    row, col = divmod(cell, 8)
    current = values[cell]
    out, valid = {}, {}
    for name, (dr, dc) in DIRECTIONS.items():
        rr, cc = row + dr, col + dc
        valid[name] = 0 <= rr < 8 and 0 <= cc < 8
        out[name] = values[rr * 8 + cc] if valid[name] else current
    return out, valid


def available(values, valid, names, fallback):
    selected = [values[name] for name in names if valid[name]]
    return np.asarray(selected if selected else [fallback], dtype=float)


def build(args):
    import pandas as pd
    from PIL import Image

    by = cer.load_frames(args.frames, args.grades)
    gold = cer.golden_from_jsonl(args.golden_jsonl) if args.golden_jsonl else cer.golden_from_votes(by)
    gold_cells = [np.array([int(ch) for ch in word[::-1]]) for word in gold]
    rows = []
    for capture_set, frames in by.items():
        alignment = cer.align(frames, gold)
        start_means = None
        for frame, gidx in zip(frames, alignment):
            path = Path(args.image_dir) / frame["key"]
            if gidx == 0 and path.exists():
                blocks = cell_blocks(np.array(Image.open(path).convert("L")))
                start_means = np.array([mask_mean(block, MASKS["r5"]) for block in blocks])
                break
        if start_means is None:
            continue

        for frame, gidx in zip(frames, alignment):
            path = Path(args.image_dir) / frame["key"]
            if not path.exists() or not (1 <= gidx <= 11):
                continue
            blocks = cell_blocks(np.array(Image.open(path).convert("L")))
            raw = np.array([mask_mean(block, MASKS["r5"]) for block in blocks])
            for cell in range(64):
                if cell in CORNERS:
                    continue
                white = max(start_means[cell], 1.0)
                center = raw[cell] / white
                neighbor_raw, valid = directional_values(raw, cell)
                direction = {name: value / white for name, value in neighbor_raw.items()}
                axial = available(direction, valid, AXIAL, center)
                diagonal = available(direction, valid, DIAGONAL, center)
                all_nb = available(direction, valid, list(DIRECTIONS), center)

                def pair_delta(a, b):
                    return abs(direction[a] - direction[b]) if valid[a] and valid[b] else 0.0

                row = {
                    "set": capture_set, "key": frame["key"], "gidx": gidx,
                    "cell": cell, "y": int(gold_cells[gidx][cell]), "center": center,
                    **{f"nb_{name}": direction[name] for name in DIRECTIONS},
                    **{f"has_{name}": int(valid[name]) for name in DIRECTIONS},
                    "neighbor_mean_all": float(all_nb.mean()),
                    "neighbor_mean_axial": float(axial.mean()),
                    "neighbor_mean_diagonal": float(diagonal.mean()),
                    "neighbor_var_all": float(all_nb.var()),
                    "neighbor_var_axial": float(axial.var()),
                    "neighbor_var_diagonal": float(diagonal.var()),
                    "neighbor_range_all": float(all_nb.max() - all_nb.min()),
                    "neighbor_range_axial": float(axial.max() - axial.min()),
                    "neighbor_range_diagonal": float(diagonal.max() - diagonal.min()),
                    "vertical_contrast": pair_delta("n", "s"),
                    "horizontal_contrast": pair_delta("e", "w"),
                    "diag_ne_sw_contrast": pair_delta("ne", "sw"),
                    "diag_nw_se_contrast": pair_delta("nw", "se"),
                    "axial_diagonal_delta": float(axial.mean() - diagonal.mean()),
                    "center_neighbor_delta": float(center - all_nb.mean()),
                    "center_neighbor_abs_mean": float(np.abs(all_nb - center).mean()),
                    "center_neighbor_sq_mean": float(np.square(all_nb - center).mean()),
                    "center_x_neighbor_mean": float(center * all_nb.mean()),
                    "neighbors_above_center": float(np.mean(all_nb > center)),
                    "neighbors_below_half_white": float(np.mean(all_nb < 0.5)),
                }
                for fan, names in {
                    "top": ["nw", "n", "ne"], "right": ["ne", "e", "se"],
                    "bottom": ["sw", "s", "se"], "left": ["nw", "w", "sw"],
                }.items():
                    row[f"fan_{fan}"] = float(available(direction, valid, names, center).mean())
                rows.append(row)
    return pd.DataFrame(rows)


def make_splits(groups):
    return [(groups != held, groups == held) for held in sorted(set(groups))]


def evaluate_matrix(X, y, splits, polynomial=False, predictions=False):
    from sklearn.pipeline import make_pipeline
    from sklearn.preprocessing import PolynomialFeatures, StandardScaler
    from sklearn.svm import LinearSVC

    pred = np.zeros(len(y), dtype=np.uint8)
    start = time.perf_counter()
    for train, test in splits:
        steps = [StandardScaler()]
        if polynomial:
            steps.append(PolynomialFeatures(degree=2, include_bias=False))
        steps.append(LinearSVC(C=1.0, max_iter=20000))
        model = make_pipeline(*steps)
        model.fit(X[train], y[train])
        pred[test] = model.predict(X[test])
    result = {
        "errors": int(np.sum(pred != y)), "cells": int(len(y)),
        "error_percent": float(100.0 * np.mean(pred != y)),
        "host_cv_seconds": time.perf_counter() - start,
    }
    return (result, pred) if predictions else result


def subset_matrix(center, directions, valid, indexes, pooled):
    chosen = directions[:, indexes]
    if not pooled:
        return np.column_stack([center, chosen])
    chosen_valid = valid[:, indexes]
    count = chosen_valid.sum(axis=1)
    total = (chosen * chosen_valid).sum(axis=1)
    mean = np.divide(total, count, out=center.copy(), where=count != 0)
    return np.column_stack([center, mean])


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--frames", required=True)
    ap.add_argument("--grades")
    ap.add_argument("--image-dir", required=True)
    ap.add_argument("--golden-jsonl")
    ap.add_argument("--out", default="directional_neighbor_exploration")
    ap.add_argument("--jobs", type=int, default=max(1, min(8, os.cpu_count() or 1)))
    ap.add_argument("--reuse-subsets", action="store_true",
                    help="Reuse an existing directional_subset_results.csv")
    args = ap.parse_args()
    out = Path(args.out); out.mkdir(parents=True, exist_ok=True)

    import matplotlib
    matplotlib.use("Agg")
    import matplotlib.pyplot as plt
    import pandas as pd
    from joblib import Parallel, delayed

    df = build(args).reset_index(drop=True)
    names = list(DIRECTIONS)
    center = df["center"].to_numpy(float)
    directional = df[[f"nb_{name}" for name in names]].to_numpy(float)
    valid = df[[f"has_{name}" for name in names]].to_numpy(bool)
    y = df["y"].to_numpy(np.uint8)
    groups = df["set"].to_numpy()
    splits = make_splits(groups)

    baseline_X = np.column_stack([center, df["neighbor_mean_axial"]])
    baseline = evaluate_matrix(baseline_X, y, splits)
    subsets = [combo for size in range(1, 9) for combo in itertools.combinations(range(8), size)]

    def run_subset(indexes, pooled):
        X = subset_matrix(center, directional, valid, indexes, pooled)
        metric = evaluate_matrix(X, y, splits)
        selected = [names[i] for i in indexes]
        return {
            "representation": "pooled_mean" if pooled else "separate_inputs",
            "mask": sum(1 << i for i in indexes), "subset": "+".join(selected),
            "neighbor_count": len(indexes), "input_features": X.shape[1], **metric,
        }

    subset_path = out / "directional_subset_results.csv"
    if args.reuse_subsets and subset_path.exists():
        print(f"reusing {subset_path}")
        subset_table = pd.read_csv(subset_path).sort_values("error_percent")
    else:
        print(f"evaluating {len(subsets) * 2} directional subset models with {args.jobs} workers")
        subset_rows = Parallel(n_jobs=args.jobs, prefer="threads", verbose=10)(
            delayed(run_subset)(combo, pooled)
            for pooled in (False, True) for combo in subsets
        )
        subset_table = pd.DataFrame(subset_rows).sort_values("error_percent")
        subset_table.to_csv(subset_path, index=False)

    engineered = [
        "neighbor_mean_all", "neighbor_mean_axial", "neighbor_mean_diagonal",
        "neighbor_var_all", "neighbor_var_axial", "neighbor_var_diagonal",
        "neighbor_range_all", "neighbor_range_axial", "neighbor_range_diagonal",
        "vertical_contrast", "horizontal_contrast", "diag_ne_sw_contrast",
        "diag_nw_se_contrast", "axial_diagonal_delta", "center_neighbor_delta",
        "center_neighbor_abs_mean", "center_neighbor_sq_mean",
        "center_x_neighbor_mean", "neighbors_above_center",
        "neighbors_below_half_white", "fan_top", "fan_right", "fan_bottom", "fan_left",
    ]
    engineered_rows = [{"name": "production-like center + axial mean", "features": "center+neighbor_mean_axial", **baseline}]
    for feature in engineered:
        X = df[["center", "neighbor_mean_axial", feature]].to_numpy(float)
        engineered_rows.append({"name": f"baseline + {feature}",
                                "features": f"center+neighbor_mean_axial+{feature}",
                                **evaluate_matrix(X, y, splits)})
    bundles = {
        "all directional summaries": engineered,
        "variance bundle": ["neighbor_var_all", "neighbor_var_axial", "neighbor_var_diagonal"],
        "contrast bundle": ["vertical_contrast", "horizontal_contrast", "diag_ne_sw_contrast", "diag_nw_se_contrast"],
        "fan bundle": ["fan_top", "fan_right", "fan_bottom", "fan_left"],
        "nonlinear disagreement bundle": ["neighbor_var_all", "neighbor_range_all", "center_neighbor_abs_mean", "center_neighbor_sq_mean", "neighbors_above_center"],
    }
    for label, features in bundles.items():
        columns = ["center", "neighbor_mean_axial"] + features
        engineered_rows.append({"name": label, "features": "+".join(columns),
                                **evaluate_matrix(df[columns].to_numpy(float), y, splits)})
    engineered_table = pd.DataFrame(engineered_rows).sort_values("error_percent")
    engineered_table.to_csv(out / "engineered_neighbor_results.csv", index=False)

    best_vector = subset_table[subset_table.representation == "separate_inputs"].iloc[0]
    best_pooled = subset_table[subset_table.representation == "pooled_mean"].iloc[0]
    kernel_rows = []
    for label, row, pooled in (("best separate", best_vector, False), ("best pooled", best_pooled, True)):
        indexes = tuple(i for i in range(8) if int(row["mask"]) & (1 << i))
        X = subset_matrix(center, directional, valid, indexes, pooled)
        for polynomial in (False, True):
            kernel_rows.append({"name": label, "subset": row["subset"],
                                "model": "polynomial degree 2" if polynomial else "linear",
                                **evaluate_matrix(X, y, splits, polynomial=polynomial)})
    all8_X = np.column_stack([center, directional])
    kernel_rows.append({"name": "all eight separate", "subset": "+".join(names),
                        "model": "polynomial degree 2",
                        **evaluate_matrix(all8_X, y, splits, polynomial=True)})
    kernel_table = pd.DataFrame(kernel_rows).sort_values("error_percent")
    kernel_table.to_csv(out / "selected_nonlinear_models.csv", index=False)

    # Paired diagnostics for the strongest discovered model. This comparison is
    # descriptive only because the winner was selected on this same corpus.
    best_indexes = tuple(i for i in range(8) if int(best_vector["mask"]) & (1 << i))
    best_X = subset_matrix(center, directional, valid, best_indexes, pooled=False)
    baseline_metric, baseline_pred = evaluate_matrix(
        baseline_X, y, splits, predictions=True)
    winner_metric, winner_pred = evaluate_matrix(
        best_X, y, splits, polynomial=True, predictions=True)
    baseline_wrong = baseline_pred != y
    winner_wrong = winner_pred != y
    fixed = int(np.sum(baseline_wrong & ~winner_wrong))
    broken = int(np.sum(~baseline_wrong & winner_wrong))
    from scipy.stats import binomtest
    paired = {
        "baseline": baseline_metric, "winner": winner_metric,
        "winner_subset": [names[i] for i in best_indexes],
        "winner_model": "polynomial degree 2",
        "baseline_wrong_winner_right": fixed,
        "baseline_right_winner_wrong": broken,
        "mcnemar_exact_p_unadjusted": float(binomtest(min(fixed, broken), fixed + broken, 0.5).pvalue),
        "selection_warning": "The winner was selected from many models on this corpus, so this p-value is descriptive and not confirmatory.",
    }
    per_set = []
    for capture_set in sorted(set(groups)):
        selected = groups == capture_set
        base_errors = int(np.sum(baseline_pred[selected] != y[selected]))
        winner_errors = int(np.sum(winner_pred[selected] != y[selected]))
        per_set.append({"set": capture_set, "baseline_errors": base_errors,
                        "winner_errors": winner_errors,
                        "improvement": base_errors - winner_errors})
    paired["per_set"] = per_set
    (out / "paired_winner_comparison.json").write_text(json.dumps(paired, indent=2), encoding="utf-8")
    prediction_table = df[["set", "key", "gidx", "cell", "y"]].copy()
    prediction_table["baseline_prediction"] = baseline_pred
    prediction_table["winner_prediction"] = winner_pred
    prediction_table.to_csv(out / "winner_predictions.csv", index=False)

    # Capture-set CV checks new imaging conditions, but every capture repeats the
    # same payload words. Hold out each payload frame index as a second audit so
    # directional features cannot simply memorize spatial bit relationships.
    payload_splits = make_splits(df["gidx"].to_numpy())
    pooled_indexes = tuple(i for i in range(8) if int(best_pooled["mask"]) & (1 << i))
    pooled_X = subset_matrix(center, directional, valid, pooled_indexes, pooled=True)
    payload_rows = [
        {"name": "baseline axial mean", "model": "linear",
         **evaluate_matrix(baseline_X, y, payload_splits)},
        {"name": "best pooled subset", "model": "linear", "subset": best_pooled["subset"],
         **evaluate_matrix(pooled_X, y, payload_splits)},
        {"name": "best separate subset", "model": "linear", "subset": best_vector["subset"],
         **evaluate_matrix(best_X, y, payload_splits)},
        {"name": "best separate subset", "model": "polynomial degree 2", "subset": best_vector["subset"],
         **evaluate_matrix(best_X, y, payload_splits, polynomial=True)},
        {"name": "all eight separate", "model": "polynomial degree 2", "subset": "+".join(names),
         **evaluate_matrix(all8_X, y, payload_splits, polynomial=True)},
    ]
    payload_table = pd.DataFrame(payload_rows).sort_values("error_percent")
    payload_table.to_csv(out / "leave_one_payload_frame_out.csv", index=False)

    direct_columns = ["center"] + [f"nb_{name}" for name in names]
    direct_corr = df[direct_columns].corr()
    direct_corr.to_csv(out / "directional_feature_correlation.csv")
    fig, ax = plt.subplots(figsize=(9, 8), dpi=160)
    im = ax.imshow(direct_corr, cmap="coolwarm", vmin=-1, vmax=1)
    short = ["center"] + [name.upper() for name in names]
    ax.set_xticks(range(9), short); ax.set_yticks(range(9), short)
    for row in range(9):
        for col in range(9):
            ax.text(col, row, f"{direct_corr.iloc[row, col]:.2f}", ha="center", va="center", fontsize=7)
    ax.set_title("Directional neighbor feature correlation")
    fig.colorbar(im, ax=ax, label="Pearson correlation")
    fig.tight_layout(); fig.savefig(out / "directional_feature_correlation.png", bbox_inches="tight"); plt.close(fig)

    engineered_corr = df[["center"] + engineered].corr()
    engineered_corr.to_csv(out / "engineered_feature_correlation.csv")
    fig, ax = plt.subplots(figsize=(15, 13), dpi=150)
    im = ax.imshow(engineered_corr, cmap="coolwarm", vmin=-1, vmax=1)
    labels = [name.replace("neighbor_", "nb_").replace("_", "\n") for name in engineered_corr.columns]
    ax.set_xticks(range(len(labels)), labels, rotation=90, fontsize=6)
    ax.set_yticks(range(len(labels)), labels, fontsize=6)
    ax.set_title("Engineered directional and nonlinear feature correlation")
    fig.colorbar(im, ax=ax, label="Pearson correlation")
    fig.tight_layout(); fig.savefig(out / "engineered_feature_correlation.png", bbox_inches="tight"); plt.close(fig)

    shown = pd.concat([
        subset_table.head(18),
        pd.DataFrame([{"representation": "baseline", "subset": "axial mean", **baseline}]),
    ], ignore_index=True).sort_values("error_percent", ascending=False)
    fig, ax = plt.subplots(figsize=(13, 9), dpi=150)
    labels = shown["representation"] + ": " + shown["subset"]
    ax.barh(labels, shown["error_percent"], color=["#6b7280" if x == "baseline" else "#1976d2" for x in shown.representation])
    ax.set_xlabel("LOCO cell error (%)"); ax.set_title("Best directional-neighbor combinations")
    for i, value in enumerate(shown.error_percent):
        ax.text(value + .002, i, f"{value:.3f}%", va="center", fontsize=8)
    fig.tight_layout(); fig.savefig(out / "best_directional_models.png", bbox_inches="tight"); plt.close(fig)

    fig, axes = plt.subplots(1, 2, figsize=(13, 5), dpi=150, sharey=True)
    for ax, representation in zip(axes, ("separate_inputs", "pooled_mean")):
        part = subset_table[subset_table.representation == representation]
        data = [part[part.neighbor_count == size].error_percent for size in range(1, 9)]
        ax.boxplot(data, tick_labels=range(1, 9), showfliers=False)
        ax.set_title(representation.replace("_", " ")); ax.set_xlabel("Selected directions")
        ax.grid(axis="y", alpha=.2)
    axes[0].set_ylabel("LOCO cell error (%)")
    fig.suptitle("Directional subset size versus classifier error")
    fig.tight_layout(); fig.savefig(out / "error_by_subset_size.png", bbox_inches="tight"); plt.close(fig)

    top = subset_table.head(32)
    frequency = {name: int(top["subset"].str.split("+").apply(lambda values: name in values).sum()) for name in names}
    fig, ax = plt.subplots(figsize=(9, 5), dpi=150)
    ax.bar([name.upper() for name in names], list(frequency.values()), color="#0f766e")
    ax.set(ylabel="Appearances in best 32 models", title="Directional usefulness among top models")
    fig.tight_layout(); fig.savefig(out / "top_model_direction_frequency.png", bbox_inches="tight"); plt.close(fig)

    comparison = pd.DataFrame([
        {"name": "Current: center + axial mean", **baseline},
        {"name": "Best pooled directional", **best_pooled.to_dict()},
        {"name": "Best separate directional", **best_vector.to_dict()},
        {"name": "All engineered summaries", **engineered_table.iloc[0].to_dict()},
        {"name": "Best degree-2 directional", **kernel_table.iloc[0].to_dict()},
    ]).sort_values("error_percent", ascending=False)
    fig, ax = plt.subplots(figsize=(11, 5), dpi=150)
    ax.barh(comparison.name, comparison.error_percent, color=["#6b7280", "#2563eb", "#2563eb", "#0f766e", "#9333ea"])
    for i, value in enumerate(comparison.error_percent):
        ax.text(value + .003, i, f"{value:.3f}%", va="center", fontsize=9)
    ax.set(xlabel="LOCO cell error (%)", title="Directional feature model-family comparison")
    fig.tight_layout(); fig.savefig(out / "model_family_comparison.png", bbox_inches="tight"); plt.close(fig)

    payload_plot = payload_table.sort_values("error_percent", ascending=False)
    fig, ax = plt.subplots(figsize=(11, 5), dpi=150)
    ax.barh(payload_plot["name"] + " (" + payload_plot["model"] + ")", payload_plot.error_percent, color="#b45309")
    for i, value in enumerate(payload_plot.error_percent):
        ax.text(value + .02, i, f"{value:.3f}%", va="center", fontsize=9)
    ax.set(xlabel="Leave-one-payload-frame-out cell error (%)",
           title="Generalization to an unseen payload word")
    fig.tight_layout(); fig.savefig(out / "payload_generalization.png", bbox_inches="tight"); plt.close(fig)

    summary = {
        "cells": int(len(df)), "capture_sets": int(df["set"].nunique()),
        "ground_truth": "sender_jsonl" if args.golden_jsonl else "all-set majority vote",
        "models": {"directional_subsets": len(subset_table), "engineered": len(engineered_table), "selected_kernel": len(kernel_table)},
        "baseline": baseline,
        "best_directional": subset_table.iloc[0].to_dict(),
        "best_engineered": engineered_table.iloc[0].to_dict(),
        "best_nonlinear": kernel_table.iloc[0].to_dict(),
        "paired_winner_comparison": paired,
        "leave_one_payload_frame_out": payload_rows,
        "top32_direction_frequency": frequency,
        "warning": "Exploratory selection on the existing corpus; confirm the frozen winner on untouched exact sender truth.",
    }
    (out / "summary.json").write_text(json.dumps(summary, indent=2), encoding="utf-8")
    print(json.dumps(summary, indent=2))


if __name__ == "__main__":
    main()
