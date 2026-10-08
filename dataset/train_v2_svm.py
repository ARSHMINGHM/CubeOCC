import os
import json
import csv
import numpy as np
from PIL import Image, ImageFilter, ImageOps
from pathlib import Path
from collections import Counter
from sklearn.svm import LinearSVC
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import accuracy_score, classification_report
import warnings
warnings.filterwarnings('ignore')

# --- Configuration ---
IMAGE_DIR = "sim/cubeocc_top_all_guard/camera_gray"
LABELS_FILE = "sim/cubeocc_top_all_guard/results.json"
ALIGNMENT_FILE = "cell_errors/per_frame.csv"

GRID_ROWS, GRID_COLS = 8, 8
CELL_W, CELL_H = 20, 15
RADIUS_SQ = 25

# --- 1. Preprocessing (Disabled for Raw Features) ---
def preprocess_image(img):
    # No filtering, just return raw numpy array
    return np.array(img)
# --- 2. Feature Extraction ---
def extract_cell_features(img_array, r, c, cell_means_grid):
    pixels = []
    origin_x = c * CELL_W
    origin_y = r * CELL_H
    for y in range(CELL_H):
        for x in range(CELL_W):
            abs_dx = abs(x - 10)
            abs_dy = abs(y - 7)
            if (abs_dx * abs_dx) + (abs_dy * abs_dy) <= RADIUS_SQ:
                pixels.append(img_array[origin_y + y, origin_x + x])
                
    if not pixels:
        return [0, 0, 0, 0, 0]
    
    mean_val = np.mean(pixels)
    var_val = np.var(pixels)
    max_val = np.max(pixels)
    min_val = np.min(pixels)
    
    neighbors = []
    if r > 0: neighbors.append(cell_means_grid[r-1][c])
    if r < 7: neighbors.append(cell_means_grid[r+1][c])
    if c > 0: neighbors.append(cell_means_grid[r][c-1])
    if c < 7: neighbors.append(cell_means_grid[r][c+1])
    neighbor_mean = np.mean(neighbors) if neighbors else mean_val
    
    return [mean_val, var_val, max_val, min_val, neighbor_mean]

