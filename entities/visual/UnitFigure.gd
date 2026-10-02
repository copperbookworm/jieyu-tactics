extends Node2D

## 12.7.1 上下半身分离（候选 M · 第三轮；工程没有美术资产 ⇒ 第一版用程序绘制替代精灵帧）
##
## 12.7.1 的结构：角色节点 = 根（坐标 / 碰撞）+ 两个子节点 —— Lower（下半身：身体 / 腿）与
## Upper（上半身：持枪）；Lower.rotation = 移动方向角，Upper.rotation = 准星方向角（枪口指向准星）。
## Blob Shadow 是独立子节点、位于 Lower 之下，不随肢体扭动（由 BlobShadow 的 z_index -1 +
## 每帧把 global_rotation 掰回 0 保证）。
##
## 与 12.7.1 原文的差异（都写在这儿，免得被当成「已经做了帧动画」）：
##   · 贴图 → 程序绘制：Lower ＝ 椭圆身体 + 两条会前后摆的腿；Upper ＝ 肩 + 枪管 + 双手；
##   · 精灵帧 → 程序相位：腿的交替由 leg_phase 驱动，相位随实际速度推进、停下就冻住
##     （等价 12.7.6 的 char_lower_walk / run / crawl 那几组帧的「腿交替」语义，但不是逐帧贴图）；
##   · 卧姿按原文「需要单独的卧倒身体贴图」用拉长压扁的椭圆近似；蹲姿整体略小；
##   · 骨骼手部动作（换弹 / 扶起 / 扔雷）与「倒地 / 阵亡」全身帧未做 —— 登记在 20.5。
##
## 结构取舍：Lower / Upper 是真的两个 Node2D 子节点（编辑器与 MCP 能查到、外部直接设 rotation），
## 但绘制集中在根节点的一次 _draw 里用两次 draw_set_transform 完成 —— 一个 _draw 画两段不同旋转的几何，
## 比两个子节点各自 _draw 少一层状态，而 rotation 仍挂在子节点上。
##
## 刻意不写 class_name：引用方 preload（见 Cover.gd 头部说明）

const LEG_SWING := 0.55       # 腿前后摆动的幅度（相对身体半径）
const LEG_SPREAD := 0.42      # 两条腿的横向间距（相对身体半径）
const LEG_WIDTH := 0.30       # 腿的粗细（相对身体半径）
const GUN_LENGTH := 1.55      # 枪管长度（相对身体半径）
const GUN_WIDTH := 0.26       # 枪管粗细（相对身体半径）
const SHOULDER_SCALE := 0.78  # 上半身肩部半径（相对身体半径）

var body_radius := 0.4
var body_color := GameConfig.UNIT_COLOR_PLAYER
var posture := 0              ## 0 站 / 1 蹲 / 2 卧（与 PlayerUnit.Posture 同值）
var leg_phase := 0.0
## 倒地：整个人躺平（不再按瞄准方向抬枪，枪掉在一边）
var downed := false
var lower: Node2D = null      ## Lower：下半身（rotation = 移动方向角）
var upper: Node2D = null      ## Upper：上半身（rotation = 准星方向角）


## 建图：Lower / Upper 两个子节点 + 初始姿态
func setup_figure(radius: float, color: Color) -> void:
	body_radius = radius
	body_color = color
	if lower == null:
		lower = Node2D.new()
		lower.name = "Lower"
		add_child(lower)
	if upper == null:
		upper = Node2D.new()
		upper.name = "Upper"
		add_child(upper)
	queue_redraw()


## 姿态（0 站 / 1 蹲 / 2 卧）：只改身体形状，不改结构
## 倒地 / 起身（使用者 2026-10-02：倒地还是站姿太不合理）
func set_downed(value: bool) -> void:
	if downed == value:
		return
	downed = value
	queue_redraw()


func set_posture(value: int) -> void:
	var clamped := clampi(value, 0, 2)
	if clamped == posture:
		return
	posture = clamped
	queue_redraw()


## 移动：下半身转到移动方向；相位随速度推进（停下就冻住）
func set_move(angle: float, speed_ratio: float, delta: float) -> void:
	var changed := false
	if lower != null and not is_equal_approx(lower.rotation, angle):
		lower.rotation = angle
		changed = true
	var before := leg_phase
	leg_phase = phase_advance(leg_phase, speed_ratio, delta)
	if not is_equal_approx(before, leg_phase):
		changed = true
	if changed:
		queue_redraw()


