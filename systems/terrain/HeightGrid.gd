class_name HeightGrid
extends RefCounted

## 1 m 高程网格：把 1 km × 1 km 地图离散成 1000 × 1000 格，每格存一个高度值（米）
## 存储：行优先一维数组，index = y * width + x（docx 12.2 推荐数据结构）
## 世界坐标：原点左上角 (0,0)，x 向右、y 向下，1 unit = 1 m（docx 12.8.2）
## 查询 O(1)：世界坐标 → 格坐标 → 数组下标
## 高程来源：FastNoiseLite 四层 fBm 生成基底，手工雕刻留待后续（docx 12.8.3 / 12.2 补充）

## 12.8.3 确认的四层特征尺寸与振幅
const NOISE_LAYERS := [
	{"feature": 250.0, "amplitude": 90.0},
	{"feature": 80.0, "amplitude": 40.0},
	{"feature": 25.0, "amplitude": 15.0},
	{"feature": 8.0, "amplitude": 5.0},
]

var width: int = 0
var height: int = 0
var cell_size: float = GameConfig.CELL_SIZE

var _data := PackedFloat32Array()


func _init(grid_width: int = 0, grid_height: int = 0) -> void:
	if grid_width > 0 and grid_height > 0:
		resize(grid_width, grid_height)


## 分配网格（全 0 高度）
func resize(grid_width: int, grid_height: int) -> void:
	width = grid_width
	height = grid_height
	_data = PackedFloat32Array()
	_data.resize(width * height)
	_data.fill(0.0)


func is_inside(cell_x: int, cell_y: int) -> bool:
	return cell_x >= 0 and cell_y >= 0 and cell_x < width and cell_y < height


## 格取整高度（米），越界钳到边缘，避免视线走出地图时误判
func height_at_cell(cell_x: int, cell_y: int) -> float:
	var cx := clampi(cell_x, 0, width - 1)
	var cy := clampi(cell_y, 0, height - 1)
	return _data[cy * width + cx]


func set_height_at_cell(cell_x: int, cell_y: int, value: float) -> void:
	if is_inside(cell_x, cell_y):
		_data[cell_y * width + cell_x] = value


func height_at_world(world_pos: Vector2) -> float:
	var cell := world_to_cell(world_pos)
	return height_at_cell(cell.x, cell.y)


## 双线性插值采样：人物踩地不跳格（docx 12.2）
func sample_bilinear(world_pos: Vector2) -> float:
	var local := world_pos / cell_size - Vector2(0.5, 0.5)
	var x0 := floori(local.x)
	var y0 := floori(local.y)
	var tx := local.x - float(x0)
	var ty := local.y - float(y0)
	var h00 := height_at_cell(x0, y0)
	var h10 := height_at_cell(x0 + 1, y0)
	var h01 := height_at_cell(x0, y0 + 1)
	var h11 := height_at_cell(x0 + 1, y0 + 1)
	var top := lerpf(h00, h10, tx)
	var bottom := lerpf(h01, h11, tx)
	return lerpf(top, bottom, ty)


func world_to_cell(world_pos: Vector2) -> Vector2i:
	return Vector2i(floori(world_pos.x / cell_size), floori(world_pos.y / cell_size))


func cell_to_world_center(cell: Vector2i) -> Vector2:
	return (Vector2(cell) + Vector2(0.5, 0.5)) * cell_size


## DDA 逐格：返回线段穿过的所有格（含起止格）。
## 斜穿格角时两格都收进来——遮挡判定宁多不漏。
func cells_on_segment(from_world: Vector2, to_world: Vector2) -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	var start_cell := world_to_cell(from_world)
	var end_cell := world_to_cell(to_world)
	cells.append(start_cell)
	if start_cell == end_cell:
		return cells

	var delta := to_world - from_world
	var step_x := 0
	var step_y := 0
	var t_delta_x := INF
	var t_delta_y := INF
	var t_max_x := INF
	var t_max_y := INF

	if not is_zero_approx(delta.x):
		step_x = 1 if delta.x > 0.0 else -1
		t_delta_x = absf(cell_size / delta.x)
		var boundary_x := (float(start_cell.x) + (1.0 if step_x > 0 else 0.0)) * cell_size
		t_max_x = (boundary_x - from_world.x) / delta.x
	if not is_zero_approx(delta.y):
		step_y = 1 if delta.y > 0.0 else -1
		t_delta_y = absf(cell_size / delta.y)
		var boundary_y := (float(start_cell.y) + (1.0 if step_y > 0 else 0.0)) * cell_size
		t_max_y = (boundary_y - from_world.y) / delta.y

	var guard := absi(end_cell.x - start_cell.x) + absi(end_cell.y - start_cell.y) + 2
	var current := start_cell
	while current != end_cell and guard > 0:
		if t_max_x < t_max_y:
			current.x += step_x
			t_max_x += t_delta_x
		elif t_max_y < t_max_x:
			current.y += step_y
			t_max_y += t_delta_y
		else:
			# 正好穿过格角：把两条分支上的相邻格都收进来（遮挡判定宁多不漏）
			cells.append(Vector2i(current.x + step_x, current.y))
			cells.append(Vector2i(current.x, current.y + step_y))
			current.x += step_x
			current.y += step_y
			t_max_x += t_delta_x
			t_max_y += t_delta_y
		cells.append(current)
		guard -= 1
	return cells


