extends SceneTree

## 《解域》地图工具链 CLI（无头，给 agent / CI 用）
##
## 用法（在项目根目录）：
##   godot --headless --path . --script res://tools/jieyu_map_cli.gd -- <子命令> [参数]
##
## 子命令：
##   list                                  列出 res://assets/maps/ 下的全部地图
##   info     --map <id>                   打印一张地图的规格摘要
##   render   --map <id> [--layers a,b,c]  只重画 terrain.png 审阅图（不动高度）
##   validate --map <id> [--json]          跑 JieyuMapChecks 全量校验；有 ERROR → 退出码 1
##   generate --recipe <file.json> [--map <id>] [--seed N] [--validate]
##                                         按配方生成一张完整地图并落盘
##   snapshot --map <id> --out <png> [--layers ...]
##                                         导出审阅图到任意路径（给 agent 看图用）
##
## 为什么要有它：编辑器插件是给「人」的鼠标用的；agent / CI 需要的是
## 「一条命令生成 → 一条命令校验 → 非零退出码」这条链，否则每张图都得靠手点。
## 退出码：0 = 成功 / 1 = 失败（配方读不到、校验出 ERROR 等）。

const RECIPE_PATH := "res://addons/jieyu_map/recipe_demo.json"

var _exit_code := 0


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	var command := args[0] if args.size() > 0 else "help"
	var options := _parse_options(args)
	match command:
		"list":
			_cli_list()
		"info":
			_cli_info(options)
		"render":
			_cli_render(options)
		"snapshot":
			_cli_snapshot(options)
		"validate":
			_cli_validate(options)
		"generate":
			_cli_generate(options)
		_:
			_cli_help()
	quit(_exit_code)


func _parse_options(args: Array) -> Dictionary:
	var options := {}
	var i := 1
	while i < args.size():
		var token := str(args[i])
		if token.begins_with("--"):
			var key := token.substr(2)
			if key == "validate":
				options[key] = true
				i += 1
				continue
			if i + 1 < args.size():
				options[key] = str(args[i + 1])
				i += 2
				continue
		i += 1
	return options


func _cli_help() -> void:
	print("《解域》地图工具链 CLI")
	print("  list")
	print("  info     --map <id>")
	print("  render   --map <id> [--layers zones,occluders,contours,passability,grid_km]")
	print("  snapshot --map <id> --out <png> [--layers ...]")
	print("  validate --map <id> [--json]")
	print("  generate --recipe <file.json> [--map <id>] [--seed N] [--validate]")


# ────────────── list ──────────────

func _cli_list() -> void:
	var dirs := JieyuMapDoc.list_map_dirs()
	print("地图目录（%s）：%d 张" % [JieyuMapSpec.DEFAULT_MAP_ROOT, dirs.size()])
	for map_id in dirs:
		var doc := JieyuMapDoc.load_from_dir(map_id)
		if doc == null:
			print("  · %s（heightmap.png 读不出来）" % map_id)
			continue
		var nodes: Array = doc.zones.get("raas_nodes", [])
		print("  · %s  %d×%d  %s  节点 %d  遮挡体 %d"
				% [map_id, doc.width, doc.height_px, str(doc.meta.get("name", "")),
				nodes.size(), doc.occluders.size()])
	var flat := JieyuMapDoc.list_flat_height_maps()
	if not flat.is_empty():
		print("单张扁平高度图（历史产物，插件不管）：%d 张" % flat.size())
		for path in flat:
			print("  · %s" % path)


# ────────────── info ──────────────

func _cli_info(options: Dictionary) -> void:
	var doc := _require_doc(options)
	if doc == null:
		return
	var report := JieyuMapChecks.run(doc)
	print("map_id        %s" % doc.map_id)
	print("name          %s" % str(doc.meta.get("name", "")))
	print("尺寸          %d × %d（cell %.2f m）" % [doc.width, doc.height_px,
			float(doc.meta.get("cell_size_m", GameConfig.CELL_SIZE))])
	print("最大海拔      %.0f m（1 灰度 ≈ %.2f m）" % [doc.max_elevation(),
			doc.max_elevation() / 255.0])
	print("地形类型      %s" % str(doc.meta.get("terrain_type", "")))
	var noise: Dictionary = doc.meta.get("noise", {})
	print("噪声种子      %s（%s / octaves %s）" % [str(noise.get("seed", "")),
			str(noise.get("type", "")), str(noise.get("octaves", ""))])
	print("支持模式      %s" % str(doc.meta.get("modes", [])))
	var nodes: Array = doc.zones.get("raas_nodes", [])
	print("RAAS 节点     %d 个" % nodes.size())
	for node_v in nodes:
		var node: Dictionary = node_v
		print("   %-4s %-8s %s" % [str(node.get("id", "")), str(node.get("name", "")),
				str(JieyuMapGen.vec2(node.get("pos", [0, 0])))])
	print("出生区        %d 个" % (doc.zones.get("spawn_areas", []) as Array).size())
	print("集结点区      %d 个" % (doc.zones.get("rally_zones", []) as Array).size())
	print("遮挡体        %d 个" % doc.occluders.size())
	print("校验          %s" % JieyuMapChecks.summary(report))
	for item_v in report:
		var item: Dictionary = item_v
		if str(item["level"]) == JieyuMapChecks.SEV_ERROR:
			print("   [%s] %s" % [str(item["level"]), str(item["message"])])