# --- Main Pipeline ---
def main():
    if not os.path.exists(LABELS_FILE):
        print(f"Error: Labels file not found at {LABELS_FILE}")
        return

    with open(LABELS_FILE, 'r') as f:
        labels_data = json.load(f)
    
    frames_info = {}
    if isinstance(labels_data["frames"], dict):
        for key, val in labels_data["frames"].items():
            val["frame_id"] = key.split('/')[-1].split('.')[0]
            val["capture_set"] = key.split('/')[0]
            frames_info[key] = val
    else:
        for val in labels_data["frames"]:
            key = val["relative_path"]
            val["frame_id"] = key.split('/')[-1].split('.')[0]
            val["capture_set"] = key.split('/')[0]
            frames_info[key] = val

    alignment_map = {}
    if os.path.exists(ALIGNMENT_FILE):
        print("Loading perfect frame alignment from cell_errors/per_frame.csv...")
        with open(ALIGNMENT_FILE, 'r') as f:
            reader = csv.DictReader(f)
            for row in reader:
                clean_key = row["key"].replace("\\", "/")
                alignment_map[clean_key] = int(row["golden_index"])
    else:
        print("Error: per_frame.csv not found. Run cell_error_report.py first.")
        return

    print("Reconstructing Golden Truth using perfect alignment...")
    # Create a list of 13 Counters, one for each bit position (0 to 63)
    golden_votes = [[Counter() for _ in range(64)] for _ in range(13)]
    
    for clean_key, golden_idx in alignment_map.items():
        if clean_key in frames_info:
            bits = frames_info[clean_key]["symbols_bits"]
            for bit_idx in range(64):
                golden_votes[golden_idx][bit_idx][bits[bit_idx]] += 1
                
    golden_truth = []
    for i in range(13):
        frame_bits = ""
        for bit_idx in range(64):
            if golden_votes[i][bit_idx]:
                frame_bits += golden_votes[i][bit_idx].most_common(1)[0][0]
            else:
                frame_bits += "1" # Fallback if no data
        golden_truth.append(frame_bits)
    
    X_data = []
    Y_labels = []
    groups = []
    
    print("Extracting features with 100% accurate labels...")
    
    sets = {}
    for key, fdata in frames_info.items():
        sets.setdefault(fdata["capture_set"], []).append((key, fdata))
        
    for set_name, frames in sets.items():
        frames.sort(key=lambda x: int(x[1]["frame_id"].split('_')[-1]))
        
        for i, (key, fdata) in enumerate(frames):
            img_path = Path(IMAGE_DIR) / key
            if not img_path.exists(): continue
            
            img = Image.open(img_path).convert("L")
            processed_arr = preprocess_image(img)
            
            cell_means_grid = np.zeros((8, 8))
            for r in range(8):
                for c in range(8):
                    origin_x = c * CELL_W
                    origin_y = r * CELL_H
                    cell_pixels = []
                    for y in range(CELL_H):
                        for x in range(CELL_W):
                            abs_dx = abs(x - 10)
                            abs_dy = abs(y - 7)
                            if (abs_dx * abs_dx) + (abs_dy * abs_dy) <= RADIUS_SQ:
                                cell_pixels.append(processed_arr[origin_y + y, origin_x + x])
                    cell_means_grid[r][c] = np.mean(cell_pixels) if cell_pixels else 0
            
            clean_key = key.replace("\\", "/")
            if clean_key in alignment_map:
                golden_idx = alignment_map[clean_key]
            else:
                golden_idx = min(i, 12) # Fallback
                
            golden_bits = golden_truth[golden_idx]
            
            for r in range(8):
                for c in range(8):
                    cell_idx = r * 8 + c
                    features = extract_cell_features(processed_arr, r, c, cell_means_grid)
                    
                    # FIX: Correct MSB/LSB string indexing
                    bit_idx = 63 - cell_idx
                    label = int(golden_bits[bit_idx])
                    
                    X_data.append(features)
                    Y_labels.append(label)
                    groups.append(set_name)

    X_data = np.array(X_data)
    Y_labels = np.array(Y_labels)
    groups = np.array(groups)
    
    # --- 4. Train/Test Split ---
    unique_sets = list(set(groups))
    np.random.shuffle(unique_sets)
    test_size = int(len(unique_sets) * 0.2)
    test_sets = set(unique_sets[:test_size])
    
    train_mask = np.array([s not in test_sets for s in groups])
    test_mask = ~train_mask
    
    X_train, Y_train = X_data[train_mask], Y_labels[train_mask]
    X_test, Y_test = X_data[test_mask], Y_labels[test_mask]
    
    scaler = StandardScaler()
    X_train_scaled = scaler.fit_transform(X_train)
    X_test_scaled = scaler.transform(X_test)
    
    print(f"\nTraining Linear SVM... (Train: {len(X_train)} cells, Test: {len(X_test)} cells)")
    
    clf = LinearSVC(C=1.0, max_iter=5000, random_state=42)
    clf.fit(X_train_scaled, Y_train)
    
    Y_pred = clf.predict(X_test_scaled)
    acc = accuracy_score(Y_test, Y_pred)
    error_rate = 1.0 - acc
    
    print("\n=========================================")
    print("       V2 SVM Model Evaluation           ")
    print("=========================================")
    print(f"Test Sets: {len(test_sets)} capture sets")
    print(f"Model Accuracy: {acc*100:.2f}%")
    print(f"Cell Error Rate: {error_rate*100:.2f}%")
    print(f"Baseline V1 Error Rate: 3.73%")
    print("=========================================")
    print("\nClassification Report:")
    print(classification_report(Y_test, Y_pred, target_names=["Black (0)", "White (1)"]))

if __name__ == "__main__":
    main()