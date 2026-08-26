#!/usr/bin/env python3
"""Convert an image to a hex memory file for the simulation camera model.

Produces one 8-bit grayscale hex value per line (row-major), loadable via
$readmemh in dvp_camera_model (IMAGE_FILE / IMAGE_WIDTH / IMAGE_HEIGHT
parameters).

Usage:
    python image_to_mem.py input.jpg output.mem [width height]

If width/height are given the image is resized; otherwise the original
size is kept and printed (pass those numbers as IMAGE_WIDTH/IMAGE_HEIGHT).
"""

import sys
from pathlib import Path

try:
    from PIL import Image
except ImportError:
    sys.exit("Pillow is required: pip install Pillow")


def main():
    if len(sys.argv) < 3:
        sys.exit(__doc__)

    src = Path(sys.argv[1])
    dst = Path(sys.argv[2])

    img = Image.open(src)
    if len(sys.argv) >= 5:
        img = img.resize((int(sys.argv[3]), int(sys.argv[4])))
    width, height = img.size

    gray = img.convert("L")
    with dst.open("w") as f:
        for b in gray.tobytes():
            f.write(f"{b:02x}\n")

    print(f"Wrote {dst} ({width}x{height}, {width * height} pixels)")
    print(f"Use IMAGE_WIDTH={width}, IMAGE_HEIGHT={height} in the camera model.")


if __name__ == "__main__":
    main()
