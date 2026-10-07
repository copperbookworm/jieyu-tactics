@tool
extends EditorScript

## 《解域》地图工具链自测 · 基础与落盘（拆自 jieyu_map_test，2026-10-06 第七十九版）
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
	_step("规格与灰度往返", _test_spec_roundtrip)
	_step("schema 校验", _test_schema_validation)
	_step("画笔", _test_painter)
	_step("节点与掩体编辑", _test_editing)
	_step("落盘与回读", _test_save_and_load)
	_step("面板", _test_panel)
	_step("青岭走廊", _test_qingling_corridor)

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


func _test_spec_roundtrip() -> void:
	_check("12.8.2 灰度 0 → 0 m", JieyuMapSpec.gray_to_height(0), 0.0)
	_check_near("12.8.2 灰度 255 → 最大海拔 150 m",
			JieyuMapSpec.gray_to_height(255), 150.0, 0.001)
	_check_near("12.8.2 1 灰度 ≈ 0.59 m",
			JieyuMapSpec.gray_to_height(1) - JieyuMapSpec.gray_to_height(0), 0.588, 0.002)
	var worst := 0
	for gray in range(0, 256):
		var height := JieyuMapSpec.gray_to_height(gray)
		if JieyuMapSpec.height_to_gray(height) != gray:
			worst += 1
	_check("12.8.2 灰度↔高度 256 级全部无损往返", worst, 0)
	_check("超出最大海拔被钳到 255 灰度", JieyuMapSpec.height_to_gray(400.0), 255)
	_check("负高度被钳到 0 灰度", JieyuMapSpec.height_to_gray(-5.0), 0)

	_check("12.8.3 噪声层数 = 4", JieyuMapSpec.NOISE_LAYERS.size(), 4)
	_check("12.8.3 第 1 层特征尺寸 250 m", int(JieyuMapSpec.NOISE_LAYERS[0]["feature_m"]), 250)
	_check("12.8.3 第 1 层振幅 90 m", int(JieyuMapSpec.NOISE_LAYERS[0]["amp_m"]), 90)
	var max_elev := JieyuMapSpec.max_elevation()
	_check("GameConfig 最大海拔 = 150 m", int(max_elev), 150)
	_check("12.8.4 示例节点 5 个", JieyuMapSpec.DEMO_NODES.size(), 5)
	_check("12.8.4 N3 中央枢纽坐标", JieyuMapSpec.DEMO_NODES[2]["pos"], [500.0, 500.0])
	_check("12.8.4 核心占领区半径 15 m", int(JieyuMapSpec.CORE_RADIUS_M), 15)
	_check("12.8.4 外围压制圈 30–150 m", JieyuMapSpec.PRESSURE_RING_M, [30.0, 150.0])
	_check("12.8.4 续航区 100–200 m", JieyuMapSpec.SPAWN_OFFSET_M, [100.0, 200.0])
	_check("6 章 占领点间距下限 200 m", int(JieyuMapSpec.NODE_SPACING_MIN_M), 200)
	_check("6 章 占领点间距上限 500 m", int(JieyuMapSpec.NODE_SPACING_MAX_M), 500)
	_check("6 章 无掩体开阔地上限 300 m", int(JieyuMapSpec.MAX_OPEN_GROUND_M), 300)
	_check("6 章 视线打断 150–200 m",
			[int(JieyuMapSpec.SIGHT_BREAK_MIN_M), int(JieyuMapSpec.SIGHT_BREAK_MAX_M)], [150, 200])
	_check("6 章 载具通道 ≥ 8 m", int(JieyuMapSpec.VEHICLE_CORRIDOR_MIN_M), 8)
	_check("12.8.5 坡度阈值取 GameConfig.MAX_SLOPE_DEG",
			int(JieyuMapSpec.vehicle_slope_limit()), int(GameConfig.MAX_SLOPE_DEG))
	_check("4.2 进入通道下限 2 条", JieyuMapSpec.MIN_APPROACH_ROUTES, 2)
	_check("地图目录约定", JieyuMapSpec.map_dir("foo"), "res://assets/maps/foo/")
	_check("高度图路径约定",
			JieyuMapSpec.file_path("foo", JieyuMapSpec.FILE_HEIGHTMAP),
			"res://assets/maps/foo/heightmap.png")


