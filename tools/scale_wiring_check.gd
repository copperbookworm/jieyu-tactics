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
	[ModeTableScript.Mode.PVEVP, 30, 3],
	[ModeTableScript.Mode.PVP_RANKED, 20, 19],
	[ModeTableScript.Mode.PVP_CASUAL, 20, 19],
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
	# 用「活着的」数一下（事件驱动的穿插兵会晚点才进 enemy 组，这里只做规模下限校验）
	var enemies := get_nodes_in_group("enemy").size()
	var friendlies := get_nodes_in_group("friendly").size()
	print("— %s：敌 %d（期望 %d）/ 友 %d（期望 %d）" % [label, enemies, want_e, friendlies, want_a])
	_check("模式 %s 建出 %d 个敌人" % [label, want_e], enemies, want_e)
	_check("模式 %s 建出 %d 名队友（1 + %d = %d 人）" % [label, want_a, want_a, want_a + 1],
			friendlies, want_a)


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
