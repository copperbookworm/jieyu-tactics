class_name CaptureZone
extends Node2D

## 白旗点占领区（核心占领区，docx 4.2 / 12.8.4：半径 15 m）
## 净进度模型：progress ∈ [-1, 1]，正=我方、负=敌方
##   +1 → BLUE（我方控制）；-1 → RED（敌方控制）；中间 = 白旗（争夺/过渡）
## 争夺规则（docx 4.2「空间占领 + 生存能力 + 持续性」）：
##   只有我方在区内 → 进度上升；只有敌方在区内 → 进度下降
##   双方同在 → 对冲，进度不动（白旗 = 双方同时存在有效兵力）
##   没人且在争夺中 → 缓慢回退到 0；已占满（BLUE/RED）→ 保持，不因离开而丢失

enum State { NEUTRAL, BLUE, RED }

@export var radius: float = GameConfig.CAPTURE_ZONE_RADIUS
@export var hold_time: float = GameConfig.FLAG_HOLD_TIME

var state: State = State.NEUTRAL
var progress := 0.0  # -1..1

## 区内兵力（供 HUD/调试显示「为什么进度不动」——双方同在＝对冲，见 docx 4.2）
var player_inside := false
var enemy_inside := false
## 敌方能否在这个点推进占领进度。默认 true（单节点场景 / 测试不受影响）；
## 对局里由 WorldSetup 按「分批推进」把非进攻节点设成 false。见 _process 里的说明。
var enemy_capture_enabled := true

var _player: Node2D = null


func _ready() -> void:
	add_to_group("capture_zone")


func setup(player: Node2D) -> void:
	_player = player


func is_inside(point: Vector2) -> bool:
	return global_position.distance_to(point) <= radius


func _process(delta: float) -> void:
	if _player == null:
		return
	player_inside = is_inside(_player.global_position)
	enemy_inside = _is_enemy_inside()
	# 速率按「完整翻转（-1 → +1）＝ hold_time」计：首占 15 s、反夺 30 s。
	# 原实现是半个行程 = hold_time，反夺要 60 s——真机上根本打不回来。
	var rate := delta * 2.0 / hold_time

	if player_inside and not enemy_inside:
		progress = minf(progress + rate, 1.0)
	# 分批推进（2026-10-07 第八十九版 · 使用者选择题 A）：敌方只在**被指派**的节点上推进度。
	# 为什么要在这一层卡：光把敌人部署到圈外没用 —— 他们的战斗 AI 会为了打我方进圈者而自己走回圈里，
	# 于是好几个点又同时翻红（真机实测：部署改成防御环之后依然 ~50 s 全丢）。
	# 注意只卡**进度**：敌人照样在圈内交火、照样算「敌方在区内」（HUD 与对冲口径不变）。
	elif enemy_inside and not player_inside and enemy_capture_enabled:
		progress = maxf(progress - rate, -1.0)
	elif not player_inside and not enemy_inside and state == State.NEUTRAL:
		progress = move_toward(progress, 0.0, rate)
	# 双方同在：对冲，progress 不动
	_update_state()
	queue_redraw()


func _is_enemy_inside() -> bool:
	if not is_inside_tree():
		return false
	for enemy in get_tree().get_nodes_in_group("enemy"):
		var node := enemy as Node2D
		if node == null or node.is_queued_for_deletion():
			continue
		if is_inside(node.global_position):
			return true
	return false


func _update_state() -> void:
	var new_state := State.NEUTRAL
	# 容差 + 吸附：浮点累加可能停在 0.9999…，永远到不了精确 1.0，
	# 导致「保持 30s 应该翻蓝却翻不了」。接近 ±1 就吸附到精确值。
	if progress >= 1.0 - 0.001:
		progress = 1.0
		new_state = State.BLUE
	elif progress <= -1.0 + 0.001:
		progress = -1.0
		new_state = State.RED
	if new_state != state:
		state = new_state
		# @tool 测试脚本（EditorScript）里 autoload 信号可能未注册，
		# 用 has_signal + 字符串 emit 防御，避免运行时访问失败。
		if EventBus != null and EventBus.has_signal("flag_state_changed"):
			EventBus.emit_signal("flag_state_changed", name, state)


func _draw() -> void:
	var fill_color := Color(0.5, 0.5, 0.5, 0.35)
	if state == State.BLUE:
		fill_color = Color(0.25, 0.5, 0.9, 0.45)
	elif state == State.RED:
		fill_color = Color(0.85, 0.25, 0.2, 0.45)
	elif not is_zero_approx(progress):
		fill_color = Color(0.95, 0.95, 0.95, 0.4)
	draw_circle(Vector2.ZERO, radius, fill_color)
	draw_arc(Vector2.ZERO, radius, 0.0, TAU, 48, Color(1.0, 1.0, 1.0, 0.35), 2.0)
	# 进度弧：从顶部按 |progress| 展开（谁占更多看弧长）
	if state == State.NEUTRAL and not is_zero_approx(progress):
		draw_arc(Vector2.ZERO, radius * 0.7, -PI * 0.5, -PI * 0.5 + TAU * absf(progress),
				48, Color(1.0, 1.0, 1.0, 0.85), 4.0)
