@tool
extends EditorScript

## 《解域》地图工具链自测 · 生成与运行时装配（拆自 jieyu_map_test，2026-10-06 第七十九版）
##
## 拆文件的原因：**测试跑批是进程级分片的**（tools/run_tests_headless.gd --jobs），
## 700+ 行、40 s 的单文件会把整轮跑批钉在一条关键路径上（实测：它一个文件 41.8 s，
## 其余 52 个脚本合计约 3 s）。拆开后三段落在不同分片，关键路径 = 最慢那段。
##
## 编辑器内：脚本编辑器打开本文件 → 文件 → 运行
## 无头：godot --headless --path . --script res://tools/run_tests_headless.gd -- jieyu_map

const GRID_N := 160
## 面板自测用的地图 id（跑完就删，不留产物）
const UI_MAP_ID := "unit_ui_map"

## 面板代码引用的脚本（无头下也能实例化 Control；不依赖任何编辑器 API）
const DOCK_SCRIPT := preload("res://addons/jieyu_map/editor/JieyuMapDock.gd")
const CANVAS_SCRIPT := preload("res://addons/jieyu_map/editor/JieyuMapCanvas.gd")
## 2026-10-03 第三轮：地图数据 → 运行时 Cover 的转换要用它（无 class_name，必须 preload）
const WorldSetupScript := preload("res://scenes/gameplay/WorldSetup.gd")



func _run() -> void:
	_step("噪声生成与可复现（含 world_setup 掩体转换）", _test_generation)

	print("—— 通过 %d 项 / 失败 %d 项 ——" % [_passed, _failed])
	if _failed > 0:
		print("！！ 有 %d 项失败，往上翻 [FAIL] 行看期望值与实际值" % _failed)


func _step(label: String, section: Callable) -> void:
	var t0 := Time.get_ticks_usec()
	var before := _passed + _failed
	section.call()
	print("[段] %-18s %6d ms  %3d 项" % [label, (Time.get_ticks_usec() - t0) / 1000,
			(_passed + _failed) - before])


# ────────────── 断言 ──────────────


func _check(title: String, actual: Variant, expected: Variant) -> void:
	if actual == expected:
		_passed += 1
		print("[OK]   %s" % title)
	else:
		_failed += 1
		print("[FAIL] %s  期望=%s 实际=%s" % [title, str(expected), str(actual)])


func _check_true(title: String, condition: bool) -> void:
	_check(title, condition, true)


func _check_near(title: String, actual: float, expected: float, tolerance: float) -> void:
	if absf(actual - expected) <= tolerance:
		_passed += 1
		print("[OK]   %s (%.3f ≈ %.3f)" % [title, actual, expected])
	else:
		_failed += 1
		print("[FAIL] %s  期望=%.3f±%.3f 实际=%.3f" % [title, expected, tolerance, actual])


# ────────────── 1. 规格与灰度往返 ──────────────


