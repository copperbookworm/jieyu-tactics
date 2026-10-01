extends RefCounted

## 载具数据表（数据源：docx 第八章 / 官方「解域游戏载具数据表.csv」，按游戏需要的列精简）
## 官方表列很全（尺寸 / 重量 / 乘员 / 主副武器 / 速度 / 装甲厚度@倾角 / 数据来源），
## 这里只抽出第一版用得到的：尺寸、速度、乘员、主武器与射程、四向装甲（法向厚度 + 基础倾角）。
## 装甲字段在官方表里写作「700@30 / 260@0 / 130@0 / 50@0」（前/侧/后/顶），我拆成了独立列。
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
