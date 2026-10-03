extends Node2D

## 注意：本文件刻意不写 class_name —— 新建脚本的 class_name 要等 Godot 扫描后才可用，
## 期间引用处会报「Identifier not declared」。引用方用 preload，例如：
##     const CoverScript := preload("res://entities/cover/Cover.gd")
##     var cover = CoverScript.new()   # 用 = 而不是 :=（右侧类型未知，:= 会报「无法推断类型」）
## SightSystem 侧则用鸭子类型（has_method 判断），同样不依赖类名。

## 掩体（docx 4.7 第③级「掩体连线检测」+ C2「矮掩体 / 架枪依托」）
##   ① 挡通视——视线高度没高出掩体顶就判「被遮挡」
##   ② 挡子弹——与通视同一套高度规则（站姿 1.6 m 打得过 1.1 m 沙袋，趴下 0.6 m 打不过）
##   ③ 提供依托——蹲 / 卧贴着掩体时给一档精度（C3）
##   ④ 可破坏——三段耐久（完好 / 受损 / 摧毁），见下
## 支持任意旋转：求交与距离都在本地空间做（global_transform 的逆变换），不限定轴对齐
##
## 三段耐久（2026-10-03 使用者拍板，落进 occluders.json 的 damage_profiles）：
##   · 完好   ：耐久比 > damaged_below          → 顶高 = height
##   · 受损   ：0 < 耐久比 ≤ damaged_below      → 顶高 = height × damaged_scale（挡视线的缝变大）
##   · 摧毁   ：耐久归零                        → 退出 occluder 组（不再挡通视与子弹），残痕另建
## 「受损变矮」不是新物理：通视与子弹都走 top_height_at()，顶高一降，缝自己就出来了
## （判据是「视线高度 ≥ 掩体顶高 + COVER_SIGHT_SLACK 才算看得过去」）。

@export var half_size := Vector2(GameConfig.COVER_SANDBAG_HALF_X,
		GameConfig.COVER_SANDBAG_HALF_Y)
@export var height := GameConfig.COVER_SANDBAG_HEIGHT  # m，**完好**时的掩体顶高（相对地面）
@export var max_hp := GameConfig.COVER_HP              # 耐久：打光后不再挡通视与子弹
## 掉到这条线以下算「受损」（顶高按 damaged_height_scale 缩）
@export var damaged_below_ratio := GameConfig.COVER_DAMAGED_BELOW_RATIO
@export var damaged_height_scale := GameConfig.COVER_DAMAGED_HEIGHT_SCALE

var hp := GameConfig.COVER_HP
var destroyed := false

## 摧毁时发（WorldSetup 拿它落残痕）。参数是自己，免得接收方还要闭包捕获
signal destroyed_now(cover)


func _ready() -> void:
	hp = max_hp
	add_to_group(GameConfig.OCCLUDER_GROUP)


## 承受伤害（双方子弹都能打坏它）；耐久清零后退出 occluder 组 ⇒ 不再挡通视与子弹
func take_damage(amount: float) -> void:
	if destroyed or amount <= 0.0:
		return
	hp = maxf(hp - amount, 0.0)
	if hp <= 0.0:
		destroyed = true
		remove_from_group(GameConfig.OCCLUDER_GROUP)
		destroyed_now.emit(self)
	queue_redraw()


func is_destroyed() -> bool:
	return destroyed


func health_ratio() -> float:
	return hp / maxf(max_hp, 0.001)


## 是否处在「受损」档（完好 = false，摧毁 = false —— 摧毁是另一回事）
func is_damaged() -> bool:
	return not destroyed and health_ratio() <= damaged_below_ratio


## 当前顶高相对完好顶高的比例：完好 1.0 / 受损 damaged_height_scale / 摧毁 0.0
func height_scale() -> float:
	if destroyed:
		return 0.0
	return damaged_height_scale if is_damaged() else 1.0


## 当前实际掩体高度（完好时等于 height）
func effective_height() -> float:
	return height * height_scale()


## 掩体顶的绝对高度（地面高 + 当前掩体高）；地面高度由调用方传入，避免这里依赖 HeightGrid
func top_height_at(ground_height: float) -> float:
	return ground_height + effective_height()


