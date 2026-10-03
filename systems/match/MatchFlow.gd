extends Node

## 战局流程（docx 5.7 胜负判定决策 · 确认稿）—— 候选 Q（2026-10-02）
## ① 单局 15 分钟倒计时（MATCH_DURATION）→ 时间到按占领数分胜负；持平 → 进加时
## ② 加时 3 分钟（OVERTIME_DURATION）**突然死亡**：占领差一旦变化，领先方立刻胜
## ③ 加时结束仍持平 → 平局（docx：平局信誉分不变）
## ④ 重生预算 ＝ 进攻方人数 × RESPAWN_BUDGET_MULTIPLIER：每次阵亡扣 1 并复活，
##    扣到 0 才判负（docx 5.2：重生预算耗尽 ＝ 攻防失败，与任务结算解耦）
##
## 为什么单开一个模块：Main.gd 已经 398/400，所以本模块 _process 自走 + 自己订阅 EventBus，
## Main 只负责「建它 + 把 player_died 交给它」。判定逻辑尽量做成静态纯函数，方便单测。
## 刻意不写 class_name：引用方 preload（见 Cover.gd 头部说明）

enum Phase { PLAYING, OVERTIME, FINISHED }

var main = null
var phase: int = Phase.PLAYING
var time_left := GameConfig.MATCH_DURATION
var budget := 0                    ## 我方重生预算
var enemy_budget := 0              ## 敌方（第一版与对称，只为 HUD 显示）
var outcome := ""                  ## "" 未结束 / "player" / "enemy" / "draw"
var reason := ""
var hold_diff := 0                 ## 加时的基准占领差（突然死亡要比它）

var _our := 0
var _their := 0

## 模式规则（由 MatchHost 按模式表灌进来；不灌就保持 5.7 的占领口径）
var win_rule := "occupy"                             ## "occupy" 占领数 / "objective" 战术目标
var base_duration := GameConfig.MATCH_DURATION
var overtime_duration := GameConfig.OVERTIME_DURATION
var _objective := ""


func setup(main_node, attacker_count: int = -1) -> void:
	main = main_node
	var count := attacker_count if attacker_count > 0 else _count_attackers()
	budget = GameConfig.RESPAWN_BUDGET_MULTIPLIER * count
	enemy_budget = GameConfig.RESPAWN_BUDGET_MULTIPLIER * count
	# 幂等：Main 不再重复接这一条（重复接同一个 callable 会被 Godot 判为错误），
	# 但 setup 万一被调两次（场景重载）也不能炸。
	if EventBus != null and EventBus.has_signal("player_died") \
			and not EventBus.player_died.is_connected(on_player_died):
		EventBus.player_died.connect(on_player_died)
	_sync_holds()
	_refresh()


## 进攻方人数：玩家自己 +1，再加场上的友军（第一版没有友军就是 1）
func _count_attackers() -> int:
	var tree := get_tree()
	if tree == null:
		return 1
	return 1 + tree.get_nodes_in_group("friendly").size()


## 超时判定（纯函数）：我方领先 → player、落后 → enemy、持平 → ""（表示要进加时）
static func decide_at_timeout(ours: int, theirs: int) -> String:
	if ours > theirs:
		return "player"
	if theirs > ours:
		return "enemy"
	return ""


## 突然死亡判定（纯函数）：占领差与基准相同 → ""（继续）；变了 → 领先方胜
static func sudden_death_winner(baseline: int, ours: int, theirs: int) -> String:
	var diff := ours - theirs
	if diff == baseline:
		return ""
	return "player" if diff > baseline else "enemy"


## 剩余时间文案（纯函数）：mm:ss，加时加前缀
static func time_text(seconds: float, overtime: bool = false) -> String:
	var total := int(ceilf(maxf(seconds, 0.0)))
	return "%s%02d:%02d" % ["加时 " if overtime else "", total / 60, total % 60]


func _process(delta: float) -> void:
	if phase == Phase.FINISHED:
		return
	time_left = maxf(time_left - delta, 0.0)
	if time_left <= 0.0:
		_on_clock_zero()
	_sync_holds()
	_refresh()


func _on_clock_zero() -> void:
	if phase == Phase.PLAYING:
		# 22.6 PVEVP：只看战术目标，无平局、无加时 —— 到点没达成就是败
		if win_rule == "objective":
			_finish("enemy", "时间到：%s未达成" % objective_text())
			return
		var decided := decide_at_timeout(_our, _their)
		if decided == "":
			if overtime_duration <= 0.0:
				_finish("draw", "时间到：占领数持平（本模式无加时）")
				return
			phase = Phase.OVERTIME
			time_left = overtime_duration
			hold_diff = _our - _their
			_hint("超时仍未分胜负 —— 进入加时 %d 分钟（突然死亡）"
					% int(round(overtime_duration / 60.0)))
			_refresh()
			return
		_finish(decided, "时间到：占领数 %d : %d" % [_our, _their])
		return
	_finish("draw", "加时结束仍未分胜负")


## 模式规则入口（外壳在 Main 装好之后调用）。objective 模式额外订阅主线任务完成。
func apply_mode(rule: String, duration_s: float, overtime_s: float, objective: String) -> void:
	win_rule = rule
	base_duration = maxf(duration_s, 1.0)
	overtime_duration = maxf(overtime_s, 0.0)
	_objective = objective
	time_left = base_duration
	if phase == Phase.OVERTIME:
		phase = Phase.PLAYING
	if win_rule == "objective" and main != null and main.quests != null \
			and not main.quests.quest_completed.is_connected(_on_objective_quest):
		main.quests.quest_completed.connect(_on_objective_quest)
	_refresh()


