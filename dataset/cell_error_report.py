#!/usr/bin/env python3
"""Automatic cell-level error baseline for the CubeOCC grayscale sampler.

No manual per-cell labeling needed. For every capture set the 64-bit symbol
words from the sampler are aligned (monotonic DP, tolerant of duplicated or
skipped optical frames) to a golden 13-frame message, then compared cell by
cell.

Golden message, in order of preference:
  1. --golden-jsonl  : the sender's *_frames.jsonl (exact truth)
  2. fallback        : per-frame-index majority vote of frames you graded
                       "true" in symbols_review.json (approximate truth)

Input frames: symbols_review.json (has grades) or results.json.
Cell index = row*8+col, bit string is MSB..LSB (bit[i] at char 63-i), the
same convention as run_cubeocc_top_image_sim.py.

Usage:
  python cell_error_report.py --frames symbols_review.json [--golden-jsonl X.jsonl] [--out cell_errors]
"""
import argparse, collections, csv, json, re, sys
from pathlib import Path

N = 64

def ham(a, b):
    return sum(x != y for x, y in zip(a, b))

def align_cost(captured, golden, down_weight=3):
    """Alignment cost. Bloom/glare turns black cells white (golden 0 -> read 1),
    which can make a corrupted frame look closer to the wrong golden frame under
    plain Hamming distance. White cells read as black (golden 1 -> read 0) are
    rare, so they weigh more: the true golden frame is the one that explains
    every white cell."""
    up = sum(1 for g, c in zip(golden, captured) if g == "0" and c == "1")
    down = sum(1 for g, c in zip(golden, captured) if g == "1" and c == "0")
    return up + down_weight * down

def load_frames(path, grades_path=None):
    d = json.loads(Path(path).read_text(encoding="utf-8"))
    grades = {}
    if grades_path:
        g = json.loads(Path(grades_path).read_text(encoding="utf-8"))["frames"]
        grades = {k.replace("\\", "/"): v.get("grade") for k, v in g.items()}
    frames = d["frames"]
    rows = []
    if isinstance(frames, dict):               # symbols_review.json
        for key, v in frames.items():
            rows.append({"key": key, "set": v["capture_set"], "bits": v["symbols_bits"], "grade": v.get("grade")})
    else:                                       # results.json
        for v in frames:
            rows.append({"key": v["relative_path"], "set": v["capture_set"], "bits": v["symbols_bits"],
                         "grade": grades.get(v["relative_path"].replace("\\", "/"))})
    by = collections.OrderedDict()
    for r in rows:
        by.setdefault(r["set"], []).append(r)
    # Natural frame order: "frame_9.png" must come before "frame_10.png". Plain
    # string sorting (as in the sim runner) puts it after frame_12.png.
    def frame_no(r):
        m = re.findall(r"\d+", r["key"].replace("\\", "/").split("/")[-1])
        return (int(m[0]) if m else 10**9, r["key"])
    for s, l in by.items():
        l.sort(key=frame_no)
        nums = [frame_no(r)[0] for r in l]
        dup = sorted({n for n in nums if nums.count(n) > 1})
        if dup or nums != list(range(len(l))):
            print(f"WARNING {s}: frame numbers {nums} (duplicates: {dup or 'none'})", file=sys.stderr)
    return by

def to_cellstr(cells):
    # sender 'cells' string is row-major cell 0..63; sampler string is MSB..LSB -> reverse
    return cells[::-1]

def golden_from_jsonl(path):
    recs = [json.loads(l) for l in Path(path).read_text(encoding="ascii").splitlines() if l.strip()]
    recs.sort(key=lambda r: r["index"])
    out = []
    for r in recs:
        c = r["cells"]
        if len(c) != N or set(c) - set("01"):
            raise SystemExit("jsonl is not an 8x8 grayscale mapping (cells must be 64 chars of 0/1)")
        out.append(to_cellstr(c))
    return out

def golden_from_votes(by, length=13, min_votes=3):
    gold = []
    for i in range(length):
        c = collections.Counter(l[i]["bits"] for l in by.values() if len(l) > i and l[i]["grade"] == "true")
        if not c or c.most_common(1)[0][1] < min_votes:
            raise SystemExit(f"not enough 'true' frames to vote golden frame {i}")
        gold.append(c.most_common(1)[0][0])
    return gold

def align(frames, gold, step_penalty=14):
    """Monotonic DP: captured frame i -> golden index j(i), j non-decreasing,
    step 0 (repeat), 1 (normal) or 2 (skip). Non-unit steps cost step_penalty."""
    n, m = len(frames), len(gold)
    INF = 10**9
    cost = [[align_cost(f["bits"], g) for g in gold] for f in frames]
    dp = [[INF] * m for _ in range(n)]
    back = [[-1] * m for _ in range(n)]
    # START is a single optical frame at the beginning of the transfer: the first
    # captured frame is START, and no later captured frame may be matched to it
    # (a bloomed DATA frame saturates to all-white and would otherwise "match" START).
    dp[0][0] = cost[0][0]
    for i in range(1, n):
        for j in range(1, m):
            for step in (0, 1, 2):
                pj = j - step
                if pj < 0 or dp[i - 1][pj] >= INF:
                    continue
                v = dp[i - 1][pj] + cost[i][j] + (0 if step == 1 else step_penalty)
                if v < dp[i][j]:
                    dp[i][j] = v; back[i][j] = pj
    j = min(range(m), key=lambda x: dp[n - 1][x])
    path = [0] * n
    for i in range(n - 1, -1, -1):
        path[i] = j
        j = back[i][j] if i else j
    return path

