class_name GameConfig
extends RefCounted

## 《解域》第一版全局常量（唯一数值出口——禁止在其它脚本里写魔法数字）
## 依据：squad-2d/解域游戏.docx  0.全局基线 / 相机数值落地（确认稿）/ 12.2 补充（确认稿）/ 5.7 胜负判定决策
## 用法：GameConfig.FLAG_HOLD_TIME —— 纯常量类，不需要注册 autoload

# ────────────── 地图与高程网格 ──────────────
const GRID_WIDTH := 1000          # 格
const GRID_HEIGHT := 1000         # 格
const CELL_SIZE := 1.0            # m／格（1 格严格 = 1 m）
const MAX_ELEVATION := 150.0      # m，12.2 补充确认（丘陵草原）
## 地形高度容差：按文档 12.2 补充的口径取 0.3 m（严格）。
## 历史：曾因真机「准心老是被挡住」临时放宽到 1.0 并叠加随距离容差；
## 2026-09-28 用户要求恢复文档严格口径，故回到 0.3，下面两项一并归零。
const SIGHT_MARGIN := 0.3
## 准心瞄准专用的放宽开关（文档口径＝严格，故为 0）：
## 调试想放宽时把 MARGIN_PER_METER 调到 0.02、NEAR_EXEMPT 调到 10.0 即可。
const CROSSHAIR_SIGHT_MARGIN_PER_METER := 0.0
const CROSSHAIR_SIGHT_NEAR_EXEMPT := 0.0  # m，准心离玩家这么近时不判地形遮挡
const MAX_SLOPE_DEG := 30.0       # 度，超过不可通行（12.8.5 ⑤ 候选值）
const DEFAULT_MAP_SEED := 20260101  # grassland_demo 示例地图种子（12.8.4）

# ────────────── 自制地图（工具链 A：灰度高度图导入）─────────────
## 空字符串 = 用上面的噪声地形；填了路径则优先导入该高度图（导入失败会退回噪声并报错）
## 约定：黑 = 0 m、白（255）= MAX_ELEVATION；尺寸必须与网格一致（1000×1000），不缩放
const MAP_HEIGHT_IMAGE := "res://assets/maps/map_demo_height.png"
const MAP_HEIGHT_DIR := "res://assets/maps/"  # 自制高度图默认存放目录

# ────────────── 画布与缩放 ──────────────
const VIEWPORT_WIDTH := 960       # 逻辑分辨率（横屏，已确认）
const VIEWPORT_HEIGHT := 540
## 三档缩放档位：Camera2D.zoom 直接就是"每米多少像素"（px/m）。
## 默认 1 world unit = 1 屏幕像素，zoom 放大 N 倍 = 1 unit 显示 N px。
## 32 / 16 / 8 px每米 ⇒ 960 px 屏幕可视 30 / 60 / 120 m（docx 相机数值落地）
const ZOOM_LEVELS := [32.0, 16.0, 8.0]
const DEFAULT_ZOOM_INDEX := 1

# ────────────── 相机与准心（照抄 fight-2 实现）──────────────
# 核心规则：准心 = 屏幕中心 = 相机中心，三者恒等，无死区
const CAMERA_SMOOTH_SPEED := 12.0        # lerp 系数，无死区
const CROSSHAIR_CLAMP_OFFSET := 1.0      # m，被挡回退量
const SIGHT_MAX_DISTANCE_INFANTRY := 500.0   # m，步兵拖拽上限
const SIGHT_MAX_DISTANCE_VEHICLE := 1500.0   # m，坦克拖拽上限（8.2）

# ────────────── 通视检测（4.7 三级递进）─────────────
const SCREEN_BOX_MARGIN := 240.0  # px，①框检测：屏幕框外一律不显示
const OCCLUDER_GROUP := "occluder"      # ②③ 掩体层：可破坏 / 移动 / 实体墙

# ────────────── 步兵 ──────────────
const SOLDIER_SPEED := 5.0        # m/s，第一版先给个能跑的值，真机再调
const SOLDIER_EYE_HEIGHT := 1.6   # m，视线起点高度（眼高）
const SOLDIER_HEIGHT := 1.8       # m，目标高度（通视/命中判定用）
const SOLDIER_HP := 100.0
## C2 确认值：判定用 0.6 m × 0.4 m 的矩形（视觉占位才放大到 1.0 × 0.6）。
## 这里用半径 0.3 的圆近似该矩形——原来写 0.6（直径 1.2 m）等于判定面积是文档的 4 倍，
## 散布再大也几乎枪枪命中（2026-09-28 真机反馈「命中率不受散布影响」，根因就在这）
const ENEMY_HIT_RADIUS := 0.25    # m，弹丸命中判定的半径（所有人的子弹共用）
## 敌人基础散布：按同一把武器口径取 3 MOA（不给的话敌人是零散布直射，远距离比玩家还准）
const ENEMY_BASE_MOA := 3.0
## 敌方伤害总开关：0.0 = 敌人打不掉任何血（调试用），1.0 = 正式数值。
## 2026-09-30 按拍板改回 1.0 —— 调试值留在工作区会被误判成「敌人 AI 坏了」。
## 出口三处：步兵在 Enemy._try_fire 打玩家、敌人打掩体耐久、载具主炮在 Vehicle，三处都乘它。
## 注意：压制不随它归零（准心仍会抖、HUD 仍显示压制值），因为压制不是伤害。
const ENEMY_DAMAGE_SCALE := 1.0
## 敌人**载具主炮**伤害倍率。1.0 = 正式数值。
## 🧪 想开「坦克打不掉血」的测试态：把下面这行改成 0.0 —— 坦克照常开炮（火光 / 曳光 / 炮声 / 炮塔后坐 /
## 命中闪白 / 屏幕震动都在），但一炮都不掉血。只作用于载具；要连步兵一起关，用上面的 ENEMY_DAMAGE_SCALE。
## ⚠ 测完改回 1.0：调试值留在工作区会被误判成「敌人 AI 坏了」（2026-09-30 踩过这坑）。
const ENEMY_VEHICLE_DAMAGE_SCALE := 1.0
## 与压制散布叠加

