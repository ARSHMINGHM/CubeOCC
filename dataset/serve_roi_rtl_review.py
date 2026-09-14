#!/usr/bin/env python3
"""Serve the dependency-free RTL ROI review UI on localhost."""

from __future__ import annotations

import argparse
import webbrowser
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parents[1]


def main() -> int:
    parser = argparse.ArgumentParser(description="Serve the CubeOCC XSim RTL ROI review UI.")
    parser.add_argument("--port", type=int, default=8765)
    args = parser.parse_args()
    url = f"http://127.0.0.1:{args.port}/dataset/roi_rtl_review.html"
    handler = lambda *handler_args, **handler_kwargs: SimpleHTTPRequestHandler(*handler_args, directory=str(PROJECT_ROOT), **handler_kwargs)
    with ThreadingHTTPServer(("127.0.0.1", args.port), handler) as server:
        print(f"CubeOCC RTL ROI review: {url}")
        print("Keep this terminal open while reviewing. Press Ctrl+C here when finished.")
        webbrowser.open(url)
        server.serve_forever()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
