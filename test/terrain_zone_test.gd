@tool
extends EditorScript

## 环境互动区（docx 4.17，候选 O 第四轮）：区域几何 / 移速倍率 / 草丛隐蔽 / 掩体暴露 / demo 摆位安全距离
## 运行：脚本编辑器打开本文件 → 文件 → 运行；或 godot --headless --script res://tools/run_tests_headless.gd

const TerrainZoneScript := preload("res://entities/zone/TerrainZone.gd")
const TerrainZonesScript := preload("res://systems/terrain/TerrainZones.gd")

var _passed := 0
var _failed := 0

## 用来验「隐蔽度封顶」的假区域（比草丛更强）
class StrongGrass:
	func covers(_point: Vector2) -> bool:
		return true
	func concealment(_prone: bool) -> float:
		return 0.95
	func speed_scale() -> float:
		return 1.0


func _run() -> void:
	_test_params()
	_test_zone_basics()
	_test_speed_query()
	_test_conceal_query()
	_test_conceal_cap()
	_test_player_terrain()
	_test_player_exposure()
	_test_enemy_detection()
	_test_demo_layout()
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


func _zone(kind: int, pos: Vector2, radius: float = 20.0):
	var zone = TerrainZoneScript.new()
	zone.setup(kind, radius)
	zone.global_position = pos
	return zone


## 4.17 的数值出口
func _test_params() -> void:
	_check("4.17：泥泞移速 ×0.70", GameConfig.TERRAIN_MUD_SPEED_SCALE, 0.70)
	_check("4.17：雪地移速 ×0.55", GameConfig.TERRAIN_SNOW_SPEED_SCALE, 0.55)
	_check("4.17：草丛隐蔽 0.35", GameConfig.TERRAIN_GRASS_CONCEAL, 0.35)
	_check("4.17：卧姿额外隐蔽 0.20", GameConfig.TERRAIN_GRASS_PRONE_BONUS, 0.20)
	_check("4.17：隐蔽上限 0.60（隐蔽不是隐身）", GameConfig.TERRAIN_CONCEAL_MAX, 0.60)
	_check("4.17：贴掩体判定距离 1.5 m", GameConfig.COVER_HUG_RANGE, 1.5)
	_check("4.17：缩在掩体后暴露 ×0.5", GameConfig.COVER_HUG_EXPOSURE, 0.5)


func _test_zone_basics() -> void:
	var grass = _zone(TerrainZoneScript.Kind.GRASS, Vector2(100.0, 100.0), 30.0)
	_check("区域：草从标签", grass.kind_label(), "草丛")
	_check_true("区域：圆心在内", grass.covers(Vector2(100.0, 100.0)))
	_check_true("区域：半径内（29 m）在内", grass.covers(Vector2(129.0, 100.0)))
	_check_true("区域：半径外（31 m）不在", not grass.covers(Vector2(131.0, 100.0)))
	_check("区域：草丛不减速", grass.speed_scale(), 1.0)
	_check("区域：草丛隐蔽 0.35", grass.concealment(false), 0.35)
	_check("区域：草丛卧姿 0.55", grass.concealment(true), 0.55)

	var mud = _zone(TerrainZoneScript.Kind.MUD, Vector2.ZERO)
	_check("区域：泥泞标签", mud.kind_label(), "泥泞")
	_check("区域：泥泞移速 0.70", mud.speed_scale(), 0.70)
	_check("区域：泥泞不给隐蔽", mud.concealment(false), 0.0)

	var snow = _zone(TerrainZoneScript.Kind.SNOW, Vector2.ZERO)
	_check("区域：雪地移速 0.55", snow.speed_scale(), 0.55)
	_check("区域：雪地不给隐蔽", snow.concealment(true), 0.0)
	grass.free(); mud.free(); snow.free()


func _test_speed_query() -> void:
	var mud = _zone(TerrainZoneScript.Kind.MUD, Vector2.ZERO, 40.0)
	var snow = _zone(TerrainZoneScript.Kind.SNOW, Vector2(50.0, 0.0), 40.0)
	var zones := [mud, snow]
	_check("查询：空数组 → 1.0", TerrainZonesScript.speed_scale_at([], Vector2.ZERO), 1.0)
	_check("查询：只在泥地内 → 0.70",
			TerrainZonesScript.speed_scale_at(zones, Vector2.ZERO), 0.70)
	_check("查询：只在雪地内 → 0.55",
			TerrainZonesScript.speed_scale_at(zones, Vector2(50.0, 0.0)), 0.55)
	_check("查询：两片重叠处取最慢（0.55）",
			TerrainZonesScript.speed_scale_at(zones, Vector2(30.0, 0.0)), 0.55)
	_check("查询：区域外 → 1.0",
			TerrainZonesScript.speed_scale_at(zones, Vector2(500.0, 500.0)), 1.0)
	mud.free(); snow.free()


