@tool
extends EditorScript

## 对局操作提示者（docx 4.15，候选 O 第一轮）
## 规则纯逻辑：一次性 / 限频 / 待弹位 / 总开关。感知与渲染在 ui/TipPanel.gd，跑集成冒烟。

const TipBookScript := preload("res://systems/hud/TipBook.gd")

var _passed := 0
var _failed := 0


func _run() -> void:
	_test_catalogue()
	_test_once_only()
	_test_unknown_id()
	_one_at_a_time()
	_test_disabled()
	_test_ttl()
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
	return TipBookScript.new()


## 4.15 举例的四条要有对应条目（「集结点已放置」等集结点系统落地后补）
func _test_catalogue() -> void:
	var book = _new_book()
	var tips: Dictionary = book.TIPS
	_check_true("4.15：准星被地形遮挡有提示", tips.has("terrain_block"))
	_check_true("4.15：进入烟雾区有提示", tips.has("smoke_enter"))
	_check_true("4.15：任务已更新有提示", tips.has("quest_updated"))
	_check_true("4.15：文案里写明「按 M 查看」",
			String(tips["quest_updated"]).contains("M"))
	_check_true("4.15：默认开着", GameConfig.TIP_DEFAULT_ENABLED)
	_check_true("4.15：提示条数 ≥ 5", tips.size() >= 5)


func _test_once_only() -> void:
	var book = _new_book()
	_check_true("首见：会弹", book.request("quest_updated"))
	_check("首见：文案来自目录", book.current_text(), book.TIPS["quest_updated"])
	_check("首见：只显示一条（待弹位空）", book.pending(), false)
	# 当场再请求同一条：不再弹（4.15「看过的不再弹」）
	_check("再见：不再弹", book.request("quest_updated"), false)
	_check("再见：seen 里记着", book.seen("quest_updated"), true)
	_check("再见：计数仍是 1", book.seen_count(), 1)


func _test_unknown_id() -> void:
	var book = _new_book()
	_check("未注册 id：不弹", book.request("no_such_tip"), false)
	_check("未注册 id：不记 seen", book.seen_count(), 0)


## 一次只显示一条：第二条进待弹位，且要等「本条结束 + 最小间隔」
func _one_at_a_time() -> void:
	var book = _new_book()
	_check_true("A 先弹：返回 true", book.request("terrain_block"))
	_check("B 请求时 A 还在：返回 false", book.request("smoke_enter"), false)
	_check("B 进了待弹位", book.pending(), true)
	_check("此刻显示的仍是 A", book.current_text(), book.TIPS["terrain_block"])
	book.tick(GameConfig.TIP_TTL)
	_check("A 到点后不再显示", book.is_showing(), false)
	_check("最小间隔内 B 不显示", book.is_showing(), false)
	book.tick(GameConfig.TIP_MIN_INTERVAL)
	_check("间隔过后 B 弹出来", book.current_text(), book.TIPS["smoke_enter"])


func _test_disabled() -> void:
	var book = _new_book()
	book.set_enabled(false)
	_check("关掉后不弹", book.request("low_hp"), false)
	_check("关掉后不记 seen（重开还有机会）", book.seen("low_hp"), false)
	book.set_enabled(true)
	_check_true("再打开又能弹", book.request("low_hp"))


func _test_ttl() -> void:
	var book = _new_book()
	book.request("suppressed")
	book.tick(GameConfig.TIP_TTL - 0.1)
	_check_true("时效未到：还在显示", book.is_showing())
	book.tick(0.2)
	_check("时效到点：收起来", book.is_showing(), false)
	_check("收起后文案为空", book.current_text(), "")
