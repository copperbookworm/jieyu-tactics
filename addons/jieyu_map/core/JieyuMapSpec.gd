class_name JieyuMapSpec
extends RefCounted

## 《解域》地图数据规格 —— 插件里唯一放「文档口径数字」的地方。
##
## 依据：squad-2d/解域游戏.docx
##   · 12.8.1 地图目录结构（每张图一个目录 Maps/<map_id>/）
##   · 12.8.2 高度图规范（1000 × 1000、8 位灰度、h = gray / 255 × max_elevation、原点左上）
##   · 12.8.3 噪声生成参数（四层 fBm）
##   · 12.8.4 grassland_demo 示例（五节点坐标 / 五结构半径）
##   · 12.8.7 JSON 字段定义（meta / zones / occluders）
##   · 六章 关键量化指标（占领点间距、掩体密度、视线打断距离、复活时间）
##   · 4.3 判断地图是否失衡的 5 项非主观指标
##
## 与工程的关系：网格尺寸 / 最大海拔 / 坡度阈值仍以 `GameConfig` 为唯一数值出口
## （GRID_WIDTH / GRID_HEIGHT / CELL_SIZE / MAX_ELEVATION / MAX_SLOPE_DEG），
## 本类只补游戏配置里没有的地图设计口径，不另立第二份「同义常量」。

# ────────────── 12.8.1 目录结构 ──────────────
const DEFAULT_MAP_ROOT := "res://assets/maps/"
## 主图层目录（把一张图的全部产物收进一个目录，和 12.8.1 的 Maps/<map_id>/ 对应）
const LAYER_DIR_NAME := "layers"
const FILE_HEIGHTMAP := "heightmap.png"
const FILE_TERRAIN := "terrain.png"
const FILE_META := "meta.json"
const FILE_ZONES := "zones.json"
const FILE_OCCLUDERS := "occluders.json"
## 可选内容层：4.17 角色与环境的互动效果（泥泞 / 雪地 / 草丛）。
## 方案 A = 单张纯色图按**行序**排 N 片区域（工程侧逐行检测同色像素）；
## 方案 B = 单通道「地形材质 id 图」（0 无 / 1 泥泞 / 2 雪地 / 3 草丛）。两者可同时存在。
const FILE_CONTENT_ROWS := "content.png"
const FILE_MATERIAL := "material.png"

# ────────────── 12.8.2 高度图规范 ──────────────
const GRAY_MAX := 255
# ────────────── 12.8.3 噪声生成参数（四层 fBm 示例起点）──────────────
const NOISE_TYPE := "simplex_smooth"
const NOISE_OCTAVES := 4
const NOISE_LACUNARITY := 2.0
const NOISE_GAIN := 0.5
## feature_m（特征尺寸） / amp_m（振幅）
const NOISE_LAYERS := [
	{"feature_m": 250, "amp_m": 90},
	{"feature_m": 80, "amp_m": 40},
	{"feature_m": 25, "amp_m": 15},
	{"feature_m": 8, "amp_m": 5},
]

# ────────────── 12.8.4 / 4.2 白旗点五结构 ──────────────
const CORE_RADIUS_M := 15.0
const PRESSURE_RING_M := [30.0, 150.0]
const SPAWN_OFFSET_M := [100.0, 200.0]
const MIN_APPROACH_ROUTES := 2          # 4.2 要求 ≥ 2 条（六章建议 ≥ 3）
const RECOMMENDED_APPROACH_ROUTES := 3  # 六章「每个占领点 3 个以上入口/射击窗」
const MIN_DIST_TO_CORE_M := 100.0       # 12.8.7 rally_zones.min_dist_to_core_m

## 12.8.4 grassland_demo 五节点（N1 西侧起点 → N5 东侧终点）
const DEMO_NODES := [
	{"id": "N1", "name": "西侧起点", "pos": [150.0, 500.0]},
	{"id": "N2", "name": "", "pos": [350.0, 300.0]},
	{"id": "N3", "name": "中央枢纽", "pos": [500.0, 500.0]},
	{"id": "N4", "name": "", "pos": [680.0, 700.0]},
	{"id": "N5", "name": "东侧终点", "pos": [850.0, 500.0]},
]

