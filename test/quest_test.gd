@tool
extends EditorScript

## 任务系统测试（docx 4.10.10 奖励决策 / 4.10.11 任务模板池实例）
## 运行：脚本编辑器打开本文件 → 文件 → 运行

const QuestTableScript := preload("res://systems/quest/QuestTable.gd")

var _passed := 0
var _failed := 0


func _run() -> void:
	_test_templates()
	_test_smeac()
	_test_weights()
	_test_side_quest_limit()
	_test_events()
	_test_timeout()
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


func _test_templates() -> void:
	var table := QuestTableScript.load_table()
	_check_true("模板表：至少 3 条（实际 %d 条）" % table.size(), table.size() >= 3)
	var main: Dictionary = QuestTableScript.get_template("T-M1")
	_check("模板表：T-M1 是主线", QuestTableScript.is_main(main), true)
	_check("模板表：T-M1 奖励 40（4.10.10）",
			QuestTableScript.number(main, "reward", 0.0), 40.0)
	_check("模板表：T-S4 奖励 10（简单支线）",
			QuestTableScript.number(QuestTableScript.get_template("T-S4"), "reward", 0.0), 10.0)
	_check("模板表：T-S1 奖励 15（中等支线）",
			QuestTableScript.number(QuestTableScript.get_template("T-S1"), "reward", 0.0), 15.0)


func _test_smeac() -> void:
	var smeac: Dictionary = QuestTableScript.smeac(
			QuestTableScript.get_template("T-M1"))
	_check_true("SMEAC：S / M / E 三行都非空",
			String(smeac["s"]) != "—" and String(smeac["m"]) != "—"
			and String(smeac["e"]) != "—")


## 权重表：战局变量会改变支线权重（4.10.10「规则模板 + 权重表」）
func _test_weights() -> void:
	var rifle := QuestSystem.new()
	rifle.start([], null, RoleTable.Role.RIFLEMAN)
	var scout := QuestSystem.new()
	scout.start([], null, RoleTable.Role.SCOUT)
	_check_true("权重：侦察兵在场时「侦察标记」权重更高（%.0f > %.0f）"
			% [scout.weight_of_template_id("T-S4"), rifle.weight_of_template_id("T-S4")],
			scout.weight_of_template_id("T-S4") > rifle.weight_of_template_id("T-S4"))
	rifle.free()
	scout.free()


func _test_side_quest_limit() -> void:
	var quests := QuestSystem.new()
	quests.start([], null, RoleTable.Role.RIFLEMAN)
	var side_count := 0
	for quest in quests.quests:
		if not bool(quest["main"]):
			side_count += 1
	_check_true("发放：支线不超过 %d 条（实际 %d）"
			% [QuestSystem.SIDE_QUEST_LIMIT, side_count],
			side_count <= QuestSystem.SIDE_QUEST_LIMIT)
	_check("发放：没有节点时不发主线", quests.main_quest().is_empty(), true)
	quests.free()


## 事件推进：报点 → 侦察标记进度；击倒 → 歼灭进度
func _test_events() -> void:
	var quests := QuestSystem.new()
	quests.start([], null, RoleTable.Role.RIFLEMAN)
	var marks_quest: Dictionary = {}
	for quest in quests.quests:
		if String(quest["goal_kind"]) == "place_marks":
			marks_quest = quest
	_check_true("事件：侦察标记支线已下发", not marks_quest.is_empty())
	if marks_quest.is_empty():
		quests.free()
		return
	quests.notify_mark_placed(Vector2.ZERO)
	_check("事件：报点 1 次 → 进度 1", float(marks_quest["progress"]), 1.0)
	quests.notify_mark_placed(Vector2.ZERO)
	_check("事件：报点到目标数 → 任务移出列表", quests.quests.has(marks_quest), false)
	_check("事件：完成计数 +1", quests.completed_count, 1)
	quests.free()


## 时限：到点失败、且不扣分（4.10.10）
func _test_timeout() -> void:
	var quests := QuestSystem.new()
	quests.start([], null, RoleTable.Role.RIFLEMAN)
	var timed: Dictionary = {}
	for quest in quests.quests:
		if float(quest["time_limit"]) > 0.0:
			timed = quest
	_check_true("时限：存在带时限的支线", not timed.is_empty())
	if timed.is_empty():
		quests.free()
		return
	quests.update(float(timed["time_limit"]) + 1.0)
	_check("时限：超时后任务移出列表", quests.quests.has(timed), false)
	_check("时限：超时不算完成（也就不扣分）", quests.completed_count, 0)
	quests.free()
