extends Node

## 烟雾控制器（候选 P，docx 4.12 / 4.12.8 确认稿）
##
## 职责只有两件事：
##   ① 按下 HUD「烟雾」键 → 步兵投烟雾弹（落点＝准心）／人在载具里＝载具发烟器（车体位置）
##   ② 管配额：步兵烟雾弹 SMOKE_GRENADE_COUNT 发；载具发烟器一局 SMOKE_VEHICLE_COUNT 次（8.3，下车不恢复）
##
## 与其它控制器同一套分工：世界实体（SmokeScreen）挂到 Main 上，流程与配额都在本模块，
## Main 只负责「建模块 + 接线」——所以 Main.gd 守得住候选 N 的 ≤400 行验收线。
## 刻意不写 class_name：引用方 preload（见 Cover.gd 头部说明）

const SmokeScreenScript := preload("res://entities/smoke/SmokeScreen.gd")

var main = null
## 步兵烟雾弹余量（第一版固定，不做补给）
var grenades := GameConfig.SMOKE_GRENADE_COUNT
## 载具发烟器剩余次数（一局一次，下车不恢复）
var vehicle_charges := GameConfig.SMOKE_VEHICLE_COUNT
## 一共放出去几团烟（集成冒烟 / 调试读它）
var deployed := 0


func setup(main_node) -> void:
	main = main_node


## HUD「烟雾」键的回调
func deploy() -> void:
	if main == null or main.player == null or main.hud == null:
		return
	# 开图期间不能操作（与开火同一条口径：开图 = 看情报，不是打架）
	if main.hud.is_map_open():
		return
	if in_vehicle():
		deploy_vehicle_smoke()
		return
	if main.camera_controller == null:
		return
	if grenades <= 0:
		main.hud.show_hint("烟雾弹打完了（第一版不做补给）")
		return
	grenades -= 1
	spawn_smoke(main.camera_controller.crosshair_world)
	main.hud.show_hint("烟雾弹已投出：剩余 %d 发" % grenades)


## 是否人在载具里（在车里就是发烟器，不是烟雾弹）
func in_vehicle() -> bool:
	return main != null and main.vehicles != null and main.vehicles.vehicle != null \
			and main.vehicles.vehicle.is_occupied()


func deploy_vehicle_smoke() -> void:
	if vehicle_charges <= 0:
		main.hud.show_hint("载具发烟器已经用过了（8.3：一局一次）")
		return
	vehicle_charges -= 1
	# 第二参数让烟幕真的跟着车（2026-10-02 真机修：以前只是提示文字写着「跟着车走」，
	# 实际烟幕是一个静止的落点，车一开走烟就留在原地）
	spawn_smoke(main.vehicles.vehicle.global_position, main.vehicles.vehicle)
	main.hud.show_hint("载具发烟器：烟幕已释放（跟着车走）")


## 放一团烟（半径 10 m / 高 3 m / 25 s，4.12.8 确认稿）。挂在 Main 上，与其它实体一致
func spawn_smoke(where: Vector2, follow_node: Node2D = null):
	if main == null:
		return null
	var smoke = SmokeScreenScript.new()
	smoke.name = "Smoke%d" % main.get_child_count()
	main.add_child(smoke)
	smoke.setup(where, follow_node)
	deployed += 1
	return smoke
