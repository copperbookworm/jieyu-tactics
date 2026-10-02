extends Control

## 4.16 被击倒时的视角 · 表现层（候选 O 第三轮）
##
## 4.16 原文：被击倒后相机锁定在倒地身体上方（俯视固定、不可拖动），画面模糊 / 去色 / 暗角，声音静音。
## 工程落地与取舍：
##   · 相机锁定 → systems/camera/AimCameraController.gd（unit_is_downed() → 准心锁死在身体上、不吃拖拽）
##   · 无法行动 → entities/player/Player.gd（移动 / 开火 / 换弹 / 换枪全部封住，只走倒地计时）
##   · 画面     → 本文件：全屏灰罩（「去色」的近似）+ 复用聚焦那套暗角贴图 + 居中倒计时
##   · 真模糊   → 需要屏幕纹理 shader，本项目至今零 shader（2026-10-01 实测）；第一版用灰罩 + 暗角从简，
##                登记为未做（docx 20.5）
##   · 声音静音 → 工程里目前没有任何 AudioStreamPlayer（docx 20.6），无音可静；音频系统落地后再接
##   · 队友可见 → 第一版单机没有队友，倒地者仍留在世界里（贴图不隐藏），等小队系统再谈「扶起」
##
## 刻意不写 class_name：引用方 preload（见 Cover.gd 头部说明）

const HudTextureFactory := preload("res://ui/HudTextureFactory.gd")

var main = null
var veil: ColorRect = null
var vignette: TextureRect = null
var title: Label = null


func setup(main_node) -> void:
	main = main_node
	size = Vector2(GameConfig.VIEWPORT_WIDTH, GameConfig.VIEWPORT_HEIGHT)
	mouse_filter = Control.MouseFilter.MOUSE_FILTER_IGNORE
	visible = false

	# 灰罩：矢量风画面没有真正的去色，用一层半透明灰把颜色「洗掉」
	veil = ColorRect.new()
	veil.name = "Veil"
	veil.color = Color(GameConfig.DOWNED_GRAY, GameConfig.DOWNED_VEIL_ALPHA)
	veil.size = size
	veil.mouse_filter = Control.MouseFilter.MOUSE_FILTER_IGNORE
	add_child(veil)

	# 暗角：直接复用聚焦那套程序生成的渐变贴图（同一张图，聚焦时也用它）
	vignette = TextureRect.new()
	vignette.name = "DownedVignette"
	vignette.texture = HudTextureFactory.vignette()
	vignette.size = size
	vignette.stretch_mode = TextureRect.STRETCH_SCALE
	vignette.mouse_filter = Control.MouseFilter.MOUSE_FILTER_IGNORE
	add_child(vignette)

	title = Label.new()
	title.name = "DownedTitle"
	title.position = Vector2(0.0, GameConfig.VIEWPORT_HEIGHT * 0.5 - 18.0)
	title.size = Vector2(GameConfig.VIEWPORT_WIDTH, 40.0)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_color_override("font_outline_color", Color(0.0, 0.0, 0.0, 0.9))
	title.add_theme_constant_override("outline_size", 5)
	add_child(title)


## 每帧：跟着玩家的倒地状态显隐与倒计时。放在 HUD 层的最后面，所以会盖住其它控件
## ——但 mouse_filter 全是 IGNORE，不吃触摸（人已经倒了，按什么也不该有反应）。
func tick(_delta: float) -> void:
	if main == null or main.player == null:
		return
	var player = main.player
	var downed: bool = bool(player.downed)
	visible = downed
	if not downed:
		return
	title.text = "被击倒 —— 剩余 %.0f s（第一版单机没有队友，无法被扶起）" \
			% maxf(float(player.downed_time_left), 0.0)
