extends Node

## HUD 构建与刷新（2026-09-30 候选 N：从 Main.gd 拆出）
##
## 负责：HUD 那一整层（CanvasLayer + 全部控件）、准心的染色/朝向/压制抖动、聚焦视觉、
## 三条状态标签（血量 / 占领 / 兵种·武器）的节流刷新、报点提示行、胜负文字、战术地图开合。
##
## 对外接口（Main 与其它模块只用这些）：
##   setup(main, terrain_texture)  建 HUD（必须在地形/玩家/标记/间瞄之后调用）
##   tick(delta)                   每帧：血量 + 准心 + 占领/兵种标签（0.25 s 节流）+ 提示超时
##   show_hint(text)               左下/底部提示行（原来叫 Main._show_mark_hint，各模块共用）
##   push_feed(kind, text, color)  战斗播报（4.14）；tick 里驱动播报与操作提示（4.15）
##   update_ammo / mark_reloading / update_score / update_capture / update_role
##   apply_focus(on)               聚焦开关（准心收窄 + 暗角 + 玩家散布收紧）
##   toggle_map / close_map / is_map_open     战术地图开合（含开图期间的玩家输入冻结）
##   show_victory / show_defeat(reason) / set_vehicle_button_text(text)
##
## 控件本身也是公开字段（fire_button / mark_wheel / tactical_map …），信号接线统一在 Main._wire_signals。
## 刻意不写 class_name：引用方 preload（见 Cover.gd 头部说明）

## HUD 程序生成贴图（准心箭头 / 聚焦暗角）：2026-09-29 从 Main.gd 拆出，Main 因此回到 1000 行以内
const HudTextureFactory := preload("res://ui/HudTextureFactory.gd")
## 候选 O 第一轮：战斗播报（4.14）+ 操作提示（4.15）两个 HUD 面板
const ArtAssetsScript := preload("res://systems/art/ArtAssets.gd")
const CombatFeedPanelScript := preload("res://ui/CombatFeedPanel.gd")
const TipPanelScript := preload("res://ui/TipPanel.gd")
## 候选 O 第二轮：快捷指令轮盘（4.13）
const CommandWheelScript := preload("res://ui/CommandWheel.gd")
## 候选 O 第三轮：被击倒时的全屏视角（4.16）
const DownedOverlayScript := preload("res://ui/DownedOverlay.gd")
## 部件系统（docx 8.4）：HUD 状态行与瞄高键要读档位名
const VehiclePartsScript := preload("res://systems/vehicles/VehicleParts.gd")

var main = null                 # Main（不标类型：Main 无 class_name，用鸭子类型）
var layer: CanvasLayer = null
var crosshair: Sprite2D = null
var vignette: TextureRect = null
var hint_label: Label = null
var score_label: Label = null
## 战局状态（剩余时间 / 加时 / 重生预算，候选 Q）
var match_label: Label = null
var capture_hud: Label = null
## 左上信息列容器（占领状态 + 任务卡）：位置由布局器算，见 _build 里的说明
var left_column: VBoxContainer = null
var quest_card: QuestCard = null
var mark_wheel: MarkWheel = null
var command_wheel = null
var mark_hint: Label = null
var role_label: Label = null
var hp_label: Label = null
var ammo_label: Label = null
var victory_label: Label = null
var defeat_label: Label = null
var map_button: Button = null
var role_button: Button = null
var posture_button: Button = null
var indirect_button: Button = null
## 烟雾（候选 P，docx 4.12）：步兵投烟雾弹 / 在载具里放发烟器
var smoke_button: Button = null
## 爆破键（2026-10-04 炸药 / 工程兵）：按一下放、再按一下遥控起爆
var explosive_button: Button = null
var weapon_button: Button = null
var vehicle_button: Button = null
var seat_button: Button = null
## 弹种键（ATGM 落地后加的）：武器位一键切「主炮 ⇄ 反坦克导弹」
var ammo_type_button: Button = null
## 瞄高键（docx 8.4.2 / 8.4.4 · 2026-10-05）：武器位切「炮塔 / 车体 / 弹药架 / 机动件」，只在武器位显示
var aim_gear_button: Button = null
## 暂停键（2026-10-03 游戏外壳）：本文件只负责**建**，接线在 ui/screens/MatchHost.gd
## —— Main.gd 守着 398/400 的硬线，加不了这一行
var pause_button: Button = null
## 战术地图层（原来只是 setup 里的局部变量）：外壳暂停时要连它一起收起来
var map_layer: CanvasLayer = null
var fire_button: FireButton = null
var focus_button: FocusButton = null
var joystick: TouchJoystick = null
var tactical_map: TacticalMap = null
var mini_map: MiniMap = null
## 候选 O 第一轮：战斗播报（4.14）与操作提示（4.15），纯展示、不参与交互
var feed = null
var tips = null
## 候选 O 第三轮：被击倒时的全屏视角（4.16）
var downed_overlay = null