func _test_generation() -> void:
	var recipe := {
		"seed": 20260101,
		"grid_w": GRID_N,
		"grid_h": GRID_N,
		"node_count": 5,
		"settlement_groups": 1,
		"buildings_per_group": 4,
	}
	var a := JieyuMapGen.from_recipe("unit_test_map", recipe)
	var b := JieyuMapGen.from_recipe("unit_test_map", recipe)
	_check("生成文档尺寸", [a.width, a.height_px], [GRID_N, GRID_N])
	_check("高度字节长度", a.height.size(), GRID_N * GRID_N)
	_check("同种子两次生成逐字节一致", a.height == b.height, true)

	var other_seed := recipe.duplicate()
	other_seed["seed"] = 20260102
	var c := JieyuMapGen.from_recipe("unit_test_map", other_seed)
	_check("换种子结果不同", a.height == c.height, false)

	var highest := 0.0
	var lowest := 999.0
	for y in a.height_px:
		for x in a.width:
			var height := a.height_at(x, y)
			highest = maxf(highest, height)
			lowest = minf(lowest, height)
	_check_true("最高点 < 最大海拔 150 m", highest < 150.0)
	_check_true("地形有起伏（最高 > 最低 + 20 m）", highest > lowest + 20.0)

	# 12.8.4：五节点、**相邻**间距落在 200–500 m。
	# ⚠ 间距是「相邻两跳」的口径（六章：点间移动步兵 30–60 s），不是全图任意两点的距离；
	#   而且要在接近真实尺寸的图上验（160 格摆不下 5 个点）。
	var spacing := JieyuMapGen.from_recipe("unit_test_spacing", {
		"seed": 20260101, "grid_w": 900, "grid_h": 900, "node_count": 5,
	})
	var spacing_nodes: Array = spacing.zones.get("raas_nodes", [])
	var step_min := INF
	var step_max := 0.0
	for i in range(spacing_nodes.size() - 1):
		var step := JieyuMapGen.vec2((spacing_nodes[i] as Dictionary)["pos"]).distance_to(
				JieyuMapGen.vec2((spacing_nodes[i + 1] as Dictionary)["pos"]))
		step_min = minf(step_min, step)
		step_max = maxf(step_max, step)
	_check_true("相邻节点间距 ≥ 200 m（900×900 实测 %.0f m）" % step_min,
			step_min >= JieyuMapSpec.NODE_SPACING_MIN_M)
	_check_true("相邻节点间距 ≤ 500 m（实测 %.0f m）" % step_max,
			step_max <= JieyuMapSpec.NODE_SPACING_MAX_M)
	_check_true("任意两点间距 ≥ 200 m（推进链不自重叠；实测 %.0f m）"
			% JieyuMapGen.min_node_spacing(spacing_nodes),
			JieyuMapGen.min_node_spacing(spacing_nodes) >= JieyuMapSpec.NODE_SPACING_MIN_M)
	for node_v in spacing.zones.get("raas_nodes", []):
		var point := JieyuMapGen.vec2((node_v as Dictionary)["pos"])
		_check_true("节点 %s 落在地图内" % str((node_v as Dictionary)["id"]),
				point.x > 0.0 and point.y > 0.0 \
				and point.x < 900.0 and point.y < 900.0)

	# 12.8.4：五结构齐全
	_check("自动布点 5 个节点", (a.zones.get("raas_nodes", []) as Array).size(), 5)
	_check("五结构 flags 数量 = 节点数",
			(a.zones.get("flags", []) as Array).size(),
			(a.zones.get("raas_nodes", []) as Array).size())
	_check("出生区 2 个", (a.zones.get("spawn_areas", []) as Array).size(), 2)
	_check("集结点区数量 = 节点数",
			(a.zones.get("rally_zones", []) as Array).size(),
			(a.zones.get("raas_nodes", []) as Array).size())
	_check_true("生成了遮挡体", a.occluders.size() > 0)
	_check_true("遮挡体都是 building/wall", _all_occluders_valid(a.occluders))
	# 2026-10-03 拍板四条：① 一律可摧毁 ② 按占地给结构值 ③ 摧毁留残痕 ④ 三段阈值
	_check_true("遮挡体全部可摧毁且带 hp（拍板①）", _all_destructible_with_hp(a.occluders))
	_check_true("可摧毁物都带完好/受损/摧毁三段阈值（拍板④）",
			_all_have_damage_profiles(a.occluders))
	_check_true("建筑结构值落在三档里（拍板②：800 / 1200 / 3000）",
			_building_hp_in_tiers(a.occluders))
	_check_true("「摧毁」段不挡视线且带残痕声明（拍板③）",
			_destroyed_profiles_valid(a.occluders))
	# 拍板①开口（第三轮）：只有打中窗 / 门洞才伤得到建筑里面
	_check_true("每栋建筑都带 ≥2 个开口（六章：每个占领点 3 个以上入口/射击窗）",
			_buildings_have_openings(a.occluders, 2))
	_check_true("开口类型合法、几何贴在墙面上、高度区间自洽",
			_openings_valid(a.occluders))
	# 2026-10-03 第三轮：地图数据 → 运行时 Cover 的那一段转换（WorldSetup 的两支纯函数）
	_test_world_setup_covers()
	_check("meta 记录了生成配方", a.meta.has("recipe"), true)
	_check("meta.recipe.seed 与配方一致", int(a.meta["recipe"]["seed"]), 20260101)

	# 河谷：河心被压到水位附近，河道外明显更高（12.8.4 南北向河谷）
	# 注意河宽是有限的 —— 只能比同一条 x 上的「河心 vs 河外」，比全图平均值毫无意义。
	var river := JieyuMapGen.from_recipe("unit_test_river", {
		"seed": 7, "grid_w": GRID_N, "grid_h": GRID_N, "node_count": 3,
		"river_axis": "y", "water_level_m": 5.0, "river_center_ratio": 0.5,
		"river_half_width_m": 40.0,
	})
	var channel := river.height_at(GRID_N / 2, GRID_N / 2)
	var bank_above := river.height_at(GRID_N / 2, 5)
	var bank_below := river.height_at(GRID_N / 2, GRID_N - 5)
	_check_true("河心（x=%d,y=%d）≈ 水位 5 m（实测 %.1f m）"
			% [GRID_N / 2, GRID_N / 2, channel], channel < 8.0)
	_check_true("河北岸明显更高（y=5 → %.1f m）" % bank_above, bank_above > channel + 20.0)
	_check_true("河南岸明显更高（y=%d → %.1f m）" % [GRID_N - 5, bank_below],
			bank_below > channel + 20.0)

	# 2026-10-04：显式给的 raas_nodes 过去**不压平核心**（只有自动布点才压平），而道路是
	# 「沿程坡度受控」的路基 —— 在陡坡上会把走廊抬成一条高于两侧的堤。路基若穿过节点核心，
	# 核心格就会出现远超 30° 的陡坎（实测青岭走廊 N1 核心格 79.3°，校验器报 node.core_not_passable）。
	# 现在两条分支都在道路之后压平：压平是「把圆内高度铺成同一个值」，所以核心半径内高差必须是 0。
	var explicit := JieyuMapGen.from_recipe("unit_test_explicit_nodes", {
		"seed": 20261004, "grid_w": 300, "grid_h": 300,
		"raas_nodes": [{"id": "N1", "name": "甲", "pos": [150, 150]}],
		"roads": [{"name": "路基", "width_m": 8,
			"path": [[150, 20], [150, 150], [150, 280]]}],
	})
	var flat_min := INF
	var flat_max := -INF
	for dy in range(-10, 11):
		for dx in range(-10, 11):
			var sample := explicit.height_at(150 + dx, 150 + dy)
			flat_min = minf(flat_min, sample)
			flat_max = maxf(flat_max, sample)
	_check_near("显式节点的核心半径内被铺平（高差应为 0）", flat_max - flat_min, 0.0, 0.6)

	# 2026-10-04：配方可给显式建筑群锚点（settlements[]）与显式田埂（walls[]）。
	# 背景：六章的「最长无掩体直线 ≤ 300 m」靠自动散点满足不了 —— 手写地图必须能指定
	# 「在哪儿摆村子 / 田埂」。三条落笔路径（建筑 / 节点沙袋圈 / 田埂）都要过 5 m 间距。
	var crafted := JieyuMapGen.from_recipe("unit_test_crafted", {
		"seed": 5, "grid_w": 300, "grid_h": 300,
		"raas_nodes": [{"id": "N1", "name": "甲", "pos": [150, 150]}],
		"settlements": [{"pos": [80, 80], "buildings": 3, "spread_m": 20}],
		"walls": [{"pos": [230, 230], "half_size": [6, 2], "h_top": 1.2}],
	})
	var buildings_near := 0
	var wall_near := 0
	for item_v in crafted.occluders:
		var item: Dictionary = item_v
		var sum := Vector2.ZERO
		for point_v in item["polygon"]:
			sum += JieyuMapGen.vec2(point_v)
		var center: Vector2 = sum / float((item["polygon"] as Array).size())
		if str(item["type"]) == "building" and center.distance_to(Vector2(80, 80)) <= 30.0:
			buildings_near += 1
		elif str(item["type"]) == "wall" and center.distance_to(Vector2(230, 230)) <= 1.0:
			wall_near += 1
	_check("显式建筑群锚点：30 m 内 3 栋", buildings_near, 3)
	_check("显式田埂：指定位置 1 条", wall_near, 1)
	# 自动布点也必须满足 5 m 中心距（校验器 occluders.overlap 就是这个口径）
	var auto_doc := JieyuMapGen.from_recipe("unit_test_gap", {
		"seed": 9, "grid_w": 400, "grid_h": 400, "node_count": 3,
		"settlement_groups": 2, "buildings_per_group": 8,
	})
	_check_true("自动布点也不产生 <5 m 的遮挡体对（实测最小 %.2f m）"
			% _min_occluder_gap(auto_doc.occluders),
			_min_occluder_gap(auto_doc.occluders) >= JieyuMapSpec.URBAN_SPACING_MIN_M)