# ────────────── 六章 关键量化指标 ──────────────
const NODE_SPACING_MIN_M := 200.0
const NODE_SPACING_MAX_M := 500.0
const MAX_OPEN_GROUND_M := 300.0        # 没有超过 300 m 的无掩体开阔地
const SIGHT_BREAK_MIN_M := 150.0        # 每 150–200 m 打断长视线
const SIGHT_BREAK_MAX_M := 200.0
const VEHICLE_CORRIDOR_MIN_M := 8.0     # 载具通道宽度 ≥ 8 m
const VEHICLE_SLOPE_LIMIT_DEG := -1.0   # 负值 = 取 GameConfig.MAX_SLOPE_DEG（30°）
const CORRIDOR_FLAT_DEG := 8.0          # 判定「这段路能跑车」的局部坡度上限（比 30° 严）
## ⚠ 8 位高度图 1 灰度 ≈ 0.59 m ⇒ 相邻两格的最小高差本身就是约 30.5°，
## 所以「坡度」一律按跨若干格的平均值量，别用相邻两格（那是量化噪声，不是坡度）。
## 掩体密度分级：间距 5–15 米、高 1.5–3 米（城市 / 建筑群）——插件按「建筑群」口径校验
const URBAN_SPACING_MIN_M := 5.0
const URBAN_SPACING_MAX_M := 15.0
const BUILDING_H_LOW_M := 1.5
const BUILDING_H_TOP_M := 3.0

# ────────────── 4.3 判断地图是否失衡的 5 项（能机器判的 3 项）──────────────
## 制高点覆盖：单一格能直视多少个占领点的核心区。12.8.4 要求「任一点不超过 2 个」
const MAX_NODES_PER_OVERWATCH := 2
## 制高点覆盖 ≥70% 占领区 → 用「能看见核心圆 70% 采样点」近似
const OVERWATCH_CORE_COVER_RATIO := 0.70
const OVERWATCH_MIN_ELEV_M := 40.0      # 低于这个高程不算「制高点」
const OVERWATCH_CORE_SAMPLES := 9       # 核心区采样点（3×3）

# ────────────── 破坏规则（2026-10-03 使用者拍板四条）──────────────
## ① 遮挡体默认可摧毁（一律 destructible = true）
const DEFAULT_DESTRUCTIBLE := true
## ② 结构值锚点「标准档」：与工程的 FOB 结构值同档（1200）
const STRUCTURE_HP_SMALL := 800.0         # 小屋 / 哨所
const STRUCTURE_HP_HOUSE := 1200.0        # 标准建筑（锚点）
const STRUCTURE_HP_REINFORCED := 3000.0   # 加固 / 多层
## 沙袋类半高墙的耐久：文档 4.17 / 20.5 明文「耐久 200」，与工程 GameConfig.COVER_HP 同值
const SANDBAG_HP := 200.0
## ③ 破坏后留贴地残痕 + 小减速（不影响通视）
const RUBBLE_MATERIAL_ID := 4             # material.png 的 id 值
const RUBBLE_SPEED_SCALE := 0.70          # 与泥泞同档
const RUBBLE_RADIUS_SCALE := 1.25         # 残痕半径 = 遮挡体最长边 × 这个系数
## ④ 三段破坏：完好 → 受损（h_top 变矮）→ 摧毁（退出遮挡）
const DAMAGE_STATE_INTACT := "intact"
const DAMAGE_STATE_DAMAGED := "damaged"
const DAMAGE_STATE_DESTROYED := "destroyed"
const DAMAGE_DEFAULT_DAMAGED_BELOW_RATIO := 0.70
const DAMAGE_DEFAULT_DAMAGED_HEIGHT_SCALE := 0.45
const DAMAGE_DEFAULT_DESTROYED_HEIGHT_SCALE := 0.0
## 建筑的受损顶高比例取 0.60（比沙袋的 0.45 保守：楼塌一半不该比沙袋还矮）
const DAMAGE_BUILDING_DAMAGED_HEIGHT_SCALE := 0.60
## 与工程 data/weapons_data.txt 的 structure_damage 列对齐的抽样值（只用于校验提示，不参与生成）
const SAMPLE_RIFLE_STRUCTURE_DAMAGE := 0.0       # 普通子弹：打不动建筑
const SAMPLE_HMG_STRUCTURE_DAMAGE := 30.0        # 12.7mm 车装机枪
const SAMPLE_TANK_GUN_STRUCTURE_DAMAGE := 280.0  # 125mm 主炮
const SAMPLE_ARTILLERY_STRUCTURE_DAMAGE := 420.0 # 155mm 榴弹炮

