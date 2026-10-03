@tool
extends EditorPlugin

## 《解域》地图编辑插件（for Godot 4.7 / 工程 jieyu-1）
##
## 这个插件解决一件事：**不再用 Photoshop 画高度图**。
## 12.8.6 的官方工具链第③步是「PS / GIMP 灰度笔刷压平河道、平整道路、雕刻白旗点周边掩体」——
## 那一步没有可校验的中间态：改完只能靠眼睛看，改错了只能从头再来。
## 本插件把这一步搬进编辑器：同一张高度图、同一份 zones/occluders，
## 边画边看「坡度能不能走、通视打不打断、节点间距够不够」。
##
## 面向谁：主要是**给 agent 自己用**（配合 tools/jieyu_map_cli.gd 无头批处理），
## 其次才是给人手点。所以每个按钮对应的能力都有一条等价的 CLI 路径。
##
## 面板分三栏：
##   左：地图选择 / 生成配方 / 画笔 / 节点与掩体 / 校验报告
##   右：画布（滚轮缩放、中键平移、左键画、右键反向画）
## 上：工具条（保存 / 校验 / 重画审阅图 / 撤销）

const CANVAS_SCRIPT := preload("res://addons/jieyu_map/editor/JieyuMapCanvas.gd")
const DOCK_SCRIPT := preload("res://addons/jieyu_map/editor/JieyuMapDock.gd")
const RECIPE_PATH := "res://addons/jieyu_map/recipe_demo.json"

var _dock: Control = null


func _enter_tree() -> void:
	_dock = DOCK_SCRIPT.new()
	_dock.name = "解域地图"
	_dock.set("editor_plugin", self)
	_dock.set("recipe_path", RECIPE_PATH)
	add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_UL, _dock)


func _exit_tree() -> void:
	if _dock != null:
		remove_control_from_docks(_dock)
		_dock.queue_free()
		_dock = null
