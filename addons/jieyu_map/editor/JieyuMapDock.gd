@tool
class_name JieyuMapDock
extends VBoxContainer

## 插件主面板：状态 + 所有「对地图做的事」+ UI 组装。
##
## 分工约定（避免这个文件变成一坨）：
##   · 本类：文档状态、画笔落笔逻辑、保存 / 校验 / 生成 / 导入导出、UI 组装与信号接线
##   · JieyuMapCanvas：显示与坐标换算
##   · JieyuMapPainter：改高度的原子操作
##   · JieyuMapChecks：校验
##   · JieyuMapGen：噪声生成 + 自动布点
##
## 撤销：每次落笔前 push 一份高度快照（上限 UNDO_LIMIT 步，每步 1 MB 量级）。
## 为什么不接 EditorUndoRedoManager：高度是 100 万字节的整块数据，
## 走编辑器撤销栈会把每次拖拽都塞进全局历史，撤销一次要等一秒以上；本地面板历史更跟手。

const CANVAS_SCRIPT := preload("res://addons/jieyu_map/editor/JieyuMapCanvas.gd")

const UNDO_LIMIT := 12
const REGEN_GRID_MAX := 512   # 面板里「重新生成」的最大网格边长（更大的走 CLI）

enum Tool { RAISE, LOWER, FLATTEN, SMOOTH, PLATEAU, NODE, BUILDING, ERASE_BUILDING }

var editor_plugin: EditorPlugin = null
var recipe_path := ""

var doc: JieyuMapDoc = null
var tool: int = Tool.RAISE
var brush_radius := 30.0
var brush_delta := 3.0
var brush_strength := 0.6
var plateau_height := 100.0
var building_half := 5.0
var building_top := 4.5
var building_destructible := false
var node_counter := 0

var _canvas: Control = null
var _overlay_texture: ImageTexture = null
var _undo: Array = []
var _redo: Array = []
var _moved_nodes := {}
var _last_overlay_msec := 0
var _overlay_dirty := true

# UI 引用
var _map_option: OptionButton = null
var _info_label: Label = null
var _report_text: TextEdit = null
var _layers_box: VBoxContainer = null
var _param_box: VBoxContainer = null
var _status_label: Label = null
var _tool_group: ButtonGroup = null
var _radius_spin: SpinBox = null
var _delta_spin: SpinBox = null
var _strength_spin: SpinBox = null
var _plateau_spin: SpinBox = null
var _seed_spin: SpinBox = null
var _nodes_spin: SpinBox = null
var _grid_spin: SpinBox = null
var _layer_checks := {}


func _ready() -> void:
	name = "解域地图"
	add_theme_constant_override("separation", 4)
	custom_minimum_size = Vector2(360.0, 420.0)
	_build_ui()
	_refresh_map_list()
	var dirs := JieyuMapDoc.list_map_dirs()
	if not dirs.is_empty():
		_select_map(dirs[0])
	else:
		doc = JieyuMapGen.from_recipe("map_new", _default_recipe(256))
		_after_doc_changed("没有已存在的地图，已生成一张 256×256 的草稿（改完点保存）")


# ══════════════════════════ UI 组装 ══════════════════════════

func _build_ui() -> void:
	add_child(_build_toolbar())

	var split := HSplitContainer.new()
	split.size_flags_vertical = Control.SIZE_EXPAND_FILL
	split.split_offset = 250
	add_child(split)

	split.add_child(_build_left_panel())

	_canvas = CANVAS_SCRIPT.new()
	_canvas.name = "MapCanvas"
	_canvas.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_canvas.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_canvas.custom_minimum_size = Vector2(160.0, 160.0)
	_canvas.stroke_started.connect(_on_stroke_started)
	_canvas.stroke_moved.connect(_on_stroke_moved)
	_canvas.stroke_ended.connect(_on_stroke_ended)
	split.add_child(_canvas)


func _build_toolbar() -> HBoxContainer:
	var bar := HBoxContainer.new()
	bar.add_theme_constant_override("separation", 4)
	var actions := [
		["保存", _on_save_pressed],
		["校验", _on_validate_pressed],
		["重画审阅图", _on_render_pressed],
		["撤销", _on_undo_pressed],
		["重做", _on_redo_pressed],
		["适配", func() -> void: _canvas.fit_now()],
	]
	for action in actions:
		var button := Button.new()
		button.text = str(action[0])
		button.pressed.connect(action[1])
		bar.add_child(button)
	return bar


