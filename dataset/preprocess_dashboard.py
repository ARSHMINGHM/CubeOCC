import os
import numpy as np
from PIL import Image, ImageFilter, ImageOps
from pathlib import Path
import base64
from io import BytesIO

INPUT_DIR = "sim/roi_rtl_all/camera_gray"
OUTPUT_HTML = "sim/postip/preprocess_dashboard.html"

# We select specific hard frames from the worst capture sets
TARGETS = [
    "MLCAP_020_StrongReflection_30fps/frame_05.png", # Glare / Reflection
    "MLCAP_038_Dark_SlightDefocus/frame_05.png",     # Defocus + Dark
    "MLCAP_055_Cam60_Defocus_Opt60/frame_05.png",    # Heavy Defocus + High FPS
    "MLCAP_026_Dark_Screen100/frame_05.png",         # Extreme Bloom
    "MLCAP_022_Near_Angle15/frame_05.png"             # Extreme Angle
]

def img_to_base64(img):
    """Convert PIL Image to Base64 string for embedding in HTML"""
    buffered = BytesIO()
    img.save(buffered, format="PNG")
    return base64.b64encode(buffered.getvalue()).decode("utf-8")

def apply_filters(img):
    """Apply 4 selected preprocessing techniques and return them"""
    img_arr = np.array(img).astype(np.int16)
    
    # 1. Original
    orig = img
    
    # 2. Median Filter (Removes salt/pepper noise and small glare dots)
    median = img.filter(ImageFilter.MedianFilter(size=3))
    
    # 3. BG Sub + Contrast + Sharpen (Previous Option 8)
    bg_level = np.percentile(img_arr, 10)
    bg_subtracted = np.clip(img_arr - bg_level, 0, 255).astype(np.uint8)
    bg_sub_img = Image.fromarray(bg_subtracted)
    prev_opt8 = ImageOps.autocontrast(bg_sub_img, cutoff=2).filter(ImageFilter.UnsharpMask(radius=2, percent=150, threshold=3))
    
    # 4. Median + BG Sub + Contrast + Sharpen (The Ultimate Combo)
    # We apply BG subtraction on the Median-filtered image to avoid noise spikes affecting the percentile
    median_arr = np.array(median).astype(np.int16)
    bg_level_m = np.percentile(median_arr, 10)
    bg_subtracted_m = np.clip(median_arr - bg_level_m, 0, 255).astype(np.uint8)
    bg_sub_img_m = Image.fromarray(bg_subtracted_m)
    ultimate = ImageOps.autocontrast(bg_sub_img_m, cutoff=2).filter(ImageFilter.UnsharpMask(radius=2, percent=150, threshold=3))
    
    return [
        ("1. Original", orig),
        ("2. Median (3x3)", median),
        ("3. BG Sub + Contrast + Sharpen", prev_opt8),
        ("4. Median + BG Sub + Contrast + Sharpen", ultimate)
    ]

def main():
    os.makedirs(os.path.dirname(OUTPUT_HTML), exist_ok=True)
    
    html_head = """
    <!DOCTYPE html>
    <html>
    <head>
    <title>CubeOCC Preprocessing Dashboard</title>
    <style>
        body { background-color: #1e1e1e; color: #ddd; font-family: monospace; margin: 20px; }
        h1 { color: #fff; border-bottom: 2px solid #444; padding-bottom: 10px; }
        .frame-container { margin-bottom: 40px; background: #2d2d2d; padding: 15px; border-radius: 8px; }
        .frame-title { color: #ffcc00; font-size: 1.2em; margin-bottom: 15px; }
        .grid { display: flex; flex-wrap: wrap; gap: 15px; }
        .item { text-align: center; }
        .item span { display: block; font-size: 0.8em; margin-bottom: 5px; color: #aaa; }
        img { width: 320px; image-rendering: pixelated; border: 1px solid #555; border-radius: 4px; }
        img:hover { transform: scale(2.5); transform-origin: top left; position: absolute; z-index: 10; border: 2px solid #ffcc00; }
    </style>
    </head>
    <body>
    <h1>CubeOCC Preprocessing Dashboard - Worst Case Scenarios</h1>
    <p><i>Hover your mouse over any image to zoom in 250% and inspect the LED edges.</i></p>
    """
    
    html_body = []
    
    for target in TARGETS:
        img_path = Path(INPUT_DIR) / target
        if not img_path.exists():
            print(f"Warning: {img_path} not found. Skipping.")
            continue
            
        img = Image.open(img_path).convert("L")
        results = apply_filters(img)
        
        html_body.append(f'<div class="frame-container">')
        html_body.append(f'<div class="frame-title">Condition: {target}</div>')
        html_body.append('<div class="grid">')
        
        for name, filtered_img in results:
            b64 = img_to_base64(filtered_img)
            html_body.append(f'<div class="item"><span>{name}</span><img src="data:image/png;base64,{b64}"></div>')
            
        html_body.append('</div></div>')
    
    html_end = "</body></html>"
    
    with open(OUTPUT_HTML, "w") as f:
        f.write(html_head + "\n".join(html_body) + html_end)
        
    print(f"Dashboard generated successfully! Open it in your browser: {OUTPUT_HTML}")

if __name__ == "__main__":
    main()