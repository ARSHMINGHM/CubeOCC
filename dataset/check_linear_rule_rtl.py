#!/usr/bin/env python3
"""Bit-exact model of rtl/linear_rule_sampler.sv, to check an XSim run against.

Reads a run folder made by run_cubeocc_top_image_sim.py (results.json,
camera_gray/*.png, xsim_build/symbols_results.csv), recomputes every frame's
64-bit word with the same integer arithmetic as the RTL and compares:

  kind 2 (DATA), 4 (discarded DATA), 0 (ignored):  expected = rule word, corners = 1
  kind 1 (START): expected all ones;  kind 3 (END): expected 0x0100000000000081

Usage:
  python check_linear_rule_rtl.py --sim-dir sim/cubeocc_top_all_linear [--rule linear_rule/rule.json]
"""
import argparse, csv, json, sys
from pathlib import Path
import numpy as np
from PIL import Image

CH, CW = 15, 20
YY, XX = np.mgrid[0:CH, 0:CW]
MASK = ((XX - 10) ** 2 + (YY - 7) ** 2) <= 25
CORNERS = (0, 7, 56, 63)
START_WORD = (1 << 64) - 1
END_WORD = 0x0100_0000_0000_0081
DEFAULT = dict(Wc=2047, Wn2=-272, Wn3=-181, Wn4=-136, Ww=-1126)   # start-map rule (62 sets)

def cell_sums(img):
    S = np.zeros(64, dtype=np.int64)
    for c in range(64):
        r, cc = divmod(c, 8)
        S[c] = int(img[r * CH:(r + 1) * CH, cc * CW:(cc + 1) * CW].astype(np.int64)[MASK].sum())
    return S

def rule_word(S, k, white_map=None):
    """white_map: per-cell white sums (START frame) -> start-map rule; None -> old mean-of-4-corners rule."""
    corner_term = k["Ww"] * int(S[list(CORNERS)].sum())
    word = 0
    for c in range(64):
        r, cc = divmod(c, 8)
        nbrs = []
        if r > 0: nbrs.append(c - 8)
        if r < 7: nbrs.append(c + 8)
        if cc > 0: nbrs.append(c - 1)
        if cc < 7: nbrs.append(c + 1)
        wn = {2: k["Wn2"], 3: k["Wn3"], 4: k["Wn4"]}[len(nbrs)]
        white_term = k["Ww"] * int(white_map[c]) if white_map is not None else corner_term
        score = k["Wc"] * int(S[c]) + wn * int(sum(S[n] for n in nbrs)) + white_term
        if c in CORNERS or score > 0:
            word |= 1 << c
    return word

def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--sim-dir", required=True)
    ap.add_argument("--rule", help="linear_rule/rule.json from export_linear_rule.py (default: built-in constants)")
    a = ap.parse_args()
    sim = Path(a.sim_dir)
    k = DEFAULT
    mode = "start"
    if a.rule:
        rj = json.loads(Path(a.rule).read_text())
        k = rj["int_constants"]
        mode = "start" if rj.get("white_ref") == "start" else "mean4"
    print(f"rule mode: {mode}  constants: {k}")
    res = json.loads((sim / "results.json").read_text())["frames"]
    path = {f["frame"]: f["camera_gray_path"] for f in res}
    set_of = {f["frame"]: f["capture_set"] for f in res}
    rows = list(csv.DictReader((sim / "xsim_build" / "symbols_results.csv").open()))
    if "symbols_kind" not in rows[0]:
        sys.exit("symbols_results.csv has no symbols_kind column: use the updated cubeocc_top_image_tb.sv")
    bad = {}; total = {}; shown = 0; seq = {}
    cur_set = None; start_map = None
    for r in rows:
        f = int(r["frame"]); kind = int(r["symbols_kind"])
        got = int(r["symbols_data_binary"], 2)
        if set_of[f] != cur_set:                 # the testbench resets the DUT between capture sets
            cur_set = set_of[f]; start_map = None
        img = np.array(Image.open(sim / path[f]).convert("L"))
        S = cell_sums(img)
        if kind == 1: exp = START_WORD
        elif kind == 3: exp = END_WORD
        else:
            if mode == "start":
                # RTL: START map once a START was accepted, else flat mean of the 4 corner sums (floor)
                wm = start_map if start_map is not None else np.full(64, int(S[list(CORNERS)].sum()) >> 2)
                exp = rule_word(S, k, wm)
            else:
                exp = rule_word(S, k)
        if kind == 1:
            start_map = S.copy()                 # an accepted START becomes the per-cell white map
        total[kind] = total.get(kind, 0) + 1
        seq.setdefault(set_of[f], []).append(kind)
        if got != exp:
            bad[kind] = bad.get(kind, 0) + 1
            if shown < 8:
                shown += 1
                diff = bin(got ^ exp).count("1")
                print(f"MISMATCH frame {f} kind {kind}: {diff} bits differ ({path[f]})")
    names = {0: "ignored", 1: "START", 2: "DATA", 3: "END", 4: "discarded DATA"}
    print("\nkind counts / mismatches:")
    for kind in sorted(total):
        print(f"  {kind} {names.get(kind, '?'):15s} frames {total[kind]:4d}   mismatches {bad.get(kind, 0)}")
    letter = {0: "i", 1: "S", 2: "D", 3: "E", 4: "x"}
    odd = {s: "".join(letter[k] for k in v) for s, v in seq.items()
           if v != [1] + [2] * (len(v) - 2) + [3]}
    print(f"\nsets whose frame kinds are not S, DATA x{len(next(iter(seq.values()))) - 2}, E (S START, D DATA, E END, "
          f"x discarded DATA, i ignored): {len(odd)} of {len(seq)}")
    for s, q in sorted(odd.items()):
        print(f"  {s:38s} {q}")
    print("PASS: RTL matches the integer model" if not bad else "FAIL: see mismatches above")
    return 1 if bad else 0

if __name__ == "__main__":
    sys.exit(main())