#!/usr/bin/env python3
"""Evaluate the recall, precision, and false-positive rate of the RTL's
'ambiguous' (kind=5) and 'discarded' (kind=4) flags.

Joins the per-frame golden errors (from cell_error_report.py) with the RTL
output (from symbols_results.csv) to measure how effectively bad frames
(>= 3 wrong cells) are flagged and how many good DATA frames (<= 1 wrong
cell) are lost in the process.

Usage:
  python evaluate_ambiguous_flag.py [--errors cell_errors_ambig/per_frame.csv] \
      [--sim-dir sim/cubeocc_top_all_ambig] [--exclude MLCAP_048]
"""
import argparse, json, sys, warnings
from pathlib import Path
import pandas as pd

warnings.filterwarnings("ignore")

def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--errors", default="cell_errors_ambig/per_frame.csv")
    ap.add_argument("--sim-dir", default="sim/cubeocc_top_all_ambig")
    ap.add_argument("--exclude", default="MLCAP_048", help="set-name prefix left out of the statistics (content mismatch)")
    a = ap.parse_args()

    sim_dir = Path(a.sim_dir)
    sim_csv = sim_dir / "xsim_build" / "symbols_results.csv"
    results_json = sim_dir / "results.json"

    if not Path(a.errors).exists() or not sim_csv.exists() or not results_json.exists():
        sys.exit("Error: Required files not found. Run cell_error_report.py first.")

    # 1. Map global frame index -> relative path (key) from results.json
    res = json.loads(results_json.read_text())["frames"]
    frames = res if isinstance(res, list) else res.values()
    idx_to_key = {
        int(f["frame"]): f.get("relative_path", f.get("camera_gray_path", "")).replace("\\", "/")
        for f in frames
    }

    # 2. Load RTL frame kinds
    rtl = pd.read_csv(sim_csv)
    rtl["key"] = rtl["frame"].map(idx_to_key).str.replace("\\", "/")
    rtl = rtl[["key", "symbols_kind"]].dropna()

    # 3. Load Golden errors
    df = pd.read_csv(a.errors)
    df["key"] = df["key"].str.replace("\\", "/")
    
    # Exclude mismatched sets
    if a.exclude:
        df = df[~df["set"].str.startswith(a.exclude)]

    # Join DataFrames
    df = df.merge(rtl, on="key", how="inner")
    
    # Definitions
    df["is_bad"] = df["cell_errors"] >= 3
    df["is_good"] = df["cell_errors"] <= 1
    
    # For FPR, we only consider GOOD DATA frames (kind 2 or 5, excluding START/END/Discarded)
    good_data = df[df["is_good"] & df["symbols_kind"].isin([2, 5])]
    bad_frames = df[df["is_bad"]]

    # Metrics for Ambiguous (kind=5)
    tp_ambig = len(bad_frames[bad_frames["symbols_kind"] == 5])
    fp_ambig = len(good_data[good_data["symbols_kind"] == 5])
    
    # Metrics for Discarded (kind=4)
    tp_disc = len(bad_frames[bad_frames["symbols_kind"] == 4])
    fp_disc = len(good_data[good_data["symbols_kind"] == 4])

    print("\n==========================================================")
    print(f" Evaluation of Flags (Set {a.exclude} excluded)")
    print("==========================================================")
    print(f"Total frames evaluated: {len(df)}")
    print(f"Bad frames (>=3 errors): {len(bad_frames)}")
    print(f"Good DATA frames (<=1 error, kind 2/5): {len(good_data)}")
    
    print("\n--- Ambiguous Flag (kind=5) ---")
    if len(bad_frames) > 0:
        recall = 100 * tp_ambig / len(bad_frames)
        print(f"Recall (Bad frames caught): {tp_ambig} / {len(bad_frames)} = {recall:.1f}%")
    if (tp_ambig + fp_ambig) > 0:
        precision = 100 * tp_ambig / (tp_ambig + fp_ambig)
        print(f"Precision (Flagged frames that are bad): {tp_ambig} / {tp_ambig + fp_ambig} = {precision:.1f}%")
    if len(good_data) > 0:
        fpr = 100 * fp_ambig / len(good_data)
        print(f"False Positive Rate (Good DATA frames lost): {fp_ambig} / {len(good_data)} = {fpr:.1f}%")

    print("\n--- Discarded Flag (kind=4, by Guard) ---")
    if len(bad_frames) > 0:
        recall_disc = 100 * tp_disc / len(bad_frames)
        print(f"Recall (Bad frames caught): {tp_disc} / {len(bad_frames)} = {recall_disc:.1f}%")
    if len(good_data) > 0:
        fpr_disc = 100 * fp_disc / len(good_data)
        print(f"False Positive Rate (Good DATA frames lost): {fp_disc} / {len(good_data)} = {fpr_disc:.1f}%")

    print("\n--- Combined System Performance ---")
    total_caught = tp_ambig + tp_disc
    total_fp = fp_ambig + fp_disc
    if len(bad_frames) > 0:
        print(f"Total Bad Frames Removed: {total_caught} / {len(bad_frames)} ({100*total_caught/len(bad_frames):.1f}%)")
    if len(good_data) > 0:
        print(f"Total Good DATA Frames Lost: {total_fp} / {len(good_data)} ({100*total_fp/len(good_data):.1f}%)")

if __name__ == "__main__":
    sys.exit(main())