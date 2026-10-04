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

## 开口（窗 / 门洞，12.8 原本没有这个字段，2026-10-03 拍板补进 occluders.json 的 openings[]）：
##   每条 = {type:"window"|"door", center:Vector2, half_size:Vector2, h_low:float, h_top:float}
##   center / half_size 都是**本地坐标**（与 half_size / segment_hit 同一个坐标系，随旋转一起转）。
## 语义：线段穿过矩形时，若交点落在某个开口格内、且视线高度落在该开口的高度区间里，
## 这一枪就从开口穿过去（看得见 / 打得进），不然就是实心墙。
## 高度区间是「窗台高～顶高」——所以站姿能透过窗看到屋里、卧姿看不到（与 C2 矮掩体同一套直觉）。
var openings: Array = []

## 摧毁时发（WorldSetup 拿它落残痕）。参数是自己，免得接收方还要闭包捕获
signal destroyed_now(cover)

## 吃不吃普通子弹（掩体耐久口径）：沙袋/半高墙 = true；
## **建筑 = false**（2026-10-03 拍板：普通子弹对建筑伤害恒为 0）——
## 建筑只走 take_structure_damage()，由弹种表决定谁能拆。
@export var absorbs_bullets := true


func _ready() -> void:
	hp = max_hp
	add_to_group(GameConfig.OCCLUDER_GROUP)


## 承受伤害（双方子弹都能打坏它）；耐久清零后退出 occluder 组 ⇒ 不再挡通视与子弹。
## 【口径提醒】amount 是**子弹伤害**口径（沙袋 200 耐久）。
## 2026-10-03 拍板「普通子弹对建筑伤害恒为 0」：absorbs_bullets=false 的物件（建筑）
## 直接忽略这条路径 —— 它只走 take_structure_damage()。
func take_damage(amount: float) -> void:
	if not absorbs_bullets:
		return
	_apply_damage(amount)


## 承受**结构伤害**（弹种口径，见 data/weapons_data.txt 的 structure_damage 列与
## data/vehicles_data.txt 的 gun_structure_damage 列；普通子弹恒为 0）。
## 与 take_damage 共用同一条三段状态机，区别只在「谁有资格扣这个血」。
func take_structure_damage(amount: float) -> void:
	_apply_damage(amount)


func _apply_damage(amount: float) -> void:
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
## 线段与掩体矩形的交点（世界坐标；没有交点**或整条线都从开口穿过去**则返回 Vector2.INF）。
## sight_height 是**相对地面**的视线/弹道高度（传 INF 表示调用方只关心几何，忽略开口高度区间）。
## 开口（窗 / 门洞）的 h_low / h_top 也是相对地面的，所以这里不需要知道绝对地面高 —— 两套口径天然一致。
##
## 2026-10-03 拍板①：只有打中开口才能伤到建筑里面，所以在屋子里不再绝对安全。
## 结构伤害的落点用 far_wall_hit()（直射穿窗时吃伤害的是对侧墙，不是入口那面）。
func segment_hit(from: Vector2, to: Vector2, sight_height: float = INF) -> Vector2:
	return wall_hit(from, to, sight_height, true)


## 找到线段与掩体矩形的交点（世界坐标），没有则返回 Vector2.INF。
##
## sight_height_at 传 INF 表示「调用方只关心几何，不关心高度」——
## 例如准心回退（first_cover）只要知道「这条线上有没有掩体」。
## 传了具体高度时，会再看该点是否落在某个开口的高度区间里：
## 落在里面就从开口穿过去（这一枪打得到里面），否则算实心墙。
##
## include_openings = true：开口视为可穿（通视 / 枪线口径，拍板①）
## include_openings = false：开口也当墙（「越过墙体的实际落点」用，结构伤害结算要它）
func wall_hit(from: Vector2, to: Vector2, sight_height_at: float = INF,
		include_openings: bool = true) -> Vector2:
	# 摧毁之后整块都不挡：通视与枪线口径下没有交点（「这一枪什么也没碰着」）
	if destroyed and include_openings:
		return Vector2.INF
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
		if t >= best_t:
			continue
		# include_openings = true  ⇒ 从开口穿过去的交点不算（拍板①：这是「打得到里面」的那一枪）。
		#   整条线都从开口过去 ⇒ 没有交点 ⇒ 返回 INF。
		# include_openings = false ⇒ **忽略开口**，直接返回几何上第一个交点：
		#   「一发弹是从哪个面开始穿这个掩体」——SightSystem 拿它算入口高度。
		if include_openings and _point_in_opening(point, sight_height_at, false):
			continue
		best_t = t
		best_local = point
	if best_local == Vector2.INF:
		return Vector2.INF
	return global_transform * best_local


