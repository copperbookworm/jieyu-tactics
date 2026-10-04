extends Node2D

## 已放置的炸药（遥控起爆）。本节点只负责「在那儿 + 能画出来 + 知道自己是哪一型」——
## 爆炸结算收在 ExplosiveController.detonate() 里（一处结算，便于复用与推理）。
## 刻意不写 class_name：ExplosiveController preload 引用（与 Cover / Tracer 一致）。

const ChargeTableScript := preload("res://data/config/ChargeTable.gd")

var charge_id := ChargeTableScript.DEFAULT_CHARGE_ID


func setup(id: String, world_position: Vector2) -> void:
	charge_id = String(ChargeTableScript.get_charge(id)["id"])
	global_position = world_position
	z_index = 5
	queue_redraw()


## 程序绘制（不引美术资产）：暗色方块 + 中心红灯 + 一根短引线。
## 刻意不做闪烁动画：起爆是「再按一次」的即时动作，静态标记已经够读；省掉每帧重绘。
func _draw() -> void:
	draw_rect(Rect2(-6.0, -6.0, 12.0, 12.0), Color(0.14, 0.14, 0.16), true)
	draw_rect(Rect2(-6.0, -6.0, 12.0, 12.0), Color(0.62, 0.62, 0.68), false, 1.0)
	draw_circle(Vector2.ZERO, 2.4, Color(1.0, 0.28, 0.22))
	draw_line(Vector2(0.0, -6.0), Vector2(0.0, -11.0), Color(0.70, 0.70, 0.75), 1.0)