def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--frames", required=True)
    ap.add_argument("--grades", help="symbols_review.json with your true/mid/false labels; use it when --frames is a fresh results.json (no grades)")
    ap.add_argument("--golden-jsonl")
    ap.add_argument("--out", default="cell_errors")
    ap.add_argument("--step-penalty", type=int, default=14)
    a = ap.parse_args()

    by = load_frames(a.frames, a.grades)
    gold = golden_from_jsonl(a.golden_jsonl) if a.golden_jsonl else golden_from_votes(by)
    src = "sender jsonl" if a.golden_jsonl else "majority of 'true' frames (approximate)"
    print(f"golden: {len(gold)} frames from {src}")

    out = Path(a.out); out.mkdir(parents=True, exist_ok=True)
    cell_err = [0] * N; cell_n = [0] * N
    tot = collections.Counter(); per_set = {}
    with (out / "per_frame.csv").open("w", newline="", encoding="utf-8") as fh:
        w = csv.writer(fh)
        w.writerow(["set", "frame", "key", "grade", "golden_index", "aligned_shift", "cell_errors", "black_as_white", "white_as_black", "wrong_cells"])
        for s, frames in by.items():
            path = align(frames, gold, a.step_penalty)
            e_set = 0; shifted = 0; raw_set = 0
            for i, (f, j) in enumerate(zip(frames, path)):
                g = gold[j]; b = f["bits"]
                up = dn = 0; wrong = []
                for c in range(N):
                    gb, bb = g[63 - c], b[63 - c]
                    cell_n[c] += 1
                    if gb != bb:
                        cell_err[c] += 1; wrong.append(c)
                        if gb == "0": up += 1
                        else: dn += 1
                e = up + dn; e_set += e; tot["up"] += up; tot["down"] += dn
                raw_set += ham(gold[min(i, len(gold) - 1)], b)
                tot["cells"] += N; tot["frames"] += 1
                tot["frames_bad"] += e > 0
                sh = j - min(i, len(gold) - 1)
                shifted += sh != 0
                w.writerow([s, i, f["key"], f["grade"], j, sh, e, up, dn, " ".join(map(str, wrong))])
            per_set[s] = {"frames": len(frames), "cell_error_rate": e_set / (len(frames) * N),
                          "index_based_error_rate": raw_set / (len(frames) * N), "shifted_frames": shifted}
            tot["shifted"] += shifted

    errs = tot["up"] + tot["down"]
    print(f"frames {tot['frames']}  cells {tot['cells']}  cell errors {errs}  rate {100*errs/tot['cells']:.2f}%")
    print(f"black read as white: {tot['up']}   white read as black: {tot['down']}   frames with >=1 wrong cell: {tot['frames_bad']}")
    print(f"frames aligned to a different golden index than their position: {tot['shifted']}")
    ranked = sorted(per_set.items(), key=lambda kv: -kv[1]["cell_error_rate"])
    tot_err_sets = sum(v["cell_error_rate"] * v["frames"] * N for v in per_set.values())
    top10 = sum(v["cell_error_rate"] * v["frames"] * N for _, v in ranked[:10])
    print(f"sets with zero errors: {sum(1 for v in per_set.values() if v['cell_error_rate']==0)}/{len(per_set)};"
          f" worst 10 sets hold {100*top10/max(tot_err_sets,1):.0f}% of errors")
    print("worst sets:")
    for s, v in ranked[:12]:
        print(f"  {s:38s} cell error {100*v['cell_error_rate']:5.1f}%  (by index only {100*v['index_based_error_rate']:5.1f}%)  shifted frames {v['shifted_frames']}")
    print("per-cell error rate by grid position (%, rows top->bottom):")
    for r in range(8):
        print("  " + " ".join(f"{100*cell_err[r*8+c]/max(cell_n[r*8+c],1):5.1f}" for c in range(8)))
    (out / "summary.json").write_text(json.dumps({
        "golden_source": src, "totals": dict(tot),
        "cell_error_rate_overall": errs / tot["cells"],
        "per_set": per_set,
        "per_cell_error_rate": [cell_err[c] / max(cell_n[c], 1) for c in range(N)],
    }, indent=2), encoding="utf-8")
    print(f"wrote {out/'per_frame.csv'} and {out/'summary.json'}")

if __name__ == "__main__":
    sys.exit(main())