func _build_left_panel() -> ScrollContainer:
	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(250.0, 0.0)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	var box := VBoxContainer.new()
	box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.add_theme_constant_override("separation", 6)
	scroll.add_child(box)

	box.add_child(_section("地图"))
	box.add_child(_build_map_row())
	_info_label = Label.new()
	_info_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_info_label.add_theme_font_size_override("font_size", 11)
	box.add_child(_info_label)

	box.add_child(_section("生成 / 重新生成"))
	box.add_child(_build_generate_row())

	box.add_child(_section("画笔"))
	box.add_child(_build_tool_row())
	_param_box = VBoxContainer.new()
	box.add_child(_param_box)
	_build_param_rows()
	_update_param_visibility()

	box.add_child(_section("图层（审阅叠加）"))
	_layers_box = VBoxContainer.new()
	box.add_child(_layers_box)
	_build_layer_checks()

	box.add_child(_section("节点与掩体"))
	box.add_child(_build_zone_row())

	box.add_child(_section("校验报告"))
	_report_text = TextEdit.new()
	_report_text.custom_minimum_size = Vector2(0.0, 140.0)
	_report_text.editable = false
	_report_text.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY
	_report_text.add_theme_font_size_override("font_size", 11)
	box.add_child(_report_text)

	_status_label = Label.new()
	_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_status_label.add_theme_font_size_override("font_size", 11)
	box.add_child(_status_label)
	return scroll


func _section(title: String) -> Label:
	var label := Label.new()
	label.text = "── %s" % title
	label.add_theme_font_size_override("font_size", 12)
	return label


func _build_map_row() -> HBoxContainer:
	var row := HBoxContainer.new()
	_map_option = OptionButton.new()
	_map_option.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_map_option.item_selected.connect(func(index: int) -> void:
		_select_map(_map_option.get_item_text(index)))
	row.add_child(_map_option)
	var reload := Button.new()
	reload.text = "重载"
	reload.pressed.connect(func() -> void:
		if doc != null:
			_select_map(doc.map_id))
	row.add_child(reload)
	var import_button := Button.new()
	import_button.text = "导入 PNG…"
	import_button.pressed.connect(_on_import_pressed)
	row.add_child(import_button)
	return row


func _build_generate_row() -> VBoxContainer:
	var box := VBoxContainer.new()
	var grid_row := HBoxContainer.new()
	grid_row.add_child(_label("网格"))
	_grid_spin = _spin(64, 1024, 1, 256)
	grid_row.add_child(_grid_spin)
	grid_row.add_child(_label("种子"))
	_seed_spin = _spin(1, 2147483647, 1, GameConfig.DEFAULT_MAP_SEED)
	grid_row.add_child(_seed_spin)
	grid_row.add_child(_label("节点"))
	_nodes_spin = _spin(2, 8, 1, 5)
	grid_row.add_child(_nodes_spin)
	box.add_child(grid_row)
	var row := HBoxContainer.new()
	var regen := Button.new()
	regen.text = "按面板参数生成"
	regen.tooltip_text = "用面板里的种子 / 网格 / 节点数重新生成一张草稿（大图请走 CLI: generate --recipe）"
	regen.pressed.connect(_on_regenerate_pressed)
	row.add_child(regen)
	var from_recipe := Button.new()
	from_recipe.text = "按 recipe_demo.json 生成"
	from_recipe.pressed.connect(_on_generate_from_recipe)
	row.add_child(from_recipe)
	box.add_child(row)
	box.add_child(_button_row([
		["压平所有节点", func() -> void: _apply_flatten_nodes()],
		["重画五结构", func() -> void: _apply_rebuild_zones()],
	]))
	return box


func _build_tool_row() -> GridContainer:
	var grid := GridContainer.new()
	grid.columns = 4
	_tool_group = ButtonGroup.new()
	var tools := [
		["抬升", Tool.RAISE], ["下挖", Tool.LOWER], ["压平", Tool.FLATTEN], ["平滑", Tool.SMOOTH],
		["台地", Tool.PLATEAU], ["放节点", Tool.NODE], ["放建筑", Tool.BUILDING],
		["删建筑", Tool.ERASE_BUILDING],
	]
	for entry in tools:
		var button := Button.new()
		button.text = str(entry[0])
		button.toggle_mode = true
		button.button_group = _tool_group
		button.button_pressed = int(entry[1]) == tool
		button.pressed.connect(_on_tool_selected.bind(int(entry[1])))
		grid.add_child(button)
	return grid