## 第一张正式地图（2026-10-04）：仓库里的**当前产物**必须始终校验全绿、且能被工程侧读进世界。
## 这条测的不是生成器，是交付物本身 —— 谁手改坏了 JSON / 漏了一张图，这里就会红。

func _destroyed_profiles_valid(occluders: Array) -> bool:
	for item_v in occluders:
		var item: Dictionary = item_v
		for profile_v in (item.get("damage_profiles", []) as Array):
			var profile: Dictionary = profile_v
			if str(profile.get("state", "")) != JieyuMapSpec.DAMAGE_STATE_DESTROYED:
				continue
			if bool(profile.get("blocks_sight", true)):
				return false
			if float(profile.get("height_scale", 1.0)) != 0.0:
				return false
			var rubble: Variant = profile.get("rubble", null)
			if not (rubble is Dictionary):
				return false
			if int((rubble as Dictionary).get("material_id", 0)) \
					!= JieyuMapSpec.RUBBLE_MATERIAL_ID:
				return false
	return true


# ────────────── 4. 画笔 ──────────────


func _building_hp_in_tiers(occluders: Array) -> bool:
	var tiers := [JieyuMapSpec.STRUCTURE_HP_SMALL, JieyuMapSpec.STRUCTURE_HP_HOUSE,
			JieyuMapSpec.STRUCTURE_HP_REINFORCED]
	for item_v in occluders:
		var item: Dictionary = item_v
		if str(item.get("type", "")) != "building":
			continue
		if not tiers.has(float(item.get("hp", 0.0))):
			return false
	return true


