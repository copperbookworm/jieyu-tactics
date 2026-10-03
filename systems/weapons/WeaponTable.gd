extends RefCounted

## 武器数据表（数据源：docx 7.5 提到的「解域游戏武器数据表.csv」，已按游戏需要的列精简成
## data/weapons.csv）—— 列：id/name/type/rpm/mag_size/reserve/game_range/dmg_base/dmg_min/
## falloff_start/falloff_end/moa/reload_tactical/reload_empty/switch_time/structure_damage/source
## 刻意不写 class_name：引用方用 preload（见 Cover.gd 头部说明）

## 用 .txt 存 CSV 格式：Godot 会把 .csv 当**翻译表**导入，生成 .translation 垃圾文件（2026-09-28 踩到）
const CSV_PATH := "res://data/weapons_data.txt"

## 对建筑 / 工事的伤害缺省值。0 = **打不动**（2026-10-03 拍板：普通子弹对建筑伤害恒为 0）
const DEFAULT_STRUCTURE_DAMAGE := 0.0

static var _table := {}
static var _loaded := false


## 读 CSV（惰性、只读一次）。解析失败返回已加载的部分，并 push_error 说明原因
static func load_table() -> Dictionary:
	if _loaded:
		return _table
	_loaded = true
	if not FileAccess.file_exists(CSV_PATH):
		push_error("[武器表] 找不到 %s" % CSV_PATH)
		return _table
	var file := FileAccess.open(CSV_PATH, FileAccess.READ)
	if file == null:
		push_error("[武器表] 打不开 %s" % CSV_PATH)
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


static func has_weapon(id: String) -> bool:
	return load_table().has(id)


## 取一把枪的整行（找不到返回空字典，调用方自己兜底）
static func get_weapon(id: String) -> Dictionary:
	return load_table().get(id, {})


## 字符串列 → 数值（缺失或空串时用 fallback）
static func number(weapon: Dictionary, key: String, fallback: float) -> float:
	if not weapon.has(key):
		return fallback
	var text := String(weapon[key])
	if text.is_empty():
		return fallback
	return text.to_float()


## 这把武器对建筑 / 工事的伤害（结构伤害）。缺列或空串 ⇒ 0（打不动），
## 与「普通子弹对建筑伤害为 0」的拍板口径一致 —— 默认值必须是「打不动」，不能是「能打」。
static func structure_damage(weapon_row: Dictionary) -> float:
	return number(weapon_row, "structure_damage", DEFAULT_STRUCTURE_DAMAGE)


## 按 id 直接取结构伤害（战斗侧用）
static func structure_damage_of(weapon_id: String) -> float:
	return structure_damage(get_weapon(weapon_id))


## 能不能对建筑造成伤害（结构伤害 > 0）—— 判定「这个兵种能不能拆楼」的入口
static func can_break_structure(weapon_id: String) -> bool:
	return structure_damage_of(weapon_id) > 0.0


static func ids() -> Array:
	return load_table().keys()
