class_name QuestSystem
extends Node

## 任务系统（docx 4.10 / 4.10.10 奖励决策（确认稿）/ 4.10.11 任务模板池实例）
## 第一版落地三条模板：T-M1 主线占领节点、T-S4 侦察标记（+10）、T-S1 歼灭穿插小队（+15）；
## 模板数据在 data/quest_templates.txt（取自官方「解域游戏任务模板表.csv」，其余 5 条暂不可发的
## 理由写在 QuestTable.gd 头部）。
## AI 参谋 = 规则模板 + 权重表（4.10.10 确认：不用生成式大模型）：
##   实际权重 = 基础权重 + Σ(战局变量修正)；主线固定取 1 条；支线按权重降序取前 2 条（阈值 ≥ 15）。
## 红线：主线不可拒绝；支线可放弃/超时失败，**不扣分**，只损失奖励机会。

signal quest_list_changed(quests: Array)
signal quest_completed(quest: Dictionary)
signal quest_failed(quest: Dictionary)

## 任务模板表用 preload（QuestTable.gd 刻意不写 class_name，见其文件头说明）
const QuestTable := preload("res://systems/quest/QuestTable.gd")

const SIDE_QUEST_LIMIT := 2          # 4.10.11：支线最多同时 2 条
const SIDE_WEIGHT_THRESHOLD := 15.0  # 4.10.11：权重低于它不发支线

var quests: Array = []               # 进行中的任务（1 主线 + ≤2 支线）
var completed_count := 0

var _zones: Array = []
var _marks = null                    # MarkSystem（第一版权重表用不到，留作后续接口）
var _role := 0
var _assigned: Array = []            # 已发过的模板 id（第一版不重复发同一条）


## 开局：登记节点、兵种，发主线 + 支线
func start(zones: Array, marks, role: int) -> void:
	_zones = zones
	_marks = marks
	_role = role
	quests.clear()
	_assigned.clear()
	_assign_main()
	_assign_side_quests()
	quest_list_changed.emit(quests)


func _pick_capture_target() -> CaptureZone:
	for zone in _zones:
		var candidate := zone as CaptureZone
		if candidate == null or candidate.is_queued_for_deletion():
			continue
		if candidate.state != CaptureZone.State.BLUE:
			return candidate
	return null


## 主线：4.10.11「主线固定取与当前阶段角色对应的模板」——第一版只有进攻阶段，固定 T-M1
func _assign_main() -> void:
	var target := _pick_capture_target()
	if target == null:
		return
	var template := QuestTable.get_template("T-M1")
	if template.is_empty():
		return
	quests.append(_build_quest(template, target))
	_assigned.append("T-M1")


## 支线：对「触发条件成立」的模板算权重，降序取前 2 条（4.10.11 的流程）
func _assign_side_quests() -> void:
	var candidates: Array = []
	for id in QuestTable.ids():
		var template := QuestTable.get_template(id)
		if template.is_empty() or QuestTable.is_main(template) or _assigned.has(id):
			continue
		var weight := _weight_of(template)
		if weight < SIDE_WEIGHT_THRESHOLD:
			continue
		candidates.append({"weight": weight, "template": template})
	candidates.sort_custom(_sort_by_weight)
	var taken := 0
	for candidate in candidates:
		if taken >= SIDE_QUEST_LIMIT:
			break
		var template: Dictionary = candidate["template"]
		quests.append(_build_quest(template, null))
		_assigned.append(String(template["id"]))
		taken += 1


static func _sort_by_weight(a: Dictionary, b: Dictionary) -> bool:
	return float(a["weight"]) > float(b["weight"])


## 权重表（可解释、可调参）：第一版只用三个战局变量——我方控制节点数、场上敌人数、玩家兵种
func _weight_of(template: Dictionary) -> float:
	var weight := QuestTable.number(template, "base_weight", 0.0)
	match String(template["id"]):
		"T-S4":
			# 侦察标记：我方节点越少（战况越吃紧）越该去侦察；玩家是侦察兵再加码（官方表 +15）
			if _owned_zone_count() <= 1:
				weight += 10.0
			if _role == RoleTable.Role.SCOUT:
				weight += 15.0
		"T-S1":
			# 歼灭：场上敌人多才值得发（官方表：敌步兵密度高 +5）
			if _alive_enemy_count() >= 2:
				weight += 10.0
	return weight


