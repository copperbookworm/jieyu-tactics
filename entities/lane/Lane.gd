extends Node2D

## 侧翼通路（docx 4.10.11 T-S6「守住侧翼通路」的几何，候选 L4）
##
## 一条直线走廊：入口（敌方来向）→ 出口（我方一侧），半宽 GameConfig.LANE_HALF_WIDTH。
## 本文件只做几何 + 画出来，不做判定流程（谁穿过、什么时候算失败在 LaneController 里）。
## 「穿过」＝沿走廊方向走到出口线之外，且横向还在走廊宽度内（从走廊里过去才算数）。
## 刻意不写 class_name：引用方 preload（见 Cover.gd 头部说明）

var entry_position := Vector2.ZERO     # 入口：敌方来向
var exit_position := Vector2.ZERO      # 出口：我方一侧
var half_width := GameConfig.LANE_HALF_WIDTH
## 任务激活时画亮一点（未激活也画淡一层，让玩家认得这条侧翼）
var active := false


func setup(entry: Vector2, exit_point: Vector2) -> void:
	entry_position = entry
	exit_position = exit_point
	add_to_group("flank_lane")
	queue_redraw()


func set_active(value: bool) -> void:
	active = value
	queue_redraw()


func length() -> float:
	return entry_position.distance_to(exit_position)


## 沿走廊方向的归一化进度：入口 0、出口 1、出口之外 > 1
func progress_along(point: Vector2) -> float:
	var span := exit_position - entry_position
	var length_sq := span.length_squared()
	if length_sq < 0.001:
		return 0.0
	return (point - entry_position).dot(span) / length_sq


## 到走廊中线的横向距离（绝对值）
func lateral_offset(point: Vector2) -> float:
	var span := exit_position - entry_position
	var span_length := span.length()
	if span_length < 0.001:
		return 0.0
	var normal := Vector2(-span.y, span.x) / span_length
	return absf((point - entry_position).dot(normal))


func is_inside(point: Vector2) -> bool:
	var progress := progress_along(point)
	return progress >= 0.0 and progress <= 1.0 and lateral_offset(point) <= half_width


## 是否已经穿过走廊（走到出口线之外，且是从走廊里过去的）
func is_crossed(point: Vector2) -> bool:
	return progress_along(point) >= 1.0 and lateral_offset(point) <= half_width


func _draw() -> void:
	var span := exit_position - entry_position
	var span_length := span.length()
	if span_length < 0.001:
		return
	var direction := span / span_length
	var normal := Vector2(-direction.y, direction.x)
	var left_entry := entry_position + normal * half_width
	var right_entry := entry_position - normal * half_width
	var left_exit := exit_position + normal * half_width
	var right_exit := exit_position - normal * half_width
	# 走廊两长边
	var edge := Color(0.95, 0.75, 0.30, 0.75) if active else Color(0.75, 0.70, 0.45, 0.35)
	draw_line(left_entry, left_exit, edge, 2.0)
	draw_line(right_entry, right_exit, edge, 2.0)
	# 入口（敌方来向）：红；出口（我方一侧）：蓝绿
	draw_line(left_entry, right_entry, Color(0.90, 0.35, 0.30, 0.85), 3.0)
	draw_line(left_exit, right_exit, Color(0.35, 0.75, 0.95, 0.85), 3.0)
	# 中线虚线：每隔 12 m 一段
	var step := 0.0
	while step < span_length:
		var from := entry_position + direction * step
		var to := entry_position + direction * minf(step + 6.0, span_length)
		draw_line(from, to, Color(0.95, 0.85, 0.55, 0.35), 1.0)
		step += 12.0
