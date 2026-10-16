#!/usr/bin/env python3
"""Train and export the two directional degree-2 classifiers for RTL.

Both classifiers consume the same seven per-cell inputs (center, N, SE, S,
SW, W, NW).  The PCA30 transform is fused into its final linear SVM before
export, so RTL evaluates two coefficient sets over one shared polynomial term
stream.  Division by the START-frame reference is removed by multiplying the
decision equation by the positive reference squared.
"""
import argparse
import json
from pathlib import Path

import numpy as np

import cell_error_report as cer
import explore_directional_neighbors as edn
from compare_directional_pca_lda import RAW_COLUMNS
from explore_hardware_features import CORNERS, MASKS, cell_blocks


RAW_NAMES = ["center", "n", "se", "s", "sw", "w", "nw"]
PAIRS = [(i, j) for i in range(7) for j in range(i, 7)]


def expand_from_standardized(linear, quadratic, bias, mean, scale):
    """Expand a polynomial in z=(x-mean)/scale into raw x coordinates."""
    out_linear = np.zeros(7, dtype=float)
    out_quad = np.zeros((7, 7), dtype=float)
    out_bias = float(bias)

    for i, coefficient in enumerate(linear):
        out_linear[i] += coefficient / scale[i]
        out_bias -= coefficient * mean[i] / scale[i]

    for coefficient, (i, j) in zip(quadratic, PAIRS):
        denominator = scale[i] * scale[j]
        value = coefficient / denominator
        out_quad[i, j] += value
        if i == j:
            out_linear[i] -= 2.0 * value * mean[i]
            out_bias += value * mean[i] * mean[i]
        else:
            out_linear[i] -= value * mean[j]
            out_linear[j] -= value * mean[i]
            out_bias += value * mean[i] * mean[j]
    return np.concatenate([[out_bias], out_linear,
                           np.array([out_quad[i, j] for i, j in PAIRS])])


def integer_inputs(args, expected_rows):
    """Rebuild integer circle sums in exactly the same order as edn.build."""
    from PIL import Image

    by = cer.load_frames(args.frames, args.grades)
    result, white_result = [], []
    mask = MASKS["r5"]
    for capture_set, frames in by.items():
        gold = cer.golden_from_jsonl(args.golden_jsonl) if args.golden_jsonl else cer.golden_from_votes(by)
        alignment = cer.align(frames, gold)
        start_sums = None
        for frame, gidx in zip(frames, alignment):
            path = Path(args.image_dir) / frame["key"]
            if gidx == 0 and path.exists():
                blocks = cell_blocks(np.array(Image.open(path).convert("L")))
                start_sums = np.array([int(block[mask].sum()) for block in blocks], dtype=np.int64)
                break
        if start_sums is None:
            continue

        for frame, gidx in zip(frames, alignment):
            path = Path(args.image_dir) / frame["key"]
            if not path.exists() or not (1 <= gidx <= 11):
                continue
            blocks = cell_blocks(np.array(Image.open(path).convert("L")))
            sums = np.array([int(block[mask].sum()) for block in blocks], dtype=np.int64)
            for cell in range(64):
                if cell in CORNERS:
                    continue
                neighbors, _ = edn.directional_values(sums, cell)
                result.append([sums[cell]] + [neighbors[name] for name in RAW_NAMES[1:]])
                white_result.append(start_sums[cell])

    values = np.asarray(result, dtype=np.int64)
    white = np.asarray(white_result, dtype=np.int64)
    if len(values) != expected_rows:
        raise RuntimeError(f"integer feature rows {len(values)} != dataframe rows {expected_rows}")
    return values, white


def quantize(coefficients, bits):
    peak = float(np.max(np.abs(coefficients)))
    limit = (1 << (bits - 1)) - 1
    scale = limit / peak
    return np.rint(coefficients * scale).astype(np.int64), scale


def integer_score(coefficients, raw, white, value_shift):
    values = raw >> value_shift
    reference = white >> value_shift
    score = coefficients[0] * reference * reference
    score = score + np.sum(coefficients[1:8] * values * reference[:, None], axis=1)
    for coefficient, (i, j) in zip(coefficients[8:], PAIRS):
        score = score + coefficient * values[:, i] * values[:, j]
    return score


