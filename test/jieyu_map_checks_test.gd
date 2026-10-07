@tool
extends EditorScript

## 《解域》地图工具链自测 · 校验器（拆自 jieyu_map_test，2026-10-06 第七十九版）
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
	_step("校验器（单段 24 s：合规大图有 1076 块掩体，出生区采样 × 全表掩体距离 = O(n·m)）", _test_checks)

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


func _test_checks() -> void:
	# ① 一份能全绿的图：手摆 5 个节点 + 完整五结构 + 均匀掩体 + 平 terrain
	var doc := JieyuMapDoc.create("check_ok", 1000, 1000)
	doc.height.fill(JieyuMapSpec.height_to_gray(60.0))
	var nodes: Array = []
	var xs := [150, 340, 500, 670, 850]
	var ys := [500, 300, 500, 700, 500]
	for i in 5:
		nodes.append({"id": "N%d" % (i + 1), "name": "点%d" % (i + 1),
				"pos": [float(xs[i]), float(ys[i])]})
	doc.zones = JieyuMapGen.build_zones(nodes, 1000, 1000, 1)
	# 掩体：每 30 m 一个，避开核心区（核心 15 m）
	var gx := 30
	while gx < 1000:
		var gy := 30
		while gy < 1000:
			var point := Vector2(float(gx), float(gy))
			var blocked := false
			for node_v in nodes:
				if point.distance_to(JieyuMapGen.vec2((node_v as Dictionary)["pos"])) \
						< JieyuMapSpec.CORE_RADIUS_M + 10.0:
					blocked = true
					break
			if not blocked:
				JieyuMapPainter.add_occluder(doc, point, 3.0, 3.0, 2.0, "building", false)
			gy += 30
		gx += 30
	var report := JieyuMapChecks.run(doc)
	_check("手工摆的合规图 ERROR = 0", JieyuMapChecks.count_level(report, JieyuMapChecks.SEV_ERROR), 0)

	# ② 节点太近 → ERROR
	var too_close := doc.create("check_close", 1000, 1000)
	too_close.height.fill(100)
	too_close.zones = JieyuMapGen.build_zones([
		{"id": "N1", "name": "a", "pos": [100.0, 100.0]},
		{"id": "N2", "name": "b", "pos": [180.0, 100.0]},
	], 1000, 1000, 1)
	var close_report := JieyuMapChecks.run(too_close)
	_check_true("节点间距 80 m 被抓出",
			_has_code(close_report, "nodes.spacing_min"))

	# ③ 命名重复 → ERROR
	too_close.zones["raas_nodes"][0]["name"] = "同一名"
	too_close.zones["raas_nodes"][1]["name"] = "同一名"
	_check_true("地名重复被抓出",
			_has_code(JieyuMapChecks.run(too_close), "naming.duplicate"))

	# ④ 核心区里放建筑 → ERROR
	var in_core := doc.create("check_core", 400, 400)
	in_core.height.fill(100)
	in_core.zones = JieyuMapGen.build_zones([
		{"id": "N1", "name": "a", "pos": [200.0, 200.0]},
	], 400, 400, 1)
	JieyuMapPainter.add_occluder(in_core, Vector2(200, 200), 5.0, 5.0, 4.0, "building", false)
	_check_true("核心区内建筑被抓出",
			_has_code(JieyuMapChecks.run(in_core), "occluders.in_core"))

	# ⑤ 进入通道只有 1 条 → ERROR（4.2）
	in_core.zones["flags"][0]["approach_routes"] = 1
	_check_true("进入通道 < 2 被抓出",
			_has_code(JieyuMapChecks.run(in_core), "flags.approach_routes"))

	# ⑥ 尺寸不是 1000×1000 → WARN；flags 悬空 → ERROR
	var odd := doc.create("check_odd", 256, 256)
	odd.height.fill(100)
	odd.zones = JieyuMapDoc.empty_zones()
	odd.zones["raas_nodes"] = [{"id": "N1", "name": "a", "pos": [100, 100]}]
	odd.zones["flags"] = [{"node": "NX", "pressure_ring_m": [30, 150]}]
	var odd_report := JieyuMapChecks.run(odd)
	_check_true("非 1000×1000 被提示", _has_code(odd_report, "grid.size"))
	_check_true("flags 悬空被抓出", _has_code(odd_report, "flags.dangling"))
	_check_true("缺 spawn_offset_m 被抓出", _has_code(odd_report, "flags.spawn_offset"))
	_check_true("summary 里写着错误数",
			JieyuMapChecks.summary(odd_report).contains("错误"))

	# ⑦ 核心格站在陡坡上 → ERROR
	var steep := doc.create("check_steep", 200, 200)
	for y in 200:
		for x in 200:
			steep.set_height(x, y, float(x) * 0.8)   # 每米 0.8 m ≈ 38.7°
	steep.zones = JieyuMapGen.build_zones([
		{"id": "N1", "name": "a", "pos": [100.0, 100.0]},
	], 200, 200, 1)
	_check_true("节点核心在陡坡上被抓出",
			_has_code(JieyuMapChecks.run(steep), "node.core_not_passable"))

	# ⑧ 出生区落脚地（2026-10-05 新增判据）：只看**顶点**会漏掉「内部是陡崖」的出生区
	var pad := doc.create("check_pad", 400, 400)
	pad.height.fill(100)
	pad.zones = JieyuMapGen.build_zones([
		{"id": "N1", "name": "a", "pos": [250.0, 250.0]},
	], 400, 400, 1)
	pad.zones["spawn_areas"] = [{"side": "west",
			"polygon": [[10, 10], [160, 10], [160, 160], [10, 160]]}]
	_check_true("平地上的出生区有落脚地（spawn.pad）",
			_has_code(JieyuMapChecks.run(pad), "spawn.pad"))
	# 把出生区内部做成陡坡：**四个顶点仍是平的**（以前只看顶点，这条会漏过去）。
	# 两个单位坑（都实测踩过，别再踩）：
	#   ① set_height 写的是**灰度 0~255**，坡度按 max_elevation(150 m) 满量程换算
	#      ⇒ 0.8 灰度/m 实际只有约 25°，够不上 30° 的判据（负例会假绿）；
	#   ② 单调斜坡走远了会**顶到 255 饱和**，整片反而变成「常量 = 平地」（3 灰度/m 时踩到）。
	# 所以用锯齿：每 20 m 拉 5 灰度/m（≈ 65°+），周期回绕，宽度够宽且永不饱和。
	for x in range(40, 150):
		for y in range(40, 150):
			pad.set_height(x, y, 100.0 + float((x - 40) % 20) * 5.0)
	var broken := JieyuMapChecks.run(pad)
	_check_true("出生区内部是陡坡 → 顶点全平也必须报 spawn.no_pad",
			_has_code(broken, "spawn.no_pad"))
	_check("内部陡坡不算 ERROR（图不可用才是 ERROR）",
			JieyuMapChecks.count_level(broken, JieyuMapChecks.SEV_ERROR), 0)
	# 压平一块落脚地之后必须恢复
	JieyuMapPainter.flatten_disc(pad, Vector2(100, 100), JieyuMapSpec.SPAWN_PAD_RADIUS_M, 20.0, 100.0)
	_check_true("压平落脚地后 spawn.no_pad 消失",
			not _has_code(JieyuMapChecks.run(pad), "spawn.no_pad"))

func _has_code(report: Array, code: String) -> bool:
	for item_v in report:
		if str((item_v as Dictionary).get("code", "")) == code:
			return true
	return false


# ────────────── 7. 落盘 / 回读 ──────────────

var _passed := 0
var _failed := 0
