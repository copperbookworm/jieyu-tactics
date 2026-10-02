@tool
extends EditorScript

## 启动自检测试（2026-10-01）：三张数据表都在、文案生成正确。
## 运行：脚本编辑器打开本文件 → 文件 → 运行
## 说明：这条**测不出「导出包里没打进去」**——那要靠 tools/probe_export_pack.gd 在真 PCK 里验。
## 这里钉的是「自检本身别写错」：路径常量对得上、缺失时文案非空且带路径、齐全时返回空。

const BootCheckScript := preload("res://scenes/gameplay/BootCheck.gd")
const WeaponTableScript := preload("res://systems/weapons/WeaponTable.gd")
const VehicleTableScript := preload("res://systems/vehicles/VehicleTable.gd")
const QuestTableScript := preload("res://systems/quest/QuestTable.gd")

var _passed := 0
var _failed := 0


func _run() -> void:
	_test_tables_present()
	_test_messages()
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


func _check_true(title: String, condition: bool) -> void:
	_check(title, condition, true)


## 开发机上三张表都该在（不在 ⇒ 项目目录被搬坏了，或 path 常量写错了）
func _test_tables_present() -> void:
	_check("自检：开发机上三张数据表都在（缺一张就会报出来）",
			BootCheckScript.missing_tables().size(), 0)
	_check_true("自检：武器表路径常量指向 data/*.txt",
			WeaponTableScript.CSV_PATH.begins_with("res://data/")
			and WeaponTableScript.CSV_PATH.ends_with(".txt"))
	_check_true("自检：载具表路径常量指向 data/*.txt",
			VehicleTableScript.CSV_PATH.begins_with("res://data/")
			and VehicleTableScript.CSV_PATH.ends_with(".txt"))
	_check_true("自检：任务表路径常量指向 data/*.txt",
			QuestTableScript.CSV_PATH.begins_with("res://data/")
			and QuestTableScript.CSV_PATH.ends_with(".txt"))


func _test_messages() -> void:
	_check("文案：没有缺失时提示为空串", BootCheckScript.missing_hint([]), "")
	_check("文案：没有缺失时日志为空串", BootCheckScript.missing_error([]), "")
	var fake: Array = ["res://data/vehicles_data.txt"]
	_check_true("文案：缺失时提示里带路径与修法",
			BootCheckScript.missing_hint(fake).contains("vehicles_data.txt")
			and BootCheckScript.missing_hint(fake).contains("include_filter"))
	_check_true("文案：缺失时日志里说清后果",
			BootCheckScript.missing_error(fake).contains("0/0"))
	_check_true("文案：多条缺失用顿号连起来",
			BootCheckScript.missing_hint(["a.txt", "b.txt"]).contains("a.txt、b.txt"))
