@tool
extends EditorScript

## 反坦克导弹（ATGM，使用者 2026-10-01 拍板）：IFV 装导弹 → 能打穿并摧毁敌方主战坦克
## 运行：脚本编辑器打开本文件 → 文件 → 运行；或 godot --headless --script res://tools/run_tests_headless.gd
## 数据事实（data/vehicles_data.txt）：IFV hp 800 / 机炮穿深 60 mm；MBT hp 2000 / 正面 700@30° ⇒ 等效 ≈ 808 mm。

const VehicleScript := preload("res://entities/vehicle/Vehicle.gd")
## VehicleTable 刻意不写 class_name（见其文件头），测试里同样 preload
const VehicleTableScript := preload("res://systems/vehicles/VehicleTable.gd")
const Procedural := preload("res://systems/audio/ProceduralAudio.gd")

var _passed := 0
var _failed := 0


func _run() -> void:
	_test_data()
	_test_penetration_math()
	_test_switch_ammo()
	_test_switch_permission()
	_test_fire_by_ammo_type()
	_test_atgm_exhausted()
	_test_visual_and_audio()
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


func _ifv():
	var vehicle = VehicleScript.new()
	vehicle.setup("ifv_a", null)
	return vehicle


## 数据表：只有步战车装了导弹
func _test_data() -> void:
	var ifv := VehicleTableScript.get_vehicle("ifv_a")
	_check("数据：IFV 带 2 发反坦克导弹", VehicleTableScript.number(ifv, "atgm_ammo", 0.0), 2.0)
	_check("数据：导弹伤害 1000", VehicleTableScript.number(ifv, "atgm_damage", 0.0), 1000.0)
	_check("数据：导弹穿深 900 mm", VehicleTableScript.number(ifv, "atgm_penetration_mm", 0.0), 900.0)
	_check("数据：导弹发射间隔 8 s", VehicleTableScript.number(ifv, "atgm_interval", 0.0), 8.0)
	# 射程 2000 m 是 docx 7.4.2 / 第十八章确认稿里的「ATGM 2000 m」；实际能瞄到多远受相机拖拽上限
	# （SIGHT_MAX_DISTANCE_VEHICLE 1500）限制 —— 19 章「ATGM 载具拖拽上限 2000 m」还没实现，见 docx 20.5。
	_check("数据：导弹射程 2000 m（按 docx 确认值）",
			VehicleTableScript.number(ifv, "atgm_range", 0.0), 2000.0)
	var tank := VehicleTableScript.get_vehicle("mbt_t1")
	_check("数据：主战坦克没装导弹（基数为 0）",
			VehicleTableScript.number(tank, "atgm_ammo", 0.0), 0.0)
	var vehicle = _ifv()
	_check_true("数据：IFV 的 has_atgm 为真", vehicle.has_atgm())
	_check("数据：导弹基数从表里读出来", vehicle.atgm_total(), 2)
	vehicle.free()


## 两条硬约束（使用者要求「能摧毁敌人坦克」）：穿得动正面、两发打得死
func _test_penetration_math() -> void:
	var tank := VehicleTableScript.get_vehicle("mbt_t1")
	var front := VehicleTableScript.effective_armor_mm(tank, "front", 0.0)
	var side := VehicleTableScript.effective_armor_mm(tank, "side", 0.0)
	var rear := VehicleTableScript.effective_armor_mm(tank, "rear", 0.0)
	_check_true("算术：坦克正面等效 ≈ 808 mm（700 ÷ cos30°）",
			absf(front - 808.29) < 1.0)
	_check_true("算术：导弹穿深 900 ≥ 正面等效（正面能打穿）", 900.0 >= front)
	_check_true("算术：导弹侧后更没问题", 900.0 >= side and 900.0 >= rear)
	var tank_hp := VehicleTableScript.number(tank, "hp", 0.0)
	var ifv := VehicleTableScript.get_vehicle("ifv_a")
	var atgm_damage := VehicleTableScript.number(ifv, "atgm_damage", 0.0)
	var atgm_ammo := VehicleTableScript.number(ifv, "atgm_ammo", 0.0)
	_check_true("算术：两发导弹总伤害 ≥ 坦克结构值（%d ≥ %d）"
			% [int(atgm_damage * atgm_ammo), int(tank_hp)],
			atgm_damage * atgm_ammo >= tank_hp)
	# 反例：不装导弹时，机炮对坦克任何一面都打不穿 —— 这就是使用者遇到的那个问题
	var gun_pen := VehicleTableScript.number(ifv, "gun_penetration_mm", 0.0)
	_check_true("反例：30mm 机炮 60 mm 打不穿坦克任何一面",
			not VehicleTableScript.is_penetrated(tank, "front", 0.0, gun_pen)
			and not VehicleTableScript.is_penetrated(tank, "side", 0.0, gun_pen)
			and not VehicleTableScript.is_penetrated(tank, "rear", 0.0, gun_pen))


