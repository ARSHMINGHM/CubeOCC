#!/usr/bin/env python3
"""SVM cross-validation with linear / poly2 / rbf kernels.

Usage:
  python svm_cv_report.py --frames symbols_review.json \
      --image-dir sim/cubeocc_top_all_guard/camera_gray \
      [--preprocess none|gaussian|opt4] \
      [--kernel linear|poly2|rbf|rbf-exact|both] \
      [--nonlinear-only] [--rbf-components 100] [--n-jobs -1] \
      [--out svm_cv]
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

FPGA_COST = {
    "A": ("A",  "0 mult, 1 cmp", "no training, rule only"),
    "B": ("A",  "0 mult, 1 cmp", "2-means threshold"),
    "D": ("L1", "1 mult + add",  "learned threshold"),
    "C": ("L5", "5 mult + adds", "5 features"),
    "E": ("L5", "5 mult + adds", "5 features"),
    "F": ("L2", "2 mult + adds", "2 features"),
    "G": ("L8", "8 mult + adds", "8 features"),
    "H": ("L1", "1 mult + add",  "1 feature"),
    "I": ("L2", "2 mult + adds", "2 features (production)"),
    "J": ("L4", "4 mult + adds", "4 features"),
    "K": ("L3", "3 mult + adds", "3 features (E-reduced)"),
}

NONLINEAR_ONLY_METHODS = {"E SVM 5 / white ref", "I SVM mean / white + nb / white"}


def poly2_n_terms(n_in):
    return n_in + n_in * (n_in + 1) // 2


def cost_class(method_name, n_components=200):
    if "[RBF" in method_name:
        return ("RBF*", f"~{n_components} SVs + exp()", "not FPGA-friendly")
    if "[poly2-" in method_name:
        n_out = int(method_name.split("[poly2-")[1].rstrip("]"))
        return (f"P{n_out}", f"{n_out} monomials", "poly2 expansion")
    tag = method_name.strip()[0]
    return FPGA_COST.get(tag, ("?", "?", "?"))


def preprocess_opt4(arr):
    from PIL import Image, ImageFilter, ImageOps
    img = Image.fromarray(arr).filter(ImageFilter.MedianFilter(size=3))
    a = np.array(img).astype(np.int16)
    a = np.clip(a - np.percentile(a, 10), 0, 255).astype(np.uint8)
    return np.array(ImageOps.autocontrast(Image.fromarray(a), cutoff=2).filter(
        ImageFilter.UnsharpMask(radius=2, percent=150, threshold=3)))


def preprocess_gaussian(arr, sigma):
    from PIL import Image, ImageFilter
    if sigma <= 0:
        return arr
    return np.array(Image.fromarray(arr).filter(ImageFilter.GaussianBlur(radius=float(sigma))))


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


def resolve_gamma(gamma, n_features):
    if isinstance(gamma, str):
        if gamma in ("scale", "auto"):
            return 1.0 / max(n_features, 1)
        raise ValueError(f"unknown gamma spec: {gamma}")
    return float(gamma)


def make_classifier(kern, rbf_gamma, n_components, n_features):
    from sklearn.svm import LinearSVC, SVC
    from sklearn.kernel_approximation import Nystroem
    from sklearn.pipeline import make_pipeline
    from sklearn.preprocessing import PolynomialFeatures

    if kern == "linear":
        return LinearSVC(C=1.0, max_iter=20000)
    if kern == "poly2":
        return make_pipeline(
            PolynomialFeatures(degree=2, include_bias=False),
            LinearSVC(C=1.0, max_iter=20000),
        )
    if kern == "rbf-exact":
        return SVC(kernel="rbf", C=1.0, gamma=resolve_gamma(rbf_gamma, n_features))
    if kern == "rbf":
        nys = Nystroem(kernel="rbf", gamma=resolve_gamma(rbf_gamma, n_features),
                       n_components=n_components, random_state=0)
        return make_pipeline(nys, LinearSVC(C=1.0, max_iter=20000))
    raise ValueError(f"unknown kernel {kern}")


def fit_one_task(held, name, te_index, X_tr, y_tr, X_te, kern, rbf_gamma, n_components):
    from sklearn.preprocessing import StandardScaler
    sc = StandardScaler().fit(X_tr)
    clf = make_classifier(kern, rbf_gamma, n_components, X_tr.shape[1])
    clf.fit(sc.transform(X_tr), y_tr)
    preds = clf.predict(sc.transform(X_te))
    return held, name, te_index, preds


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--frames", required=True)
    ap.add_argument("--image-dir", required=True)
    ap.add_argument("--grades")
    ap.add_argument("--golden-jsonl")
    ap.add_argument("--preprocess", choices=["none", "gaussian", "opt4"], default="none")
    ap.add_argument("--gauss-sigma", type=float, default=0.75)
    ap.add_argument("--kernel",
                    choices=["linear", "poly2", "rbf", "rbf-exact", "both"],
                    default="linear")
    ap.add_argument("--rbf-gamma", default="scale")
    ap.add_argument("--rbf-components", type=int, default=200)
    ap.add_argument("--nonlinear-only", action="store_true",
                    help="Run nonlinear variants only for methods E and I")
    ap.add_argument("--n-jobs", type=int, default=-1)
    ap.add_argument("--worst", type=int, default=10)
    ap.add_argument("--out", default="svm_cv")
    a = ap.parse_args()

    import pandas as pd
    try:
        rbf_gamma = float(a.rbf_gamma)
    except ValueError:
        rbf_gamma = a.rbf_gamma

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
                missing += 1
                continue
            from PIL import Image
            img = np.array(Image.open(p).convert("L"))
            if a.preprocess == "opt4":
                img = preprocess_opt4(img)
            elif a.preprocess == "gaussian":
                img = preprocess_gaussian(img, a.gauss_sigma)
            m, v, mx, mn = cell_stats(img)
            nb = neighbor_mean(m)
            white = m[CORNERS].mean()
            lo, hi = two_means(m[DATA_CELLS])
            sb = f["bits"]
            for c in range(64):
                rows.append(dict(set=s, key=f["key"], gidx=j, cell=c,
                                 y=int(gold_cells[j][c]),
                                 mean=m[c], var=v[c], mx=mx[c], mn=mn[c], nb=nb[c],
                                 white=white, lo=lo, hi=hi,
                                 samp=int(sb[63 - c])))
    if not rows:
        raise SystemExit("no images found under --image-dir")
    if missing:
        print(f"note: {missing} frames had no image and were skipped")
    df = pd.DataFrame(rows)
    df = df[(df.gidx >= 1) & (df.gidx <= 11) & (~df.cell.isin(CORNERS))].reset_index(drop=True)
    sets = sorted(df.set.unique())
    print(f"{len(sets)} capture sets, {len(df)} payload cells, preprocess={a.preprocess}"
          + (f" (sigma={a.gauss_sigma})" if a.preprocess == "gaussian" else "")
          + f", kernel={a.kernel}, n_jobs={a.n_jobs}")

    df["otsu"] = (df["mean"] > (df.lo + df.hi) / 2).astype(int)
    rng = (df.hi - df.lo).clip(lower=20)
    df["m_w"] = df["mean"] / df.white
    df["v_w"] = df["var"] / df.white ** 2
    df["mx_w"] = df.mx / df.white
    df["mn_w"] = df.mn / df.white
    df["nb_w"] = df.nb / df.white
    df["m_r"] = (df["mean"] - df.lo) / rng
    df["nb_r"] = (df.nb - df.lo) / rng

    feats = {
        "C SVM raw 5 features": ["mean", "var", "mx", "mn", "nb"],
        "D SVM mean only": ["mean"],
        "E SVM 5 / white ref": ["m_w", "v_w", "mx_w", "mn_w", "nb_w"],
        "F SVM mean+nb rel. to 2-means": ["m_r", "nb_r"],
        "G SVM raw 5 + white + 2-means": ["mean", "var", "mx", "mn", "nb", "white", "lo", "hi"],
        "H SVM mean / white only": ["m_w"],
        "I SVM mean / white + nb / white": ["m_w", "nb_w"],
        "J SVM E without neighbor": ["m_w", "v_w", "mx_w", "mn_w"],
        "K SVM E-reduced (3 feat)": ["m_w", "v_w", "nb_w"],
    }

    method_configs = []
    for name, cols in feats.items():
        if a.kernel in ("linear", "both"):
            method_configs.append((name, cols, "linear"))
        if a.kernel in ("poly2", "rbf", "rbf-exact", "both"):
            if a.nonlinear_only and name not in NONLINEAR_ONLY_METHODS:
                continue
            if a.kernel in ("poly2", "both"):
                n_out = poly2_n_terms(len(cols))
                method_configs.append((f"{name} [poly2-{n_out}]", cols, "poly2"))
            if a.kernel in ("rbf", "rbf-exact", "both"):
                tag = "rbf-exact" if a.kernel == "rbf-exact" else "rbf"
                sfx = " [RBF]" if tag == "rbf" else " [RBF-exact]"
                method_configs.append((name + sfx, cols, tag))

    for name, _, _ in method_configs:
        df[name] = -1

    print(f"running {len(sets) * len(method_configs)} fits "
          f"({len(sets)} sets x {len(method_configs)} methods)...")

    from joblib import Parallel, delayed
    tasks = []
    for held in sets:
        tr_mask = (df.set != held).values
        te_mask = (df.set == held).values
        y_tr = df.loc[tr_mask, "y"].values
        te_index = df.index[te_mask].values
        for name, cols, kern in method_configs:
            tasks.append((held, name, te_index,
                          df.loc[tr_mask, cols].values, y_tr,
                          df.loc[te_mask, cols].values, kern))

    results = Parallel(n_jobs=a.n_jobs, backend="loky", verbose=5)(
        delayed(fit_one_task)(held, name, te_index, X_tr, y_tr, X_te, kern,
                              rbf_gamma, a.rbf_components)
        for (held, name, te_index, X_tr, y_tr, X_te, kern) in tasks
    )
    for (held, name, te_index, preds) in results:
        df.loc[te_index, name] = preds

    methods = [("A current sampler", "samp"), ("B per-frame 2-means", "otsu")] \
              + [(n, n) for n, _, _ in method_configs]
    per_set = {s: 100 * (df[df.set == s].samp != df[df.set == s].y).mean() for s in sets}
    worst = set(sorted(per_set, key=per_set.get, reverse=True)[:a.worst])
    err = lambda d, c: 100 * (d[c] != d.y).mean()
    W_, R_ = df[df.set.isin(worst)], df[~df.set.isin(worst)]

    print(f"\nworst {a.worst} sets (by current sampler error): "
          f"{', '.join(sorted(w[6:9] for w in worst))}")
    print()
    header = f"{'method':48s} {'all':>7s} {'worst':>7s} {'others':>7s}  {'FPGA cost':<22s}  note"
    print(header)
    print("-" * len(header))
    for name, col in methods:
        _, cost_str, cost_note = cost_class(name, a.rbf_components)
        print(f"{name:48s} {err(df, col):7.2f} {err(W_, col):7.2f} {err(R_, col):7.2f}  "
              f"{cost_str:<22s}  {cost_note}")

    fpa = [(n, c) for n, c in methods
           if not cost_class(n, a.rbf_components)[0].startswith("RBF")]
    best_err = min(err(df, c) for _, c in fpa)
    thr = best_err + 0.2
    cands = sorted([(n, c, err(df, c)) for n, c in fpa if err(df, c) <= thr],
                   key=lambda x: x[2])
    print(f"\nFPGA-friendly candidates within {thr:.2f}% (best={best_err:.2f}%):")
    for n, c, e in cands:
        _, s, note = cost_class(n, a.rbf_components)
        print(f"  {n:48s} {e:6.2f}%   [{s}] {note}")

    rbf_m = [(n, c) for n, c in methods
             if cost_class(n, a.rbf_components)[0].startswith("RBF")]
    if rbf_m:
        b = min(rbf_m, key=lambda x: err(df, x[1]))
        print(f"\nBest RBF (reference only, not FPGA): {b[0]} {err(df, b[1]):.2f}%")

    out = Path(a.out)
    out.mkdir(parents=True, exist_ok=True)
    with (out / "per_set.csv").open("w", newline="") as fh:
        w = csv.writer(fh)
        w.writerow(["set"] + [n for n, _ in methods])
        for s in sets:
            d = df[df.set == s]
            w.writerow([s] + [f"{err(d, c):.2f}" for _, c in methods])
    print(f"\nwrote {out / 'per_set.csv'}")

    summary = {
        "preprocess": a.preprocess,
        "kernel": a.kernel,
        "nonlinear_only": a.nonlinear_only,
        "n_jobs": a.n_jobs,
        "rbf_gamma": a.rbf_gamma,
        "rbf_components": a.rbf_components if a.kernel in ("rbf", "both") else None,
        "n_sets": len(sets),
        "n_cells": len(df),
        "worst_sets": sorted(w[6:9] for w in worst),
        "all_sets_error": {n: round(err(df, c), 4) for n, c in methods},
        "worst_10_error": {n: round(err(W_, c), 4) for n, c in methods},
        "others_error": {n: round(err(R_, c), 4) for n, c in methods},
        "fpga_cost_class": {n: cost_class(n, a.rbf_components)[0] for n, _ in methods},
        "fpga_cost_string": {n: cost_class(n, a.rbf_components)[1] for n, _ in methods},
    }
    (out / "summary.json").write_text(json.dumps(summary, indent=2), encoding="utf-8")
    print(f"wrote {out / 'summary.json'}")


if __name__ == "__main__":
    main()