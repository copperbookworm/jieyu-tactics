extends RefCounted

## 炸药表（2026-10-04 使用者拍板：工程兵 / 准心落点放置 / 遥控引爆 / TNT 2000 · C4 1500）
##
## 这是「炸药」这一类弹种的**唯一数值出口** —— 与 data/weapons_data.txt 的 structure_damage 同一条口径：
## 普通子弹恒为 0，重武器才有；而炸药是「贴上去」的那一档（比 155mm 间瞄的 420 高一档）。
## 口径锚点：「加固档建筑 3000」要能被拆 —— C4 1500 正好两发、TNT 2000 一发半。
##
## 刻意不写 class_name：引用方 preload（与 IndirectFire / Cover / 各控制器一致）。

const DEFAULT_CHARGE_ID := "c4"

const CHARGES := [
	{
		"id": "c4",
		"name": "C4",
		"structure_damage": 1500.0,
		"unit_damage": 120.0,
		"unit_min_damage": 40.0,
		"radius_m": 8.0,
		"note": "工程兵默认装药：拆加固档（3000）两发；对人爆心 120",
	},
	{
		"id": "tnt",
		"name": "TNT",
		"structure_damage": 2000.0,
		"unit_damage": 160.0,
		"unit_min_damage": 55.0,
		"radius_m": 9.0,
		"note": "拍板给的更重一档；第一版只进表（用一行数据就能换装药），不作为默认",
	},
]


static func get_charge(charge_id: String) -> Dictionary:
	for entry in CHARGES:
		if String(entry["id"]) == charge_id:
			return entry
	return CHARGES[0]


static func default_charge_id() -> String:
	return DEFAULT_CHARGE_ID


static func ids() -> Array:
	var result: Array = []
	for entry in CHARGES:
		result.append(String(entry["id"]))
	return result


static func name_of(charge_id: String) -> String:
	return String(get_charge(charge_id)["name"])


static func structure_damage(charge_id: String) -> float:
	return float(get_charge(charge_id)["structure_damage"])


static func unit_damage(charge_id: String) -> float:
	return float(get_charge(charge_id)["unit_damage"])


static func unit_min_damage(charge_id: String) -> float:
	return float(get_charge(charge_id)["unit_min_damage"])


static func radius_m(charge_id: String) -> float:
	return float(get_charge(charge_id)["radius_m"])