# ────────────── 弹道（7.4.2 确认稿）─────────────
const GRAVITY_EFFECTIVE := 9.81 * 2.8  # m/s²，g_eff = g0 × 2.8
const BALLISTICS_STEP := 1.0           # m，弹道表按水平距离 1 m 采样
const BALLISTICS_DT := 0.01            # s，离线积分步长（表由此生成）
const DEFAULT_DRAG_DECEL := 30.0       # m/s²，阻力＝常数减速度（可由武器覆盖）
const DEFAULT_DRAG_DURATION := 2.0     # s，阻力作用时长
const TRACER_SPEED := 300.0            # m/s，曳光表现速度（仅视觉）
const MUZZLE_VELOCITY := 900.0         # m/s，第一版默认步枪初速
const FIRING_ELEVATION := 0.0          # rad，枪口仰角（直瞄统一 0，docx 7.4.2）

# ────────────── 武器数据（7.2 确认稿，5.8mm 制式步枪 A / QBZ-191）─────────────
const WEAPON_MAG_SIZE := 30              # 发，弹匣容量
const WEAPON_RESERVE := 120              # 发，备弹总量
const WEAPON_RPM := 750.0                # 发/分，射速
const WEAPON_RELOAD_TACTICAL := 4.28     # s，战术换弹（弹匣有残弹）
const WEAPON_RELOAD_EMPTY := 4.85        # s，空仓换弹
const WEAPON_SWITCH_TIME := 1.04         # s，切枪时间（C3 动作时间基线：全枪族对标值）
## 按文档口径取现实值 3 MOA（7.2 / 7.5）：100 m 只散 ±8.7 cm、300 m ±26 cm——
## 近距指哪打哪、远距才靠点射与点射纪律，这就是设计意图。2026-09-28 曾为「手感明显」
## 临时放大到 6 MOA，用户拍板改回文档值：别再动它（断言 test_spread_scale_is_realistic 守着）
const WEAPON_MOA := 3.0                  # 角分散布（1 MOA ≈ 1 英寸 @ 100 码）
const WEAPON_DAMAGE_BASE := 62.0         # 基础伤害（衰减起点内）
const WEAPON_DAMAGE_MIN := 35.0          # 最低伤害（衰减终点外）
const WEAPON_DAMAGE_FALLOFF_START := 60.0  # m，伤害开始衰减
const WEAPON_DAMAGE_FALLOFF_END := 300.0   # m，伤害衰减到最低
const WEAPON_MAX_RANGE := 400.0            # m，直瞄最大射程（5.8mm 制式步枪 A 游戏射程，CSV）

# ────────────── 散布动静二分与聚焦（第十八章 步兵武器操纵性 + 聚焦模式确认稿）─────────────
## 步兵不做后坐力/四姿态晃动，收敛为「散布 MOA + 动/静二分」。
const WEAPON_SPREAD_MOVE := 2.5        # 倍，移动中散布倍率（相对基础 MOA）
const WEAPON_SPREAD_STILL := 1.0       # 倍，站定散布倍率
const MOVE_SPEED_EPSILON := 0.5        # m/s，判定"在移动"的速度阈值
## 聚焦模式（取消开镜）：按住收窄准心、降散布、屏幕边缘暗角，不损失全局视野。
const FOCUS_SPREAD_SCALE := 0.5        # 倍，聚焦时散布倍率
const FOCUS_CROSSHAIR_SCALE := 0.45    # 倍，聚焦时准心半径收窄比
const FOCUS_VIGNETTE_ALPHA := 0.55     # 聚焦时屏幕边缘暗角不透明度

# ────────────── 任务系统（4.10 SMEAC / 4.10.10 奖励 / 4.10.11 模板池）─────────────
const TASK_REWARD_CAPTURE := 40     # 分，主线「占领节点」全队战力分（4.10.10 确认稿）
const TASK_CARD_POS_X := 16.0       # px，任务卡片屏幕位置（左上，占领 HUD 下方）
const TASK_CARD_POS_Y := 60.0
const TASK_CARD_WIDTH := 300.0
const TASK_CARD_HEIGHT := 96.0
const TASK_COMPLETE_FLASH := 2.0    # s，完成后卡片高亮「任务完成 +N」的时长

# ────────────── HUD 层间距（第四十一版补丁9 收尾 · 几何回归）──────────────
## 左侧 3×3 按键集群整体下移量。
## 起因：任务卡占 (16,60)-(316,156)，而按键第一行原先在 y=140 ⇒ 卡片盖住第一行 16 px。
## （同类问题真机反馈过一次：指令轮盘向左展开压住中间那列，见第四十一版补丁9。）
## 下移 22 ⇒ 第一行 y=162，与卡片底边留 6 px；最下一行 y=254..294，
## 仍在左下摇杆触摸区（y≥420）之上，不产生新的重叠。
const HUD_BUTTON_CLUSTER_DY := 22.0
## 战斗播报与顶部操作说明行之间的竖向间距。
## 起因：说明行在 y=12、高 23（底 35），播报原先在 y=34 ⇒ 压住 1 px。
## 下移 4 给一个稳的间隔，而不是「差 1 px 不重叠」。
const HUD_FEED_TOP_GAP_DY := 4.0

