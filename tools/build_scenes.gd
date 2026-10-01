@tool
extends EditorScript

## 场景生成脚本（不手写 .tscn，让 Godot 自己序列化，避免格式与 uid 出错）
## 用法：Godot 编辑器 → 脚本编辑器打开本文件 → 文件 → 运行（Ctrl+Shift+X）
## 生成物：
##   res://entities/player/Player.tscn —— CharacterBody2D + Player.gd（子节点运行时创建）
##   res://scenes/gameplay/Main.tscn   —— Node2D + Main.gd（地形/玩家/相机/敌人/HUD 运行时创建）
## 并把 Main.tscn 设为主场景，省去手点项目设置

const PLAYER_SCENE_PATH := "res://entities/player/Player.tscn"
const MAIN_SCENE_PATH := "res://scenes/gameplay/Main.tscn"
const PLAYER_SCRIPT_PATH := "res://entities/player/Player.gd"
const MAIN_SCRIPT_PATH := "res://scenes/gameplay/Main.gd"


func _run() -> void:
	_save_scene(PLAYER_SCENE_PATH, _make_player_root())
	_save_scene(MAIN_SCENE_PATH, _make_main_root())

	_apply_project_settings()
	var save_error := ProjectSettings.save()
	print("ProjectSettings.save → %s" % error_string(save_error))
	print("完成。已配好横屏 960×540 + Nearest 纹理 + 主场景，直接按 F5。")


## 一次性写入项目设置：横屏、960×540 视口、Nearest 纹理过滤、主场景
## 键名与枚举都来自 Godot 4 稳定接口；写后读回打印，便于确认真的生效
func _apply_project_settings() -> void:
	ProjectSettings.set_setting(
			"display/window/handheld/orientation", DisplayServer.SCREEN_LANDSCAPE)
	ProjectSettings.set_setting(
			"display/window/size/viewport_width", GameConfig.VIEWPORT_WIDTH)
	ProjectSettings.set_setting(
			"display/window/size/viewport_height", GameConfig.VIEWPORT_HEIGHT)
	ProjectSettings.set_setting(
			"rendering/textures/canvas_textures/default_texture_filter",
			Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST)
	ProjectSettings.set_setting("application/run/main_scene", MAIN_SCENE_PATH)

	# 读回验证
	var orientation := int(ProjectSettings.get_setting("display/window/handheld/orientation"))
	var view_w := int(ProjectSettings.get_setting("display/window/size/viewport_width"))
	var view_h := int(ProjectSettings.get_setting("display/window/size/viewport_height"))
	var filter := int(ProjectSettings.get_setting(
			"rendering/textures/canvas_textures/default_texture_filter"))
	print("方向 = %d（0=横屏）" % orientation)
	print("视口 = %d × %d" % [view_w, view_h])
	print("纹理过滤 = %d（0=Nearest）" % filter)
	print("主场景 = %s" % str(ProjectSettings.get_setting("application/run/main_scene")))


func _make_player_root() -> Node:
	var root := CharacterBody2D.new()
	root.name = "Player"
	root.set_script(load(PLAYER_SCRIPT_PATH))
	return root


func _make_main_root() -> Node:
	var root := Node2D.new()
	root.name = "Main"
	root.set_script(load(MAIN_SCRIPT_PATH))
	return root


func _save_scene(path: String, root: Node) -> void:
	var packed := PackedScene.new()
	var pack_error := packed.pack(root)
	if pack_error != OK:
		push_error("打包场景失败 %s：%s" % [path, error_string(pack_error)])
		root.free()
		return
	var save_error := ResourceSaver.save(packed, path)
	print("写入 %s → %s" % [path, error_string(save_error)])
	root.free()
