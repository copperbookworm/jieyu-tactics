@tool
extends EditorScript

## 快捷指令（docx 4.13，候选 O 第二轮）：目录 / 落点映射 / 冷却 / 轮盘几何
## 运行：脚本编辑器打开本文件 → 文件 → 运行；或 godot --headless --script res://tools/run_tests_headless.gd
## 这里只测纯逻辑与几何（不建 UI 节点）——真实装配（按键 → 落标记 → 播报）跑在集成冒烟里。

const CommandBookScript := preload("res://systems/comm/CommandBook.gd")

var _passed := 0
var _failed := 0


func _run() -> void:
	_test_catalogue()
	_test_mark_mapping()
	_test_cooldown()
	_test_global_cooldown()
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


func _new_book():
	return CommandBookScript.new()


## 4.13 举例的 6 条预设短语要在目录里，且 id 唯一
func _test_catalogue() -> void:
	_check("目录：6 条指令", CommandBookScript.count(), 6)
	var ids := {}
	for i in CommandBookScript.count():
		ids[String(CommandBookScript.command(i)["id"])] = true
	_check("目录：id 互不重复", ids.size(), 6)
	var labels := ""
	for i in CommandBookScript.count():
		labels += String(CommandBookScript.command(i)["label"]) + "／"
	for want in ["跟我来", "需要支援", "发现敌人", "掩护我", "撤退", "集结点"]:
		_check_true("目录：含「%s」" % want, labels.contains(want))
	_check("目录：越界返回空字典", CommandBookScript.command(99), {})
	_check("目录：未知 id 的文案为空", CommandBookScript.label_of("nope"), "")


## 落点映射：只有「发现敌人」「集结点」落标记，其余口头指令不落点
func _test_mark_mapping() -> void:
	# 交叉断言：CommandBook 里的常量必须与 MarkSystem.MarkType 对得上（防枚举漂移）
	_check("映射：MARK_ENEMY ＝ MarkSystem.MarkType.ENEMY",
			CommandBookScript.MARK_ENEMY, MarkSystem.MarkType.ENEMY)
	_check("映射：MARK_RALLY ＝ MarkSystem.MarkType.RALLY",
			CommandBookScript.MARK_RALLY, MarkSystem.MarkType.RALLY)
	_check("映射：发现敌人 → 敌人标记",
			CommandBookScript.mark_type_of("enemy"), MarkSystem.MarkType.ENEMY)
	_check("映射：集结点 → 集结点标记",
			CommandBookScript.mark_type_of("rally"), MarkSystem.MarkType.RALLY)
	_check("映射：跟我来不落点", CommandBookScript.mark_type_of("follow"),
			CommandBookScript.MARK_NONE)
	_check("映射：撤退不落点", CommandBookScript.mark_type_of("retreat"),
			CommandBookScript.MARK_NONE)
	_check("映射：未知 id 不落点", CommandBookScript.mark_type_of("nope"),
			CommandBookScript.MARK_NONE)


func _test_cooldown() -> void:
	var book = _new_book()
	_check_true("冷却：首次可以发", book.ready("follow"))
	_check_true("冷却：发送成功", book.send("follow"))
	_check("冷却：单条冷却记上了", book.remaining("follow"), GameConfig.COMMAND_COOLDOWN)
	_check("冷却：冷却中 ready 为假", book.ready("follow"), false)
	_check("冷却：冷却中再发被拒", book.send("follow"), false)
	book.tick(GameConfig.COMMAND_COOLDOWN - 0.1)
	_check("冷却：差一点还不能发", book.send("follow"), false)
	book.tick(0.2)
	_check_true("冷却：到点后可以再发", book.send("follow"))
	book.clear()
	_check("clear：冷却清零", book.remaining("follow"), 0.0)


## 4.14 那条「限频」精神同样适用：任意两条指令之间还有一层公共冷却，防连点刷屏
func _test_global_cooldown() -> void:
	var book = _new_book()
	_check_true("全局冷却：A 发得出去", book.send("follow"))
	_check("全局冷却：B 的自身冷却还没开始", book.remaining("support"), 0.0)
	_check("全局冷却：公共冷却期内 B 被拒", book.send("support"), false)
	book.tick(GameConfig.COMMAND_GLOBAL_COOLDOWN)
	_check_true("全局冷却：公共冷却过后 B 可以发", book.send("support"))


## 回归：指令键在左侧第三列（x=192），菜单必须**向右**半圈展开 —— 向左会盖住中间那列按钮
## （使用者 2026-10-02 真机反馈），整圈展开又会被挤出屏幕，所以走右半圈 + clamp。
func _test_wheel_items_stay_on_screen() -> void:
	var button_pos := Vector2(GameConfig.COMMAND_BUTTON_X, GameConfig.COMMAND_BUTTON_Y)
	var size := Vector2(GameConfig.COMMAND_BUTTON_WIDTH, GameConfig.COMMAND_BUTTON_HEIGHT)
	var center := button_pos + size * 0.5
	var count := CommandBookScript.count()
	var all_inside := true
	var all_to_right := true
	var clear_of_middle_column := true
	for i in count:
		var offset := MarkWheel.item_offset(i, count)
		offset.x = absf(offset.x)          # 与 CommandWheel 的镜像保持一致
		if offset.x < 0.0:
			all_to_right = false
		var item_center := center + offset
		var rect := Rect2(item_center - Vector2(GameConfig.MARK_ITEM_WIDTH,
				GameConfig.MARK_ITEM_HEIGHT) * 0.5,
				Vector2(GameConfig.MARK_ITEM_WIDTH, GameConfig.MARK_ITEM_HEIGHT))
		if rect.position.x < 0.0 or rect.position.y < 0.0 \
				or rect.end.x > GameConfig.VIEWPORT_WIDTH \
				or rect.end.y > GameConfig.VIEWPORT_HEIGHT:
			all_inside = false
	_check_true("轮盘：6 个菜单项全部落在屏幕内", all_inside)
	# 菜单左缘不得压到中间那列按钮（指令键在 x=192，往左就是中间列）
	for i in count:
		var off := MarkWheel.item_offset(i, count)
		off.x = absf(off.x)
		var item_center := center + off
		# 中间那列的右缘 = 104 + 80 = 184 = 指令键 x − 8（指令键在 x=192）
		if item_center.x - GameConfig.MARK_ITEM_WIDTH * 0.5 < GameConfig.COMMAND_BUTTON_X - 8.0:
			clear_of_middle_column = false
	_check_true("轮盘：菜单向右展开（不再压住中间那列按钮）", clear_of_middle_column)
