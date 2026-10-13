#!/usr/bin/env bash
# CubeOCC sim cleanup — run from repo root.
# Safe: only touches regenerable XSim runs.

set -e

show() {
  echo ""
  echo "=== $1 ==="
  du -sh sim 2>/dev/null || echo "sim not found"
  find sim -type f 2>/dev/null | wc -l | xargs echo "total files:"
}

show "BEFORE"

echo ""
echo ">>> Deleting XSim runs (regenerable)..."
rm -rf sim/cubeocc_top_all_ambig/
rm -rf sim/cubeocc_top_all_linear/
rm -rf sim/cubeocc_top_all_start/
rm -rf sim/roi_rtl_all/
rm -rf sim/roi_rtl_all_grayscale/
rm -rf sim/rgb_warped/
rm -rf sim/postip/

echo ">>> Stripping large image dumps from kept runs..."
# cubeocc_top_all: keep symbols_review/, drop everything else
find sim/cubeocc_top_all -mindepth 1 -maxdepth 1 \
  ! -name symbols_review -exec rm -rf {} +
# _start_v2: keep results.json, drop the rest
find sim/cubeocc_top_all_start_v2 -mindepth 1 -maxdepth 1 \
  ! -name results.json -exec rm -rf {} +

echo ">>> Deleting SVM / ambiguity / cell-error regenerables (outside sim/)..."
rm -rf svm_cv_*/ cell_errors*/ ambiguity/ ambiguity_cv/

show "AFTER"

echo ""
echo "Kept on purpose:"
echo "  sim/cubeocc_top_all/symbols_review/             (labels)"
echo "  sim/cubeocc_top_all_guard/camera_gray/          (SVM input)"
echo "  sim/cubeocc_top_all_start_v2/results.json       (latest output)"
echo "  sim/sender_bitstreams*/ sim/sender_frames*/     (sender tools)"
echo "  sim/warp_stress_*/ sim/warp_smoke_*/            (small datasets)"