# ────────────── 战术地图全屏（docx 4.11.1 图层 / 4.11.3 操作 / 4.11.7 确认稿）─────────────
## 不暂停游戏（覆盖层），但开图期间由 Main 冻结移动与开火；固定朝北不旋转
const TACTICAL_ZOOM_LEVELS := [0.5, 0.9, 1.6]   # px/m，全图 → 局部 → 细节
const TACTICAL_PRESS_SLOP := 8.0               # px，位移小于它才算「点位置落标记」
const TACTICAL_MAP_BUTTON_SIZE := 96.0         # px，屏幕上的「地图」按钮边长
const TACTICAL_TYPE_BUTTON_WIDTH := 84.0       # px，底部类型选择按钮
const TACTICAL_TYPE_BUTTON_HEIGHT := 40.0
const TACTICAL_BG_ALPHA := 0.72                # 地图背景遮罩不透明度（下面还有游戏在跑）

# ────────────── 报点 / 标记（docx 4.11.2 信息分层 / 4.11.7 确认稿）─────────────
## 三条红线：通视前提（落点取准心，准心本身已被地形钳制）、最后目击位置（标记不跟随目标）、
## 有时效（普通报点 30 s；侦察兵 90 s 属兵种特权，第一版不做）
const MARK_DURATION := 30.0        # s，普通报点时效
const MARK_SCOUT_DURATION := 90.0  # s，侦察兵标记时效（docx 4.11.4 确认稿）
const MARK_REFRESH_RADIUS := 5.0   # m，同类型且在此半径内视为「再次报点」→ 刷新时效
const MARK_BUTTON_SIZE := 120.0    # px，报点键尺寸（放右下角，最易触达）
const MARK_WHEEL_RADIUS := 108.0   # px，环形菜单半径
const MARK_ITEM_WIDTH := 84.0      # px，菜单项尺寸（测试与布局共用，别写两遍）
const MARK_ITEM_HEIGHT := 44.0
const MARK_ICON_RADIUS := 6.0      # m，主视图标记圆点半径

# ────────────── 快捷指令（docx 4.13 局内对话设置，候选 O 第二轮）─────────────
## 按键放左侧，**第三列右侧**（x=272 / y=186）：右侧已被小地图 / 地图键 / 报点轮盘占满；
## 不能再放 x=192 —— 那里与 3×3 按钮集群的第三列、以及兵种文字行（Role）水平重叠。
## 第四十一版补丁9 收尾实测：轮盘展开后与 Role / AmmoTypeButton 各有 33 / 16 px 重叠，
## 移到 x=272 后两者皆清（轮盘项按 clamp 保证不出屏，见 command_test 的两条断言）。
const COMMAND_BUTTON_X := 272.0
const COMMAND_BUTTON_Y := 186.0
const COMMAND_BUTTON_WIDTH := 80.0
const COMMAND_BUTTON_HEIGHT := 40.0
## 环形菜单的半径与菜单项尺寸直接复用报点轮盘的那一套（MARK_WHEEL_RADIUS / MARK_ITEM_*）：
## 同一套手感参数，不另抄一份数值。
const COMMAND_GLOBAL_COOLDOWN := 1.5   # s，任意两条指令之间的公共冷却（防连点刷屏）
const COMMAND_COOLDOWN := 6.0          # s，同一条指令的冷却

# ────────────── 被击倒与倒地视角（docx 4.16，候选 O 第三轮）─────────────
## 4.16 原文：倒地超时（默认值 60 s，待实测）转为阵亡 —— 这里就是那个默认值
const DOWNED_TIMEOUT := 60.0
## s，敌人倒地后的流血时间（比玩家的 60 s 短：AI 会互相补刀，拖太久看着像卡住）
const ENEMY_DOWNED_TIMEOUT := 30.0
## 被扶起后的血量（4.16 的队友救援路径；第一版单机没有队友，数值待实测）
const DOWNED_REVIVE_HP := 25.0
## 画面表现：全屏灰罩（「去色」的近似，本项目零 shader）+ 复用聚焦那套暗角贴图
const DOWNED_GRAY := Color(0.42, 0.45, 0.50)
const DOWNED_VEIL_ALPHA := 0.62

# ────────────── 环境互动区（docx 4.17，候选 O 第四轮）─────────────
## 地形内容层：高程网格只有高度、没有材质，所以泥泞 / 雪地 / 草丛先用独立圆形区域表达
const TERRAIN_ZONE_GROUP := "terrain_zone"
const TERRAIN_ZONE_RADIUS := 24.0         # m，区域默认半径
const TERRAIN_MUD_SPEED_SCALE := 0.70     # 泥泞：移速 ×0.70
const TERRAIN_SNOW_SPEED_SCALE := 0.55    # 雪地：移速 ×0.55
const TERRAIN_GRASS_CONCEAL := 0.35       # 草丛：敌人发现距离 −35%
const TERRAIN_GRASS_PRONE_BONUS := 0.20   # 卧姿再加一档（呼应 C2 的「矮掩体」属性）
const TERRAIN_CONCEAL_MAX := 0.60         # 隐蔽度上限：隐蔽＝更难被发现，不是隐身
## 掩体互动（4.17）：贴着掩体但不聚焦＝缩在掩体后（暴露面积打折）；按住聚焦＝探头（暴露回满）
const COVER_HUG_RANGE := 1.5              # m，算作「贴着掩体」的距离
const COVER_HUG_EXPOSURE := 0.5           # 缩在掩体后的命中面积倍率

