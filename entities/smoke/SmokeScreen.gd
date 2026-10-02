extends Node2D

## 烟雾幕（docx 4.12 / 4.12.8 确认稿，候选 P）
##
## 一个圆饼形的临时遮挡体：半径 10 m、高 3 m、持续 25 s，触发即生效（4.12.3）。
## 三条边界（都来自确认稿）：
##   ① 只挡视线、不挡子弹（4.12.6）——所以本节点进 SMOKE_GROUP，**不进 OCCLUDER_GROUP**；
##     那个组同时喂给「子弹截断」，混进去会让子弹打在烟上。
##   ② 只遮得住低于烟顶的视线：烟高 3 m，坦克 2.5~3 m 观察高度会被遮住，飞机 / 高处仍可越过（4.12.2）。
##   ③ 多发可叠加：本文件是单发，叠加就是场上多几个本节点，判定取「任一发挡住即挡住」。
## 本文件只负责几何 + 计时 + 画出来；「挡不挡视线」的判定在 SightSystem.smoke_blocks()。
## 刻意不写 class_name：引用方 preload（见 Cover.gd 头部说明）

signal expired(smoke: Node2D)

var radius := GameConfig.SMOKE_RADIUS
var height := GameConfig.SMOKE_HEIGHT
var duration := GameConfig.SMOKE_DURATION
var time_left := GameConfig.SMOKE_DURATION
## 跟着某个节点走（载具发烟器：烟幕随车移动）；null ＝ 固定落点（步兵烟雾弹）
var follow: Node2D = null


func _ready() -> void:
	add_to_group(GameConfig.SMOKE_GROUP)
	queue_redraw()


## 落烟：必须 add_child 之后再调（要读 global_position 的父链）
func setup(at: Vector2, follow_node: Node2D = null) -> void:
	follow = follow_node
	global_position = at
	time_left = duration
	if not is_in_group(GameConfig.SMOKE_GROUP):
		add_to_group(GameConfig.SMOKE_GROUP)
	queue_redraw()


## 烟顶相对高度（绝对高度 = 地面高 + 烟高），与 Cover.top_height_at 同一口径
func top_height_at(ground: float) -> float:
	return ground + height


func is_active() -> bool:
	return time_left > 0.0


## 剩余寿命比例（1 = 刚放，0 = 散尽）
func life_ratio() -> float:
	return clampf(time_left / maxf(duration, 0.001), 0.0, 1.0)


## 线段是否穿过本烟饼；穿过则返回入射点。纯几何，不含高度判断
func segment_crossing(from: Vector2, to: Vector2) -> Vector2:
	return segment_circle_entry(from, to, global_position, radius)


## 线段与圆的第一个交点（无交点返回 Vector2.INF；起点已在圆内则返回起点本身）。
## 纯函数：测试与 SightSystem 共用同一套几何，不重复写两遍。
static func segment_circle_entry(from: Vector2, to: Vector2, center: Vector2,
		circle_radius: float) -> Vector2:
	var delta := to - from
	var length_sq := delta.length_squared()
	var offset := from - center
	if offset.length() <= circle_radius:
		return from
	if length_sq <= 0.000001:
		return Vector2.INF
	var b := offset.dot(delta)
	var c := offset.length_squared() - circle_radius * circle_radius
	var disc := b * b - length_sq * c
	if disc < 0.0:
		return Vector2.INF
	var t := (-b - sqrt(disc)) / length_sq
	if t < 0.0 or t > 1.0:
		return Vector2.INF
	return from + delta * t


## AI 盲射命中率 −70%（docx 4.12.5 / 4.12.8 ④）：命中判定成立后按 SMOKE_BLIND_FIRE_HIT_SCALE 再抽一次。
## roll 传 randf()；抽不中就把这次命中当未命中。纯函数，测试直接给 roll。
static func keeps_blind_hit(roll: float) -> bool:
	return roll <= GameConfig.SMOKE_BLIND_FIRE_HIT_SCALE


func _process(delta: float) -> void:
	# 载具发烟器：烟幕跟着车走（2026-10-02 真机反馈「没有属于载具的烟雾 / 烟被留在原地」）
	if follow != null and is_instance_valid(follow):
		global_position = follow.global_position
	if time_left <= 0.0:
		return
	time_left -= delta
	queue_redraw()
	if time_left <= 0.0:
		time_left = 0.0
		expired.emit(self)
		queue_free()


## 烟饼：起烟 0.6 s 内铺开到位（「触发即生效」），最后 40% 寿命淡出
func _draw() -> void:
	var life := life_ratio()
	if life <= 0.0:
		return
	var grow := clampf((duration - time_left) / 0.6, 0.35, 1.0)
	var alpha := 0.55 * clampf(life * 2.5, 0.0, 1.0)
	var current := radius * grow
	draw_circle(Vector2.ZERO, current, Color(0.76, 0.76, 0.79, alpha))
	# 两团偏心的小烟：让烟饼不是一个几何圆，看得出是「一团烟」
	draw_circle(Vector2(current * 0.35, -current * 0.25), current * 0.55,
			Color(0.82, 0.82, 0.85, alpha * 0.75))
	draw_circle(Vector2(-current * 0.30, current * 0.30), current * 0.50,
			Color(0.70, 0.70, 0.74, alpha * 0.75))
	draw_arc(Vector2.ZERO, current, 0.0, TAU, GameConfig.SMOKE_DRAW_SEGMENTS,
			Color(0.90, 0.90, 0.93, alpha * 0.8), 2.0)