var _hint_timer := 0.0
var _focusing := false
var _capture_timer := 0.0
## C2（施工单 §7）：血量文本写入去重。原先每帧都 `hp_label.text = "血量 %d" ...` ——
## 值没变也重建 String 并触发 Label 排版。缓存"上一次写进去的三个输入"，三者都没变就不写。
## 三个输入缺一不可：hp / 压制百分比 / **要不要显示压制后缀**。
## 反例：suppression=0.010 与 0.015 的百分数都是 1，但前者不带后缀、后者带 ——
## 只比百分比会漏掉一次必要更新（标签会停在"血量 80"）。
var _hp_last := -1
var _hp_sup_pct_last := -1
var _hp_sup_on_last := false


## 分组色（2026-10-03）：九宫格三列各管一件事，用颜色把「这是哪一组」显出来。
## 手机上认色比认字快，而且比加分组标题省地方（y=138 那一带被任务卡占着，放不下标题）。
const GROUP_INFANTRY := Color(0.55, 0.78, 1.00)   # 列1 步兵自身
const GROUP_VEHICLE := Color(0.60, 0.88, 0.62)    # 列2 载具
const GROUP_FIRE := Color(1.00, 0.80, 0.50)       # 列3 火力与沟通


## 给 HUD 按钮上分组色 + 一句 tooltip（桌面上鼠标悬停看得到）
func _tint(button: Button, group: Color, tip: String) -> void:
	button.add_theme_color_override("font_color", group)
	button.add_theme_color_override("font_hover_color", Color.WHITE)
	button.add_theme_color_override("font_focus_color", group)
	if tip != "":
		button.tooltip_text = tip