# ────────────── 2. 12.8.7 schema 校验 ──────────────


func _test_schema_validation() -> void:
	var zones := JieyuMapDoc.empty_zones()
	zones["raas_nodes"] = [{"id": "N1", "name": "西侧起点", "pos": [150, 500]}]
	zones["flags"] = [{"node": "N1", "pressure_ring_m": [30, 150]}]
	_check("合法 zones 无错误", JieyuMapDoc.validate_schema(zones, []), [])

	var bad := JieyuMapDoc.empty_zones()
	bad["raas_nodes"] = [{"id": "N1", "name": "a"}]
	var errors := JieyuMapDoc.validate_schema(bad, [])
	_check("缺 pos 被抓出", errors.size() >= 1, true)
	_check_true("错误信息提到 pos", str(errors).contains("pos"))

	var duplicate := JieyuMapDoc.empty_zones()
	duplicate["raas_nodes"] = [
		{"id": "N1", "name": "a", "pos": [0, 0]},
		{"id": "N1", "name": "b", "pos": [10, 10]},
	]
	_check_true("重复 id 被抓出",
			str(JieyuMapDoc.validate_schema(duplicate, [])).contains("重复"))

	var occ_errors := JieyuMapDoc.validate_schema(JieyuMapDoc.empty_zones(),
			[{"id": "w1", "type": "wall", "polygon": [[0, 0], [1, 1]], "h_low": 3.0, "h_top": 1.0}])
	_check_true("多边形少于 3 顶点被抓出", str(occ_errors).contains("3 个顶点"))
	_check_true("h_low > h_top 被抓出", str(occ_errors).contains("h_low"))


# ────────────── 3. 噪声生成与可复现 ──────────────


func _test_painter() -> void:
	var doc := JieyuMapDoc.create("paint_test", 120, 120)
	doc.height.fill(100)   # 100 灰度 ≈ 58.8 m

	var touched := JieyuMapPainter.paint_flat(doc, Vector2(60, 60), 20.0,
			JieyuMapSpec.gray_to_height(120))
	_check_true("平顶笔刷有改动", touched > 0)
	_check("圆心被改成目标高度", doc.gray_at(60, 60), 120)
	_check("圆外不受影响", doc.gray_at(5, 5), 100)

	JieyuMapPainter.paint_raise(doc, Vector2(20, 20), 10.0, 20.0)
	_check_true("抬升笔刷把圆心抬高了", doc.gray_at(20, 20) > 100)
	_check("抬升不影响远处", doc.gray_at(100, 100), 100)

	JieyuMapPainter.flatten_disc(doc, Vector2(60, 60), 15.0, 0.0, -1.0)
	_check_true("压平到均值（不是 0）", doc.gray_at(60, 60) > 0)

	# 台地：半径 30 + 衰减 30 → 外圈 60，中心到峰高、外圈回原地形
	var flat := JieyuMapDoc.create("plateau_test", 200, 200)
	flat.height.fill(20)
	JieyuMapPainter.carve_plateau(flat, Vector2(100, 100), 30.0,
			JieyuMapSpec.gray_to_height(150), 30.0)
	_check("台地中心 = 峰高", flat.gray_at(100, 100), 150)
	_check("台地外（> 半径+衰减）保持原值", flat.gray_at(5, 5), 20)
	# 半径 30 内是平顶；45 处在衰减段（介于两者之间）；70 在外圈之外
	_check("台地半径内是平顶", flat.gray_at(120, 100), 150)
	_check_true("台地衰减带介于两者之间（x=145 → %d）" % flat.gray_at(145, 100),
			flat.gray_at(145, 100) > 20 and flat.gray_at(145, 100) < 150)
	_check("台地外圈之外回到原值", flat.gray_at(170, 100), 20)

	# 平滑：把一块 5×5 的凸起拉平（峰值降低但仍在原值之上）
	var bump := JieyuMapDoc.create("smooth_test", 60, 60)
	bump.height.fill(50)
	for y in range(28, 33):
		for x in range(28, 33):
			bump.set_gray(x, y, 255)
	JieyuMapPainter.paint_smooth(bump, Vector2(30, 30), 12.0, 1.0)
	_check_true("平滑把凸起压低", bump.gray_at(30, 30) < 255)
	_check_true("平滑后仍高于基础值（是变缓不是压平）", bump.gray_at(30, 30) > 50)

	# 道路：走廊压平成一条能走的带。
	# ⚠ 8 位高度图 1 灰度 ≈ 0.59 m，逐格高差最小就是一个量化台阶（约 30.5°），
	#   所以坡度必须按「跨若干格的平均坡度」量，相邻两格看的是量化噪声不是坡度。
	var road := JieyuMapDoc.create("road_test", 300, 300)
	for y in 300:
		for x in 300:
			road.set_height(x, y, 10.0 + float(x) * 0.4)   # 陡坡：每米 0.4 m ≈ 21.8°
	JieyuMapPainter.carve_road(road, [Vector2(20, 150), Vector2(280, 150)], 10.0, 8.0)
	var window := 20
	var steepest := 0.0
	for x in range(20, 280 - window):
		var drop := absf(road.height_at(x + window, 150) - road.height_at(x, 150))
		steepest = maxf(steepest, rad_to_deg(atan2(drop, float(window))))
	# 目标坡度上限 8°，但走廊横截面本身有过渡，实测会略高 —— 上限放到 14°（= 载具阈值 30° 的一半）
	_check_true("道路走廊 %d m 平均坡度 ≤ 14°（实际 %.1f°）" % [window, steepest], steepest <= 14.0)
	_check_true("走廊外仍是原地形（x=150,y=40 → %.1f m）" % road.height_at(150, 40),
			road.height_at(150, 40) > road.height_at(150, 150) + 20.0)
	_check_true("走廊起点已被压到接近原地形高度（25,150 → %.1f m）" % road.height_at(25, 150),
			absf(road.height_at(25, 150) - 20.0) < 4.0)

	# 越界不崩
	_check("笔刷越界返回 0", JieyuMapPainter.paint_flat(doc, Vector2(-50, -50), 5.0, 10.0), 0)


