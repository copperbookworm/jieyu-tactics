extends SceneTree

## 美术资产规格校验（2026-10-07 第八十六版 · asset-pipeline 技能第 3 步）
##
## 两件事分开做，**退出码只反映第一件**：
##   ① **结构性检查**（失败会红）：规格文件自己是否自洽 —— ID 唯一且 snake_case、路径都在 res://assets/ 下、
##      不许有中文文件名、尺寸要么是正整数对要么显式标 unresolved、batch 合法、batch1 的每一项都**必须已经给出尺寸**
##      （否则美术拿不到可执行的任务）。
##   ② **入库盘点**（只打印，不算失败）：规格里列的文件工程里到了几个。资产是一张一张产出的，
##      「第 N 张还没来」不是工程坏了 —— 所以默认不红。要硬查加 --require-batch1。
##
## 用法：godot --headless --path . --script res://tools/check_art_manifest.gd
##       godot --headless --path . --script res://tools/check_art_manifest.gd -- --require-batch1
##
## 为什么单开一条门禁而不是塞进几何门禁：几何门禁量的是**运行时 HUD 摆得对不对**，
## 这条量的是**规格与素材的到货情况** —— 两件事红的原因完全不同，混在一起会让「哪一步坏了」变模糊。

const MANIFEST_PATH := "res://assets/spec/art_manifest.json"

var _passed := 0
var _failed := 0


func _initialize() -> void:
	var require_batch1 := false
	for arg in OS.get_cmdline_user_args():
		if arg == "--require-batch1":
			require_batch1 = true

	var manifest: Dictionary = _load_manifest()
	if manifest.is_empty():
		_check_true("规格文件能读到且是 JSON 对象（%s）" % MANIFEST_PATH, false)
		_finish()
		return
	_check_true("规格文件能读到且是 JSON 对象", true)
	_check("schema = 1", int(manifest.get("schema", 0)), 1)

	var assets: Array = manifest.get("assets", [])
	var anims: Array = manifest.get("animations", [])
	var design: Dictionary = manifest.get("design_source", {})
	var rules: Dictionary = manifest.get("rules", {})
	var batch1: Array = manifest.get("batch1", [])
	_check_true("资产条目非空", not assets.is_empty())
	_check_true("动画条目非空", not anims.is_empty())

	# ── ① 结构性检查 ──────────────────────────────────────────────
	var ids := {}
	var ids_unique := true
	var ids_snake := true
	var paths_ok := true
	var paths_ascii := true
	var sizes_ok := true
	var batches_ok := true
	var rows := {}
	var batch1_without_size: Array = []
	for entry_v in assets:
		var a: Dictionary = entry_v
		var id: String = String(a.get("id", ""))
		if ids.has(id):
			ids_unique = false
		ids[id] = true
		if not _is_snake(id):
			ids_snake = false
		var path: String = String(a.get("path", ""))
		if not path.begins_with("res://assets/") or not path.ends_with(".png"):
			paths_ok = false
		if _has_cjk(path):
			paths_ascii = false
		var size = a.get("size", null)
		if size != null:
			var ok := size is Array and (size as Array).size() == 2 \
					and int(size[0]) > 0 and int(size[1]) > 0
			if not ok:
				sizes_ok = false
		var batch: int = int(a.get("batch", 0))
		if batch < 1 or batch > 3:
			batches_ok = false
		rows[int(a.get("design_row", 0))] = true
		if batch == 1 and size == null:
			batch1_without_size.append(id)

	_check_true("资产 ID 唯一（%d 条）" % assets.size(), ids_unique)
	_check_true("资产 ID 都是 snake_case", ids_snake)
	_check_true("路径都在 res://assets/ 下且是 .png", paths_ok)
	_check_true("路径不含中文（跨平台导出风险）", paths_ascii)
	_check_true("尺寸要么是正整数对、要么显式 null（unresolved）", sizes_ok)
	_check_true("batch 都在 1..3", batches_ok)
	var design_rows: int = int(design.get("assets_rows", 0))
	var covered := true
	for i in range(1, design_rows + 1):
		if not rows.has(i):
			covered = false
	_check_true("设计表 %d 行每一行都有对应的资产 ID（不漏行）" % design_rows, covered)
	_check_true("batch1 非空（第一批可开工）", not batch1.is_empty())
	_check_true("batch1 每一项都已经给出尺寸（美术才拿得到可执行任务）",
			batch1_without_size.is_empty())
	if not batch1_without_size.is_empty():
		print("      ↳ 缺尺寸的 batch1 条目：%s" % _join(batch1_without_size))
	var batch1_known := true
	for id_v in batch1:
		if not ids.has(String(id_v)):
			batch1_known = false
	_check_true("batch1 里的 ID 都能在资产表里找到", batch1_known)

	# 动画三态：frames = 0 表示设计表写「无帧」（Tween / 程序驱动，不产 PNG 序列）；
	# frames = 1 静态；frames ≥ 2 是多帧序列（必须有 %02d 模板，否则排序会错）。
	var anim_ok := true
	var anim_tmpl_ok := true
	var anim_zero_ok := true
	var zero_frames: Array = []
	for entry_v in anims:
		var an: Dictionary = entry_v
		var frames: int = int(an.get("frames", -1))
		if frames < 0 or not _is_snake(String(an.get("id", ""))):
			anim_ok = false
		if frames == 0:
			zero_frames.append(String(an.get("id", "")))
			if String(an.get("frames_design", "")).find("无帧") < 0:
				anim_zero_ok = false
		var tmpl: String = String(an.get("path_template", ""))
		if frames > 1 and not tmpl.contains("%02d"):
			anim_tmpl_ok = false
	_check_true("动画：帧数 >= 0 且 ID 是 snake_case", anim_ok)
	_check_true("动画：多帧动画的路径模板带 %02d（补零两位，排序不会错）", anim_tmpl_ok)
	_check_true("动画：frames = 0 的条目在设计表里确实写着「无帧」（不是漏填）", anim_zero_ok)
	if not zero_frames.is_empty():
		print("      ↳ 无帧动画（Tween / 程序驱动，不产 PNG）：%s" % _join(zero_frames))
	_check_true("规格里写清了命名规则", String(rules.get("naming", "")).length() > 0)
	_check_true("规格里写清了纹理过滤 = Nearest", String(rules.get("filter", "")).contains("Nearest"))

	# ── ② 入库盘点（只打印） ──────────────────────────────────────
	print("")
	print("---- 入库盘点（不算失败：资产是一张一张来的）----")
	var arrived := {}
	var missing_batch1: Array = []
	var arrived_count := 0
	for entry_v in assets:
		var a: Dictionary = entry_v
		var batch: int = int(a.get("batch", 0))
		if FileAccess.file_exists(String(a.get("path", ""))):
			arrived_count += 1
			arrived[batch] = int(arrived.get(batch, 0)) + 1
		elif batch == 1:
			missing_batch1.append(String(a.get("id", "")))
	print("  已入库 %d / %d 张" % [arrived_count, assets.size()])
	for b in [1, 2, 3]:
		var total := 0
		for entry_v in assets:
			if int((entry_v as Dictionary).get("batch", 0)) == b:
				total += 1
		print("  batch%d：已入库 %d / %d" % [b, int(arrived.get(b, 0)), total])
	if not missing_batch1.is_empty():
		print("  ⚠ 第一批还缺 %d 张：%s" % [missing_batch1.size(), _join(missing_batch1)])
	if require_batch1:
		_check("--require-batch1：第一批 %d 张已全部入库" % batch1.size(),
				missing_batch1.size(), 0)

	_finish()