## 建 HUD。terrain_texture 由 Main 从 WorldSetup 中转过来（小地图与战术地图都要它）
func setup(main_node, terrain_texture: Texture2D) -> void:
	main = main_node
	layer = CanvasLayer.new()
	layer.name = "HUD"
	add_child(layer)

	# 屏幕边缘暗角（聚焦时显示）：先加，压在底层，不挡 HUD 文字与按键。
	vignette = TextureRect.new()
	vignette.name = "FocusVignette"
	vignette.texture = HudTextureFactory.vignette()
	vignette.size = Vector2(GameConfig.VIEWPORT_WIDTH, GameConfig.VIEWPORT_HEIGHT)
	vignette.stretch_mode = TextureRect.STRETCH_SCALE
	vignette.mouse_filter = Control.MouseFilter.MOUSE_FILTER_IGNORE
	vignette.visible = false
	layer.add_child(vignette)

	crosshair = Sprite2D.new()
	crosshair.name = "Crosshair"
	# 美术优先（2026-10-07 第九十五版）：ui_crosshair 有文件就用文件，没有就程序生成三角箭头。
	# ⚠ 换图必须守约定：**箭尖＝纹理中心＝屏心、箭身朝 -x**（纹理 32×32，箭身长 14、底边半高 7）——
	# 因为 Sprite2D 以中心为旋转轴，箭尖不在中心的话「枪口指向」会整体偏一段。
	var cross_tex := ArtAssetsScript.texture("ui_crosshair")
	crosshair.texture = cross_tex if cross_tex != null else HudTextureFactory.crosshair_arrow()
	crosshair.position = Vector2(GameConfig.VIEWPORT_WIDTH, GameConfig.VIEWPORT_HEIGHT) * 0.5
	layer.add_child(crosshair)

	hint_label = Label.new()
	hint_label.name = "Hint"
	hint_label.text = "左下摇杆移动 ｜ 右手拖动移动准心（准心＝屏心＝相机中心）"
	hint_label.position = Vector2(16.0, 12.0)
	layer.add_child(hint_label)

	joystick = TouchJoystick.new()
	joystick.name = "Joystick"
	layer.add_child(joystick)
	main.player.set_joystick(joystick)

	var enemy_arrow := DebugEnemyArrow.new()
	enemy_arrow.name = "DebugEnemyArrow"
	layer.add_child(enemy_arrow)
	enemy_arrow.setup(main.camera, main.player)

	fire_button = FireButton.new()
	fire_button.name = "FireButton"
	layer.add_child(fire_button)

	# 聚焦键（开火键左侧）：按住聚焦，松开退出。
	focus_button = FocusButton.new()
	focus_button.name = "FocusButton"
	layer.add_child(focus_button)

	score_label = Label.new()
	score_label.name = "Score"
	score_label.position = Vector2(GameConfig.VIEWPORT_WIDTH - 158.0, 8.0 + 150.0 + 4.0)
	layer.add_child(score_label)

	# 战局状态行（候选 Q，docx 5.7）：剩余时间 + 加时提示 + 重生预算
	match_label = Label.new()
	match_label.name = "MatchClock"
	match_label.position = Vector2(GameConfig.VIEWPORT_WIDTH - 158.0, 8.0 + 150.0 + 52.0)
	layer.add_child(match_label)
	update_score(main.score)

	# 左上信息列（2026-10-07 第八十八版真机验收后改）：占领状态 + 任务卡放进 VBoxContainer。
	# 为什么必须容器化：两块以前是**手写坐标**的，占领状态 (16,36 高 51) 与任务卡 (16,60 高 96)
	# 纵向叠了 25 px —— 真机截图里任务卡把「区内兵力 我 0 ｜ 敌 2」整行盖住。
	# 容器化后位置由布局器算，结构上不可能再重叠（Container 的子节点在几何门禁里本就跳过重叠检查：
	# 这是「用布局消灭断言」，不是「用断言掩盖布局」）。纵向预算见 GameConfig 的 LEFT_COLUMN_*。
	left_column = VBoxContainer.new()
	left_column.name = "LeftColumn"
	left_column.position = Vector2(GameConfig.LEFT_COLUMN_X, GameConfig.LEFT_COLUMN_Y)
	left_column.add_theme_constant_override("separation", int(GameConfig.LEFT_COLUMN_GAP))
	left_column.mouse_filter = Control.MouseFilter.MOUSE_FILTER_IGNORE
	layer.add_child(left_column)

	capture_hud = Label.new()
	capture_hud.name = "CaptureStatus"
	# 字号压到 12：两行才装得进 32 px（默认字号是 51 px，与任务卡一起放不下）
	capture_hud.add_theme_font_size_override("font_size", GameConfig.CAPTURE_STATUS_FONT_SIZE)
	left_column.add_child(capture_hud)
	update_capture()

	quest_card = QuestCard.new()
	quest_card.name = "QuestCard"
	quest_card.main = main          # 组任务行每帧从这里读 world.squad_orders
	left_column.add_child(quest_card)

	# 报点键（右下角、开火键上方）＋ 报点结果提示
	mark_wheel = MarkWheel.new()
	mark_wheel.name = "MarkWheel"
	layer.add_child(mark_wheel)

	# 指令键（docx 4.13 快捷指令轮盘）：左侧第三列的空位；展开只走左半圈（与报点轮盘同一套几何）
	command_wheel = CommandWheelScript.new()
	command_wheel.name = "CommandWheel"
	command_wheel.tooltip_text = "列3 火力·沟通：快捷指令轮盘（4.13）"
	layer.add_child(command_wheel)

	mark_hint = Label.new()
	mark_hint.name = "MarkHint"
	mark_hint.position = Vector2(GameConfig.VIEWPORT_WIDTH * 0.5 - 120.0,
			GameConfig.VIEWPORT_HEIGHT - 56.0)
	layer.add_child(mark_hint)

	# 对局内战斗播报（docx 4.14）与操作提示（docx 4.15）：候选 O 第一轮
	feed = CombatFeedPanelScript.new()
	feed.name = "CombatFeed"
	layer.add_child(feed)
	feed.setup(main)

	tips = TipPanelScript.new()
	tips.name = "TipPanel"
	layer.add_child(tips)
	tips.setup(main)

	# 暂停键（2026-10-03 游戏外壳）：放右上角 (878,8)。
	# 这个矩形是拿 tools/hud_rects.gd 的实测输出挑的：右上角 y<162 的整片区域是空的
	# （右列从 Score 的 y=162 才开始占），所以 878..958 × 8..52 与全部 HUD 控件无交集。
	pause_button = Button.new()
	pause_button.name = "PauseButton"
	_tint(pause_button, Color(0.86, 0.86, 0.90), "暂停 / 设置 / 返回大厅")
	pause_button.text = "暂停"
	pause_button.size = Vector2(80.0, 44.0)
	pause_button.position = Vector2(GameConfig.VIEWPORT_WIDTH - 82.0, 8.0)
	layer.add_child(pause_button)

	# 战术地图：M 键或这个按钮开图；单独一层盖在 HUD 之上（docx 4.11.3）
	map_button = Button.new()
	map_button.name = "MapButton"
	_tint(map_button, GROUP_FIRE, "战术地图（4.11.3）；桌面按 M")
	map_button.text = "地图"
	map_button.size = Vector2(80.0, 44.0)
	map_button.position = Vector2(GameConfig.VIEWPORT_WIDTH - 158.0, 8.0 + 150.0 + 76.0)

	# 左侧功能键：3 列 × 3 行（列 x = 16 / 104 / 192，行 y = 140/186/232 + _dy）。
	# 底界 294，给左下角摇杆（圆心 100,440、半径 90、触摸判定 144 ⇒ 上沿 296）留出空间。
	# ⚠ 第四十一版补丁9：整个集群下移 HUD_BUTTON_CLUSTER_DY —— 任务卡占 (16,60)-(316,156)，
	#   原先第一行 y=140 会被卡片盖住 16 px（几何回归实测）。
	#
	# 【2026-10-03 游戏外壳 · 按用途归位】使用者反馈「按钮越来越多」。这次不动九宫格的几何
	# （位置集合一个都没变，几何基线因此仍然成立），只把**谁坐哪个格子**按用途摆正：
	#   列1「步兵自身」兵种 / 姿势 / 换枪
	#   列2「载具」    弹种 / 上车 / 换座
	#   列3「火力·沟通」间瞄 / 烟雾 / 指令
	# 原先是散着的（换枪在列2、弹种在列3、间瞄在列1），三列各管一件事之后才找得着。
	# 每列再加一个颜色（下方 _tint），手机上认色比认字快。
	var _dy: float = GameConfig.HUD_BUTTON_CLUSTER_DY
	# 2026-10-02 真机修：CommandWheel 的 _ready 用的是 GameConfig 常量（不含 _dy），
	# 真机实测它落在 (272,186)：既比集群高 22 px，又正好被角色文字框（280,170 宽 500）压住 ⇒
	# 「指令」键点不开、轮盘在手机上根本看不到（几何基线里记为 CommandWheel|Role）。
	# 这里在 _dy 之后显式对齐到第三列（同 弹种 192,162 / 烟雾 192,254）。
	# 指令挪到列3 行3：口头/落点指令与火力支援同属「对外输出」
	command_wheel.position = Vector2(192.0, 232.0 + _dy)
	# 兵种按钮放左侧（右侧已被小地图/分数/地图按钮占满），点一下循环切兵种
	role_button = Button.new()
	role_button.name = "RoleButton"
	role_button.text = "兵种"
	role_button.size = Vector2(80.0, 40.0)
	role_button.position = Vector2(16.0, 140.0 + _dy)      # 列1 行1 步兵
	layer.add_child(role_button)
	_tint(role_button, GROUP_INFANTRY, "列1 步兵：切换兵种（docx 3.1）")

	role_label = Label.new()
	role_label.name = "Role"
	# 2026-10-02 真机修：原来在 (192,148+dy) —— 正好压在第三列（弹种 192,162 / 指令 192,208）上，
	# 真机上「指令」键因此点不开（截图里那个深色文字框就是它）。挪到第三列右侧（280）+ 限宽裁剪。
	role_label.position = Vector2(280.0, 148.0 + _dy)
	role_label.size = Vector2(500.0, 46.0)
	role_label.clip_text = true
	layer.add_child(role_label)
	update_role()

	# 姿势按钮（C2 站/蹲/卧）：点一下循环切换
	posture_button = Button.new()
	posture_button.name = "PostureButton"
	posture_button.text = "姿势"
	posture_button.size = Vector2(80.0, 40.0)
	posture_button.position = Vector2(16.0, 186.0 + _dy)   # 列1 行2
	layer.add_child(posture_button)
	_tint(posture_button, GROUP_INFANTRY, "列1 步兵：站 / 蹲 / 卧（C2）")

	# 间瞄按钮：直接开图并切到选点模式（省得玩家先开图再切开关）
	indirect_button = Button.new()
	indirect_button.name = "IndirectButton"
	indirect_button.text = "间瞄"
	indirect_button.size = Vector2(80.0, 40.0)
	# 间瞄从列1 挪到列3 行1：它是火力链的一环（7.4.2）
	indirect_button.position = Vector2(192.0, 140.0 + _dy)
	layer.add_child(indirect_button)
	_tint(indirect_button, GROUP_FIRE, "列3 火力：开图选间瞄落点（7.4.2）")

	# 烟雾（候选 P，docx 4.12）：步兵按下＝朝准心投一发烟雾弹；人在车里按下＝载具发烟器。
	# 放左侧第三列（x=192）的 y=232 行：右侧那一列被小地图 / 血量 / 地图键 / 报点轮盘占满，
	# 且报点轮盘展开半径 108 px，塞在它附近会被轮盘项抢触摸。本位置离摇杆触摸圈（r=144）227 px，安全。
	smoke_button = Button.new()
	smoke_button.name = "SmokeButton"
	smoke_button.text = "烟雾"
	smoke_button.size = Vector2(80.0, 40.0)
	# 烟雾挪到列3 行2：与间瞄同一列（都是火力/视野手段）
	smoke_button.position = Vector2(192.0, 186.0 + _dy)
	layer.add_child(smoke_button)
	_tint(smoke_button, GROUP_FIRE, "列3 火力：烟雾弹 / 载具发烟器（4.12）")

	# 爆破（2026-10-04 炸药 / 工程兵）：按一下在准心落点放，再按一下遥控起爆。
	# 位置 (700,340) 是拿 tools/hud_rects.gd 的实测输出挑的：3×3 集群（实际底界 294）与
	# 左下摇杆触摸圈（上沿 296）都满了，右侧 700..780 × 340..380 这块没有任何控件
	# （火力键 800,380 起、聚焦键 680,420 起、角色文字框止于 y=221），所以与既有一切无交集。
	explosive_button = Button.new()
	explosive_button.name = "ExplosiveButton"
	explosive_button.text = "爆破"
	explosive_button.size = Vector2(80.0, 40.0)
	explosive_button.position = Vector2(700.0, 340.0)
	layer.add_child(explosive_button)
	_tint(explosive_button, GROUP_FIRE, "炸药：准心落点放置 → 再按一次遥控起爆（工程兵携带 2 发）")

	# 换枪按钮（C3：切枪 1.04 s，期间不能开火）
	weapon_button = Button.new()
	weapon_button.name = "WeaponButton"
	weapon_button.text = "换枪"
	weapon_button.size = Vector2(80.0, 40.0)
	# 换枪从列2 挪到列1 行3：它管的是步兵自己的枪，不该和载具挤在一列
	weapon_button.position = Vector2(16.0, 232.0 + _dy)
	layer.add_child(weapon_button)
	_tint(weapon_button, GROUP_INFANTRY, "列1 步兵：换枪（C3，切枪期间不能开火）")

	# 上车 / 下车（8.1 舱室与座位）
	vehicle_button = Button.new()
	vehicle_button.name = "VehicleButton"
	vehicle_button.text = "上车"
	vehicle_button.size = Vector2(80.0, 40.0)
	vehicle_button.position = Vector2(104.0, 186.0 + _dy)
	layer.add_child(vehicle_button)
	_tint(vehicle_button, GROUP_VEHICLE, "列2 载具：上 / 下车（8.1）")

	# 换座位（8.1：驾驶位 ⇄ 武器位；只有武器位能开炮）
	seat_button = Button.new()
	seat_button.name = "SeatButton"
	seat_button.text = "换座"
	seat_button.size = Vector2(80.0, 40.0)
	seat_button.position = Vector2(104.0, 232.0 + _dy)
	layer.add_child(seat_button)
	_tint(seat_button, GROUP_VEHICLE, "列2 载具：驾驶位 ⇄ 武器位")

	# 弹种键：左侧第三列唯一剩下的空位 (192,140)。非载具状态下按它只会得到一句提示。
	ammo_type_button = Button.new()
	ammo_type_button.name = "AmmoTypeButton"
	ammo_type_button.text = "弹种"
	ammo_type_button.size = Vector2(80.0, 40.0)
	# 弹种从列3 挪到列2 行1：主炮 ⇄ 导弹是载具的事
	ammo_type_button.position = Vector2(104.0, 140.0 + _dy)
	layer.add_child(ammo_type_button)
	_tint(ammo_type_button, GROUP_VEHICLE, "列2 载具：主炮 ⇄ 反坦克导弹")

	# 瞄高键（docx 8.4.2 / 8.4.4 · 2026-10-05）：武器位一键切「炮塔 / 车体 / 弹药架 / 机动件」。
	# 位置 (700,292) 由 tools/hud_rects.gd 实测选出：在爆破键 (700,340) 正上方、
	# 离开火键 (800,380) 与聚焦键 (680,420) 都留白，与既有控件零交集。
	# 只在武器位显示（步兵 / 驾驶位 / 报废车都不出现）；枪手态的几何断言在集成冒烟里。
	aim_gear_button = Button.new()
	aim_gear_button.name = "AimGearButton"
	aim_gear_button.text = "瞄高"
	aim_gear_button.size = Vector2(80.0, 40.0)
	aim_gear_button.position = Vector2(700.0, 292.0)
	aim_gear_button.visible = false
	layer.add_child(aim_gear_button)
	_tint(aim_gear_button, GROUP_VEHICLE, "武器位：瞄高（炮塔 / 车体 / 弹药架 / 机动件）")
	layer.add_child(map_button)

	map_layer = CanvasLayer.new()
	map_layer.name = "MapLayer"
	map_layer.layer = 10
	add_child(map_layer)
	tactical_map = TacticalMap.new()
	tactical_map.name = "TacticalMap"
	map_layer.add_child(tactical_map)
	tactical_map.setup(main.grid, main.player, main.capture_zones, main.marks, main.quests,
			terrain_texture, main)

	# 4.16 被击倒时的视角：全屏去色灰罩 + 暗角 + 倒计时。放最后（盖住其它控件），但不吃触摸
	downed_overlay = DownedOverlayScript.new()
	downed_overlay.name = "DownedOverlay"
	layer.add_child(downed_overlay)
	downed_overlay.setup(main)

	victory_label = Label.new()
	victory_label.name = "Victory"
	victory_label.text = "胜利！\n点按屏幕重新开始"
	victory_label.position = Vector2(GameConfig.VIEWPORT_WIDTH * 0.5 - 80.0,
			GameConfig.VIEWPORT_HEIGHT * 0.5 - 20.0)
	victory_label.visible = false
	layer.add_child(victory_label)

	mini_map = MiniMap.new()
	mini_map.name = "MiniMap"
	layer.add_child(mini_map)
	mini_map.setup(terrain_texture, main.player, main.capture_zones, main.marks, main)
	mini_map.set_indirect(main.indirect)

	hp_label = Label.new()
	hp_label.name = "HP"
	# 2026-10-02 真机修：右列重排 162 / 186 / 210 / 234（原 162/182/184/188：血量与战局行贴身、
	# 地图键压住战局行 ⇒ 真机上倒计时被盖住看不见）
	hp_label.position = Vector2(GameConfig.VIEWPORT_WIDTH - 158.0, 8.0 + 150.0 + 28.0)
	layer.add_child(hp_label)

	ammo_label = Label.new()
	ammo_label.name = "Ammo"
	# 弹药标签挪到摇杆右侧：摇杆底座圆心 (100, 440)、半径 90，左下角是摇杆的地盘
	ammo_label.position = Vector2(216.0, GameConfig.VIEWPORT_HEIGHT - 30.0)
	layer.add_child(ammo_label)
	update_ammo()

	defeat_label = Label.new()
	defeat_label.name = "Defeat"
	defeat_label.text = "阵亡\n点按屏幕重新开始"
	defeat_label.position = Vector2(GameConfig.VIEWPORT_WIDTH * 0.5 - 80.0,
			GameConfig.VIEWPORT_HEIGHT * 0.5 - 20.0)
	defeat_label.visible = false
	layer.add_child(defeat_label)


