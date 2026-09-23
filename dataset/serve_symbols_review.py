#!/usr/bin/env python3
"""Serve the CubeOCC symbol classification review page."""

import argparse
import webbrowser
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--port", type=int, default=8768)
    args = parser.parse_args()
    url = f"http://127.0.0.1:{args.port}/dataset/symbols_review.html"
    handler = lambda *items, **kwargs: SimpleHTTPRequestHandler(*items, directory=str(ROOT), **kwargs)
    with ThreadingHTTPServer(("127.0.0.1", args.port), handler) as server:
        print(f"CubeOCC symbol classification review: {url}")
        print("Keep this terminal open. Press Ctrl+C when finished.")
        webbrowser.open(url)
        server.serve_forever()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())