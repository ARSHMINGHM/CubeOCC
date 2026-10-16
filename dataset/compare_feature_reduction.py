#!/usr/bin/env python3
"""Compare CubeOCC feature subsets, PCA, and LDA with grouped validation.

All validation transforms are fitted inside each leave-one-capture-set-out fold.
The plots use a descriptive full-dataset projection only and are not accuracy
estimates. Production geometry and cell images must come from the RTL pipeline.
"""
import argparse
import itertools
import json
import sys
import time
from pathlib import Path

import numpy as np

sys.path.insert(0, str(Path(__file__).resolve().parent))
import cell_error_report as cer
import svm_cv_report as scv

FEATURES = ["mean_w", "var_w2", "max_w", "min_w", "neighbor_w"]
LABELS = {
    "mean_w": "cell mean / START white",
    "var_w2": "cell variance / START white^2",
    "max_w": "cell maximum / START white",
    "min_w": "cell minimum / START white",
    "neighbor_w": "neighbor mean / START white",
}
COLORS = ["#1976d2", "#d32f2f"]


def build_dataset(args):
    import pandas as pd
    from PIL import Image

    by = cer.load_frames(args.frames, args.grades)
    gold = cer.golden_from_jsonl(args.golden_jsonl) if args.golden_jsonl else cer.golden_from_votes(by)
    gold_cells = [np.array([int(ch) for ch in g[::-1]]) for g in gold]
    rows = []
    for capture_set, frames in by.items():
        path = cer.align(frames, gold)
        start_white = None
        for frame, golden_index in zip(frames, path):
            p = Path(args.image_dir) / frame["key"]
            if golden_index == 0 and p.exists():
                start_white = scv.cell_stats(np.array(Image.open(p).convert("L")))[0]
                break
        if start_white is None:
            continue
        for frame, golden_index in zip(frames, path):
            p = Path(args.image_dir) / frame["key"]
            if not p.exists() or not (1 <= golden_index <= 11):
                continue
            image = np.array(Image.open(p).convert("L"))
            mean, var, maximum, minimum = scv.cell_stats(image)
            neighbor = scv.neighbor_mean(mean)
            for cell in range(64):
                if cell in scv.CORNERS:
                    continue
                white = max(float(start_white[cell]), 1.0)
                rows.append({
                    "set": capture_set,
                    "key": frame["key"],
                    "gidx": golden_index,
                    "cell": cell,
                    "y": int(gold_cells[golden_index][cell]),
                    "mean_w": mean[cell] / white,
                    "var_w2": var[cell] / (white * white),
                    "max_w": maximum[cell] / white,
                    "min_w": minimum[cell] / white,
                    "neighbor_w": neighbor[cell] / white,
                })
    return pd.DataFrame(rows)


def grouped_eval(df, columns, method, components=None):
    from sklearn.decomposition import PCA
    from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
    from sklearn.pipeline import make_pipeline
    from sklearn.preprocessing import StandardScaler
    from sklearn.svm import LinearSVC

    X = df[list(columns)].to_numpy(float)
    y = df["y"].to_numpy(int)
    pred = np.zeros(len(df), dtype=int)
    started = time.perf_counter()
    for held in sorted(df["set"].unique()):
        train = (df["set"] != held).to_numpy()
        test = ~train
        if method == "svm":
            steps = [StandardScaler()]
            if components is not None:
                steps.append(PCA(n_components=components))
            steps.append(LinearSVC(C=1.0, max_iter=20000))
            model = make_pipeline(*steps)
        elif method == "lda":
            steps = [StandardScaler()]
            if components is not None:
                steps.append(PCA(n_components=components))
            steps.append(LinearDiscriminantAnalysis())
            model = make_pipeline(*steps)
        else:
            raise ValueError(method)
        model.fit(X[train], y[train])
        pred[test] = model.predict(X[test])
    elapsed = time.perf_counter() - started
    errors = int(np.sum(pred != y))
    return {
        "errors": errors,
        "cells": int(len(y)),
        "error_percent": 100.0 * errors / len(y),
        "host_cv_seconds": elapsed,
    }


