extends RefCounted

## 启动自检（2026-10-01）
##
## 三张数据表是 data/*.txt，**不是 Godot 资源**（刻意如此：.csv 会被 Godot 当翻译表导入并生成 .translation 垃圾），
## 所以只配 export_filter="all_resources" 的话，一张都不会进导出包。而三条降级全是静默的：
##   · 载具：Vehicle.setup() 查表失败直接 return ⇒ hp/max_hp/_ammo 全是 0
##     （HUD 显示「车体 0/0 ｜ 余弹 0」，炮永远打不出来，看起来像「开火键坏了」）
##   · 武器：退回 GameConfig 默认值（弹匣 30 / 备弹 120），换了枪也没差别
##   · 任务：没有模板 ⇒ 任务系统发不出任何任务
## 2026-10-01 真机「上车换座之后开不了炮」就是这个：三张表一张都没进包。
## 修法在 export_presets.cfg 的 include_filter="data/*.txt"；
## 导出后另跑 tools/probe_export_pack.gd 做包内验收（那条才是真正的回归闸门）。
##
## 放进独立模块是为了让 Main.gd 守住候选 N 的 ≤400 行验收线（先拆模块再加功能）。
## 刻意不写 class_name：引用方 preload（见 Cover.gd 头部说明）

const WeaponTableScript := preload("res://systems/weapons/WeaponTable.gd")
const VehicleTableScript := preload("res://systems/vehicles/VehicleTable.gd")
const VehiclePartsScript := preload("res://systems/vehicles/VehicleParts.gd")
const QuestTableScript := preload("res://systems/quest/QuestTable.gd")


## 读不到的数据表路径（都读得到 ⇒ 空数组）
static func missing_tables() -> Array[String]:
	var missing: Array[String] = []
	for path in [WeaponTableScript.CSV_PATH, VehicleTableScript.CSV_PATH,
			VehiclePartsScript.CSV_PATH, QuestTableScript.CSV_PATH]:
		if not FileAccess.file_exists(path):
			missing.append(String(path))
	return missing


## 给玩家看的提示（空数组 ⇒ 空串，调用方据此决定要不要弹提示）
static func missing_hint(missing: Array) -> String:
	if missing.is_empty():
		return ""
	return "数据表缺失：%s（导出要在 include_filter 里带上 data/*.txt）" % "、".join(missing)


## 给日志看的一行（同上）
static func missing_error(missing: Array) -> String:
	if missing.is_empty():
		return ""
	return "[数据表] 导出包里读不到：%s ⇒ 载具会是 0/0 血 0 弹、武器退回默认值、任务没有模板。" \
			% "、".join(missing)
