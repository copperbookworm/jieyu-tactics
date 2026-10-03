extends RefCounted

## 载具数据表（数据源：docx 第八章 / 官方「解域游戏载具数据表.csv」，按游戏需要的列精简）
## 官方表列很全（尺寸 / 重量 / 乘员 / 主副武器 / 速度 / 装甲厚度@倾角 / 数据来源），
## 这里只抽出第一版用得到的：尺寸、速度、乘员、主武器与射程、四向装甲（法向厚度 + 基础倾角）。
## 装甲字段在官方表里写作「700@30 / 260@0 / 130@0 / 50@0」（前/侧/后/顶），我拆成了独立列。
##
## 候选 R（2026-10-02）：行数已扩到官方全量（18 辆）。官方表**有**的列（尺寸 / 速度 / 乘员 / 载员 /
## 主武器 / 射程 / 备弹 / 四向装甲）直接抄；官方表**没有**的列（hp / gun_damage / gun_penetration_mm /
## gun_interval）按「类别模板」内联，模板锚定在两辆已校准的车上：
##   主战坦克 2000 / 400 / 700 / 6.0（＝ mbt_t1）　步兵战车 800 / 40 / 60 / 0.15（＝ ifv_a）
## 其余类别（装甲输送车 / 轻型坦克 / 自行火炮 / 自行高炮 / 侦察车 / 武装直升机）取两者之间的工程默认值。
## ⚠ 这些模板值**未经平衡校验**，只保证「表能读、字段齐全」；要真上线得逐个定标（登记在进度文件六节）。
## atgm_* 五列只有 ifv_a 有值（玩家那辆车），其余留空 ＝ 没装导弹。
##
## 刻意不写 class_name：引用方用 preload（见 Cover.gd 头部说明）

const CSV_PATH := "res://data/vehicles_data.txt"

static var _table := {}
static var _loaded := false


static func load_table() -> Dictionary:
	if _loaded:
		return _table
	_loaded = true
	if not FileAccess.file_exists(CSV_PATH):
		push_error("[载具表] 找不到 %s" % CSV_PATH)
		return _table
	var file := FileAccess.open(CSV_PATH, FileAccess.READ)
	if file == null:
		push_error("[载具表] 打不开 %s" % CSV_PATH)
		return _table
	var header := file.get_csv_line()
	var keys: Array = []
	for column in header:
		keys.append(String(column).strip_edges())
	while not file.eof_reached():
		var values := file.get_csv_line()
		if values.size() < keys.size() or String(values[0]).strip_edges().is_empty():
			continue
		var row := {}
		for i in keys.size():
			row[keys[i]] = String(values[i]).strip_edges()
		_table[row["id"]] = row
	file.close()
	return _table


static func has_vehicle(id: String) -> bool:
	return load_table().has(id)


static func get_vehicle(id: String) -> Dictionary:
	return load_table().get(id, {})


static func number(vehicle: Dictionary, key: String, fallback: float) -> float:
	if not vehicle.has(key):
		return fallback
	var text := String(vehicle[key])
	if text.is_empty():
		return fallback
	return text.to_float()


## 车载主炮对建筑 / 工事的结构伤害（2026-10-03 拍板的一列）。
## 缺列或空串 ⇒ 0（打不动），与「普通子弹对建筑伤害为 0」同一条默认口径 —— 默认不能是「能打」。
static func gun_structure_damage(vehicle: Dictionary) -> float:
	return number(vehicle, "gun_structure_damage", 0.0)


## 车载反坦克导弹对建筑 / 工事的结构伤害（只有装了导弹的车有值）
static func atgm_structure_damage(vehicle: Dictionary) -> float:
	return number(vehicle, "atgm_structure_damage", 0.0)


static func ids() -> Array:
	return load_table().keys()


## 命中方向 → 装甲面（前 / 侧 / 后）。hull_facing 是车体朝向，hit_direction 是弹道方向。
## 敌人在车头正前方开火时两个向量同向 ⇒ 打的是首上装甲。
static func hit_side(hull_facing: Vector2, hit_direction: Vector2) -> String:
	var dot := hull_facing.normalized().dot(hit_direction.normalized())
	if dot > 0.7:
		return "front"
	if dot < -0.7:
		return "rear"
	return "side"


## 装甲有效厚度（mm）：法向厚度 ÷ cos(法线角)，法线角 = 入射偏角 + 该面基础倾角。
## 角度越大等效越厚（首上大倾角为什么难打），超过 80° 时给个下限防止除零式爆炸。
static func effective_armor_mm(vehicle: Dictionary, side: String,
		hit_angle_deg: float) -> float:
	var thickness := number(vehicle, "armor_%s_mm" % side, 0.0)
	var base_angle := number(vehicle, "armor_%s_deg" % side, 0.0)
	var total := clampf(absf(hit_angle_deg) + base_angle, 0.0, 80.0)
	return thickness / maxf(cos(deg_to_rad(total)), 0.1)


## 装甲面名转中文（HUD 提示用：未击穿时要告诉玩家打的是哪一面）
static func side_label(side: String) -> String:
	if side == "front":
		return "正面"
	if side == "rear":
		return "后部"
	return "侧面"


## 击穿判定：弹丸穿深 ≥ 有效厚度即击穿（第一版最经典的坦克规则）
static func is_penetrated(vehicle: Dictionary, side: String, hit_angle_deg: float,
		penetration_mm: float) -> bool:
	return penetration_mm >= effective_armor_mm(vehicle, side, hit_angle_deg)
