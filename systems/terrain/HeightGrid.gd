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

## 并行烘焙的公共旋钮（2026-10-06 第七十九版）：低于 PARALLEL_MIN_CELLS 一律单线程
const PARALLEL_MIN_CELLS := 262144          # 512×512；小网格并行只赔不赚
const PARALLEL_MAX_BANDS := 12

## 噪声分块的实例脚手架（只在 fill_from_noise 与它的块内使用）
var _noise_bands := 1
var _noise_seed_value := 0
var _noise_max_elevation := 0.0
var _noise_elevation_ratio := 0.0
var _noise_total_amplitude := 0.0
## 派发前建好的振幅 LUT（worker 只读；惰性版本 _noise_amplitudes() 只许主线程调）
var _noise_amps := PackedFloat32Array()
static var _noise_amp_lut := PackedFloat32Array()


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


## 整块只读视图（2026-10-06 第七十九版）：并行上色要把高程一次取出来，
## 逐格 height_at_cell() 在 100 万格上是 40 万次以上的方法调用（见 MapGenerator._paint_rows）。
## ⚠ 返回的是**共享引用**：调用方只许读。一旦有人在拿到它之后写 _data，
## Packed 数组会触发 copy-on-write，那是正确但会多一次整块拷贝；并发写则会撞上
## 「已共享的 write」这条坑（见 docs/性能预算.md 第二十八节）。
func heights_readonly() -> PackedFloat32Array:
	return _data


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
	_fill_cells_on_segment(cells, from_world, to_world)
	return cells


## 复用调用方缓冲的版本（通视热路径专用）：避免每次查询都新分配一个 Array。
## 20v20 里每帧有十几条视线，每条一次分配是移动端 GC 抖动的主要来源之一。
## 注意：返回值就是入参同一个数组，下一次调用会覆盖，只许当场用完。
func cells_on_segment_into(out: Array[Vector2i], from_world: Vector2,
		to_world: Vector2) -> Array[Vector2i]:
	out.clear()
	_fill_cells_on_segment(out, from_world, to_world)
	return out


func _fill_cells_on_segment(cells: Array[Vector2i], from_world: Vector2,
		to_world: Vector2) -> void:
	var start_cell := world_to_cell(from_world)
	var end_cell := world_to_cell(to_world)
	cells.append(start_cell)
	if start_cell == end_cell:
		return

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
## 1000 × 1000 × 4 层 ≈ 400 万次采样：纯 GDScript 单线程实测 2.3 s，分块并行 0.8~0.9 s（2.4~3.0×）。
## chunks <= 0 = 自动（小网格自动单线程）；显式传 1 可强制串行（等价性测试用）。
func fill_from_noise(noise_seed: int, max_elevation: float = GameConfig.MAX_ELEVATION,
		chunks: int = 0) -> void:
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
	# 【2026-10-06 第七十九版 · 并行计算整改】按行分块 + WorkerThreadPool。
	# 400 万次噪声采样在纯 GDScript 下实测 2.3 s（1000×1000×4 层），分块后 0.8~0.9 s（2.4~3.0×）。
	# ⚠ 每个块**各自 new 一套 FastNoiseLite**：同一个实例被多线程同时调用 get_noise_2d 不是文档承诺的用法；
	#   参数与 seed 完全一致 ⇒ 逐格结果与单线程相同（探针实测 2000 格逐格一致）。
	# ⚠ 先置空再 resize：这样分配出来的缓冲是**未被共享**的，worker 里 `_data[i] = …` 才是就地写。
	#   若复用同一个（已共享的）Packed 数组，写入会触发 copy-on-write —— 多线程下会互相踩
	#   （实测报过满屏 `Out of bounds set index`，见 docs/性能预算.md 第二十八节）。
	_data = PackedFloat32Array()
	_data.resize(width * height)
	_noise_seed_value = noise_seed
	_noise_max_elevation = max_elevation
	_noise_elevation_ratio = elevation_ratio
	_noise_total_amplitude = total_amplitude
	_noise_bands = _bands_from(chunks, width * height, height)
	_noise_amps = _noise_amplitudes()      # 派发前建好（worker 里只读）
	if _noise_bands <= 1:
		_fill_noise_band(0)
		return
	var id := WorkerThreadPool.add_group_task(
			func(band: int) -> void: _fill_noise_band(band),
			_noise_bands, _noise_bands, true, "height_noise")
	WorkerThreadPool.wait_for_group_task_completion(id)


