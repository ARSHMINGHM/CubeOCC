import cv2
import os
import glob
import re
import numpy as np

CAPTURES_DIR = "captures_rgb"
NUM_FRAMES = 6  # برای دیتاست RGB؛ برای grayscale برگردون به 13


def parse_fps_from_name(dataset_id):
    """اگه اسم فایل شامل CamXX و OptYY باشه (مثل ...Cam60_Opt60...)،
    نسبت camera_fps/optical_fps رو استخراج می‌کنه. اگه نبود None برمی‌گردونه."""
    cam_match = re.search(r'Cam(\d+)', dataset_id)
    opt_match = re.search(r'Opt(\d+)', dataset_id)
    if cam_match and opt_match:
        return int(cam_match.group(1)), int(opt_match.group(1))
    return None, None


def compute_diff_signal(video_path):
    """کل ویدیو رو می‌خونه، هر فریم رو (رنگی، بدون تبدیل به خاکستری) بلور می‌کنه
    و نگه می‌داره، و سیگنال تفاوت فریم‌به‌فریم رو روی هر ۳ کانال BGR حساب می‌کنه.
    برای RGB این حیاتیه: تبدیل به grayscale می‌تونست دو نماد هم‌روشنایی/رنگ‌متفاوت
    رو یکی نشون بده و کل تغییرشون از سیگنال diff حذف بشه."""
    cap = cv2.VideoCapture(video_path)
    if not cap.isOpened():
        raise IOError(f"Could not open video {video_path}")

    frames = []
    blurred = []
    while True:
        ret, frame = cap.read()
        if not ret:
            break
        frames.append(frame)
        blurred.append(cv2.GaussianBlur(frame, (5, 5), 0))
    cap.release()

    diffs = np.zeros(len(blurred))
    for i in range(1, len(blurred)):
        # cv2.mean روی تصویر ۳-کاناله میانگین هر کانال رو جدا میده؛ میانگین‌شون
        # می‌کنیم تا یه عدد واحد diff داشته باشیم که هم روشنایی هم رنگ رو پوشش بده
        per_channel = cv2.mean(cv2.absdiff(blurred[i], blurred[i - 1]))[:3]
        diffs[i] = sum(per_channel) / 3.0

    return frames, diffs


def find_top_peaks(diffs, num_peaks, min_distance):
    """بین کل فریم‌ها، num_peaks تا از قوی‌ترین تغییرات (بزرگ‌ترین diff) رو
    انتخاب می‌کنه، طوری که هیچ‌کدوم به‌هم نزدیک‌تر از min_distance نباشن
    (non-max suppression). این کار جای آستانه‌ی مطلق و ثابت رو می‌گیره،
    پس مستقل از روشنایی/رنگ نمادهاست."""
    order = np.argsort(diffs)[::-1]
    selected = []
    for idx in order:
        idx = int(idx)
        if all(abs(idx - s) >= min_distance for s in selected):
            selected.append(idx)
        if len(selected) == num_peaks:
            break
    return sorted(selected)


def pick_stable_frame(diffs, start, end):
    """داخل یک بازه‌ی بین دو تغییر، پایدارترین فریم (کمترین diff با فریم قبلی)
    رو از دوسوم انتهایی بازه انتخاب می‌کنه، تا از تاری حرکت بلافاصله بعد از
    تغییر دور بمونه؛ بدون نیاز به تعداد ثابت SETTLE_FRAMES."""
    inner_start = start + max(1, (end - start) // 3)
    if inner_start >= end:
        inner_start = start
    segment = diffs[inner_start:end]
    if len(segment) == 0:
        return max(start, end - 1)
    return inner_start + int(np.argmin(segment))


def extract_frames(video_path):
    dataset_id = os.path.splitext(os.path.basename(video_path))[0]
    output_dir = os.path.join(CAPTURES_DIR, dataset_id)
    os.makedirs(output_dir, exist_ok=True)

    print(f"Processing {dataset_id}...")

    frames, diffs = compute_diff_signal(video_path)
    total = len(frames)

    if total < NUM_FRAMES:
        print(f"  [Warning] video has only {total} frames, cannot extract {NUM_FRAMES}")
        return

    num_transitions = NUM_FRAMES - 1

    cam_fps, opt_fps = parse_fps_from_name(dataset_id)
    if cam_fps and opt_fps:
        # چند فریم دوربین به‌ازای هر نماد نوری واقعاً وجود داره (نه کل ویدیو با holdها)
        frames_per_symbol = cam_fps / opt_fps
        min_distance = max(1, int(frames_per_symbol * 0.4))
    else:
        # اسم فایل الگوی CamXX_OptYY نداشت -> برگرد به فرض قدیمی (توزیع یکنواخت کل ویدیو)
        expected_gap = total / NUM_FRAMES
        min_distance = max(1, int(expected_gap * 0.4))

    peaks = find_top_peaks(diffs, num_transitions, min_distance)
    boundaries = [0] + peaks + [total]

    extracted = 0
    for i in range(NUM_FRAMES):
        start, end = boundaries[i], boundaries[i + 1]
        idx = pick_stable_frame(diffs, start, end)
        fname = f"frame_{extracted:02d}.jpg"
        cv2.imwrite(os.path.join(output_dir, fname), frames[idx])

        print(f"  [Saved] {fname}  (frame index {idx}, segment {start}-{end})")
        extracted += 1

    print(f"  -> Extracted {extracted} images to {output_dir}")


def main():
    print("=== CubeOCC Video Frame Extractor ===")

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