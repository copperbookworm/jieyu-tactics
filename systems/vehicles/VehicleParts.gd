extends RefCounted

## 载具部件系统（docx 8.4 / 第二十八章 · 2026-10-05 拍板）
## 只管纯逻辑：部件目录、部件血量（派生 + 表内覆盖）、瞄高三档、方位权重兜底、三态状态机。
## 把部位结算接进 Vehicle / BallisticsSystem 是下一轮的事（本轮只到数据层与纯函数）。
## 刻意不写 class_name：引用方 preload（见 Cover.gd 头部说明）

const CSV_PATH := "res://data/vehicle_parts.txt"
const VehicleTableScript := preload("res://systems/vehicles/VehicleTable.gd")

# ── 机动型式（vehicles_data.txt 的 mobility 列）──
const MOBILITY_TRACKED := "tracked"
const MOBILITY_WHEELED := "wheeled"
const MOBILITY_ROTARY := "rotary"
const MOBILITIES := [MOBILITY_TRACKED, MOBILITY_WHEELED, MOBILITY_ROTARY]

# ── 瞄高三档（8.4.2）──
enum Gear { TURRET, HULL, MOBILE }

# ── 部件 id ──
const PART_HULL := "hull"
const PART_ENGINE := "engine"
const PART_AMMO_RACK := "ammo_rack"
const PART_FUEL_TANK := "fuel_tank"
const PART_TURRET_RING := "turret_ring"
const PART_TRACK_L := "track_l"
const PART_TRACK_R := "track_r"
const PART_WHEEL_FRONT := "wheel_front"
const PART_WHEEL_REAR := "wheel_rear"
const PART_ROTOR := "rotor"
const PART_TAIL_ROTOR := "tail_rotor"

# ── 三态（8.4.3）──
const STATE_OK := 0
const STATE_DAMAGED := 1
const STATE_DESTROYED := 2

const PART_LABELS := {
	PART_HULL: "车体",
	PART_ENGINE: "发动机",
	PART_AMMO_RACK: "弹药架",
	PART_FUEL_TANK: "油箱",
	PART_TURRET_RING: "炮塔环",
	PART_TRACK_L: "左侧履带",
	PART_TRACK_R: "右侧履带",
	PART_WHEEL_FRONT: "前轮组",
	PART_WHEEL_REAR: "后轮组",
	PART_ROTOR: "旋翼",
	PART_TAIL_ROTOR: "尾桨",
}

const GEAR_LABELS := {Gear.TURRET: "炮塔", Gear.HULL: "车体", Gear.MOBILE: "机动件"}

## 表覆盖列 → 部件 id（空值 / 0 ⇒ 退回派生值）。列名见 data/vehicle_parts.txt 表头。
const HP_COLUMNS := {
	PART_ENGINE: "engine_hp",
	PART_AMMO_RACK: "ammo_rack_hp",
	PART_FUEL_TANK: "fuel_tank_hp",
	PART_TURRET_RING: "turret_ring_hp",
	PART_TRACK_L: "mobility_hp",
	PART_TRACK_R: "mobility_hp",
	PART_WHEEL_FRONT: "mobility_hp",
	PART_WHEEL_REAR: "mobility_hp",
	PART_ROTOR: "mobility_hp",
	PART_TAIL_ROTOR: "mobility_hp",
}

## 没有炮塔的车型（8.4.1：只有「有炮塔或主炮的车」才有炮塔环）
const NO_TURRET_TYPES := ["武装直升机", "非正规载具"]

static var _table := {}
static var _loaded := false


static func load_table() -> Dictionary:
	if _loaded:
		return _table
	_loaded = true
	if not FileAccess.file_exists(CSV_PATH):
		push_error("[载具部件表] 找不到 %s" % CSV_PATH)
		return _table
	var file := FileAccess.open(CSV_PATH, FileAccess.READ)
	if file == null:
		push_error("[载具部件表] 打不开 %s" % CSV_PATH)
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


static func get_row(vehicle_id: String) -> Dictionary:
	return load_table().get(vehicle_id, {})


static func has_row(vehicle_id: String) -> bool:
	return load_table().has(vehicle_id)


# ── 机动型式与部件目录 ──

static func mobility_of(vehicle_id: String) -> String:
	return VehicleTableScript.mobility(VehicleTableScript.get_vehicle(vehicle_id))


static func mobility_parts(mobility: String) -> Array[String]:
	var out: Array[String] = []
	if mobility == MOBILITY_WHEELED:
		out.append(PART_WHEEL_FRONT)
		out.append(PART_WHEEL_REAR)
	elif mobility == MOBILITY_ROTARY:
		out.append(PART_ROTOR)
		out.append(PART_TAIL_ROTOR)
	else:
		out.append(PART_TRACK_L)
		out.append(PART_TRACK_R)
	return out


static func has_turret(vehicle_id: String) -> bool:
	var vehicle := VehicleTableScript.get_vehicle(vehicle_id)
	var kind := VehicleTableScript.text(vehicle, "type", "")
	return not NO_TURRET_TYPES.has(kind)