## 找到线段与掩体矩形的**最后一个**交点（世界坐标），没有则返回 Vector2.INF。
##
## 用途：结构伤害的落点。一发弹打在墙上就是墙体交点的位置；从窗 / 门洞打进去时，
## 它会一路飞到**对侧墙**才停 —— 所以这里取 all intersections 里最靠后的那一个。
## 注意这**不是**「第一个交点」：直射打进窗户的那一发，入口那面墙并不吃伤害。
func far_wall_hit(from: Vector2, to: Vector2) -> Vector2:
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
	var far_t := -INF
	var far_local := Vector2.INF
	for i in corners.size():
		var hit: Variant = Geometry2D.segment_intersects_segment(a, b, corners[i],
				corners[(i + 1) % corners.size()])
		if hit == null:
			continue
		var point := hit as Vector2
		var t := 0.0
		if ab_len_sq > 0.000001:
			t = (point - a).dot(ab) / ab_len_sq
		if t > far_t:
			far_t = t
			far_local = point
	if far_local == Vector2.INF:
		return Vector2.INF
	return global_transform * far_local


## 本地坐标点是否落在某个开口格内。
##   ignore_height = true  → 只看几何（「开口背后的墙体落点」用）
##   ignore_height = false → 还要视线/弹道高度落在开口区间里
func _point_in_opening(local_point: Vector2, sight_height: float,
		ignore_height: bool) -> bool:
	for opening_v in openings:
		if not (opening_v is Dictionary):
			continue
		var opening: Dictionary = opening_v
		var center := _to_vec2(opening.get("center", Vector2.ZERO))
		var half := _to_vec2(opening.get("half_size", Vector2.ZERO))
		if absf(local_point.x - center.x) > half.x or absf(local_point.y - center.y) > half.y:
			continue
		if ignore_height or is_inf(sight_height):
			return true
		var low := float(opening.get("h_low", 0.0))
		var top := float(opening.get("h_top", height))
		if sight_height >= low and sight_height <= top:
			return true
	return false


## 点到掩体矩形的距离（在矩形内返回 0）——「依托」判定用（支持任意旋转）
func distance_to_edge(point: Vector2) -> float:
	var local: Vector2 = global_transform.affine_inverse() * point
	var outside := Vector2(maxf(absf(local.x) - half_size.x, 0.0),
			maxf(absf(local.y) - half_size.y, 0.0))
	return outside.length()


## 这一枪能不能从某个开口穿过去（2026-10-03 拍板①：只有打中开口才能伤到里面）。
## world_point 是线段与掩体矩形的交点（世界坐标）；ground 是掩体所在处的地面高。
## 开口的高度区间在数据里是**相对地面**的（窗台 1.0 m / 门 0～顶高），这里换算成绝对高度比。
## 摧毁之后整块都不挡了，所以直接返回 true（开口此时已无意义）。
func pierces_at(world_point: Vector2, sight_height: float, ground: float = 0.0) -> bool:
	if destroyed:
		return true
	if openings.is_empty():
		return false
	var local: Vector2 = global_transform.affine_inverse() * world_point
	for opening_v in openings:
		if not (opening_v is Dictionary):
			continue
		var opening: Dictionary = opening_v
		var center := _to_vec2(opening.get("center", Vector2.ZERO))
		var half := _to_vec2(opening.get("half_size", Vector2.ZERO))
		if absf(local.x - center.x) > half.x or absf(local.y - center.y) > half.y:
			continue
		var low := ground + float(opening.get("h_low", 0.0))
		var top := ground + float(opening.get("h_top", height))
		if sight_height >= low and sight_height <= top:
			return true
	return false


static func _to_vec2(value: Variant) -> Vector2:
	if value is Vector2:
		return value
	if value is Array and (value as Array).size() >= 2:
		return Vector2(float((value as Array)[0]), float((value as Array)[1]))
	if value is Dictionary:
		var d: Dictionary = value
		return Vector2(float(d.get("x", 0.0)), float(d.get("y", 0.0)))
	return Vector2.ZERO


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
