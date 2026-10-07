class_name MapInspector
extends RefCounted

## 地图效果检测（预览模式的后端）：纯逻辑、可单测，不碰任何场景节点
##   ① 可达性掩码：按 step 降采样算坡度，超过 MAX_SLOPE_DEG 的方块标红
##   ② 通视探针：从一点向四周发射线，返回每条射线的可见距离与遮挡点
## 为什么要有它：自制高度图导入后，光看贴图不知道「哪里爬不上去、哪里挡视线」

## 并行分块（与 MapGenerator.PAINT_* 同口径）
const PAINT_PARALLEL_MIN_CELLS := 262144
const PASS_MAX_BANDS := 12
static var _pass_out := PackedByteArray()
static var _pass_w := 0
static var _pass_h := 0
static var _pass_step := 1
static var _pass_bands := 1
static var _pass_y_starts := 1
static var _blocked_bytes := PackedByteArray()


## 不可通行红域（RGBA8，可通行处全透明——只有它才能直接叠在地形贴图上）
## 【2026-10-06 第七十九版 · 并行计算整改】三处改动：
##   ① 逐像素 set_pixel → 整块 RGBA8 字节 + create_from_data；
##   ② 按 y 分块（WorkerThreadPool）并行；块的划分以 step 为单位 ⇒ 各块写的像素**互不相交**；
##   ③ 顺序与并行共用 _mark_rows() 一份实现 ⇒ 两条路径逐字节一致。
## chunks <= 0 = 自动（小图自动单线程）；step <= 0 视作 1（旧实现在 step=0 时会死循环）。
static func build_passability_image(grid: HeightGrid,
		step: int = GameConfig.PREVIEW_SLOPE_STEP, chunks: int = 0) -> Image:
	if grid == null or grid.width <= 0 or grid.height <= 0:
		return null
	var w: int = grid.width
	var h: int = grid.height
	_pass_step = maxi(step, 1)
	_pass_w = w
	_pass_h = h
	_pass_out = PackedByteArray()
	_pass_out.resize(w * h * 4)      # 全 0 = 全透明
	var y_starts := int(ceil(float(h) / float(_pass_step)))
	var bands := chunks
	if bands <= 0:
		bands = 1 if w * h < PAINT_PARALLEL_MIN_CELLS \
				else clampi(OS.get_processor_count() - 1, 2, PASS_MAX_BANDS)
	bands = clampi(bands, 1, maxi(y_starts, 1))
	_pass_bands = bands
	_pass_y_starts = y_starts
	# ⚠ 惰性 LUT 必须在派发**之前**于主线程建好：worker 里惰性初始化会互相踩
	# （HeightGrid 的振幅 LUT 就是这么报过一次 `Out of bounds get index`）
	_blocked_rgba()
	if bands <= 1:
		_mark_band(grid, 0)
	else:
		var id := WorkerThreadPool.add_group_task(
				func(band: int) -> void: _mark_band(grid, band),
				bands, bands, true, "passability")
		WorkerThreadPool.wait_for_group_task_completion(id)
	var image := Image.create_from_data(w, h, false, Image.FORMAT_RGBA8, _pass_out)
	_pass_out = PackedByteArray()
	return image


## 一个 y 分块：(band*per) 到 (band+1)*per 个「y 起点」
static func _mark_band(grid: HeightGrid, band: int) -> void:
	var per := int(ceil(float(_pass_y_starts) / float(_pass_bands)))
	var y0 := band * per * _pass_step
	var y1 := mini((band + 1) * per * _pass_step, _pass_h)
	if y0 >= y1:
		return
	_mark_rows(grid, y0, y1)


## 真正的标记循环（顺序与并行共用）
static func _mark_rows(grid: HeightGrid, y0: int, y1: int) -> void:
	var w := _pass_w
	var h := _pass_h
	var step := _pass_step
	var rgba := _blocked_rgba()
	var r := rgba[0]
	var g := rgba[1]
	var b := rgba[2]
	var a := rgba[3]
	var y := y0
	while y < y1:
		var x := 0
		while x < w:
			if _is_steep(grid, x, y, step):
				var x_end := mini(x + step, w)
				var y_end := mini(y + step, h)
				for by in range(y, y_end):
					var row := by * w
					for bx in range(x, x_end):
						var i := (row + bx) * 4
						_pass_out[i] = r
						_pass_out[i + 1] = g
						_pass_out[i + 2] = b
						_pass_out[i + 3] = a
			x += step
		y += step


