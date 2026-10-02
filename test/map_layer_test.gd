@tool
extends EditorScript

## 地图世界图层数据源测试（2026-10-01 ④：FOB · 补给车 · 侧翼通路补进小地图与战术地图）
## 运行：脚本编辑器打开本文件 → 文件 → 运行
## 说明：小地图 / 战术地图的 _draw() 只在 visible 时跑，纯逻辑测试碰不到；
## 所以这里测的是两张图共用的那份取数与几何（ui/MapLayerSource.gd）——
## 「画得对不对」由集成冒烟负责（那边会把战术地图真开一阶段，让 _draw 真的跑起来）。

const MapLayerSourceScript := preload("res://ui/MapLayerSource.gd")
const LaneScript := preload("res://entities/lane/Lane.gd")
const SupplyScript := preload("res://entities/supply/Supply.gd")
const FobScript := preload("res://entities/fob/Fob.gd")

var _passed := 0
var _failed := 0


func _run() -> void:
	_test_lane_edges_axis()
	_test_lane_edges_vertical_and_degenerate()
	_test_lane_lookup()
	_test_convoy_lookup()
	_test_fob_visibility()
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


## 东西走向的通路：入口 (0,0) → 出口 (100,0)，半宽 25 ⇒ 四角 y = ±25
func _test_lane_edges_axis() -> void:
	var corners := MapLayerSourceScript.lane_edges(Vector2.ZERO, Vector2(100.0, 0.0),
			GameConfig.LANE_HALF_WIDTH)
	_check("通路四角：返回 4 个角", corners.size(), 4)
	if corners.size() != 4:
		return
	_check("通路四角：左入 = 入口 + 半宽法线", corners[0], Vector2(0.0, GameConfig.LANE_HALF_WIDTH))
	_check("通路四角：右入 = 入口 − 半宽法线", corners[1], Vector2(0.0, -GameConfig.LANE_HALF_WIDTH))
	_check("通路四角：左出", corners[2], Vector2(100.0, GameConfig.LANE_HALF_WIDTH))
	_check("通路四角：右出", corners[3], Vector2(100.0, -GameConfig.LANE_HALF_WIDTH))
	# 两条长边必须与中线平行且等长（画出来才是个走廊，不是梯形）
	_check("通路两长边等长（走廊不是梯形）",
			(corners[2] as Vector2).distance_to(corners[0]),
			(corners[3] as Vector2).distance_to(corners[1]))
	_check("通路宽度 = 2 × 半宽",
			(corners[0] as Vector2).distance_to(corners[1]),
			GameConfig.LANE_HALF_WIDTH * 2.0)


## 南北走向（法线方向要转 90°）＋ 退化情形（入口＝出口 ⇒ 空数组，别画出零点）
func _test_lane_edges_vertical_and_degenerate() -> void:
	var corners := MapLayerSourceScript.lane_edges(Vector2.ZERO, Vector2(0.0, 100.0), 10.0)
	_check("南北通路：左入 = (−10, 0)", corners[0], Vector2(-10.0, 0.0))
	_check("南北通路：右入 = (10, 0)", corners[1], Vector2(10.0, 0.0))
	_check("南北通路：左出 = (−10, 100)", corners[2], Vector2(-10.0, 100.0))
	_check("南北通路：右出 = (10, 100)", corners[3], Vector2(10.0, 100.0))
	_check("退化通路（入口＝出口）：不返回角点",
			MapLayerSourceScript.lane_edges(Vector2(5.0, 5.0), Vector2(5.0, 5.0), 25.0), [])


## 取数：通路从 main.lane_ctl.lane 拿（无 Main 类可用时用字典冒充，鸭子类型的口径就靠它钉住）
func _test_lane_lookup() -> void:
	var lane = LaneScript.new()
	lane.entry_position = Vector2(10.0, 10.0)
	lane.exit_position = Vector2(90.0, 10.0)
	var fake := {"lane_ctl": {"lane": lane}, "supply_ctl": {"convoy": null}}
	_check("取通路：从 main.lane_ctl.lane 取到", MapLayerSourceScript.lane(fake), lane)
	_check("取通路：main 为 null ⇒ null", MapLayerSourceScript.lane(null), null)
	_check("取通路：控制器在但还没建通路 ⇒ null",
			MapLayerSourceScript.lane({"lane_ctl": {"lane": null}}), null)
	_check("取通路：连控制器都没有 ⇒ null",
			MapLayerSourceScript.lane({"lane_ctl": null}), null)
	lane.free()


func _test_convoy_lookup() -> void:
	var convoy = SupplyScript.new()
	convoy.target_position = Vector2(300.0, 300.0)
	var fake := {"lane_ctl": {"lane": null}, "supply_ctl": {"convoy": convoy}}
	_check("取补给车：从 main.supply_ctl.convoy 取到",
			MapLayerSourceScript.convoy(fake), convoy)
	_check("取补给车：还没派车 ⇒ null",
			MapLayerSourceScript.convoy({"supply_ctl": {"convoy": null}}), null)
	_check("取补给车：main 为 null ⇒ null", MapLayerSourceScript.convoy(null), null)
	convoy.free()


## 4.11.2 红线：敌方 FOB 默认不上地图；被报点暴露（mark_revealed）或已被打掉之后才上
func _test_fob_visibility() -> void:
	var fob = FobScript.new()
	_check("FOB：初始未暴露", fob.is_known_to_player(), false)
	_check("FOB：未暴露时不在图层里",
			MapLayerSourceScript.known_fobs([fob]).size(), 0)
	fob.mark_revealed()
	_check("FOB：暴露后 is_known_to_player 为真", fob.is_known_to_player(), true)
	_check("FOB：暴露后进图层", MapLayerSourceScript.known_fobs([fob]).size(), 1)
	# 幂等：重复暴露不改变什么（QuestSystem 每次重算都会调一次）
	fob.mark_revealed()
	_check("FOB：重复暴露仍然只算一个", MapLayerSourceScript.known_fobs([fob]).size(), 1)
	fob.free()

	# 另一路：没被报点过但已经被打掉的工事，玩家当然知道它在哪
	var wrecked = FobScript.new()
	wrecked.take_damage(GameConfig.FOB_MAX_HP + 1.0)
	_check("FOB：没报点但已摧毁 ⇒ 仍然上图层（自己打掉的知道在哪）",
			MapLayerSourceScript.known_fobs([wrecked]).size(), 1)
	wrecked.free()

	# 脏输入不许把图层搞崩：null / 已释放对象直接跳过
	var junk: Array = [null, fob]
	_check("FOB：图层过滤吃掉 null（已释放对象也不炸）",
			MapLayerSourceScript.known_fobs(junk).size(), 0)
