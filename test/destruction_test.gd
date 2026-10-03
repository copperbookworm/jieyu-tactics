@tool
extends EditorScript

## 破坏规则测试（2026-10-03 使用者拍板四条）
##   ① destructible 一律 true  ② 结构值按占地分档（800 / 1200 / 3000，锚点 1200）
##   ③ 破坏后留贴地残痕 + 小减速、不影响通视  ④ 三段：完好 → 受损（顶高变矮）→ 摧毁（退出遮挡）
## 覆盖：掩体三段（Cover）/ 残痕（RubblePatch）/ 掩体表 → 区域列表的解析（MapGenerator）/
##       掩体破坏后玩家能走过去而敌人看不到（与通视、移速两条链路对接）
##
## 编辑器内：脚本编辑器打开本文件 → 文件 → 运行
## 无头：godot --headless --path . --script res://tools/run_tests_headless.gd -- destruction

const CoverScript := preload("res://entities/cover/Cover.gd")
const RubblePatchScript := preload("res://entities/zone/RubblePatch.gd")
const TerrainZonesScript := preload("res://systems/terrain/TerrainZones.gd")


func _run() -> void:
	_test_three_stage()
	_test_rubble()
	_test_material_parser()
	_test_sight_and_speed()

	print("—— 通过 %d 项 / 失败 %d 项 ——" % [_passed, _failed])
	if _failed > 0:
		print("！！ 有 %d 项失败，往上翻 [FAIL] 行看期望值与实际值" % _failed)


var _passed := 0
var _failed := 0


func _check(title: String, actual: Variant, expected: Variant) -> void:
	if actual == expected:
		_passed += 1
		print("[OK]   %s" % title)
	else:
		_failed += 1
		print("[FAIL] %s  期望=%s 实际=%s" % [title, str(expected), str(actual)])


func _check_true(title: String, condition: bool) -> void:
	_check(title, condition, true)


func _check_near(title: String, actual: float, expected: float, tolerance: float) -> void:
	if absf(actual - expected) <= tolerance:
		_passed += 1
		print("[OK]   %s (%.3f ≈ %.3f)" % [title, actual, expected])
	else:
		_failed += 1
		print("[FAIL] %s  期望=%.3f±%.3f 实际=%.3f" % [title, expected, tolerance, actual])


## ────────────── ① 三段破坏（Cover）──────────────

func _test_three_stage() -> void:
	_check("拍板②锚点：标准建筑结构值 = 1200", int(GameConfig.STRUCTURE_HP_HOUSE), 1200)
	_check("掩体耐久仍是文档的 200（4.17 / 20.5）", int(GameConfig.COVER_HP), 200)
	_check_near("受损阈值 0.70", GameConfig.COVER_DAMAGED_BELOW_RATIO, 0.70, 0.001)
	_check_near("沙袋受损顶高比例 0.45", GameConfig.COVER_DAMAGED_HEIGHT_SCALE, 0.45, 0.001)

	var cover = CoverScript.new()
	cover.height = GameConfig.COVER_SANDBAG_HEIGHT
	cover.max_hp = GameConfig.COVER_HP
	cover.hp = cover.max_hp

	# 完好
	_check("完好：不是受损态", cover.is_damaged(), false)
	_check("完好：顶高比例 1.0", cover.height_scale(), 1.0)
	_check_near("完好：顶高 = 地面 + 1.1", cover.top_height_at(10.0), 11.1, 0.001)

	# 打到 60%（一发 62 伤害后的档）→ 进受损
	cover.take_damage(GameConfig.COVER_HP * 0.40)
	_check_near("受损：耐久比 0.60", snappedf(cover.health_ratio(), 0.01), 0.60, 0.001)
	_check("受损：is_damaged 为真", cover.is_damaged(), true)
	_check("受损：还没被摧毁", cover.is_destroyed(), false)
	_check_near("受损：顶高比例 0.45", cover.height_scale(), 0.45, 0.001)
	_check_near("受损：顶高变矮到 10.495", cover.top_height_at(10.0),
			10.0 + GameConfig.COVER_SANDBAG_HEIGHT * GameConfig.COVER_DAMAGED_HEIGHT_SCALE,
			0.001)

	# 打光 → 摧毁
	cover.take_damage(GameConfig.COVER_HP)
	_check("摧毁：is_destroyed 为真", cover.is_destroyed(), true)
	_check("摧毁：顶高比例 0", cover.height_scale(), 0.0)
	_check_near("摧毁：顶高 = 地面高（不再挡住）", cover.top_height_at(10.0), 10.0, 0.001)
	_check("摧毁：不再是「受损」态（两个语义分开）", cover.is_damaged(), false)

	# 摧毁信号：WorldSetup 拿它落残痕
	var received: Array = []
	cover.destroyed_now.connect(func(node) -> void: received.append(node))
	var second = CoverScript.new()
	second.max_hp = 100.0
	second.destroyed_now.connect(func(node) -> void: received.append(node))
	second.take_damage(10.0)
	_check("挨打但没打光：不发摧毁信号", received.size(), 0)
	second.take_damage(1000.0)
	_check("打光：发一次摧毁信号", received.size(), 1)
	second.take_damage(1000.0)
	_check("已经摧毁后再打：不重复发", received.size(), 1)

	cover.free()
	second.free()


