class_name QuestSystem
extends Node

## 任务系统（docx 4.10 / 4.10.10 奖励决策（确认稿）/ 4.10.11 任务模板池实例）
## 官方 8 条模板已全部落地（候选 L1~L5）：T-M1 主线占领节点（+40）、T-M2 主线守住节点（+40，守住型）、
## T-S4 侦察标记（+10）、T-S1 歼灭穿插小队（+15）、T-S3 摧毁敌方载具（+20）、T-S2 摧毁敌方 FOB（+20）、
## T-S5 护送补给至前线（+15）、T-S6 守住侧翼通路（+10，守住型）；
## 模板数据在 data/quest_templates.txt（取自官方「解域游戏任务模板表.csv」）。
## 主线在进攻/防守两个阶段之间切（候选 L5）：拿下节点 → T-M2 守住 → 守满一轮 → 再 T-M1 打下一个；
## 节点被翻红 → T-M2 失守 → 主线回到「夺回该节点」（失败不扣分）。
## AI 参谋 = 规则模板 + 权重表（4.10.10 确认：不用生成式大模型）：
##   实际权重 = 基础权重 + Σ(战局变量修正)；主线固定取 1 条；支线按权重降序取前 2 条（阈值 ≥ 15）。
## 触发与重发（4.10.11「主线下发 / 支线由战局事件触发」）：
##   · 主线：目标节点翻蓝完成 → 立刻按当前战局补发下一个非我方控制节点（T-M1 链，第三版就有这条）
##   · 支线：开局算一次，之后在「报点」「完成 / 失败」这些战局事件上重算，空出名额就补发
##   · 同一模板一局只发一次（_assigned），同时最多 2 条支线（重发时把在跑的支线也算进名额）
##   · 事件源：任务系统自己订阅（fob_enemy / 敌方载具的 wrecked 信号），实体与 Main 都不必为任务接线
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
var _captured_zones: Array = []      # 本局我方刚拿下的节点（候选 L5：防守阶段只针对它们）
var _defended_zones: Array = []      # 已经守过一轮的节点（一局只打一次防守，丢了重夺才会再有）


## 开局：登记节点、兵种，订阅战局事件源，发主线 + 支线
func start(zones: Array, marks, role: int) -> void:
	_zones = zones
	_marks = marks
	_role = role
	quests.clear()
	_assigned.clear()
	_subscribe_event_sources()
	_assign_main()
	_assign_side_quests()
	quest_list_changed.emit(quests)


## 订阅战局事件源（4.10.11「支线由战局事件触发」）：任务系统自己盯它要追踪的目标，
## 这样 Main / 各实体都不必为了任务去接线（第一版两类源：敌方 FOB 被摧毁 → T-S2、敌方载具被摧毁 → T-S3）
func _subscribe_event_sources() -> void:
	var loop := Engine.get_main_loop() as SceneTree
	if loop == null:
		return
	for node in loop.get_nodes_in_group("fob_enemy"):
		if not node.wrecked.is_connected(notify_fob_destroyed):
			node.wrecked.connect(notify_fob_destroyed)
	for node in loop.get_nodes_in_group("vehicle"):
		if bool(node.friendly) or bool(node.destroyed):
			continue
		if not node.wrecked.is_connected(notify_vehicle_destroyed):
			node.wrecked.connect(notify_vehicle_destroyed)


func _pick_capture_target() -> CaptureZone:
	for zone in _zones:
		var candidate := zone as CaptureZone
		if candidate == null or candidate.is_queued_for_deletion():
			continue
		if candidate.state != CaptureZone.State.BLUE:
			return candidate
	return null


