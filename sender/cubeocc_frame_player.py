#!/usr/bin/env python3
"""
Preview mapped CubeOCC frame PNGs.

This is a sender-side display helper for folders created by
cubeocc_frame_mapper.py when image mode is preview or all.
"""

from __future__ import annotations

import argparse
import re
import sys
import time
from dataclasses import dataclass
from pathlib import Path
from typing import List, Sequence

try:
    import tkinter as tk
    from tkinter import filedialog, messagebox, ttk
except Exception:  # pragma: no cover - GUI is optional in headless runs.
    tk = None
    filedialog = None
    messagebox = None
    ttk = None

try:
    from PIL import Image, ImageTk
except Exception:  # pragma: no cover - runtime dependency check happens in GUI.
    Image = None
    ImageTk = None


FRAME_RE = re.compile(r"frame_(\d+)_(start|data|end)\.png$", re.IGNORECASE)


@dataclass(frozen=True)
class FrameImage:
    path: Path
    index: int
    kind: str


def discover_frames(folder: Path) -> List[FrameImage]:
    frames: List[FrameImage] = []
    for path in folder.glob("*.png"):
        match = FRAME_RE.match(path.name)
        if not match:
            continue
        frames.append(FrameImage(path=path, index=int(match.group(1)), kind=match.group(2).lower()))
    frames.sort(key=lambda item: item.index)
    return frames


