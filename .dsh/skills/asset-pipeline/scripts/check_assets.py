#!/usr/bin/env python3
"""asset-pipeline / 校验：设计表（美术资产表 + 动画帧规格） ↔ 工程实际资源

只依赖标准库。PNG 尺寸直接读文件头（不依赖 Pillow）。

用法：
  python check_assets.py --design <squad-2d 目录> --project <jieyu-1 目录>

退出码：
  0 = 没发现问题
  1 = 有需要处理的发现（是给人看的清单，不等于工程坏了）
  2 = 用法/路径问题
"""

from __future__ import annotations

import argparse
import csv
import io
import re
import struct
import sys
import unicodedata
from collections import Counter, defaultdict
from pathlib import Path

ASSET_CSV = "解域游戏美术资产表.csv"
ANIM_CSV = "解域游戏动画帧规格.csv"

# 本机 Python 的 stdout 默认走系统 ANSI 代码页（GBK），直接 print 非 GBK 字符（如 ⚠）会
# UnicodeEncodeError 崩掉。这里强制 UTF-8，并把不可编码字符替换掉，保证脚本绝不因输出而挂。
try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    sys.stderr.reconfigure(encoding="utf-8", errors="replace")
except (AttributeError, ValueError):
    pass

# 无法解析成 WxH 的「规格」写法 —— 它们不是可校验的尺寸
NON_DIMENSIONAL = ("按需", "按", "半径", "几何", "炮塔")


def parse_args() -> argparse.Namespace:
    ap = argparse.ArgumentParser(description="美术资产设计表 ↔ 工程资源 校验")
    ap.add_argument("--design", required=True, help="含两张设计表的目录（squad-2d）")
    ap.add_argument("--project", required=True, help="jieyu-1 工程目录")
    ap.add_argument("--quiet", action="store_true", help="只输出发现项，不输出全部明细")
    return ap.parse_args()


def read_csv_checked(path: Path):
    """读 CSV，返回 (rows, has_bom, ncols)。UTF-8 带 BOM 是硬要求。"""
    raw = path.read_bytes()
    has_bom = raw[:3] == b"\xef\xbb\xbf"
    text = raw.decode("utf-8-sig" if has_bom else "utf-8")
    rows = list(csv.reader(io.StringIO(text)))
    # 去掉尾部空行
    while rows and not any(c.strip() for c in rows[-1]):
        rows.pop()
    ncols = len(rows[0]) if rows else 0
    return rows, has_bom, ncols


def normalize_spec(s: str) -> str:
    """归一化规格写法：全角→半角、去空白、统一 × 和 x。

    用来发现 `64×64px（近战档）` 与 `64×64px(近战档)` 这类「其实同一条」的重复。
    """
    s = unicodedata.normalize("NFKC", s or "")
    s = s.lower().replace(" ", "").replace("\u3000", "")
    s = s.replace("*", "x").replace("×", "x")
    return s


def parse_dims(spec: str):
    """从规格里抠出 (w, h)。抠不出返回 None。"""
    s = unicodedata.normalize("NFKC", spec or "")
    m = re.search(r"(\d+)\s*[x×*]\s*(\d+)", s)
    if not m:
        return None
    return int(m.group(1)), int(m.group(2))


def png_size(path: Path):
    """读 PNG 头部拿 (w, h)；不是 PNG 或读不动返回 None。"""
    try:
        with path.open("rb") as f:
            head = f.read(24)
    except OSError:
        return None
    if len(head) < 24 or head[:8] != b"\x89PNG\r\n\x1a\n":
        return None
    w, h = struct.unpack(">II", head[16:24])
    return w, h