## 主线：4.10.11「主线固定取与当前阶段角色对应的模板」——按战局在进攻/防守两个阶段之间切：
##   · 我方刚拿下、还没守过的节点 → T-M2 守住节点（拖延防守阶段，候选 L5）
##   · 其余情况（还有非我方节点）→ T-M1 占领节点（进攻阶段）
## 节点被翻红（丢了）会从「守过」名单里移除，重夺之后会再打一轮防守。
func _assign_main() -> void:
	# 防守阶段优先：手上有一个「本局刚拿下、还没守过」的蓝节点，就先把它守住
	# （只看 _captured_zones——开局本来就属于我方的节点不该让主线卡在防守上）
	for zone in _captured_zones:
		var blue_zone := zone as CaptureZone
		if blue_zone == null or blue_zone.is_queued_for_deletion():
			continue
		if blue_zone.state != CaptureZone.State.BLUE or _defended_zones.has(blue_zone):
			continue
		var defend := QuestTable.get_template("T-M2")
		if defend.is_empty():
			break
		quests.append(_build_quest(defend, blue_zone))
		_assigned.append("T-M2")
		return
	# 进攻阶段：拿下一个非我方控制的节点
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
	# 先把「正在跑的支线」算进名额：重发路径（报点 / 完成 / 失败都会调这里）不能突破上限
	var taken := 0
	for quest in quests:
		if not bool(quest["main"]):
			taken += 1
	var added := 0
	for candidate in candidates:
		if taken >= SIDE_QUEST_LIMIT:
			break
		var template: Dictionary = candidate["template"]
		quests.append(_build_quest(template, _side_target_for(template)))
		_assigned.append(String(template["id"]))
		taken += 1
		added += 1
	if added > 0:
		# 补发过就广播一次：UI 与「补给护送控制器」这类监听者才知道列表变了
		quest_list_changed.emit(quests)


## 部分支线要带一个目标地点（T-S5 护送补给的「指定节点」＝要送到哪个节点）：
## 优先取当前主线目标节点（就是前线），没有就退回第一个我方控制的节点；其它支线不需要地点，返回 null
func _side_target_for(template: Dictionary) -> Variant:
	if String(template.get("goal_kind", "")) != "escort_supply":
		return null
	var main_q: Dictionary = main_quest()
	var frontline = main_q.get("zone")
	if frontline != null:
		return frontline
	for zone in _zones:
		var capture_zone := zone as CaptureZone
		if capture_zone != null and capture_zone.state == CaptureZone.State.BLUE:
			return capture_zone
	return null


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
		"T-S3":
			# 摧毁敌方载具（官方表）：触发＝敌方载具被标记且可接近 —— 第一版闸门 =「载具存活 + 已被报点标记」，
			# 闸门不成立直接判 0（低于阈值就不发）；成立后按官方修正：敌载具活跃 +15、己方反装甲在场 +10
			# （第一版没有反装甲兵种，用精确射手近似这个位置）
			if not _enemy_vehicle_alive() or not _vehicle_marked():
				return 0.0
			weight += 15.0
			if _role == RoleTable.Role.MARKSMAN:
				weight += 10.0
		"T-S2":
			# 摧毁敌方 FOB（官方表）：触发＝敌方 FOB 被标记暴露 —— 闸门不成立判 0（不发）；
			# 成立后按官方修正「FOB 暴露 +20」。官方另一条「敌方续航 <30% +10」第一版没有续航预算系统，
			# 暂不计入（与 T-S1 的兵种修正同样处理，理由写在 QuestTable.gd 头部）
			if not _fob_exposed():
				return 0.0
			weight += 20.0
		"T-S5":
			# 护送补给（官方表）：触发＝己方节点续航不足 —— 第一版没有续航预算系统，闸门近似成
			# 「我方已控制 ≥1 个节点」（有前线才谈得上往前送补给）；官方修正「友军兵力不足 +15」
			# 同样缺这个量（场上只有玩家一个友军单位），不计入，理由写在 QuestTable.gd 头部
			if _owned_zone_count() < 1:
				return 0.0
		"T-S6":
			# 守住侧翼通路（官方表）：触发＝主线为占领且侧翼有未设防通道 —— 闸门 =「有主线任务（＝占领阶段）
			# + 场上有侧翼通路」；官方修正「攻方侧翼暴露 +10」近似成「我方控制节点 ≤1（战况吃紧）」
			if main_quest().is_empty() or not _lane_exists():
				return 0.0
			if _owned_zone_count() <= 1:
				weight += 10.0
	return weight


