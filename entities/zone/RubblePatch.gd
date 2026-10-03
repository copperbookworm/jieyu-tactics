extends Node2D

## 废墟残痕（2026-10-03 使用者拍板「掩体破坏后留贴地残痕 + 小减速，不影响通视」）
##
## 为什么单独一个节点、而不让 Cover 自己留在场上：
##   ① Cover 一旦脱离 occluder 组就不再挡通视 / 挡子弹，但**仍然在场上**会被玩家看成障碍；
##      残痕的语义是「地上一摊东西」，与「一块掩体」在战术上完全不同，混在一起会误导。
##   ② 通视与子弹只认 occluder 组 —— 残痕不进那个组，所以「不影响通视」是结构上成立的，
##      不靠任何额外判断。
## 与泥泞 / 雪地共用「内容层区域」那一套（covers + speed_scale 的鸭子类型接口），
## 所以 Player 的移速计算**一行都不用改**：把残痕加进 player.zones 即可。
##
## 数值口径：小减速取泥泞档（0.70）——瓦砾堆比泥地更难走一档也不合适，
## 它与泥泞同类（都是「脚下不利索」），取同一个数是刻意的减法。
## 刻意不写 class_name：引用方 preload（见 Cover.gd 头部说明）

const DEFAULT_LIFETIME := 0.0   # s，<=0 = 不自动消失（残痕留到本局结束）


func _ready() -> void:
	queue_redraw()


func setup(radius_m: float, lifetime_s: float = DEFAULT_LIFETIME) -> void:
	_radius = maxf(radius_m, 0.5)
	if lifetime_s > 0.0:
		_lifetime = lifetime_s
	queue_redraw()


var _radius := 3.0
var _lifetime := DEFAULT_LIFETIME
var _age := 0.0


func covers(point: Vector2) -> bool:
	return global_position.distance_to(point) <= _radius


## 移速倍率：取泥泞档（`GameConfig.TERRAIN_MUD_SPEED_SCALE`）
func speed_scale() -> float:
	return GameConfig.TERRAIN_MUD_SPEED_SCALE


## 残痕不给隐蔽也不给遮挡
func concealment(_prone: bool) -> float:
	return 0.0


func radius() -> float:
	return _radius


func _process(delta: float) -> void:
	if _lifetime <= 0.0:
		return
	_age += delta
	if _age >= _lifetime:
		queue_free()


func _draw() -> void:
	# 贴地瓦砾：与 Cover 的残骸配色同族（灰褐），但更贴地、更碎
	draw_circle(Vector2.ZERO, _radius, Color(0.32, 0.29, 0.25, 0.45))
	draw_circle(Vector2.ZERO, _radius * 0.62, Color(0.40, 0.36, 0.30, 0.42))
	draw_arc(Vector2.ZERO, _radius, 0.0, TAU, 48, Color(0.52, 0.48, 0.42, 0.7), 1.0)
	# 几块碎料，让残痕不像一个规整的圆
	var chunks := [
		Vector2(-0.45, -0.20), Vector2(0.30, -0.42), Vector2(0.52, 0.22),
		Vector2(-0.10, 0.48), Vector2(0.05, 0.05),
	]
	for chunk in chunks:
		draw_rect(Rect2(chunk * _radius - Vector2(1.6, 1.6), Vector2(3.2, 3.2)),
				Color(0.62, 0.58, 0.50, 0.85))