func weight_of_template_id(id: String) -> float:
	return _weight_of(QuestTable.get_template(id))


func _owned_zone_count() -> int:
	var count := 0
	for zone in _zones:
		var capture_zone := zone as CaptureZone
		if capture_zone != null and capture_zone.state == CaptureZone.State.BLUE:
			count += 1
	return count


func _alive_enemy_count() -> int:
	var loop := Engine.get_main_loop() as SceneTree
	if loop == null:
		return 0
	var count := 0
	for node in loop.get_nodes_in_group("enemy"):
		var enemy = node
		if enemy != null and bool(enemy.alive):
			count += 1
	return count


func _build_quest(template: Dictionary, zone) -> Dictionary:
	var goal_kind := String(template.get("goal_kind", "place_marks"))
	var quest := {
		"id": String(template["id"]),
		"type": String(template.get("type", "")),
		"name": String(template.get("name", "")),
		"main": QuestTable.is_main(template),
		"goal_kind": goal_kind,
		"goal_count": int(QuestTable.number(template, "goal_count", 1.0)),
		"progress": 0.0,
		"reward": int(QuestTable.number(template, "reward", 0.0)),
		"time_limit": QuestTable.number(template, "time_limit", 0.0),
		"time_left": QuestTable.number(template, "time_limit", 0.0),
		"smeac": QuestTable.smeac(template),
		"zone": zone,
	}
	if zone != null:
		quest["progress"] = capture_progress(zone)
	return quest


func _process(delta: float) -> void:
	update(delta)


## 每帧：推进占领类进度、扣支线时限、判完成与失败
func update(delta: float) -> void:
	var changed := false
	var finished: Array = []
	var expired: Array = []
	for quest in quests:
		if float(quest["time_limit"]) > 0.0:
			quest["time_left"] = maxf(float(quest["time_left"]) - delta, 0.0)
			if float(quest["time_left"]) <= 0.0:
				expired.append(quest)
				continue
		if String(quest["goal_kind"]) != "capture_zone":
			continue
		var zone = quest["zone"]
		if zone == null:
			continue
		var progress := capture_progress(zone)
		if not is_equal_approx(progress, float(quest["progress"])):
			quest["progress"] = progress
			changed = true
		if zone.state == CaptureZone.State.BLUE:
			finished.append(quest)
	for quest in finished:
		_complete(quest)
	for quest in expired:
		_fail(quest)
	if changed:
		quest_list_changed.emit(quests)


## 报点成功（Main 在 marks.add_mark 之后调用）——推进「侦察标记」类任务
func notify_mark_placed(_position: Vector2) -> void:
	_advance("place_marks")


## 击倒敌人（Main 在 enemy_killed 信号里调用）——推进「歼灭」类任务
func notify_enemy_killed() -> void:
	_advance("kill_enemies")


func _advance(goal_kind: String) -> void:
	var changed := false
	var finished: Array = []
	for quest in quests:
		if String(quest["goal_kind"]) != goal_kind:
			continue
		quest["progress"] = minf(float(quest["progress"]) + 1.0, float(quest["goal_count"]))
		changed = true
		if float(quest["progress"]) >= float(quest["goal_count"]):
			finished.append(quest)
	for quest in finished:
		_complete(quest)
	if changed:
		quest_list_changed.emit(quests)


func _complete(quest: Dictionary) -> void:
	quests.erase(quest)
	completed_count += 1
	# 先发完成信号（Main 在这里记账），再换任务列表
	quest_completed.emit(quest)
	quest_list_changed.emit(quests)


func _fail(quest: Dictionary) -> void:
	quests.erase(quest)
	# 4.10.10：支线失败或放弃不扣分，只损失该支线的奖励机会
	quest_failed.emit(quest)
	quest_list_changed.emit(quests)


## 主线任务（UI 高亮用）；没有返回空字典
func main_quest() -> Dictionary:
	for quest in quests:
		if bool(quest["main"]):
			return quest
	return {}


## 净进度 → 任务进度 0..1（-1 全敌；+1 全我）
static func capture_progress(zone: CaptureZone) -> float:
	return clampf((zone.progress + 1.0) * 0.5, 0.0, 1.0)
