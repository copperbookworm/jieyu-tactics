# -*- coding: utf-8 -*-
"""jieyu-progress-sync · 只读取证脚本（不改任何文件）。

给《解域》jieyu-1 开发收尾对账用：一次输出全部「必须实测、不许凭记忆」的数字。

用法：
    & "D:\\dsh-data\\dsh-runtimes\\dsh-primary-runtime\\dependencies\\python\\python.exe" `
      "D:\\dsh-data\\skills\\jieyu-progress-sync\\scripts\\inspect_project.py"

可选参数：
    --project <路径>   覆盖 jieyu-1 工作副本路径
    --docs   <路径>    覆盖 squad-2d 文档目录路径
    --json             额外把结果写成 JSON（便于程序比对），同时仍打印中文报告

口径（与 jieyu-1/AGENTS.md 一致，别改）：
  · 行数用 LF 字节口径：读全文按 "\\n" 切分的段数 - 1。
    绝不能用逐行迭代器（中文 UTF-8 会少数约 6%，历史教训：Main.gd 被数成 911 行）。
  · .gd 统计不含 addons / gdtoolkit / .godot。
  · 本脚本只读；不写日志、不改文件。
"""
from __future__ import annotations

import argparse
import csv
import io
import json
import os
import subprocess
import sys

DEFAULT_PROJECT = r"D:\Godot4.7_Proj\jieyu-1"
DEFAULT_DOCS = r"D:\Godot4.7_Proj\squad-2d"

EXCLUDE_DIRS = {"addons", "gdtoolkit", ".godot", ".git"}

# 数据表：文件 → (表头行数, 说明)
DATA_TABLES = {
    r"data\weapons_data.txt": 1,
    r"data\vehicles_data.txt": 1,
    r"data\quest_templates.txt": 1,
}

# 只看这 6 张（其余 解域游戏*.csv 若出现会在报告里提示）
CSV_FILES = [
    "解域游戏动画帧规格.csv",
    "解域游戏美术资产表.csv",
    "解域游戏任务模板表.csv",
    "解域游戏载具数据表.csv",
    "解域游戏地图数据规格.csv",
    "解域游戏武器数据表.csv",
]

# 关注的工程文件（存在性 = 该候选是否落地）
LANDMARK_FILES = [
    r"scenes\gameplay\Main.gd",
    r"scenes\gameplay\Main.tscn",
    r"scenes\gameplay\WorldSetup.gd",
    r"scenes\gameplay\VehicleController.gd",
    r"systems\marks\MarkController.gd",
    r"ui\HudBuilder.gd",
    r"scenes\gameplay\IndirectController.gd",
    r"scenes\gameplay\SupplyController.gd",
    r"scenes\gameplay\LaneController.gd",
    r"entities\fob\Fob.gd",
    r"entities\lane\Lane.gd",
    r"entities\supply\Supply.gd",
    r"systems\quest\QuestSystem.gd",
    r"systems\quest\QuestTable.gd",
    r"tools\run_tests_headless.gd",
    r"tools\run_integration_headless.gd",
]

MAIN_SUBMODULES = [
    r"scenes\gameplay\WorldSetup.gd",
    r"scenes\gameplay\VehicleController.gd",
    r"systems\marks\MarkController.gd",
    r"ui\HudBuilder.gd",
    r"scenes\gameplay\IndirectController.gd",
    r"scenes\gameplay\SupplyController.gd",
    r"scenes\gameplay\LaneController.gd",
]


def lf_lines(path: str) -> int:
    """LF 字节口径行数（本工程唯一认可的统计口径）。"""
    with io.open(path, "rb") as fh:
        data = fh.read()
    if not data:
        return 0
    return data.count(b"\n") + (0 if data.endswith(b"\n") else 1)


def walk_files(root: str, suffix: str):
    out = []
    for dirpath, dirnames, filenames in os.walk(root):
        dirnames[:] = [d for d in dirnames if d not in EXCLUDE_DIRS]
        for name in filenames:
            if name.endswith(suffix):
                out.append(os.path.join(dirpath, name))
    return out


def rel(root: str, path: str) -> str:
    return os.path.relpath(path, root).replace("/", "\\")


def git_info(root: str) -> dict:
    def run(args):
        try:
            p = subprocess.run(
                ["git", "-C", root] + args,
                capture_output=True,
                text=True,
                encoding="utf-8",
                errors="replace",
                timeout=30,
            )
            return p.returncode, (p.stdout or "").strip()
        except Exception as exc:  # noqa: BLE001
            return -1, "git 调用失败：%s" % exc

    info = {"is_repo": os.path.isdir(os.path.join(root, ".git"))}
    if not info["is_repo"]:
        return info
    rc, head = run(["log", "-1", "--format=%H|%ad|%s", "--date=short"])
    info["head"] = head if rc == 0 else ""
    rc, st = run(["status", "--short"])
    info["dirty_count"] = len([l for l in st.splitlines() if l.strip()]) if rc == 0 else -1
    return info