## docx 12.6 图②「求最高点」：同一条 DDA 上扫描并保留最高格及其高度
func highest_cell_on_segment(from_world: Vector2, to_world: Vector2) -> Dictionary:
	var best_cell := world_to_cell(from_world)
	var best_height := height_at_cell(best_cell.x, best_cell.y)
	for cell in cells_on_segment(from_world, to_world):
		var h := height_at_cell(cell.x, cell.y)
		if h > best_height:
			best_height = h
			best_cell = cell
	return {"cell": best_cell, "height": best_height}


## 两格之间的坡度（度），用于载具通行判定（docx 12.8.5 ⑤）
func slope_deg(cell_a: Vector2i, cell_b: Vector2i) -> float:
	if cell_a == cell_b:
		return 0.0
	var distance := Vector2(cell_b - cell_a).length() * cell_size
	if is_zero_approx(distance):
		return 0.0
	var rise := absf(height_at_cell(cell_b.x, cell_b.y) - height_at_cell(cell_a.x, cell_a.y))
	return rad_to_deg(atan2(rise, distance))


## 用 FastNoiseLite 四层 fBm 生成基底高程（docx 12.8.3）
## 注意：1000 × 1000 × 4 层 ≈ 400 万次采样，纯 GDScript 首次生成需要数十秒，
## 第一版在加载画面后跑一次即可；后续改为工具脚本预生成 heightmap.png。
func fill_from_noise(noise_seed: int, max_elevation: float = GameConfig.MAX_ELEVATION) -> void:
	var noises: Array[FastNoiseLite] = []
	var total_amplitude := 0.0
	for layer in NOISE_LAYERS:
		var noise := FastNoiseLite.new()
		noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
		noise.fractal_type = FastNoiseLite.FRACTAL_FBM
		noise.fractal_octaves = 4
		noise.fractal_lacunarity = 2.0
		noise.fractal_gain = 0.5
		noise.frequency = 1.0 / float(layer["feature"])
		noise.seed = noise_seed
		noises.append(noise)
		total_amplitude += float(layer["amplitude"])
	if is_zero_approx(total_amplitude):
		return

	var elevation_ratio := max_elevation / total_amplitude
	for y in height:
		for x in width:
			var accumulated := 0.0
			for i in noises.size():
				accumulated += noises[i].get_noise_2d(float(x), float(y)) \
						* float(NOISE_LAYERS[i]["amplitude"])
			var value := (accumulated + total_amplitude) * 0.5 * elevation_ratio
			_data[y * width + x] = clampf(value, 0.0, max_elevation)


## 第 4 层噪声细节振幅（5 m）用于压平道路/河道时做参考
## 从灰度高度图导入（工具链 A：PNG → HeightGrid）
## 约定：黑 = 0 m，白（255）= max_elevation；尺寸必须严格一致，不做缩放
## （静默拉伸会让「图即所见」失效，宁可直接报错、由调用方退回噪声地形）
func fill_from_image(image: Image,
		max_elevation: float = GameConfig.MAX_ELEVATION) -> bool:
	if image == null or image.get_width() <= 0 or image.get_height() <= 0:
		push_error("[HeightGrid] 高度图为空，导入失败")
		return false
	if image.get_width() != width or image.get_height() != height:
		push_error("[HeightGrid] 高度图 %dx%d 与网格 %dx%d 不一致：不缩放、直接拒绝"
				% [image.get_width(), image.get_height(), width, height])
		return false
	# 转成 8bit 单通道后整块读：100 万格逐格 get_pixel 会慢到十几秒
	var img := image.duplicate() as Image
	if img.get_format() != Image.FORMAT_L8:
		img.convert(Image.FORMAT_L8)
	var data := img.get_data()
	for i in width * height:
		set_height_at_cell(i % width, i / width, data[i] / 255.0 * max_elevation)
	return true


func min_elevation() -> float:
	var lowest := INF
	for value in _data:
		lowest = minf(lowest, value)
	return 0.0 if is_inf(lowest) else lowest


func max_height() -> float:
	var highest := -INF
	for value in _data:
		highest = maxf(highest, value)
	return 0.0 if is_inf(highest) else highest
