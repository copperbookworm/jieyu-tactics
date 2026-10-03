@tool
extends EditorScript

## 规模化的决策层：模式人数 latch / 回落，以及队友编队必须铺得开。
## 端到端（真的按模式建出 30 敌 / 19 友）走 tools/scale_wiring_check.gd —— 那需要场景树，跑批器装不下。

const MatchRulesScript := preload("res://systems/match/MatchRules.gd")
const ModeTableScript := preload("res://data/config/ModeTable.gd")
const AllyScript := preload("res://entities/ally/Ally.gd")

var _passed := 0
var _failed := 0


func _run() -> void:
	MatchRulesScript.reset()
	_test_latching()
	_test_fallback()
	_test_formation_spreads()
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


## 人数随模式一起 latch（docx 5.8）
func _test_latching() -> void:
	MatchRulesScript.set_mode(ModeTableScript.Mode.PVEVP)
	_check("PVEVP：敌 30", MatchRulesScript.enemy_count(), 30)
	_check("PVEVP：友 3（4P = 玩家 + 3 名）", MatchRulesScript.ally_count(), 3)
	MatchRulesScript.set_mode(ModeTableScript.Mode.PVP_RANKED)
	_check("PVP 竞技：敌 20", MatchRulesScript.enemy_count(), 20)
	_check("PVP 竞技：友 19（20 = 玩家 + 19 名）", MatchRulesScript.ally_count(), 19)
	_check("PVP 竞技：PVP 20 v 20 的进攻方就是 20 人（重生预算 ×2 = 40，对齐 docx 5.5）",
			1 + MatchRulesScript.ally_count(), 20)


## 模式没定义人数（兵棋 = 0）与「压根没设模式」都要回落到引擎默认
func _test_fallback() -> void:
	MatchRulesScript.set_mode(ModeTableScript.Mode.WARGAME)
	_check("兵棋（人数未定）：敌人 -1 = 未定义", MatchRulesScript.enemy_count(), -1)
	_check("兵棋（人数未定）：队友 -1 = 未定义", MatchRulesScript.ally_count(), -1)
	MatchRulesScript.reset()
	_check("没设模式：敌人 -1", MatchRulesScript.enemy_count(), -1)
	_check("没设模式：队友 -1", MatchRulesScript.ally_count(), -1)
	_check("回落值：GameConfig.ALLY_SQUAD_SIZE 仍是 3（= PVEVP 的 4P）",
			GameConfig.ALLY_SQUAD_SIZE, 3)


## 19 名队友必须铺得开：旧实现把角度取模 3 ⇒ 只有 3 个位置，19 人会叠成 3 堆
func _test_formation_spreads() -> void:
	var seen := {}
	for i in 19:
		seen[AllyScript.formation_offset(i, 6.0)] = true
	_check_true("编队：19 名队友的位置数 >= 15（不再取模 3 叠成 3 堆）", seen.size() >= 15)
	# 前 3 个与旧实现逐字一致（回归面为零）
	_check("编队：第 0 名 = 左后 0.75π", AllyScript.formation_offset(0, 6.0),
			Vector2.RIGHT.rotated(PI * 0.75) * 6.0)
	_check("编队：第 1 名 = 右后 1.25π", AllyScript.formation_offset(1, 6.0),
			Vector2.RIGHT.rotated(PI * 1.25) * 6.0)
	_check("编队：第 2 名 = 正后 π", AllyScript.formation_offset(2, 6.0),
			Vector2.RIGHT.rotated(PI) * 6.0)
	# 挂到后方的弧上：都在玩家后方（x < 0）
	_check_true("编队：第 4 名之后都在玩家后方（x < 0）",
			AllyScript.formation_offset(5, 6.0).x < 0.0 and AllyScript.formation_offset(18, 6.0).x < 0.0)