## 瞄准：上半身转到准星方向（枪口指向准星）
func set_aim(angle: float) -> void:
	if upper == null or is_equal_approx(upper.rotation, angle):
		return
	upper.rotation = angle
	queue_redraw()


func lower_angle() -> float:
	return 0.0 if lower == null else lower.rotation


func aim_angle() -> float:
	return 0.0 if upper == null else upper.rotation


## 蹲姿压低一点（视觉）；卧姿用拉长的身体表达，不再单独缩放
func posture_scale() -> float:
	if posture == 1:
		return 0.85
	if posture == 2:
		return 0.80
	return 1.0


## 卧姿把身体沿移动方向拉长（12.7.1「卧倒身体贴图」的程序化近似）
func body_length_scale() -> float:
	return 1.50 if posture == 2 else 1.0


## 相位推进：速度越快摆得越快（等价走 / 跑的步频）；站着不动不推进；结果恒在 [0, TAU)
static func phase_advance(phase: float, speed_ratio: float, delta: float) -> float:
	var ratio := clampf(speed_ratio, 0.0, 1.0)
	if ratio <= 0.05:
		return phase
	return fposmod(phase + TAU * GameConfig.FIGURE_STRIDE_HZ * ratio * delta, TAU)


## 两条腿的前后摆动量：一前一后、都在 [-1, 1]（纯函数，测试直接调）
static func leg_offsets(phase: float) -> Vector2:
	var swing := sin(phase)
	return Vector2(swing, -swing)


## 倒地：整体转 90° 躺下（身体长轴与「面朝方向」垂直 ⇒ 一眼看出是躺着），四肢摊开、枪掉在身侧，
## 颜色压暗一档与站姿区分。
func _draw_downed() -> void:
	var r := body_radius
	var limb := body_color.darkened(0.45)
	draw_set_transform(Vector2.ZERO, PI * 0.5, Vector2.ONE)
	draw_colored_polygon(_ellipse_points(r * 1.45, r * 0.95, 20), body_color.darkened(0.25))
	draw_line(Vector2(-r * 0.25, r * 0.55), Vector2(-r * 1.45, r * 1.35), limb, r * 0.26, true)
	draw_line(Vector2(-r * 0.25, -r * 0.55), Vector2(-r * 1.45, -r * 1.35), limb, r * 0.26, true)
	draw_line(Vector2(r * 0.45, r * 0.15), Vector2(r * 1.15, r * 0.95), limb, r * 0.22, true)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	draw_line(Vector2(r * 0.75, r * 1.05), Vector2(r * 2.15, r * 1.35),
			Color(0.16, 0.16, 0.18, 0.9), r * 0.24, true)


## 椭圆采样点（along ＝ 沿 x 的半轴，across ＝ 沿 y 的半轴）
static func _ellipse_points(along: float, across: float, segments: int) -> PackedVector2Array:
	var points := PackedVector2Array()
	for i in segments:
		var a := TAU * float(i) / float(segments)
		points.append(Vector2(cos(a) * along, sin(a) * across))
	return points


func _draw() -> void:
	if downed:
		_draw_downed()
		return
	var r := body_radius * posture_scale()
	var along := r * body_length_scale()
	# ① 下半身：沿移动方向的身体 + 两条前后摆的腿
	draw_set_transform(Vector2.ZERO, lower_angle(), Vector2.ONE)
	draw_colored_polygon(_ellipse_points(along, r, 24), body_color)
	var swing := leg_offsets(leg_phase)
	for i in 2:
		var side := 1.0 if i == 0 else -1.0
		var hip := Vector2(-along * 0.20, side * r * LEG_SPREAD)
		var foot := Vector2(swing[i] * LEG_SWING * r, side * r * (LEG_SPREAD + 0.10))
		draw_line(hip, foot, body_color.darkened(0.30), r * LEG_WIDTH, true)
	# ② 上半身：肩 + 枪管 + 双手（沿准星方向）
	draw_set_transform(Vector2.ZERO, aim_angle(), Vector2.ONE)
	var sr := r * SHOULDER_SCALE
	draw_circle(Vector2.ZERO, sr, body_color.lightened(0.12))
	var gun_from := Vector2(sr * 0.35, 0.0)
	var gun_to := Vector2(sr * 0.35 + r * GUN_LENGTH, 0.0)
	draw_line(gun_from, gun_to, Color(0.16, 0.16, 0.18, 0.95), r * GUN_WIDTH, true)
	draw_circle(gun_from, r * 0.17, body_color.darkened(0.15))
	draw_circle(gun_from.lerp(gun_to, 0.55), r * 0.15, body_color.darkened(0.15))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
