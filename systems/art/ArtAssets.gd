extends RefCounted

## 美术资产的**唯一取用入口**（2026-10-07 第九十四版）。
##
## 为什么要有这一层：`assets/spec/art_manifest.json` 是美术与工程之间的契约（名字 / 尺寸 / 目录），
## 但工程侧原先**一点都没读它** —— 准星、摇杆、标记全是 `_draw()` 现画的，
## 于是美术把文件放进来了也没人用（入库盘点全绿、画面上毫无变化）。
## 这一层把「id → 路径 → 纹理」收敛到一处，并统一提供「**文件在就用文件、不在就退回程序绘制**」的语义：
## 正式美术到位时只要**同名替换文件**，工程一行都不用改。
##
## 刻意不写 class_name（引用方 preload），与 Cover.gd 同一约定。

## id → res:// 路径。**与 art_manifest.json 的 path 字段一一对应**，改这里必须同步 manifest。
const PATHS := {
	"ui_crosshair": "res://assets/ui/ui_crosshair.png",
	"ui_button_nineslice": "res://assets/ui/ui_button_nineslice.png",
	"ui_joystick_base": "res://assets/ui/ui_joystick_base.png",
	"ui_joystick_knob": "res://assets/ui/ui_joystick_knob.png",
	"ui_mark_enemy": "res://assets/ui/ui_mark_enemy.png",
	"ui_mark_vehicle": "res://assets/ui/ui_mark_vehicle.png",
	"ui_mark_position": "res://assets/ui/ui_mark_position.png",
	"ui_mark_supply": "res://assets/ui/ui_mark_supply.png",
	"ui_mark_smoke": "res://assets/ui/ui_mark_smoke.png",
	"ui_mark_rally": "res://assets/ui/ui_mark_rally.png",
	"char_rifleman_base": "res://assets/chars/char_rifleman_base.png",
	"char_marksman_base": "res://assets/chars/char_marksman_base.png",
	"char_scout_base": "res://assets/chars/char_scout_base.png",
	"char_engineer_base": "res://assets/chars/char_engineer_base.png",
}

## 已加载纹理的缓存。**懒加载**：第一次要用才 load，且只 load 一次。
static var _cache := {}


static func path_of(id: String) -> String:
	return String(PATHS.get(id, ""))


## 文件在不在（美术还没画就是 false —— 调用方据此退回程序绘制）
static func has(id: String) -> bool:
	var p := path_of(id)
	return p != "" and ResourceLoader.exists(p)


## 取纹理；不在就返回 null
static func texture(id: String) -> Texture2D:
	if _cache.has(id):
		return _cache[id]
	var tex: Texture2D = null
	if has(id):
		tex = load(path_of(id)) as Texture2D
	_cache[id] = tex
	return tex


## 清缓存（只给测试用：换文件后要能重新加载）
static func clear_cache() -> void:
	_cache.clear()


## 当前已入库的 id 列表（盘点 / 调试用）
static func available() -> Array:
	var out: Array = []
	for id in PATHS.keys():
		if has(id):
			out.append(id)
	return out