## 每帧 HUD：血量（含压制）→ 准心（染色 / 朝向 / 压制抖动）→ 占领与兵种标签（0.25 s 节流）
## → 报点提示超时。
## 注：拆分前「占领/兵种标签」排在载具操炮之后，现在提前到同一帧的 HUD 阶段；
## 两者都是 0.25 s 节流刷新，观感无差别。
func tick(delta: float) -> void:
	if hp_label != null and main.player != null:
		# C2：值没变就不重建 String、不写 Label（三个输入见 _hp_last 附近的说明）
		# ⚠ `main` 是鸭子类型（无 class_name / 无类型标注）⇒ 这里**必须显式标注类型**，不能用 `:=`
		# （施工单 §9.3 的老坑：`main.player.suppression > 0.01` 推不出类型，会让整个 Main.gd 编译失败）。
		var hp_now: int = int(main.player.hp)
		var sup_on: bool = main.player.suppression > 0.01
		var sup_pct: int = int(main.player.suppression * 100.0)
		if hp_now != _hp_last or sup_pct != _hp_sup_pct_last or sup_on != _hp_sup_on_last:
			_hp_last = hp_now
			_hp_sup_pct_last = sup_pct
			_hp_sup_on_last = sup_on
			var text_now: String = "血量 %d" % hp_now
			if sup_on:
				text_now += " ｜ 压制 %d%%" % sup_pct
			hp_label.text = text_now
	update_crosshair()
	_capture_timer -= delta
	if _capture_timer <= 0.0:
		_capture_timer = 0.25
		update_capture()
		update_role()
	if _hint_timer > 0.0:
		_hint_timer = maxf(_hint_timer - delta, 0.0)
		if _hint_timer <= 0.0 and mark_hint != null:
			mark_hint.text = ""
	# 候选 O：播报倒计时（4.14）与操作提示（4.15）
	if feed != null:
		feed.tick(delta)
	if tips != null:
		tips.tick(delta)
	# 候选 O 第三轮：倒地视角（4.16）
	if downed_overlay != null:
		downed_overlay.tick(delta)