static func part_catalog_for(vehicle_id: String) -> Array[String]:
	var out: Array[String] = []
	out.append(PART_ENGINE)
	out.append(PART_FUEL_TANK)
	for part in mobility_parts(mobility_of(vehicle_id)):
		out.append(part)
	var vehicle := VehicleTableScript.get_vehicle(vehicle_id)
	if VehicleTableScript.number(vehicle, "ammo", 0.0) > 0.0:
		out.append(PART_AMMO_RACK)
	if has_turret(vehicle_id):
		out.append(PART_TURRET_RING)
	return out


static func gear_of(part: String) -> int:
	if part == PART_TURRET_RING:
		return Gear.TURRET
	if part == PART_ENGINE or part == PART_AMMO_RACK \
			or part == PART_FUEL_TANK or part == PART_HULL:
		return Gear.HULL
	return Gear.MOBILE


static func next_gear(gear: int) -> int:
	return (gear + 1) % 3


static func gear_name(gear: int) -> String:
	return String(GEAR_LABELS.get(gear, "车体"))


static func part_name(part: String) -> String:
	return String(PART_LABELS.get(part, part))


# ── 血量：派生 + 表内覆盖 ──

static func derived_hp(vehicle_hp: float, part: String) -> float:
	var ratio := GameConfig.VEHICLE_PART_HP_MOBILITY
	if part == PART_ENGINE:
		ratio = GameConfig.VEHICLE_PART_HP_ENGINE
	elif part == PART_AMMO_RACK:
		ratio = GameConfig.VEHICLE_PART_HP_AMMO_RACK
	elif part == PART_FUEL_TANK:
		ratio = GameConfig.VEHICLE_PART_HP_FUEL_TANK
	elif part == PART_TURRET_RING:
		ratio = GameConfig.VEHICLE_PART_HP_TURRET_RING
	elif part == PART_ROTOR:
		ratio = GameConfig.VEHICLE_PART_HP_ROTOR
	elif part == PART_TAIL_ROTOR:
		ratio = GameConfig.VEHICLE_PART_HP_TAIL_ROTOR
	return maxf(vehicle_hp * ratio, 1.0)


static func hp_with_row(row: Dictionary, vehicle_hp: float, part: String) -> float:
	var column := String(HP_COLUMNS.get(part, ""))
	if column != "":
		var override := VehicleTableScript.number(row, column, 0.0)
		if override > 0.0:
			return override
	return derived_hp(vehicle_hp, part)


static func part_hp(vehicle_id: String, part: String) -> float:
	var vehicle := VehicleTableScript.get_vehicle(vehicle_id)
	var vehicle_hp := VehicleTableScript.number(vehicle, "hp", 0.0)
	return hp_with_row(get_row(vehicle_id), vehicle_hp, part)


# ── 炮塔装甲（8.4.7）：表内覆盖；空值 ⇒ 沿用该车车体同一面 ──

static func turret_armor_with_row(row: Dictionary, vehicle: Dictionary, side: String) -> float:
	var override := VehicleTableScript.number(row, "turret_armor_%s_mm" % side, 0.0)
	if override > 0.0:
		return override
	return VehicleTableScript.number(vehicle, "armor_%s_mm" % side, 0.0)


static func turret_armor_mm(vehicle_id: String, side: String) -> float:
	return turret_armor_with_row(get_row(vehicle_id),
			VehicleTableScript.get_vehicle(vehicle_id), side)


# ── 三态状态机（8.4.3）──

static func state_from_ratio(ratio: float) -> int:
	if ratio <= 0.0:
		return STATE_DESTROYED
	if ratio <= GameConfig.VEHICLE_PART_DAMAGED_RATIO:
		return STATE_DAMAGED
	return STATE_OK


static func init_parts(vehicle_id: String) -> Dictionary:
	var out := {}
	for part in part_catalog_for(vehicle_id):
		var hp := part_hp(vehicle_id, part)
		out[part] = {"hp": hp, "max_hp": hp, "state": STATE_OK}
	return out


## 扣一件部件的血；返回 {part, applied, state, changed, destroyed}（parts 原地修改）
static func damage_part(parts: Dictionary, part: String, damage: float) -> Dictionary:
	if not parts.has(part):
		return {"part": part, "applied": false, "state": STATE_OK,
				"changed": false, "destroyed": false}
	var entry: Dictionary = parts[part]
	var before := int(entry.get("state", STATE_OK))
	entry["hp"] = maxf(float(entry.get("hp", 0.0)) - maxf(damage, 0.0), 0.0)
	entry["state"] = state_from_ratio(float(entry["hp"])
			/ maxf(float(entry.get("max_hp", 1.0)), 0.001))
	parts[part] = entry
	var after := int(entry["state"])
	return {"part": part, "applied": true, "state": after,
			"changed": after != before, "destroyed": after == STATE_DESTROYED}