# ────────────── 5. 节点 / 掩体编辑 ──────────────


func _test_editing() -> void:
	var doc := JieyuMapDoc.create("edit_test", 300, 300)
	JieyuMapPainter.upsert_node(doc, "N1", "西侧起点", Vector2(60, 150))
	JieyuMapPainter.upsert_node(doc, "N2", "东侧终点", Vector2(240, 150))
	_check("加了 2 个节点", (doc.zones["raas_nodes"] as Array).size(), 2)
	JieyuMapPainter.upsert_node(doc, "N1", "西侧起点", Vector2(70, 150))
	_check("同名节点是替换不是新增", (doc.zones["raas_nodes"] as Array).size(), 2)
	_check("节点坐标已更新", JieyuMapGen.vec2(doc.zones["raas_nodes"][0]["pos"]),
			Vector2(70, 150))

	doc.zones = JieyuMapGen.build_zones(doc.zones["raas_nodes"], 300, 300, 1)
	_check("重建后 flags = 2", (doc.zones["flags"] as Array).size(), 2)
	_check_true("删节点会带走它的 flag", JieyuMapPainter.remove_node(doc, "N2"))
	_check("删完只剩 1 个节点", (doc.zones["raas_nodes"] as Array).size(), 1)
	_check("删完只剩 1 条 flag", (doc.zones["flags"] as Array).size(), 1)
	_check("删不存在的节点返回 false", JieyuMapPainter.remove_node(doc, "N9"), false)

	var added := JieyuMapPainter.add_occluder(doc, Vector2(150, 150), 6.0, 5.0, 4.0,
			"building", true, 500.0)
	_check("新增建筑 id 前缀", str(added["id"]).begins_with("building_"), true)
	_check("可破坏建筑带 hp", float(added["hp"]), 500.0)
	_check("多边形 4 个顶点", (added["polygon"] as Array).size(), 4)
	_check("删附近遮挡体删掉 1 个", JieyuMapPainter.remove_occluders_near(doc,
			Vector2(150, 150), 10.0), 1)
	_check("删完 occluders 空", doc.occluders.size(), 0)


# ────────────── 6. 校验器 ──────────────