## ────────────── ② 残痕（RubblePatch）──────────────

func _test_rubble() -> void:
	_check_near("残痕移速倍率与泥泞同档 0.70", GameConfig.RUBBLE_SPEED_SCALE, 0.70, 0.001)
	_check_near("残痕半径系数 1.25", GameConfig.RUBBLE_RADIUS_SCALE, 1.25, 0.001)
	_check("残痕生命周期 0 = 留到本局结束", GameConfig.RUBBLE_LIFETIME, 0.0)

	var patch = RubblePatchScript.new()
	patch.setup(4.0)
	_check("残痕：圆心在内", patch.covers(Vector2(0.0, 0.0)), true)
	_check("残痕：半径内（3.9 m）在内", patch.covers(Vector2(3.9, 0.0)), true)
	_check("残痕：半径外（4.1 m）不在", patch.covers(Vector2(4.1, 0.0)), false)
	_check_near("残痕：移速倍率", patch.speed_scale(), GameConfig.TERRAIN_MUD_SPEED_SCALE, 0.001)
	_check("残痕：不给隐蔽（不挡视线）", patch.concealment(false), 0.0)
	_check("残痕：半径可读回", patch.radius(), 4.0)
	patch.free()


## ────────────── ③ 掩体表 → 区域列表（MapGenerator）──────────────

func _test_material_parser() -> void:
	# 造一张 200×200 的材质图：一块 60×60 泥泞 + 一块 50×50 雪地 + 一块 40×40 草丛
	# 坐标都在整数格心，方便断言；另外撒 4 个单格散点验「小于 min_cells 丢弃」
	var image := Image.create(200, 200, false, Image.FORMAT_L8)
	image.fill(0)
	_fill_rect(image, 20, 20, 60, 60, 1)    # 泥泞
	_fill_rect(image, 120, 30, 50, 50, 2)   # 雪地
	_fill_rect(image, 60, 140, 40, 40, 3)   # 草丛
	image.set_pixel(190, 190, 1)
	image.set_pixel(5, 190, 2)
	image.set_pixel(190, 5, 3)
	image.set_pixel(2, 2, 1)

	var entries := MapGenerator.terrain_zones_from_material_image(image)
	_check("材质图解析出 3 片区域（4 个散点被丢弃）", entries.size(), 3)
	if entries.size() != 3:
		return
	var by_kind := {}
	for entry in entries:
		by_kind[int(entry["kind"])] = entry

	# 泥泞：60×60 = 3600 格 ⇒ 等面积圆半径 sqrt(3600/π) ≈ 33.85
	_check_true("泥泞区域存在（kind 0）", by_kind.has(0))
	if by_kind.has(0):
		var mud: Dictionary = by_kind[0]
		_check_near("泥泞：等面积圆半径", float(mud["radius"]), sqrt(3600.0 / PI), 0.05)
		_check_near("泥泞：圆心 x", (mud["position"] as Vector2).x, 49.5, 0.6)
		_check_near("泥泞：圆心 y", (mud["position"] as Vector2).y, 49.5, 0.6)
		_check("泥泞：格数", int(mud["cells"]), 3600)

	_check_true("雪地区域存在（kind 1）", by_kind.has(1))
	if by_kind.has(1):
		_check_near("雪地：等面积圆半径", float((by_kind[1] as Dictionary)["radius"]),
				sqrt(2500.0 / PI), 0.05)
	_check_true("草丛区域存在（kind 2）", by_kind.has(2))
	if by_kind.has(2):
		_check_near("草丛：等面积圆半径", float((by_kind[2] as Dictionary)["radius"]),
				sqrt(1600.0 / PI), 0.05)

	# 全空的图 → 空列表（调用方据此退回 demo 摆位）
	var empty := Image.create(64, 64, false, Image.FORMAT_L8)
	empty.fill(0)
	_check("全空材质图 → 空列表", MapGenerator.terrain_zones_from_material_image(empty).size(), 0)
	_check("null 图不崩", MapGenerator.terrain_zones_from_material_image(null).size(), 0)

	# 瓦砾（id 4）不从图里读（残痕是摧毁时现落的）
	var rubble_only := Image.create(80, 80, false, Image.FORMAT_L8)
	rubble_only.fill(4)
	_check("id=4（瓦砾）解析时跳过", 
			MapGenerator.terrain_zones_from_material_image(rubble_only).size(), 0)


