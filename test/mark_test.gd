@tool
extends EditorScript

## 报点标记测试（docx 4.11.2 / 4.11.7）：落点、刷新不堆叠、时效递减、到期移除、类型表
## 运行：脚本编辑器打开本文件 → 文件 → 运行

var _passed := 0
var _failed := 0


func _run() -> void:
	_test_add_mark()
	_test_refresh_same_type()
	_test_expire()
	_test_type_table()
	_test_wheel_items_stay_on_screen()
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


func _test_add_mark() -> void:
	var marks := MarkSystem.new()
	var mark := marks.add_mark(MarkSystem.MarkType.ENEMY, Vector2(100.0, 200.0))
	_check("落点：标记数量 1", marks.marks.size(), 1)
	_check("落点：位置正确", mark["position"], Vector2(100.0, 200.0))
	_check("落点：类型正确", mark["type"], MarkSystem.MarkType.ENEMY)
	_check("落点：时效 = 普通报点 30 s", mark["time_left"], GameConfig.MARK_DURATION)
	marks.free()


## 再次报点＝刷新（docx 4.11.2），不堆叠
func _test_refresh_same_type() -> void:
	var marks := MarkSystem.new()
	marks.add_mark(MarkSystem.MarkType.ENEMY, Vector2(100.0, 100.0))
	marks.add_mark(MarkSystem.MarkType.ENEMY, Vector2(102.0, 100.0))
	_check("刷新：同类型 5 m 内不新增", marks.marks.size(), 1)
	marks.add_mark(MarkSystem.MarkType.ENEMY, Vector2(130.0, 100.0))
	_check("刷新：同类型 30 m 外算新标记", marks.marks.size(), 2)
	marks.add_mark(MarkSystem.MarkType.SUPPLY, Vector2(130.0, 100.0))
	_check("刷新：不同类型算新标记", marks.marks.size(), 3)
	marks.free()


func _test_expire() -> void:
	var marks := MarkSystem.new()
	marks.add_mark(MarkSystem.MarkType.SMOKE, Vector2.ZERO, 2.0)
	marks._process(1.0)
	_check("时效：1 s 后仍在", marks.marks.size(), 1)
	marks._process(1.5)
	_check("时效：超时后移除", marks.marks.size(), 0)
	marks.free()


func _test_type_table() -> void:
	_check("类型表：6 类标记（敌人/载具/阵地/补给/烟雾/集结点）",
			MarkSystem.TYPE_LABELS.size(), 6)
	_check("类型表：敌人＝红系", MarkSystem.type_color(MarkSystem.MarkType.ENEMY),
			Color(0.95, 0.30, 0.25))
	_check("类型表：越界返回「未知」", MarkSystem.type_label(99), "未知")


## 回归：报点键贴着屏幕右侧，环形菜单若整圈展开会把右侧按钮推出屏幕（2026-09-28 实测踩到）
func _test_wheel_items_stay_on_screen() -> void:
	var button_pos := Vector2(GameConfig.VIEWPORT_WIDTH - GameConfig.MARK_BUTTON_SIZE,
			GameConfig.VIEWPORT_HEIGHT - 160.0 - GameConfig.MARK_BUTTON_SIZE * 1.6)
	var center := button_pos + Vector2(GameConfig.MARK_BUTTON_SIZE,
			GameConfig.MARK_BUTTON_SIZE) * 0.5
	var count := MarkSystem.TYPE_LABELS.size()
	var all_inside := true
	var all_on_left := true
	for i in count:
		var offset := MarkWheel.item_offset(i, count)
		if offset.x > 0.0:
			all_on_left = false
		var item_center := center + offset
		var rect := Rect2(item_center - Vector2(GameConfig.MARK_ITEM_WIDTH,
				GameConfig.MARK_ITEM_HEIGHT) * 0.5,
				Vector2(GameConfig.MARK_ITEM_WIDTH, GameConfig.MARK_ITEM_HEIGHT))
		if rect.position.x < 0.0 or rect.position.y < 0.0 \
				or rect.end.x > GameConfig.VIEWPORT_WIDTH \
				or rect.end.y > GameConfig.VIEWPORT_HEIGHT:
			all_inside = false
	_check_true("轮盘：6 个菜单项全部落在屏幕内", all_inside)
	_check_true("轮盘：菜单只向左半圈展开（不越右边缘）", all_on_left)