## 22.6 PVEVP：主线任务完成 = 战术目标达成
func _on_objective_quest(quest_data: Dictionary) -> void:
	if win_rule != "objective" or phase == Phase.FINISHED:
		return
	if not bool(quest_data.get("main", false)):
		return
	_finish("player", "战术目标达成：%s" % String(quest_data.get("name", "主线任务")))


func objective_text() -> String:
	return _objective if _objective != "" else "完成主线任务"


func clock_text() -> String:
	return time_text(time_left, phase == Phase.OVERTIME)


func holds_text() -> String:
	return "我方 %d : 敌方 %d" % [_our, _their]


func _sync_holds() -> void:
	if main == null or main.capture_zones == null:
		return
	_our = 0
	_their = 0
	for zone in main.capture_zones:
		if zone.state == CaptureZone.State.BLUE:
			_our += 1
		elif zone.state == CaptureZone.State.RED:
			_their += 1
	if phase == Phase.OVERTIME:
		var winner := sudden_death_winner(hold_diff, _our, _their)
		if winner != "":
			_finish(winner, "加时突然死亡：占领数变化到 %d : %d" % [_our, _their])


## EventBus.player_died 的落点（Main 转交给本模块）：扣预算 → 复活 或 判负
func on_player_died() -> void:
	if phase == Phase.FINISHED:
		return
	budget -= 1
	if budget > 0:
		_respawn_player()
		_hint("阵亡 —— 已重生（重生预算剩 %d）：满血 + 回出生点" % budget)
		_refresh()
		return
	_finish("enemy", "重生预算耗尽")


## 重生：先下车（人已阵亡却还挂在座位上的话，Vehicle._carry_occupants() 会把坐标又拽回车体），
## 再满血回出生点，最后把相机中心拉回来（否则会从倒地处慢慢飘过去）。
func _respawn_player() -> void:
	if main == null:
		return
	if main.vehicles != null and main.vehicles.vehicle != null \
			and main.vehicles.vehicle.is_occupied():
		main.vehicles.vehicle.exit_vehicle()
	if main.player == null:
		return
	# 落点：出生点 + 我方已占领的节点（5.2 的重生语义 = 回己方控制区，不是死在原地，也不是固定出生点）
	var candidates: Array = []
	if main.player.respawn_point != Vector2.ZERO:
		candidates.append(main.player.respawn_point)
	if main.capture_zones != null:
		for zone in main.capture_zones:
			if zone.state == CaptureZone.State.BLUE:
				candidates.append(zone.global_position)
	var enemy_positions: Array = []
	var tree := get_tree()
	if tree != null:
		for e in tree.get_nodes_in_group("enemy"):
			enemy_positions.append(e.global_position)
	var point: Vector2 = main.player.respawn_point
	if not candidates.is_empty():
		point = pick_respawn_point(candidates, enemy_positions)
	var nearest := nearest_enemy_distance(point, enemy_positions)
	if nearest < GameConfig.RESPAWN_SAFE_DISTANCE:
		_hint("重生落点附近有敌人（最近 %.0f m）—— 小心" % nearest)
	main.player.respawn(point)
	if main.camera_controller != null:
		main.camera_controller.crosshair_world = point


## 选重生点（纯函数，测试直接调）：候选点里挑「离最近敌人最远」的那个。
## 候选 = 出生点 + 我方已占领的节点。若所有候选都贴着敌人，也返回其中最好的一个
## （调用方负责提示；不强行改落点，因为「哪里能重生」本身是关卡设计问题）。
static func pick_respawn_point(candidates: Array, enemy_positions: Array) -> Vector2:
	if candidates.is_empty():
		return Vector2.ZERO
	if enemy_positions.is_empty():
		return candidates[0]
	var best: Vector2 = candidates[0]
	var best_distance := -1.0
	for c in candidates:
		var d := nearest_enemy_distance(c, enemy_positions)
		if d > best_distance:
			best_distance = d
			best = c
	return best


## 某个点到最近敌人的距离（场上没敌人时返回 INF）
static func nearest_enemy_distance(point: Vector2, enemy_positions: Array) -> float:
	var nearest := INF
	for p in enemy_positions:
		nearest = minf(nearest, point.distance_to(p))
	return nearest


func _finish(who: String, why: String) -> void:
	if phase == Phase.FINISHED:
		return
	phase = Phase.FINISHED
	outcome = who
	reason = why
	_refresh()
	if main == null:
		return
	if who == "player":
		main._on_victory()
	elif who == "enemy":
		main._on_defeat(why)
	else:
		# 平局不能走 _on_defeat：那会把结局说成 enemy。这里直接落 Main 的结束闸门 + 文案，
		# 并广播 match_finished("draw")，让音频 / 任务按「平局」处理（docx：平局信誉分不变）。
		main._defeat = true
		if main.hud != null:
			main.hud.show_defeat("平局：%s（信誉分不变）" % why)
		if EventBus != null and EventBus.has_signal("match_finished"):
			EventBus.match_finished.emit("draw")


func _hint(text: String) -> void:
	if main != null and main.hud != null:
		main.hud.show_hint(text)


func _refresh() -> void:
	if main == null or main.hud == null:
		return
	main.hud.set_match_status("%s ｜ 重生预算 %d" % [
			time_text(time_left, phase == Phase.OVERTIME), budget],
			phase == Phase.OVERTIME or time_left <= 60.0)
