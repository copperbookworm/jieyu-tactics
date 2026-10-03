extends SceneTree

## 规模化的端到端验收：走**真实路径**（App.start_match → MatchHost 写 @export → WorldSetup 取模式人数），
## 数一数按模式到底建出了多少敌我单位。
##
## 为什么不放进 test/：跑批器把 @tool 测试当 RefCounted 跑，装不下场景树；
## 集成冒烟又只例化 Main.tscn（MatchRules 未设 ⇒ 回落 3 名队友），且中途换模式会毁掉它后面的检查。
## 所以单开这支，并挂进 run_tests_headless 的网关列表。
##
## 用法：godot --headless --path . --log-file <可写路径> --script res://tools/scale_wiring_check.gd
## 退出码：0 = 全绿，1 = 有失败。

const ModeTableScript := preload("res://data/config/ModeTable.gd")

## [模式, 期望敌人, 期望队友]
const CASES := [
	[ModeTableScript.Mode.PVEVP, 30, 3, 1, 0],
	[ModeTableScript.Mode.PVP_RANKED, 20, 19, 5, 2],
	[ModeTableScript.Mode.PVP_CASUAL, 20, 19, 5, 2],
]
const SETTLE_FRAMES := 24
const BOOT_FRAMES := 4

var _app = null
var _index := 0
var _frames := 0
var _booted := false
var _boot_frames := 0
var _passed := 0
var _failed := 0


func _initialize() -> void:
	var packed: PackedScene = load("res://scenes/app/App.tscn")
	if packed == null:
		print("！！ 加载不到 App.tscn")
		quit(1)
		return
	_app = packed.instantiate()
	_app.settings_path_override = "user://_scale_wiring_settings.cfg"
	root.add_child(_app)
	current_scene = _app


func _process(_delta: float) -> bool:
	if _app == null:
		return true
	if not _booted:
		_boot_frames += 1
		if _boot_frames >= BOOT_FRAMES:
			_booted = true
			print("===== 规模化端到端（真实路径：App → MatchHost → WorldSetup）=====")
		return false
	if _index >= CASES.size():
		_finish()
		return true
	if _frames == 0:
		_app.start_match(int(CASES[_index][0]))
	elif _frames <= 2:
		# 这条网关测的是「装配出多少单位」，不是战果 —— 19 个队友在 24 帧里能打死并 free 掉一个敌人，
		# 那样断言就会因为无关的战斗结果而假红（踩到过：20 → 19）。冻住双方开火，数出来的才是装配数。
		_freeze_combat()
	_frames += 1
	if _frames >= SETTLE_FRAMES:
		_check_case(_index)
		_app.return_to_lobby()
		_index += 1
		_frames = 0
	return false


func _check_case(i: int) -> void:
	var mode_id: int = int(CASES[i][0])
	var want_e: int = int(CASES[i][1])
	var want_a: int = int(CASES[i][2])
	var label := ModeTableScript.name_of(mode_id)
	# 只数 WorldSetup 按模式建出来的那些：事件驱动的穿插兵叫 Infiltrator#（Task T-S6 派出来的），
	# 它进不进 enemy 组取决于任务触发时机 —— 拿「组里一共几个」当断言会因为无关事件而假红。
	var enemies := _count_named("enemy", "Enemy")
	var friendlies := _count_named("friendly", "Ally")
	var spawned_e := -1
	var spawned_a := -1
	var w = _app.match_host.main.world if _app.match_host != null             and _app.match_host.main != null else null
	if w != null:
		spawned_e = int(w.spawned_enemy_count)
		spawned_a = int(w.spawned_ally_count)
	print("— %s：敌 %d（期望 %d）/ 友 %d（期望 %d）" % [label, enemies, want_e, friendlies, want_a])
	_check("模式 %s 装配出 %d 个敌人（组内实时 %d）" % [label, want_e, enemies], spawned_e, want_e)
	_check("模式 %s 装配出 %d 名队友（1 + %d = %d 人）" % [label, want_a, want_a, want_a + 1],
			spawned_a, want_a)
	# 编成（docx 4.10.8 / 5.8）：组 4 人 · 一小队至少 2 组
	var want_g: int = int(CASES[i][3])
	var want_s: int = int(CASES[i][4])
	var org: Dictionary = {}
	if _app.match_host != null and _app.match_host.main != null \
			and _app.match_host.main.world != null:
		org = _app.match_host.main.world.organization
	_check("模式 %s 的编成：%d 组 / %d 小队" % [label, want_g, want_s],
			[int(org.get("group_count", -99)), int(org.get("squad_count", -99))], [want_g, want_s])
	# 编成命令层（docx 4.10.8）：每个组一条组任务；主线收件人恒为玩家；0 组拿主线那个节点
	var orders: Dictionary = w.squad_orders if w != null else {}
	_check("模式 %s 派发 %d 条组任务（每组一条）" % [label, want_g],
			int(orders.get("items", []).size()), want_g)
	_check("模式 %s 主线收件人 = 玩家" % label, int(orders.get("recipient", -1)), 0)
	_check("模式 %s 玩家所在组的组任务是「占领 A」" % label,
			String((orders.get("my_order", {}) as Dictionary).get("text", "")),
			"占领 A" if want_g > 0 else "")


## 数组里名字以 prefix 开头的节点数（WorldSetup 的命名是 Enemy# / Ally#）
## 冻住双方开火：让「装配数」不被战斗结果影响（玩家阵亡也不影响计数）
func _freeze_combat() -> void:
	for e in get_nodes_in_group("enemy"):
		if "fire_damage" in e:
			e.fire_damage = 0.0
	for a in get_nodes_in_group("friendly"):
		if "fire_damage" in a:
			a.fire_damage = 0.0


func _count_named(group: String, prefix: String) -> int:
	var n := 0
	for node in get_nodes_in_group(group):
		if String(node.name).begins_with(prefix):
			n += 1
	return n


func _check(title: String, actual: Variant, expected: Variant) -> void:
	if actual == expected:
		_passed += 1
		print("[OK]   %s" % title)
	else:
		_failed += 1
		print("[FAIL] %s  期望=%s 实际=%s" % [title, str(expected), str(actual)])


func _finish() -> void:
	print("—— 通过 %d 项 / 失败 %d 项 ——" % [_passed, _failed])
	quit(1 if _failed > 0 else 0)