func _fill_rect(image: Image, x0: int, y0: int, width: int, height: int, id: int) -> void:
	var color := Color8(id, id, id)
	for y in range(y0, y0 + height):
		for x in range(x0, x0 + width):
			if x < image.get_width() and y < image.get_height():
				image.set_pixel(x, y, color)


## ────────────── ④ 破坏对通视与移速两条链路的实际影响 ───────────────

func _test_sight_and_speed() -> void:
	var cover = CoverScript.new()
	cover.half_size = Vector2(4.0, 1.0)
	cover.position = Vector2(100.0, 100.0)
	cover.height = GameConfig.COVER_SANDBAG_HEIGHT
	cover.max_hp = GameConfig.COVER_HP
	cover.hp = cover.max_hp

	var ground := 10.0
	var stand_eye := ground + GameConfig.SOLDIER_EYE_HEIGHT
	var prone_eye := ground + GameConfig.PRONE_SIGHT_HEIGHT
	var top_intact: float = cover.top_height_at(ground)
	_check("完好：站姿眼高能越过沙袋",
			SightSystem.blocks_sight(stand_eye, top_intact), false)
	_check("完好：卧姿视线被沙袋挡住",
			SightSystem.blocks_sight(prone_eye, top_intact), true)

	# 打到受损档：顶高落到 1.1 × 0.45 = 0.495 m ⇒ 「看得过去」所需的视线高度整整降了 0.605 m
	cover.take_damage(GameConfig.COVER_HP * 0.40)
	var top_damaged: float = cover.top_height_at(ground)
	_check_true("受损：顶高确实变矮（%.3f → %.3f m）" % [top_intact, top_damaged],
			top_damaged < top_intact)
	_check_near("受损：顶高 = 地面 + 1.1 × 0.45", top_damaged,
			ground + GameConfig.COVER_SANDBAG_HEIGHT * GameConfig.COVER_DAMAGED_HEIGHT_SCALE,
			0.001)
	_check_near("受损：越过它所需的视线高度降了 0.605 m（缝变大）",
			top_intact - top_damaged,
			GameConfig.COVER_SANDBAG_HEIGHT * (1.0 - GameConfig.COVER_DAMAGED_HEIGHT_SCALE),
			0.001)
	# 口径提醒：0.495 m 的残掩体仍在「矮掩体」档（文档 4.6 掩体高 0.5–2 m）里，
	# 所以卧姿（0.6 m 眼高）**仍然**越不过去 —— 这是刻意的：受损不等于消失。
	_check("受损：卧姿仍然越不过去（残掩体仍在矮掩体档）",
			SightSystem.blocks_sight(prone_eye, top_damaged), true)
	_check("受损：站姿当然还是能看过去",
			SightSystem.blocks_sight(stand_eye, top_damaged), false)
	_check_true("受损：视线抬到 0.8 m 就能看过去（完好时同样高度会被 1.1 m 挡住）",
			not SightSystem.blocks_sight(ground + 0.8, top_damaged))

	# 摧毁：不再进 occluder 组
	cover.take_damage(GameConfig.COVER_HP)
	_check("摧毁：退出 occluder 组", cover.is_in_group(GameConfig.OCCLUDER_GROUP), false)

	# 残痕走「区域」链路：与泥泞共用 TerrainZones 的查询，玩家侧不新增接口
	var patch = RubblePatchScript.new()
	patch.setup(5.0)
	patch.position = Vector2(200.0, 200.0)
	var zones: Array = [patch]
	_check_near("残痕：站在上面移速按泥泞档",
			TerrainZonesScript.speed_scale_at(zones, Vector2(202.0, 200.0)),
			GameConfig.TERRAIN_MUD_SPEED_SCALE, 0.001)
	_check_near("残痕：站在外面移速不受影响",
			TerrainZonesScript.speed_scale_at(zones, Vector2(300.0, 200.0)), 1.0, 0.001)
	_check_near("残痕：不给隐蔽（与「不影响通视」同一条约束）",
			TerrainZonesScript.concealment_at(zones, Vector2(200.0, 200.0), false), 0.0, 0.001)

	cover.free()
	patch.free()
