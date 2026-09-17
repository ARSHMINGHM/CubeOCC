#!/usr/bin/env python3
"""Serve the Python-versus-FPGA ROI comparison review UI."""

from __future__ import annotations

import argparse
import webbrowser
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parents[1]


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--port", type=int, default=8766)
    args = parser.parse_args()
    url = f"http://127.0.0.1:{args.port}/dataset/roi_comparison_review.html"
    handler = lambda *items, **kwargs: SimpleHTTPRequestHandler(*items, directory=str(PROJECT_ROOT), **kwargs)
    with ThreadingHTTPServer(("127.0.0.1", args.port), handler) as server:
        print(f"CubeOCC Python/FPGA ROI comparison review: {url}")
        print("Keep this terminal open. Press Ctrl+C here when finished.")
        webbrowser.open(url)
        server.serve_forever()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
