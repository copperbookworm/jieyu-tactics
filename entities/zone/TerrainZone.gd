extends Node2D

## 环境互动区（docx 4.17 角色与环境的互动效果，候选 O 第四轮）
##
## 三种地形内容：泥泞（减速）/ 雪地（更慢）/ 草丛（隐蔽）。第一版是「圆饼区域」——
## 高程网格里只有高度、没有材质层，所以内容层先用独立区域表达，与掩体（Cover）同一套思路：
## 一个 Node2D + 组查询 + 纯判定函数。形状取圆（掩体取矩形是因为要算边缘距离，区域只需要「在不在里面」）。
##
## 4.17 原文的三块里，本文件负责「地形互动」；「掩体互动」在 Player（贴掩体 / 探头）；
## 「破坏互动」早已由候选 E / 第十版的可破坏掩体覆盖（Cover 有耐久、双方子弹都能拆）。
##
## 判定与查询在 systems/terrain/TerrainZones.gd（纯静态函数，可单测）；本文件只管「自己长什么样」。
## 刻意不写 class_name：引用方 preload（见 Cover.gd 头部说明）

enum Kind { MUD, SNOW, GRASS }

const KIND_LABELS := ["泥泞", "雪地", "草丛"]
const KIND_COLORS := [
	Color(0.45, 0.35, 0.22, 0.42),
	Color(0.85, 0.90, 0.95, 0.45),
	Color(0.30, 0.62, 0.28, 0.40),
]

var kind: int = Kind.MUD
var radius := GameConfig.TERRAIN_ZONE_RADIUS


func _ready() -> void:
	if not is_in_group(GameConfig.TERRAIN_ZONE_GROUP):
		add_to_group(GameConfig.TERRAIN_ZONE_GROUP)
	queue_redraw()


## 摆位（必须 add_child 之后再调，组查询与重绘都依赖在树里）
func setup(zone_kind: int, zone_radius: float = -1.0) -> void:
	kind = zone_kind
	if zone_radius > 0.0:
		radius = zone_radius
	if not is_in_group(GameConfig.TERRAIN_ZONE_GROUP):
		add_to_group(GameConfig.TERRAIN_ZONE_GROUP)
	queue_redraw()


func kind_label() -> String:
	if kind < 0 or kind >= KIND_LABELS.size():
		return "未知"
	return KIND_LABELS[kind]


func kind_color() -> Color:
	if kind < 0 or kind >= KIND_COLORS.size():
		return Color.WHITE
	return KIND_COLORS[kind]


## 这块区域盖到这个点吗（第一版是圆）
func covers(point: Vector2) -> bool:
	return global_position.distance_to(point) <= radius


## 区域内的移速倍率：泥 0.70 / 雪 0.55 / 草 1.0
func speed_scale() -> float:
	if kind == Kind.SNOW:
		return GameConfig.TERRAIN_SNOW_SPEED_SCALE
	if kind == Kind.MUD:
		return GameConfig.TERRAIN_MUD_SPEED_SCALE
	return 1.0


## 区域内的隐蔽度：只有草丛给（卧姿再加一档，呼应 C2 的「矮掩体」属性）；泥 / 雪不给
func concealment(prone: bool) -> float:
	if kind != Kind.GRASS:
		return 0.0
	return GameConfig.TERRAIN_GRASS_CONCEAL \
			+ (GameConfig.TERRAIN_GRASS_PRONE_BONUS if prone else 0.0)


func _draw() -> void:
	var color := kind_color()
	draw_circle(Vector2.ZERO, radius, color)
	draw_arc(Vector2.ZERO, radius, 0.0, TAU, 64, Color(color, 0.9), 0.5)