# ────────────── 开口（窗 / 门洞，拍板① 2026-10-03）──────────────
## 12.8 原本没有这个字段：开口的几何写在 occluders.json 每条遮挡体的 `openings[]` 里。
## 语义：只有打中开口才能伤到建筑里面（也才能在屋子里打到人）。
## 坐标是**本地坐标**（与 polygon 包围盒中心同一个坐标系），随遮挡体旋转一起转。
const OPENING_WINDOW := "window"
const OPENING_DOOR := "door"
const OPENING_KINDS := [OPENING_WINDOW, OPENING_DOOR]
## 开口厚度（本地坐标，跨墙厚）：取 1.2 m ⇒ 两侧各出 0.6 m，
## 这样「炮弹从墙的哪一侧穿进来」都落在开口格里（拿射线与开口求交是标称的）。
const OPENING_HALF_THICKNESS := 0.6
## 窗：宽 2.4 m、窗台 0.75 m —— 取在卧姿眼高 0.6 m 与站姿眼高 1.6 m 之间，
## 于是「站姿能透过窗看到屋里、卧姿看不到」是一条干净的边界（与 C2 矮掩体同一套直觉）。
const WINDOW_HALF_WIDTH := 1.2
const WINDOW_SILL_M := 0.75
## 门：宽 2.0 m、落地到顶（卧姿也能走过去 / 打进去）
const DOOR_HALF_WIDTH := 1.0
const DOOR_SILL_M := 0.0
## 4.2 / 六章「每个占领点 3 个以上入口/射击窗」⇒ 建筑也要至少两个开口（校验器据此报警）
const MIN_OPENINGS_PER_BUILDING := 2

# ────────────── 命名口径（《给地图不同区域命名》：短 / 唯一 / 可想象 / 可战术化）──────────────
const NAME_MAX_CHARS := 6               # 中文 2–3 字为宜，放宽到 6 字符
const MODE_IDS := ["pvp_competitive", "pvp_armor", "pvp_casual", "pvevp"]

## 4.17 环境互动区的 kind 取值（与 entities/zone/TerrainZone.gd 的 Kind 枚举同值）
## 瓦砾（RUBBLE_MATERIAL_ID）不在其中：残痕由掩体摧毁时现落，不从内容图里读
const CONTENT_KIND_NAMES := ["泥泞", "雪地", "草丛"]


static func max_elevation() -> float:
	return GameConfig.MAX_ELEVATION


static func grid_width() -> int:
	return GameConfig.GRID_WIDTH


static func grid_height() -> int:
	return GameConfig.GRID_HEIGHT


static func vehicle_slope_limit() -> float:
	return GameConfig.MAX_SLOPE_DEG if VEHICLE_SLOPE_LIMIT_DEG < 0.0 else VEHICLE_SLOPE_LIMIT_DEG


## 高度（米）→ 高度图灰度（12.8.2：h = gray / 255 × max_elevation 的反函数）
static func height_to_gray(height_m: float, max_elevation_m: float = -1.0) -> int:
	var top := max_elevation_m if max_elevation_m > 0.0 else max_elevation()
	return clampi(roundi(height_m / top * float(GRAY_MAX)), 0, GRAY_MAX)


## 高度图灰度 → 高度（米）
static func gray_to_height(gray: int, max_elevation_m: float = -1.0) -> float:
	var top := max_elevation_m if max_elevation_m > 0.0 else max_elevation()
	return float(clampi(gray, 0, GRAY_MAX)) / float(GRAY_MAX) * top


## 一张地图的目录：res://assets/maps/<map_id>/
static func map_dir(map_id: String) -> String:
	return DEFAULT_MAP_ROOT + map_id.strip_edges().replace(" ", "_") + "/"


static func file_path(map_id: String, file_name: String) -> String:
	return map_dir(map_id) + file_name


static func layer_file_path(map_id: String, layer_name: String) -> String:
	return map_dir(map_id) + LAYER_DIR_NAME + "/" + layer_name


## 默认 meta（12.8.7 字段顺序与示例一致）
static func default_meta(map_id: String, seed_value: int = -1) -> Dictionary:
	return {
		"map_id": map_id,
		"name": map_id,
		"size_m": [float(grid_width()), float(grid_height())],
		"grid": grid_width(),
		"cell_size_m": GameConfig.CELL_SIZE,
		"max_elevation_m": max_elevation(),
		"terrain_type": "grassland",
		"noise": default_noise(seed_value),
		"modes": MODE_IDS.duplicate(),
		"players": 64,
		"sight_margin_m": GameConfig.SIGHT_MARGIN,
		"content_layers": default_content_layers(),
	}


static func default_noise(seed_value: int = -1) -> Dictionary:
	var use_seed := seed_value if seed_value > 0 else GameConfig.DEFAULT_MAP_SEED
	return {
		"type": NOISE_TYPE,
		"seed": use_seed,
		"octaves": NOISE_OCTAVES,
		"lacunarity": NOISE_LACUNARITY,
		"gain": NOISE_GAIN,
		"layers": NOISE_LAYERS.duplicate(true),
	}


## 内容层的默认声明（插件生成的图默认带这两张图；没有写到盘上时工程侧静默跳过）
static func default_content_layers() -> Dictionary:
	return {
		"name": "",
		"rows_file": FILE_CONTENT_ROWS,
		"material_file": FILE_MATERIAL,
		"merge_mode": "max_conceal",
	}
