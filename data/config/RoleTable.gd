class_name RoleTable
extends RefCounted

## 兵种表（docx 3.1 兵种与装备表 + 4.11.4 侦察兵标记差异（确认稿））
## 注意：新增脚本的 class_name 要等 Godot 扫描过一次项目后才可用；改完代码若报
## 「Identifier ... not declared」，在编辑器里执行「项目 → 重新加载当前项目」即可（2026-09-28 踩到）
## 第一版兵种只决定四件事：标记时效 / 弹匣容量 / 备弹 / 伤害倍率。
## 刻意不动「散布与射速」——那是刚验收过的手感基线，兵种差异先别去搅它。
## 武器名只是标签：真正的「多把枪自由切换 + 武器数据表」属于武器系统重构，不在这一版。
## 侦察兵按 4.11.4 应为「目标指示（call for fire）」：90 s 时效 + 稳定观测 1.5 s + 20 s 冷却
## + 可被间瞄选为目标；第一版只落地最核心的 90 s 时效，其余随间瞄/兵种系统一起做。

enum Role { RIFLEMAN, SCOUT, MARKSMAN }

const ROLES := [
	{
		"id": Role.RIFLEMAN,
		"name": "步枪兵",
		"weapon": "QBZ-191",
		"weapons": ["qbz191", "m17"],
		"mag_size": GameConfig.WEAPON_MAG_SIZE,
		"reserve": GameConfig.WEAPON_RESERVE,
		"damage_scale": 1.0,
		"mark_duration": GameConfig.MARK_DURATION,
		"note": "基准兵种（7.2 武器数据）",
	},
	{
		"id": Role.SCOUT,
		"name": "侦察兵",
		"weapon": "QBU-191",
		"weapons": ["qbu191", "m17"],
		"mag_size": 30,
		"reserve": 120,
		"damage_scale": 1.0,
		"mark_duration": GameConfig.MARK_SCOUT_DURATION,
		"note": "标记 90 s（4.11.4）；官方武器表把 QBU-191 列为侦察兵备选",
	},
	{
		"id": Role.MARKSMAN,
		"name": "精确射手",
		"weapon": "QBU-191",
		"weapons": ["qbu191", "m17"],
		"mag_size": 30,
		"reserve": 120,
		"damage_scale": 1.0,
		"mark_duration": GameConfig.MARK_DURATION,
		"note": "5.8mm 精确射手步枪（官方表：70/45、500 m、MOA 1.5）",
	},
]


static func get_role(role: int) -> Dictionary:
	for entry in ROLES:
		if int(entry["id"]) == role:
			return entry
	return ROLES[0]


static func count() -> int:
	return ROLES.size()


## 调试/切换用：下一个兵种（循环）
static func next_role(role: int) -> int:
	return (role + 1) % ROLES.size()


static func role_name(role: int) -> String:
	return String(get_role(role)["name"])


static func weapon_name(role: int) -> String:
	return String(get_role(role)["weapon"])


static func mag_size(role: int) -> int:
	return int(get_role(role)["mag_size"])


static func reserve(role: int) -> int:
	return int(get_role(role)["reserve"])


static func damage_scale(role: int) -> float:
	return float(get_role(role)["damage_scale"])


static func mark_duration(role: int) -> float:
	return float(get_role(role)["mark_duration"])


## 兵种携带的武器 id 列表（第一版：主武器 + 副武器；换枪就靠它）
static func weapon_ids(role: int) -> Array:
	return get_role(role).get("weapons", [])