func _build_param_rows() -> void:
	var rows := [
		["半径 m", _spin(1.0, 400.0, 1.0, brush_radius), func(value: float) -> void:
			brush_radius = value
			_canvas.brush_radius = value],
		["强度 m", _spin(0.2, 60.0, 0.2, brush_delta), func(value: float) -> void:
			brush_delta = value],
		["平滑 0–1", _spin(0.05, 1.0, 0.05, brush_strength), func(value: float) -> void:
			brush_strength = value],
		["台地高 m", _spin(10.0, 150.0, 1.0, plateau_height), func(value: float) -> void:
			plateau_height = value],
		["建筑半宽 m", _spin(1.0, 30.0, 0.5, building_half), func(value: float) -> void:
			building_half = value],
		["建筑高 m", _spin(0.5, 20.0, 0.5, building_top), func(value: float) -> void:
			building_top = value],
	]
	var index := 0
	for row in rows:
		var line := HBoxContainer.new()
		line.add_child(_label(str(row[0])))
		var spin: SpinBox = row[1]
		line.add_child(spin)
		spin.value_changed.connect(row[2])
		match index:
			0: _radius_spin = spin
			1: _delta_spin = spin
			2: _strength_spin = spin
			3: _plateau_spin = spin
		_param_box.add_child(line)
		index += 1


func _build_layer_checks() -> void:
	var layers := [
		["等高线", "contours", true],
		["节点五结构", "zones", true],
		["掩体建筑", "occluders", true],
		["不可通行", "passability", false],
		["百米格网", "grid_km", false],
	]
	for entry in layers:
		var check := CheckBox.new()
		check.text = str(entry[0])
		check.button_pressed = bool(entry[2])
		check.toggled.connect(func(_pressed: bool) -> void: _refresh_overlay(true))
		_layers_box.add_child(check)
		_layer_checks[str(entry[1])] = check


func _build_zone_row() -> VBoxContainer:
	var box := VBoxContainer.new()
	box.add_child(_button_row([
		["节点区压平", _apply_flatten_nodes],
		["加一栋建筑", func() -> void: _set_tool(Tool.BUILDING)],
	]))
	var destructible := CheckBox.new()
	destructible.text = "新建筑可破坏（occluders.destructible）"
	destructible.button_pressed = building_destructible
	destructible.toggled.connect(func(pressed: bool) -> void: building_destructible = pressed)
	box.add_child(destructible)
	return box


func _button_row(entries: Array) -> HBoxContainer:
	var row := HBoxContainer.new()
	for entry in entries:
		var button := Button.new()
		button.text = str(entry[0])
		button.pressed.connect(entry[1])
		row.add_child(button)
	return row


func _label(text: String) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 11)
	return label


func _spin(min_value: float, max_value: float, step: float, value: float) -> SpinBox:
	var spin := SpinBox.new()
	spin.min_value = min_value
	spin.max_value = max_value
	spin.step = step
	spin.value = value
	spin.custom_minimum_size = Vector2(78.0, 0.0)
	return spin


# ══════════════════════════ 文档 ══════════════════════════

func _refresh_map_list() -> void:
	if _map_option == null:
		return
	_map_option.clear()
	for map_id in JieyuMapDoc.list_map_dirs():
		_map_option.add_item(map_id)


func _select_map(map_id: String) -> void:
	var loaded := JieyuMapDoc.load_from_dir(map_id)
	if loaded == null:
		_set_status("读不到 %s（要先有 heightmap.png）" % map_id)
		return
	doc = loaded
	_moved_nodes.clear()
	_undo.clear()
	_redo.clear()
	_after_doc_changed("已载入 %s" % map_id)


func _after_doc_changed(message: String) -> void:
	_canvas.map_size = Vector2i(doc.width, doc.height_px)
	_canvas.texture = doc.to_height_texture()
	_canvas.fit_now()
	node_counter = (doc.zones.get("raas_nodes", []) as Array).size()
	_overlay_dirty = true
	_refresh_overlay(true)
	_refresh_info()
	_set_status(message)


func _default_recipe(grid: int) -> Dictionary:
	return {
		"map_id": "map_new",
		"name": "新地图草稿",
		"grid_w": grid,
		"grid_h": grid,
		"seed": int(_seed_spin.value) if _seed_spin != null else GameConfig.DEFAULT_MAP_SEED,
		"node_count": int(_nodes_spin.value) if _nodes_spin != null else 5,
		"river_axis": "y",
		"water_level_m": 8.0,
		"river_center_ratio": 0.52,
		"river_half_width_m": 26.0,
	}


