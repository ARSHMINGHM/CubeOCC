import os
from PIL import Image, ImageFilter
from pathlib import Path

INPUT_DIR = "sim/roi_rtl_all/camera_gray"
OUTPUT_DIR = "sim/postip"
SHARPENED_DIR = os.path.join(OUTPUT_DIR, "cleaned")
HTML_PATH = os.path.join(OUTPUT_DIR, "index.html")

# We focus on the worst sets (Bloom/Defocus/Glare) to see if sharpening helps
WORST_SETS = ["MLCAP_020", "MLCAP_026", "MLCAP_037", "MLCAP_038", "MLCAP_039", "MLCAP_055"]

def main():
    os.makedirs(SHARPENED_DIR, exist_ok=True)
    input_path = Path(INPUT_DIR)
    images = list(input_path.rglob("*.png"))
    
    print(f"Processing {len(images)} images...")
    
    html_content = ["<html><head><title>Preprocessing Visual Review</title></head><body>"]
    html_content.append("<h1>Original vs Sharpened (Worst Sets)</h1>")
    html_content.append("<p>Zoom in your browser to 200% to see the edges clearly.</p>")
    
    for img_path in images:
        rel_path = img_path.relative_to(INPUT_DIR)
        out_path = Path(SHARPENED_DIR) / rel_path
        out_path.parent.mkdir(parents=True, exist_ok=True)
        
        img = Image.open(img_path).convert("L")
        
        # Apply Sharpening Kernel
        # In V2 hardware, this will be a simple 3x3 convolution streaming filter
        sharpened = img.filter(ImageFilter.SHARPEN)
        sharpened.save(out_path)
        
        # Add to HTML if it's one of the worst sets
        set_name = rel_path.parts[0] if len(rel_path.parts) > 1 else ""
        if any(worst in set_name for worst in WORST_SETS):
            rel_path_str = str(rel_path).replace("\\", "/")
            html_content.append(f"<div style='margin-bottom: 20px; border-bottom: 1px solid #ccc; padding-bottom: 10px;'>")
            html_content.append(f"<h3>{rel_path_str}</h3>")
            html_content.append(f"<img src='../../{INPUT_DIR}/{rel_path_str}' style='width: 320px; image-rendering: pixelated; border: 1px solid black;' title='Original'> ")
            html_content.append(f"<img src='cleaned/{rel_path_str}' style='width: 320px; image-rendering: pixelated; border: 1px solid black;' title='Sharpened'>")
            html_content.append("</div>")
            
    html_content.append("</body></html>")
    
    with open(HTML_PATH, "w") as f:
        f.write("\n".join(html_content))
        
    print(f"Done! Cleaned images saved to {SHARPENED_DIR}")
    print(f"HTML review saved to {HTML_PATH}")

if __name__ == "__main__":
    main()