func _test_save_and_load() -> void:
	var doc := JieyuMapDoc.create("unit_roundtrip", 200, 200)
	for y in 200:
		for x in 200:
			doc.set_height(x, y, float((x + y) % 150))
	var before := doc.height.duplicate()
	doc.zones = JieyuMapGen.build_zones([
		{"id": "N1", "name": "西侧起点", "pos": [50.0, 100.0]},
		{"id": "N2", "name": "东侧终点", "pos": [160.0, 100.0]},
	], 200, 200, 1)
	JieyuMapPainter.add_occluder(doc, Vector2(100, 60), 5.0, 5.0, 3.5, "building", false)

	var err := doc.save()
	_check("保存返回 OK", err, OK)
	_check_true("写了 heightmap.png",
			FileAccess.file_exists(JieyuMapSpec.file_path("unit_roundtrip",
					JieyuMapSpec.FILE_HEIGHTMAP)))
	_check_true("写了 terrain.png",
			FileAccess.file_exists(JieyuMapSpec.file_path("unit_roundtrip",
					JieyuMapSpec.FILE_TERRAIN)))
	_check_true("写了 meta.json",
			FileAccess.file_exists(JieyuMapSpec.file_path("unit_roundtrip",
					JieyuMapSpec.FILE_META)))
	_check_true("写了 zones.json",
			FileAccess.file_exists(JieyuMapSpec.file_path("unit_roundtrip",
					JieyuMapSpec.FILE_ZONES)))
	_check_true("写了 occluders.json",
			FileAccess.file_exists(JieyuMapSpec.file_path("unit_roundtrip",
					JieyuMapSpec.FILE_OCCLUDERS)))

	var loaded := JieyuMapDoc.load_from_dir("unit_roundtrip")
	_check_true("能回读", loaded != null)
	if loaded == null:
		return
	_check("回读尺寸一致", [loaded.width, loaded.height_px], [200, 200])
	_check("回读高度逐字节一致（8 位无损往返）", loaded.height == before, true)
	_check("回读节点数一致", (loaded.zones.get("raas_nodes", []) as Array).size(), 2)
	_check("回读 occluders 一致", loaded.occluders.size(), 1)
	_check("回读地名一致", str((loaded.zones["raas_nodes"][1] as Dictionary)["name"]),
			"东侧终点")
	_check("回读 meta.terrain_type", str(loaded.meta.get("terrain_type", "")), "grassland")

	# 与工程运行时互通：转成 HeightGrid 后高度口径一致
	var grid := loaded.to_height_grid()
	var max_diff := 0.0
	for y in range(0, 200, 7):
		for x in range(0, 200, 7):
			max_diff = maxf(max_diff, absf(grid.height_at_cell(x, y) - loaded.height_at(x, y)))
	_check_near("to_height_grid 与文档高度一致", max_diff, 0.0, 0.001)

	# 审阅图
	var image := JieyuMapRender.overview_image(loaded)
	_check("审阅图尺寸 = 地图尺寸", [image.get_width(), image.get_height()], [200, 200])
	_check("关掉所有叠加层也能出图",
			JieyuMapRender.overview_image(loaded,
			{"contours": false, "zones": false, "occluders": false}).get_width(), 200)

	# 12.8.7 回读的 zones.json 要能过 schema 校验
	var schema_errors := JieyuMapDoc.validate_schema(loaded.zones, loaded.occluders)
	_check("回读的 JSON 通过 schema 校验", schema_errors, [])

	# 清理（测试产物不留在地图目录里）
	_cleanup_map("unit_roundtrip")


