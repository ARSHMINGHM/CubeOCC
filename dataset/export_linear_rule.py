#!/usr/bin/env python3
"""Division-free linear cell rule (method I) for the RTL: cross-validated, then exported.

Model I = LinearSVC on [mean/white, neighbor_mean/white] (see svm_cv_report.py).
Because the features are the cell mean and the neighbor mean divided by the same
frame white reference, the decision is

      sign( a*mean + b*nb + c*white )          (white > 0)

i.e. no divider, no bias, no variance/max/min accumulators. In terms of the
integer per-cell sums S (81 pixels of the circle) already produced by the sampler:

      score = Wc * S_cell  +  Wn[n] * sum(S of the n neighbors)  +  Ww * sum(S of the 4 corners)
      bit   = score > 0

with n = 2 (grid corner), 3 (edge) or 4 (interior); the 1/n of the neighbor mean
and the 1/81 and 1/4 of the means are folded into Wn[n], Wc and Ww.

This script (1) cross-validates leave-one-capture-set-out with float weights,
with the division-free float form (must give identical bits), and with integer
weights of several widths; (2) trains on all payload cells and prints the
constants. It scores payload cells of DATA frames only, like svm_cv_report.py.

  python export_linear_rule.py --frames results.json --grades symbols_review.json \
      --image-dir sim/.../camera_gray [--white-ref mean4|median4|max4] [--bits 12] [--out linear_rule]
"""
import argparse, json, sys, warnings
from pathlib import Path
import numpy as np

sys.path.insert(0, str(Path(__file__).resolve().parent))
import cell_error_report as cer
import svm_cv_report as scv

warnings.filterwarnings("ignore")
CORNERS = scv.CORNERS

def white_ref(m, mode):
    c = m[CORNERS]
    return {"mean4": c.mean(), "median4": float(np.median(c)), "max4": c.max()}[mode]

def n_neighbors(cell):
    r, c = divmod(cell, 8)
    return (r > 0) + (r < 7) + (c > 0) + (c < 7)

def build(a):
    from PIL import Image
    import pandas as pd
    by = cer.load_frames(a.frames, a.grades)
    gold = cer.golden_from_jsonl(a.golden_jsonl) if a.golden_jsonl else cer.golden_from_votes(by)
    gold_cells = [np.array([int(ch) for ch in g[::-1]]) for g in gold]
    rows = []
    for s, frames in by.items():
        path = cer.align(frames, gold)
        for f, j in zip(frames, path):
            p = Path(a.image_dir) / f["key"]
            if not p.exists() or not (1 <= j <= 11):
                continue
            img = np.array(Image.open(p).convert("L"))
            m, v, mx, mn = scv.cell_stats(img)
            nb = scv.neighbor_mean(m)
            w = white_ref(m, a.white_ref)
            S = np.rint(m * 81).astype(np.int64)                      # exact integer sums of the 81-pixel circle
            for c in range(64):
                if c in CORNERS:
                    continue
                nbr = []
                r, cc = divmod(c, 8)
                if r > 0: nbr.append(c - 8)
                if r < 7: nbr.append(c + 8)
                if cc > 0: nbr.append(c - 1)
                if cc < 7: nbr.append(c + 1)
                rows.append(dict(set=s, cell=c, y=int(gold_cells[j][c]), mean=m[c], nb=nb[c], white=w,
                                 S=int(S[c]), Snb=int(sum(S[k] for k in nbr)), n=len(nbr),
                                 Scorn=int(sum(S[k] for k in CORNERS)),
                                 samp=int(f["bits"][63 - c])))
    return pd.DataFrame(rows)

def fit(tr):
    from sklearn.svm import LinearSVC
    from sklearn.preprocessing import StandardScaler
    X = np.c_[tr["mean"] / tr.white, tr.nb / tr.white]
    sc = StandardScaler().fit(X)
    clf = LinearSVC(C=1.0, max_iter=20000).fit(sc.transform(X), tr.y)
    w1, w2 = clf.coef_[0]; s1, s2 = sc.scale_; u1, u2 = sc.mean_
    alpha, beta = w1 / s1, w2 / s2
    gamma = clf.intercept_[0] - w1 * u1 / s1 - w2 * u2 / s2          # sign(alpha*m + beta*nb + gamma*white)
    return clf, sc, (alpha, beta, gamma)

def float_predict_sklearn(clf, sc, d):
    return clf.predict(sc.transform(np.c_[d["mean"] / d.white, d.nb / d.white]))

