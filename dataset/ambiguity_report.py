#!/usr/bin/env python3
"""Can a count of 'uncertain' cells flag unreliable (transition / blended) frames?

For every DATA frame the linear rule gives each payload cell a margin
      d = (mean - threshold) / white
i.e. how far the cell is from the decision boundary in units of the white level.
A cell is 'uncertain' if |d| < delta. U(delta) = number of uncertain cells in the frame.
A frame is flagged when U >= N. This script measures, for a grid of (delta, N):

  flagged      share of DATA frames flagged
  good lost    share of frames with <= 1 wrong cell that would be flagged (cost)
  err removed  share of all wrong cells that sit in flagged frames (benefit)
  bad caught   share of frames with >= 3 wrong cells that are flagged

and recommends the pair with the largest 'err removed' while 'good lost' stays below
--max-good-lost (default 5 %). Wrong cells are rule decisions vs the golden message.

Usage:
  python ambiguity_report.py --frames results.json --grades symbols_review.json \
      --image-dir sim/.../camera_gray [--coef A B G] [--max-good-lost 5] [--out ambiguity]
Default coefficients: the 62-set fit of --white-ref start (mean, neighbor, white).
"""
import argparse, csv, sys
from pathlib import Path
import numpy as np

sys.path.insert(0, str(Path(__file__).resolve().parent))
import export_linear_rule as ex

DEFAULT_COEF = (5.752914414109695, -1.5290268788175847, -3.1647125466755264)


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--frames", required=True); ap.add_argument("--grades")
    ap.add_argument("--image-dir", required=True); ap.add_argument("--golden-jsonl")
    ap.add_argument("--coef", nargs=3, type=float, default=list(DEFAULT_COEF))
    ap.add_argument("--max-good-lost", type=float, default=5.0)
    ap.add_argument("--exclude", default="MLCAP_048", help="set-name prefix left out of the statistics (content mismatch)")
    ap.add_argument("--out", default="ambiguity")
    a = ap.parse_args()
    a.white_ref = "start"

    df = ex.build(a)
    df = df[~df.set.str.startswith(a.exclude)] if a.exclude else df
    A, B, G = a.coef

    # score = A*mean + B*nb + G*white ; margin in units of white
    df["d"] = (A * df["mean"] + B * df.nb + G * df.white) / (A * df.white)
    df["pred"] = (df.d > 0).astype(int)
    df["wrong"] = (df.pred != df.y).astype(int)

    deltas = [0.05, 0.069, 0.10, 0.15, 0.20, 0.25]

    # Previous decoded frame (START = all ones for the first DATA frame)
    # A blended capture shows intermediate values exactly in the cells
    # that CHANGE between two displayed frames.
    prev = np.ones(len(df), dtype=int)

    for sname, g in df.groupby("set"):
        by_frame = g.groupby(["gidx", "cell"])["pred"].first().to_dict()

        for idx, row in g.iterrows():
            if row.gidx == 1:
                prev[df.index.get_loc(idx)] = 1
            else:
                prev[df.index.get_loc(idx)] = by_frame.get(
                    (row.gidx - 1, row.cell), 1
                )

    df["changed"] = (df.pred.values != prev).astype(int)

    fr = df.groupby(["set", "key"]).agg(
        wrong=("wrong", "sum"),
        cells=("wrong", "size")
    ).reset_index()

    for dl in deltas:
        u = df.assign(
            u=(df.d.abs() < dl).astype(int)
        ).groupby(["set", "key"]).u.sum().reset_index(name=f"U{dl}")
        fr = fr.merge(u, on=["set", "key"])

        t = df.assign(
            t=((df.d.abs() < dl) & (df.changed == 1)).astype(int)
        ).groupby(["set", "key"]).t.sum().reset_index(name=f"T{dl}")
        fr = fr.merge(t, on=["set", "key"])

    n = len(fr)
    tot_err = fr.wrong.sum()
    good = fr.wrong <= 1
    bad = fr.wrong >= 3

    print(
        f"{n} DATA frames ({a.exclude or 'nothing'} excluded), "
        f"{int(tot_err)} wrong cells, "
        f"{int(good.sum())} frames with <=1 wrong, "
        f"{int(bad.sum())} with >=3 wrong"
    )

    for label, prefix, what in (
        ("uncertain cells U", "U", "all uncertain cells"),
        ("changed AND uncertain cells T", "T",
         "cells that changed vs the previous frame and are uncertain")
    ):
        print(f"\n[{prefix}] flag = number of {what} >= N")
        print(
            f"{'delta':>6s} {'N':>3s} {'flagged%':>9s} "
            f"{'good lost%':>11s} {'err removed%':>13s} "
            f"{'bad caught%':>12s}"
        )

        best = None

        for dl in deltas:
            col = fr[f"{prefix}{dl}"]

            for N in (1, 2, 3, 4, 5, 6, 8):
                fl = col >= N

                row = (
                    dl,
                    N,
                    100 * fl.mean(),
                    100 * (fl & good).sum() / good.sum(),
                    100 * fr.wrong[fl].sum() / tot_err,
                    100 * (fl & bad).sum() / max(bad.sum(), 1)
                )

                if 0 < row[2] < 60:
                    print(
                        f"{row[0]:6.2f} {row[1]:3d} "
                        f"{row[2]:9.1f} {row[3]:11.1f} "
                        f"{row[4]:13.1f} {row[5]:12.1f}"
                    )

                if row[3] <= a.max_good_lost and (
                    best is None or row[4] > best[4]
                ):
                    best = row

        if best:
            print(
                f"recommended [{prefix}] "
                f"(good lost <= {a.max_good_lost}%): "
                f"delta {best[0]}, N >= {best[1]}: "
                f"flags {best[2]:.1f}% of frames, "
                f"removes {best[4]:.1f}% of wrong cells, "
                f"catches {best[5]:.1f}% of the frames with >=3 wrong cells"
            )

    out = Path(a.out)
    out.mkdir(parents=True, exist_ok=True)
    fr.to_csv(out / "per_frame.csv", index=False)
    print(f"wrote {out / 'per_frame.csv'}")


if __name__ == "__main__":
    main()