func _test_conceal_query() -> void:
	var grass = _zone(TerrainZoneScript.Kind.GRASS, Vector2.ZERO, 40.0)
	var mud = _zone(TerrainZoneScript.Kind.MUD, Vector2.ZERO, 40.0)
	_check("隐蔽：草丛内 0.35",
			TerrainZonesScript.concealment_at([grass], Vector2.ZERO, false), 0.35)
	_check("隐蔽：草丛内卧姿 0.55",
			TerrainZonesScript.concealment_at([grass], Vector2.ZERO, true), 0.55)
	_check("隐蔽：泥地里 0.0",
			TerrainZonesScript.concealment_at([mud], Vector2.ZERO, false), 0.0)
	_check("隐蔽：两片草叠加不翻倍（仍 0.35）",
			TerrainZonesScript.concealment_at([grass, mud], Vector2.ZERO, false), 0.35)
	_check("隐蔽：区域外 0.0",
			TerrainZonesScript.concealment_at([grass], Vector2(500.0, 500.0), false), 0.0)
	grass.free(); mud.free()


func _test_conceal_cap() -> void:
	var strong = StrongGrass.new()
	_check("隐蔽：超过上限时封顶到 0.60",
			TerrainZonesScript.concealment_at([strong], Vector2.ZERO, true),
			GameConfig.TERRAIN_CONCEAL_MAX)


## 玩家侧：地形档进实际移速，隐蔽度给出草丛加成
func _test_player_terrain() -> void:
	var mud = _zone(TerrainZoneScript.Kind.MUD, Vector2.ZERO, 40.0)
	var grass = _zone(TerrainZoneScript.Kind.GRASS, Vector2.ZERO, 40.0)
	var player = PlayerUnit.new()
	player.zones = [mud]
	player.global_position = Vector2.ZERO
	_check("玩家：泥地里移速档 0.70", player.terrain_speed_scale(), 0.70)
	_check("玩家：实际移速 = 基础 × 姿态 × 地形",
			player.effective_move_speed(), player.move_speed * 0.70)
	player.switch_posture(PlayerUnit.Posture.PRONE)
	player.tick_timers(1.0)   # 切姿态 0.65 s 到点才生效
	_check("玩家：卧姿 × 地形（0.35 × 0.70）",
			player.effective_move_speed(),
			player.move_speed * GameConfig.POSTURE_SPEED_PRONE * 0.70)
	player.zones = [grass]
	_check("玩家：卧在草丛里 0.55", player.terrain_concealment(), 0.55)
	player.switch_posture(PlayerUnit.Posture.STAND)
	player.tick_timers(1.0)
	_check("玩家：站进草丛隐蔽 0.35", player.terrain_concealment(), 0.35)
	player.global_position = Vector2(900.0, 900.0)
	_check("玩家：走出区域 → 移速档 1.0", player.terrain_speed_scale(), 1.0)
	_check("玩家：走出区域 → 隐蔽 0.0", player.terrain_concealment(), 0.0)
	mud.free(); grass.free(); player.free()


## 掩体互动：贴掩体不聚焦＝缩着（暴露 ×0.5）；聚焦＝探头（暴露回满）
func _test_player_exposure() -> void:
	var player = PlayerUnit.new()
	_check("暴露：没贴掩体时 1.0", player.exposure_scale(), 1.0)
	player.hugging = true
	_check("暴露：贴掩体且缩着 0.5", player.exposure_scale(), 0.5)
	player.set_focus(true)
	_check("暴露：贴掩体但探头（聚焦）→ 1.0", player.exposure_scale(), 1.0)
	player.hugging = false
	_check("暴露：离开掩体仍是 1.0", player.exposure_scale(), 1.0)
	_check_true("暴露：测试环境没有掩体 ⇒ hugging 刷新为假",
			not player._compute_hugging())
	player.free()


## 敌人侧：发现距离按玩家隐蔽度打折
func _test_enemy_detection() -> void:
	var grass = _zone(TerrainZoneScript.Kind.GRASS, Vector2.ZERO, 40.0)
	var player = PlayerUnit.new()
	var enemy = Enemy.new()
	enemy.detection_range = 60.0
	enemy._player = player
	player.zones = []
	_check("敌人：玩家不在草丛 → 发现距离不变", enemy.effective_detection_range(), 60.0)
	player.zones = [grass]
	player.global_position = Vector2.ZERO
	_check("敌人：玩家在草丛 → 60 × 0.65 = 39",
			enemy.effective_detection_range(),
			60.0 * (1.0 - GameConfig.TERRAIN_GRASS_CONCEAL))
	player.switch_posture(PlayerUnit.Posture.PRONE)
	player.tick_timers(1.0)
	_check("敌人：玩家卧在草丛 → 60 × 0.45 = 27",
			enemy.effective_detection_range(),
			60.0 * (1.0 - (GameConfig.TERRAIN_GRASS_CONCEAL
					+ GameConfig.TERRAIN_GRASS_PRONE_BONUS)))
	grass.free(); player.free(); enemy.free()


## demo 摆位：三片区域，且刻意远离五节点（≥ 250 m）——免得干扰候选 P / 4.16 那些地形扫描检查
func _test_demo_layout() -> void:
	var entries: Array = MapGenerator.demo_terrain_zones()
	_check("demo：3 片区域", entries.size(), 3)
	var kinds := {}
	var min_gap := 1.0e9
	for entry in entries:
		kinds[int(entry["kind"])] = true
		_check_true("demo：半径为正", float(entry["radius"]) > 0.0)
		for node in MapGenerator.DEMO_NODES:
			min_gap = minf(min_gap, (entry["position"] as Vector2).distance_to(node))
	_check("demo：泥 / 雪 / 草三种都有", kinds.size(), 3)
	_check_true("demo：离五节点最近也有 %.0f m（≥ 250）" % min_gap, min_gap >= 250.0)