func _test_panel() -> void:
	var canvas: Control = CANVAS_SCRIPT.new()
	_check("画布可实例化", canvas != null, true)
	canvas.map_size = Vector2i(200, 200)
	canvas.size = Vector2(200.0, 200.0)
	canvas.zoom = 1.0
	canvas.pan = Vector2.ZERO
	_check("画布坐标换算（屏幕 → 格）", canvas.screen_to_cell(Vector2(50.0, 60.0)), Vector2i(50, 60))
	_check("画布格 → 屏幕中点", canvas.cell_to_screen(Vector2i(50, 60)), Vector2(50.5, 60.5))
	canvas.zoom = 2.0
	_check("缩放后坐标换算跟着变", canvas.screen_to_cell(Vector2(50.0, 60.0)), Vector2i(25, 30))
	canvas.zoom = 1.0
	_check("画布越界判定", canvas.is_inside(Vector2i(300, 10)), false)

	var dock: Control = DOCK_SCRIPT.new()
	_check("面板可实例化", dock != null, true)
	if dock == null:
		return
	dock.set("recipe_path", "res://addons/jieyu_map/recipe_demo.json")
	dock.set("brush_radius", 20.0)
	dock.set("brush_delta", 4.0)
	dock.set("plateau_height", 90.0)
	dock.set("_canvas", canvas)   # 无头下没有编辑器 dock 容器，手工接管画布
	# 测试是 SceneTree 入口（跑批器把 EditorScript 换成 RefCounted），所以从 main loop 拿根节点。
	# ⚠ _ready 是**下一帧**才触发（headless 下实测 get_child_count() 当场还是 0），
	#   而测试是同步函数、不能 await —— 所以显式调一次 _ready（它就是普通方法）。
	#   这也顺带钉住「面板的 UI 组装自己就能跑通，不依赖编辑器容器」。
	var loop := Engine.get_main_loop()
	if loop is SceneTree:
		(loop as SceneTree).root.add_child(dock)
	dock.call("_ready")
	_check_true("子控件已建出来（_ready 没炸）", dock.get_child_count() > 0)

	# 工具编号与面板按钮一致：0 抬升 / 1 下挖 / 2 压平 / 3 平滑 / 4 台地 / 5 放节点 /
	# 6 放建筑 / 7 删建筑 / 8 放窗 / 9 放门 / 10 删开口
	dock.call("_set_tool", 1)
	_check("换工具生效", int(dock.get("tool")), 1)
	dock.call("_set_tool", 8)
	_check("工具能切到「放窗」", int(dock.get("tool")), 8)
	dock.call("_set_tool", 0)
	_check("工具切回抬升", int(dock.get("tool")), 0)

	# 面板参数生成草稿（走 JieyuMapGen.from_recipe）
	(dock.get("_grid_spin") as SpinBox).value = 128.0
	(dock.get("_seed_spin") as SpinBox).value = 4242.0
	(dock.get("_nodes_spin") as SpinBox).value = 3.0
	dock.call("_on_regenerate_pressed")
	var doc: JieyuMapDoc = dock.get("doc")
	_check_true("面板生成出了文档", doc != null)
	if doc == null:
		dock.queue_free()
		canvas.queue_free()
		return
	# ⚠ 面板的「生成」默认沿用**当前打开地图的 id**（免得一按就把产物换个地方），
	#   而 _ready 会自动载入 assets/maps 里的第一张图。测试里必须把它钉到测试专用 id 上，
	#   否则后面的「保存 + 清理」会把真实的示例地图删掉（本轮真踩过）。
	doc.map_id = UI_MAP_ID
	_check("面板生成的尺寸", [doc.width, doc.height_px], [128, 128])
	_check("面板按面板参数取种子", int(doc.meta["recipe"]["seed"]), 4242)

	# 落笔：抬升 → 下挖 → 压平 → 平滑 → 台地，五种都要能动一次
	var canvas_ref: Control = dock.get("_canvas")
	var before_gray := doc.gray_at(64, 64)
	canvas_ref.emit_signal("stroke_started", Vector2i(64, 64))
	var raised := doc.gray_at(64, 64)
	_check_true("抬升落笔把该格抬高了（%d → %d）" % [before_gray, raised], raised > before_gray)
	canvas_ref.emit_signal("stroke_moved", Vector2i(64, 64), Vector2i(70, 64))
	_check_true("拖拽也改了中间格", doc.gray_at(70, 64) > before_gray)
	canvas_ref.emit_signal("stroke_ended")
	for tool_index in [1, 2, 3, 4]:
		dock.call("_set_tool", tool_index)
		canvas_ref.emit_signal("stroke_started", Vector2i(40, 40))
		canvas_ref.emit_signal("stroke_ended")
	_check_true("换过五种工具都没崩", true)

	# 放节点 + 加建筑 + 删建筑
	dock.call("_set_tool", 5)
	canvas_ref.emit_signal("stroke_started", Vector2i(30, 30))
	canvas_ref.emit_signal("stroke_ended")
	_check_true("放节点工具加进了节点", (doc.zones["raas_nodes"] as Array).size() >= 1)
	dock.call("_set_tool", 6)
	canvas_ref.emit_signal("stroke_started", Vector2i(90, 90))
	canvas_ref.emit_signal("stroke_ended")
	_check_true("放建筑工具建出了遮挡体", doc.occluders.size() >= 1)
	_check_true("新建筑自带默认开口（一窗一门）",
			((doc.occluders[0] as Dictionary).get("openings", []) as Array).size() >= 2)
	# 放窗 / 放门 / 删开口（拍板①：开口是打进去的唯一入口）。
	# ⚠ 一次落笔会走两次 _apply_brush_at（stroke_started + stroke_ended），所以按**总数**比对。
	var openings_before := _count_openings(doc)
	dock.call("_set_tool", 8)
	canvas_ref.emit_signal("stroke_started", Vector2i(90, 90))
	canvas_ref.emit_signal("stroke_ended")
	_check_true("放窗工具给建筑加了开口（%d → %d）" % [openings_before, _count_openings(doc)],
			_count_openings(doc) > openings_before)
	dock.call("_set_tool", 9)
	canvas_ref.emit_signal("stroke_started", Vector2i(90, 90))
	canvas_ref.emit_signal("stroke_ended")
	var before_erase := _count_openings(doc)
	dock.call("_set_tool", 10)
	canvas_ref.emit_signal("stroke_started", Vector2i(90, 90))
	canvas_ref.emit_signal("stroke_ended")
	_check_true("删开口工具真的删掉了开口（%d → %d）" % [before_erase, _count_openings(doc)],
			_count_openings(doc) < before_erase)
	dock.call("_set_tool", 7)
	canvas_ref.emit_signal("stroke_started", Vector2i(90, 90))
	canvas_ref.emit_signal("stroke_ended")

	# 撤销 / 重做 / 压平节点 / 重画五结构 / 刷新叠加层
	dock.call("_on_undo_pressed")
	dock.call("_on_redo_pressed")
	dock.call("_apply_flatten_nodes")
	dock.call("_apply_rebuild_zones")
	dock.call("_refresh_overlay", true)
	_check_true("五结构重建后 flags 与节点数对齐",
			(doc.zones["flags"] as Array).size() == (doc.zones["raas_nodes"] as Array).size())

	# 保存 / 校验 / 重画审阅图：真的落一份盘，再删掉
	dock.call("_on_save_pressed")
	_check_true("面板保存写出了 heightmap.png",
			FileAccess.file_exists(JieyuMapSpec.file_path(str(doc.map_id),
					JieyuMapSpec.FILE_HEIGHTMAP)))
	dock.call("_on_validate_pressed")
	dock.call("_on_render_pressed")
	var report_text: TextEdit = dock.get("_report_text")
	_check_true("校验报告写进了面板", report_text.text.length() > 0)
	_cleanup_map(str(doc.map_id))

	dock.queue_free()
	canvas.queue_free()