# ────────────── 表现层：阴影 / 枪口火光 / 命中特效 / 受击闪白 / 屏幕震动（候选 M · 12.3 / 12.7）──
## 12.3 Blob Shadow：脚底一个扁椭圆，不随身体转动；越高越小越淡（滞空），全场景统一光照偏移
const BLOB_SHADOW_COLOR := Color(0.0, 0.0, 0.0)
const BLOB_SHADOW_RADIUS := 0.55          # m，默认阴影半径（角色会按身体尺寸再乘一档）
const BLOB_SHADOW_BODY_SCALE := 1.30      # 阴影半径 ＝ 身体半径 × 此值
const BLOB_SHADOW_SQUASH := 0.55          # 椭圆压扁比（Y/X）——12.3 的「扁椭圆」
const BLOB_SHADOW_ALPHA := 0.42           # 贴地时的不透明度
const BLOB_SHADOW_HEIGHT_SCALE := 0.80    # 离地每 1 m 缩小 / 变淡多少（12.3「滞空时缩小变模糊」）
const BLOB_SHADOW_MIN_SCALE := 0.35       # 缩小下限，别缩成一个点
const BLOB_SHADOW_LIGHT_DEG := 135.0      # 度，全局光照方向（12.3「统一微调」，不做逐光源计算）
const BLOB_SHADOW_LIGHT_OFFSET := 0.18    # m，阴影沿光照方向的统一偏移
## 12.7.3 枪口火光：开火瞬间闪一下
const MUZZLE_OFFSET := 0.60               # m，枪口相对身体中心的距离
const MUZZLE_FLASH_LIFETIME := 0.06       # s，2~4 帧
const MUZZLE_FLASH_LENGTH := 0.90         # m
const MUZZLE_FLASH_WIDTH := 0.50          # m
const MUZZLE_FLASH_COLOR := Color(1.0, 0.86, 0.45)
## 12.7.4 命中特效：火花 + 扩散环
const IMPACT_FX_LIFETIME := 0.22          # s
const IMPACT_FX_SPARKS := 6               # 火花条数（确定性方向，不用 randf）
const IMPACT_FX_SPARK_LENGTH := 0.55      # m
const IMPACT_FX_RING_RADIUS := 0.75       # m
## 12.7.4 受击闪白 + 轻微屏幕震动
const HIT_FLASH_TIME := 0.09              # s，闪白时长
const HIT_FLASH_ALPHA := 0.65             # 闪白圆周的不透明度（按剩余时间衰减）
const SCREEN_SHAKE_TIME := 0.18           # s，每次受击的抖动时长
const SCREEN_SHAKE_STRENGTH := 0.35       # m，抖动幅度（俯视 2D 下很小的位移）

# ────────────── 音效（docx 第十章，候选 M · 第二轮）─────────────
## 工程没有任何音频资产 ⇒ 第一版用程序生成的 PCM（systems/audio/ProceduralAudio.gd）
const SFX_MIN_INTERVAL := 0.045   # s，同一种音效的最小间隔（连发时别糊成一片）
const SFX_MAX_VOICES := 4         # 每种音效的并发声部数（轮换复用，避免声部爆炸）
const SFX_SAMPLE_RATE := 22050    # Hz，移动端够用（样本量是 44100 的一半）

# ────────────── 角色图：12.7.1 上下半身分离（候选 M · 第三轮）─────────────
## 第一版没有帧资源 ⇒ 用程序绘制的 Lower / Upper 替代精灵帧；腿的交替由相位驱动（等价走 / 跑节奏）
const FIGURE_STRIDE_HZ := 1.5             # 次/秒，全速前进时的步频（相位推进速率）
const UNIT_COLOR_PLAYER := Color(0.310, 0.616, 0.878)   # ＝ 旧圆点贴图色 #4f9de0
const UNIT_COLOR_ENEMY := Color(0.851, 0.326, 0.310)    # ＝ 旧圆点贴图色 #d9534f

# ────────────── 载具动画（docx 12.7.2，候选 M · 第四轮）─────────────
## 履带滚动：相位 ＝ 跑过的距离（m），停车即冻结；报废后冻结 + 变黑（M-kill 的等效表现）
const VEHICLE_TRACK_SPACING := 0.62       # m，履带齿间距
const VEHICLE_TRACK_WIDTH := 0.34         # m，履带宽度
const VEHICLE_TRACK_COLOR := Color(0.16, 0.16, 0.16, 0.95)
const VEHICLE_TRACK_WRECK_COLOR := Color(0.10, 0.09, 0.08, 0.95)
const VEHICLE_TRACK_TOOTH_COLOR := Color(0.55, 0.55, 0.52, 0.55)
## 报废后的炮管：俯视 2D 画不出「下垂」，用「变黑 + 缩短」等效（12.7.2 F-kill 的取舍，登记在 20.5）
const VEHICLE_WRECK_BARREL_SHRINK := 0.15
const VEHICLE_WRECK_BARREL_COLOR := Color(0.30, 0.28, 0.26, 0.95)
## 残骸冒烟（K-kill 的「持续冒烟」）
const VEHICLE_SMOKE_PUFFS := 5            # 烟团数
const VEHICLE_SMOKE_RADIUS := 1.6         # m，烟团最大半径
const VEHICLE_SMOKE_RISE := 2.2           # m，向外扩散 / 上飘的视觉量
const VEHICLE_SMOKE_LIFETIME := 3.6       # s，一个烟团从生到灭

