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
	_test_ts3_trigger()
	_test_ts2_trigger()
	_test_ts5_escort()
	_test_ts6_hold_lane()
	_test_tm2_defend()
	_test_side_requeue()
	_test_main_chain()
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
	_check("模板表：T-S3 奖励 20（候选 L1 新增）",
			QuestTableScript.number(QuestTableScript.get_template("T-S3"), "reward", 0.0), 20.0)


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


## 候选 L1：T-S3 摧毁敌方载具——官方模板行 + 触发闸门 + 事件推进
## （带真载具的端到端在 tools/run_integration_headless.gd 里跑：这里只测能确定复现的闸门与事件）
func _test_ts3_trigger() -> void:
	var template: Dictionary = QuestTableScript.get_template("T-S3")
	_check("T-S3：模板已入库", template.is_empty(), false)
	_check("T-S3：奖励 +20（官方表）", QuestTableScript.number(template, "reward", 0.0), 20.0)
	_check("T-S3：时限 150 s（官方表）", QuestTableScript.number(template, "time_limit", 0.0), 150.0)
	_check("T-S3：基础权重 20（官方表）", QuestTableScript.number(template, "base_weight", 0.0), 20.0)
	_check("T-S3：机制键 = destroy_vehicles",
			String(template.get("goal_kind", "")), "destroy_vehicles")
	_check("T-S3：是支线不是主线", QuestTableScript.is_main(template), false)
	# 闸门：第一版要求「敌方载具存活 + 已被报点标记」；测试环境两样都没有 ⇒ 权重必须为 0（开局不许发）
	var quests := QuestSystem.new()
	quests.start([], null, RoleTable.Role.MARKSMAN)
	_check("T-S3：无载具/无标记时权重为 0（开局不发）",
			quests.weight_of_template_id("T-S3"), 0.0)
	var issued := false
	for quest in quests.quests:
		if String(quest["id"]) == "T-S3":
			issued = true
	_check("T-S3：因此它不在开局任务列表里", issued, false)
	# 事件推进：手工挂一条 T-S3，验证「击毁载具 → 进度 +1 → 结算」
	var quest := quests._build_quest(template, null)
	quests.quests.append(quest)
	quests.notify_vehicle_destroyed()
	_check("T-S3：击毁载具事件 → 进度 1", float(quest["progress"]), 1.0)
	_check("T-S3：达到目标数 → 移出任务列表", quests.quests.has(quest), false)
	_check("T-S3：完成计数 +1", quests.completed_count, 1)
	quests.free()


## 支线重发（4.10.11「支线由战局事件触发」）：事件后重算，且不得突破「同时最多 2 条」的上限
func _test_side_requeue() -> void:
	var quests := QuestSystem.new()
	quests.start([], null, RoleTable.Role.RIFLEMAN)
	_check_true("重发：开局先发了支线（%d 条）" % _side_count(quests), _side_count(quests) > 0)
	# 报点两次推完「侦察标记」→ 完成 → 触发一次重算
	quests.notify_mark_placed(Vector2.ZERO)
	quests.notify_mark_placed(Vector2.ZERO)
	_check_true("重发：完成后有完成计数", quests.completed_count >= 1)
	_check_true("重发：支线不超过上限 %d（实际 %d）"
			% [QuestSystem.SIDE_QUEST_LIMIT, _side_count(quests)],
			_side_count(quests) <= QuestSystem.SIDE_QUEST_LIMIT)
	_check_true("重发：同一模板不重复发（T-S4 最多一条）",
			_count_template(quests, "T-S4") <= 1)
	quests.free()


