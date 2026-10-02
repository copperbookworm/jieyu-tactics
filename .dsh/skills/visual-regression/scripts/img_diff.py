#!/usr/bin/env python3
"""visual-regression / B 路 · 两张 PNG 的差异比对。

只依赖 Pillow。输出差异图（在原图上标红）+ 差异像素数 / 占比 / 差异外接矩形；
差异占比超过阈值时以非零退出码结束，便于挂进流程。

用法：
  python img_diff.py --base <基线.png> --current <当前.png> [--out <差异.png>]
                     [--tolerance 3] [--max-diff-ratio 0.002]

退出码：
  0 = 在容差内
  1 = 超出容差（有差异）
  2 = 用法/文件问题（含尺寸不一致）
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

# 本机 Python 的 stdout 默认走系统 ANSI 代码页（GBK）；强制 UTF-8 以免中文/符号输出直接崩。
try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    sys.stderr.reconfigure(encoding="utf-8", errors="replace")
except (AttributeError, ValueError):
    pass

try:
    from PIL import Image, ImageChops, ImageDraw
except ImportError:  # pragma: no cover
    print("需要 Pillow。本机可用：D:\\dsh-data\\dsh-runtimes\\dsh-primary-runtime\\dependencies\\python\\python.exe", file=sys.stderr)
    sys.exit(2)


def parse_args() -> argparse.Namespace:
    ap = argparse.ArgumentParser(description="PNG 差异比对（视觉回归）")
    ap.add_argument("--base", required=True, help="基线 PNG 路径")
    ap.add_argument("--current", required=True, help="当前 PNG 路径")
    ap.add_argument("--out", default="", help="差异图输出路径（省略则不写文件）")
    ap.add_argument("--tolerance", type=int, default=3,
                    help="单通道容差 0-255，用来吃掉压缩/抗锯齿噪声（默认 3）")
    ap.add_argument("--max-diff-ratio", type=float, default=0.002,
                    help="允许的差异像素占比，超出即非零退出（默认 0.002 = 0.2%%）")
    return ap.parse_args()


def main() -> int:
    args = parse_args()
    base_path = Path(args.base)
    cur_path = Path(args.current)

    for p in (base_path, cur_path):
        if not p.is_file():
            print(f"找不到文件：{p}", file=sys.stderr)
            return 2

    base = Image.open(base_path).convert("RGB")
    cur = Image.open(cur_path).convert("RGB")

    if base.size != cur.size:
        print(f"尺寸不一致：基线 {base.size} vs 当前 {cur.size}", file=sys.stderr)
        print("→ 尺寸不一致说明分辨率/窗口/设备变了，不能按像素比。先统一抓图条件，或重做基线。", file=sys.stderr)
        return 2

    tol = max(0, min(255, args.tolerance))
    diff = ImageChops.difference(base, cur)

    # 逐像素判定：任一通道超过容差就算差异
    # 用 point 把 ≤tol 压到 0，再取通道最大值作为「差异强度」
    if tol > 0:
        bands = [ch.point(lambda v, t=tol: 0 if v <= t else v) for ch in diff.split()]
        strength = ImageChops.lighter(ImageChops.lighter(bands[0], bands[1]), bands[2])
    else:
        bands = list(diff.split())
        strength = ImageChops.lighter(ImageChops.lighter(bands[0], bands[1]), bands[2])

    total = base.size[0] * base.size[1]
    # histogram 里 0 是「相同」，其余都是差异
    hist = strength.histogram()
    diff_px = total - hist[0]
    ratio = diff_px / total if total else 0.0

    bbox = strength.getbbox()  # 差异外接矩形（None = 完全一致）

    print(f"基线    : {base_path}  {base.size[0]}x{base.size[1]}")
    print(f"当前    : {cur_path}")
    print(f"容差    : ±{tol}/通道    阈值: {args.max_diff_ratio * 100:.2f}%")
    print(f"差异像素: {diff_px} / {total}  ({ratio * 100:.4f}%)")
    if bbox:
        print(f"差异区域: x={bbox[0]}..{bbox[2]}  y={bbox[1]}..{bbox[3]}  "
              f"({bbox[2] - bbox[0]}x{bbox[3] - bbox[1]})")
    else:
        print("差异区域: 无（完全一致）")

    if args.out:
        before = cur.copy()
        draw = ImageDraw.Draw(before)
        if bbox:
            draw.rectangle(
                [bbox[0], bbox[1], max(bbox[0], bbox[2] - 1), max(bbox[1], bbox[3] - 1)],
                outline=(255, 0, 0), width=2,
            )
        out_path = Path(args.out)
        out_path.parent.mkdir(parents=True, exist_ok=True)
        before.save(out_path)
        print(f"差异图  : {out_path}")

    if ratio > args.max_diff_ratio:
        print("结果    : 超出阈值 —— 先看差异图，再判断是布局/资源问题还是渲染噪声")
        return 1

    print("结果    : 在容差内")
    return 0


if __name__ == "__main__":
    sys.exit(main())