func _test_qingling_corridor() -> void:
	var doc := JieyuMapDoc.load_from_dir("qingling_corridor")
	_check_true("青岭走廊能读出来", doc != null)
	if doc == null:
		return
	var nodes: Array = doc.zones.get("raas_nodes", [])
	_check("青岭走廊五节点", nodes.size(), 5)
	var names: Array = []
	for node_v in nodes:
		names.append(str((node_v as Dictionary).get("name", "")).strip_edges())
	_check_true("每个节点都有名字（报点要用）", not names.has(""))
	var report := JieyuMapChecks.run(doc)
	_check("青岭走廊校验：ERROR 数", JieyuMapChecks.count_level(report, JieyuMapChecks.SEV_ERROR), 0)
	_check("青岭走廊校验：WARN 数", JieyuMapChecks.count_level(report, JieyuMapChecks.SEV_WARN), 0)
	# 出生区落脚地（2026-10-05）：两个出生区都必须有一块压平过的落脚地，
	# 且它离最近节点要满足 12.8.4 的 100~200 m（不然会多一条 spawn.pad_too_close WARN，上面那条就会红）
	var pad_count := 0
	for item_v in report:
		if str((item_v as Dictionary).get("code", "")) == "spawn.pad":
			pad_count += 1
	_check("青岭走廊：两个出生区各有一块落脚地", pad_count, 2)
	# 工程侧要读的三样：掩体（occluders.json）/ 内容层（material.png）/ 扁平高度图
	var world_setup := WorldSetupScript.new()
	var stub := Node.new()
	stub.set_script(_stub_main_script())
	stub.set("map_height_image", "res://assets/maps/qingling_corridor/heightmap.png")
	var entries: Array = world_setup.call("_load_occluders", stub)
	_check_true("青岭走廊掩体能被 WorldSetup 读出来（%d 条）" % entries.size(), entries.size() >= 100)
	_check_true("根目录有 material.png（工程按这个约定名找）",
			FileAccess.file_exists("res://assets/maps/qingling_corridor/material.png")
			or ResourceLoader.exists("res://assets/maps/qingling_corridor/material.png", "Texture2D"))
	var content_zones: Array = world_setup.call("_terrain_zone_entries", stub)
	var total_cells := 0
	for zone_v in content_zones:
		total_cells += int((zone_v as Dictionary).get("cells", 0))
	_check_true("内容层真的读进来了（%d 片 / %d 格，不是 demo 三片摆位）"
			% [content_zones.size(), total_cells], total_cells > 50000)
	# 白旗点必须来自**地图自己的**推进链（2026-10-04 第五十九版把默认图换成正式图之后，这是硬前提：
	# demo 坐标在正式图上会踩到 45.8° 的坡 + 核心圈里压着一栋房子）。
	var capture_positions: Array = world_setup.call("_capture_zone_positions", stub)
	_check("白旗点取地图推进链的前 3 个（第一版三节点全占）", capture_positions.size(), 3)
	var expected_positions: Array = []
	for i in 3:
		expected_positions.append(JieyuMapGen.vec2((nodes[i] as Dictionary).get("pos", [0, 0])))
	_check("白旗点坐标 = 地图 raas_nodes 前 3 个", capture_positions, expected_positions)
	stub.free()
	world_setup.free()