## 拍板③：摧毁段必须不挡视线，且给得出残痕（材质 id / 半径系数 / 移速倍率）


func _openings_valid(occluders: Array) -> bool:
	for item_v in occluders:
		var item: Dictionary = item_v
		var openings: Variant = item.get("openings", null)
		if openings == null:
			continue
		if not (openings is Array):
			return false
		var polygon: Array = item.get("polygon", [])
		if polygon.size() < 3:
			return false
		var min_point := Vector2(INF, INF)
		var max_point := Vector2(-INF, -INF)
		for point_v in polygon:
			var point := JieyuMapGen.vec2(point_v)
			min_point = Vector2(minf(min_point.x, point.x), minf(min_point.y, point.y))
			max_point = Vector2(maxf(max_point.x, point.x), maxf(max_point.y, point.y))
		var box := Rect2(min_point, max_point - min_point)
		var half_x := box.size.x * 0.5
		var half_y := box.size.y * 0.5
		var top := float(item.get("h_top", 0.0))
		for opening_v in (openings as Array):
			if not (opening_v is Dictionary):
				return false
			var opening: Dictionary = opening_v
			if not JieyuMapSpec.OPENING_KINDS.has(str(opening.get("type", ""))):
				return false
			var center := JieyuMapGen.vec2(opening.get("center", Vector2.ZERO))
			var half := JieyuMapGen.vec2(opening.get("half_size", Vector2.ZERO))
			if half.x <= 0.0 or half.y <= 0.0:
				return false
			var on_face := absf(absf(center.x) - half_x) <= half.y + 0.01 \
					or absf(absf(center.y) - half_y) <= half.x + 0.01
			if not on_face:
				return false
			var low := float(opening.get("h_low", 0.0))
			var opening_top := float(opening.get("h_top", 0.0))
			if low < 0.0:
				return false
			if opening_top > 0.0 and (opening_top < low or opening_top > top + 0.01):
				return false
	return true


