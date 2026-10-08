
# -*- coding: utf-8 -*-
import io, sys, os, json, csv
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
ROOT = r"D:\Godot4.7_Proj\jieyu-1"
OUT  = r"D:\Godot4.7_Proj\squad-2d\解域游戏正式版_游戏资产表.csv"

m = json.load(open(os.path.join(ROOT, "assets", "spec", "art_manifest.json"), encoding="utf-8"))
assets = m["assets"]; anims = m.get("animations", [])

def size_of(a):
    s = a.get("size")
    if isinstance(s, list) and len(s) == 2:
        return "%dx%d" % (int(s[0]), int(s[1]))
    return "未定(见备注)"

def fps_of(an):
    fps = an.get("fps")
    if fps is None or fps == "":
        return ""
    try:
        return " @%dfps" % int(float(fps))
    except (TypeError, ValueError):
        return ""

rows = []
for a in assets:
    rows.append({
        "资产类别": "图片",
        "id": a["id"], "名称": a.get("design_name", ""),
        "用途类别": a.get("category", ""),
        "规格": size_of(a), "规格依据": a.get("size_source", ""), "阵营": a.get("faction", ""),
        "格式": a.get("format", "PNG"),
        "批次": "batch%d" % int(a.get("batch", 0)),
        "路径": a["path"],
        "状态": a.get("design_status", ""),
        "备注": a.get("note", ""),
    })

for an in anims:
    frames = an.get("frames")
    if frames is None:
        fs = "未定"
    elif frames == 0:
        fs = "无帧(程序相位)"
    else:
        try:
            fs = "%d 帧" % int(float(frames))
        except (TypeError, ValueError):
            fs = str(frames)
    rows.append({
        "资产类别": "动画",
        "id": an["id"], "名称": an.get("design_name", ""),
        "用途类别": an.get("category", ""),
        "规格": fs + fps_of(an), "规格依据": "设计表帧数",
        "阵营": an.get("faction", ""),
        "格式": "PNG 序列帧",
        "批次": "batch%d" % int(an.get("batch", 0)),
        "路径": an.get("path_template", ""),
        "状态": an.get("design_status", ""),
        "备注": an.get("note", ""),
    })

SFX = [
    ("shot","步枪/机枪单发",0.11,"180Hz+噪声 85%"),
    ("shot_enemy","敌方枪声(略低)",0.11,"140Hz+噪声 85%"),
    ("cannon","坦克主炮",0.38,"70Hz+噪声 62%"),
    ("missile","导弹/火箭",0.55,"110Hz+噪声 95%"),
    ("impact","弹着/命中地形",0.07,"320Hz+噪声 90%"),
    ("hit","命中人体",0.10,"220Hz+噪声 70%"),
    ("explosion","爆炸",0.60,"45Hz+噪声 80%"),
    ("reload","换弹咔嗒",0.14,"900Hz+噪声 55%"),
    ("flag","占领/白旗",0.35,"520Hz 纯音"),
    ("down","倒地",0.45,"110Hz+噪声 35%"),
    ("kill","击杀确认",0.18,"660Hz 纯音"),
    ("match","对局结束",0.90,"260Hz 纯音"),
]
for sid, name, dur, spec in SFX:
    rows.append({
        "资产类别": "音效", "id": "sfx_" + sid, "名称": name,
        "用途类别": "战斗音效",
        "规格": "%.2f s @22050Hz 16bit mono (WAV)" % dur,
        "规格依据": "程序合成配方（ProceduralAudio RECIPES）",
        "阵营": "通用", "格式": "WAV(建议) / OGG", "批次": "batch3",
        "路径": "res://assets/audio/sfx_" + sid + ".wav(建议)",
        "状态": "程序合成(ProceduralAudio)",
        "备注": spec + "；正式录制/采购后同名替换",
    })

rows.append({
    "资产类别": "音乐", "id": "bgm_menu", "名称": "大厅/菜单主题",
    "用途类别": "BGM",
    "规格": "建议 60~120 s 循环 OGG, 44.1kHz 16bit stereo",
    "规格依据": "工程约定（移动端 BGM 通用规格）",
    "阵营": "通用", "格式": "OGG(建议)", "批次": "batch3",
    "路径": "res://assets/audio/bgm_menu.ogg(建议)",
    "状态": "暂无(工程无音乐)",
    "备注": "需要使用者提供或授权；循环点要干净",
})
rows.append({
    "资产类别": "音乐", "id": "bgm_battle", "名称": "对局战斗主题",
    "用途类别": "BGM",
    "规格": "建议 60~120 s 循环 OGG, 44.1kHz 16bit stereo",
    "规格依据": "工程约定（移动端 BGM 通用规格）",
    "阵营": "通用", "格式": "OGG(建议)", "批次": "batch3",
    "路径": "res://assets/audio/bgm_battle.ogg(建议)",
    "状态": "暂无(工程无音乐)",
    "备注": "战斗情绪；与 bgm_menu 音量分层",
})

cols = ["资产类别","id","名称","用途类别","规格","规格依据","阵营","格式","批次","路径","状态","备注"]
with open(OUT, "w", newline="", encoding="utf-8-sig") as f:
    w = csv.DictWriter(f, fieldnames=cols, extrasaction="ignore")
    w.writeheader()
    for r in rows:
        w.writerow(r)

print("已生成:", OUT)
print("总行数(含表头):", len(rows) + 1)
from collections import Counter
print("按资产类别:", dict(Counter(r["资产类别"] for r in rows)))
print("批次分布:", dict(Counter(r["批次"] for r in rows)))
print("文件大小: %.1f KB" % (os.path.getsize(OUT)/1024))
