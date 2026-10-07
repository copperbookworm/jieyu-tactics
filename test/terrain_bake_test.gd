@tool
extends EditorScript

## 并行烘焙等价性测试（2026-10-06 第七十九版 · 并行计算整改）
##
## 钉两件事，别的一概不管：
##   ① 「分块并行」与「单块串行」逐字节一致（分块边界最容易翻车）；
##   ② 「整块字节 + create_from_data」与旧的「逐像素 set_pixel」逐字节一致
##      （字节换算的 float 截断差一级就会让地形/红域整片变色，肉眼还看不出来）。
##
## 运行：脚本编辑器打开本文件 → 文件 → 运行；或 tools/run_tests_headless.gd 跑批。

var _passed := 0
var _failed := 0


func _run() -> void:
	_test_to_byte_matches_set_pixel()
	_test_terrain_texture_parallel_equals_serial()
	_test_terrain_texture_matches_oracle()
	_test_fill_from_image_reference()
	_test_export_height_image_roundtrip()
	_test_passability_parallel_equals_serial()
	_test_passability_matches_oracle()
	_test_noise_parallel_equals_serial()
	_test_material_zones_expected()
	_test_mapgen_noise_parallel_equals_serial()
	_test_content_images_parallel_equals_serial()
	print("—— 通过 %d 项 / 失败 %d 项 ——" % [_passed, _failed])
	if _failed > 0:
		print("！！ 有 %d 项失败，往上翻看期望与实际" % _failed)


func _check(title: String, actual: Variant, expected: Variant) -> void:
	if actual == expected:
		_passed += 1
		print("[OK]   %s" % title)
	else:
		_failed += 1
		print("[FAIL] %s  期望=%s 实际=%s" % [title, str(expected), str(actual)])


func _check_true(title: String, condition: bool) -> void:
	_check(title, condition, true)


## 起伏 + 局部陡坎的确定性网格（覆盖全部配色档与 debug 红域）
func _make_wavy_grid(w: int, h: int) -> HeightGrid:
	var grid := HeightGrid.new(w, h)
	for y in h:
		for x in w:
			var value := float((x * 17 + y * 29) % 151)
			if (x + y) % 11 == 0:
				value = GameConfig.MAX_ELEVATION
			grid.set_height_at_cell(x, y, value)
	return grid


## 东半边抬到 100 m 的陡坡网格（可达性红域）
func _make_ridge_grid(w: int, h: int) -> HeightGrid:
	var grid := HeightGrid.new(w, h)
	for y in h:
		for x in range(w / 2, w):
			grid.set_height_at_cell(x, y, 100.0)
	return grid


func _marked_count(image: Image) -> int:
	var marked := 0
	for y in image.get_height():
		for x in image.get_width():
			if image.get_pixel(x, y).a > 0.01:
				marked += 1
	return marked


# ────────────── ① 字节换算：整块写 vs set_pixel ──────────────

func _test_to_byte_matches_set_pixel() -> void:
	var samples := [0.0, 0.05, 0.1, 0.15, 0.25, 0.3, 0.45, 0.5, 0.55, 0.7, 0.9, 0.99, 1.0]
	var n := samples.size()

	var ref_rgb := Image.create(n, 1, false, Image.FORMAT_RGB8)
	var ref_l8 := Image.create(n, 1, false, Image.FORMAT_L8)
	var ref_rgba := Image.create(n, 1, false, Image.FORMAT_RGBA8)
	var rgb := PackedByteArray()
	var l8 := PackedByteArray()
	var rgba := PackedByteArray()
	for i in n:
		var v: float = samples[i]
		ref_rgb.set_pixel(i, 0, Color(v, v, v))
		ref_l8.set_pixel(i, 0, Color(v, v, v))
		ref_rgba.set_pixel(i, 0, Color(v, v, v, v))
		rgb.append(MapGenerator._to_byte(v))
		rgb.append(MapGenerator._to_byte(v))
		rgb.append(MapGenerator._to_byte(v))
		l8.append(MapGenerator._to_byte(v))
		rgba.append(MapInspector._to_byte(v))
		rgba.append(MapInspector._to_byte(v))
		rgba.append(MapInspector._to_byte(v))
		rgba.append(MapInspector._to_byte(v))
	_check_true("RGB8 字节换算 == set_pixel（%d 个采样值）" % n,
			Image.create_from_data(n, 1, false, Image.FORMAT_RGB8, rgb).get_data() 					== ref_rgb.get_data())
	_check_true("L8 字节换算 == set_pixel（%d 个采样值）" % n,
			Image.create_from_data(n, 1, false, Image.FORMAT_L8, l8).get_data() 					== ref_l8.get_data())
	_check_true("RGBA8 字节换算 == set_pixel（%d 个采样值）" % n,
			Image.create_from_data(n, 1, false, Image.FORMAT_RGBA8, rgba).get_data() 					== ref_rgba.get_data())


# ────────────── ② 地形贴图 ──────────────