## 提示行：所有模块共用（原来叫 Main._show_mark_hint）
## seconds：默认 1.6 s（既有观感）；启动自检这类「必须让人看见」的提示可以给长一点
func show_hint(text: String, seconds: float = 1.6) -> void:
	if mark_hint == null:
		return
	mark_hint.text = text
	_hint_timer = seconds


## 战斗播报入口（docx 4.14）：各模块往 HUD 播报里塞一条（与 show_hint 同一套用法）
func push_feed(kind: String, text: String, color: Color = Color.WHITE) -> void:
	if feed != null:
		feed.push(kind, text, color)


## 操作提示总开关（docx 4.15「可在设置关闭」；设置界面后置，先给 API）
func set_tips_enabled(value: bool) -> void:
	if tips != null:
		tips.set_enabled(value)


# 刷新弹药 HUD。
func update_ammo() -> void:
	if ammo_label != null and main.player != null:
		ammo_label.text = "弹匣 %d/%d  备弹 %d" % [
			main.player.ammo_in_mag, main.player.mag_size, main.player.reserve_ammo]


# 开始换弹 → 显示换弹中。
func mark_reloading() -> void:
	if ammo_label != null:
		ammo_label.text = "换弹中…"


func update_score(score: int) -> void:
	if score_label != null:
		score_label.text = "战力分 %d" % score


