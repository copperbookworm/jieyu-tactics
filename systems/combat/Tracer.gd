class_name Tracer
extends Line2D

## 曳光：一条从枪口到命中点/射程末端的亮线，快速淡出
## 俯视 2D 里弹道下坠体现在"命中判定"上，曳光只表现水平弹道轨迹
## 用亮线替代之前的飞行亮点——点太小太快，肉眼看不到

const LIFETIME := 0.25  # s，可见时长

var _elapsed := 0.0


func setup(origin: Vector2, direction: Vector2, distance: float) -> void:
	var end := origin + direction * maxf(distance, 0.0)
	points = PackedVector2Array([origin, end])
	width = 0.3  # m，zoom16 下约 5px
	default_color = Color(1.0, 0.85, 0.35, 0.95)


func _process(delta: float) -> void:
	_elapsed += delta
	if _elapsed >= LIFETIME:
		queue_free()
		return
	default_color.a = 0.95 * (1.0 - _elapsed / LIFETIME)
