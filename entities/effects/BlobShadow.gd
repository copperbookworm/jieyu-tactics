extends Node2D

## 12.3 Blob Shadow（候选 M · 第一轮）
##
## 12.3 原文：以固定在角色脚底 / 重心的扁椭圆或模糊圆形作为基础形状，形状本身不随肢体动画扭动；
## 跳跃 / 滞空时阴影原位不动但缩小并变模糊（表达 Z 轴），受击 / 位移时阴影更早更稳地贴地以牵引视线；
## 形状需遵循场景的全局光照方向统一微调。落地原则：用最克制、最稳定的阴影形状去承载最硬核的动作。
##
## 第一版口径：
##   · 形状 ＝ 程序生成的扁椭圆（BLOB_SHADOW_SQUASH 压扁），不依赖任何美术资产；
##   · 「缩小并变模糊」用「缩小 + 变淡」近似（真模糊要屏幕纹理 shader，本项目零 shader —— 见 4.16 同一取舍）；
##   · 光照方向是全局常量（BLOB_SHADOW_LIGHT_DEG），全场景统一偏移，不做逐光源计算；
##   · 挂法：身体的子节点 + show_behind_parent，并在 _process 里把 global_rotation 掰回 0
##     —— 车体 / 身体转向时阴影不跟着扭（12.3 的原话），位置仍留在身体重心。
##
## 刻意不写 class_name：新 class_name 在 --headless --script 下不进全局类缓存，引用方会解析失败
## （2026-10-01 第三十一版踩过、本轮又踩一次）——所以引用方一律 preload（同 Cover.gd 头部说明）。

var radius := GameConfig.BLOB_SHADOW_RADIUS
var base_alpha := GameConfig.BLOB_SHADOW_ALPHA
## 离地高度（m）：0 ＝ 贴地。第一版步兵恒为 0，接口留给以后的高抛 / 滞空。
var height := 0.0


func _ready() -> void:
	show_behind_parent = true
	z_index = -1
	queue_redraw()


func _process(_delta: float) -> void:
	# 12.3：形状本身不随身体 / 车体转动 —— 每帧把世界旋转掰回 0
	global_rotation = 0.0


## 按身体尺寸摆阴影（半径 = 身体半径 × BLOB_SHADOW_BODY_SCALE）
func fit_body(body_radius: float) -> void:
	radius = body_radius * GameConfig.BLOB_SHADOW_BODY_SCALE
	queue_redraw()


func set_height(value: float) -> void:
	var clamped := maxf(value, 0.0)
	if is_equal_approx(clamped, height):
		return
	height = clamped
	queue_redraw()


## 滞空高度 → 缩放（越高越小，到 BLOB_SHADOW_MIN_SCALE 为止）；纯函数，测试直接用
static func scale_for(height_m: float) -> float:
	return clampf(1.0 - GameConfig.BLOB_SHADOW_HEIGHT_SCALE * maxf(height_m, 0.0),
			GameConfig.BLOB_SHADOW_MIN_SCALE, 1.0)


## 滞空高度 → 透明度（越高越淡 —— 「变模糊」的近似）；纯函数
static func alpha_for(height_m: float, base: float = GameConfig.BLOB_SHADOW_ALPHA) -> float:
	return base * scale_for(height_m)


## 全局光照方向下的统一偏移（12.3「遵循场景的全局光照方向统一微调」）；纯函数
static func light_offset() -> Vector2:
	return Vector2.RIGHT.rotated(deg_to_rad(GameConfig.BLOB_SHADOW_LIGHT_DEG)) \
			* GameConfig.BLOB_SHADOW_LIGHT_OFFSET


func current_scale() -> float:
	return scale_for(height)


func current_alpha() -> float:
	return alpha_for(height, base_alpha)


func _draw() -> void:
	var scale := current_scale()
	draw_set_transform(light_offset(), 0.0,
			Vector2(radius * scale, radius * scale * GameConfig.BLOB_SHADOW_SQUASH))
	draw_circle(Vector2.ZERO, 1.0,
			Color(GameConfig.BLOB_SHADOW_COLOR, current_alpha()))
