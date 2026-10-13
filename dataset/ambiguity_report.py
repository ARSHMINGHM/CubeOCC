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

import argparse
import csv
import sys
from pathlib import Path

import numpy as np

sys.path.insert(0, str(Path(__file__).resolve().parent))
import export_linear_rule as ex


DEFAULT_COEF = (
    5.752914414109695,
    -1.5290268788175847,
    -3.1647125466755264,
)


def main():
    ap = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )

    ap.add_argument("--frames", required=True)
    ap.add_argument("--grades")
    ap.add_argument("--image-dir", required=True)
    ap.add_argument("--golden-jsonl")

    ap.add_argument(
        "--coef",
        nargs=3,
        type=float,
        default=list(DEFAULT_COEF),
    )

    ap.add_argument(
        "--max-good-lost",
        type=float,
        default=5.0,
    )

    ap.add_argument(
        "--exclude",
        default="MLCAP_048",
        help="set-name prefix left out of the statistics (content mismatch)",
    )

    ap.add_argument(
        "--out",
        default="ambiguity",
    )

    ap.add_argument(
        "--cv-splits",
        type=int,
        default=0,
        help=(
            "if > 0: repeat N random half/half splits of the capture sets, "
            "choose (delta, N) on one half and measure it on the other "
            "(tests how optimistic the in-sample choice is)"
        ),
    )

    ap.add_argument(
        "--seed",
        type=int,
        default=0,
    )

    a = ap.parse_args()

    a.white_ref = "start"

    df = ex.build(a)

    df = (
        df[~df.set.str.startswith(a.exclude)]
        if a.exclude
        else df
    )

    A, B, G = a.coef

    # score = A*mean + B*nb + G*white
    # margin in units of white:
    # d = score / (A * white)
    df["d"] = (
        A * df["mean"]
        + B * df.nb
        + G * df.white
    ) / (A * df.white)

    df["pred"] = (df.d > 0).astype(int)
    df["wrong"] = (df.pred != df.y).astype(int)

    deltas = [0.05, 0.069, 0.10, 0.15, 0.20, 0.25]

    # ------------------------------------------------------------------
    # Previous decoded frame
    #
    # START = all ones for the first DATA frame.
    #
    # IMPORTANT:
    # We use groupby("cell").pred.first() instead of set_index("cell")
    # because duplicate cell labels can exist inside a frame. In that
    # case, Series.get(cell) would return a Series rather than a scalar,
    # causing:
    #
    #   TypeError: int() argument ... not 'Series'
    # ------------------------------------------------------------------

    prev = np.zeros(len(df), dtype=int)

    for sname, g in df.groupby("set"):

        # For every frame, create:
        #
        #     cell -> previous prediction
        #
        # groupby("cell").first() guarantees one scalar value per cell.
        by_frame = {
            gi: gg.groupby("cell").pred.first()
            for gi, gg in g.groupby("gidx")
        }

        for idx, row in g.iterrows():

            out_idx = df.index.get_loc(idx)

            # First DATA frame:
            # previous/displayed frame is assumed to be all ones.
            if row.gidx == 1:
                prev[out_idx] = 1
                continue

            # Previous frame.
            pf = by_frame.get(row.gidx - 1)

            # If previous frame does not exist, keep the original
            # fallback behavior: previous value = 1.
            if pf is None:
                prev[out_idx] = 1
                continue

            # pf.get(...) is now guaranteed to return a scalar because
            # by_frame was constructed using groupby("cell").first().
            prev[out_idx] = int(
                pf.get(row.cell, 1)
            )

    df["changed"] = (
        df.pred.values != prev
    ).astype(int)

    # ------------------------------------------------------------------
    # Per-frame statistics
    # ------------------------------------------------------------------

    fr = (
        df.groupby(["set", "key"])
        .agg(
            wrong=("wrong", "sum"),
            cells=("wrong", "size"),
        )
        .reset_index()
    )

    # ------------------------------------------------------------------
    # Calculate U(delta) and T(delta)
    #
    # U = number of uncertain cells
    # T = number of cells that both changed and are uncertain
    # ------------------------------------------------------------------

    for dl in deltas:

        u = (
            df.assign(
                u=(df.d.abs() < dl).astype(int)
            )
            .groupby(["set", "key"])
            .u.sum()
            .reset_index(name=f"U{dl}")
        )

        fr = fr.merge(
            u,
            on=["set", "key"],
        )

        t = (
            df.assign(
                t=(
                    (df.d.abs() < dl)
                    & (df.changed == 1)
                ).astype(int)
            )
            .groupby(["set", "key"])
            .t.sum()
            .reset_index(name=f"T{dl}")
        )

        fr = fr.merge(
            t,
            on=["set", "key"],
        )

    # ------------------------------------------------------------------
    # Overall statistics
    # ------------------------------------------------------------------

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

    # ------------------------------------------------------------------
    # Evaluate U and T
    # ------------------------------------------------------------------

    for label, prefix, what in (
        (
            "uncertain cells U",
            "U",
            "all uncertain cells",
        ),
        (
            "changed AND uncertain cells T",
            "T",
            "cells that changed vs the previous frame and are uncertain",
        ),
    ):

        print(
            f"\n[{prefix}] flag = number of {what} >= N"
        )

        print(
            f"{'delta':>6s} "
            f"{'N':>3s} "
            f"{'flagged%':>9s} "
            f"{'good lost%':>11s} "
            f"{'err removed%':>13s} "
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
                    100 * (fl & bad).sum() / max(bad.sum(), 1),
                )

                if 0 < row[2] < 60:

                    print(
                        f"{row[0]:6.2f} "
                        f"{row[1]:3d} "
                        f"{row[2]:9.1f} "
                        f"{row[3]:11.1f} "
                        f"{row[4]:13.1f} "
                        f"{row[5]:12.1f}"
                    )

                if (
                    row[3] <= a.max_good_lost
                    and (
                        best is None
                        or row[4] > best[4]
                    )
                ):
                    best = row

        if best:

            print(
                f"recommended [{prefix}] "
                f"(good lost <= {a.max_good_lost}%): "
                f"delta {best[0]}, "
                f"N >= {best[1]}: "
                f"flags {best[2]:.1f}% of frames, "
                f"removes {best[4]:.1f}% of wrong cells, "
                f"catches {best[5]:.1f}% of the frames with >=3 wrong cells"
            )

    # ------------------------------------------------------------------
    # Cross-validation
    # ------------------------------------------------------------------

    if a.cv_splits > 0:

        rng = np.random.default_rng(a.seed)

        all_sets = np.array(
            sorted(fr.set.unique())
        )

        def measure(d, col, N):

            fl = d[col] >= N

            g = d.wrong <= 1
            b = d.wrong >= 3

            t = max(
                d.wrong.sum(),
                1,
            )

            return (
                100 * fl.mean(),
                100 * (fl & g).sum()
                / max(g.sum(), 1),
                100 * d.wrong[fl].sum()
                / t,
                100 * (fl & b).sum()
                / max(b.sum(), 1),
            )

        res = []
        picks = []

        for _ in range(a.cv_splits):

            perm = rng.permutation(all_sets)
            half = len(perm) // 2

            tr = fr[
                fr.set.isin(perm[:half])
            ]

            te = fr[
                fr.set.isin(perm[half:])
            ]

            best = None

            for dl in deltas:

                for N in (1, 2, 3, 4, 5, 6, 8):

                    m = measure(
                        tr,
                        f"U{dl}",
                        N,
                    )

                    if (
                        m[1] <= a.max_good_lost
                        and (
                            best is None
                            or m[2] > best[0]
                        )
                    ):
                        best = (
                            m[2],
                            dl,
                            N,
                        )

            if best is None:
                continue

            picks.append(
                (
                    best[1],
                    best[2],
                )
            )

            res.append(
                (
                    measure(
                        tr,
                        f"U{best[1]}",
                        best[2],
                    ),
                    measure(
                        te,
                        f"U{best[1]}",
                        best[2],
                    ),
                )
            )

        if res:

            tr_m = np.mean(
                [r[0] for r in res],
                axis=0,
            )

            te_m = np.mean(
                [r[1] for r in res],
                axis=0,
            )

            te_s = np.std(
                [r[1] for r in res],
                axis=0,
            )

            from collections import Counter

            print(
                f"\n[CV] {len(res)} random half/half splits "
                f"of the capture sets; "
                f"(delta, N) chosen on the train half "
                f"(good lost <= {a.max_good_lost}%), "
                f"measured on the held-out half"
            )

            print(
                f"{'':12s} "
                f"{'flagged%':>9s} "
                f"{'good lost%':>11s} "
                f"{'err removed%':>13s} "
                f"{'bad caught%':>12s}"
            )

            print(
                f"{'train half':12s} "
                + " ".join(
                    f"{v:>{w}.1f}"
                    for v, w in zip(
                        tr_m,
                        (9, 11, 13, 12),
                    )
                )
            )

            print(
                f"{'held-out':12s} "
                + " ".join(
                    f"{v:>{w}.1f}"
                    for v, w in zip(
                        te_m,
                        (9, 11, 13, 12),
                    )
                )
            )

            print(
                f"{'held-out sd':12s} "
                + " ".join(
                    f"{v:>{w}.1f}"
                    for v, w in zip(
                        te_s,
                        (9, 11, 13, 12),
                    )
                )
            )

            print(
                "most chosen (delta, N):",
                Counter(picks).most_common(4),
            )

    # ------------------------------------------------------------------
    # Save output
    # ------------------------------------------------------------------

    out = Path(a.out)
    out.mkdir(
        parents=True,
        exist_ok=True,
    )

    fr.to_csv(
        out / "per_frame.csv",
        index=False,
    )

    print(
        f"wrote {out / 'per_frame.csv'}"
    )


if __name__ == "__main__":
    main()