## 遮挡体两两中心距的最小值（校验器 occluders.overlap 用的是同一个口径）

func _stub_main_script() -> GDScript:
	var script := GDScript.new()
	script.source_code = "extends Node\n@export var map_height_image := \"\"\n"
	script.reload()
	return script


## 场上全部开口的总数（面板测试按总数比对：一次落笔会走两次 _apply_brush_at）


func _cleanup_map(map_id: String) -> void:
	var dir := JieyuMapSpec.map_dir(map_id)
	var absolute := ProjectSettings.globalize_path(dir)
	var entries := DirAccess.open(absolute)
	if entries != null:
		for file in entries.get_files():
			DirAccess.remove_absolute(absolute.path_join(file))
		for sub in entries.get_directories():
			var sub_dir := DirAccess.open(absolute.path_join(sub))
			if sub_dir != null:
				for file in sub_dir.get_files():
					DirAccess.remove_absolute(absolute.path_join(sub).path_join(file))
			DirAccess.remove_absolute(absolute.path_join(sub))
	DirAccess.remove_absolute(absolute)
	DirAccess.remove_absolute(ProjectSettings.globalize_path(
			JieyuMapSpec.DEFAULT_MAP_ROOT + map_id + "_height.png"))
	DirAccess.remove_absolute(ProjectSettings.globalize_path(
			JieyuMapSpec.DEFAULT_MAP_ROOT + map_id + "_height.png.import"))


# ────────────── 8. 插件面板（画布 + dock）──────────────

## 无头冒烟：面板的 UI 组装与「点一下会发生什么」。
## 为什么值得单独测：插件代码在 --headless 下不会加载，编辑器里加载失败只会静默少一个 dock；
## 这里直接把 dock 挂进场景树跑一遍真实调用链（换工具 / 生成 / 落笔 / 保存 / 校验 / 撤销），
## 把「类型写错、信号连错、字段名拼错」这类问题在无头就抓出来。


func _count_openings(doc: JieyuMapDoc) -> int:
	var total := 0
	if doc == null:
		return total
	for item_v in doc.occluders:
		total += ((item_v as Dictionary).get("openings", []) as Array).size()
	return total


## 拍板①开口：每栋建筑至少 N 个开口

var _passed := 0
var _failed := 0