## 主线链（第三版口径 + 候选 L5 防守阶段）：开局指向第一个非我方节点；翻蓝后转入防守，
## 不再直接跳下一个节点（完整流程与失守路径在 _test_tm2_defend 里逐条断言）
func _test_main_chain() -> void:
	var zones: Array = []
	for i in 3:
		var zone := CaptureZone.new()
		zone.state = CaptureZone.State.BLUE if i == 0 else CaptureZone.State.NEUTRAL
		zones.append(zone)
	var quests := QuestSystem.new()
	quests.start(zones, null, RoleTable.Role.RIFLEMAN)
	var main: Dictionary = quests.main_quest()
	_check_true("主线链：开局主线指向第一个非我方节点", main.get("zone") == zones[1])
	_check("主线链：开局主线是占领模板", String(main.get("id", "")), "T-M1")
	zones[1].state = CaptureZone.State.BLUE
	quests.update(0.0)
	_check("主线链：该节点翻蓝 → 主线完成一次", quests.completed_count, 1)
	var next_main: Dictionary = quests.main_quest()
	_check_true("主线链：翻蓝后转入防守阶段（候选 L5：打完就守，不直接跳下一个）",
			not next_main.is_empty() and String(next_main.get("id", "")) == "T-M2"
			and next_main.get("zone") == zones[1])
	for zone in zones:
		zone.free()
	quests.free()


func _side_count(quests: QuestSystem) -> int:
	var count := 0
	for quest in quests.quests:
		if not bool(quest["main"]):
			count += 1
	return count


func _count_template(quests: QuestSystem, id: String) -> int:
	var count := 0
	for quest in quests.quests:
		if String(quest["id"]) == id:
			count += 1
	return count


## 候选 L2：T-S2 摧毁敌方 FOB——官方模板行 + 触发闸门（必须先被报点暴露）+ 事件推进
## （带真 FOB 的端到端在 tools/run_integration_headless.gd 里跑：这里只测能确定复现的闸门与事件）
func _test_ts2_trigger() -> void:
	var template: Dictionary = QuestTableScript.get_template("T-S2")
	_check("T-S2：模板已入库", template.is_empty(), false)
	_check("T-S2：奖励 +20（官方表）", QuestTableScript.number(template, "reward", 0.0), 20.0)
	_check("T-S2：时限 180 s（官方表）", QuestTableScript.number(template, "time_limit", 0.0), 180.0)
	_check("T-S2：基础权重 25（官方表）", QuestTableScript.number(template, "base_weight", 0.0), 25.0)
	_check("T-S2：机制键 = destroy_fob", String(template.get("goal_kind", "")), "destroy_fob")
	_check("T-S2：是支线不是主线", QuestTableScript.is_main(template), false)
	# 闸门：官方触发「敌方 FOB 被标记暴露」——测试环境既没有 FOB 也没有标记 ⇒ 权重 0、开局不许发
	var quests := QuestSystem.new()
	quests.start([], null, RoleTable.Role.RIFLEMAN)
	_check("T-S2：无 FOB / 无标记时权重为 0（开局不发）",
			quests.weight_of_template_id("T-S2"), 0.0)
	var issued := false
	for quest in quests.quests:
		if String(quest["id"]) == "T-S2":
			issued = true
	_check("T-S2：因此不在开局任务列表里", issued, false)
	# 事件推进：手工挂一条，验证「摧毁 FOB → 进度 +1 → 结算」
	var quest := quests._build_quest(template, null)
	quests.quests.append(quest)
	quests.notify_fob_destroyed(null)
	_check("T-S2：摧毁 FOB 事件 → 进度 1", float(quest["progress"]), 1.0)
	_check("T-S2：达到目标数 → 移出任务列表", quests.quests.has(quest), false)
	_check("T-S2：完成计数 +1", quests.completed_count, 1)
	quests.free()


