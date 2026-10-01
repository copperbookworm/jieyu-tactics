@tool
extends EditorScript

## 地形与通视自测（不需要场景、不需要渲染）
## 编辑器内：脚本编辑器打开本文件 → 文件 → 运行（extends EditorScript 才能这样跑）
## 覆盖：DDA 水平/垂直/对角/同格、最高点、双线性采样、坡度、地形遮挡、屏幕框、噪声/压平/配色

const GRID_N := 20

var _passed := 0
var _failed := 0


func _run() -> void:
	var grid := HeightGrid.new(GRID_N, GRID_N)
	var sight := SightSystem.new(grid)

	_test_dda_horizontal(grid)
	_test_dda_vertical(grid)
	_test_dda_diagonal(grid)
	_test_same_cell(grid)
	_test_bilinear(grid)
	_test_slope(grid)
	_test_highest(grid, sight)
	_test_terrain_blocker(grid, sight)
	_test_screen_box(sight)
	_test_map_generation()

	print("—— 通过 %d 项 / 失败 %d 项 ——" % [_passed, _failed])
	if _failed > 0:
		print("！！ 有 %d 项失败，往上翻 [FAIL] 行看期望值与实际值" % _failed)


func _check(title: String, actual: Variant, expected: Variant) -> void:
	if actual == expected:
		_passed += 1
		print("[OK]   %s" % title)
	else:
		_failed += 1
		print("[FAIL] %s  期望=%s 实际=%s" % [title, str(expected), str(actual)])


func _check_true(title: String, condition: bool) -> void:
	_check(title, condition, true)


func _test_dda_horizontal(grid: HeightGrid) -> void:
	var cells := grid.cells_on_segment(Vector2(0.5, 0.5), Vector2(19.5, 0.5))
	_check("DDA 水平：格数", cells.size(), GRID_N)
	_check("DDA 水平：起点", cells[0], Vector2i(0, 0))
	_check("DDA 水平：终点", cells[cells.size() - 1], Vector2i(19, 0))


func _test_dda_vertical(grid: HeightGrid) -> void:
	var cells := grid.cells_on_segment(Vector2(0.5, 0.5), Vector2(0.5, 19.5))
	_check("DDA 垂直：格数", cells.size(), GRID_N)
	_check("DDA 垂直：终点", cells[cells.size() - 1], Vector2i(0, 19))


func _test_dda_diagonal(grid: HeightGrid) -> void:
	var cells := grid.cells_on_segment(Vector2(0.5, 0.5), Vector2(3.5, 3.5))
	_check("DDA 对角：起点", cells[0], Vector2i(0, 0))
	_check("DDA 对角：终点", cells[cells.size() - 1], Vector2i(3, 3))
	_check_true("DDA 对角：宁多不漏，含角邻格 (0,1)", cells.has(Vector2i(0, 1)))
	_check_true("DDA 对角：至少覆盖 3 步对角 7 格", cells.size() >= 7)


func _test_same_cell(grid: HeightGrid) -> void:
	var cells := grid.cells_on_segment(Vector2(0.4, 0.4), Vector2(0.9, 0.9))
	_check("同格：只返回一格", cells.size(), 1)
	_check("同格：就是 (0,0)", cells[0], Vector2i(0, 0))


func _test_bilinear(grid: HeightGrid) -> void:
	grid.set_height_at_cell(0, 0, 10.0)
	_check("双线性：格中心 = 该格高度", grid.sample_bilinear(Vector2(0.5, 0.5)), 10.0)
	grid.set_height_at_cell(0, 0, 0.0)


func _test_slope(grid: HeightGrid) -> void:
	grid.set_height_at_cell(1, 0, 1.0)
	_check("坡度：1 m 升 1 m = 45°", snappedf(grid.slope_deg(Vector2i(0, 0), Vector2i(1, 0)), 0.01), 45.0)
	grid.set_height_at_cell(1, 0, 0.0)


func _test_highest(grid: HeightGrid, sight: SightSystem) -> void:
	grid.set_height_at_cell(5, 0, 50.0)
	var highest := sight.highest_on_segment(Vector2(0.5, 0.5), Vector2(19.5, 0.5))
	_check("最高点：格坐标", highest["cell"], Vector2i(5, 0))
	_check("最高点：高度", highest["height"], 50.0)
	grid.set_height_at_cell(5, 0, 0.0)


func _test_terrain_blocker(grid: HeightGrid, sight: SightSystem) -> void:
	var origin := Vector2(0.5, 0.5)
	var target := Vector2(19.5, 0.5)
	_check_true("遮挡：平地全通视（视高 1.6→1.8）",
			sight.has_sight(origin, 1.6, target, 1.8))

	grid.set_height_at_cell(5, 0, 10.0)
	var blocker := sight.terrain_first_blocker(origin, 1.6, target, 1.8)
	_check_true("遮挡：10 m 土坎挡住 1.6 m 视线", blocker["blocked"])
	_check("遮挡：挡住的格", blocker["cell"], Vector2i(5, 0))

	grid.set_height_at_cell(5, 0, 1.0)
	_check_true("遮挡：1 m 矮坎不该挡 1.6 m 视线（容差 0.3 m 生效）",
			sight.has_sight(origin, 1.6, target, 1.8))
	grid.set_height_at_cell(5, 0, 0.0)


func _test_screen_box(sight: SightSystem) -> void:
	var viewport := Vector2(GameConfig.VIEWPORT_WIDTH, GameConfig.VIEWPORT_HEIGHT)
	_check_true("框检测：屏幕中心在框内", sight.in_screen_box(viewport * 0.5, viewport))
	_check_true("框检测：安全边距内算可见",
			sight.in_screen_box(Vector2(viewport.x + 200.0, 270.0), viewport))
	_check("框检测：超出边距不显示",
			sight.in_screen_box(Vector2(viewport.x + 300.0, 270.0), viewport), false)


func _test_map_generation() -> void:
	# 用小网格替代 1000×1000，避免自测跑几分钟
	var grid := HeightGrid.new(64, 64)
	grid.fill_from_noise(GameConfig.DEFAULT_MAP_SEED, GameConfig.MAX_ELEVATION)
	_check_true("噪声：最低值 ≥ 0", grid.min_elevation() >= 0.0)
	_check_true("噪声：最高值 ≤ 最大海拔", grid.max_height() <= GameConfig.MAX_ELEVATION)
	_check_true("噪声：地形有起伏（不是一块平板）",
			grid.max_height() - grid.min_elevation() > 10.0)

	# 压平：区域内所有格高度被抹成同一个值
	MapGenerator.flatten_area(grid, Vector2(32.0, 32.0), 5.0)
	var flat_height := grid.height_at_cell(32, 32)
	_check("压平：区域内高度一致", grid.height_at_cell(34, 32), flat_height)

	_check("地形配色：0 m 是最低地色",
			MapGenerator.height_to_color(0.0), MapGenerator.TERRAIN_COLORS[0]["color"])
	_check("地形配色：150 m 是最高地色",
			MapGenerator.height_to_color(GameConfig.MAX_ELEVATION),
			MapGenerator.TERRAIN_COLORS[MapGenerator.TERRAIN_COLORS.size() - 1]["color"])
	_check("示例地图：五个节点", MapGenerator.DEMO_NODES.size(), 5)