# ══════════════════════════ 画笔 ══════════════════════════

func _set_tool(new_tool: int) -> void:
	tool = new_tool
	_canvas.brush_visible = tool != Tool.NODE
	_update_param_visibility()


func _on_tool_selected(new_tool: int) -> void:
	_set_tool(new_tool)


func _update_param_visibility() -> void:
	if _delta_spin == null:
		return
	_delta_spin.get_parent().visible = tool in [Tool.RAISE, Tool.LOWER]
	_strength_spin.get_parent().visible = tool == Tool.SMOOTH
	_plateau_spin.get_parent().visible = tool == Tool.PLATEAU


func _on_stroke_started(at_cell: Vector2i) -> void:
	if doc == null:
		return
	_push_undo()
	_apply_brush(at_cell, at_cell)


func _on_stroke_moved(from_cell: Vector2i, to_cell: Vector2i) -> void:
	if doc == null:
		return
	_apply_brush(from_cell, to_cell)


func _on_stroke_ended() -> void:
	_refresh_info()
	_refresh_overlay(true)


## 沿线段落笔（拖拽时保证笔刷连续，不掉点）
func _apply_brush(from_cell: Vector2i, to_cell: Vector2i) -> void:
	if doc == null:
		return
	var from_world := Vector2(from_cell)
	var to_world := Vector2(to_cell)
	var distance := from_world.distance_to(to_world)
	var steps := maxi(1, int(ceil(distance / maxf(brush_radius * 0.4, 1.0))))
	var touched := 0
	for i in steps + 1:
		var point := from_world.lerp(to_world, float(i) / float(steps))
		touched += _apply_brush_at(point)
	if touched == 0:
		return
	_canvas.texture = doc.to_height_texture()
	_overlay_dirty = true
	_refresh_overlay(false)


func _apply_brush_at(point: Vector2) -> int:
	match tool:
		Tool.RAISE:
			return JieyuMapPainter.paint_raise(doc, point, brush_radius, brush_delta)
		Tool.LOWER:
			return JieyuMapPainter.paint_raise(doc, point, brush_radius, -brush_delta)
		Tool.FLATTEN:
			return JieyuMapPainter.flatten_disc(doc, point, brush_radius, 0.0, -1.0)
		Tool.SMOOTH:
			return JieyuMapPainter.paint_smooth(doc, point, brush_radius, brush_strength)
		Tool.PLATEAU:
			return JieyuMapPainter.carve_plateau(doc, point, brush_radius, plateau_height,
					brush_radius)
		Tool.NODE:
			return _place_node(point)
		Tool.BUILDING:
			JieyuMapPainter.add_occluder(doc, point, building_half, building_half, building_top,
					"building", building_destructible)
			_overlay_dirty = true
			return 1
		Tool.ERASE_BUILDING:
			return JieyuMapPainter.remove_occluders_near(doc, point, maxf(brush_radius, 20.0))
		_:
			return 0


## 放节点：地形按「被移过的节点才降平顶」处理（避免整片地形被抹平）
func _place_node(point: Vector2) -> int:
	node_counter += 1
	var node_id := "N%d" % node_counter
	if not doc.zones.get("raas_nodes", []).is_empty() and _find_node(node_id) != null:
		node_id = "N%d" % (node_counter + 100)
	node_counter = maxi(node_counter, node_id.substr(1).to_int())
	JieyuMapPainter.upsert_node(doc, node_id, "", point)
	_moved_nodes[node_id] = true
	var level := _min_height_around(point, JieyuMapSpec.CORE_RADIUS_M)
	JieyuMapPainter.flatten_disc(doc, point, JieyuMapSpec.CORE_RADIUS_M, 12.0, level)
	_set_status("已放节点 %s（%s）—— 点「重画五结构」补齐 flag / 集结点 / 出生区"
			% [node_id, str(Vector2i(roundi(point.x), roundi(point.y)))])
	return 1


func _find_node(node_id: String) -> Variant:
	for node_v in doc.zones.get("raas_nodes", []):
		if str((node_v as Dictionary).get("id", "")) == node_id:
			return node_v
	return null


func _min_height_around(point: Vector2, radius: float) -> float:
	var lowest := INF
	for y in range(maxi(floori(point.y - radius), 0),
			mini(ceili(point.y + radius) + 1, doc.height_px)):
		for x in range(maxi(floori(point.x - radius), 0),
				mini(ceili(point.x + radius) + 1, doc.width)):
			if Vector2(x, y).distance_to(point) > radius:
				continue
			lowest = minf(lowest, doc.height_at(x, y))
	return 0.0 if is_inf(lowest) else lowest