def inspect_docx(docs_dir: str) -> dict:
    path = os.path.join(docs_dir, "解域游戏.docx")
    result = {"path": path, "exists": os.path.isfile(path)}
    if not result["exists"]:
        return result
    result["size"] = os.path.getsize(path)
    try:
        from docx import Document  # 延迟导入：没装 python-docx 时也能跑其余部分

        doc = Document(path)
        result["paragraphs"] = len(doc.paragraphs)
        result["tables"] = len(doc.tables)
        heads = [
            p.text.strip()
            for p in doc.paragraphs
            if p.style is not None and "Heading 1" in (p.style.name or "")
        ]
        result["h1"] = heads
    except Exception as exc:  # noqa: BLE001
        result["error"] = "python-docx 读取失败：%s" % exc
    return result


def inspect_csv(path: str) -> dict:
    info = {"file": os.path.basename(path)}
    if not os.path.isfile(path):
        info["exists"] = False
        return info
    info["exists"] = True
    info["size"] = os.path.getsize(path)
    try:
        with io.open(path, "rb") as fh:
            raw = fh.read(3)
        info["utf8_bom"] = raw == b"\xef\xbb\xbf"
        with io.open(path, encoding="utf-8-sig", newline="") as fh:
            rows = list(csv.reader(fh))
        info["rows_incl_header"] = len(rows)
        info["data_rows"] = max(0, len(rows) - 1)
        info["cols"] = len(rows[0]) if rows else 0
        if "状态" in (rows[0] if rows else []):
            idx = rows[0].index("状态")
            statuses = {}
            for r in rows[1:]:
                if idx < len(r):
                    statuses[r[idx]] = statuses.get(r[idx], 0) + 1
            info["status_counts"] = statuses
    except Exception as exc:  # noqa: BLE001
        info["error"] = "读取失败：%s" % exc
    return info


