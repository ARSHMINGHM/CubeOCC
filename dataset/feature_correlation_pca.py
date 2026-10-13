#!/usr/bin/env python3
"""Correlation matrix and PCA analysis for the cell-level features.

Purpose
  Understand which of the 8 candidate features are redundant, and how many
  principal components carry most of the variance. The output informs feature
  selection: if two features are highly correlated, keeping both wastes FPGA
  multipliers. If PCA finds that 2 components explain 95% of variance, then a
  linear SVM on those components should match the full-feature SVM.

Usage
  python feature_correlation_pca.py \
    --frames sim/cubeocc_top_all/symbols_review/symbols_review.json \
    --image-dir sim/cubeocc_top_all_guard/camera_gray \
    [--preprocess none|opt4] [--out feature_analysis]
"""
import argparse, csv, json, sys, warnings
from pathlib import Path
import numpy as np

sys.path.insert(0, str(Path(__file__).resolve().parent))
import cell_error_report as cer

warnings.filterwarnings("ignore")
W, H, CW, CH = 160, 120, 20, 15
YY, XX = np.mgrid[0:CH, 0:CW]
MASK = ((XX - 10) ** 2 + (YY - 7) ** 2) <= 25
CORNERS = [0, 7, 56, 63]
DATA_CELLS = np.array([c for c in range(64) if c not in CORNERS])


def preprocess_opt4(arr):
    from PIL import Image, ImageFilter, ImageOps
    img = Image.fromarray(arr).filter(ImageFilter.MedianFilter(size=3))
    a = np.array(img).astype(np.int16)
    a = np.clip(a - np.percentile(a, 10), 0, 255).astype(np.uint8)
    return np.array(ImageOps.autocontrast(Image.fromarray(a), cutoff=2).filter(
        ImageFilter.UnsharpMask(radius=2, percent=150, threshold=3)))


def two_means(v):
    lo, hi = float(v.min()), float(v.max())
    for _ in range(20):
        th = (lo + hi) / 2
        a, b = v[v <= th], v[v > th]
        if len(a) == 0 or len(b) == 0:
            break
        lo, hi = a.mean(), b.mean()
    return lo, hi


def cell_stats(img):
    m = np.zeros(64); v = np.zeros(64); mx = np.zeros(64); mn = np.zeros(64)
    for c in range(64):
        r, cc = divmod(c, 8)
        px = img[r * CH:(r + 1) * CH, cc * CW:(cc + 1) * CW].astype(float)[MASK]
        m[c], v[c], mx[c], mn[c] = px.mean(), px.var(), px.max(), px.min()
    return m, v, mx, mn