func _buildings_have_openings(occluders: Array, minimum: int) -> bool:
	for item_v in occluders:
		var item: Dictionary = item_v
		if str(item.get("type", "")) != "building":
			continue
		var openings: Variant = item.get("openings", null)
		if not (openings is Array) or (openings as Array).size() < minimum:
			return false
	return true


## 拍板①开口：类型合法、half_size 为正、贴在墙面上（本地坐标）、高度区间自洽


func _test_world_setup_covers() -> void:
	var world_setup := WorldSetupScript.new()
	# ① 示例图（真实存在的那一份）里有 occluders.json ⇒ 应该读得到条目
	var stub := Node.new()
	stub.set_script(_stub_main_script())
	stub.set("map_height_image", "res://assets/maps/grassland_demo2/heightmap.png")
	var entries: Array = world_setup.call("_load_occluders", stub)
	_check_true("WorldSetup 能从示例图目录读出 occluders.json（%d 条）" % entries.size(),
			entries.size() > 0)
	stub.free()
	if entries.is_empty():
		world_setup.free()
		return

	# ② 挑一栋建筑，把它的 openings 走一遍归一化
	var building: Dictionary = {}
	for entry_v in entries:
		if str((entry_v as Dictionary).get("type", "")) == "building":
			building = entry_v
			break
	_check_true("示例图里有建筑条目", not building.is_empty())
	if building.is_empty():
		world_setup.free()
		return
	var raw_openings: Array = building.get("openings", [])
	_check_true("建筑条目带 openings（%d 个）" % raw_openings.size(), raw_openings.size() >= 2)
	var normalized: Array = world_setup.call("_normalized_openings", raw_openings,
			float(building.get("h_top", 0.0)))
	_check("归一化后开口数不变", normalized.size(), raw_openings.size())
	var first: Dictionary = normalized[0] if normalized.size() > 0 else {}
	_check_true("归一化后 center 是 Vector2（JSON 里是 [x,y] 数组）", first.get("center") is Vector2)
	_check_true("归一化后 half_size 是 Vector2", first.get("half_size") is Vector2)
	# h_top = 0 是地图数据里的约定值「到掩体顶」⇒ 归一化时必须换成实际顶高
	var top_values: Array = []
	for opening_v in normalized:
		top_values.append(float((opening_v as Dictionary).get("h_top", 0.0)))
	_check_true("h_top=0 被换成掩体实际顶高（%.1f）" % float(building.get("h_top", 0.0)),
			top_values.has(float(building.get("h_top", 0.0))))
	_check_true("归一化后不存在 h_top=0（约定值不能漏到运行时）", not top_values.has(0.0))
	_check("建筑 h_top=%s ⇒ 开口 h_top 跟着变" % str(building.get("h_top", "")),
			normalized.is_empty(), false)

	# ③ 建筑不吃子弹、半高墙吃子弹（absorbs_bullets 字段）
	_check("建筑 absorbs_bullets = false（普通子弹打不动它）",
			bool(building.get("absorbs_bullets", true)), false)
	var wall: Dictionary = {}
	for entry_v in entries:
		if str((entry_v as Dictionary).get("type", "")) == "wall":
			wall = entry_v
			break
	if not wall.is_empty():
		_check("半高墙 absorbs_bullets = true（子弹 4 发打坏，老手感不变）",
				bool(wall.get("absorbs_bullets", false)), true)
	# ④ 反推地图目录：<id>_height.png 与 <id>/heightmap.png 两种都要认
	_check("从 .../grassland_demo2/heightmap.png 反推 id",
			WorldSetupScript._map_id_from_path("res://assets/maps/grassland_demo2/heightmap.png"),
			"grassland_demo2")
	_check("从 .../demo2_height.png 反推 id",
			WorldSetupScript._map_id_from_path("res://assets/maps/demo2_height.png"), "demo2")
	world_setup.free()