# ────────────── 载具（docx 第八章 8.1 舱室与座位 / 8.2 武器与装甲）─────────────
## 第一版只做「能上车 / 能开炮 / 装甲能挡弹」；炮塔回正与弹簧模型（8.2.6）后置
const VEHICLE_NON_PEN_DAMAGE_SCALE := 0.05  # 未击穿时只吃 5% 伤害（装甲的主要意义）
const VEHICLE_HIT_RADIUS_SCALE := 0.5       # 命中判定半径 = 车长 × 此值
const VEHICLE_BOARD_RANGE := 9.0            # m，离载具多近能上车
## 步兵弹穿深（mm RHA）：5.8mm 步枪弹 ≈ 12、9mm 手枪 ≈ 3——用来对装甲做击穿判定。
## 官方武器表没有穿深列，这里是公开近似值（第一版只需「步枪弹打不穿步战车侧甲 45 mm」这条成立）
const SOLDIER_BULLET_PENETRATION_MM := 12.0
const PISTOL_BULLET_PENETRATION_MM := 3.0

# ────────────── 载具炮塔（docx 8.2.6 炮塔手感：后坐力 / 炮塔回正 / 弹簧模型）─────────────
## 文档明确把这三件套从步兵迁给载具炮塔：炮管是看得见、抖得起的视觉载体
const TURRET_ROTATE_SPEED := 45.0        # 度/秒，炮塔最大转向速率（8.2.6 默认值待实测）
const TURRET_RECENTER_STIFFNESS := 1.8   # 回正弹簧刚度（越大回正越快）
const TURRET_RECENTER_DAMPING := 0.7     # 回正阻尼（0~1，越大越不摆）
const ATGM_TRACER_COLOR := Color(1.0, 0.45, 0.25, 0.95)  # 反坦克导弹尾迹色（与机炮曳光区分）
const TURRET_RECOIL_DECAY := 4.0         # /s，后坐视觉量衰减
const TURRET_RECOIL_OFFSET := 1.2        # m，开火瞬间炮塔后座位移（纯视觉）
const VEHICLE_AI_RANGE := 900.0          # m，敌方载具发现玩家的距离
const VEHICLE_AI_INTERVAL_SCALE := 3.0   # 倍，AI 开火间隔 = 炮间隔 × 此值（AI 打得更慢）
const VEHICLE_AI_AIM_TOLERANCE_DEG := 5.0  # 度，炮口对准到这个容差内才开火

# ────────────── 间瞄火力（docx 7.4 闭式解 + 4.11.3 地图选落点 + 4.11.4 侦察兵标记当靶点）─────────────
## 第一版解算就用带阻力模型（docx 7.4.2 定标：常数减速度 −30 m/s² 持续 2 s + g_eff 2.8 倍），
## 7.4 的无阻力闭式解降级为校验基准（工具与测试用它互校）
## 初速按最大射程反标定：g_eff 是 2.8 倍重力、又叠加常数减速度阻力，
## 要打到 INDIRECT_MAX_RANGE 400 m 就得给足初速（现实 60 mm 迫击炮 ~110 m/s，这里 180）
const INDIRECT_MUZZLE_VELOCITY := 180.0   # m/s，间瞄初速（按射程反标定，不是现实值）
const INDIRECT_MIN_RANGE := 60.0          # m，最小射程（太近不打）
const INDIRECT_MAX_RANGE := 400.0         # m，最大射程
const INDIRECT_FLIGHT_MAX := 12.0         # s，飞行时间上限（解算兜底）
const INDIRECT_BLAST_RADIUS := 10.0       # m，爆炸半径
const INDIRECT_BLAST_DAMAGE := 90.0       # 爆心伤害
const INDIRECT_BLAST_MIN_DAMAGE := 25.0   # 边缘伤害（半径处，线性衰减）
const INDIRECT_AMMO := 4                  # 发，第一版固定 4 发
const INDIRECT_COOLDOWN := 3.0            # s，发射间隔
const INDIRECT_SNAP_RADIUS := 12.0        # m，间瞄落点吸附到报点标记的半径（4.11.4 杀伤链）
## 间瞄（榴弹炮 / 迫击炮）对**建筑**的结构伤害（弹种口径，2026-10-03 拍板）。
## 取 420 = data/vehicles_data.txt 里 155mm 自行火炮 sph 的 gun_structure_damage ——
## 间瞄就是那条炮打出去的，所以同一个数。玩家没有「自己那一行」可查时用这个值兜底。
const INDIRECT_STRUCTURE_DAMAGE := 420.0