## 守住型目标（4.10.11）：时限到点算「达成」而不是超时失败
##   hold_lane（T-S6 守住侧翼通路）、hold_zone（T-M2 守住节点，L5 再上）
static func is_hold_goal(goal_kind: String) -> bool:
	return goal_kind == "hold_lane" or goal_kind == "hold_zone"


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


## 场上是否还有敌方载具（活着的）。走主循环取组，测试里没有场景树也不会炸（与 _alive_enemy_count 同一套写法）
func _enemy_vehicle_alive() -> bool:
	var loop := Engine.get_main_loop() as SceneTree
	if loop == null:
		return false
	for node in loop.get_nodes_in_group("vehicle"):
		if node == null:
			continue
		if not bool(node.friendly) and not bool(node.destroyed):
			return true
	return false


## 敌方载具是否已被我方报点标记（4.10.11 触发条件的前半段：只认「载具」类型且未过期的标记）
func _vehicle_marked() -> bool:
	if _marks == null:
		return false
	for mark in _marks.marks:
		if int(mark["type"]) == MarkSystem.MarkType.VEHICLE \
				and float(mark["time_left"]) > 0.0:
			return true
	return false


## 场上活着的敌方 FOB（没有就返回 null）；同样走主循环取组，测试里没有场景树也不会炸
func _enemy_fob() -> Node2D:
	var loop := Engine.get_main_loop() as SceneTree
	if loop == null:
		return null
	for node in loop.get_nodes_in_group("fob_enemy"):
		var fob := node as Node2D
		if fob != null and not bool(fob.destroyed):
			return fob
	return null


## 场上有没有侧翼通路（LaneController 建的；走主循环取组，测试里没有场景树也不会炸）
func _lane_exists() -> bool:
	var loop := Engine.get_main_loop() as SceneTree
	if loop == null:
		return false
	return not loop.get_nodes_in_group("flank_lane").is_empty()


## 敌方 FOB 是否已被报点暴露（官方触发条件「敌方 FOB 被标记暴露」）
## 判定：FOB 附近 FOB_EXPOSE_RADIUS 内有未过期的「阵地」或「补给」标记——先侦察、再打掉
## 副作用（2026-10-01 ④）：判成暴露时顺手把它记成「已侦察到」，供小地图 / 战术地图图层用
## （docx 4.11.2：敌方默认不上地图）。用无类型 var 走鸭子类型，省得给 _enemy_fob 的返回类型加接口。
func _fob_exposed() -> bool:
	var fob = _enemy_fob()
	if fob == null or _marks == null:
		return false
	for mark in _marks.marks:
		var mark_type := int(mark["type"])
		if mark_type != MarkSystem.MarkType.POSITION \
				and mark_type != MarkSystem.MarkType.SUPPLY:
			continue
		if float(mark["time_left"]) <= 0.0:
			continue
		if Vector2(mark["position"]).distance_to(fob.global_position) \
				<= GameConfig.FOB_EXPOSE_RADIUS:
			if fob.has_method("mark_revealed"):
				fob.mark_revealed()
			return true
	return false


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