func _test_terrain_texture_parallel_equals_serial() -> void:
	var grid := _make_wavy_grid(96, 96)
	for rough in [1.5, -1.0]:
		var serial := MapGenerator.build_terrain_image(grid, rough, 1)
		var parallel := MapGenerator.build_terrain_image(grid, rough, 6)
		var again := MapGenerator.build_terrain_image(grid, rough, 6)
		_check_true("地形贴图 rough=%s：1 块 == 6 块（逐字节）" % str(rough),
				serial.get_data() == parallel.get_data())
		_check_true("地形贴图 rough=%s：6 块可复现" % str(rough),
				parallel.get_data() == again.get_data())


## 旧实现（逐像素 set_pixel + height_to_color + _is_rough）当参照物
func _terrain_oracle(grid: HeightGrid, rough: float) -> Image:
	var w: int = grid.width
	var h: int = grid.height
	var image := Image.create(w, h, false, Image.FORMAT_RGB8)
	for y in h:
		for x in w:
			var height := grid.height_at_cell(x, y)
			if rough > 0.0 and _rough_oracle(grid, x, y, rough):
				image.set_pixel(x, y, Color(1.0, 0.3, 0.25))
			else:
				image.set_pixel(x, y, MapGenerator.height_to_color(height))
	return image


func _rough_oracle(grid: HeightGrid, x: int, y: int, threshold: float) -> bool:
	var center_height := grid.height_at_cell(x, y)
	for offset in [[1, 0], [-1, 0], [0, 1], [0, -1]]:
		var neighbor := grid.height_at_cell(x + offset[0], y + offset[1])
		if absf(center_height - neighbor) > threshold:
			return true
	return false


func _test_terrain_texture_matches_oracle() -> void:
	var grid := _make_wavy_grid(64, 64)
	for rough in [1.5, -1.0]:
		var mine := MapGenerator.build_terrain_image(grid, rough, 4)
		var oracle := _terrain_oracle(grid, rough)
		_check_true("地形贴图 rough=%s：整块字节 == 逐像素旧实现" % str(rough),
				mine.get_data() == oracle.get_data())


# ────────────── ③ 高度图导入 / 导出 ──────────────

func _test_fill_from_image_reference() -> void:
	var image := Image.create(64, 48, false, Image.FORMAT_L8)
	for y in 48:
		for x in 64:
			var v := float((x * 3 + y * 5) % 256) / 255.0
			image.set_pixel(x, y, Color(v, v, v))
	var grid := HeightGrid.new(64, 48)
	_check_true("高度图导入成功（64×48）", grid.fill_from_image(image))
	var data := image.get_data()
	# ⚠ 判等要按 float32 口径：_data 是 PackedFloat32Array，存进去就舍到 float32，
	# 而参考算式是 float64 —— 真按 != 比会"全不一致"（本次就是这么先踩了一次）。
	var worst := 0.0
	for y in 48:
		for x in 64:
			var expect: float = data[y * 64 + x] / 255.0 * GameConfig.MAX_ELEVATION
			worst = maxf(worst, absf(grid.height_at_cell(x, y) - expect))
	_check_true("fill_from_image：逐格与参考算式一致（float32 舍入内，最大偏差 %.6f）" % worst,
			worst <= 0.001)
	_check("fill_from_image：全黑 = 0 m", HeightGrid.new(1, 1).height_at_cell(0, 0), 0.0)


func _test_export_height_image_roundtrip() -> void:
	var grid := _make_wavy_grid(48, 48)
	var path := "user://_bake_test_height.png"
	var err := MapGenerator.export_height_image(grid, path)
	_check("导出高度图返回 OK", err, OK)
	var back := Image.load_from_file(ProjectSettings.globalize_path(path))
	_check_true("导出高度图能读回", back != null)
	if back == null:
		return
	var worst := 0.0
	for y in 48:
		for x in 48:
			var expect := clampf(grid.height_at_cell(x, y) / GameConfig.MAX_ELEVATION, 0.0, 1.0)
			worst = maxf(worst, absf(back.get_pixel(x, y).r - expect))
	_check_true("导出高度图：8bit 量化内一致（最大偏差 %.5f）" % worst,
			worst <= 1.0 / 255.0 + 0.000001)
	DirAccess.remove_absolute(ProjectSettings.globalize_path(path))


# ────────────── ④ 可达性掩码 ──────────────

func _test_passability_parallel_equals_serial() -> void:
	var grid := _make_ridge_grid(128, 128)
	var serial := MapInspector.build_passability_image(grid, 4, 1)
	var parallel := MapInspector.build_passability_image(grid, 4, 7)
	_check_true("可达性掩码：1 块 == 7 块（逐字节）",
			serial.get_data() == parallel.get_data())
	_check_true("可达性掩码：确有红域（否则等价性等于没测）", _marked_count(serial) > 0)


