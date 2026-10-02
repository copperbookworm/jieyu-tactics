extends Node2D

## 补给车（docx 4.10.11 T-S5「护送补给至前线」的实体，候选 L3）
##
## 第一版只做三件事：
##   ① 从出发点到目标点直线行驶（不做寻路——地图上没有阻挡体，先跑通链路）
##   ② 进目标半径（GameConfig.SUPPLY_ARRIVE_RADIUS）就发 arrived 信号，任务系统据此结算
##   ③ 画车身 + 一条「出发点 → 目标点」的虚线，让玩家知道要护送到哪里
## 第一版不可被击毁、也不吸引敌人火力——官方表给 T-S5 的失败条件只有「超时」。
## 刻意不写 class_name：引用方用 preload（见 Cover.gd 头部说明）

signal arrived(supply: Node2D)

var target_position := Vector2.ZERO
var speed := GameConfig.SUPPLY_SPEED
var arrived_flag := false

var _start_position := Vector2.ZERO


func setup(target: Vector2, move_speed: float = GameConfig.SUPPLY_SPEED) -> void:
	target_position = target
	speed = move_speed
	_start_position = global_position
	queue_redraw()


## 离目标还有多远（HUD / 调试用）
func distance_left() -> float:
	return global_position.distance_to(target_position)


func has_arrived() -> bool:
	return arrived_flag


func _process(delta: float) -> void:
	if arrived_flag:
		return
	var to_target := target_position - global_position
	var left := to_target.length()
	if left <= GameConfig.SUPPLY_ARRIVE_RADIUS:
		arrived_flag = true
		arrived.emit(self)
		queue_redraw()
		return
	global_position += to_target / left * speed * delta
	queue_redraw()


func _draw() -> void:
	# 路线：从出发点到目标点的虚线（每 12 m 一段），抵达后整条变绿
	var route_color := Color(0.55, 0.85, 0.55, 0.55) if arrived_flag \
			else Color(0.85, 0.80, 0.45, 0.45)
	var span := target_position - _start_position
	var length := span.length()
	if length > 1.0:
		var direction := span / length
		var step := 0.0
		while step < length:
			var from := _start_position + direction * step
			var to := _start_position + direction * minf(step + 6.0, length)
			draw_line(from, to, route_color, 1.5)
			step += 12.0
	# 目标圈（到点提示，半径即抵达判定）
	if not arrived_flag:
		draw_arc(target_position, GameConfig.SUPPLY_ARRIVE_RADIUS, 0.0, TAU, 32,
				Color(0.55, 0.85, 0.55, 0.35), 2.0)
	# 车身：军绿卡车（抵达后变亮并收掉路线）
	var body := Color(0.30, 0.42, 0.30, 0.95) if not arrived_flag \
			else Color(0.45, 0.70, 0.45, 0.95)
	var rect := Rect2(-3.0, -1.6, 6.0, 3.2)
	draw_rect(rect, body)
	draw_rect(rect, Color(0.85, 0.90, 0.80, 0.9), false, 1.5)
	# 车头白点：朝向目标
	var to_target := target_position - global_position
	if to_target.length() > 0.001:
		draw_circle(to_target.normalized() * 2.4, 0.9, Color(0.95, 0.95, 0.90, 0.95))
