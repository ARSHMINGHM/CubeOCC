#!/usr/bin/env python3
"""Fair comparison of cell classifiers: leave-one-capture-set-out cross-validation.

Why this script exists
  A single random train/test split (unseeded, ~12 sets) can not be compared with
  a baseline measured on all 62 sets. Here every capture set is held out once,
  every method is scored on the same cells, and the baselines are scored on the
  same cells as the SVMs.

Cells scored: payload cells of DATA frames (golden frame index 1..11, corner
cells excluded). START, END and the four always-white corners are trivial and
only inflate accuracy.

Methods
  A  current sampler output (bits already in --frames)
  B  per-frame 2-means threshold on the cell mean (no training)
  C  LinearSVC on raw [mean, var, max, min, neighbor_mean]
  D  LinearSVC on [mean] only (a learned global threshold)
  E  C divided by the frame's white reference (corner mean)
  F  LinearSVC on [mean, neighbor_mean] relative to the frame's 2-means levels
  G  C + white reference + 2-means levels
  H, I, J  ablations of E: mean only, mean + neighbor, E without the neighbor feature
All frame-level references use only values that exist at frame end in a
streaming design (64 per-cell sums), no frame buffer needed.

"Worst sets" are chosen automatically (largest sampler error), not by hand.

Usage
  python svm_cv_report.py --frames symbols_review.json \
      --image-dir sim/cubeocc_top_all_guard/camera_gray [--golden-jsonl X.jsonl] \
      [--preprocess none|opt4] [--out svm_cv]
"""
import argparse, csv, json, sys, warnings
from pathlib import Path
import numpy as np

sys.path.insert(0, str(Path(__file__).resolve().parent))
import cell_error_report as cer          # same golden / alignment code as the baseline

warnings.filterwarnings("ignore")
W, H, CW, CH = 160, 120, 20, 15
YY, XX = np.mgrid[0:CH, 0:CW]
MASK = ((XX - 10) ** 2 + (YY - 7) ** 2) <= 25
CORNERS = [0, 7, 56, 63]
DATA_CELLS = np.array([c for c in range(64) if c not in CORNERS])

def preprocess_opt4(arr):
    """Median 3x3 + 10th-percentile background subtraction + autocontrast + unsharp (the dashboard's option 4)."""
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
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--frames", required=True)
    ap.add_argument("--image-dir", required=True)
    ap.add_argument("--grades", help="symbols_review.json with grades, when --frames is a fresh results.json")
    ap.add_argument("--golden-jsonl")
    ap.add_argument("--preprocess", choices=["none", "opt4"], default="none")
    ap.add_argument("--worst", type=int, default=10, help="how many sets (by sampler error) count as 'worst'")
    ap.add_argument("--out", default="svm_cv")
    a = ap.parse_args()

    import pandas as pd
    from sklearn.svm import LinearSVC
    from sklearn.preprocessing import StandardScaler

    by = cer.load_frames(a.frames, a.grades)
    gold = cer.golden_from_jsonl(a.golden_jsonl) if a.golden_jsonl else cer.golden_from_votes(by)
    gold_cells = [np.array([int(ch) for ch in g[::-1]]) for g in gold]       # index = cell
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
                                 mean=m[c], var=v[c], mx=mx[c], mn=mn[c], nb=nb[c], white=white, lo=lo, hi=hi,
                                 samp=int(sb[63 - c])))
    if not rows:
        raise SystemExit("no images found under --image-dir")
    if missing:
        print(f"note: {missing} frames had no image and were skipped")
    df = pd.DataFrame(rows)
    df = df[(df.gidx >= 1) & (df.gidx <= 11) & (~df.cell.isin(CORNERS))].reset_index(drop=True)
    sets = sorted(df.set.unique())
    print(f"{len(sets)} capture sets, {len(df)} payload cells, preprocess={a.preprocess}")

    df["otsu"] = (df["mean"] > (df.lo + df.hi) / 2).astype(int)
    rng = (df.hi - df.lo).clip(lower=20)
    df["m_w"] = df["mean"] / df.white; df["v_w"] = df["var"] / df.white ** 2
    df["mx_w"] = df.mx / df.white;     df["mn_w"] = df.mn / df.white; df["nb_w"] = df.nb / df.white
    df["m_r"] = (df["mean"] - df.lo) / rng; df["nb_r"] = (df.nb - df.lo) / rng
    feats = {
        "C SVM raw 5 features": ["mean", "var", "mx", "mn", "nb"],
        "D SVM mean only": ["mean"],
        "E SVM 5 / white ref": ["m_w", "v_w", "mx_w", "mn_w", "nb_w"],
        "F SVM mean+nb rel. to 2-means": ["m_r", "nb_r"],
        "G SVM raw 5 + white + 2-means": ["mean", "var", "mx", "mn", "nb", "white", "lo", "hi"],
        # ablations: does the neighbor feature add anything once the frame level is known?
        "H SVM mean / white only": ["m_w"],
        "I SVM mean / white + nb / white": ["m_w", "nb_w"],
        "J SVM E without neighbor": ["m_w", "v_w", "mx_w", "mn_w"],
    }
    for name, cols in feats.items():
        df[name] = -1
    for held in sets:
        tr, te = df[df.set != held], df[df.set == held]
        for name, cols in feats.items():
            sc = StandardScaler().fit(tr[cols])
            clf = LinearSVC(C=1.0, max_iter=20000).fit(sc.transform(tr[cols]), tr.y)
            df.loc[te.index, name] = clf.predict(sc.transform(te[cols]))

    methods = [("A current sampler", "samp"), ("B per-frame 2-means", "otsu")] + [(k, k) for k in feats]
    per_set = {s: 100 * (df[df.set == s].samp != df[df.set == s].y).mean() for s in sets}
    worst = set(sorted(per_set, key=per_set.get, reverse=True)[:a.worst])
    err = lambda d, c: 100 * (d[c] != d.y).mean()
    W_, R_ = df[df.set.isin(worst)], df[~df.set.isin(worst)]
    print(f"\nworst {a.worst} sets (by current sampler error): {', '.join(sorted(w[6:9] for w in worst))}")
    print(f"{'method':34s} {'all sets':>9s} {'worst':>8s} {'others':>8s}   (payload cell error %)")
    for name, col in methods:
        print(f"{name:34s} {err(df, col):9.2f} {err(W_, col):8.2f} {err(R_, col):8.2f}")

    out = Path(a.out); out.mkdir(parents=True, exist_ok=True)
    with (out / "per_set.csv").open("w", newline="") as fh:
        w = csv.writer(fh); w.writerow(["set"] + [n for n, _ in methods])
        for s in sets:
            d = df[df.set == s]; w.writerow([s] + [f"{err(d, c):.2f}" for _, c in methods])
    print(f"\nwrote {out / 'per_set.csv'}")

if __name__ == "__main__":
    main()