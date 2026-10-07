extends SceneTree

## 启动期地形烘焙探针（2026-10-06 第七十九版 · 并行计算整改）
##
## 为什么要有它：WorldSetup.setup() 在 Main._ready() 里**同步**跑完才出第一帧，
## 其中「高度图导入 / 地形贴图上色 / 内容层解析 / 可达性掩码 / 噪声基底」是大头。
## 这个探针把这几件按真实代码路径各跑一遍并计时，改前改后同一口径可比。
##
## 口径纪律：桌面 headless、debug 编辑器构建；**只量脚本侧墙钟**，不含渲染与 GPU。
## 真机对局加载时间要另走 android-device-verify（本探针不能外推）。
##
## 用法（在项目根目录）：
##   godot --headless --path . --script res://tools/probe_terrain_bake.gd
##   godot --headless --path . --script res://tools/probe_terrain_bake.gd -- --chunks=1   # 强制串行对照
##   godot --headless --path . --script res://tools/probe_terrain_bake.gd -- --no-noise  # 跳过 1000×1000 噪声

var _chunks := 0


func _ms(t0: int) -> float:
	return float(Time.get_ticks_usec() - t0) / 1000.0


func _initialize() -> void:
	var skip_noise := false
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--chunks="):
			_chunks = int(arg.split("=")[1])
		elif arg == "--no-noise":
			skip_noise = true
	print("[烘焙] cpu=%d build=%s grid=%d×%d chunks=%s" % [
			OS.get_processor_count(), "debug" if OS.is_debug_build() else "release",
			GameConfig.GRID_WIDTH, GameConfig.GRID_HEIGHT,
			"auto" if _chunks <= 0 else str(_chunks)])

	# ① 读高度图（WorldSetup._load_height_image 的路径）
	var t := Time.get_ticks_usec()
	var image := _load_height_image(GameConfig.MAP_HEIGHT_IMAGE)
	print("[烘焙] ① 读高度图                  %.1f ms  size=%s" % [
			_ms(t), str(image.get_size()) if image != null else "null"])

	# ② 导入网格（HeightGrid.fill_from_image）
	var grid := HeightGrid.new(GameConfig.GRID_WIDTH, GameConfig.GRID_HEIGHT)
	t = Time.get_ticks_usec()
	var ok := grid.fill_from_image(image)
	print("[烘焙] ② fill_from_image           %.1f ms  ok=%s" % [_ms(t), str(ok)])

	# ③ 地形贴图（WorldSetup._build_terrain 的判据：debug 才画红域）
	var rough := 1.5 if OS.is_debug_build() else -1.0
	t = Time.get_ticks_usec()
	var texture := MapGenerator.build_terrain_texture(grid, rough, _chunks)
	print("[烘焙] ③ build_terrain_texture     %.1f ms  rough=%s 纹理=%s" % [
			_ms(t), str(rough), "有" if texture != null else "无"])

	# ④ 内容层 material.png → 连通域（WorldSetup._build_terrain_zones 的路径）
	t = Time.get_ticks_usec()
	var material_path := "res://assets/maps/qingling_corridor/material.png"
	if ResourceLoader.exists(material_path, "Texture2D") or FileAccess.file_exists(material_path):
		var material := _load_height_image(material_path)
		var zones := MapGenerator.terrain_zones_from_material_image(material)
		print("[烘焙] ④ 内容层连通域              %.1f ms  区域=%d" % [_ms(t), zones.size()])
	else:
		print("[烘焙] ④ 内容层连通域              跳过（没有 material.png）")

	# ⑤ 可达性掩码（只在地图检测模式用；这里量它是为了给「同一批整块字节写法」留个基线）
	t = Time.get_ticks_usec()
	var passability := MapInspector.build_passability_image(grid, GameConfig.PREVIEW_SLOPE_STEP, _chunks)
	print("[烘焙] ⑤ build_passability_image   %.1f ms  (仅预览模式)" % _ms(t))

	# ⑥ 噪声基底（只在没有高度图时走；1000×1000×4 层）
	if not skip_noise:
		var noise_grid := HeightGrid.new(GameConfig.GRID_WIDTH, GameConfig.GRID_HEIGHT)
		t = Time.get_ticks_usec()
		noise_grid.fill_from_noise(GameConfig.DEFAULT_MAP_SEED, GameConfig.MAX_ELEVATION, _chunks)
		print("[烘焙] ⑥ fill_from_noise（退回路径）%.1f ms" % _ms(t))
	quit(0)


## 与 WorldSetup._load_height_image 同口径（导出包走 Texture2D，编辑器里回退直读文件）
func _load_height_image(path: String) -> Image:
	if ResourceLoader.exists(path, "Texture2D"):
		var texture := ResourceLoader.load(path, "Texture2D") as Texture2D
		if texture != null:
			var imported := texture.get_image()
			if imported != null and imported.get_width() > 0:
				return imported
	return Image.load_from_file(path)
