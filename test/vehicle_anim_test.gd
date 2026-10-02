@tool
extends EditorScript

## 12.7.2 载具动画（候选 M · 第四轮）：图层结构 / 履带滚动相位 / 报废冻结与变黑 / 残骸冒烟
## 运行：脚本编辑器打开本文件 → 文件 → 运行；或 godot --headless --script res://tools/run_tests_headless.gd
## 纯规则与节点结构在这里测；「真开一局里履带真的在滚、打爆后真的冒烟」跑在集成冒烟里。

const VehicleScript := preload("res://entities/vehicle/Vehicle.gd")
const WreckSmokeScript := preload("res://entities/effects/WreckSmoke.gd")

var _passed := 0
var _failed := 0


func _run() -> void:
	_test_params()
	_test_track_phase()
	_test_tread_positions()
	_test_layers()
	_test_track_freeze_when_wrecked()
	_test_wreck_smoke()
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


func _new_vehicle():
	var vehicle = VehicleScript.new()
	vehicle.setup("ifv_a", null)
	return vehicle


func _test_params() -> void:
	_check_true("12.7.2：履带齿间距为正", GameConfig.VEHICLE_TRACK_SPACING > 0.0)
	_check_true("12.7.2：履带宽度为正", GameConfig.VEHICLE_TRACK_WIDTH > 0.0)
	_check_true("12.7.2：报废炮管缩短比例在 (0,1)",
			GameConfig.VEHICLE_WRECK_BARREL_SHRINK > 0.0
			and GameConfig.VEHICLE_WRECK_BARREL_SHRINK < 1.0)
	_check_true("12.7.2：烟团数 ≥ 1", GameConfig.VEHICLE_SMOKE_PUFFS >= 1)


## 履带相位 ＝ 跑过的距离：速度 × 时间；停车（低于阈值）不推进
func _test_track_phase() -> void:
	_check("履带：停车不推进",
			VehicleScript.track_phase_advance(0.0, 0.0, 1.0), 0.0)
	_check("履带：速度低于阈值也不推进",
			VehicleScript.track_phase_advance(0.0, GameConfig.MOVE_SPEED_EPSILON * 0.5, 1.0), 0.0)
	_check("履带：5 m/s 走 2 s → 相位 +10 m",
			VehicleScript.track_phase_advance(0.0, 5.0, 2.0), 10.0)
	_check("履带：相位可累加",
			VehicleScript.track_phase_advance(10.0, 5.0, 1.0), 15.0)


func _test_tread_positions() -> void:
	var spacing := GameConfig.VEHICLE_TRACK_SPACING
	var count := 8
	var positions := VehicleScript.tread_positions(0.0, count, spacing)
	_check("履带齿：数量对得上", positions.size(), count)
	var span := float(count) * spacing
	var inside := true
	var spacing_ok := true
	for i in positions.size():
		if absf(positions[i]) > span * 0.5 + 0.001:
			inside = false
		if i > 0 and not is_equal_approx(positions[i] - positions[i - 1], spacing):
			spacing_ok = false
	_check_true("履带齿：都落在车体长度内", inside)
	_check_true("履带齿：等间距", spacing_ok)
	# 相位推进「一整段」之后齿的排布应当回到原样（周期性）
	var rolled := VehicleScript.tread_positions(span, count, spacing)
	var same := true
	for i in positions.size():
		if not is_equal_approx(positions[i], rolled[i]):
			same = false
	_check_true("履带齿：滚过一整段后回到原样（周期）", same)
	# 滚半格：齿的位置应该整体挪开
	var half := VehicleScript.tread_positions(spacing * 0.5, count, spacing)
	_check_true("履带齿：滚半格后位置变了",
			not is_equal_approx(positions[0], half[0]))
	_check("履带齿：个数为 0 时返回空", VehicleScript.tread_positions(0.0, 0, spacing).size(), 0)
	_check("履带齿：间距为 0 时返回空", VehicleScript.tread_positions(0.0, 4, 0.0).size(), 0)


