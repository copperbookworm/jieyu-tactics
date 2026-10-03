@tool
extends EditorScript

## 本局模式规则 MatchRules：默认值必须与「今天的工程行为」一致（关友伤），
## 否则单测 / 集成冒烟 / 几何门禁这些没显式选模式的路径会被悄悄改行为。

const MatchRulesScript := preload("res://systems/match/MatchRules.gd")
const ModeTableScript := preload("res://data/config/ModeTable.gd")

var _passed := 0
var _failed := 0


func _run() -> void:
	# 静态字段在整个进程里共享（跑批器一个进程跑完所有测试脚本），先复位再断言
	MatchRulesScript.reset()
	_test_default_is_todays_behaviour()
	_test_ranked_mode()
	_test_pvevp_mode()
	_test_friendly_targets()
	_test_reset()
	MatchRulesScript.reset()   # 收尾复位：别把模式泄漏给后面的测试脚本
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


## 未设定模式时＝模式表默认（休闲）＝与今天工程一致的关友伤 / AI 参谋开放
func _test_default_is_todays_behaviour() -> void:
	_check_true("未设定模式：is_default", MatchRulesScript.is_default())
	_check("未设定模式：取模式表的默认模式",
			MatchRulesScript.mode_id(), ModeTableScript.default_mode_id())
	_check("未设定模式：关友伤（这是今天的既有行为，回归面为零）",
			MatchRulesScript.friendly_fire(), false)
	_check("未设定模式：AI 参谋开放", MatchRulesScript.competitive(), false)
	_check("未设定模式：胜负口径＝占领数",
			MatchRulesScript.win_rule(), ModeTableScript.WIN_OCCUPY)
	_check("未设定模式：时长＝默认模式的时长",
			MatchRulesScript.duration_s(), ModeTableScript.duration_s(ModeTableScript.default_mode_id()))


func _test_ranked_mode() -> void:
	MatchRulesScript.set_mode(ModeTableScript.Mode.PVP_RANKED)
	_check("竞技：不再是默认态", MatchRulesScript.is_default(), false)
	_check("竞技：开友伤", MatchRulesScript.friendly_fire(), true)
	_check("竞技：关 AI 参谋", MatchRulesScript.competitive(), true)
	_check("竞技：时长来自模式表",
			MatchRulesScript.duration_s(), ModeTableScript.duration_s(ModeTableScript.Mode.PVP_RANKED))
	_check("竞技：有加时", MatchRulesScript.uses_overtime(), true)
	_check_true("竞技：模式名可用", MatchRulesScript.name_of_mode().contains("竞技"))


func _test_pvevp_mode() -> void:
	MatchRulesScript.set_mode(ModeTableScript.Mode.PVEVP)
	_check("PVEVP：战术目标口径",
			MatchRulesScript.win_rule(), ModeTableScript.WIN_OBJECTIVE)
	_check("PVEVP：无加时（无平局）", MatchRulesScript.uses_overtime(), false)
	_check("PVEVP：关友伤", MatchRulesScript.friendly_fire(), false)


## 友伤只在开友伤的模式里改射击目标列表；且必须排除自己、不重复
func _test_friendly_targets() -> void:
	var shooter := Node.new()
	var ally_a := Node.new()
	var ally_b := Node.new()
	var enemy := Node.new()
	var targets: Array = [enemy]
	var friendlies: Array = [shooter, ally_a, ally_b]

	MatchRulesScript.set_mode(ModeTableScript.Mode.PVP_CASUAL)
	var off := MatchRulesScript.with_friendly_targets(shooter, targets, friendlies)
	_check("关友伤：目标列表一个都不多", off.size(), 1)
	_check("关友伤：目标还是那个敌人", off[0], enemy)

	MatchRulesScript.set_mode(ModeTableScript.Mode.PVP_RANKED)
	var on := MatchRulesScript.with_friendly_targets(shooter, targets, friendlies)
	_check("开友伤：敌人在", on.has(enemy), true)
	_check("开友伤：两名友军都进目标列表", on.size(), 3)
	_check("开友伤：自己不在目标列表里（不能打自己）", on.has(shooter), false)

	# 已经混进友军的列表不能再重复加一遍
	var mixed: Array = [enemy, ally_a]
	var again := MatchRulesScript.with_friendly_targets(shooter, mixed, friendlies)
	_check("开友伤：重复入列不加第二遍", again.size(), 3)
	_check("开友伤：不改动传入的原数组", targets.size(), 1)

	shooter.free()
	ally_a.free()
	ally_b.free()
	enemy.free()


func _test_reset() -> void:
	MatchRulesScript.set_mode(ModeTableScript.Mode.PVP_RANKED)
	MatchRulesScript.reset()
	_check_true("reset 后回到默认态", MatchRulesScript.is_default())
	_check("reset 后关友伤", MatchRulesScript.friendly_fire(), false)
