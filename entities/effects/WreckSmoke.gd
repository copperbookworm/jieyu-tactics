extends Node2D

## 12.7.2 毁伤表现：残骸持续冒烟（对应 8.2.6 的 K-kill「爆炸 → 烧毁残骸 + 持续冒烟」）
##
## 第一版没有粒子资源 / 序列帧，所以用程序绘制的烟团（与 BlobShadow / ImpactFx 同一条路子）：
## VEHICLE_SMOKE_PUFFS 个烟团各有一个相位，相位循环推进 ⇒ 上升 / 扩散 / 变淡都由相位驱动，
## 看起来是「持续冒烟」而不是一次性爆炸。
## 确定性：烟团的横向漂移按序号固化成常量，不用 randf（单测与录像可复现）。
##
## 刻意不写 class_name：引用方 preload（见 Cover.gd 头部说明）

var radius := GameConfig.VEHICLE_SMOKE_RADIUS
var emitting := true

var _phases := PackedFloat32Array()
var _drifts := PackedFloat32Array()


func setup(radius_m: float = -1.0) -> void:
	if radius_m > 0.0:
		radius = radius_m
	var count := GameConfig.VEHICLE_SMOKE_PUFFS
	_phases = PackedFloat32Array()
	_drifts = PackedFloat32Array()
	for i in count:
		_phases.append(float(i) / float(count))
		_drifts.append((float(i) - float(count - 1) * 0.5) * 0.6)
	queue_redraw()


## 推进一帧（抽出来是为了让测试能不进场景树地驱动它）
func tick(delta: float) -> void:
	if not emitting or _phases.is_empty():
		return
	for i in _phases.size():
		_phases[i] = fposmod(_phases[i] + delta / GameConfig.VEHICLE_SMOKE_LIFETIME, 1.0)
	queue_redraw()


func puff_count() -> int:
	return _phases.size()


func puff_phase(index: int) -> float:
	if index < 0 or index >= _phases.size():
		return 0.0
	return _phases[index]


func stop() -> void:
	emitting = false
	queue_redraw()


func _process(delta: float) -> void:
	tick(delta)


func _draw() -> void:
	for i in _phases.size():
		var t := _phases[i]
		var r := radius * (0.35 + 0.65 * t)
		# 俯视 2D 没有高度：用「向外扩散 + 变淡」表达上升
		var center := Vector2(_drifts[i] * t * radius, -GameConfig.VEHICLE_SMOKE_RISE * t)
		draw_circle(center, r, Color(0.22, 0.21, 0.20, 0.55 * (1.0 - t)))