# ────────────── render / snapshot ──────────────

func _cli_render(options: Dictionary) -> void:
	var doc := _require_doc(options)
	if doc == null:
		return
	var image := JieyuMapRender.overview_image(doc, _layer_options(options))
	var path := JieyuMapSpec.file_path(doc.map_id, JieyuMapSpec.FILE_TERRAIN)
	var err := image.save_png(path)
	if err != OK:
		print("！！ 审阅图写入失败：%s" % error_string(err))
		_exit_code = 1
		return
	print("已重画审阅图：%s（%d×%d）" % [path, image.get_width(), image.get_height()])


func _cli_snapshot(options: Dictionary) -> void:
	var doc := _require_doc(options)
	if doc == null:
		return
	var out := str(options.get("out", ""))
	if out.is_empty():
		print("！！ snapshot 需要 --out <png 路径>")
		_exit_code = 1
		return
	var image := JieyuMapRender.overview_image(doc, _layer_options(options))
	var err := image.save_png(out)
	if err != OK:
		print("！！ 快照写入失败：%s" % error_string(err))
		_exit_code = 1
		return
	print("已导出快照：%s（%d×%d）" % [out, image.get_width(), image.get_height()])


func _layer_options(options: Dictionary) -> Dictionary:
	var defaults := {
		"contours": true, "zones": true, "occluders": true,
		"passability": false, "grid_km": false,
	}
	var wanted := str(options.get("layers", ""))
	if wanted.is_empty():
		return defaults
	for key in defaults.keys():
		defaults[key] = false
	for token in wanted.split(","):
		var key := token.strip_edges()
		if defaults.has(key):
			defaults[key] = true
	return defaults


# ────────────── validate ──────────────

func _cli_validate(options: Dictionary) -> void:
	var doc := _require_doc(options)
	if doc == null:
		return
	var report := JieyuMapChecks.run(doc)
	if bool(options.get("json", false)):
		print(JSON.stringify(report, "  ", true, true))
	else:
		_print_report(doc.map_id, report)
	if JieyuMapChecks.count_level(report, JieyuMapChecks.SEV_ERROR) > 0:
		_exit_code = 1


func _print_report(map_id: String, report: Array) -> void:
	print("==== 校验 %s ====" % map_id)
	for item_v in report:
		var item: Dictionary = item_v
		print("[%-5s] %-28s %s" % [str(item["level"]), str(item["code"]), str(item["message"])])
	print("---- %s ----" % JieyuMapChecks.summary(report))


# ────────────── generate ──────────────

func _cli_generate(options: Dictionary) -> void:
	var recipe_path := str(options.get("recipe", RECIPE_PATH))
	var recipe := _load_recipe(recipe_path)
	if recipe.is_empty():
		_exit_code = 1
		return
	var map_id := str(options.get("map", recipe.get("map_id", "map_new")))
	if options.has("seed"):
		recipe["seed"] = int(str(options["seed"]))
	var started := Time.get_ticks_msec()
	var doc := JieyuMapGen.from_recipe(map_id, recipe)
	var generated := Time.get_ticks_msec() - started
	print("生成完成：%s（%d×%d，%.1f s）" % [map_id, doc.width, doc.height_px,
			float(generated) / 1000.0])
	for warning in doc.warnings:
		print("  [注意] %s" % warning)
	var err := doc.save()
	if err != OK:
		print("！！ 落盘失败：%s" % error_string(err))
		_exit_code = 1
		return
	print("已写入 %s" % JieyuMapSpec.map_dir(map_id))
	if bool(options.get("validate", false)):
		var report := JieyuMapChecks.run(doc)
		_print_report(map_id, report)
		if JieyuMapChecks.count_level(report, JieyuMapChecks.SEV_ERROR) > 0:
			_exit_code = 1


func _load_recipe(path: String) -> Dictionary:
	var text := ""
	if FileAccess.file_exists(path):
		var file := FileAccess.open(path, FileAccess.READ)
		text = file.get_as_text()
		file.close()
	else:
		var absolute := ProjectSettings.globalize_path(path)
		if FileAccess.file_exists(absolute):
			var file2 := FileAccess.open(absolute, FileAccess.READ)
			text = file2.get_as_text()
			file2.close()
	if text.is_empty():
		print("！！ 读不到配方：%s" % path)
		return {}
	var parsed: Variant = JSON.parse_string(text)
	if not (parsed is Dictionary):
		print("！！ 配方不是 JSON 对象：%s" % path)
		return {}
	return parsed


# ────────────── 公共 ──────────────

func _require_doc(options: Dictionary) -> JieyuMapDoc:
	var map_id := str(options.get("map", ""))
	if map_id.is_empty():
		print("！！ 需要 --map <id>（可用 list 子命令看有哪些）")
		_exit_code = 1
		return null
	var doc := JieyuMapDoc.load_from_dir(map_id)
	if doc == null:
		print("！！ 读不到地图：%s" % map_id)
		_exit_code = 1
		return null
	for warning in doc.warnings:
		print("  [注意] %s" % warning)
	return doc