## 线段是否穿过本掩体：穿过返回「沿 from→to 方向先撞上的那一面」的交点（世界坐标），
## 否则返回 Vector2.INF（支持任意旋转）。
## 修（2026-09-30 回归测试抓出）：原来按四条边的遍历顺序返回第一个命中的边，
## 而边序是先底边、再右边……于是横穿时返回的是远端（从左上到右下打过去，回的是出去的那一面）。
## 通视截断与子弹截断要的都是「先挡住视线的那一面」，所以必须按线段参数取最靠前的交点。
func segment_hit(from: Vector2, to: Vector2) -> Vector2:
	var to_local := global_transform.affine_inverse()
	var a: Vector2 = to_local * from
	var b: Vector2 = to_local * to
	var corners := [
		Vector2(-half_size.x, -half_size.y),
		Vector2(half_size.x, -half_size.y),
		Vector2(half_size.x, half_size.y),
		Vector2(-half_size.x, half_size.y),
	]
	var ab := b - a
	var ab_len_sq := ab.length_squared()
	var best_t := INF
	var best_local := Vector2.INF
	for i in corners.size():
		var hit: Variant = Geometry2D.segment_intersects_segment(a, b, corners[i],
				corners[(i + 1) % corners.size()])
		if hit == null:
			continue
		var point := hit as Vector2
		# 交点在 a→b 上的参数位置；线段退化成一点时取 0，避免除零
		var t := 0.0
		if ab_len_sq > 0.000001:
			t = (point - a).dot(ab) / ab_len_sq
		if t < best_t:
			best_t = t
			best_local = point
	if best_local == Vector2.INF:
		return Vector2.INF
	return global_transform * best_local


## 点到掩体矩形的距离（在矩形内返回 0）——「依托」判定用（支持任意旋转）
func distance_to_edge(point: Vector2) -> float:
	var local: Vector2 = global_transform.affine_inverse() * point
	var outside := Vector2(maxf(absf(local.x) - half_size.x, 0.0),
			maxf(absf(local.y) - half_size.y, 0.0))
	return outside.length()


func _draw() -> void:
	var rect := Rect2(-half_size, half_size * 2.0)
	if destroyed:
		# 残骸：半透明发灰，明确表示「这里已经不能遮了」（但视觉上还留着废墟）
		draw_rect(rect, Color(0.30, 0.28, 0.25, 0.35))
		draw_rect(rect, Color(0.45, 0.42, 0.38, 0.5), false, 2.0)
		return
	# 受损越重颜色越暗（耐久满 → 0.9 透明度的沙袋色，打光 → 深褐）
	var life := health_ratio()
	var fill := Color(0.28, 0.22, 0.18, 0.9).lerp(Color(0.52, 0.47, 0.38, 0.9), life)
	draw_rect(rect, fill)
	draw_rect(rect, Color(0.80, 0.75, 0.62, 0.95), false, 2.0)
	# 高度提示：越高的掩体顶部亮条越粗（1.1 m 沙袋 → 1.4 m 矮墙）
	if height >= 1.3:
		draw_rect(rect.grow(-3.0), Color(1.0, 1.0, 1.0, 0.22), false, 2.0)
	# 受损档：画几道裂纹 + 内缩一圈，让「顶高变矮了」在画面上看得出来
	# （3C 的可读性要求：状态变化必须有视觉反馈，不能只靠耐久条）
	if is_damaged():
		var crack := Color(0.16, 0.13, 0.11, 0.9)
		draw_line(Vector2(-half_size.x * 0.6, -half_size.y), Vector2(-half_size.x * 0.1, 0.0),
				crack, 1.5)
		draw_line(Vector2(-half_size.x * 0.1, 0.0), Vector2(-half_size.x * 0.45, half_size.y),
				crack, 1.5)
		draw_line(Vector2(half_size.x * 0.5, -half_size.y), Vector2(half_size.x * 0.15, 0.0),
				crack, 1.5)
		draw_line(Vector2(half_size.x * 0.15, 0.0), Vector2(half_size.x * 0.55, half_size.y),
				crack, 1.5)
		draw_rect(rect.grow(-2.0), Color(1.0, 0.85, 0.35, 0.55), false, 1.0)
	# 挨过打才显示耐久条（顶部细条，免得满耐久时满屏都是条）
	if life < 0.999:
		var bar := Rect2(Vector2(-half_size.x, -half_size.y - 4.0),
				Vector2(half_size.x * 2.0, 2.5))
		draw_rect(bar, Color(0.0, 0.0, 0.0, 0.45))
		draw_rect(Rect2(bar.position, Vector2(bar.size.x * life, bar.size.y)),
				Color(0.90, 0.75, 0.30, 0.95))