func _test_switch_ammo() -> void:
	var vehicle = _ifv()
	_check("弹种：开局是主炮", vehicle.ammo_type(), VehicleScript.AmmoType.GUN)
	_check_true("弹种：切一次能切到导弹", vehicle.switch_ammo())
	_check("弹种：切到导弹了", vehicle.ammo_type(), VehicleScript.AmmoType.ATGM)
	_check_true("弹种：is_atgm_selected 为真", vehicle.is_atgm_selected())
	_check_true("弹种：再切回主炮", vehicle.switch_ammo())
	_check("弹种：回到主炮", vehicle.ammo_type(), VehicleScript.AmmoType.GUN)
	_check("弹种：主炮名字来自表", vehicle.ammo_type_name(), "30mm 机炮")
	vehicle.switch_ammo()
	_check("弹种：导弹名字固定", vehicle.ammo_type_name(), "反坦克导弹")
	_check("弹种：当前弹种余弹（导弹 2）", vehicle.selected_ammo(), 2)
	_check("弹种：当前弹种基数（导弹 2）", vehicle.selected_total(), 2)
	vehicle.free()
	var tank = VehicleScript.new()
	tank.setup("mbt_t1", null)
	_check("弹种：没装导弹的车切不动", tank.switch_ammo(), false)
	_check("弹种：切不动就还是主炮", tank.ammo_type(), VehicleScript.AmmoType.GUN)
	tank.free()


## 开火按弹种走：消耗谁、用谁的伤害/穿深/间隔
## 切弹种权限（2026-10-02 真机修：没上车时按「弹种」也能把车上弹种切了）
func _test_switch_permission() -> void:
	var vehicle = _ifv()
	var driver := PlayerUnit.new()
	vehicle.enter(driver)                          # 默认坐驾驶位
	_check("权限：人在驾驶位 → 不能切弹种", vehicle.can_switch_ammo(driver), false)
	vehicle.switch_seat(driver)                    # 换到武器位
	_check("权限：人在武器位 → 可以切弹种", vehicle.can_switch_ammo(driver), true)
	_check("权限：传 null 不做座位校验（内部 / 测试用）", vehicle.can_switch_ammo(null), true)
	vehicle.exit_vehicle()
	_check("权限：下车后（不在任何座位）→ 不能切弹种",
			vehicle.can_switch_ammo(driver), false)
	var tank = VehicleScript.new()
	tank.setup("mbt_t1", null)
	_check("权限：没装导弹的车，在武器位也不能切", tank.can_switch_ammo(driver), false)
	vehicle.free(); tank.free(); driver.free()


func _test_fire_by_ammo_type() -> void:
	var vehicle = _ifv()
	var player := PlayerUnit.new()
	vehicle.operator = player          # 武器位有人（跳过上车距离判定，直接给操作员）
	var gun_ammo_before: int = vehicle.ammo()

	var gun_shot: Dictionary = vehicle.fire([])
	_check("开火：主炮打出去的是 gun", String(gun_shot.get("ammo_type", "")), "gun")
	_check("开火：主炮穿深 60 mm", float(gun_shot["penetration_mm"]), 60.0)
	_check("开火：主炮弹药 -1", vehicle.ammo(), gun_ammo_before - 1)

	vehicle.switch_ammo()
	vehicle._fire_cooldown = 0.0
	var atgm_before: int = vehicle.atgm_ammo()
	var atgm_shot: Dictionary = vehicle.fire([])
	_check("开火：切弹种后打出去的是 atgm", String(atgm_shot.get("ammo_type", "")), "atgm")
	_check("开火：导弹穿深 900 mm", float(atgm_shot["penetration_mm"]), 900.0)
	_check("开火：导弹伤害 1000", float(atgm_shot["damage"]), 1000.0)
	_check("开火：导弹 -1", vehicle.atgm_ammo(), atgm_before - 1)
	_check("开火：主炮弹药没被动（各记各的账）", vehicle.ammo(), gun_ammo_before - 1)
	_check("开火：导弹的装填时间是 8 s", vehicle._fire_cooldown, 8.0)
	vehicle.free(); player.free()


## 导弹打光之后：打不出来、原因说清；切回主炮还能打
func _test_atgm_exhausted() -> void:
	var vehicle = _ifv()
	var player := PlayerUnit.new()
	vehicle.operator = player
	vehicle.switch_ammo()
	vehicle._fire_cooldown = 0.0
	vehicle.fire([])                       # 第 1 发
	vehicle._fire_cooldown = 0.0
	vehicle.fire([])                       # 第 2 发（打光）
	_check("打光：导弹余弹 0", vehicle.atgm_ammo(), 0)
	_check("打光：can_fire 为假", vehicle.can_fire(), false)
	_check("打光：给出的原因是「反坦克导弹打光」",
			vehicle.fire_block_reason(), "反坦克导弹打光")
	vehicle.switch_ammo()                  # 切回主炮
	vehicle._fire_cooldown = 0.0
	_check("打光：切回主炮后又可以打", vehicle.can_fire(), true)
	_check("打光：切回主炮没有阻塞原因", vehicle.fire_block_reason(), "")
	vehicle.free(); player.free()


## 导弹的视觉与音效要与机炮分得开
func _test_visual_and_audio() -> void:
	var tracer := Tracer.new()
	tracer.setup(Vector2.ZERO, Vector2.RIGHT, 100.0, GameConfig.ATGM_TRACER_COLOR)
	_check("表现：曳光支持自定义颜色（导弹用暖红）",
			tracer.default_color, GameConfig.ATGM_TRACER_COLOR)
	tracer.free()
	_check_true("音效：程序生成里有「missile」", Procedural.has_sound("missile"))
	var missile := Procedural.build("missile")
	_check_true("音效：导弹音效有波形",
			Procedural.sample_count(missile) > 0
			and Procedural.peak_amplitude(missile) > 0.0)
