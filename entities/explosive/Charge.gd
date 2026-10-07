extends Node2D

## 已放置 / 飞行中的炸药（遥控起爆）。本节点只负责「在那儿 / 在飞 + 能画出来 + 知道自己是哪一型」——
## 爆炸结算收在 ExplosiveController.detonate() 里（一处结算，便于复用与推理）。
##
## 时间只有**一个时钟**：本节点**不**自己 _process —— 读条与飞行都由 ExplosiveController.tick(delta) 推进。
## 好处：全模块只有一个时间入口，集成冒烟也只用 tick 一个口子就能把抛物线推到底。
##
## 2026-10-07 第八十三版（docx ㊻）：新增**投掷**态 —— 抛物线飞行 + 落点预警圈（红圈 + 十字）。
## 刻意不写 class_name：ExplosiveController preload 引用（与 Cover / Tracer 一致）。

const ChargeTableScript := preload("res://data/config/ChargeTable.gd")
const ExplosiveSystemScript := preload("res://systems/explosives/ExplosiveSystem.gd")

var charge_id := ChargeTableScript.DEFAULT_CHARGE_ID

# 投掷态（㊻）：起点 / 落点 / 总飞行时间 / 已飞时间
var _flying := false
var _from := Vector2.ZERO
var _to := Vector2.ZERO
var _flight_s := 0.0
var _elapsed := 0.0


## 贴放 / 落地后的静态状态
func setup(id: String, world_position: Vector2) -> void:
	charge_id = String(ChargeTableScript.get_charge(id)["id"])
	global_position = world_position
	_flying = false
	z_index = 5
	queue_redraw()


## 投掷：从 from 起飞，throw_flight_time() 秒后落在 to（落点预警在飞行中一直画着）
func launch(id: String, from: Vector2, to: Vector2) -> void:
	charge_id = String(ChargeTableScript.get_charge(id)["id"])
	_from = from
	_to = to
	_flight_s = ExplosiveSystemScript.throw_flight_time(from.distance_to(to))
	_elapsed = 0.0
	global_position = from
	_flying = true
	z_index = 5
	queue_redraw()


func is_flying() -> bool:
	return _flying


## 落点：飞行中 = 预警圈的位置；落地后 = 自己脚下
func landing_point() -> Vector2:
	return _to if _flying else global_position


## 由 ExplosiveController.tick() 驱动；飞完自己落地（位置精确落在 _to，不留截断误差）
func tick(delta: float) -> void:
	if not _flying:
		return
	_elapsed += delta
	if _elapsed >= _flight_s:
		_elapsed = _flight_s
		_flying = false
		global_position = _to
	else:
		global_position = ExplosiveSystemScript.throw_position_at(_from, _to, _elapsed, _flight_s)
	queue_redraw()


## 程序绘制（不引美术资产）：暗色方块 + 中心红灯 + 一根短引线。
## 飞行中额外画**落点预警圈**（docx ㊻）：红圈 + 十字标在落点上；方块本身按抛物线抬升。
## 刻意不做闪烁动画：起爆是「再按一次」的即时动作，静态标记已经够读；省掉每帧重绘。
func _draw() -> void:
	if _flying:
		var offset := _to - global_position
		draw_arc(offset, 14.0, 0.0, TAU, 28, Color(1.0, 0.35, 0.25, 0.85), 1.5)
		draw_line(offset + Vector2(-7.0, 0.0), offset + Vector2(7.0, 0.0),
				Color(1.0, 0.35, 0.25, 0.70), 1.0)
		draw_line(offset + Vector2(0.0, -7.0), offset + Vector2(0.0, 7.0),
				Color(1.0, 0.35, 0.25, 0.70), 1.0)
		var lift := ExplosiveSystemScript.throw_lift_px(
				_from.distance_to(_to), _elapsed, _flight_s)
		_draw_charge(Vector2(0.0, -lift))
		return
	_draw_charge(Vector2.ZERO)


func _draw_charge(at: Vector2) -> void:
	draw_rect(Rect2(at + Vector2(-6.0, -6.0), Vector2(12.0, 12.0)), Color(0.14, 0.14, 0.16), true)
	draw_rect(Rect2(at + Vector2(-6.0, -6.0), Vector2(12.0, 12.0)), Color(0.62, 0.62, 0.68), false, 1.0)
	draw_circle(at, 2.4, Color(1.0, 0.28, 0.22))
	draw_line(at + Vector2(0.0, -6.0), at + Vector2(0.0, -11.0), Color(0.70, 0.70, 0.75), 1.0)