def emit_sv_function(name, coefficients, width):
    lines = [f"function automatic signed [{width-1}:0] {name}(input logic [5:0] index);",
             "    begin", "        case (index)"]
    for index, value in enumerate(coefficients):
        literal = (f"-{width}'sd{abs(int(value))}" if value < 0
                   else f"{width}'sd{int(value)}")
        lines.append(f"            6'd{index}: {name} = {literal};")
    lines.extend([f"            default: {name} = {width}'sd0;", "        endcase", "    end", "endfunction"])
    return "\n".join(lines)


def write_tb_vectors(args, output_path, fixed_models):
    """Write START/DATA/END vectors made from the latest warped grid images."""
    from PIL import Image

    by = cer.load_frames(args.frames, args.grades)
    gold = cer.golden_from_jsonl(args.golden_jsonl) if args.golden_jsonl else cer.golden_from_votes(by)
    mask = MASKS["r5"]
    lines = ["# R resets one capture set; F kind old_word pca_word then 64 sums"]
    frame_count = 0
    for capture_set, frames in by.items():
        alignment = cer.align(frames, gold)
        loaded = []
        for frame, gidx in zip(frames, alignment):
            path = Path(args.image_dir) / frame["key"]
            if not path.exists() or not (0 <= gidx <= 12):
                continue
            blocks = cell_blocks(np.array(Image.open(path).convert("L")))
            sums = np.array([int(block[mask].sum()) for block in blocks], dtype=np.int64)
            loaded.append((gidx, sums))
        starts = [sums for gidx, sums in loaded if gidx == 0]
        if not starts:
            continue
        start = starts[0]
        lines.append("R")
        for gidx, sums in loaded:
            if gidx == 0:
                kind, old_word, pca_word = 1, (1 << 64) - 1, (1 << 64) - 1
            elif gidx == 12:
                kind, old_word, pca_word = 3, 0x0100000000000081, 0x0100000000000081
            else:
                kind = 2
                raw = []
                for cell in range(64):
                    neighbors, _ = edn.directional_values(sums, cell)
                    raw.append([sums[cell]] + [neighbors[name] for name in RAW_NAMES[1:]])
                raw = np.asarray(raw, dtype=np.int64)
                reference = start.copy()
                old_bits = integer_score(fixed_models["old_poly"], raw, reference, args.value_shift) > 0
                pca_bits = integer_score(fixed_models["pca30_fused"], raw, reference, args.value_shift) > 0
                old_bits[list(CORNERS)] = True
                pca_bits[list(CORNERS)] = True
                old_word = sum(int(value) << cell for cell, value in enumerate(old_bits))
                pca_word = sum(int(value) << cell for cell, value in enumerate(pca_bits))
            lines.append(f"F {kind} {old_word:016x} {pca_word:016x}")
            lines.extend(str(int(value)) for value in sums)
            frame_count += 1
    output_path.write_text("\n".join(lines) + "\n", encoding="ascii")
    return frame_count


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--frames", required=True)
    ap.add_argument("--grades")
    ap.add_argument("--image-dir", required=True)
    ap.add_argument("--golden-jsonl")
    ap.add_argument("--out", default="directional_dual_rtl")
    ap.add_argument("--coefficient-bits", type=int, default=18)
    ap.add_argument("--value-shift", type=int, default=3)
    args = ap.parse_args()

    from sklearn.decomposition import PCA
    from sklearn.preprocessing import PolynomialFeatures, StandardScaler
    from sklearn.svm import LinearSVC

    out = Path(args.out)
    out.mkdir(parents=True, exist_ok=True)
    df = edn.build(args).reset_index(drop=True)
    x = df[RAW_COLUMNS].to_numpy(float)
    y = df["y"].to_numpy(np.uint8)

    raw_scaler = StandardScaler().fit(x)
    z = raw_scaler.transform(x)
    polynomial = PolynomialFeatures(degree=2, include_bias=False).fit(z)
    poly_z = polynomial.transform(z)

    old_svm = LinearSVC(C=1.0, max_iter=20000).fit(poly_z, y)
    old_z = old_svm.coef_.ravel()
    old_raw = expand_from_standardized(old_z[:7], old_z[7:],
                                       old_svm.intercept_[0],
                                       raw_scaler.mean_, raw_scaler.scale_)

    poly_scaler = StandardScaler().fit(poly_z)
    poly_scaled = poly_scaler.transform(poly_z)
    pca = PCA(n_components=30, random_state=0).fit(poly_scaled)
    pca_values = pca.transform(poly_scaled)
    pca_svm = LinearSVC(C=1.0, max_iter=20000).fit(pca_values, y)
    fused_scaled = pca.components_.T @ pca_svm.coef_.ravel()
    fused_scaled_bias = float(pca_svm.intercept_[0] - pca.mean_ @ fused_scaled)
    fused_z = fused_scaled / poly_scaler.scale_
    fused_z_bias = float(fused_scaled_bias - fused_z @ poly_scaler.mean_)
    pca_raw = expand_from_standardized(fused_z[:7], fused_z[7:], fused_z_bias,
                                       raw_scaler.mean_, raw_scaler.scale_)

    raw_integer, white_integer = integer_inputs(args, len(df))
    reconstructed = raw_integer / np.maximum(white_integer[:, None], 1)
    if not np.allclose(reconstructed, x, atol=1e-12):
        raise RuntimeError("integer sums do not reproduce the training features")

    report = {"samples": int(len(y)), "features": RAW_NAMES,
              "terms": ["bias"] + RAW_NAMES + [f"{RAW_NAMES[i]}*{RAW_NAMES[j]}" for i, j in PAIRS],
              "coefficient_bits": args.coefficient_bits, "value_shift": args.value_shift,
              "ground_truth": "sender_jsonl" if args.golden_jsonl else "all-set majority vote",
              "models": {}}
    functions = []
    fixed_models = {}
    for label, coefficients, float_score in (
        ("old_poly", old_raw, old_svm.decision_function(poly_z)),
        ("pca30_fused", pca_raw, pca_svm.decision_function(pca_values)),
    ):
        fixed, coefficient_scale = quantize(coefficients, args.coefficient_bits)
        fixed_models[label] = fixed
        fixed_score = integer_score(fixed, raw_integer, white_integer, args.value_shift)
        float_prediction = float_score > 0
        fixed_prediction = fixed_score > 0
        report["models"][label] = {
            "all_data_float_errors": int(np.sum(float_prediction != y)),
            "all_data_fixed_errors": int(np.sum(fixed_prediction != y)),
            "fixed_vs_float_mismatches": int(np.sum(fixed_prediction != float_prediction)),
            "coefficient_scale": coefficient_scale,
            "float_coefficients": coefficients.tolist(),
            "fixed_coefficients": fixed.tolist(),
            "minimum_absolute_fixed_margin": int(np.min(np.abs(fixed_score))),
        }
        functions.append(emit_sv_function(f"coefficient_{label}", fixed, args.coefficient_bits))

    (out / "dual_directional_models.json").write_text(json.dumps(report, indent=2), encoding="utf-8")
    header = "// Generated by dataset/export_directional_dual_rtl.py. Do not edit by hand.\n"
    header += f"localparam integer DUAL_COEF_W = {args.coefficient_bits};\n"
    header += f"localparam integer DUAL_VALUE_SHIFT = {args.value_shift};\n\n"
    (out / "dual_directional_coefficients.svh").write_text(
        header + "\n\n".join(functions) + "\n", encoding="ascii")
    report["rtl_test_frames"] = write_tb_vectors(
        args, out / "dual_sampler_vectors.txt", fixed_models)
    (out / "dual_directional_models.json").write_text(json.dumps(report, indent=2), encoding="utf-8")
    print(json.dumps({name: {key: value for key, value in values.items()
                            if key not in {"float_coefficients", "fixed_coefficients"}}
                      for name, values in report["models"].items()}, indent=2))


if __name__ == "__main__":
    main()