def rule_float(coef, d):
    a, b, g = coef
    return (a * d["mean"] + b * d.nb + g * d.white > 0).astype(int)

def int_constants(coef, bits):
    a, b, g = coef
    # folded constants acting on the integer sums S:
    Wc = a / 81.0                       # S_cell/81 = mean
    Wn = {n: b / (81.0 * n) for n in (2, 3, 4)}
    Ww = g / (4 * 81.0)                 # white = (sum of 4 corner sums)/(4*81)
    mx = max(abs(Wc), abs(Ww), *[abs(v) for v in Wn.values()])
    k = (2 ** (bits - 1) - 1) / mx
    q = lambda x: int(np.rint(x * k))
    return dict(Wc=q(Wc), Wn2=q(Wn[2]), Wn3=q(Wn[3]), Wn4=q(Wn[4]), Ww=q(Ww)), k

def rule_int(consts, d):
    wn = d.n.map({2: consts["Wn2"], 3: consts["Wn3"], 4: consts["Wn4"]})
    score = consts["Wc"] * d.S + wn * d.Snb + consts["Ww"] * d.Scorn
    return (score > 0).astype(int)

def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--frames", required=True); ap.add_argument("--grades")
    ap.add_argument("--image-dir", required=True); ap.add_argument("--golden-jsonl")
    ap.add_argument("--white-ref", choices=["mean4", "median4", "max4"], default="mean4")
    ap.add_argument("--bits", type=int, default=12)
    ap.add_argument("--out", default="linear_rule")
    a = ap.parse_args()

    df = build(a)
    sets = sorted(df.set.unique())
    print(f"{len(sets)} capture sets, {len(df)} payload cells, white reference = {a.white_ref}")
    widths = [8, 10, 12, 16]
    pred = {k: np.zeros(len(df), int) for k in ["sklearn", "float rule"] + [f"int{b}" for b in widths]}
    for held in sets:
        tr = df[df.set != held]; te = df[df.set == held]
        clf, sc, coef = fit(tr)
        pred["sklearn"][te.index] = float_predict_sklearn(clf, sc, te)
        pred["float rule"][te.index] = rule_float(coef, te)
        for b in widths:
            if a.white_ref == "mean4":          # the integer form uses the sum of the 4 corners = mean4
                consts, _ = int_constants(coef, b)
                pred[f"int{b}"][te.index] = rule_int(consts, te)
            else:
                pred[f"int{b}"][te.index] = pred["float rule"][te.index]
    err = lambda p: 100 * (p != df.y.values).mean()
    print("\nleave-one-capture-set-out payload cell error %:")
    print(f"  current sampler (for reference)          {err(df.samp.values):6.2f}")
    print(f"  model I, sklearn (float, with division)  {err(pred['sklearn']):6.2f}")
    print(f"  same rule, division-free float           {err(pred['float rule']):6.2f}"
          f"   (bits differing from sklearn: {int((pred['sklearn'] != pred['float rule']).sum())})")
    if a.white_ref != "mean4":
        print("  (integer rows are only meaningful with --white-ref mean4; copied from the float rule here)")
    for b in widths:
        print(f"  integer weights, {b:2d} bits                 {err(pred[f'int{b}']):6.2f}"
              f"   (bits differing from float rule: {int((pred['float rule'] != pred[f'int{b}']).sum())})")

    clf, sc, coef = fit(df)
    consts, k = int_constants(coef, a.bits)
    print("\nfinal rule trained on all payload cells (in-sample, not an accuracy estimate):")
    print(f"  score = {coef[0]:+.6f}*mean {coef[1]:+.6f}*neighbor_mean {coef[2]:+.6f}*white   (bit = score > 0)")
    print(f"\ninteger constants on the sums S (circle of 81 pixels), {a.bits}-bit signed, scale 2^x = {k:.4g}:")
    for name, v in consts.items():
        print(f"  localparam signed [{a.bits-1}:0] {name.upper():4s} = {v};")
    print("  // score = WC*S_cell + WN{n}*(sum of neighbor S) + WW*(S_TL+S_TR+S_BL+S_BR);  bit = score > 0")
    out = Path(a.out); out.mkdir(parents=True, exist_ok=True)
    (out / "rule.json").write_text(json.dumps({"white_ref": a.white_ref, "float_coef_mean_nb_white": coef,
                                               "int_bits": a.bits, "int_constants": consts}, indent=2))
    print(f"\nwrote {out / 'rule.json'}")

if __name__ == "__main__":
    main()