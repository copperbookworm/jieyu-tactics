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


func setup(main_node, attacker_count: int = -1) -> void:
	main = main_node
	var count := attacker_count if attacker_count > 0 else _count_attackers()
	budget = GameConfig.RESPAWN_BUDGET_MULTIPLIER * count
	enemy_budget = GameConfig.RESPAWN_BUDGET_MULTIPLIER * count
	if EventBus != null and EventBus.has_signal("player_died"):
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
		var decided := decide_at_timeout(_our, _their)
		if decided == "":
			phase = Phase.OVERTIME
			time_left = GameConfig.OVERTIME_DURATION
			hold_diff = _our - _their
			_hint("超时仍未分胜负 —— 进入加时 3 分钟（突然死亡）")
			_refresh()
			return
		_finish(decided, "时间到：占领数 %d : %d" % [_our, _their])
		return
	_finish("draw", "加时结束仍未分胜负")


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
		if main != null and main.player != null:
			main.player.revive()
		_hint("阵亡 —— 重生预算 -1（剩 %d）" % budget)
		_refresh()
		return
	_finish("enemy", "重生预算耗尽")


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