# ══════════════════════════ 动作 ══════════════════════════

func _push_undo() -> void:
	if doc == null:
		return
	_undo.append(doc.height.duplicate())
	if _undo.size() > UNDO_LIMIT:
		_undo.pop_front()
	_redo.clear()


func _on_undo_pressed() -> void:
	if doc == null or _undo.is_empty():
		return
	_redo.append(doc.height.duplicate())
	doc.height = _undo.pop_back()
	_canvas.texture = doc.to_height_texture()
	_overlay_dirty = true
	_refresh_overlay(true)
	_set_status("撤销（剩 %d 步）" % _undo.size())


func _on_redo_pressed() -> void:
	if doc == null or _redo.is_empty():
		return
	_undo.append(doc.height.duplicate())
	doc.height = _redo.pop_back()
	_canvas.texture = doc.to_height_texture()
	_overlay_dirty = true
	_refresh_overlay(true)
	_set_status("重做")


func _on_save_pressed() -> void:
	if doc == null:
		return
	_renumber_nodes()
	var err := doc.save()
	if err != OK:
		_set_status("保存失败：%s" % error_string(err))
		return
	_moved_nodes.clear()
	_refresh_map_list()
	var report := JieyuMapChecks.run(doc)
	_show_report(report)
	_set_status("已保存 %s：%s" % [doc.map_id, JieyuMapChecks.summary(report)])


func _on_validate_pressed() -> void:
	if doc == null:
		return
	_show_report(JieyuMapChecks.run(doc))


func _on_render_pressed() -> void:
	if doc == null:
		return
	var image := JieyuMapRender.overview_image(doc, _layer_options())
	var err := image.save_png(JieyuMapSpec.file_path(doc.map_id, JieyuMapSpec.FILE_TERRAIN))
	if err != OK:
		_set_status("审阅图写入失败：%s" % error_string(err))
		return
	_set_status("已重画 %s" % JieyuMapSpec.FILE_TERRAIN)


func _on_regenerate_pressed() -> void:
	var grid := int(_grid_spin.value)
	if grid > REGEN_GRID_MAX:
		_set_status("面板里最大 %d 格（%d 格请用 CLI：generate --recipe，避免编辑器卡住）"
				% [REGEN_GRID_MAX, grid])
		return
	var map_id := doc.map_id if doc != null else "map_new"
	var recipe := _default_recipe(grid)
	recipe["map_id"] = map_id
	var generated := JieyuMapGen.from_recipe(map_id, recipe)
	if generated == null:
		_set_status("生成失败")
		return
	doc = generated
	_moved_nodes.clear()
	_undo.clear()
	_redo.clear()
	_after_doc_changed("已重新生成 %d×%d 草稿（还没落盘）" % [grid, grid])


func _on_generate_from_recipe() -> void:
	if not FileAccess.file_exists(recipe_path):
		_set_status("找不到配方：%s" % recipe_path)
		return
	var file := FileAccess.open(recipe_path, FileAccess.READ)
	var recipe: Variant = JSON.parse_string(file.get_as_text())
	file.close()
	if not (recipe is Dictionary):
		_set_status("配方不是 JSON 对象：%s" % recipe_path)
		return
	var map_id := str((recipe as Dictionary).get("map_id", "map_new"))
	var generated := JieyuMapGen.from_recipe(map_id, recipe)
	if generated == null:
		_set_status("生成失败")
		return
	doc = generated
	_moved_nodes.clear()
	_undo.clear()
	_redo.clear()
	_after_doc_changed("按配方生成 %s（点保存落盘）" % map_id)


func _on_import_pressed() -> void:
	_set_status("导入 PNG：把灰度高度图放到 %s，再用左上的下拉「重载」；"
			% JieyuMapSpec.DEFAULT_MAP_ROOT
			+ "或走 CLI snapshot/render 之后直接改 heightmap.png")


func _apply_flatten_nodes() -> void:
	if doc == null:
		return
	_push_undo()
	var touched := 0
	for node_v in doc.zones.get("raas_nodes", []):
		var node: Dictionary = node_v
		var pos := JieyuMapGen.vec2(node.get("pos", [0, 0]))
		var level := -1.0
		if _moved_nodes.has(str(node.get("id", ""))):
			level = _min_height_around(pos, JieyuMapSpec.CORE_RADIUS_M)
		touched += JieyuMapPainter.flatten_disc(doc, pos, JieyuMapSpec.CORE_RADIUS_M,
				18.0, level)
	_canvas.texture = doc.to_height_texture()
	_overlay_dirty = true
	_refresh_overlay(true)
	_set_status("节点区压平：改动 %d 格" % touched)