def main() -> int:
    args = parse_args()
    design = Path(args.design)
    project = Path(args.project)

    for p in (design, project):
        if not p.is_dir():
            print(f"目录不存在：{p}", file=sys.stderr)
            return 2

    findings = []            # (类别, 说明)
    asset_rows = anim_rows = []

    # ---------- 读设计表 ----------
    print("=" * 72)
    print("一、设计表")
    print("=" * 72)
    for fname, store in ((ASSET_CSV, "asset"), (ANIM_CSV, "anim")):
        p = design / fname
        if not p.is_file():
            findings.append(("缺文件", f"设计表不存在：{p}"))
            print(f"  [!!] 找不到 {fname}")
            continue
        rows, has_bom, ncols = read_csv_checked(p)
        if store == "asset":
            asset_rows = rows
        else:
            anim_rows = rows
        n = len(rows) - 1
        print(f"  {fname}: 数据 {n} 行 / {ncols} 列 / BOM={has_bom}")
        if not has_bom:
            findings.append(("BOM", f"{fname} 没有 UTF-8 BOM（按工程约定应保留）"))
        if ncols != len(rows[0]):
            findings.append(("列数", f"{fname} 存在列数不一致的行"))

    def col_index(rows, name):
        return rows[0].index(name) if rows and name in rows[0] else -1

    # ---------- 二、规格可解析性 + 近似重复 ----------
    print()
    print("=" * 72)
    print("二、规格列（资产表）")
    print("=" * 72)
    si = col_index(asset_rows, "规格")
    if si >= 0 and asset_rows:
        specs = [r[si] for r in asset_rows[1:] if len(r) > si and r[si].strip()]
        unparsed = [s for s in specs if parse_dims(s) is None]
        print(f"  共 {len(specs)} 条规格，其中 **无法解析成 WxH** 的 {len(unparsed)} 条：")
        for s, c in Counter(unparsed).most_common():
            print(f"    - {s}  (x{c})")
        if unparsed:
            findings.append(("规格不可解析",
                             f"{len(unparsed)} 条规格不是 WxH 形式（{', '.join(sorted(set(unparsed)))[:120]}）"))

        # 归一化后的近似重复
        norm = defaultdict(set)
        for s in specs:
            norm[normalize_spec(s)].add(s)
        dupes = {k: v for k, v in norm.items() if len(v) > 1}
        print(f"  归一化后**近似重复**（全角/半角/空格差异）: {len(dupes)} 组")
        for k, v in dupes.items():
            variants = " vs ".join(sorted(v))
            print(f"    - {variants}")
            findings.append(("近似重复规格", f"归一化相同但写法不同：{variants}"))
    else:
        print("  （资产表里没有『规格』列，跳过）")

    # ---------- 三、状态 vs 实际 ----------
    print()
    print("=" * 72)
    print("三、状态列 vs 工程实际")
    print("=" * 72)
    sti = col_index(asset_rows, "状态")
    nai = col_index(asset_rows, "资产名")
    if sti >= 0 and asset_rows:
        st = Counter(r[sti] for r in asset_rows[1:] if len(r) > sti)
        print(f"  状态分布：{dict(st)}")
        done = [r for r in asset_rows[1:] if len(r) > sti and "已制作" in r[sti]]
        print(f"  标『已制作』的 {len(done)} 条：")
        for r in done:
            nm = r[nai] if nai >= 0 and len(r) > nai else "(无名)"
            note = r[-1] if len(r) > 6 else ""
            print(f"    - {nm}   备注：{note}")
        # 关键提醒：程序生成 ≠ PNG 资产
        print()
        print("  ⚠ 提醒：本工程画面多为**程序绘制**（HudBuilder 画几何 / HudTextureFactory 程序生成贴图）。")
        print("     「界面上看得见」**不等于**「资产表里的 PNG 已制作」。改状态前先确认真的有 PNG 入库。")
        findings.append(("人工确认",
                         f"{len(done)} 条标『已制作』，需逐条确认是 PNG 入库还是程序生成"))
    else:
        print("  （资产表里没有『状态』列，跳过）")

    # ---------- 四、工程 assets/ ----------
    print()
    print("=" * 72)
    print("四、工程 res://assets/ 实际资源")
    print("=" * 72)
    assets_dir = project / "assets"
    pngs = []
    if assets_dir.is_dir():
        pngs = sorted(p for p in assets_dir.rglob("*.png") if ".godot" not in p.parts)
    print(f"  找到 PNG {len(pngs)} 个")
    for p in pngs:
        rel = p.relative_to(project).as_posix()
        dim = png_size(p)
        dims = f"{dim[0]}x{dim[1]}" if dim else "读不出尺寸"
        print(f"    {rel}   {dims}   {p.stat().st_size:,} B")

    bad_names = []
    for p in pngs:
        stem = p.stem
        reasons = []
        if re.search(r"[\u4e00-\u9fff]", stem):
            reasons.append("含中文")
        if re.search(r"[A-Z]", stem):
            reasons.append("含大写")
        if re.search(r"_\d\b", stem) or re.search(r"_\d(?!\d)", stem):
            reasons.append("序号可能没补零两位")
        if reasons:
            bad_names.append((p.relative_to(project).as_posix(), "、".join(reasons)))
    if bad_names:
        print(f"\n  命名可能违规 {len(bad_names)} 个：")
        for rel, why in bad_names:
            print(f"    - {rel}   （{why}）")
        findings.append(("命名", f"{len(bad_names)} 个资源文件名可能违规"))

    # ---------- 五、孤儿资源 ----------
    print()
    print("=" * 72)
    print("五、孤儿资源（工程里有、设计表里找不到）")
    print("=" * 72)
    if pngs and asset_rows:
        # 设计表里出现的英文/数字标识 + 中文名，都拿来模糊匹配
        haystack = " ".join(" ".join(r) for r in asset_rows).lower()
        orphans = []
        for p in pngs:
            stem = p.stem.lower()
            # 去掉 _height 之类的后缀再试
            tokens = [t for t in re.split(r"[_\-\s]+", stem) if len(t) > 2]
            hit = stem in haystack or any(t in haystack for t in tokens)
            if not hit:
                orphans.append(p.relative_to(project).as_posix())
        if orphans:
            for rel in orphans:
                print(f"    {rel}")
            print(f"  共 {len(orphans)} 个 —— 可能是高度图这类『设计表没单列』的资源，也可能是漏登记/临时产物。")
            findings.append(("孤儿资源", f"{len(orphans)} 个资源在设计表里找不到明显对应"))
        else:
            print("  没有明显孤儿。")

    # ---------- 六、动画表 ----------
    print()
    print("=" * 72)
    print("六、动画帧规格表")
    print("=" * 72)
    if anim_rows:
        ai = col_index(anim_rows, "名称")
        fi = col_index(anim_rows, "帧数")
        zi = col_index(anim_rows, "尺寸px")
        print(f"  动画 {len(anim_rows) - 1} 条")
        print(f"  「名称」列样例（这一列是本工程的**正例命名**）：")
        for r in anim_rows[1:6]:
            if ai >= 0 and len(r) > ai:
                fr = r[fi] if fi >= 0 and len(r) > fi else "?"
                z = r[zi] if zi >= 0 and len(r) > zi else "?"
                print(f"    {r[ai]:<24} 帧数={fr:<4} 尺寸={z}")
        # 名称规范性
        bad = [r[ai] for r in anim_rows[1:] if ai >= 0 and len(r) > ai
               and not re.fullmatch(r"[a-z0-9_]+", r[ai] or "")]
        if bad:
            print(f"  [!!] 不符合 snake_case 的名称 {len(bad)} 条：{bad[:8]}")
            findings.append(("动画命名", f"{len(bad)} 条动画名不符合 snake_case"))
        else:
            print("  [OK] 全部动画名都是 snake_case（资产表应当向这一列看齐）")
        # 尺寸一致性
        zs = Counter(r[zi] for r in anim_rows[1:] if zi >= 0 and len(r) > zi)
        print(f"  尺寸分布：{dict(zs)}")
    else:
        print("  （没读到动画表）")

    # ---------- 汇总 ----------
    print()
    print("=" * 72)
    print("汇总：需要处理的发现")
    print("=" * 72)
    if not findings:
        print("  没有发现需要处理的问题。")
        return 0
    for cat, msg in findings:
        print(f"  [{cat}] {msg}")
    print()
    print(f"  共 {len(findings)} 类发现。这些是**给人看的清单**，不是「工程坏了」。")
    print("  改设计表结构（如加『资源ID』列）属于文档决策 → 登记待拍板，别自己拍。")
    return 1


if __name__ == "__main__":
    sys.exit(main())
