extends RefCounted

## 任务模板表（数据源：docx 4.10.11 任务模板池实例 / 官方「解域游戏任务模板表.csv」）
## 官方表 8 条模板（2 主线 + 6 支线）已全部落地（候选 L1~L5，2026-09-30 ~ 2026-10-01）：
##   主线：T-M1 占领节点（+40）、T-M2 守住节点（+40，守住型＝防守阶段）
##   支线：T-S4 侦察标记（+10）、T-S1 歼灭穿插小队（+15）、T-S3 摧毁敌方载具（+20）、
##         T-S2 摧毁敌方 FOB（+20）、T-S5 护送补给至前线（+15）、T-S6 守住侧翼通路（+10，守住型）
## 两条守住型（hold_lane / hold_zone）的达成都是「时限到点仍守住」而不是超时失败：
##   判定见 QuestSystem.is_hold_goal()；T-M2 另有「节点被翻红即失守」这条失败分支。
## 官方写「时限：阶段内」的模板（T-M2）第一版取 120 s（防守阶段长度，待实操调）。
## 暂时落不了的官方权重修正（第一版没有对应的战局变量，故不计入）：
##   T-S2「敌方续航 <30% +10」、T-S5「友军兵力不足 +15」（场上只有玩家一个友军单位）。
## 另外两处第一版取舍：T-S1 目标数从官方「≥3 人」降到「≥1 人」（场上只有 2 个敌人）；
##   T-M2 官方奖励「+40（剩 1 人 +60）」的「剩 1 人加码」未做（第一版没有小队编制）。
## 局部简化（写进 SMEAC 执行段，引擎不判）：T-S3 官方触发是「敌方载具被标记且可接近」，
## 第一版闸门只认「载具存活 + 已被报点标记」，「可接近」不做判定。
## 列对应：官方「基础权重」→ base_weight；「权重修正」→ QuestSystem._weight_of 里的战局变量；
## 「达成条件」→ goal_kind + goal_count（引擎判定用的机制键）；SMEAC 三行由本表补。
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