def main() -> int:
    ap = argparse.ArgumentParser(add_help=True)
    ap.add_argument("--project", default=DEFAULT_PROJECT)
    ap.add_argument("--docs", default=DEFAULT_DOCS)
    ap.add_argument("--json", action="store_true", help="同时输出 JSON")
    args = ap.parse_args()

    project, docs = args.project, args.docs
    out = {"project": project, "docs": docs}
    lines = []

    def emit(s=""):
        lines.append(s)

    emit("=" * 72)
    emit("jieyu-progress-sync · 只读取证报告")
    emit("=" * 72)

    # ── 规模 ───────────────────────────────────────────────
    if not os.path.isdir(project):
        emit("!! 工程目录不存在：%s" % project)
        print("\n".join(lines))
        return 2

    gd = walk_files(project, ".gd")
    total = sum(lf_lines(f) for f in gd)
    out["gd_files"] = len(gd)
    out["gd_lines"] = total
    emit("")
    emit("[规模]（LF 字节口径，不含 addons / gdtoolkit / .godot）")
    emit("  .gd 文件数 : %d" % len(gd))
    emit("  总行数     : %d" % total)

    main_gd = os.path.join(project, r"scenes\gameplay\Main.gd")
    if os.path.isfile(main_gd):
        n = lf_lines(main_gd)
        out["main_gd_lines"] = n
        emit("  Main.gd    : %d 行   %s" % (n, "（≤400 验收线：%s）" % ("守住" if n <= 400 else "⚠ 已破线")))
    else:
        emit("  Main.gd    : 缺失（路径变了？）")

    emit("")
    emit("[Main 子模块行数]")
    subs = {}
    for f in MAIN_SUBMODULES:
        p = os.path.join(project, f)
        name = os.path.basename(f)
        if os.path.isfile(p):
            subs[name] = lf_lines(p)
        else:
            subs[name] = None
    out["main_submodules"] = subs
    for name, n in subs.items():
        emit("  %-26s %s" % (name, ("%d 行" % n) if n is not None else "不存在"))

    # 最大的 .gd（看清谁在膨胀）
    big = sorted(((lf_lines(f), rel(project, f)) for f in gd), reverse=True)[:8]
    out["largest_gd"] = [{"lines": n, "path": p} for n, p in big]
    emit("")
    emit("[最大的 8 个 .gd]")
    for n, p in big:
        emit("  %5d  %s" % (n, p))

    # ── 地标文件 ────────────────────────────────────────────
    emit("")
    emit("[落地地标文件]（存在 = 该候选已落地）")
    marks = {}
    for f in LANDMARK_FILES:
        p = os.path.join(project, f)
        ok = os.path.isfile(p)
        marks[f] = ok
        emit("  %s  %s" % ("✔" if ok else "✘", f))
    out["landmarks"] = marks

    # ── 数据表 ──────────────────────────────────────────────
    emit("")
    emit("[工程数据表]（行数含表头）")
    tables = {}
    for f, header in DATA_TABLES.items():
        p = os.path.join(project, f)
        if os.path.isfile(p):
            n = lf_lines(p)
            tables[f] = {"lines": n, "data_rows": max(0, n - header)}
            emit("  %-32s 行=%d  数据行=%d" % (f, n, max(0, n - header)))
        else:
            tables[f] = None
            emit("  %-32s 缺失" % f)
    out["data_tables"] = tables

    # ── git ────────────────────────────────────────────────
    gi = git_info(project)
    out["git"] = gi
    emit("")
    emit("[git]")
    if not gi["is_repo"]:
        emit("  不是 git 仓库（进度文件抬头要照实写「没有 .git，无法核对/回退」）")
    else:
        emit("  HEAD        : %s" % (gi.get("head") or "（无提交）"))
        emit("  未提交改动  : %d 项（= 本轮工作量，收尾要写进进度文件）" % gi.get("dirty_count", -1))

    # ── 临时文件体检 ────────────────────────────────────────
    stray = [
        rel(project, os.path.join(project, n))
        for n in os.listdir(project)
        if n.startswith("_verify_") or n.startswith("_skill_verify")
    ]
    out["stray_logs"] = stray
    if stray:
        emit("")
        emit("[!] 取证临时文件没删干净：%s" % ", ".join(stray))

    # ── 设计文档侧 ──────────────────────────────────────────
    emit("")
    emit("=" * 72)
    emit("设计文档侧：%s" % docs)
    emit("=" * 72)
    if not os.path.isdir(docs):
        emit("!! 文档目录不存在：%s" % docs)
    else:
        dx = inspect_docx(docs)
        out["docx"] = dx
        emit("")
        emit("[解域游戏.docx]")
        if not dx["exists"]:
            emit("  不存在")
        elif "error" in dx:
            emit("  %s" % dx["error"])
        else:
            emit("  大小       : %d 字节" % dx["size"])
            emit("  段落数     : %d" % dx["paragraphs"])
            emit("  表格数     : %d" % dx["tables"])
            emit("  一级标题   : %s" % " / ".join(dx.get("h1", [])[-4:]))
            emit("  ⇒ 收尾后这三项都不应减少（减少=结构被破坏）")

        emit("")
        emit("[6 张 CSV]（设计目标；默认不该被改）")
        present = sorted(
            os.path.join(docs, n)
            for n in os.listdir(docs)
            if n.startswith("解域游戏") and n.endswith(".csv")
        )
        ordered = [os.path.join(docs, n) for n in CSV_FILES if os.path.isfile(os.path.join(docs, n))]
        extra_files = [p for p in present if p not in ordered]
        infos = []
        for p in ordered + extra_files:
            i = inspect_csv(p)
            infos.append(i)
            if not i["exists"]:
                emit("  %-30s 不存在" % i["file"])
                continue
            extra = ""
            if "status_counts" in i:
                extra = "  状态列: " + ", ".join(
                    "%s=%d" % (k, v) for k, v in sorted(i["status_counts"].items())
                )
            emit(
                "  %-30s 行=%d 数据行=%d 列=%d BOM=%s%s"
                % (
                    i["file"],
                    i.get("rows_incl_header", -1),
                    i.get("data_rows", -1),
                    i.get("cols", -1),
                    "有" if i.get("utf8_bom") else "无",
                    extra,
                )
            )
        missing = [n for n in CSV_FILES if not os.path.isfile(os.path.join(docs, n))]
        if missing:
            emit("  ⚠ 清单里缺失：%s" % ", ".join(missing))
        out["csv"] = infos

    emit("")
    emit("[下一步] 测试项数必须真跑取，本脚本不跑测试：")
    emit(r'  & "E:\Godot_v4.7.1-stable_win64.exe\Godot_v4.7.1-stable_win64_console.exe" `')
    emit(r'    --headless --path "%s" --script res://tools/run_tests_headless.gd --log-file "%s\_verify_unit.log"' % (project, project))
    emit(r'  & "E:\Godot_v4.7.1-stable_win64.exe\Godot_v4.7.1-stable_win64_console.exe" `')
    emit(r'    --headless --path "%s" --script res://tools/run_integration_headless.gd --log-file "%s\_verify_integration.log"' % (project, project))
    emit("  退出码 0=全绿 / 1=有失败；项数取日志里 <<<<< 与 #### 汇总 行。跑完删掉这两个 _verify_*.log。")

    report = "\n".join(lines)
    print(report)

    if args.json:
        jp = os.path.join(os.environ.get("TEMP", "."), "jieyu_progress_sync_state.json")
        with io.open(jp, "w", encoding="utf-8") as fh:
            json.dump(out, fh, ensure_ascii=False, indent=2)
        print("\n[JSON] %s" % jp)

    return 0


if __name__ == "__main__":
    sys.exit(main())
