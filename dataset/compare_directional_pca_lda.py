#!/usr/bin/env python3
"""PCA/LDA study for the best CubeOCC directional-neighbor feature set."""
import argparse
import json
import os
import time
from pathlib import Path

import numpy as np

import explore_directional_neighbors as edn


BEST_DIRECTIONS = ["n", "se", "s", "sw", "w", "nw"]
RAW_COLUMNS = ["center"] + [f"nb_{name}" for name in BEST_DIRECTIONS]


def evaluate(X, y, splits, method="svm", pca_components=None, polynomial=False,
             scale_polynomial=True, return_predictions=False):
    from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
    from sklearn.decomposition import PCA
    from sklearn.pipeline import make_pipeline
    from sklearn.preprocessing import PolynomialFeatures, StandardScaler
    from sklearn.svm import LinearSVC

    predictions = np.zeros(len(y), dtype=np.uint8)
    started = time.perf_counter()
    for train, test in splits:
        steps = [StandardScaler()]
        if polynomial:
            steps.append(PolynomialFeatures(degree=2, include_bias=False))
            if scale_polynomial:
                steps.append(StandardScaler())
        if pca_components is not None:
            steps.append(PCA(n_components=pca_components, random_state=0))
        if method == "svm":
            steps.append(LinearSVC(C=1.0, max_iter=20000))
        elif method == "lda":
            steps.append(LinearDiscriminantAnalysis(solver="svd"))
        else:
            raise ValueError(method)
        model = make_pipeline(*steps)
        model.fit(X[train], y[train])
        predictions[test] = model.predict(X[test])
    errors = int(np.sum(predictions != y))
    result = {
        "errors": errors, "cells": int(len(y)),
        "error_percent": float(100.0 * errors / len(y)),
        "host_cv_seconds": time.perf_counter() - started,
    }
    return (result, predictions) if return_predictions else result