def operation_cost(columns):
    cols = set(columns)
    # Relative operation inventory for extracting all selected features and
    # evaluating one folded linear boundary. It is not a Vivado utilization report.
    return {
        "linear_weights": len(columns),
        "needs_neighbor_accumulator": "neighbor_w" in cols,
        "needs_sum_of_squares": "var_w2" in cols,
        "needs_min_tracker": "min_w" in cols,
        "needs_max_tracker": "max_w" in cols,
        "normalization_complexity": "white_squared" if "var_w2" in cols else "shared_white",
    }


def make_plots(df, results, out):
    import matplotlib
    matplotlib.use("Agg")
    import matplotlib.pyplot as plt
    import pandas as pd
    from sklearn.decomposition import PCA
    from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
    from sklearn.preprocessing import StandardScaler

    plt.rcParams.update({"font.size": 10, "axes.grid": False, "figure.dpi": 140})
    corr = df[FEATURES].corr()
    fig, ax = plt.subplots(figsize=(8, 6))
    im = ax.imshow(corr, vmin=-1, vmax=1, cmap="coolwarm")
    ax.set_xticks(range(len(FEATURES)), [x.replace("_", "\n") for x in FEATURES])
    ax.set_yticks(range(len(FEATURES)), FEATURES)
    for i in range(len(FEATURES)):
        for j in range(len(FEATURES)):
            ax.text(j, i, f"{corr.iloc[i, j]:.2f}", ha="center", va="center",
                    color="white" if abs(corr.iloc[i, j]) > .55 else "black")
    ax.set_title("Production-derived candidate feature correlation")
    fig.colorbar(im, ax=ax, label="Pearson correlation")
    fig.tight_layout()
    fig.savefig(out / "correlation_matrix.png", bbox_inches="tight")
    plt.close(fig)

    X = StandardScaler().fit_transform(df[FEATURES].to_numpy(float))
    y = df["y"].to_numpy(int)
    pca = PCA().fit(X)
    Z = pca.transform(X)
    rng = np.random.default_rng(7)
    take = rng.choice(len(df), size=min(6000, len(df)), replace=False)

    fig, axes = plt.subplots(1, 2, figsize=(13, 5))
    axes[0].bar(np.arange(1, 6), pca.explained_variance_ratio_ * 100, color="#1976d2")
    axes[0].plot(np.arange(1, 6), np.cumsum(pca.explained_variance_ratio_) * 100,
                 color="#d32f2f", marker="o", label="cumulative")
    axes[0].set(xlabel="Principal component", ylabel="Explained variance (%)",
                title="PCA explained variance", xticks=np.arange(1, 6))
    axes[0].legend()
    for label in (0, 1):
        mask = y[take] == label
        axes[1].scatter(Z[take[mask], 0], Z[take[mask], 1], s=7, alpha=.28,
                        color=COLORS[label], label=f"bit {label}")
    axes[1].set(xlabel=f"PC1 ({pca.explained_variance_ratio_[0]*100:.1f}%)",
                ylabel=f"PC2 ({pca.explained_variance_ratio_[1]*100:.1f}%)",
                title="PC1 vs PC2 (descriptive projection)")
    axes[1].legend(markerscale=2)
    fig.tight_layout()
    fig.savefig(out / "pca_variance_and_pc1_pc2.png", bbox_inches="tight")
    plt.close(fig)

    lda = LinearDiscriminantAnalysis().fit(X, y)
    L = lda.transform(X).ravel()
    fig, ax = plt.subplots(figsize=(9, 5))
    bins = np.linspace(np.percentile(L, .2), np.percentile(L, 99.8), 90)
    for label in (0, 1):
        ax.hist(L[y == label], bins=bins, density=True, alpha=.48,
                color=COLORS[label], label=f"bit {label}")
    ax.set(xlabel="LDA discriminant score", ylabel="Density",
           title="Binary LDA separation on five candidate features")
    ax.legend()
    fig.tight_layout()
    fig.savefig(out / "lda_score_distribution.png", bbox_inches="tight")
    plt.close(fig)

    comparison = pd.DataFrame(results).sort_values("error_percent")
    fig, ax = plt.subplots(figsize=(11, max(5, .35 * len(comparison))))
    ax.barh(comparison["name"], comparison["error_percent"], color="#1976d2")
    ax.invert_yaxis()
    ax.set(xlabel="Leave-one-capture-set-out cell error (%)",
           title="Feature reduction comparison")
    for i, value in enumerate(comparison["error_percent"]):
        ax.text(value + .04, i, f"{value:.3f}%", va="center")
    fig.tight_layout()
    fig.savefig(out / "model_error_comparison.png", bbox_inches="tight")
    plt.close(fig)

    return corr, pca, lda


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--frames", required=True)
    ap.add_argument("--grades")
    ap.add_argument("--image-dir", required=True)
    ap.add_argument("--golden-jsonl")
    ap.add_argument("--out", default="feature_reduction_comparison")
    args = ap.parse_args()

    out = Path(args.out)
    out.mkdir(parents=True, exist_ok=True)
    df = build_dataset(args).reset_index(drop=True)
    print(f"dataset: {len(df)} cells, {df['set'].nunique()} capture sets")

    cases = []
    def evaluate(name, columns, method="svm", components=None, family="subset"):
        print(f"evaluating {name}")
        metric = grouped_eval(df, columns, method, components)
        cases.append({"name": name, "family": family, "method": method,
                      "components": components, "features": list(columns),
                      **metric, "operation_cost": operation_cost(columns)})

    evaluate("Current 2: mean + neighbor", ["mean_w", "neighbor_w"])
    evaluate("Full 5: no PCA", FEATURES)
    for k in range(1, 6):
        evaluate(f"Full 5 -> PCA{k} -> SVM", FEATURES, "svm", k, "pca")
    evaluate("Full 5 -> LDA", FEATURES, "lda", None, "lda")
    for k in range(1, 6):
        evaluate(f"Full 5 -> PCA{k} -> LDA", FEATURES, "lda", k, "pca_lda")

    # Exhaustive lightweight subsets expose a simpler option without the
    # hardware overhead of a PCA projection or variance/min/max extraction.
    subset_rows = []
    for size in (1, 2, 3):
        for columns in itertools.combinations(FEATURES, size):
            metric = grouped_eval(df, columns, "svm")
            subset_rows.append((metric["error_percent"], columns, metric))
    for size in (1, 2, 3):
        best = min(x for x in subset_rows if len(x[1]) == size)
        evaluate(f"Best {size}-feature subset: {' + '.join(best[1])}", best[1], family="best_subset")

    corr, pca, lda = make_plots(df, cases, out)
    corr.to_csv(out / "correlation_matrix.csv")
    (out / "cases.json").write_text(json.dumps(cases, indent=2), encoding="utf-8")
    summary = {
        "cells": int(len(df)),
        "capture_sets": int(df["set"].nunique()),
        "golden_source": "sender_jsonl" if args.golden_jsonl else "all-set majority vote",
        "feature_labels": LABELS,
        "correlation": corr.round(6).to_dict(),
        "pca_explained_variance_ratio": pca.explained_variance_ratio_.tolist(),
        "pca_components": pca.components_.tolist(),
        "lda_classes": lda.classes_.tolist(),
        "lda_components_available": 1,
        "cases": cases,
        "hardware_note": (
            "PCA/LDA followed by a linear classifier can be folded into one linear boundary. "
            "Resource cost is governed by the original features that must be extracted, not by "
            "the number of displayed PCA components. operation_cost is analytical, not Vivado synthesis."
        ),
    }
    (out / "summary.json").write_text(json.dumps(summary, indent=2), encoding="utf-8")
    print(f"wrote {out}")


if __name__ == "__main__":
    main()
