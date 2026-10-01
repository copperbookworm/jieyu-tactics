extends RefCounted

## 任务模板表（数据源：docx 4.10.11 任务模板池实例 / 官方「解域游戏任务模板表.csv」）
## 官方表有 8 条模板（1 主线占领 + 1 主线防守 + 6 支线），第一版只抄「现在就能发」的 3 条：
##   T-M1 占领节点（主线）、T-S4 侦察标记（简单 +10）、T-S1 歼灭穿插小队（中等 +15）
## 其余 5 条暂不可发的理由：
##   T-M2 守住节点 —— 需要「我方先占下节点」的前置阶段，第一版只有单线进攻流程
##   T-S2 摧毁敌方 FOB / T-S5 护送补给 —— 没有 FOB 与补给实体
##   T-S3 摧毁敌方载具 —— 场上没有敌方载具（只有玩家那辆）
##   T-S6 守住侧翼通路 —— 需要「通道」判定与敌军行进路径
## 另外 T-S1 的目标数从官方的「≥3 人」降到「≥1 人」：第一版场上只有 2 个敌人。
## 刻意不写 class_name：引用方用 preload（见 Cover.gd 头部说明）

const CSV_PATH := "res://data/quest_templates.txt"

static var _table := {}
static var _loaded := false


static func load_table() -> Dictionary:
	if _loaded:
		return _table
	_loaded = true
	if not FileAccess.file_exists(CSV_PATH):
		push_error("[任务表] 找不到 %s" % CSV_PATH)
		return _table
	var file := FileAccess.open(CSV_PATH, FileAccess.READ)
	if file == null:
		push_error("[任务表] 打不开 %s" % CSV_PATH)
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


static func get_template(id: String) -> Dictionary:
	return load_table().get(id, {})


static func ids() -> Array:
	return load_table().keys()


static func number(template: Dictionary, key: String, fallback: float) -> float:
	if not template.has(key):
		return fallback
	var text := String(template[key])
	if text.is_empty():
		return fallback
	return text.to_float()


static func is_main(template: Dictionary) -> bool:
	return number(template, "main", 0.0) > 0.5


## SMEAC 简报（4.10：每条任务用 SMEAC 呈现，S 情境 / M 任务 / E 执行）
static func smeac(template: Dictionary) -> Dictionary:
	return {
		"s": String(template.get("situation", "—")),
		"m": String(template.get("mission", "—")),
		"e": String(template.get("execution", "—")),
	}
