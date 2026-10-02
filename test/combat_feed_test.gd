@tool
extends EditorScript

## 对局内战斗播报（docx 4.14，候选 O 第一轮）
## 运行：脚本编辑器打开本文件 → 文件 → 运行；或 godot --headless --script res://tools/run_tests_headless.gd
## 这里只测纯逻辑（合并 / 限频 / 时效 / 行数上限）——它不依赖场景与 autoload，
## 所以 --script 模式下也能直接跑。真实装配（HUD 上出现哪几行）跑在集成冒烟里。

const CombatFeedScript := preload("res://systems/hud/CombatFeed.gd")

var _passed := 0
var _failed := 0


func _run() -> void:
	_test_params()
	_test_push_and_lines()
	_test_merge_same_kind()
	_test_no_merge_after_window()
	_test_expire()
	_test_limits()
	_test_bbcode()
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


func _new_feed():
	return CombatFeedScript.new()


## 4.14 数值都从 GameConfig 出（唯一数值出口）
func _test_params() -> void:
	_check_true("4.14：合并窗口是正数", GameConfig.FEED_MERGE_WINDOW > 0.0)
	_check_true("4.14：播报停留是正数", GameConfig.FEED_TTL > 0.0)
	_check_true("4.14：显示行数上限 ≥ 1", GameConfig.FEED_MAX_LINES >= 1)
	_check_true("4.14：逻辑上限 ≥ 显示上限",
			GameConfig.FEED_MAX_ENTRIES >= GameConfig.FEED_MAX_LINES)


func _test_push_and_lines() -> void:
	var feed = _new_feed()
	_check_true("新播报：一开始是空的", feed.is_empty())
	feed.push("kill", "击倒敌人", Color.GREEN)
	_check("一条播报：逻辑 1 条", feed.size(), 1)
	_check("一条播报：显示 1 行", feed.lines().size(), 1)
	_check("一条播报：文案原样", feed.lines()[0]["text"], "击倒敌人")


## 4.14「同类事件合并」：窗口内再来同类事件不新增行，只把计数 +1
func _test_merge_same_kind() -> void:
	var feed = _new_feed()
	feed.push("kill", "击倒敌人", Color.GREEN)
	feed.push("kill", "击倒敌人", Color.GREEN)
	feed.push("kill", "击倒敌人", Color.GREEN)
	_check("合并：三条合成一条", feed.size(), 1)
	_check("合并：文案带 ×3", feed.lines()[0]["text"], "击倒敌人 ×3")


## 超过合并窗口就是新的一条（限频不变成吞事件）
func _test_no_merge_after_window() -> void:
	var feed = _new_feed()
	feed.push("kill", "击倒敌人", Color.GREEN)
	feed.tick(GameConfig.FEED_MERGE_WINDOW + 0.5)
	feed.push("kill", "击倒敌人", Color.GREEN)
	_check("超窗口：两条并存", feed.size(), 2)
	_check("超窗口：各自计数为 1", feed.lines()[0]["text"], "击倒敌人")


func _test_expire() -> void:
	var feed = _new_feed()
	feed.push("kill", "击倒敌人", Color.GREEN)
	feed.tick(GameConfig.FEED_TTL - 0.1)
	_check("时效未到：还在", feed.size(), 1)
	feed.tick(0.2)
	_check("时效到点：丢掉", feed.size(), 0)
	_check("时效到点：没有行", feed.lines().size(), 0)
	_check_true("时效到点：is_empty 为真", feed.is_empty())


## 限频的两种上限：显示行数（4 行）与逻辑条数（12 条）
func _test_limits() -> void:
	var feed = _new_feed()
	for i in range(6):
		feed.push("kind_%d" % i, "事件 %d" % i, Color.WHITE)
	_check("显示上限：最多 %d 行" % GameConfig.FEED_MAX_LINES,
			feed.lines().size(), GameConfig.FEED_MAX_LINES)
	_check("新的在上：第一行是最新的", feed.lines()[0]["text"], "事件 5")
	for i in range(20):
		feed.push("more_%d" % i, "事件 %d" % i, Color.WHITE)
	_check("逻辑上限：最多 %d 条" % GameConfig.FEED_MAX_ENTRIES,
			feed.size(), GameConfig.FEED_MAX_ENTRIES)
	feed.clear()
	_check("清空后没有播报", feed.size(), 0)


func _test_bbcode() -> void:
	var feed = _new_feed()
	feed.push("kill", "击倒敌人", Color(1.0, 0.0, 0.0))
	var bb: String = feed.to_bbcode()
	_check_true("BBCode：带颜色标签", bb.contains("[color=#"))
	_check_true("BBCode：带文案", bb.contains("击倒敌人"))
	_check_true("BBCode：红色十六进制是 ff0000", bb.contains("ff0000"))