## 单块填噪声（顺序与并行共用同一个实现 ⇒ 两条路径逐格一致）
func _fill_noise_band(band: int) -> void:
	var rows := int(ceil(float(height) / float(_noise_bands)))
	var y0 := band * rows
	var y1 := mini(y0 + rows, height)
	if y0 >= y1:
		return
	var noises: Array[FastNoiseLite] = []
	for layer in NOISE_LAYERS:
		var noise := FastNoiseLite.new()
		noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
		noise.fractal_type = FastNoiseLite.FRACTAL_FBM
		noise.fractal_octaves = 4
		noise.fractal_lacunarity = 2.0
		noise.fractal_gain = 0.5
		noise.frequency = 1.0 / float(layer["feature"])
		noise.seed = _noise_seed_value
		noises.append(noise)
	# ⚠ 读的是主线程预先建好的 LUT（_noise_amps）：惰性初始化放在 worker 里会**互相踩** ——
	# 实测（probe_terrain_bake 第一次跑）报 `Out of bounds get index 3`：一个线程正在读，
	# 另一个线程把它重置成空数组。惰性 LUT 一律在派发之前建好。
	var amps := _noise_amps
	for y in range(y0, y1):
		var row := y * width
		for x in width:
			var accumulated := 0.0
			for i in noises.size():
				accumulated += noises[i].get_noise_2d(float(x), float(y)) * amps[i]
			var value := (accumulated + _noise_total_amplitude) * 0.5 * _noise_elevation_ratio
			_data[row + x] = clampf(value, 0.0, _noise_max_elevation)


## 并行分块数：低于阈值的网格走单线程（并行有固定开销，64×64 的单测不该为它买单）
## chunks > 0 时以调用方指定的为准（等价性测试要拿 chunks=1 当串行基准）。
static func _bands_from(chunks: int, cells: int, rows: int) -> int:
	var bands := chunks
	if bands <= 0:
		bands = 1 if cells < PARALLEL_MIN_CELLS else clampi(OS.get_processor_count() - 1, 2, PARALLEL_MAX_BANDS)
	return clampi(bands, 1, maxi(rows, 1))


## NOISE_LAYERS 的振幅 LUT（懒建；避免每格一次 Dictionary 取值）
static func _noise_amplitudes() -> PackedFloat32Array:
	if _noise_amp_lut.size() != NOISE_LAYERS.size():
		_noise_amp_lut = PackedFloat32Array()
		for layer in NOISE_LAYERS:
			_noise_amp_lut.append(float(layer["amplitude"]))
	return _noise_amp_lut


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
	# 【2026-10-06 第七十九版 · 并行计算整改】去掉逐格 set_height_at_cell()：
	# 旧实现每格一次 GDScript 方法调用 + 一次取模 + 一次整除，1000×1000 实测 653 ms；
	# 改成「整块字节 + 直写 _data」后同样口径 47 ms（**14×**，未用线程）。
	# 算式逐字保持 data[i] / 255.0 * max_elevation —— 换写成 data[i] * (max/255.0) 会动最后一 ulp，
	# 而配色分级是按高度比较的（见 MapGenerator.height_to_color），ulp 差异会在分级临界点上翻色。
	var cells := width * height
	if _data.size() != cells:
		_data.resize(cells)
	for i in cells:
		_data[i] = data[i] / 255.0 * max_elevation
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
