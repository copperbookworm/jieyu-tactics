extends Node2D

## 12.7.3 枪口火光（候选 M · 第一轮）：开火瞬间闪一次的 2~3 帧闪光。
## 第一版用程序绘制的三段楔形 + 中心亮斑（没有美术资产，也没有序列帧资源）。
## 生命周期写法与 Tracer 一致：挂进场景 → 自己 _process → 到点 queue_free。
## 用法：host.add_child(fx) 之后再调 setup()（要读父节点变换）。
## 刻意不写 class_name：引用方 preload（见 Cover.gd 头部说明）。

var _elapsed := 0.0
var _direction := Vector2.RIGHT
var _length := GameConfig.MUZZLE_FLASH_LENGTH
var _width := GameConfig.MUZZLE_FLASH_WIDTH


func setup(origin: Vector2, direction: Vector2, scale: float = 1.0) -> void:
	global_position = origin
	_direction = direction.normalized() if direction.length() > 0.001 else Vector2.RIGHT
	_length = GameConfig.MUZZLE_FLASH_LENGTH * maxf(scale, 0.1)
	_width = GameConfig.MUZZLE_FLASH_WIDTH * maxf(scale, 0.1)
	queue_redraw()


## 推进一帧；返回「该销毁了吗」。抽出来是为了让测试能在不进场景树的情况下驱动它。
func tick(delta: float) -> bool:
	_elapsed += delta
	queue_redraw()
	return _elapsed >= GameConfig.MUZZLE_FLASH_LIFETIME


## 剩余寿命比例（1 → 0），画的时候用它做亮度衰减
func remaining_ratio() -> float:
	return clampf(1.0 - _elapsed / GameConfig.MUZZLE_FLASH_LIFETIME, 0.0, 1.0)


func _process(delta: float) -> void:
	if tick(delta):
		queue_free()


func _draw() -> void:
	var ratio := remaining_ratio()
	if ratio <= 0.0:
		return
	var perp := _direction.orthogonal()
	# 三段楔形：越靠外越短越暗，合起来就是一次闪光
	for i in 3:
		var shrink := 1.0 - 0.28 * float(i)
		var tip := _direction * _length * shrink * ratio
		var half := _width * (1.0 - 0.25 * float(i)) * ratio
		var base := _direction * _length * 0.22 * shrink * ratio
		draw_colored_polygon(PackedVector2Array([
				Vector2.ZERO, base + perp * half, tip, base - perp * half]),
				Color(GameConfig.MUZZLE_FLASH_COLOR, 0.55 * ratio))
	# 中心亮斑：枪口本体那一小块
	draw_circle(Vector2.ZERO, _width * 0.45 * ratio, Color(1.0, 0.95, 0.72, ratio))