# ────────────── 掩体与依托（docx 4.7 第③级检测 · C2 矮掩体与架枪/依托）─────────────
## 第一版掩体是轴对齐矩形（沙袋/矮墙），只挡通视、不挡子弹（已知取舍，子弹穿掩体留待后续）
const COVER_SANDBAG_HALF_X := 3.6       # m，沙袋矩形半宽
const COVER_SANDBAG_HALF_Y := 1.1       # m，沙袋矩形半长
const COVER_SANDBAG_HEIGHT := 1.1       # m，沙袋顶高（站姿眼高 1.6 m 能看过，卧姿看不出去）
const COVER_HP := 200.0                # 掩体耐久：玩家近距 62 伤害 → 4 发打坏（榴弹/机枪后续再调）
## 掩体三段耐久（2026-10-03 使用者拍板）：耐久比掉到这条线以下算「受损」，顶高按下面的比例缩。
## 为什么是 0.70 / 0.45：62 伤害打 200 耐久 ⇒ 第 2 发就进受损档（有中间态、不是「要么完好要么没」）；
## 0.45 的顶高让 1.1 m 沙袋降到约 0.5 m，正好与 PRONE_SIGHT_HEIGHT 同档
## ——「受损后卧姿能看过」是一条可读、可解释的边界。
const COVER_DAMAGED_BELOW_RATIO := 0.70
const COVER_DAMAGED_HEIGHT_SCALE := 0.45
## 掩体破坏后留下的贴地残痕（4.17 破坏互动：留残痕 + 小减速，不影响通视）
const RUBBLE_SPEED_SCALE := 0.70        # 与泥泞同档（瓦砾 ＝ 脚下不利索）
const RUBBLE_RADIUS_SCALE := 1.25       # 残痕半径 = 掩体最长边 × 这个系数
const RUBBLE_LIFETIME := 0.0            # s，0 ＝ 留到本局结束
## 建筑结构值锚点（2026-10-03 拍板「标准档 1200」，与 FOB 的结构值同档）：
## 主炮 125mm 对建筑伤害 280 ⇒ 5 发拆一栋；30mm 机炮 45 ⇒ 27 发（基本打不掉）；
## 而普通子弹对建筑伤害恒为 0（见 data/weapons_data.txt 的 structure_damage 列）。
const STRUCTURE_HP_SMALL := 800.0       # 小屋 / 哨所
const STRUCTURE_HP_HOUSE := 1200.0      # 标准建筑（锚点）
const STRUCTURE_HP_REINFORCED := 3000.0 # 加固 / 多层（困难模式与后续版本用）
## 爆炸对建筑的结构伤害**衰减系数**：爆心给满，半径处按这个比例收尾。
## 取 0.35 而不是对人也用的「25/90 ≈ 0.28」：炮击有 10 m 半径散布，衰减太狠会让
## 「打偏一点就毫无意义」；拆楼靠的是落在附近，不是正中。
const BLAST_STRUCTURE_FALLOFF := 0.35
const COVER_SIGHT_SLACK := 0.15         # m，视线高度需高出掩体顶这么多才算「看得过去」
const PRONE_SIGHT_HEIGHT := 0.6         # m，卧姿视线高度（C2「矮掩体」：少 1 m 看不到东西）
const SUPPORT_RANGE := 2.5              # m，离掩体多近算「依托/架枪」
const SUPPORT_SPREAD_SCALE := 0.7       # 依托额外精度档（C3：架枪/依托提供一档精度）

# ────────────── FOB（前进作战基地 / 工事，docx 4.10.11 T-S2「摧毁敌方 FOB」）─────────────
## 第一版只做「敌方 FOB」：它是个大目标（子弹 / 车载炮 / 间瞄爆炸都吃伤害），结构值打光即摧毁，
## 摧毁时发 wrecked 信号（任务系统订阅它推进 T-S2）。
## 「暴露」判定（官方触发条件「敌方 FOB 被标记暴露」）：FOB 附近要有未过期的阵地/补给报点，见 QuestSystem。
const FOB_MAX_HP := 1200.0            # 结构值：步枪 62 伤 → 约 20 发；间瞄爆心 90 → 约 14 发；载具主炮 400 → 3 发
const FOB_HIT_RADIUS := 3.0           # m，弹道命中半径（大目标，别套步兵的 0.25）
const FOB_HALF_X := 5.0               # m，占地半宽（画面上是 10 × 7 的工事）
const FOB_HALF_Y := 3.5
const FOB_EXPOSE_RADIUS := 60.0       # m，报点落在这个范围内才算「FOB 被标记暴露」

# ────────────── 补给车（docx 4.10.11 T-S5「护送补给至前线」）─────────────
## 第一版补给车不可被击毁、也不吸引敌人火力——官方表给 T-S5 的失败条件只有「超时」。
const SUPPLY_SPEED := 4.0              # m/s，比步兵（5.0）慢一点：护送者跟得上，也能提前清路
const SUPPLY_ARRIVE_RADIUS := 15.0     # m，进这个半径算「抵达指定节点」（＝占领区半径）

# ────────────── 侧翼通路（docx 4.10.11 T-S6「守住侧翼通路」）─────────────
## 第一版：一条直线通路，敌人在入口放穿插兵、沿通路推进到出口；玩家在时限内拦住他们。
## 官方达成＝「时限内阻止敌人通过该通道」，所以它是「守住型」任务：拖到时限到点也算达成（见 QuestSystem）。
const LANE_HALF_WIDTH := 25.0          # m，通路半宽（50 m 宽的走廊，够两三个人侧身通过）
const LANE_INFILTRATORS := 3           # 个，一次派出的穿插兵数量（第一版固定）
const LANE_INFILTRATOR_SPEED := 2.6    # m/s，比普通敌人（2.0）快一点——穿插就该有点紧迫感