## 红域字节（RGBA8），与 Image.set_pixel 同一条换算
static func _blocked_rgba() -> PackedByteArray:
	if _blocked_bytes.size() == 4:
		return _blocked_bytes
	var c := Color(0.9, 0.15, 0.1, GameConfig.PREVIEW_PASSABLE_ALPHA)
	_blocked_bytes = PackedByteArray()
	_blocked_bytes.append(_to_byte(c.r))
	_blocked_bytes.append(_to_byte(c.g))
	_blocked_bytes.append(_to_byte(c.b))
	_blocked_bytes.append(_to_byte(c.a))
	return _blocked_bytes


static func _to_byte(v: float) -> int:
	return int(clampf(v * 255.0, 0.0, 255.0))


static func _is_steep(grid: HeightGrid, x: int, y: int, step: int) -> bool:
	var here := Vector2i(x, y)
	var right := Vector2i(mini(x + step, grid.width - 1), y)
	var down := Vector2i(x, mini(y + step, grid.height - 1))
	if grid.slope_deg(here, right) > GameConfig.MAX_SLOPE_DEG:
		return true
	return grid.slope_deg(here, down) > GameConfig.MAX_SLOPE_DEG


static func _fill_block(image: Image, grid: HeightGrid, x: int, y: int, step: int,
		color: Color) -> void:
	for by in range(y, mini(y + step, grid.height)):
		for bx in range(x, mini(x + step, grid.width)):
			image.set_pixel(bx, by, color)


## 通视探针：以 origin 为起点向四周扫一圈，返回 [{dir, blocked, distance, point}]
## 遮挡距离直接取第一个阻挡格的中心（精度 1 m，够用，省掉二分）
static func scan_visibility(grid: HeightGrid, sight: SightSystem, origin: Vector2,
		ray_radius: float = GameConfig.PREVIEW_RAY_RADIUS,
		step_deg: float = GameConfig.PREVIEW_RAY_STEP_DEG) -> Array:
	var rays: Array = []
	if grid == null or sight == null:
		return rays
	var origin_height := sight.eye_height_at(origin)
	var angle := 0.0
	while angle < 360.0:
		var dir := Vector2.RIGHT.rotated(deg_to_rad(angle))
		var target := origin + dir * ray_radius
		var target_height := sight.eye_height_at(target)
		# 与准心完全同口径（含 CROSSHAIR_SIGHT_MARGIN_PER_METER，现为 0 ＝文档严格口径）
		var blocker := sight.terrain_first_blocker(origin, origin_height, target,
				target_height, GameConfig.CROSSHAIR_SIGHT_MARGIN_PER_METER)
		var blocked: bool = blocker["blocked"]
		var distance := ray_radius
		if blocked:
			var cell: Vector2i = blocker["cell"]
			distance = origin.distance_to(grid.cell_to_world_center(cell))
		rays.append({
			"dir": dir,
			"blocked": blocked,
			"distance": distance,
			"point": origin + dir * distance,
		})
		angle += step_deg
	return rays


## 单点信息（探针落点用）：高程 / 最大相邻坡度 / 是否可通行
static func sample_info(grid: HeightGrid, world_pos: Vector2) -> Dictionary:
	var cell := grid.world_to_cell(world_pos)
	var max_slope := 0.0
	var offsets := [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]
	for offset in offsets:
		var neighbour: Vector2i = cell + offset
		if not grid.is_inside(neighbour.x, neighbour.y):
			continue
		max_slope = maxf(max_slope, grid.slope_deg(cell, neighbour))
	return {
		"cell": cell,
		"height": grid.height_at_cell(cell.x, cell.y),
		"slope_deg": max_slope,
		"passable": max_slope <= GameConfig.MAX_SLOPE_DEG,
	}
