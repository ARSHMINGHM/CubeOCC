import cv2
import os
import glob
import numpy as np

CAPTURES_DIR = "captures_rgb"
NUM_FRAMES = 6

def extract_frames(video_path):
    dataset_id = os.path.splitext(os.path.basename(video_path))[0]
    output_dir = os.path.join(CAPTURES_DIR, dataset_id)
    os.makedirs(output_dir, exist_ok=True)

    cap = cv2.VideoCapture(video_path)
    if not cap.isOpened():
        print(f"Error: Could not open video {video_path}")
        return

    print(f"Processing {dataset_id} (Spike Detector Mode)...")
    frames = []
    grays = []
    while True:
        ret, frame = cap.read()
        if not ret: break
        frames.append(frame)
        grays.append(cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY))
    cap.release()

    total = len(frames)
    if total < NUM_FRAMES * 2:
        print("  [Error] Video too short.")
        return
    diffs = np.zeros(total)
    for i in range(1, total):
        g1 = cv2.GaussianBlur(grays[i], (5,5), 0)
        g2 = cv2.GaussianBlur(grays[i-1], (5,5), 0)
        diffs[i] = cv2.mean(cv2.absdiff(g1, g2))[0]
    num_spikes = NUM_FRAMES - 1
    expected_gap = total / NUM_FRAMES
    min_distance = max(1, int(expected_gap * 0.3)) 
    order = np.argsort(diffs)[::-1]
    selected_spikes = []
    
    for idx in order:
        idx = int(idx)
        if all(abs(idx - s) >= min_distance for s in selected_spikes):
            selected_spikes.append(idx)
        if len(selected_spikes) == num_spikes:
            break

    selected_spikes.sort() 
    boundaries = [0] + selected_spikes + [total]
    
    extracted = 0
    for i in range(NUM_FRAMES):
        start, end = boundaries[i], boundaries[i+1]
        mid = start + max(1, (end - start) // 2)
        
        fname = f"frame_{extracted:02d}.jpg"
        cv2.imwrite(os.path.join(output_dir, fname), frames[mid])
        print(f"  [Saved] {fname} (from video frame {mid})")
        extracted += 1

    print(f"  -> Extracted {extracted} images to {output_dir}")

def main():
    print("=== CubeOCC RGB Video Frame Extractor (Spike Detector) ===")
    
    video_extensions = ['*.mp4', '*.avi', '*.mov', '*.mkv']
    video_files = []
    for ext in video_extensions:
        video_files.extend(glob.glob(os.path.join(CAPTURES_DIR, ext)))
        video_files.extend(glob.glob(os.path.join(CAPTURES_DIR, '**', ext), recursive=True))

    if not video_files:
        print(f"No video files found in '{CAPTURES_DIR}' directory.")
        return

    for video_path in video_files:
        extract_frames(video_path)

    print("\nExtraction complete!")

if __name__ == "__main__":
    main()