## 战局状态行（候选 Q）：urgent = 加时中 / 最后 1 分钟，染成告警色
func set_match_status(text: String, urgent: bool = false) -> void:
	if match_label == null:
		return
	match_label.text = text
	match_label.add_theme_color_override("font_color",
			Color("ff6b5a") if urgent else Color(0.85, 0.88, 0.85))


func update_capture() -> void:
	if capture_hud == null or main == null:
		return
	var parts: Array[String] = []
	var players_inside := 0
	var enemies_inside := 0
	for zone in main.capture_zones:
		var capture_zone := zone as CaptureZone
		if capture_zone == null:
			continue
		if capture_zone.player_inside:
			players_inside += 1
		if capture_zone.enemy_inside:
			enemies_inside += 1
		if capture_zone.state == CaptureZone.State.BLUE:
			parts.append("蓝")
		elif capture_zone.state == CaptureZone.State.RED:
			parts.append("红")
		elif capture_zone.player_inside and capture_zone.enemy_inside:
			parts.append("对冲")  # 双方同在：进度不动（docx 4.2 白旗）
		elif absf(capture_zone.progress) > 0.01:
			var side := "我" if capture_zone.progress > 0.0 else "敌"
			parts.append("%s%d%%" % [side, int(absf(capture_zone.progress) * 100.0)])
		else:
			parts.append("灰")
	# 区内兵力：推不动时一眼看出是「对冲」（圈里有敌人）还是没人却不涨
	capture_hud.text = "节点  %s\n区内兵力  我 %d ｜ 敌 %d" % ["  ".join(parts),
			players_inside, enemies_inside]


