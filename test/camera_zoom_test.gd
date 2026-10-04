@tool
extends EditorScript

## 载具相机三档（docx 19 ②）自测：
##   两套档位表（步兵 30/60/120 m vs 载具 30/120/240 m）· 拖拽上限（500 / 1500 / ATGM 2000）
##   · 换档时把准心夹回新上限 · 三档都是整数 PPU（防贴图撕裂）
## AimCameraController 有 class_name，按项目惯例直接 new（与 effects_test / downed_test 一致）

var _passed := 0
var _failed := 0


func _run() -> void:
	_test_zoom_tables()
	_test_mode_switch()
	_test_drag_limits()
	_test_clamp_on_switch()
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


func _check_near(title: String, actual: float, expected: float, tolerance: float) -> void:
	if absf(actual - expected) <= tolerance:
		_passed += 1
		print("[OK]   %s (%.3f ≈ %.3f)" % [title, actual, expected])
	else:
		_failed += 1
		print("[FAIL] %s  期望=%.3f±%.3f 实际=%.3f" % [title, expected, tolerance, actual])


func _test_zoom_tables() -> void:
	_check("步兵档位表 = [32, 16, 8]（docx：30 / 60 / 120 m）",
			GameConfig.ZOOM_LEVELS, [32.0, 16.0, 8.0])
	_check("载具档位表 = [32, 8, 4]（docx 19 ②：30 / 120 / 240 m）",
			GameConfig.VEHICLE_ZOOM_LEVELS, [32.0, 8.0, 4.0])
	_check("两套都是三档", [GameConfig.ZOOM_LEVELS.size(), GameConfig.VEHICLE_ZOOM_LEVELS.size()],
			[3, 3])
	# 可视宽度 = 960 / PPU —— 文档给的 30/120/240 m 是「屏幕横跨多少米」，这才是三档的口径
	var infantry_m: Array = []
	for ppu in GameConfig.ZOOM_LEVELS:
		infantry_m.append(int(round(float(GameConfig.VIEWPORT_WIDTH) / float(ppu))))
	_check("步兵可视宽度 = 30 / 60 / 120 m", infantry_m, [30, 60, 120])
	var vehicle_m: Array = []
	for ppu in GameConfig.VEHICLE_ZOOM_LEVELS:
		vehicle_m.append(int(round(float(GameConfig.VIEWPORT_WIDTH) / float(ppu))))
	_check("载具可视宽度 = 30 / 120 / 240 m", vehicle_m, [30, 120, 240])
	var integer_ppu := true
	for ppu in GameConfig.ZOOM_LEVELS + GameConfig.VEHICLE_ZOOM_LEVELS:
		integer_ppu = integer_ppu and is_equal_approx(float(ppu), roundf(float(ppu)))
	_check_true("两套 PPU 都是整数（防非整数 PPU 破坏像素对齐）", integer_ppu)


func _test_mode_switch() -> void:
	var controller := AimCameraController.new()
	controller.set_vehicle_mode(true)
	_check_true("上车：标记为载具态", controller.in_vehicle)
	_check("上车：换成载具档位表", controller.zoom_levels(), GameConfig.VEHICLE_ZOOM_LEVELS)
	controller.set_zoom_index(2)
	_check_near("载具最远档 PPU = 4 px/m（横跨 240 m）", controller.current_ppu(), 4.0, 0.001)
	controller.set_vehicle_mode(false)
	_check_true("下车：回到步兵态", not controller.in_vehicle)
	_check("下车：换回步兵档位表", controller.zoom_levels(), GameConfig.ZOOM_LEVELS)
	_check_near("下车：当前索引下 PPU = 8 px/m（横跨 120 m）", controller.current_ppu(), 8.0, 0.001)
	controller.set_zoom_index(0)
	controller.set_vehicle_mode(false)
	_check("重复设置同一模式：索引不被重置", controller.zoom_index, 0)
	controller.free()


func _test_drag_limits() -> void:
	var controller := AimCameraController.new()
	_check("步兵拖拽上限 = 500 m（docx C3）",
			controller.max_drag_distance, GameConfig.SIGHT_MAX_DISTANCE_INFANTRY)
	controller.set_vehicle_mode(true)
	_check("上车默认上限 = 1500 m（8.2 坦克）",
			controller.max_drag_distance, GameConfig.SIGHT_MAX_DISTANCE_VEHICLE)
	controller.set_drag_limit(GameConfig.SIGHT_MAX_DISTANCE_ATGM)
	_check("武器位选中反坦克导弹 = 2000 m（docx 19 ②）",
			controller.max_drag_distance, GameConfig.SIGHT_MAX_DISTANCE_ATGM)
	controller.set_drag_limit(GameConfig.SIGHT_MAX_DISTANCE_VEHICLE)
	_check("切回主炮：上限退回 1500 m",
			controller.max_drag_distance, GameConfig.SIGHT_MAX_DISTANCE_VEHICLE)
	controller.set_drag_limit(0.0)
	_check_true("非法上限被夹到 ≥ 1 m（绝不能变成 0）", controller.max_drag_distance >= 1.0)
	controller.set_vehicle_mode(false)
	_check("下车：上限回到 500 m",
			controller.max_drag_distance, GameConfig.SIGHT_MAX_DISTANCE_INFANTRY)
	controller.free()


## 下车时准心必须**立刻**被夹回 500 m 内 —— 否则玩家带着一个 2 km 外的准心下了车，
## 要等下一次拖动才回归（真机上看起来就是「准心飞了」）。
func _test_clamp_on_switch() -> void:
	var controller := AimCameraController.new()
	var unit := Node2D.new()
	controller.set("_unit", unit)
	controller.set_vehicle_mode(true)
	controller.set_drag_limit(GameConfig.SIGHT_MAX_DISTANCE_ATGM)
	controller.crosshair_world = Vector2(1800.0, 0.0)
	_check_near("载具 + ATGM：1800 m 的准心不被夹（≤ 2000）",
			controller.crosshair_world.length(), 1800.0, 0.01)
	controller.set_vehicle_mode(false)
	_check_near("下车瞬间：准心被夹到 500 m",
			controller.crosshair_world.length(), GameConfig.SIGHT_MAX_DISTANCE_INFANTRY, 0.01)
	controller.free()
	unit.free()