def neighbor_mean(m):
    g = m.reshape(8, 8); out = np.zeros((8, 8))
    for r in range(8):
        for c in range(8):
            n = []
            if r > 0: n.append(g[r - 1, c])
            if r < 7: n.append(g[r + 1, c])
            if c > 0: n.append(g[r, c - 1])
            if c < 7: n.append(g[r, c + 1])
            out[r, c] = np.mean(n)
    return out.ravel()


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--frames", required=True)
    ap.add_argument("--image-dir", required=True)
    ap.add_argument("--grades")
    ap.add_argument("--golden-jsonl")
    ap.add_argument("--preprocess", choices=["none", "opt4"], default="none")
    ap.add_argument("--out", default="feature_analysis")
    a = ap.parse_args()

    import pandas as pd
    from sklearn.decomposition import PCA
    from sklearn.preprocessing import StandardScaler

    by = cer.load_frames(a.frames, a.grades)
    gold = cer.golden_from_jsonl(a.golden_jsonl) if a.golden_jsonl else cer.golden_from_votes(by)
    gold_cells = [np.array([int(ch) for ch in g[::-1]]) for g in gold]
    image_dir = Path(a.image_dir)

    rows, missing = [], 0
    for s, frames in by.items():
        path = cer.align(frames, gold)
        for f, j in zip(frames, path):
            p = image_dir / f["key"]
            if not p.exists():
                missing += 1; continue
            from PIL import Image
            img = np.array(Image.open(p).convert("L"))
            if a.preprocess == "opt4":
                img = preprocess_opt4(img)
            m, v, mx, mn = cell_stats(img); nb = neighbor_mean(m)
            white = m[CORNERS].mean(); lo, hi = two_means(m[DATA_CELLS])
            sb = f["bits"]
            for c in range(64):
                rows.append(dict(set=s, key=f["key"], gidx=j, cell=c, y=int(gold_cells[j][c]),
                                 mean=m[c], var=v[c], mx=mx[c], mn=mn[c], nb=nb[c],
                                 white=white, lo=lo, hi=hi,
                                 samp=int(sb[63 - c])))
    if not rows:
        raise SystemExit("no images found under --image-dir")
    if missing:
        print(f"note: {missing} frames had no image and were skipped")

    df = pd.DataFrame(rows)
    df = df[(df.gidx >= 1) & (df.gidx <= 11) & (~df.cell.isin(CORNERS))].reset_index(drop=True)
    print(f"{len(df)} payload cells")

    # Build the raw features first
    df["otsu"] = (df["mean"] > (df.lo + df.hi) / 2).astype(int)
    rng = (df.hi - df.lo).clip(lower=20)
    df["m_w"] = df["mean"] / df.white
    df["v_w"] = df["var"] / df.white ** 2
    df["mx_w"] = df.mx / df.white
    df["mn_w"] = df.mn / df.white
    df["nb_w"] = df.nb / df.white
    df["m_r"] = (df["mean"] - df.lo) / rng
    df["nb_r"] = (df.nb - df.lo) / rng

    feature_names = ["mean", "var", "mx", "mn", "nb", "white",
                     "m_w", "v_w", "mx_w", "mn_w", "nb_w", "m_r", "nb_r"]
    X = df[feature_names].values.astype(float)

    print("\n" + "=" * 78)
    print("Correlation matrix (Pearson)")
    print("=" * 78)
    corr = pd.DataFrame(X, columns=feature_names).corr()
    # Compact print
    print(f"{'':>8s}" + "".join(f"{n:>8s}" for n in feature_names))
    for i, n in enumerate(feature_names):
        row = "".join(f"{corr.iloc[i, j]:8.2f}" for j in range(len(feature_names)))
        print(f"{n:>8s}{row}")

    # Also save the correlation matrix
    out = Path(a.out); out.mkdir(parents=True, exist_ok=True)
    corr.to_csv(out / "correlation.csv")

    # Flag highly correlated pairs (|r| > 0.85)
    print("\nHighly correlated pairs (|r| > 0.85):")
    seen = set()
    for i in range(len(feature_names)):
        for j in range(i + 1, len(feature_names)):
            r = corr.iloc[i, j]
            if abs(r) > 0.85:
                print(f"  {feature_names[i]:>8s} <-> {feature_names[j]:<8s}  r = {r:+.3f}")

    # PCA on standardized features
    print("\n" + "=" * 78)
    print("PCA on standardized features")
    print("=" * 78)
    Xs = StandardScaler().fit_transform(X)
    pca = PCA().fit(Xs)
    evr = pca.explained_variance_ratio_
    cum = np.cumsum(evr)

    print(f"{'PC':>4s} {'var %':>8s} {'cum %':>8s}   top 3 loadings")
    for i in range(len(feature_names)):
        # Loadings on the original features
        loadings = pca.components_[i]
        idx = np.argsort(np.abs(loadings))[::-1][:3]
        top = ", ".join(f"{feature_names[k]}={loadings[k]:+.2f}" for k in idx)
        print(f"{i+1:>4d} {evr[i]*100:8.2f} {cum[i]*100:8.2f}   {top}")

    n_95 = int(np.argmax(cum >= 0.95)) + 1
    n_99 = int(np.argmax(cum >= 0.99)) + 1
    print(f"\nComponents for 95% variance: {n_95}")
    print(f"Components for 99% variance: {n_99}")

    # PCI reduction feasibility
    if n_95 <= 3:
        print(f"\n-> PCA suggests a {n_95}-component model may match the full-feature SVM.")
    else:
        print(f"\n-> PCA suggests features are not highly redundant ({n_95} components for 95%).")

    # Save summary
    summary = {
        "n_cells": int(len(df)),
        "preprocess": a.preprocess,
        "features": feature_names,
        "correlation_matrix": corr.round(4).to_dict(),
        "pca_explained_variance_ratio": evr.round(4).tolist(),
        "pca_cumulative": cum.round(4).tolist(),
        "components_for_95": n_95,
        "components_for_99": n_99,
    }
    (out / "summary.json").write_text(json.dumps(summary, indent=2), encoding="utf-8")
    print(f"\nwrote {out}/correlation.csv and {out}/summary.json")


if __name__ == "__main__":
    main()