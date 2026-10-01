class_name MapInspector
extends RefCounted

## 地图效果检测（预览模式的后端）：纯逻辑、可单测，不碰任何场景节点
##   ① 可达性掩码：按 step 降采样算坡度，超过 MAX_SLOPE_DEG 的方块标红
##   ② 通视探针：从一点向四周发射线，返回每条射线的可见距离与遮挡点
## 为什么要有它：自制高度图导入后，光看贴图不知道「哪里爬不上去、哪里挡视线」

## 不可通行红域（RGBA8，可通行处全透明——只有它才能直接叠在地形贴图上）
static func build_passability_image(grid: HeightGrid,
		step: int = GameConfig.PREVIEW_SLOPE_STEP) -> Image:
	var image := Image.create(grid.width, grid.height, false, Image.FORMAT_RGBA8)
	image.fill(Color(0.0, 0.0, 0.0, 0.0))
	var blocked_color := Color(0.9, 0.15, 0.1, GameConfig.PREVIEW_PASSABLE_ALPHA)
	var y := 0
	while y < grid.height:
		var x := 0
		while x < grid.width:
			if _is_steep(grid, x, y, step):
				_fill_block(image, grid, x, y, step, blocked_color)
			x += step
		y += step
	return image


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