class FramePlayerGui:
    def __init__(self) -> None:
        if tk is None or ttk is None or Image is None or ImageTk is None:
            raise RuntimeError("tkinter and Pillow are required for the frame player GUI")

        self.root = tk.Tk()
        self.root.title("CubeOCC Frame Player")
        self.folder = tk.StringVar()
        self.fps_mode = tk.StringVar(value="30")
        self.custom_fps = tk.DoubleVar(value=30.0)
        self.play_mode = tk.StringVar(value="timed")
        self.start_hold_ms = tk.IntVar(value=1000)
        self.end_hold_ms = tk.IntVar(value=1000)
        self.loop = tk.BooleanVar(value=False)
        self.status = tk.StringVar(value="Choose a mapped *_images folder.")

        self.frames: List[FrameImage] = []
        self.frame_pos = 0
        self.running = False
        self.photo: ImageTk.PhotoImage | None = None
        self.viewer: tk.Toplevel | None = None
        self.canvas: tk.Canvas | None = None
        self.after_id: str | None = None
        self._build()

    def _build(self) -> None:
        frame = ttk.Frame(self.root, padding=12)
        frame.grid(row=0, column=0, sticky="nsew")
        self.root.columnconfigure(0, weight=1)
        self.root.rowconfigure(0, weight=1)
        frame.columnconfigure(1, weight=1)

        ttk.Label(frame, text="Image folder").grid(row=0, column=0, sticky="w")
        ttk.Entry(frame, textvariable=self.folder).grid(row=0, column=1, sticky="ew", padx=6)
        ttk.Button(frame, text="Browse", command=self._choose_folder).grid(row=0, column=2)

        timing = ttk.LabelFrame(frame, text="Playback")
        timing.grid(row=1, column=0, columnspan=3, sticky="ew", pady=(12, 0))
        ttk.Radiobutton(timing, text="Timed FPS", variable=self.play_mode, value="timed").grid(row=0, column=0, sticky="w")
        ttk.Radiobutton(timing, text="Manual keystroke", variable=self.play_mode, value="manual").grid(row=0, column=1, sticky="w", padx=(12, 0))

        ttk.Label(timing, text="FPS").grid(row=1, column=0, sticky="w", pady=(8, 0))
        ttk.Combobox(timing, textvariable=self.fps_mode, values=("30", "60", "custom"), state="readonly", width=10).grid(row=2, column=0, sticky="w")
        ttk.Label(timing, text="Custom FPS").grid(row=1, column=1, sticky="w", padx=(12, 0), pady=(8, 0))
        ttk.Spinbox(timing, from_=1, to=240, increment=1, textvariable=self.custom_fps, width=10).grid(row=2, column=1, sticky="w", padx=(12, 0))
        ttk.Label(timing, text="START hold ms").grid(row=1, column=2, sticky="w", padx=(12, 0), pady=(8, 0))
        ttk.Spinbox(timing, from_=0, to=60000, increment=100, textvariable=self.start_hold_ms, width=10).grid(row=2, column=2, sticky="w", padx=(12, 0))
        ttk.Label(timing, text="END hold ms").grid(row=1, column=3, sticky="w", padx=(12, 0), pady=(8, 0))
        ttk.Spinbox(timing, from_=0, to=60000, increment=100, textvariable=self.end_hold_ms, width=10).grid(row=2, column=3, sticky="w", padx=(12, 0))
        ttk.Checkbutton(timing, text="Loop", variable=self.loop).grid(row=2, column=4, sticky="w", padx=(12, 0))

        controls = ttk.Frame(frame)
        controls.grid(row=2, column=0, columnspan=3, sticky="ew", pady=(12, 0))
        ttk.Button(controls, text="Load", command=self._load_frames).grid(row=0, column=0)
        ttk.Button(controls, text="Run Fullscreen", command=self._run_fullscreen).grid(row=0, column=1, padx=(6, 0))
        ttk.Button(controls, text="Stop", command=self._stop).grid(row=0, column=2, padx=(6, 0))
        ttk.Label(frame, textvariable=self.status, wraplength=760).grid(row=3, column=0, columnspan=3, sticky="w", pady=(12, 0))

    def _choose_folder(self) -> None:
        path = filedialog.askdirectory()
        if path:
            self.folder.set(path)
            self._load_frames()

    def _load_frames(self) -> None:
        try:
            self.frames = discover_frames(Path(self.folder.get()))
        except Exception as exc:
            self.status.set(f"Error: {exc}")
            return
        self.frame_pos = 0
        self.status.set(f"Loaded {len(self.frames)} frame image(s). Space/Right = next, Left = previous, Esc = stop.")

    def _fps(self) -> float:
        if self.fps_mode.get() == "custom":
            return max(0.001, float(self.custom_fps.get()))
        return float(self.fps_mode.get())

    def _delay_for(self, frame: FrameImage) -> int:
        if frame.kind == "start":
            return int(self.start_hold_ms.get())
        if frame.kind == "end":
            return int(self.end_hold_ms.get())
        return max(1, int(1000.0 / self._fps()))

    def _ensure_viewer(self) -> None:
        if self.viewer is not None and self.viewer.winfo_exists():
            return
        self.viewer = tk.Toplevel(self.root)
        self.viewer.title("CubeOCC Frame Preview")
        self.viewer.attributes("-fullscreen", True)
        self.viewer.configure(bg="black")
        self.viewer.bind("<Escape>", lambda _event: self._stop())
        self.viewer.bind("<space>", lambda _event: self._manual_next())
        self.viewer.bind("<Right>", lambda _event: self._manual_next())
        self.viewer.bind("<Left>", lambda _event: self._manual_prev())
        self.viewer.bind("<Return>", lambda _event: self._manual_next())
        self.canvas = tk.Canvas(self.viewer, bg="black", highlightthickness=0)
        self.canvas.pack(fill="both", expand=True)
        self.canvas.bind("<Configure>", lambda _event: self._draw_current())

    def _run_fullscreen(self) -> None:
        if not self.frames:
            self._load_frames()
        if not self.frames:
            self.status.set("No frame_000000_start/data/end PNG files found in that folder.")
            return
        self.running = True
        self.frame_pos = 0
        self._ensure_viewer()
        self._draw_current()
        if self.play_mode.get() == "timed":
            self._schedule_next()

    def _stop(self) -> None:
        self.running = False
        if self.after_id and self.viewer is not None:
            self.viewer.after_cancel(self.after_id)
            self.after_id = None
        if self.viewer is not None and self.viewer.winfo_exists():
            self.viewer.destroy()
        self.viewer = None
        self.canvas = None
        self.status.set("Stopped.")

    def _manual_next(self) -> None:
        if not self.running or not self.frames:
            return
        if self.frame_pos + 1 < len(self.frames):
            self.frame_pos += 1
        elif self.loop.get():
            self.frame_pos = 0
        self._draw_current()

    def _manual_prev(self) -> None:
        if not self.running or not self.frames:
            return
        if self.frame_pos > 0:
            self.frame_pos -= 1
        self._draw_current()

    def _schedule_next(self) -> None:
        if not self.running or self.viewer is None or not self.frames:
            return
        delay = self._delay_for(self.frames[self.frame_pos])
        self.after_id = self.viewer.after(delay, self._advance_timed)

    def _advance_timed(self) -> None:
        if not self.running or not self.frames:
            return
        if self.frame_pos + 1 < len(self.frames):
            self.frame_pos += 1
            self._draw_current()
            self._schedule_next()
        elif self.loop.get():
            self.frame_pos = 0
            self._draw_current()
            self._schedule_next()
        else:
            self.running = False
            self.status.set("Playback finished.")

    def _draw_current(self) -> None:
        if self.canvas is None or not self.frames:
            return
        frame = self.frames[self.frame_pos]
        image = Image.open(frame.path).convert("RGB")
        canvas_w = max(1, self.canvas.winfo_width())
        canvas_h = max(1, self.canvas.winfo_height())
        scale = min(canvas_w / image.width, canvas_h / image.height)
        display_w = max(1, int(image.width * scale))
        display_h = max(1, int(image.height * scale))
        image = image.resize((display_w, display_h), Image.Resampling.NEAREST)
        self.photo = ImageTk.PhotoImage(image)
        self.canvas.delete("all")
        self.canvas.create_image(canvas_w // 2, canvas_h // 2, image=self.photo, anchor="center")
        self.status.set(f"Showing {self.frame_pos + 1}/{len(self.frames)}: {frame.path.name}")

    def run(self) -> None:
        self.root.mainloop()


def main(argv: Sequence[str]) -> int:
    parser = argparse.ArgumentParser(description="Preview CubeOCC mapped frame PNGs.")
    parser.add_argument("--folder", type=Path, help="Folder containing frame_*.png images.")
    parser.add_argument("--fps", default="30", help="30, 60, or custom numeric FPS.")
    parser.add_argument("--manual", action="store_true", help="Start in manual keystroke mode.")
    args = parser.parse_args(argv)

    gui = FramePlayerGui()
    if args.folder:
        gui.folder.set(str(args.folder))
        gui._load_frames()
    if args.manual:
        gui.play_mode.set("manual")
    if args.fps in ("30", "60"):
        gui.fps_mode.set(args.fps)
    else:
        gui.fps_mode.set("custom")
        gui.custom_fps.set(float(args.fps))
    gui.run()
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