# ────────────── 烟雾与遮蔽（docx 4.12 + 4.12.8 确认稿，候选 P）─────────────
## 烟雾＝临时 Occluder：通视判定遇到它就判「被遮挡」，等价于一面不透明墙；
## 但它不阻挡子弹与单位移动（4.12.6），所以**不进 OCCLUDER_GROUP**——那个组同时被
## 「子弹截断（SightSystem.first_cover）」用，混进去会让子弹被烟挡住。
## 五项参数全部取 4.12.8 确认稿：半径 10 m / 高 3 m / 持续 25 s / 触发即生效 / AI 盲射 −70%。
const SMOKE_GROUP := "smoke"              # 烟雾节点所在组（SightSystem 单独遍历它）
const SMOKE_RADIUS := 10.0                # m，单发覆盖半径（4.12.8 ①）
const SMOKE_HEIGHT := 3.0                 # m，烟高：遮住坦克 2.5~3 m 观察高度，飞机 / 高处仍可越过（4.12.8 ②）
const SMOKE_DURATION := 25.0              # s，持续时间、触发即生效、多发可叠加（4.12.8 ③）
const SMOKE_BLIND_FIRE_HIT_SCALE := 0.3   # 倍，AI 朝最后已知位置盲射的命中率（＝下降 70%，4.12.8 ④）
const SMOKE_BLIND_FIRE_WINDOW := 10.0     # s，「最后已知位置」的有效期：太久没见就放弃盲射
const SMOKE_GRENADE_COUNT := 2            # 发，步兵携带的烟雾弹（第一版固定，不做补给）
const SMOKE_VEHICLE_COUNT := 1            # 次，载具发烟器（8.3 的落地：一局一次，下车不恢复）
const SMOKE_DRAW_SEGMENTS := 24           # 画烟饼用的圆周分段数

# ────────────── 连发散布与姿势（docx 7.3 连发扩大/点射收敛 · C2 姿态 · C3 姿势精度）─────────────
## 连发：按住连发逐发扩大，停火后逐发收敛（点射纪律的落地）
const BURST_SPREAD_PER_SHOT := 0.12   # 每多发一发的散布增量（相对基础 MOA）
const BURST_SPREAD_MAX := 2.2         # 连发散布倍率上限（×2.2）
const BURST_MAX_SHOTS := 12           # 连发计数上限，再打也不涨
const BURST_RESET_TIME := 0.35        # s，停火超过它才开始收敛
const BURST_DECAY_INTERVAL := 0.08    # s，收敛节拍（每拍少算一发）
## 姿态三档（C2 确认值：站/蹲/卧，命中面积 1.0 / 0.7 / 0.5，切换 0.45 / 0.65 s）
const POSTURE_SWITCH_CROUCH := 0.45   # s，切到蹲姿的耗时（C2 确认值）
const POSTURE_SWITCH_PRONE := 0.65    # s，切到卧姿的耗时
const POSTURE_SPREAD_CROUCH := 0.75   # 散布倍率（C3 精度档，数值待实测）
const POSTURE_SPREAD_PRONE := 0.5
const POSTURE_HIT_STAND := 1.0        # 命中面积系数
const POSTURE_HIT_CROUCH := 0.7
const POSTURE_HIT_PRONE := 0.5
const POSTURE_SPEED_CROUCH := 0.6     # 移动速度倍率（数值待实测）
const POSTURE_SPEED_PRONE := 0.35

# ────────────── 压制机制（docx 7.3）─────────────
## 弹药必须从身边飞过或附近撞击才积累压制；按贴近程度增加；随时间衰减；造成功能障碍。
## 注意：俯视下准心＝屏心＝相机中心，晃准心就是晃镜头（docx 已判负收益），
## 所以「晃动」只做在准心的视觉上（Main 里加视觉抖动），绝不改真实射击方向。
const SUPPRESSION_NEAR_MISS_RADIUS := 3.0      # m，弹道离玩家多近才算近失
const SUPPRESSION_PER_NEAR_MISS := 0.18        # 每发近失的最大积累（按贴近程度打折）
const SUPPRESSION_HIT_BONUS := 0.3             # 被命中额外积累
## 真机反馈（2026-09-28）：停手 20 多秒橙弧仍有残留 —— 0.25/s 太慢，改 0.4/s（2.5 s 清空）
## /s，每秒衰减量：0.25 在真机上观感黏人，2026-09-28 改 0.4（2.5 s 清空）
const SUPPRESSION_DECAY := 0.4
const SUPPRESSION_DRAW_THRESHOLD := 0.05  # 压制低于它就不再画橙弧（别留小尾巴）
const SUPPRESSION_SPREAD_SCALE := 1.8          # 满压制时散布额外倍率（×2.8）
const SUPPRESSION_CROSSHAIR_JITTER_DEG := 6.0  # 度，满压制时准心视觉抖动幅度（仅表现）
## 反向：压制对 AI 的影响（7.3「造成各种功能障碍」+ 4.12.5 AI 盲射命中率下降的思路）
const SUPPRESSION_AI_SPREAD_DEG := 8.0   # 度，敌人满压制时的还击散布（直接打成命中率下降）
## 阈值给 0.35：玩家一发近失最多 0.18，两发擦身就能触发「不敢露头」。
## 原值 0.6 在「2 发就把敌人打死」的节奏下永远达不到，真机上看不到任何变化（2026-09-28 实测）
const SUPPRESSION_AI_HOLD_FIRE := 0.35
const SUPPRESSION_AI_HOLD_TIME := 1.2    # s，每次被打压后停火的犹豫时长

# ────────────── 准心（等腰三角形箭头，2026-09-28 确认稿）─────────────
## 箭头尖端＝纹理中心＝屏心＝准心点，所以旋转轴就在尖端上，箭头随时指向射击方向
const CROSSHAIR_ARROW_SIZE := 32          # px，箭头纹理画布边长（正方形）
const CROSSHAIR_ARROW_LENGTH := 14        # px，尖端到底边的长度（箭身长度）
const CROSSHAIR_ARROW_HALF_HEIGHT := 7    # px，底边半高（底边总宽 = 2 × 此值）