## 12.7.2 的分图层结构：Hull / Turret / Track
func _test_layers() -> void:
	var vehicle = _new_vehicle()
	_check_true("图层：Hull 层已建", vehicle.get_node_or_null("Hull") != null)
	_check_true("图层：Turret 层已建", vehicle.get_node_or_null("Turret") != null)
	_check_true("图层：Track 层已建", vehicle.get_node_or_null("Track") != null)
	_check("图层：履带相位从 0 起算", vehicle.track_phase, 0.0)
	# 炮塔层的旋转 = 炮塔相对车体的角度
	vehicle.hull_facing = Vector2.RIGHT
	vehicle.turret_facing = Vector2.UP
	vehicle._sync_layers()
	_check_true("图层：Turret 层的 rotation 跟着炮塔转",
			is_equal_approx(vehicle.turret_layer.rotation, wrapf(Vector2.UP.angle(), -PI, PI)))
	# 履带相位随实际位移推进
	vehicle.velocity = Vector2(5.0, 0.0)
	vehicle._update_track(2.0)
	_check("图层：跑 2 s（5 m/s）后相位 10 m", vehicle.track_phase, 10.0)
	vehicle.velocity = Vector2.ZERO
	vehicle._update_track(2.0)
	_check("图层：停下来相位不再推进", vehicle.track_phase, 10.0)
	vehicle.free()


## 报废：履带冻结（M-kill 的「停转」），炮管走 WRECK 配色 / 缩短（F-kill 的等效）
func _test_track_freeze_when_wrecked() -> void:
	var vehicle = _new_vehicle()
	vehicle.velocity = Vector2(5.0, 0.0)
	vehicle._update_track(1.0)
	var phase_before: float = vehicle.track_phase
	_check_true("报废前：履带相位在推进", phase_before > 0.0)
	vehicle.take_hit(99999.0, 99999.0, Vector2.RIGHT)
	_check_true("报废：destroyed 为真", vehicle.destroyed)
	vehicle._update_track(1.0)
	_check("报废后：履带相位冻结", vehicle.track_phase, phase_before)
	_check_true("报废后：炮塔不再回正（recenter 直接返回）", vehicle.operator == null)
	vehicle.free()


func _test_wreck_smoke() -> void:
	var smoke = WreckSmokeScript.new()
	smoke.setup()
	_check("冒烟：烟团数 = 配置值", smoke.puff_count(), GameConfig.VEHICLE_SMOKE_PUFFS)
	_check("冒烟：初始相位首团为 0", smoke.puff_phase(0), 0.0)
	_check_true("冒烟：初始相位递增铺开",
			smoke.puff_phase(1) > smoke.puff_phase(0))
	var before := smoke.puff_phase(0)
	smoke.tick(GameConfig.VEHICLE_SMOKE_LIFETIME * 0.25)
	_check_true("冒烟：tick 之后相位前进", smoke.puff_phase(0) > before)
	_check_true("冒烟：相位始终在 [0, 1)",
			smoke.puff_phase(0) >= 0.0 and smoke.puff_phase(0) < 1.0)
	smoke.tick(GameConfig.VEHICLE_SMOKE_LIFETIME * 2.0)
	_check_true("冒烟：绕一圈仍在 [0, 1)",
			smoke.puff_phase(0) >= 0.0 and smoke.puff_phase(0) < 1.0)
	# 确定性：两个实例初始相位一致
	var other = WreckSmokeScript.new()
	other.setup()
	_check("冒烟：初始相位是确定性的（可复现）", other.puff_phase(0), 0.0)
	other.free()
	smoke.stop()
	var stopped := smoke.puff_phase(1)
	smoke.tick(1.0)
	_check("冒烟：停掉之后不再推进", smoke.puff_phase(1), stopped)
	_check("冒烟：越界索引安全返回 0", smoke.puff_phase(99), 0.0)
	smoke.free()