## 候选 L3：T-S5 护送补给至前线——官方模板行 + 触发闸门（我方已控制 ≥1 节点）+ 事件推进
## （真派车与抵达的端到端在 tools/run_integration_headless.gd 里跑）
func _test_ts5_escort() -> void:
	var template: Dictionary = QuestTableScript.get_template("T-S5")
	_check("T-S5：模板已入库", template.is_empty(), false)
	_check("T-S5：奖励 +15（官方表）", QuestTableScript.number(template, "reward", 0.0), 15.0)
	_check("T-S5：时限 180 s（官方表）", QuestTableScript.number(template, "time_limit", 0.0), 180.0)
	_check("T-S5：基础权重 15（官方表）", QuestTableScript.number(template, "base_weight", 0.0), 15.0)
	_check("T-S5：机制键 = escort_supply", String(template.get("goal_kind", "")), "escort_supply")
	_check("T-S5：是支线不是主线", QuestTableScript.is_main(template), false)
	# 闸门：官方「己方节点续航不足」第一版近似成「我方已控制 ≥1 个节点」
	var no_zone := QuestSystem.new()
	no_zone.start([], null, RoleTable.Role.RIFLEMAN)
	_check("T-S5：没有我方节点时权重为 0（开局不发）",
			no_zone.weight_of_template_id("T-S5"), 0.0)
	no_zone.free()
	var owned := CaptureZone.new()
	owned.state = CaptureZone.State.BLUE
	var frontline := CaptureZone.new()
	var zones: Array = [owned, frontline]
	var quests := QuestSystem.new()
	quests.start(zones, null, RoleTable.Role.RIFLEMAN)
	_check("T-S5：我方已控制 1 个节点 → 权重 15（刚好达阈值）",
			quests.weight_of_template_id("T-S5"), 15.0)
	# 事件推进：手工挂一条带目标节点的 T-S5，验证「补给抵达 → 进度 +1 → 结算」
	var quest := quests._build_quest(template, frontline)
	quests.quests.append(quest)
	_check_true("T-S5：任务带「指定节点」（补给要送到那里）", quest.get("zone") == frontline)
	quests.notify_supply_arrived()
	_check("T-S5：补给抵达事件 → 进度 1", float(quest["progress"]), 1.0)
	_check("T-S5：达到目标数 → 移出任务列表", quests.quests.has(quest), false)
	_check("T-S5：完成计数 +1", quests.completed_count, 1)
	owned.free()
	frontline.free()
	quests.free()


## 候选 L4：T-S6 守住侧翼通路——官方模板行 + 闸门 + 守住型口径（时限到点＝达成）+ 穿线失败 + 清光提前达成
## （真派穿插兵与穿线检测的端到端在 tools/run_integration_headless.gd 里跑）
func _test_ts6_hold_lane() -> void:
	var template: Dictionary = QuestTableScript.get_template("T-S6")
	_check("T-S6：模板已入库", template.is_empty(), false)
	_check("T-S6：奖励 +10（官方表）", QuestTableScript.number(template, "reward", 0.0), 10.0)
	_check("T-S6：时限 150 s（官方表）", QuestTableScript.number(template, "time_limit", 0.0), 150.0)
	_check("T-S6：基础权重 15（官方表）", QuestTableScript.number(template, "base_weight", 0.0), 15.0)
	_check("T-S6：机制键 = hold_lane", String(template.get("goal_kind", "")), "hold_lane")
	_check("T-S6：是支线不是主线", QuestTableScript.is_main(template), false)
	_check_true("T-S6：被判定为守住型（时限到点算达成）",
			QuestSystem.is_hold_goal("hold_lane"))
	# 闸门：官方触发「主线为占领且侧翼有未设防通道」——测试环境既没有主线也没有通路 ⇒ 权重 0
	var quests := QuestSystem.new()
	quests.start([], null, RoleTable.Role.RIFLEMAN)
	_check("T-S6：无主线 / 无侧翼通路时权重为 0（开局不发）",
			quests.weight_of_template_id("T-S6"), 0.0)
	# 守住型口径：时限到点 = 达成（而不是像其它支线那样超时失败）
	var hold := quests._build_quest(template, null)
	quests.quests.append(hold)
	quests.update(float(hold["time_limit"]) + 1.0)
	_check("T-S6：时限到点算达成（移出列表）", quests.quests.has(hold), false)
	_check("T-S6：守住到点计一次完成", quests.completed_count, 1)
	# 敌人穿线 → 立即失败
	var breached := quests._build_quest(template, null)
	quests.quests.append(breached)
	quests.notify_lane_breached()
	_check("T-S6：敌人穿过通道 → 立即失败（移出列表）", quests.quests.has(breached), false)
	_check("T-S6：失败不计完成", quests.completed_count, 1)
	# 穿插兵被清光 → 提前达成
	var secured := quests._build_quest(template, null)
	quests.quests.append(secured)
	quests.notify_lane_secured()
	_check("T-S6：清光穿插兵 → 提前达成", quests.quests.has(secured), false)
	_check("T-S6：再计一次完成", quests.completed_count, 2)
	quests.free()