## 爆破键文案随状态走（2026-10-07 第八十三版）：安放读条中 / 抛物飞行中 / 已落地待起爆。
## 值没变就不写（与 hp_label 同一条省法：Label 重写会触发重排与重绘）。
func _update_explosive_button() -> void:
	if explosive_button == null or main.explosive_ctl == null:
		return
	# main.explosive_ctl 是鸭子类型（Variant）：整条链推不出类型，显式标 String
	var label: String = "爆破"
	if bool(main.explosive_ctl.is_casting()):
		label = "安放中"
	elif bool(main.explosive_ctl.is_flying()):
		label = "飞行中"
	elif bool(main.explosive_ctl.is_armed()):
		label = "起爆"
	if explosive_button.text != label:
		explosive_button.text = label


## 兵种 / 武器 / 姿态 / 载具状态标签（载具里显示车体与装甲，步兵显示连发与散布）
func update_role() -> void:
	if role_label == null or main == null or main.player == null:
		return
	_update_explosive_button()
	var vehicle = main.vehicles.vehicle if main.vehicles != null else null
	# 瞄高键只在武器位显示（8.4.4）：步兵 / 驾驶位 / 报废车都不出现
	# vehicle 是鸭子类型（Variant）：这条链推不出类型，必须显式标 bool
	var gunner: bool = vehicle != null and vehicle.is_occupied() \
			and not bool(vehicle.destroyed) and vehicle.seat_of(main.player) == "gunner"
	if aim_gear_button != null:
		aim_gear_button.visible = gunner
		if gunner:
			aim_gear_button.text = "瞄高:%s" % VehiclePartsScript.gear_name(int(vehicle.aim_gear))
	if vehicle != null and vehicle.is_occupied():
		# 载具数据没读到（导出包里少了 data/vehicles_data.txt 就是这样）时别只显示 0/0 ——
		# 2026-10-01 真机上「车体 0/0 ｜ 余弹 0」被当成「正常车但开不了炮」，绕了一大圈才定位。
		if vehicle.data.is_empty():
			role_label.text = "⚠ 载具数据缺失：data/vehicles_data.txt 没读到（导出包要在 include_filter 里带上 data/*.txt）"
			return
		var seat_text := "武器位" if vehicle.seat_of(main.player) == "gunner" else "驾驶位"
		# 弹种（武器位一键切）：主炮 ⇄ 反坦克导弹；余弹显示的是**当前弹种**的可用数
		role_label.text = "%s（%s）｜ 弹种 %s %d/%d ｜ 瞄高 %s ｜ 车体 %.0f/%.0f ｜ 首上等效 %.0f mm" % [
			vehicle.vehicle_name(), seat_text, vehicle.ammo_type_name(),
			vehicle.selected_ammo(), vehicle.selected_total(),
			VehiclePartsScript.gear_name(int(vehicle.aim_gear)),
			vehicle.hp, vehicle.max_hp, vehicle.armor_summary("front")]
		return
	# 炸药余量（2026-10-04）：工程兵才 >0；读的是控制器实时算出的剩余，不另存一份
	# 2026-10-07 第八十三版：再带一段**状态**（安放中 xx% / 飞行中 / 待起爆），读条看得到进度
	var charges := 0
	var charge_state := ""
	if main.explosive_ctl != null:
		charges = main.explosive_ctl.remaining()
		if bool(main.explosive_ctl.is_casting()):
			charge_state = "（安放中 %d%%）" % int(float(main.explosive_ctl.cast_progress()) * 100.0)
		elif bool(main.explosive_ctl.is_flying()):
			charge_state = "（飞行中）"
		elif bool(main.explosive_ctl.is_armed()):
			charge_state = "（待起爆）"
	role_label.text = "%s ｜ %s ｜ 标记 %.0f s\n%s%s ｜ 连发 %d 发 ｜ 散布 ×%.2f ｜ 间瞄 %d 发 ｜ 爆破 %d 发%s" % [
		RoleTable.role_name(main.player_role), main.player.weapon_name(),
		RoleTable.mark_duration(main.player_role), main.player.posture_name(),
		"（依托）" if main.player.is_supported() else "",
		main.player.burst_shots(), main.player.effective_spread_moa() / GameConfig.WEAPON_MOA,
		0 if main.indirect == null else main.indirect.ammo, charges, charge_state]


