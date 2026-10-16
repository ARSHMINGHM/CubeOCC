#!/usr/bin/env python3
"""Audit CubeOCC production SVM data isolation and feature reduction.

The audit intentionally reuses export_linear_rule.build so its samples, START
white map, alignment, circular mask, and labels match the exported RTL model.
All learned transforms are fitted inside each leave-one-capture-set-out fold.
"""
import argparse
import collections
import hashlib
import json
import sys
from pathlib import Path

import numpy as np

sys.path.insert(0, str(Path(__file__).resolve().parent))
import export_linear_rule as elr


def image_duplicate_summary(image_dir, keys):
    groups = collections.defaultdict(list)
    for key in sorted(set(keys)):
        path = image_dir / key
        if path.exists():
            groups[hashlib.sha256(path.read_bytes()).hexdigest()].append(key)
    duplicates = [v for v in groups.values() if len(v) > 1]
    cross_set = [v for v in duplicates if len({Path(k).parts[0] for k in v}) > 1]
    return {
        "unique_image_hashes": len(groups),
        "duplicate_hash_groups": len(duplicates),
        "cross_capture_set_duplicate_groups": len(cross_set),
        "cross_capture_set_duplicate_examples": cross_set[:10],
    }


def grouped_predictions(df, mode):
    from sklearn.decomposition import PCA
    from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
    from sklearn.pipeline import make_pipeline
    from sklearn.preprocessing import StandardScaler
    from sklearn.svm import LinearSVC

    X = np.c_[df["mean"] / df["white"], df["nb"] / df["white"]]
    y = df["y"].to_numpy(dtype=int)
    pred = np.zeros(len(df), dtype=int)
    for held in sorted(df["set"].unique()):
        train = (df["set"] != held).to_numpy()
        test = ~train
        if mode == "mean_svm":
            model = make_pipeline(StandardScaler(), LinearSVC(C=1.0, max_iter=20000))
            train_x, test_x = X[train, :1], X[test, :1]
        elif mode == "svm":
            model = make_pipeline(StandardScaler(), LinearSVC(C=1.0, max_iter=20000))
            train_x, test_x = X[train], X[test]
        elif mode == "pca1_svm":
            model = make_pipeline(StandardScaler(), PCA(n_components=1),
                                  LinearSVC(C=1.0, max_iter=20000))
            train_x, test_x = X[train], X[test]
        elif mode == "lda":
            model = make_pipeline(StandardScaler(), LinearDiscriminantAnalysis())
            train_x, test_x = X[train], X[test]
        else:
            raise ValueError(mode)
        model.fit(train_x, y[train])
        pred[test] = model.predict(test_x)
    return pred, y


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--frames", required=True)
    ap.add_argument("--grades")
    ap.add_argument("--image-dir", required=True)
    ap.add_argument("--golden-jsonl")
    ap.add_argument("--out", default="svm_pipeline_audit")
    args = ap.parse_args()

    build_args = argparse.Namespace(
        frames=args.frames,
        grades=args.grades,
        image_dir=args.image_dir,
        golden_jsonl=args.golden_jsonl,
        white_ref="start",
    )
    df = elr.build(build_args).reset_index(drop=True)
    df["m_w"] = df["mean"] / df["white"]
    df["nb_w"] = df["nb"] / df["white"]

    results = json.loads(Path(args.frames).read_text(encoding="utf-8"))
    frame_rows = results["frames"] if isinstance(results["frames"], list) else list(results["frames"].values())
    kind_by_key = {
        (r.get("relative_path") or r.get("key", "")).replace("\\", "/"): r.get("symbols_kind")
        for r in frame_rows
    }
    payload_frames = df[["set", "key", "gidx"]].drop_duplicates()
    payload_frames["kind"] = payload_frames["key"].map(kind_by_key)

    grade_by_key = {}
    if args.grades:
        grade_doc = json.loads(Path(args.grades).read_text(encoding="utf-8"))
        grade_by_key = {
            k.replace("\\", "/"): v.get("grade")
            for k, v in grade_doc.get("frames", {}).items()
        }
    payload_frames["grade"] = payload_frames["key"].map(grade_by_key)

    corr = df[["m_w", "nb_w"]].corr(method="pearson")
    corr_by_class = {
        str(label): float(group[["m_w", "nb_w"]].corr().iloc[0, 1])
        for label, group in df.groupby("y")
    }
    feature_label_correlation = {
        name: float(np.corrcoef(df[name].to_numpy(), df["y"].to_numpy())[0, 1])
        for name in ("m_w", "nb_w")
    }

    from sklearn.decomposition import PCA
    from sklearn.preprocessing import StandardScaler
    X = df[["m_w", "nb_w"]].to_numpy()
    pca = PCA().fit(StandardScaler().fit_transform(X))

    errors = {}
    for mode in ("mean_svm", "svm", "pca1_svm", "lda"):
        pred, y = grouped_predictions(df, mode)
        errors[mode] = {
            "errors": int(np.sum(pred != y)),
            "cells": int(len(y)),
            "error_percent": float(100.0 * np.mean(pred != y)),
        }

    duplicate_info = image_duplicate_summary(Path(args.image_dir), payload_frames["key"])
    kind_names = {0: "ignored", 1: "start", 2: "data", 3: "end", 4: "discarded", 5: "ambiguous"}
    kind_counts = {
        kind_names.get(int(k), str(k)): int(v)
        for k, v in payload_frames["kind"].dropna().value_counts().sort_index().items()
    }
    grade_counts = {
        str(k): int(v) for k, v in payload_frames["grade"].fillna("ungraded").value_counts().items()
    }

    summary = {
        "golden_source": "sender_jsonl" if args.golden_jsonl else "majority_vote_from_all_graded_capture_sets",
        "split": "leave_one_capture_set_out",
        "capture_sets": int(df["set"].nunique()),
        "payload_frames_used": int(len(payload_frames)),
        "payload_cells_used": int(len(df)),
        "unique_payload_patterns": int(df[["gidx"]].drop_duplicates().shape[0]),
        "features": ["cell_mean / same-cell START mean", "orthogonal_neighbor_mean / same-cell START mean"],
        "feature_correlation": {
            "pearson_overall": float(corr.iloc[0, 1]),
            "pearson_by_class": corr_by_class,
            "pearson_with_label": feature_label_correlation,
        },
        "pca_standardized": {
            "explained_variance_ratio": [float(x) for x in pca.explained_variance_ratio_],
            "components": [[float(x) for x in row] for row in pca.components_],
        },
        "grouped_cv": errors,
        "payload_frame_kind_counts": kind_counts,
        "payload_frame_manual_grade_counts": grade_counts,
        "bad_frames_were_dropped": False,
        "duplicates": duplicate_info,
        "leakage_findings": [
            "Capture sets are isolated between train and test folds.",
            "Scaler, PCA, and LDA are fitted only on each training fold.",
            "Without --golden-jsonl, test capture sets contribute to majority-vote labels.",
            "Golden-aware dynamic alignment is run on each held-out set before scoring.",
            "The same 11 payload patterns repeat in every capture set; novel messages are not tested.",
            "Discarded and ambiguous payload frames are retained by the current model builder.",
        ],
    }

    out = Path(args.out)
    out.mkdir(parents=True, exist_ok=True)
    (out / "summary.json").write_text(json.dumps(summary, indent=2), encoding="utf-8")
    corr.to_csv(out / "production_feature_correlation.csv")
    payload_frames.to_csv(out / "payload_frames_used.csv", index=False)

    print(json.dumps(summary, indent=2))
    print(f"wrote {out / 'summary.json'}")


if __name__ == "__main__":
    main()
