@tool
extends EditorScript

## 美术取用层自测（2026-10-07 第九十四版）。
##
## 钉住的是一条**容易悄悄腐烂**的约定：`systems/art/ArtAssets.gd` 里的 PATHS 必须与
## `assets/spec/art_manifest.json` 的 path 字段一致。两边都是手写的，迟早会有人只改一边 ——
## 那时入库盘点（check_art_manifest）会绿，而工程读的是另一个路径（文件在、没人用）。

const ArtAssetsScript := preload("res://systems/art/ArtAssets.gd")
const MarkSystemScript := preload("res://systems/marks/MarkSystem.gd")
## 标记 id 表住在 MarkOverlay 里（与类型枚举同序）—— 这里只读它的常量，不实例化节点
const MarkOverlayIdsScript := preload("res://ui/MarkOverlay.gd")
const MANIFEST := "res://assets/spec/art_manifest.json"

var _passed := 0
var _failed := 0


func _run() -> void:
	_test_paths_match_manifest()
	_test_batch1_present()
	_test_texture_loads()
	_test_mark_ids()
	_test_unresolved_returns_null()
	_test_crosshair_convention()
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


func _manifest() -> Dictionary:
	var text := FileAccess.get_file_as_string(MANIFEST)
	var parsed: Variant = JSON.parse_string(text)
	return parsed if typeof(parsed) == TYPE_DICTIONARY else {}


func _test_paths_match_manifest() -> void:
	var m := _manifest()
	_check("能读到美术清单", m.has("assets"), true)
	var by_id := {}
	for a in m.get("assets", []):
		by_id[String((a as Dictionary)["id"])] = String((a as Dictionary)["path"])
	var mismatched: Array = []
	for id in ArtAssetsScript.PATHS.keys():
		var want := String(by_id.get(id, "<清单里没有>"))
		if want != String(ArtAssetsScript.PATHS[id]):
			mismatched.append("%s(清单=%s 工程=%s)" % [id, want, ArtAssetsScript.PATHS[id]])
	_check("ArtAssets.PATHS 与美术清单逐条一致", mismatched, [])


func _test_batch1_present() -> void:
	var missing: Array = []
	for id in ArtAssetsScript.PATHS.keys():
		if not ArtAssetsScript.has(String(id)):
			missing.append(String(id))
	_check("取用表里的每张图都在磁盘上（入库后才为真）", missing, [])


func _test_texture_loads() -> void:
	ArtAssetsScript.clear_cache()
	var bad: Array = []
	for id in ArtAssetsScript.PATHS.keys():
		if ArtAssetsScript.texture(String(id)) == null:
			bad.append(String(id))
	_check("每张图都能 load 成 Texture2D", bad, [])


func _test_mark_ids() -> void:
	var ids: Array = MarkOverlayIdsScript.MARK_ICON_IDS
	_check("标记图标数量 = MarkType 数量（顺序一一对应）", ids.size(),
			MarkSystemScript.MarkType.size())
	var missing: Array = []
	for id in ids:
		if not ArtAssetsScript.PATHS.has(String(id)):
			missing.append(String(id))
	_check("每个标记图标 id 都在取用表里", missing, [])


## 准星的**旋转约定**（2026-10-07 第九十五版）。
## 为什么值得写成断言：Sprite2D 以纹理中心为旋转轴，而本作的准星是「箭尖＝屏心」的箭头 ——
## 箭尖若不在纹理中心，枪口指向会整体偏一段（2026-09-28 真机踩过「箭身画反」）。
## 美术照着自己的直觉画一张四向十字，形状好看但**不满足这个约定** —— 这条断言会在入库时直接拦下来。
func _test_crosshair_convention() -> void:
	var tex := ArtAssetsScript.texture("ui_crosshair")
	if tex == null:
		_check("准星图已入库", false, true)
		return
	var img := tex.get_image()
	_check("准星画布边长 = CROSSHAIR_ARROW_SIZE", img.get_width(),
			GameConfig.CROSSHAIR_ARROW_SIZE)
	_check("准星画布是正方形", img.get_height(), img.get_width())
	var center := GameConfig.CROSSHAIR_ARROW_SIZE / 2
	var min_x := 99999
	var max_x := -1
	for x in img.get_width():
		for y in img.get_height():
			if img.get_pixel(x, y).a > 0.0:
				min_x = mini(min_x, x)
				max_x = maxi(max_x, x)
	_check("箭尖在纹理中心（不透明像素的最右列 = 中心）", max_x, center)
	_check("箭身朝 -x 且长度 = CROSSHAIR_ARROW_LENGTH", center - min_x,
			GameConfig.CROSSHAIR_ARROW_LENGTH)


func _test_unresolved_returns_null() -> void:
	_check("不存在的 id 返回空路径", ArtAssetsScript.path_of("no_such_asset"), "")
	_check("不存在的 id has() = false", ArtAssetsScript.has("no_such_asset"), false)
	_check("不存在的 id 取纹理 = null", ArtAssetsScript.texture("no_such_asset"), null)