## 造一个只有 map_height_image 属性的替身（WorldSetup._load_occluders 只用这一个字段）


func _stub_main_script() -> GDScript:
	var script := GDScript.new()
	script.source_code = "extends Node\n@export var map_height_image := \"\"\n"
	script.reload()
	return script


## 场上全部开口的总数（面板测试按总数比对：一次落笔会走两次 _apply_brush_at）


func _all_have_damage_profiles(occluders: Array) -> bool:
	var wanted := [JieyuMapSpec.DAMAGE_STATE_INTACT, JieyuMapSpec.DAMAGE_STATE_DAMAGED,
			JieyuMapSpec.DAMAGE_STATE_DESTROYED]
	for item_v in occluders:
		var item: Dictionary = item_v
		if not (item.get("damage_profiles") is Array):
			return false
		var states: Array = []
		for profile_v in (item["damage_profiles"] as Array):
			if not (profile_v is Dictionary):
				return false
			var profile: Dictionary = profile_v
			states.append(str(profile.get("state", "")))
			var scale := float(profile.get("height_scale", 1.0))
			if scale < 0.0 or scale > 1.0:
				return false
		for state in wanted:
			if not states.has(state):
				return false
	return true


## 2026-10-03 第三轮：地图数据 → 运行时 Cover 的转换（直接调 WorldSetup 的两支纯函数）。
## 为什么不去跑一遍完整 WorldSetup：那需要实例化 Main 主场景，代价大且会被 demo 摆位兜底逻辑干扰。
## 这里要钉的是**真源数据**上的转换结果：h_top=0 要换成掩体实际顶高、坐标要变成 Vector2。


func _all_destructible_with_hp(occluders: Array) -> bool:
	for item_v in occluders:
		var item: Dictionary = item_v
		if not bool(item.get("destructible", false)):
			return false
		if not item.has("hp") or float(item["hp"]) <= 0.0:
			return false
	return true


## 拍板④：三段齐全，且比例合法（受损/摧毁的顶高比例必须 ≤ 1）


func _all_occluders_valid(occluders: Array) -> bool:
	for item_v in occluders:
		var item: Dictionary = item_v
		if not item.has("polygon") or (item["polygon"] as Array).size() != 4:
			return false
		if float(item["h_low"]) > float(item["h_top"]):
			return false
		if not ["building", "wall"].has(str(item["type"])):
			return false
	return true


## 拍板①：一律 destructible=true，且必须带 hp（没血量这条规则落不了地）


func _min_occluder_gap(occluders: Array) -> float:
	var centers: Array[Vector2] = []
	for item_v in occluders:
		var polygon: Variant = (item_v as Dictionary).get("polygon", null)
		if not (polygon is Array) or (polygon as Array).size() < 3:
			continue
		var sum := Vector2.ZERO
		for point_v in polygon:
			sum += JieyuMapGen.vec2(point_v)
		centers.append(sum / float((polygon as Array).size()))
	var smallest := INF
	for i in centers.size():
		for j in range(i + 1, centers.size()):
			smallest = minf(smallest, centers[i].distance_to(centers[j]))
	return 0.0 if is_inf(smallest) else smallest

var _passed := 0
var _failed := 0
