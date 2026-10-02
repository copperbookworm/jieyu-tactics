extends SceneTree

## 只读诊断：打印 HUD 全部可见 Control 的屏幕矩形（按 CanvasLayer 归组）
##
## 与 tools/geom_assertions.gd 同一套「headless 看 rect」口径，但只列不判：
## 排 HUD 新控件时先看这张表，能直接找到哪块是空的，不用靠猜。
## 用法：godot --headless --path <proj> --log-file <可写路径> --script res://tools/hud_rects.gd

const SETTLE_SECONDS := 1.5
const SCENE_PATH := "res://scenes/gameplay/Main.tscn"

var _main: Node = null
var _elapsed := 0.0
var _done := false


func _initialize() -> void:
	print("===== HUD 控件矩形（只读诊断）=====")
	var packed: PackedScene = load(SCENE_PATH)
	if packed == null:
		print("！！ 加载不到 %s" % SCENE_PATH)
		_done = true
		quit(1)
		return
	_main = packed.instantiate()
	root.add_child(_main)
	current_scene = _main


func _process(delta: float) -> bool:
	if _done:
		return true
	_elapsed += delta
	if _elapsed < SETTLE_SECONDS:
		return false
	_done = true
	_dump(_main, 0)
	print("===== 完（%.1f s 后布局已稳定）=====" % SETTLE_SECONDS)
	quit(0)
	return true


func _dump(node: Node, depth: int) -> void:
	if node is Control:
		var c := node as Control
		if c.is_visible_in_tree():
			var r := c.get_global_rect()
			print("%s%s  (%.0f,%.0f %.0fx%.0f)  layer=%d" % [
				"  ".repeat(depth), c.name, r.position.x, r.position.y,
				r.size.x, r.size.y, _layer_of(c)])
	for child in node.get_children():
		_dump(child, depth + 1)


func _layer_of(node: Node) -> int:
	var p := node
	while p != null:
		if p is CanvasLayer:
			return (p as CanvasLayer).layer
		p = p.get_parent()
	return -1
