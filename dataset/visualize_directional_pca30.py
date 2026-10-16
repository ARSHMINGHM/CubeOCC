#!/usr/bin/env python3
"""Visual atlas and 2D/3D divider slices for the directional PCA30 model."""
import argparse
import json
from pathlib import Path

import numpy as np

import explore_directional_neighbors as edn
from compare_directional_pca_lda import BEST_DIRECTIONS, RAW_COLUMNS


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--frames", required=True)
    ap.add_argument("--grades")
    ap.add_argument("--image-dir", required=True)
    ap.add_argument("--golden-jsonl")
    ap.add_argument("--out", default="directional_pca30_visuals")
    args = ap.parse_args()
    out = Path(args.out); out.mkdir(parents=True, exist_ok=True)

    import matplotlib
    matplotlib.use("Agg")
    import matplotlib.pyplot as plt
    from matplotlib.lines import Line2D
    from sklearn.decomposition import PCA
    from sklearn.preprocessing import PolynomialFeatures, StandardScaler
    from sklearn.svm import LinearSVC

    df = edn.build(args).reset_index(drop=True)
    X = df[RAW_COLUMNS].to_numpy(float)
    y = df["y"].to_numpy(np.uint8)
    raw_names = ["Center", "N", "SE", "S", "SW", "W", "NW"]

    raw_scaler = StandardScaler().fit(X)
    Xs = raw_scaler.transform(X)
    poly = PolynomialFeatures(degree=2, include_bias=False).fit(Xs)
    Xpoly = poly.transform(Xs)
    poly_names = poly.get_feature_names_out(raw_names)
    poly_scaler = StandardScaler().fit(Xpoly)
    Xpoly_s = poly_scaler.transform(Xpoly)
    pca = PCA(n_components=30, random_state=0).fit(Xpoly_s)
    Z = pca.transform(Xpoly_s)
    svm = LinearSVC(C=1.0, max_iter=20000).fit(Z, y)
    score = svm.decision_function(Z)
    prediction = (score > 0).astype(np.uint8)

    pc_weight = svm.coef_.ravel()
    fused_weight = pca.components_.T @ pc_weight
    fused_bias = float(svm.intercept_[0] - pca.mean_ @ fused_weight)

    rng = np.random.default_rng(7)
    shown = np.sort(rng.choice(len(y), size=min(9000, len(y)), replace=False))
    colors = np.where(y[shown] == 1, "#dc2626", "#2563eb")

    # Complete raw-feature atlas: distributions, correlation, and class shift.
    fig, axes = plt.subplots(2, 2, figsize=(16, 11), dpi=160)
    positions = np.arange(1, 8)
    offset = .16
    for label, shift, color in ((0, -offset, "#2563eb"), (1, offset, "#dc2626")):
        values = [Xs[y == label, index] for index in range(7)]
        parts = axes[0, 0].violinplot(values, positions=positions + shift, widths=.28,
                                     showmeans=True, showextrema=False)
        for body in parts["bodies"]:
            body.set_facecolor(color); body.set_edgecolor(color); body.set_alpha(.35)
        parts["cmeans"].set_color(color)
    axes[0, 0].set_xticks(positions, raw_names)
    axes[0, 0].set(ylabel="Standardized value", title="All seven original feature distributions")
    axes[0, 0].legend(handles=[Line2D([0], [0], color="#2563eb", lw=6, alpha=.5, label="bit 0"),
                               Line2D([0], [0], color="#dc2626", lw=6, alpha=.5, label="bit 1")])
    axes[0, 0].grid(axis="y", alpha=.15)

    corr = np.corrcoef(Xs, rowvar=False)
    image = axes[0, 1].imshow(corr, cmap="coolwarm", vmin=-1, vmax=1)
    axes[0, 1].set_xticks(range(7), raw_names, rotation=45, ha="right")
    axes[0, 1].set_yticks(range(7), raw_names)
    for row in range(7):
        for col in range(7):
            axes[0, 1].text(col, row, f"{corr[row, col]:.2f}", ha="center", va="center", fontsize=8)
    axes[0, 1].set_title("Correlation of the selected seven inputs")
    fig.colorbar(image, ax=axes[0, 1], fraction=.046, pad=.04)

    class_mean = np.vstack([Xs[y == label].mean(axis=0) for label in (0, 1)])
    class_std = np.vstack([Xs[y == label].std(axis=0) for label in (0, 1)])
    axes[1, 0].errorbar(positions, class_mean[0], yerr=class_std[0], color="#2563eb",
                        marker="o", capsize=3, label="bit 0 mean +/- std")
    axes[1, 0].errorbar(positions, class_mean[1], yerr=class_std[1], color="#dc2626",
                        marker="o", capsize=3, label="bit 1 mean +/- std")
    axes[1, 0].set_xticks(positions, raw_names)
    axes[1, 0].set(ylabel="Standardized value", title="Class profiles across every original feature")
    axes[1, 0].legend(); axes[1, 0].grid(alpha=.15)

    axes[1, 1].hist(score[y == 0], bins=120, density=True, color="#2563eb", alpha=.42, label="bit 0")
    axes[1, 1].hist(score[y == 1], bins=120, density=True, color="#dc2626", alpha=.42, label="bit 1")
    axes[1, 1].axvline(0, color="#111827", linewidth=2, label="SVM divider")
    axes[1, 1].set(xlabel="Full PCA30 SVM decision score", ylabel="Density",
                   title="All-data margin distribution")
    axes[1, 1].legend(); axes[1, 1].grid(axis="y", alpha=.15)
    fig.suptitle("Directional PCA30 classifier: complete original-feature atlas", fontsize=16)
    fig.tight_layout(); fig.savefig(out / "all_feature_data_atlas.png", bbox_inches="tight"); plt.close(fig)

    # All 35 standardized polynomial terms and the fused PCA30/SVM divider weights.
    means0, means1 = Xpoly_s[y == 0].mean(axis=0), Xpoly_s[y == 1].mean(axis=0)
    fig, axes = plt.subplots(2, 1, figsize=(17, 9), dpi=160, sharex=True)
    xaxis = np.arange(35)
    axes[0].plot(xaxis, means0, marker="o", markersize=3, color="#2563eb", label="bit 0 mean")
    axes[0].plot(xaxis, means1, marker="o", markersize=3, color="#dc2626", label="bit 1 mean")
    axes[0].fill_between(xaxis, means0, means1, color="#9ca3af", alpha=.15)
    axes[0].set(ylabel="Mean standardized value", title="Class profile over all 35 degree-2 features")
    axes[0].legend(); axes[0].grid(alpha=.15)
    axes[1].bar(xaxis, fused_weight, color=np.where(fused_weight >= 0, "#dc2626", "#2563eb"))
    axes[1].axhline(0, color="#111827", linewidth=.8)
    axes[1].set(ylabel="Fused divider weight", title="PCA30 and SVM fused back onto all 35 features")
    axes[1].set_xticks(xaxis, poly_names, rotation=75, ha="right", fontsize=7)
    axes[1].grid(axis="y", alpha=.15)
    fig.tight_layout(); fig.savefig(out / "all_35_polynomial_features.png", bbox_inches="tight"); plt.close(fig)

    # PC importance: PCA variance is not the same as classifier usefulness.
    fig, ax1 = plt.subplots(figsize=(13, 5), dpi=160)
    pc_axis = np.arange(1, 31)
    ax1.bar(pc_axis, pca.explained_variance_ratio_ * 100, color="#60a5fa", label="variance")
    ax1.set(xlabel="Principal component used by classifier", ylabel="Explained variance (%)")
    ax2 = ax1.twinx()
    ax2.plot(pc_axis, np.abs(pc_weight), color="#7e22ce", marker="o", markersize=3,
             label="absolute SVM weight")
    ax2.set_ylabel("Absolute SVM weight in PCA space")
    handles1, labels1 = ax1.get_legend_handles_labels()
    handles2, labels2 = ax2.get_legend_handles_labels()
    ax1.legend(handles1 + handles2, labels1 + labels2, loc="upper right")
    ax1.set_title("All 30 PCs: variance versus classifier importance")
    ax1.grid(axis="y", alpha=.15)
    fig.tight_layout(); fig.savefig(out / "all_30_pc_importance.png", bbox_inches="tight"); plt.close(fig)

    # Anchor omitted dimensions at the mean location of the closest 5% margins.
    near = np.argsort(np.abs(score))[:max(100, len(score) // 20)]
    anchor2 = Z[near, 2:].mean(axis=0)
    intercept2 = float(svm.intercept_[0] + pc_weight[2:] @ anchor2)
    xlo, xhi = np.percentile(Z[:, 0], [.2, 99.8])
    ylo, yhi = np.percentile(Z[:, 1], [.2, 99.8])
    gx, gy = np.meshgrid(np.linspace(xlo, xhi, 300), np.linspace(ylo, yhi, 300))
    plane_score = pc_weight[0] * gx + pc_weight[1] * gy + intercept2

    fig, ax = plt.subplots(figsize=(11, 8), dpi=160)
    ax.contourf(gx, gy, plane_score, levels=[-1e9, 0, 1e9], colors=["#dbeafe", "#fee2e2"], alpha=.62)
    ax.contour(gx, gy, plane_score, levels=[0], colors=["#111827"], linewidths=2.5)
    scatter = ax.scatter(Z[shown, 0], Z[shown, 1], c=score[shown], cmap="coolwarm",
                         vmin=-3, vmax=3, s=8, alpha=.28)
    mistakes = shown[prediction[shown] != y[shown]]
    ax.scatter(Z[mistakes, 0], Z[mistakes, 1], facecolors="none", edgecolors="#facc15",
               s=38, linewidth=1.2, label=f"all-data errors shown ({len(mistakes)})")
    ax.set(xlabel=f"PC1 ({pca.explained_variance_ratio_[0] * 100:.2f}% variance)",
           ylabel=f"PC2 ({pca.explained_variance_ratio_[1] * 100:.2f}% variance)",
           title="2D slice of the PCA30 separating hyperplane")
    ax.text(.01, .01, "PC3-PC30 fixed to the near-boundary mean\nPoint color uses the full 30-PC score",
            transform=ax.transAxes, fontsize=9, va="bottom",
            bbox=dict(facecolor="white", edgecolor="#9ca3af", alpha=.9))
    ax.legend(loc="upper right"); ax.grid(alpha=.12)
    fig.colorbar(scatter, ax=ax, label="Full PCA30 SVM margin")
    fig.tight_layout(); fig.savefig(out / "pca30_divider_2d_slice.png", bbox_inches="tight"); plt.close(fig)

    # 3D local slice through PC1-PC3; PC4-PC30 stay at near-boundary mean.
    anchor3 = Z[near, 3:].mean(axis=0)
    intercept3 = float(svm.intercept_[0] + pc_weight[3:] @ anchor3)
    xgrid, ygrid = np.meshgrid(np.linspace(*np.percentile(Z[:, 0], [2, 98]), 25),
                               np.linspace(*np.percentile(Z[:, 1], [2, 98]), 25))
    if abs(pc_weight[2]) < 1e-10:
        zgrid = np.zeros_like(xgrid)
    else:
        zgrid = -(pc_weight[0] * xgrid + pc_weight[1] * ygrid + intercept3) / pc_weight[2]
    shown3 = np.sort(rng.choice(len(y), size=min(5500, len(y)), replace=False))
    fig = plt.figure(figsize=(12, 9), dpi=160)
    ax = fig.add_subplot(111, projection="3d")
    ax.plot_surface(xgrid, ygrid, zgrid, color="#16a34a", alpha=.28, linewidth=0,
                    label="score = 0 slice")
    ax.scatter(Z[shown3, 0], Z[shown3, 1], Z[shown3, 2], c=np.where(y[shown3] == 1, "#dc2626", "#2563eb"),
               s=5, alpha=.16, depthshade=False)
    ax.set_xlabel("PC1"); ax.set_ylabel("PC2"); ax.set_zlabel("PC3")
    ax.set_title("3D slice of PCA30 divider: PC1-PC3\nPC4-PC30 fixed near the full-model boundary")
    ax.view_init(elev=24, azim=-58)
    fig.tight_layout(); fig.savefig(out / "pca30_divider_3d_slice.png", bbox_inches="tight"); plt.close(fig)

    # Compact visual explanation of the dimensional path.
    fig, ax = plt.subplots(figsize=(14, 3.3), dpi=160)
    ax.axis("off")
    boxes = [(0.02, "7 normalized\ndirectional inputs"), (0.22, "degree-2\nexpansion: 35"),
             (0.43, "standardize\n35 terms"), (0.62, "keep PC1-PC30\nnot only PC1/PC2"),
             (0.82, "linear SVM\nscore and bit")]
    for x, label in boxes:
        ax.text(x, .5, label, transform=ax.transAxes, ha="left", va="center", fontsize=12,
                bbox=dict(boxstyle="round,pad=.6", facecolor="#f3f4f6", edgecolor="#374151"))
    for x in (.17, .38, .57, .77):
        ax.annotate("", xy=(x + .035, .5), xytext=(x, .5), xycoords=ax.transAxes,
                    arrowprops=dict(arrowstyle="->", linewidth=2, color="#111827"))
    ax.set_title("What PCA30 means in this classifier", fontsize=16, pad=18)
    fig.tight_layout(); fig.savefig(out / "pca30_pipeline_explainer.png", bbox_inches="tight"); plt.close(fig)

    summary = {
        "samples": int(len(y)), "raw_features": raw_names,
        "polynomial_features": poly_names.tolist(), "retained_principal_components": 30,
        "pc1_variance_percent": float(pca.explained_variance_ratio_[0] * 100),
        "pc2_variance_percent": float(pca.explained_variance_ratio_[1] * 100),
        "pc1_pc2_variance_percent": float(pca.explained_variance_ratio_[:2].sum() * 100),
        "pc1_to_pc30_variance_percent": float(pca.explained_variance_ratio_.sum() * 100),
        "all_data_visual_fit_errors": int(np.sum(prediction != y)),
        "fused_standardized_polynomial_weights": dict(zip(poly_names, fused_weight.tolist())),
        "fused_bias": fused_bias,
        "divider_note": "2D and 3D figures are local slices of a 30-dimensional hyperplane, not the complete divider.",
    }
    (out / "summary.json").write_text(json.dumps(summary, indent=2), encoding="utf-8")
    print(json.dumps({key: value for key, value in summary.items()
                      if key not in {"polynomial_features", "fused_standardized_polynomial_weights"}}, indent=2))


if __name__ == "__main__":
    main()
