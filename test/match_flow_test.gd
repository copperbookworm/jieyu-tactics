@tool
extends EditorScript

## 战局流程测试（候选 Q，docx 5.7 胜负判定决策确认稿）
## 运行：脚本编辑器打开本文件 → 文件 → 运行；或 godot --headless --script res://tools/run_tests_headless.gd

const MatchFlowScript := preload("res://systems/match/MatchFlow.gd")

var _passed := 0
var _failed := 0


func _run() -> void:
	_test_time_text()
	_test_timeout_decision()
	_test_sudden_death()
	_test_clock_phases()
	_test_respawn_budget()
	_test_respawn_resets_player()
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


func _test_time_text() -> void:
	_check("时间文案：15 分钟 → 15:00", MatchFlowScript.time_text(900.0), "15:00")
	_check("时间文案：加时前缀", MatchFlowScript.time_text(180.0, true), "加时 03:00")
	_check("时间文案：归零", MatchFlowScript.time_text(0.0), "00:00")
	_check("时间文案：不足 1 s 也显示 00:01（向上取整）",
			MatchFlowScript.time_text(0.4), "00:01")


func _test_timeout_decision() -> void:
	_check("超时判定：我方领先 → 胜", MatchFlowScript.decide_at_timeout(3, 1), "player")
	_check("超时判定：落后 → 负", MatchFlowScript.decide_at_timeout(1, 3), "enemy")
	_check("超时判定：持平 → 进加时（空串）", MatchFlowScript.decide_at_timeout(2, 2), "")


func _test_sudden_death() -> void:
	_check("突然死亡：占领差没变 → 继续", MatchFlowScript.sudden_death_winner(0, 2, 2), "")
	_check("突然死亡：我方拿到领先 → 胜", MatchFlowScript.sudden_death_winner(0, 3, 2), "player")
	_check("突然死亡：敌方拿到领先 → 负", MatchFlowScript.sudden_death_winner(0, 2, 3), "enemy")
	_check("突然死亡：从落后追平也算变化", MatchFlowScript.sudden_death_winner(-1, 2, 2), "player")


func _test_clock_phases() -> void:
	var flow = MatchFlowScript.new()
	flow.setup(null, 3)      # 3 人 ⇒ 预算 6
	_check("开局：阶段 = 进行中", flow.phase, MatchFlowScript.Phase.PLAYING)
	_check("开局：倒计时 = 15 分钟", flow.time_left, GameConfig.MATCH_DURATION)
	_check("开局：重生预算 = 人数 3 × 2", flow.budget, 6)
	flow._process(GameConfig.MATCH_DURATION - 1.0)
	_check("走完 14:59 仍在进行中", flow.phase, MatchFlowScript.Phase.PLAYING)
	flow._process(2.0)
	_check("时间到且 0:0 → 进加时", flow.phase, MatchFlowScript.Phase.OVERTIME)
	_check("加时倒计时 = 3 分钟", flow.time_left, GameConfig.OVERTIME_DURATION)
	flow._process(GameConfig.OVERTIME_DURATION + 1.0)
	_check("加时走完仍 0:0 → 平局", flow.outcome, "draw")
	_check("平局后阶段 = 已结束", flow.phase, MatchFlowScript.Phase.FINISHED)
	flow._process(10.0)
	_check("结束后时间停在 0（不会再计时）", flow.time_left, 0.0)
	flow.free()


## 重生必须真的把人和状态重置（使用者 2026-10-02 真机指出：只调 revive() 时血量与出生点都没重置）
func _test_respawn_resets_player() -> void:
	var p := PlayerUnit.new()
	p.respawn_point = Vector2(11.0, 22.0)
	p.global_position = Vector2(99.0, 99.0)
	p.suppression = 0.8
	p.hp = 0.0
	p.down()
	p.die()                                  # 真的阵亡：alive = false、downed = false
	_check_true("重生前：人是阵亡态", not p.alive)
	p.revive()
	_check_true("旧 revive() 救不活阵亡的人（它只管扶起倒地，是刻意分开的两个接口）", not p.alive)
	p.respawn()
	_check_true("重生：人活了", p.alive)
	_check("重生：血量补满（不是扶起的 25）", p.hp, GameConfig.SOLDIER_HP)
	_check("重生：回到出生点", p.global_position, Vector2(11.0, 22.0))
	_check_true("重生：不再是倒地态", not p.downed)
	_check("重生：倒地计时清零", p.downed_time_left, 0.0)
	_check("重生：压制清零", p.suppression, 0.0)
	_check("重生：弹匣补满", p.ammo_in_mag, p.mag_size)
	_check_true("重生：可见 + 输入解锁", p.visible and not p.input_locked)
	p.respawn(Vector2(3.0, 4.0))
	_check("重生：显式落点覆盖出生点", p.global_position, Vector2(3.0, 4.0))
	p.free()


func _test_respawn_budget() -> void:
	var flow = MatchFlowScript.new()
	flow.setup(null, 1)      # 1 人 ⇒ 预算 2
	_check("预算：1 人 ⇒ 2", flow.budget, 2)
	flow.on_player_died()
	_check("第一次阵亡：预算扣 1", flow.budget, 1)
	_check("第一次阵亡：还没判负（可以复活）", flow.phase, MatchFlowScript.Phase.PLAYING)
	_check("第一次阵亡：结局仍为空", flow.outcome, "")
	flow.on_player_died()
	_check("第二次阵亡：预算归零 → 判负", flow.outcome, "enemy")
	_check("判负原因 = 重生预算耗尽", flow.reason, "重生预算耗尽")
	flow.on_player_died()
	_check("已结束后再阵亡不会重复结算", flow.budget, 0)
	flow.free()
