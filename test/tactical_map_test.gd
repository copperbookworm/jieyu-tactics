@tool
extends EditorScript

## 战术地图测试（docx 4.11.1 / 4.11.3）：坐标互逆、屏幕中心、缩放档、拖动换算
## 运行：脚本编辑器打开本文件 → 文件 → 运行

var _passed := 0
var _failed := 0


func _run() -> void:
	_test_world_screen_roundtrip()
	_test_screen_center_is_map_center()
	_test_zoom_levels()
	_test_pan_scale()
	_test_close_emits_closed_signal()
	print("—— 通过 %d 项 / 失败 %d 项 ——" % [_passed, _failed])
	if _failed > 0:
		print("！！ 有 %d 项失败，往上翻看期望与实际" % _failed)


func _check(title: String, actual: Variant, expected: Variant) -> void:
	if actual == expected:
		_passed += 1
		print("[OK]   %s" % title)
	else:
		_failed += 1
		print("[FAIL] %s  期望=%s 实际=%s" % [title, str(expected), str(actual)])


func _check_true(title: String, condition: bool) -> void:
	_check(title, condition, true)


## 世界 → 屏幕 → 世界 必须回到原点（三档缩放都要成立）
func _test_world_screen_roundtrip() -> void:
	var map_center := Vector2(400.0, 600.0)
	for zoom in GameConfig.TACTICAL_ZOOM_LEVELS:
		var world := Vector2(123.0, 456.0)
		var screen := TacticalMap.world_to_screen(world, map_center, float(zoom))
		var back := TacticalMap.screen_to_world(screen, map_center, float(zoom))
		_check_true("坐标互逆（zoom=%.1f）" % float(zoom), back.distance_to(world) < 0.001)


func _test_screen_center_is_map_center() -> void:
	var map_center := Vector2(250.0, 250.0)
	var screen_center := Vector2(GameConfig.VIEWPORT_WIDTH, GameConfig.VIEWPORT_HEIGHT) * 0.5
	_check("屏幕中心对应地图中心点",
			TacticalMap.screen_to_world(screen_center, map_center, 0.9), map_center)


func _test_zoom_levels() -> void:
	var levels: Array = GameConfig.TACTICAL_ZOOM_LEVELS
	_check_true("缩放：三档且从小到大",
			levels.size() == 3 and float(levels[0]) < float(levels[1])
			and float(levels[1]) < float(levels[2]))
	var span := float(GameConfig.GRID_WIDTH) * float(levels[0])
	_check_true("最小档能把 1 km 全图放进屏幕宽（%d px ≤ %d px）"
			% [int(span), int(GameConfig.VIEWPORT_WIDTH)], span <= GameConfig.VIEWPORT_WIDTH)


## 屏幕位移 ÷ 缩放 = 世界位移（读图时「地图跟手」的前提）
func _test_pan_scale() -> void:
	var map_center := Vector2(500.0, 500.0)
	var zoom := 0.5
	var left := TacticalMap.screen_to_world(Vector2(400.0, 300.0), map_center, zoom)
	var right := TacticalMap.screen_to_world(Vector2(500.0, 300.0), map_center, zoom)
	_check("屏幕右移 100 px＝世界右移 200 m（zoom 0.5）", right.x - left.x, 200.0)


## 回归（2026-09-28 bug）：关地图必须发 closed 信号——Main 靠它复位 player.input_locked。
## 地图里那个「关闭」按钮走 TacticalMap.close()，不经过 Main._toggle_map()，
## 当时没有信号回传，摇杆就被永久锁死了。
func _test_close_emits_closed_signal() -> void:
	var map := TacticalMap.new()
	var fired := [false]
	map.closed.connect(func() -> void: fired[0] = true)
	map.close()
	_check_true("关闭地图会发 closed 信号", fired[0])
	map.free()