## 候选 L5：T-M2 守住节点——官方模板行 + 防守阶段流程（拿下节点 → 转防守 → 到点达成 → 回进攻）
## + 失守（节点被翻红）→ 主线回到「夺回该节点」
func _test_tm2_defend() -> void:
	var template: Dictionary = QuestTableScript.get_template("T-M2")
	_check("T-M2：模板已入库", template.is_empty(), false)
	_check("T-M2：是主线（main=1）", QuestTableScript.is_main(template), true)
	_check("T-M2：奖励 +40（官方表）", QuestTableScript.number(template, "reward", 0.0), 40.0)
	_check("T-M2：机制键 = hold_zone", String(template.get("goal_kind", "")), "hold_zone")
	_check_true("T-M2：被判定为守住型（时限到点＝达成）", QuestSystem.is_hold_goal("hold_zone"))
	var z0 := CaptureZone.new()
	var z1 := CaptureZone.new()
	var zones: Array = [z0, z1]
	var quests := QuestSystem.new()
	quests.start(zones, null, RoleTable.Role.RIFLEMAN)
	_check("T-M2：开局主线是占领（还有非我方节点）",
			String(quests.main_quest().get("id", "")), "T-M1")
	# 模拟「0 号被我方拿下」：T-M1 正指向 0 号，把它变蓝 → update 判完成 → 主线转防守
	z0.state = CaptureZone.State.BLUE
	quests.update(0.0)
	_check("T-M2：拿下节点后主线转入防守",
			String(quests.main_quest().get("id", "")), "T-M2")
	_check_true("T-M2：防守目标就是刚拿下的节点", quests.main_quest().get("zone") == z0)
	_check("T-M2：拿下的那一步计了一次完成", quests.completed_count, 1)
	# 守满时限 → 达成 → 主线回到进攻（下一个非我方节点＝1 号）
	var defend: Dictionary = quests.main_quest()
	quests.update(float(defend["time_limit"]) + 1.0)
	_check("T-M2：守满时限 → 完成计数 +1", quests.completed_count, 2)
	_check("T-M2：守满之后主线回到进攻",
			String(quests.main_quest().get("id", "")), "T-M1")
	_check_true("T-M2：下一个目标是 1 号节点", quests.main_quest().get("zone") == z1)
	# 失守路径：1 号被翻红 → 防守失败 → 主线回到「夺回该节点」
	z1.state = CaptureZone.State.BLUE
	quests.update(0.0)
	_check("T-M2：再拿下一个节点 → 又转入防守",
			String(quests.main_quest().get("id", "")), "T-M2")
	_check("T-M2：这一步再计一次完成", quests.completed_count, 3)
	z1.state = CaptureZone.State.RED
	quests.update(0.0)
	_check("T-M2：节点被翻红 → 防守失败（不再计完成）", quests.completed_count, 3)
	_check("T-M2：失守后主线回到「夺回该节点」",
			String(quests.main_quest().get("id", "")), "T-M1")
	_check_true("T-M2：夺回目标就是丢掉的节点", quests.main_quest().get("zone") == z1)
	z0.free()
	z1.free()
	quests.free()