## 聚焦开关：准心收窄 + 散布收紧 + 屏幕边缘暗角；画面不放大，全局视野不损失。
func apply_focus(on: bool) -> void:
	if _focusing == on:
		return
	_focusing = on
	if main.player != null:
		main.player.set_focus(on)
	if crosshair != null:
		crosshair.scale = Vector2.ONE * (GameConfig.FOCUS_CROSSHAIR_SCALE if on else 1.0)
	if vignette != null:
		vignette.visible = on


## 准心表现（每帧）：被地形挡住染橙色 + 程序生成的等腰三角形箭头始终指向射击方向
## 箭头尖端在纹理中心（＝屏心＝准心点），旋转轴因此落在尖端上
func update_crosshair() -> void:
	if crosshair == null or main == null or main.camera_controller == null:
		return
	crosshair.modulate = (Color(1.0, 0.62, 0.35)
			if main.camera_controller.blocked_by_terrain else Color.WHITE)
	if main.player == null:
		return
	# main 是鸭子类型（Variant）：显式标 Vector2，:= 推断不出来
	var aim: Vector2 = main.camera_controller.crosshair_world - main.player.global_position
	# 在载具上时玩家自己不动（位置还停在上车点），用「上车点→准心」算出来的是假方向，
	# 箭头就不再是顶角指向真实开火方向——武器位取炮塔朝向，驾驶位取车头朝向
	var vehicle = main.vehicles.vehicle if main.vehicles != null else null
	if vehicle != null:
		var seat: String = vehicle.seat_of(main.player)
		if seat == "gunner":
			aim = vehicle.turret_facing
		elif seat == "driver":
			aim = vehicle.hull_facing
	if aim.length_squared() <= 0.000001:
		return
	# 12.7.1：上半身随准星方向 —— HUD 每帧已经算好这个方向，顺势推给角色图（Main 不必插一行）
	main.player.set_aim_direction(aim)
	# 压制只晃「视觉」：真实射击方向仍取准心世界坐标，抖动不参与弹道
	# （docx 已判定抖准心＝抖镜头为负收益，所以幅度刻意做小且只在表现层）
	var jitter := 0.0
	if main.player.suppression > 0.01:
		jitter = deg_to_rad(GameConfig.SUPPRESSION_CROSSHAIR_JITTER_DEG) \
				* main.player.suppression * randf_range(-1.0, 1.0)
	crosshair.rotation = aim.angle() + jitter


func show_victory() -> void:
	if victory_label != null:
		victory_label.visible = true


func show_defeat(reason: String) -> void:
	if defeat_label != null:
		defeat_label.text = "%s\n点按屏幕重新开始" % reason
		defeat_label.visible = true


func set_vehicle_button_text(text: String) -> void:
	if vehicle_button != null:
		vehicle_button.text = text


## 游戏外壳（暂停菜单 / 结算屏）用：HUD 与战术地图两层一起收 / 放。
## 为什么收而不是叠：HUD 的控件平铺在同一层，暂停面板压上去会产生一堆「真实存在但没法修」
## 的重叠（几何门禁照样会报），而暂停时本来也不该点战斗键。世界仍渲染 ——
## 地形 / 单位是 Main 这个 Node2D 的子节点，不是 HUD 层的子节点。
func set_shell_visible(value: bool) -> void:
	if layer != null:
		layer.visible = value
	if map_layer != null:
		map_layer.visible = value


## 开关战术地图（docx 4.11.7 ①：地图不暂停游戏，但开图期间玩家不能移动 / 开火）
## 注意：冻结的复位只能靠 close_map 做——地图里那个「关闭」按钮也会关图，
## 那条路径不经过本函数（2026-09-28 bug：点地图内「关闭」后摇杆被永久锁死）。
func toggle_map() -> void:
	if tactical_map == null:
		return
	if tactical_map.is_open():
		close_map()
		return
	tactical_map.open()
	if main.player != null:
		main.player.input_locked = true
		main.player.release_joystick()  # 丢掉开图瞬间还按在摇杆上的触点，免得卡住


## 地图关闭的唯一出口：M 键、右侧地图按钮、地图里的「关闭」都汇到这里复位冻结
func close_map() -> void:
	if main != null and main.player != null:
		main.player.input_locked = false


func is_map_open() -> bool:
	return tactical_map != null and tactical_map.is_open()