## 每帧：推进占领类进度、守住型节点的失守判定、扣支线时限、判完成与失败
func update(delta: float) -> void:
	var changed := false
	var finished: Array = []
	var expired: Array = []
	var lost: Array = []
	for quest in quests:
		if float(quest["time_limit"]) > 0.0:
			quest["time_left"] = maxf(float(quest["time_left"]) - delta, 0.0)
			if float(quest["time_left"]) <= 0.0:
				# 守住型（T-S6 守住侧翼通路 / T-M2 守住节点）：拖到时限到点就是达成
				if is_hold_goal(String(quest["goal_kind"])):
					finished.append(quest)
				else:
					expired.append(quest)
				continue
		var kind := String(quest["goal_kind"])
		if kind == "hold_zone":
			# 守住节点：时限没到但节点被翻红 → 失守（官方 T-M2 失败条件「节点被翻敌方色」）
			var held = quest["zone"]
			if held != null and held.state == CaptureZone.State.RED:
				lost.append(quest)
				continue
			if held != null:
				quest["progress"] = capture_progress(held)
				changed = true
			continue
		if kind != "capture_zone":
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
	for quest in lost:
		_fail(quest)
	# 节点丢了就从两个名单里移除：重夺之后可以再打一轮防守阶段
	for zone in _zones:
		var capture_zone := zone as CaptureZone
		if capture_zone != null and capture_zone.state != CaptureZone.State.BLUE:
			_captured_zones.erase(capture_zone)
			_defended_zones.erase(capture_zone)
	if changed:
		quest_list_changed.emit(quests)


## 报点成功（Main 在 marks.add_mark 之后调用）——推进「侦察标记」类任务
## 这同时是一次战局事件：重算支线权重（「摧毁敌方载具」必须等敌方载具被标记之后才发得出来）
func notify_mark_placed(_position: Vector2) -> void:
	_advance("place_marks")
	_assign_side_quests()


## 击毁敌方载具（任务系统自己订阅了敌方载具的 wrecked 信号）——推进「摧毁载具」类任务
func notify_vehicle_destroyed(_vehicle = null) -> void:
	_advance("destroy_vehicles")


## 摧毁敌方 FOB（订阅 fob_enemy 的 wrecked 信号）——推进「摧毁 FOB」类任务
func notify_fob_destroyed(_fob = null) -> void:
	_advance("destroy_fob")


## 补给车抵达指定节点（由 scenes/gameplay/SupplyController.gd 回告）——推进「护送补给」类任务
func notify_supply_arrived() -> void:
	_advance("escort_supply")


## 敌人穿过侧翼通路（由 scenes/gameplay/LaneController.gd 检测并回告）——守住型任务失败
func notify_lane_breached() -> void:
	_fail_kind("hold_lane")


## 穿插小队被清光（LaneController 回告）——守住型任务提前达成，不必干等到时限
func notify_lane_secured() -> void:
	_complete_kind("hold_lane")


## 按机制键一次性结算（守住型任务用：一局只会有一条同类任务）
func _fail_kind(goal_kind: String) -> void:
	for quest in quests.duplicate():
		if String(quest["goal_kind"]) == goal_kind:
			_fail(quest)


func _complete_kind(goal_kind: String) -> void:
	for quest in quests.duplicate():
		if String(quest["goal_kind"]) == goal_kind:
			_complete(quest)


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
	# 守住节点守满一轮：记进「守过」名单，之后这个节点不再重复打防守阶段（丢了重夺才会再有）
	if String(quest["goal_kind"]) == "hold_zone" and quest["zone"] != null:
		_defended_zones.append(quest["zone"])
	# 拿下节点：记进「本局刚拿下」名单，下一条主线就会转成防守它（候选 L5）
	if String(quest["goal_kind"]) == "capture_zone" and quest["zone"] != null:
		_captured_zones.append(quest["zone"])
	# 主线链（docx 4.10 / 第三版口径）：按当前战局补发下一条主线（守过 → 进攻下一个节点）
	if bool(quest["main"]):
		_assign_main()
	# 支线空出名额 → 补发（4.10.11「支线由战局事件触发」）
	_assign_side_quests()
	quest_list_changed.emit(quests)


func _fail(quest: Dictionary) -> void:
	quests.erase(quest)
	# 4.10.10：支线失败或放弃不扣分，只损失该支线的奖励机会
	quest_failed.emit(quest)
	# 主线失败（T-M2 节点被翻红 / T-M1 超时）：立刻按战局重发——丢了就回到「夺回该节点」
	if bool(quest["main"]):
		_assign_main()
	_assign_side_quests()
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