func _apply_rebuild_zones() -> void:
	if doc == null:
		return
	var nodes: Array = doc.zones.get("raas_nodes", [])
	if nodes.is_empty():
		_set_status("还没有节点，先用「放节点」工具点几个")
		return
	_renumber_nodes()
	doc.zones = JieyuMapGen.build_zones(doc.zones["raas_nodes"], doc.width, doc.height_px,
			int(doc.meta.get("noise", {}).get("seed", GameConfig.DEFAULT_MAP_SEED)))
	_overlay_dirty = true
	_refresh_overlay(true)
	_refresh_info()
	_set_status("五结构已重建：%d 个节点 + flag / 集结点 / 出生区" % nodes.size())


## 按当前坐标从左到右重编号 N1..Nn（用「放节点」工具堆出来的临时 id 在这里收敛）
func _renumber_nodes() -> void:
	if doc == null:
		return
	var nodes: Array = doc.zones.get("raas_nodes", [])
	if nodes.is_empty():
		return
	var sorted := nodes.duplicate()
	sorted.sort_custom(func(a: Variant, b: Variant) -> bool:
		return JieyuMapGen.vec2((a as Dictionary).get("pos", [0, 0])).x \
				< JieyuMapGen.vec2((b as Dictionary).get("pos", [0, 0])).x)
	var remap := {}
	for i in sorted.size():
		var old_id := str((sorted[i] as Dictionary).get("id", ""))
		var new_id := "N%d" % (i + 1)
		remap[old_id] = new_id
		(sorted[i] as Dictionary)["id"] = new_id
	doc.zones["raas_nodes"] = sorted
	for key in ["flags", "rally_zones"]:
		for item_v in doc.zones.get(key, []):
			if item_v is Dictionary:
				var old_key := str((item_v as Dictionary).get("node", ""))
				if remap.has(old_key):
					(item_v as Dictionary)["node"] = remap[old_key]
	_moved_nodes.clear()


# ══════════════════════════ 显示刷新 ══════════════════════════

func _layer_options() -> Dictionary:
	var options := {}
	for key in _layer_checks.keys():
		options[key] = (_layer_checks[key] as CheckBox).button_pressed
	return options


## 重画叠加层。live=true 或超过 250 ms 才真的重画（1000×1000 逐像素是秒级开销）
func _refresh_overlay(force: bool) -> void:
	if doc == null or not _overlay_dirty:
		return
	var now := Time.get_ticks_msec()
	if not force and now - _last_overlay_msec < 250:
		return
	_last_overlay_msec = now
	var image := JieyuMapRender.overview_image(doc, _layer_options())
	_overlay_texture = ImageTexture.create_from_image(image)
	_canvas.overlay = _overlay_texture
	_canvas.overlay_alpha = 0.85
	_overlay_dirty = false


func _refresh_info() -> void:
	if doc == null or _info_label == null:
		return
	var nodes: Array = doc.zones.get("raas_nodes", [])
	_info_label.text = "%s　%d×%d　最高 %.0f m / 最低 %.0f m\n节点 %d　遮挡体 %d　出生区 %d" % [
		doc.map_id, doc.width, doc.height_px, _doc_max(), _doc_min(),
		nodes.size(), doc.occluders.size(), (doc.zones.get("spawn_areas", []) as Array).size()]


func _doc_max() -> float:
	var highest := 0.0
	for y in range(0, doc.height_px, 8):
		for x in range(0, doc.width, 8):
			highest = maxf(highest, doc.height_at(x, y))
	return highest


func _doc_min() -> float:
	var lowest := INF
	for y in range(0, doc.height_px, 8):
		for x in range(0, doc.width, 8):
			lowest = minf(lowest, doc.height_at(x, y))
	return 0.0 if is_inf(lowest) else lowest


func _show_report(report: Array) -> void:
	if _report_text == null:
		return
	var lines: Array[String] = [JieyuMapChecks.summary(report), ""]
	for item_v in report:
		var item: Dictionary = item_v
		lines.append("[%s] %s" % [str(item["level"]), str(item["message"])])
	_report_text.text = "\n".join(lines)


func _set_status(message: String) -> void:
	if _status_label != null:
		_status_label.text = message
	print("[解域地图] %s" % message)