static func state_of(parts: Dictionary, part: String) -> int:
	if not parts.has(part):
		return STATE_OK
	return int(parts[part].get("state", STATE_OK))


static func set_state(parts: Dictionary, part: String, state: int) -> void:
	if not parts.has(part):
		return
	var entry: Dictionary = parts[part]
	entry["state"] = state
	if state == STATE_DESTROYED:
		entry["hp"] = 0.0
	parts[part] = entry


# ── 效果（8.4.1）──

static func speed_scale(parts: Dictionary, mobility: String) -> float:
	var scale := 1.0
	var engine := state_of(parts, PART_ENGINE)
	if engine == STATE_DESTROYED:
		return 0.0
	if engine == STATE_DAMAGED:
		scale *= GameConfig.VEHICLE_ENGINE_DAMAGED_SPEED_SCALE
	if mobility == MOBILITY_TRACKED:
		var broken_tracks := 0
		for part in [PART_TRACK_L, PART_TRACK_R]:
			if state_of(parts, part) == STATE_DESTROYED:
				broken_tracks += 1
		if broken_tracks >= 2:
			return 0.0
		if broken_tracks == 1:
			scale *= GameConfig.VEHICLE_TRACK_ONE_SPEED_SCALE
	elif mobility == MOBILITY_WHEELED:
		var wheels: Array[String] = [PART_WHEEL_FRONT, PART_WHEEL_REAR]
		var broken_wheels := 0
		for part in wheels:
			if state_of(parts, part) == STATE_DESTROYED:
				broken_wheels += 1
		if broken_wheels * 2 > wheels.size():
			return 0.0
		if broken_wheels > 0:
			scale *= pow(GameConfig.VEHICLE_WHEEL_ONE_SPEED_SCALE, float(broken_wheels))
	elif mobility == MOBILITY_ROTARY:
		if state_of(parts, PART_ROTOR) == STATE_DESTROYED:
			return 0.0
	return scale


static func turn_scale(parts: Dictionary, mobility: String) -> float:
	if speed_scale(parts, mobility) <= 0.0:
		return 0.0
	if mobility == MOBILITY_TRACKED:
		var broken_tracks := 0
		for part in [PART_TRACK_L, PART_TRACK_R]:
			if state_of(parts, part) == STATE_DESTROYED:
				broken_tracks += 1
		if broken_tracks == 1:
			return GameConfig.VEHICLE_TRACK_ONE_TURN_SCALE
	return 1.0


static func turret_rotate_scale(parts: Dictionary) -> float:
	var state := state_of(parts, PART_TURRET_RING)
	if state == STATE_DESTROYED:
		return 0.0
	if state == STATE_DAMAGED:
		return GameConfig.VEHICLE_TURRET_RING_DAMAGED_ROTATE_SCALE
	return 1.0


static func main_gun_blocked(parts: Dictionary) -> bool:
	return state_of(parts, PART_TURRET_RING) == STATE_DESTROYED


static func fire_dps(parts: Dictionary) -> float:
	if state_of(parts, PART_FUEL_TANK) == STATE_DESTROYED:
		return GameConfig.VEHICLE_FIRE_DPS
	return 0.0


static func is_immobilised(parts: Dictionary, mobility: String) -> bool:
	return speed_scale(parts, mobility) <= 0.0


# ── 方位权重兜底（8.4.6）──

## roll ∈ [0,1) 由调用方给（显式 ⇒ 可无头单测、不依赖随机种子）；
## gear 传 -1 表示不限档（AI / 间瞄 / 爆炸），传具体档位则只在那一档的部件里归一化。
static func roll_part(vehicle_id: String, side: String, gear: int, roll: float) -> String:
	var weights: Dictionary = GameConfig.VEHICLE_PART_WEIGHTS.get(side, {})
	if weights.is_empty():
		return PART_HULL
	var catalog := part_catalog_for(vehicle_id)
	var mobility := mobility_of(vehicle_id)
	var candidates: Array[String] = []
	var weights_out: Array[float] = []
	for key in weights:
		if key == "hull":
			if gear >= 0 and gear != Gear.HULL:
				continue
			candidates.append(PART_HULL)
			weights_out.append(float(weights[key]))
			continue
		var group: Array[String] = []
		if key == "mobility":
			group = mobility_parts(mobility)
		else:
			group.append(String(key))
		for part in group:
			if gear >= 0 and gear_of(part) != gear:
				continue
			if not catalog.has(part):
				continue
			candidates.append(part)
			weights_out.append(float(weights[key]) / float(maxi(group.size(), 1)))
	var total := 0.0
	for w in weights_out:
		total += w
	if candidates.is_empty() or total <= 0.0:
		return PART_HULL
	var target := clampf(roll, 0.0, 0.999999) * total
	var accumulated := 0.0
	for i in candidates.size():
		accumulated += weights_out[i]
		if target < accumulated:
			return candidates[i]
	return candidates[candidates.size() - 1]