# ────────────── 地图预览 / 检测模式（Main.map_preview_mode）─────────────
## 不进游戏循环，直接看：地形形状 / 哪里爬不上去 / 哪里挡视线 / 抓关键点
const PREVIEW_SLOPE_STEP := 4             # 格，可达性掩码采样步长（4 m）
const PREVIEW_ZOOM_LEVELS := [0.54, 1.5, 3.0]  # 全图 → 局部 → 细节（0.54 ≈ 960/1000 铺满屏）
const PREVIEW_RAY_STEP_DEG := 3.0         # 度，通视探针射线间隔（360/3 = 120 条）
const PREVIEW_RAY_RADIUS := 300.0         # m，探针射线长度
const PREVIEW_PASSABLE_ALPHA := 0.45      # 不可通行红域的不透明度

# ────────────── 白旗点与占领（4.2 / 12.8.4）─────────────
const CAPTURE_ZONE_RADIUS := 15.0      # m，核心占领区半径
const SUPPRESSION_RING_INNER := 30.0   # m，外围压制圈内径
const SUPPRESSION_RING_OUTER := 150.0  # m，外围压制圈外径
const FLAG_HOLD_TIME := 30.0           # s，完整翻转（-1 → +1）所需时间：首占 15 s、反夺 30 s

# ────────────── 对局与胜负（5.7 确认稿）─────────────
const MATCH_DURATION := 900.0          # s，15 分钟
const OVERTIME_DURATION := 180.0       # s，加时 3 分钟突然死亡
const RESPAWN_BUDGET_MULTIPLIER := 2   # 重生预算 = 进攻方人数 × 2
## m，重生点的「安全距离」参考值：候选点里挑离最近敌人最远的那个；
## 若最好的候选仍在这个距离内，只是提示玩家「落点附近有敌人」，不强改落点（见 MatchFlow.pick_respawn_point）
const RESPAWN_SAFE_DISTANCE := 60.0
## 敌方坦克乘员弃车阈值：结构值 ≤ 这个比例（相对 max_hp）就下车逃生，车随之停火
const VEHICLE_CREW_BAILOUT_FRACTION := 0.30
## 🧪 敌人是否补刀（对倒地目标继续开火 / 补掉）。
## true = 正式（更硬核，2026-10-02 拍板）：倒地再被敌人打中一发 = 直接阵亡 → 立刻扣预算重生。
## false = **测试态**（当前值，使用者 2026-10-02 要求）：敌人不再把倒地目标当靶子（步兵退回巡逻、
##   坦克停火），且倒地目标期间免伤（流弹 / 爆炸也不算补刀）⇒ 可以安稳测「倒地 60 s → 阵亡 → 重生」。
## 注意：只影响「敌人 → 倒地目标」这一个方向；玩家补刀倒地敌人不受它影响。
const ENEMY_FINISH_OFF_ENABLED := false
## 玩家小队规模（队友数，使用者 2026-10-02 定为 3）
## 开局 AI 队友数（**不是「小队规模」**：2026-10-03 编成口径 —— 组 = 4 人、一小队至少 2 组）。
## 3 名队友 + 玩家 = 一个 4 人组 ⇒ PVEVP 的 4P 正好是这个数；PVP 20 v 20 要 19 名队友。
const ALLY_SQUAD_SIZE := 3
## 通视查询节流（2026-10-03 · 性能预算报告的第一刀）：
## 20 v 20 下每个 AI 单位每帧都要查一次通视（≈256 µs/次，debug 构建），
## 全场 ≈60 次/帧就是脚本侧 9.79 ms 的大头。同一单位在 N 帧窗口内复用上一次结果，
## 感知延迟最多 N/60 秒（4 帧 = 66 ms）；玩家在 4 帧里最多移动 ~0.3 m，体感无差别。
## 调大 = 更省但更迟钝；1 = 关掉节流（回到逐帧查）。
const SIGHT_THROTTLE_FRAMES := 4
## 队友重新挑目标的间隔（s）：原来每物理帧都遍历一次敌组并逐候选查通视，
## 现在 0.1 s 才重挑一次（当前目标失效会立刻重挑）。省的是「同一帧里对多个候选各查一次通视」。
const AI_TARGET_RETRY_INTERVAL := 0.1

# ────────────── 评分（第一版只留两项，4.8）─────────────
const SCORE_KILL := 1
const SCORE_CAPTURE_FLAG := 40

# ────────────── 局内界面与体验（候选 O：docx 4.14 战斗播报 / 4.15 操作提示）─────────────
## 4.14：同类事件在 FEED_MERGE_WINDOW 内合并成一条（limiting），每条停留 FEED_TTL 秒
const FEED_MERGE_WINDOW := 1.5    # s，同类事件合并窗口（合并＝限频）
const FEED_TTL := 4.5             # s，一条播报在 HUD 上停留多久
const FEED_MAX_LINES := 4         # HUD 上最多同时显示几条（新的在上）
const FEED_MAX_ENTRIES := 12      # 逻辑上最多留几条（超出的从最旧丢）
## 4.15：每条只弹一次；两条之间至少隔 TIP_MIN_INTERVAL 秒，避免开场连环弹
const TIP_MIN_INTERVAL := 2.0     # s，两条提示之间的最小间隔
const TIP_TTL := 5.0              # s，一条提示停留多久
const TIP_DEFAULT_ENABLED := true # 「可在设置关闭」的默认值（设置界面后置，先给 API）
const TIP_SUPPRESSION := 0.25     # 压制高于它才提示「你正被压制」
const TIP_LOW_HP := 25.0          # 血量低于它才提示「血量过低」