func _test_passability_matches_oracle() -> void:
	var grid := _make_ridge_grid(64, 64)
	var step := 4
	var mine := MapInspector.build_passability_image(grid, step, 5)
	var oracle := Image.create(grid.width, grid.height, false, Image.FORMAT_RGBA8)
	oracle.fill(Color(0.0, 0.0, 0.0, 0.0))
	var blocked := Color(0.9, 0.15, 0.1, GameConfig.PREVIEW_PASSABLE_ALPHA)
	var y := 0
	while y < grid.height:
		var x := 0
		while x < grid.width:
			if MapInspector._is_steep(grid, x, y, step):
				for by in range(y, mini(y + step, grid.height)):
					for bx in range(x, mini(x + step, grid.width)):
						oracle.set_pixel(bx, by, blocked)
			x += step
		y += step
	_check_true("可达性掩码：整块字节 == 逐像素旧实现", mine.get_data() == oracle.get_data())


# ────────────── ⑤ 噪声地形 ──────────────

func _test_noise_parallel_equals_serial() -> void:
	var serial := HeightGrid.new(256, 256)
	var parallel := HeightGrid.new(256, 256)
	serial.fill_from_noise(GameConfig.DEFAULT_MAP_SEED, GameConfig.MAX_ELEVATION, 1)
	parallel.fill_from_noise(GameConfig.DEFAULT_MAP_SEED, GameConfig.MAX_ELEVATION, 8)
	var mismatch := 0
	for y in 256:
		for x in 256:
			if serial.height_at_cell(x, y) != parallel.height_at_cell(x, y):
				mismatch += 1
	_check("噪声地形：1 块 vs 8 块逐格一致（不一致 %d 格）" % mismatch, mismatch, 0)
	_check_true("噪声地形：确实有起伏（> 10 m）",
			serial.max_height() - serial.min_elevation() > 10.0)


# ────────────── ⑥ 内容层连通域（常数因子优化后仍要对） ──────────────

func _test_material_zones_expected() -> void:
	var image := Image.create(12, 12, false, Image.FORMAT_L8)
	for y in 4:
		for x in 4:
			image.set_pixel(x, y, Color8(1, 1, 1))          # id 1 = 泥泞
	for y in range(6, 9):
		for x in range(6, 9):
			image.set_pixel(x, y, Color8(2, 2, 2))          # id 2 = 雪地
	var entries := MapGenerator.terrain_zones_from_material_image(image, 5)
	_check("内容层：连通域个数", entries.size(), 2)
	if entries.size() != 2:
		return
	var mud: Dictionary = entries[0]
	var snow: Dictionary = entries[1]
	_check("内容层：泥泞 kind", int(mud["kind"]), 0)
	_check("内容层：泥泞 格数", int(mud["cells"]), 16)
	_check("内容层：泥泞 圆心 x", float(mud["position"].x), 1.5)
	_check("内容层：泥泞 圆心 y", float(mud["position"].y), 1.5)
	_check_true("内容层：泥泞 等面积半径",
			absf(float(mud["radius"]) - sqrt(16.0 / PI)) < 0.0001)
	_check("内容层：雪地 kind", int(snow["kind"]), 1)
	_check("内容层：雪地 格数", int(snow["cells"]), 9)
	_check("内容层：雪地 圆心 x", float(snow["position"].x), 7.0)
	_check("内容层：雪地 圆心 y", float(snow["position"].y), 7.0)


# ────────────── ⑦ 地图插件（addons/jieyu_map） ──────────────

func _test_mapgen_noise_parallel_equals_serial() -> void:
	var recipe := {"seed": 4242, "octaves": 4, "lacunarity": 2.0, "gain": 0.5}
	var serial: PackedByteArray = JieyuMapGen.generate_heights(recipe, 200, 200, 1)
	var parallel: PackedByteArray = JieyuMapGen.generate_heights(recipe, 200, 200, 8)
	_check("插件噪声：1 块 == 8 块（%d 字节）" % serial.size(), serial, parallel)
	var nonzero := 0
	for b in serial:
		if b != 0:
			nonzero += 1
	_check_true("插件噪声：不是一片平（非 0 占比 > 10%）", float(nonzero) / float(serial.size()) > 0.1)


func _test_content_images_parallel_equals_serial() -> void:
	var doc := JieyuMapDoc.create("bake_equiv", 128, 128)
	doc.set_height_bytes(JieyuMapGen.generate_heights({"seed": 77}, 128, 128, 4))
	var recipe := {"mud_max_ratio": 0.10, "snow_min_ratio": 0.62, "grass_max_ratio": 0.55}
	var serial := JieyuMapGen.build_content_images(doc, recipe, 1)
	var parallel := JieyuMapGen.build_content_images(doc, recipe, 8)
	var serial_rows: Image = serial["rows"]
	var parallel_rows: Image = parallel["rows"]
	var serial_mat: Image = serial["material"]
	var parallel_mat: Image = parallel["material"]
	_check_true("内容图 rows：1 块 == 8 块（逐字节）",
			serial_rows.get_data() == parallel_rows.get_data())
	_check_true("内容图 material：1 块 == 8 块（逐字节）",
			serial_mat.get_data() == parallel_mat.get_data())
	_check("内容图 counts 一致", str(serial["counts"]), str(parallel["counts"]))
	var total := int(serial["counts"][0]) + int(serial["counts"][1]) + int(serial["counts"][2])
	_check_true("内容图：确实画了东西（合计 %d 格）" % total, total > 0)
