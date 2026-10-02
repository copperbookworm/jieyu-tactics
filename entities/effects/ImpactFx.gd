extends Node2D

## 12.7.4 命中特效（候选 M · 第一轮）：火花 + 扩散环，快速淡出。
## 第一版程序绘制（没有粒子资源 / 序列帧）；方向刻意用确定性角度而不是 randf ——
## 这样单测与录像都可复现（与项目里「能钉进工程」的取向一致）。
## 刻意不写 class_name：引用方 preload（见 Cover.gd 头部说明）。

enum Kind { GROUND, UNIT, COVER }

const KIND_COLORS := [
	Color(0.72, 0.68, 0.55),   # 地面 / 脱靶：尘土
	Color(0.86, 0.26, 0.22),   # 命中单位
	Color(0.84, 0.84, 0.80),   # 掩体碎屑
]

var kind := Kind.GROUND
var _elapsed := 0.0
var _spark_dirs := PackedVector2Array()


func setup(point: Vector2, hit_kind: int = Kind.GROUND) -> void:
	global_position = point
	kind = clampi(hit_kind, 0, KIND_COLORS.size() - 1)
	# 确定性火花方向：一圈均匀铺开 + 按序号交错一点角度，看着不呆板但每帧一致
	var sparks := GameConfig.IMPACT_FX_SPARKS
	_spark_dirs = PackedVector2Array()
	for i in sparks:
		var angle := TAU * float(i) / float(sparks) + (0.31 if i % 2 == 1 else 0.0)
		_spark_dirs.append(Vector2.RIGHT.rotated(angle))
	queue_redraw()


func tick(delta: float) -> bool:
	_elapsed += delta
	queue_redraw()
	return _elapsed >= GameConfig.IMPACT_FX_LIFETIME


func remaining_ratio() -> float:
	return clampf(1.0 - _elapsed / GameConfig.IMPACT_FX_LIFETIME, 0.0, 1.0)


func spark_dirs() -> PackedVector2Array:
	return _spark_dirs


func _process(delta: float) -> void:
	if tick(delta):
		queue_free()


func _draw() -> void:
	var ratio := remaining_ratio()
	if ratio <= 0.0:
		return
	var color: Color = KIND_COLORS[kind]
	# 火花：从命中点向外飞（长度随寿命收缩）
	var spread := GameConfig.IMPACT_FX_SPARK_LENGTH * (1.0 - ratio) * 1.0 \
			+ GameConfig.IMPACT_FX_SPARK_LENGTH * 0.35
	for dir in _spark_dirs:
		draw_line(dir * spread * 0.35, dir * spread, Color(color, 0.85 * ratio), 1.4)
	# 扩散环：命中点向外扩散并淡出
	var ring := GameConfig.IMPACT_FX_RING_RADIUS * (1.0 - ratio * 0.35)
	draw_arc(Vector2.ZERO, ring, 0.0, TAU, 24, Color(color, 0.55 * ratio), 1.6)