def ellipse(ax, points, color):
    from matplotlib.patches import Ellipse
    if len(points) < 3:
        return
    center = points.mean(axis=0)
    values, vectors = np.linalg.eigh(np.cov(points, rowvar=False))
    order = values.argsort()[::-1]
    values, vectors = values[order], vectors[:, order]
    angle = np.degrees(np.arctan2(vectors[1, 0], vectors[0, 0]))
    # Two-standard-deviation ellipse is a readable visual guide, not a decision boundary.
    width, height = 4.0 * np.sqrt(np.maximum(values, 0.0))
    ax.add_patch(Ellipse(center, width, height, angle=angle, facecolor="none",
                         edgecolor=color, linewidth=2.0, linestyle="--"))
    ax.scatter(*center, marker="X", s=90, color=color, edgecolor="white", linewidth=.8, zorder=4)


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--frames", required=True)
    ap.add_argument("--grades")
    ap.add_argument("--image-dir", required=True)
    ap.add_argument("--golden-jsonl")
    ap.add_argument("--out", default="directional_reduction")
    ap.add_argument("--jobs", type=int, default=max(1, min(8, os.cpu_count() or 1)))
    args = ap.parse_args()
    out = Path(args.out); out.mkdir(parents=True, exist_ok=True)

    import matplotlib
    matplotlib.use("Agg")
    import matplotlib.pyplot as plt
    import pandas as pd
    from joblib import Parallel, delayed
    from sklearn.decomposition import PCA
    from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
    from sklearn.preprocessing import PolynomialFeatures, StandardScaler

    df = edn.build(args).reset_index(drop=True)
    X = df[RAW_COLUMNS].to_numpy(float)
    y = df["y"].to_numpy(np.uint8)
    splits = edn.make_splits(df["set"].to_numpy())

    cases = []
    specifications = []
    specifications.append(("Raw 7 -> linear SVM", "raw_svm", "svm", None, False, True))
    specifications.append(("Raw 7 -> LDA", "raw_lda", "lda", None, False, True))
    for count in range(1, 8):
        specifications.append((f"Raw 7 -> PCA{count} -> SVM", "raw_pca_svm", "svm", count, False, True))
        specifications.append((f"Raw 7 -> PCA{count} -> LDA", "raw_pca_lda", "lda", count, False, True))
    specifications.append(("Degree 2 current pipeline -> SVM", "poly_svm_exact", "svm", None, True, False))
    specifications.append(("Degree 2 standardized (35) -> SVM", "poly_svm", "svm", None, True, True))
    specifications.append(("Degree 2 standardized (35) -> LDA", "poly_lda", "lda", None, True, True))
    polynomial_components = sorted(set([1, 2, 3, 4, 5, 7, 10, 15, 20] + list(range(21, 36))))
    for count in polynomial_components:
        specifications.append((f"Degree 2 (35) -> PCA{count} -> SVM", "poly_pca_svm", "svm", count, True, True))
        specifications.append((f"Degree 2 (35) -> PCA{count} -> LDA", "poly_pca_lda", "lda", count, True, True))

    def run(spec):
        name, family, method, components, polynomial, scale_polynomial = spec
        metric = evaluate(X, y, splits, method=method,
                          pca_components=components, polynomial=polynomial,
                          scale_polynomial=scale_polynomial)
        return {"name": name, "family": family, "method": method,
                "pca_components": components if components is not None else 0,
                "polynomial": polynomial, "scale_polynomial": scale_polynomial, **metric}

    print(f"evaluating {len(specifications)} grouped PCA/LDA cases with {args.jobs} workers")
    cases = Parallel(n_jobs=args.jobs, prefer="threads", verbose=10)(
        delayed(run)(spec) for spec in specifications)
    table = pd.DataFrame(cases).sort_values("error_percent")
    table.to_csv(out / "pca_lda_cases.csv", index=False)

    best_pca_case = table[table.family == "poly_pca_svm"].iloc[0]
    best_count = int(best_pca_case.pca_components)
    exact_metric, exact_pred = evaluate(
        X, y, splits, method="svm", polynomial=True, scale_polynomial=False,
        return_predictions=True)
    pca_metric, pca_pred = evaluate(
        X, y, splits, method="svm", polynomial=True, scale_polynomial=True,
        pca_components=best_count, return_predictions=True)
    exact_wrong = exact_pred != y
    pca_wrong = pca_pred != y
    fixed = int(np.sum(exact_wrong & ~pca_wrong))
    broken = int(np.sum(~exact_wrong & pca_wrong))
    from scipy.stats import binomtest
    paired = {
        "reference_exact_polynomial": exact_metric,
        "best_pca": pca_metric,
        "best_pca_components": best_count,
        "reference_wrong_pca_right": fixed,
        "reference_right_pca_wrong": broken,
        "mcnemar_exact_p_unadjusted": float(binomtest(min(fixed, broken), fixed + broken, .5).pvalue),
        "selection_warning": "The PCA count was selected on this corpus; confirm it without retuning on an untouched exact-truth capture.",
    }
    (out / "paired_best_pca.json").write_text(json.dumps(paired, indent=2), encoding="utf-8")
    predictions = df[["set", "key", "gidx", "cell", "y"]].copy()
    predictions["exact_polynomial_prediction"] = exact_pred
    predictions["best_pca_prediction"] = pca_pred
    predictions.to_csv(out / "best_pca_predictions.csv", index=False)

    # Visual-only transforms are fitted to the complete dataset. They are never
    # used for the cross-validated error numbers above.
    scaler = StandardScaler().fit(X)
    Xs = scaler.transform(X)
    raw_pca = PCA(n_components=7, random_state=0).fit(Xs)
    raw_scores = raw_pca.transform(Xs)

    poly = PolynomialFeatures(degree=2, include_bias=False).fit(Xs)
    Xpoly = poly.transform(Xs)
    poly_scaler = StandardScaler().fit(Xpoly)
    Xpoly_s = poly_scaler.transform(Xpoly)
    poly_pca = PCA(n_components=35, random_state=0).fit(Xpoly_s)
    poly_scores = poly_pca.transform(Xpoly_s)

    lda = LinearDiscriminantAnalysis(solver="svd").fit(Xs, y)
    lda_scores = lda.transform(Xs).ravel()

    feature_names = ["Center", "N", "SE", "S", "SW", "W", "NW"]
    colors = {0: "#2563eb", 1: "#dc2626"}

    # PC1-PC2 biplot with centroids and two-sigma guide ellipses.
    fig, ax = plt.subplots(figsize=(11, 8), dpi=160)
    rng = np.random.default_rng(0)
    for label in (0, 1):
        selected = np.flatnonzero(y == label)
        shown = rng.choice(selected, size=min(6000, len(selected)), replace=False)
        ax.scatter(raw_scores[shown, 0], raw_scores[shown, 1], s=6, alpha=.13,
                   color=colors[label], label=f"bit {label} (n={len(selected):,})")
        ellipse(ax, raw_scores[selected, :2], colors[label])
    loading_scale = np.percentile(np.abs(raw_scores[:, :2]), 95) * .75
    for index, name in enumerate(feature_names):
        dx = raw_pca.components_[0, index] * loading_scale
        dy = raw_pca.components_[1, index] * loading_scale
        ax.arrow(0, 0, dx, dy, color="#111827", width=.008,
                 head_width=.12, length_includes_head=True, alpha=.8)
        ax.text(dx * 1.08, dy * 1.08, name, fontsize=9, weight="bold")
    ax.axhline(0, color="#9ca3af", linewidth=.7); ax.axvline(0, color="#9ca3af", linewidth=.7)
    ax.set_xlabel(f"PC1 ({raw_pca.explained_variance_ratio_[0] * 100:.2f}% variance)")
    ax.set_ylabel(f"PC2 ({raw_pca.explained_variance_ratio_[1] * 100:.2f}% variance)")
    ax.set_title("Best directional features: PC1-PC2 projection")
    ax.legend(loc="best"); ax.grid(alpha=.15)
    fig.tight_layout(); fig.savefig(out / "raw_pc1_pc2_biplot.png", bbox_inches="tight"); plt.close(fig)

    # Polynomial PC1-PC2 density view avoids an unreadable 35-arrow biplot.
    fig, axes = plt.subplots(1, 2, figsize=(13, 5.5), dpi=160, sharex=True, sharey=True)
    for ax, label in zip(axes, (0, 1)):
        selected = y == label
        hb = ax.hexbin(poly_scores[selected, 0], poly_scores[selected, 1], gridsize=55,
                       mincnt=1, bins="log", cmap="Blues" if label == 0 else "Reds")
        ellipse(ax, poly_scores[selected, :2], colors[label])
        ax.set_title(f"bit {label}: degree-2 feature density")
        ax.set_xlabel(f"PC1 ({poly_pca.explained_variance_ratio_[0] * 100:.2f}%)")
        fig.colorbar(hb, ax=ax, label="log sample density")
    axes[0].set_ylabel(f"PC2 ({poly_pca.explained_variance_ratio_[1] * 100:.2f}%)")
    fig.suptitle("PC1-PC2 after 35-feature polynomial expansion")
    fig.tight_layout(); fig.savefig(out / "polynomial_pc1_pc2_density.png", bbox_inches="tight"); plt.close(fig)

    # Explained variance and cumulative information retained.
    fig, axes = plt.subplots(1, 2, figsize=(13, 5), dpi=160)
    for ax, model, title in ((axes[0], raw_pca, "Seven original directional features"),
                             (axes[1], poly_pca, "35 degree-2 features")):
        ratio = model.explained_variance_ratio_ * 100
        xaxis = np.arange(1, len(ratio) + 1)
        ax.bar(xaxis, ratio, color="#2563eb", alpha=.8, label="individual")
        ax.plot(xaxis, np.cumsum(ratio), color="#dc2626", marker="o", markersize=3,
                linewidth=1.5, label="cumulative")
        ax.axhline(95, color="#111827", linestyle="--", linewidth=1, label="95%")
        ax.set(title=title, xlabel="Principal component", ylabel="Explained variance (%)")
        ax.set_ylim(0, 103); ax.grid(axis="y", alpha=.15); ax.legend(fontsize=8)
    fig.suptitle("PCA scree and cumulative explained variance")
    fig.tight_layout(); fig.savefig(out / "pca_explained_variance.png", bbox_inches="tight"); plt.close(fig)

    # LDA is one-dimensional for a two-class problem.
    fig, ax = plt.subplots(figsize=(11, 5), dpi=160)
    bins = np.linspace(np.percentile(lda_scores, .2), np.percentile(lda_scores, 99.8), 100)
    for label in (0, 1):
        ax.hist(lda_scores[y == label], bins=bins, density=True, alpha=.42,
                color=colors[label], label=f"bit {label}")
        ax.axvline(np.mean(lda_scores[y == label]), color=colors[label], linestyle="--", linewidth=2)
    threshold = float(lda.transform(lda.means_).mean())
    ax.axvline(threshold, color="#111827", linewidth=2, label="midpoint guide")
    ax.set(xlabel="LDA discriminant score", ylabel="Density",
           title="One-dimensional LDA separation of the seven directional features")
    ax.legend(); ax.grid(axis="y", alpha=.15)
    fig.tight_layout(); fig.savefig(out / "lda_score_distribution.png", bbox_inches="tight"); plt.close(fig)

    # Error-versus-component plots for both SVM and LDA.
    fig, axes = plt.subplots(1, 2, figsize=(13, 5), dpi=160)
    for ax, prefix, maximum, title in ((axes[0], "raw", 7, "Original seven features"),
                                       (axes[1], "poly", 35, "Degree-2 feature space")):
        for method, marker, color in (("svm", "o", "#2563eb"), ("lda", "s", "#dc2626")):
            part = table[table.family == f"{prefix}_pca_{method}"].sort_values("pca_components")
            ax.plot(part.pca_components, part.error_percent, marker=marker, color=color,
                    label=method.upper())
        reference_family = f"{prefix}_{'svm'}"
        reference = table[table.family == reference_family].iloc[0].error_percent
        ax.axhline(reference, color="#111827", linestyle="--", label="no PCA SVM")
        ax.set(title=title, xlabel="Retained PCA components", ylabel="LOCO cell error (%)")
        ax.set_xlim(.7, maximum + .3); ax.grid(alpha=.15); ax.legend(fontsize=8)
    fig.suptitle("Classification cost of PCA compression")
    fig.tight_layout(); fig.savefig(out / "pca_component_error.png", bbox_inches="tight"); plt.close(fig)

    shown = table.head(18).sort_values("error_percent", ascending=False)
    fig, ax = plt.subplots(figsize=(13, 8), dpi=150)
    ax.barh(shown.name, shown.error_percent, color="#0f766e")
    for index, value in enumerate(shown.error_percent):
        ax.text(value + .003, index, f"{value:.3f}%", va="center", fontsize=8)
    ax.set(xlabel="LOCO cell error (%)", title="Best PCA/LDA cases for directional features")
    fig.tight_layout(); fig.savefig(out / "best_reduction_cases.png", bbox_inches="tight"); plt.close(fig)

    summary = {
        "features": RAW_COLUMNS,
        "cells": int(len(df)), "capture_sets": int(df["set"].nunique()),
        "ground_truth": "sender_jsonl" if args.golden_jsonl else "all-set majority vote",
        "raw_pca_explained_variance_percent": (raw_pca.explained_variance_ratio_ * 100).tolist(),
        "polynomial_pca_explained_variance_percent": (poly_pca.explained_variance_ratio_ * 100).tolist(),
        "best_pca_components": best_count,
        "best_pca_cumulative_variance_percent": float(poly_pca.explained_variance_ratio_[:best_count].sum() * 100),
        "paired_best_pca": paired,
        "best_cases": table.head(15).to_dict(orient="records"),
        "warning": "Visual transforms use all data only for plotting. Every reported error fits scaling, PCA, and LDA inside each LOCO training fold.",
    }
    (out / "summary.json").write_text(json.dumps(summary, indent=2), encoding="utf-8")
    print(table[["name", "errors", "error_percent"]].head(20).to_string(index=False))
    print(json.dumps({"raw_variance": summary["raw_pca_explained_variance_percent"],
                      "poly_first_10_variance": summary["polynomial_pca_explained_variance_percent"][:10]}, indent=2))


if __name__ == "__main__":
    main()