func _load_manifest() -> Dictionary:
	if not FileAccess.file_exists(MANIFEST_PATH):
		push_error("[美术规格] 找不到 %s" % MANIFEST_PATH)
		return {}
	var file := FileAccess.open(MANIFEST_PATH, FileAccess.READ)
	if file == null:
		push_error("[美术规格] 打不开 %s" % MANIFEST_PATH)
		return {}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	file.close()
	if not (parsed is Dictionary):
		push_error("[美术规格] %s 不是 JSON 对象" % MANIFEST_PATH)
		return {}
	return parsed


## 全小写 + 下划线 + 数字，且以字母开头
func _is_snake(id: String) -> bool:
	if id.is_empty():
		return false
	var first := id.unicode_at(0)
	if first < 97 or first > 122:      # 'a'..'z'
		return false
	for i in id.length():
		var c := id.unicode_at(i)
		var lower_letter := c >= 97 and c <= 122
		var digit := c >= 48 and c <= 57
		if not (lower_letter or digit or c == 95):   # 95 = '_'
			return false
	return true


## 文件名里不许有中文（本工程跨平台导出的硬规矩，见 asset-pipeline 技能）
func _has_cjk(text: String) -> bool:
	for i in text.length():
		var c := text.unicode_at(i)
		if c >= 0x4E00 and c <= 0x9FFF:
			return true
		if c >= 0x3000 and c <= 0x303F:
			return true
		if c >= 0xFF00 and c <= 0xFFEF:
			return true
	return false


## Array[String] 拼成一行（Godot 的 String.join 只吃 PackedStringArray）
func _join(values: Array) -> String:
	var out := ""
	for v in values:
		if not out.is_empty():
			out += ", "
		out += String(v)
	return out


func _check(title: String, actual: Variant, expected: Variant) -> void:
	if actual == expected:
		_passed += 1
		print("[OK]   %s" % title)
	else:
		_failed += 1
		print("[FAIL] %s  期望=%s 实际=%s" % [title, str(expected), str(actual)])


func _check_true(title: String, condition: bool) -> void:
	_check(title, condition, true)


func _finish() -> void:
	print("")
	print("—— 通过 %d 项 / 失败 %d 项 ——" % [_passed, _failed])
	if _failed > 0:
		print("！！ 美术规格有 %d 项结构性问题 —— 修规格文件，不是修资产" % _failed)
	quit(1 if _failed > 0 else 0)
