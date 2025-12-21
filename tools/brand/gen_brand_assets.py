#!/usr/bin/env python3
import math
import struct
import zlib
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
OUT_DIR = ROOT / "assets" / "brand" / "icons"


def hex_to_rgb(value: str):
    value = value.lstrip("#")
    return tuple(int(value[i:i+2], 16) for i in (0, 2, 4))


class Canvas:
    def __init__(self, width, height, bg):
        self.width = width
        self.height = height
        self.pixels = bytearray(width * height * 3)
        self.fill(bg)

    def fill(self, color):
        r, g, b = color
        self.pixels[:] = bytes([r, g, b]) * (self.width * self.height)

    def set_pixel(self, x, y, color):
        if x < 0 or y < 0 or x >= self.width or y >= self.height:
            return
        idx = (y * self.width + x) * 3
        self.pixels[idx] = color[0]
        self.pixels[idx + 1] = color[1]
        self.pixels[idx + 2] = color[2]

    def draw_rect(self, x, y, w, h, color):
        x0 = max(int(x), 0)
        y0 = max(int(y), 0)
        x1 = min(int(x + w), self.width)
        y1 = min(int(y + h), self.height)
        for yy in range(y0, y1):
            row = (yy * self.width + x0) * 3
            for _ in range(x0, x1):
                self.pixels[row] = color[0]
                self.pixels[row + 1] = color[1]
                self.pixels[row + 2] = color[2]
                row += 3

    def draw_circle(self, cx, cy, r, color):
        r2 = r * r
        x0 = int(cx - r)
        x1 = int(cx + r)
        y0 = int(cy - r)
        y1 = int(cy + r)
        for y in range(y0, y1 + 1):
            dy = y - cy
            dy2 = dy * dy
            for x in range(x0, x1 + 1):
                dx = x - cx
                if dx * dx + dy2 <= r2:
                    self.set_pixel(x, y, color)

    def draw_ring(self, cx, cy, r_outer, r_inner, color):
        ro2 = r_outer * r_outer
        ri2 = r_inner * r_inner
        x0 = int(cx - r_outer)
        x1 = int(cx + r_outer)
        y0 = int(cy - r_outer)
        y1 = int(cy + r_outer)
        for y in range(y0, y1 + 1):
            dy = y - cy
            dy2 = dy * dy
            for x in range(x0, x1 + 1):
                dx = x - cx
                d2 = dx * dx + dy2
                if ri2 <= d2 <= ro2:
                    self.set_pixel(x, y, color)

    def draw_line(self, x0, y0, x1, y1, thickness, color):
        dx = x1 - x0
        dy = y1 - y0
        steps = max(abs(dx), abs(dy))
        if steps == 0:
            self.draw_circle(int(x0), int(y0), thickness // 2, color)
            return
        for i in range(steps + 1):
            x = x0 + dx * i / steps
            y = y0 + dy * i / steps
            self.draw_circle(int(round(x)), int(round(y)), thickness // 2, color)


def save_png(path, width, height, pixels):
    def chunk(tag, data):
        return (
            struct.pack("!I", len(data))
            + tag
            + data
            + struct.pack("!I", zlib.crc32(tag + data) & 0xFFFFFFFF)
        )

    signature = b"\x89PNG\r\n\x1a\n"
    ihdr = struct.pack("!IIBBBBB", width, height, 8, 2, 0, 0, 0)
    raw = bytearray()
    row_bytes = width * 3
    for y in range(height):
        start = y * row_bytes
        raw.append(0)
        raw.extend(pixels[start:start + row_bytes])
    compressed = zlib.compress(raw, 9)

    with open(path, "wb") as f:
        f.write(signature)
        f.write(chunk(b"IHDR", ihdr))
        f.write(chunk(b"IDAT", compressed))
        f.write(chunk(b"IEND", b""))


ACCENT = hex_to_rgb("#2CF1B0")
DARK_BG = hex_to_rgb("#0B0F0E")
LIGHT_BG = hex_to_rgb("#F6F5F2")


def draw_six_marker(canvas, cx, cy, r_inner, stroke, color):
    bar_w = int(stroke * 0.7)
    bar_h = int(r_inner * 1.1)
    bar_x = int(cx + r_inner * 0.35 - bar_w / 2)
    bar_y = int(cy - bar_h * 0.6)
    canvas.draw_rect(bar_x, bar_y, bar_w, bar_h, color)


def draw_7seg_digit(canvas, x, y, w, h, thickness, digit, color):
    segments = {
        "0": {"top", "upper_left", "upper_right", "lower_left", "lower_right", "bottom"},
        "6": {"top", "upper_left", "middle", "lower_left", "lower_right", "bottom"},
    }.get(digit)
    if not segments:
        return

    t = int(thickness)
    seg_h = max(1, int((h - 3 * t) / 2))
    rects = {
        "top": (x + t, y, w - 2 * t, t),
        "upper_left": (x, y + t, t, seg_h),
        "upper_right": (x + w - t, y + t, t, seg_h),
        "middle": (x + t, y + t + seg_h, w - 2 * t, t),
        "lower_left": (x, y + 2 * t + seg_h, t, seg_h),
        "lower_right": (x + w - t, y + 2 * t + seg_h, t, seg_h),
        "bottom": (x + t, y + 2 * seg_h + 2 * t, w - 2 * t, t),
    }
    for name in segments:
        rx, ry, rw, rh = rects[name]
        canvas.draw_rect(rx, ry, rw, rh, color)


def icon_option_a(bg, accent, out_path):
    c = Canvas(1024, 1024, bg)
    r_outer = 170
    stroke = 60
    r_inner = r_outer - stroke
    centers = [(340, 340), (684, 340), (340, 684), (684, 684)]
    for cx, cy in centers:
        c.draw_ring(cx, cy, r_outer, r_inner, accent)
    # Add six markers to left rings to hint 60
    draw_six_marker(c, 340, 340, r_inner, stroke, accent)
    draw_six_marker(c, 340, 684, r_inner, stroke, accent)
    # Divider line
    c.draw_line(200, 512, 824, 512, 18, accent)
    save_png(out_path, c.width, c.height, c.pixels)


def icon_option_b(bg, accent, out_path):
    c = Canvas(1024, 1024, bg)
    r_outer = 220
    stroke = 70
    r_inner = r_outer - stroke
    c.draw_ring(384, 512, r_outer, r_inner, accent)
    c.draw_ring(640, 512, r_outer, r_inner, accent)
    save_png(out_path, c.width, c.height, c.pixels)


def icon_option_c(bg, accent, out_path):
    c = Canvas(1024, 1024, bg)
    digit_w = 170
    digit_h = 320
    gap = 28
    x_w = 120
    x_h = int(digit_h * 0.7)
    thickness = max(16, int(digit_w * 0.18))

    total_w = digit_w * 4 + x_w + gap * 4
    start_x = int((c.width - total_w) / 2)
    start_y = int((c.height - digit_h) / 2)

    x0 = start_x
    x1 = x0 + digit_w + gap
    x_mid = x1 + digit_w + gap
    x2 = x_mid + x_w + gap
    x3 = x2 + digit_w + gap

    draw_7seg_digit(c, x0, start_y, digit_w, digit_h, thickness, "6", accent)
    draw_7seg_digit(c, x1, start_y, digit_w, digit_h, thickness, "0", accent)

    x_top = start_y + int((digit_h - x_h) / 2)
    x_thickness = max(10, thickness - 6)
    c.draw_line(x_mid, x_top, x_mid + x_w, x_top + x_h, x_thickness, accent)
    c.draw_line(x_mid, x_top + x_h, x_mid + x_w, x_top, x_thickness, accent)

    draw_7seg_digit(c, x2, start_y, digit_w, digit_h, thickness, "6", accent)
    draw_7seg_digit(c, x3, start_y, digit_w, digit_h, thickness, "0", accent)
    save_png(out_path, c.width, c.height, c.pixels)


def icon_option_d(bg, accent, out_path):
    c = Canvas(1024, 1024, bg)
    r_outer = 260
    stroke = 70
    r_inner = r_outer - stroke
    c.draw_ring(512, 512, r_outer, r_inner, accent)
    # Pause bars
    bar_w = 70
    bar_h = 280
    c.draw_rect(420, 512 - bar_h // 2, bar_w, bar_h, accent)
    c.draw_rect(534, 512 - bar_h // 2, bar_w, bar_h, accent)
    save_png(out_path, c.width, c.height, c.pixels)


def main():
    OUT_DIR.mkdir(parents=True, exist_ok=True)

    for theme_name, bg in ("dark", DARK_BG), ("light", LIGHT_BG):
        icon_option_a(bg, ACCENT, OUT_DIR / f"icon-option-a-{theme_name}-1024.png")
        icon_option_b(bg, ACCENT, OUT_DIR / f"icon-option-b-{theme_name}-1024.png")
        icon_option_c(bg, ACCENT, OUT_DIR / f"icon-option-c-{theme_name}-1024.png")
        icon_option_d(bg, ACCENT, OUT_DIR / f"icon-option-d-{theme_name}-1024.png")


if __name__ == "__main__":
    main()
