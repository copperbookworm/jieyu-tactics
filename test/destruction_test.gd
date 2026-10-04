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
const WeaponTableScript := preload("res://systems/weapons/WeaponTable.gd")
const VehicleTableScript := preload("res://systems/vehicles/VehicleTable.gd")


func _run() -> void:
	_test_three_stage()
	_test_rubble()
	_test_material_parser()
	_test_sight_and_speed()
	_test_openings()
	_test_structure_damage_sources()

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


## ────────────── ⑤ 开口（窗 / 门洞，拍板① 2026-10-03）──────────────

func _test_openings() -> void:
	# 世界坐标：房子中心在 (300,300)（**刻意远离其它用例**，避免测试之间互相污染），
	# 半宽 5 → 西墙 x = 295、东墙 x = 305、墙带 y ∈ [295,305]
	var cover = CoverScript.new()
	cover.half_size = Vector2(5.0, 5.0)
	cover.position = Vector2(300.0, 300.0)
	cover.height = 3.0
	cover.max_hp = GameConfig.STRUCTURE_HP_HOUSE
	cover.hp = cover.max_hp
	# 西墙 y ∈ [294.5, 298.5] 段一扇窗（窗台 0.75 m —— 取在卧姿眼高 0.6 m 与站姿眼高 1.6 m 之间，
	# 这样「站姿看得见、卧姿看不见」是一条干净的边界）+ 东墙中段一道门（落地到顶）；
	# center / half_size 都是本地坐标，所以窗在本地 y = -3.5 ± 2。
	# 窗与门**刻意错开**（窗在 y≈296.5、门在 y=300）：只穿窗的那条射线不会顺带穿过门，
	# 于是「几何入口」与「对侧墙落点」都能拿到干净的值。
	cover.openings = [
		{"type": "window", "center": Vector2(-5.0, -3.5), "half_size": Vector2(0.6, 2.0),
			"h_low": 0.75, "h_top": 3.0},
		{"type": "door", "center": Vector2(5.0, 0.0), "half_size": Vector2(0.6, 1.2),
			"h_low": 0.0, "h_top": 3.0},
	]

	# ① 几何入口：从西边 50 m 外打向东 —— 第一个几何交点在墙上（窗那一面）
	var through_window_from := Vector2(280.0, 296.5)
	var through_window_to := Vector2(330.0, 296.5)
	var entry: Vector2 = cover.wall_hit(through_window_from, through_window_to, INF, false)
	_check_near("几何入口落在墙上 x = 295", entry.x, 295.0, 0.001)

	# ② 站姿视线（1.6 m）打在窗那一面 ⇒ 窗是开口，这一枪**不被入口墙挡住**；
	#    但同一发弹继续飞会撞到房间另一头 —— segment_hit 返回的是「第一个非开口交点」，
	#    所以这里期望它在**对侧**（x = 305）而不是入口（x = 295）。
	var hit_standing: Vector2 = cover.segment_hit(through_window_from, through_window_to, 1.6)
	_check_near("站姿（1.6 m）：入口窗可穿，弹道停在对侧 x = 305", hit_standing.x, 305.0, 0.001)
	# ③ 卧姿视线（0.6 m）低于窗台 ⇒ 被墙挡住
	var hit_prone: Vector2 = cover.segment_hit(through_window_from, through_window_to, 0.6)
	_check_true("卧姿（0.6 m）低于窗台：被墙挡住", hit_prone != Vector2.INF)
	_check_near("卧姿：挡住的位置仍是西墙 x = 295", hit_prone.x, 295.0, 0.001)

	# ④ 门是落地的：卧姿也能从门穿过去（这一条刻意走 y = 300 的东墙门）
	_check("穿过门：门那一面不算挡（卧姿也是）",
			cover.segment_hit(Vector2(330.0, 300.0), Vector2(280.0, 300.0),
			0.6) != Vector2.INF, true)

	# ⑤ 打在西墙的非开口段（y 偏移 4 m）⇒ 实心墙，站姿也挡
	var solid_from := Vector2(280.0, 304.0)
	var solid_to := Vector2(330.0, 304.0)
	var solid_hit: Vector2 = cover.segment_hit(solid_from, solid_to, 1.6)
	_check_true("墙上没有开口的段：站姿也挡（交点 x=%.0f）" % solid_hit.x, solid_hit != Vector2.INF)

	# ⑥ 「打中窗 ≠ 打不到楼」：从窗打进去之后，**对侧墙**才是结构伤害的落点
	#    （far_wall_hit 取所有交点里最靠后的那一个；入口那面墙不吃直射穿窗的伤害）
	var far_wall: Vector2 = cover.far_wall_hit(through_window_from, through_window_to)
	_check_true("从窗打进去还有对侧墙（结构伤害落在那里）", far_wall != Vector2.INF)
	_check_near("对侧墙在 x = 305", far_wall.x, 305.0, 0.001)

	# ⑦ 摧毁之后整块都不挡（开口已无意义）
	cover.take_damage(GameConfig.STRUCTURE_HP_HOUSE)
	_check("摧毁后：实心段也不再挡",
			cover.segment_hit(solid_from, solid_to, 1.6) == Vector2.INF, true)

	# ⑧ 与通视链路联通：开口要同时影响「看得见」与「打得着」。
	#    这里直接问 SightSystem.cover_blocks()（纯判定，不查 occluder 组）——
	#    组查询要等引擎刷新组缓存，无头同步测试里拿不到；而真正要验的就是这套几何判定。
	#    ⚠ 上面第⑦步刚把这块掩体打掉了 —— 通视链路要的是一栋**完好**的楼，所以重建一份。
	var fresh = CoverScript.new()
	fresh.half_size = Vector2(5.0, 5.0)
	fresh.position = Vector2(300.0, 300.0)
	fresh.height = 3.0
	fresh.max_hp = GameConfig.STRUCTURE_HP_HOUSE
	fresh.hp = fresh.max_hp
	fresh.openings = cover.openings.duplicate(true)
	var ground := 10.0
	var eye := ground + GameConfig.SOLDIER_EYE_HEIGHT
	# 屋里的目标点：取 (300, 296.5)（矩形内、正对窗）离地 0.5 m 的一个目标。
	# 站姿与卧姿都要从窗里穿过去看它，差别只落在「入口处视线有多高」：
	#   站姿：从 (280,296.5) 的 1.6 m 看到 (300,296.5) 的 0.5 m，入口（x=295）≈ 1.11 m > 窗台 1.0 ⇒ 看得见
	#   卧姿：从 0.6 m 看到 0.5 m，入口 ≈ 0.64 m < 窗台 ⇒ 被墙挡住
	var inside := Vector2(300.0, 296.5)   # 屋子**里面**（矩形内，x∈[295,305]）、正对窗
	var inside_target := ground + 0.5
	_check("通视：站着能透过窗看见屋里（门口视线高于窗台）",
			SightSystem.cover_blocks(fresh, through_window_from, eye, inside, inside_target,
			ground), false)
	_check("通视：同一扇窗，卧姿（0.6 m）低于窗台就看不见",
			SightSystem.cover_blocks(fresh, through_window_from,
			ground + GameConfig.PRONE_SIGHT_HEIGHT, inside, inside_target, ground), true)
	_check("通视：实心墙段站着也挡",
			SightSystem.cover_blocks(fresh, solid_from, eye, Vector2(330.0, 304.0),
			eye, ground), true)
	# 摧毁之后同一条实心墙视线不再被挡（与第⑦步同一条语义，走 cover_blocks 复核一遍）
	fresh.take_damage(GameConfig.STRUCTURE_HP_HOUSE)
	_check("通视：摧毁后实心墙也不再挡",
			SightSystem.cover_blocks(fresh, solid_from, eye, Vector2(330.0, 304.0),
			eye, ground), false)
	fresh.free()
	cover.free()


## ────────── ⑥ 建筑结构值的结算来源（2026-10-03 拍板：普通子弹恒为 0）──────────

func _test_structure_damage_sources() -> void:
	# ① 建筑不吃子弹伤害：absorbs_bullets=false ⇒ take_damage 完全无效
	var building = CoverScript.new()
	building.half_size = Vector2(6.0, 5.0)
	building.position = Vector2(500.0, 500.0)
	building.height = 4.0
	building.max_hp = GameConfig.STRUCTURE_HP_HOUSE
	building.hp = building.max_hp
	building.absorbs_bullets = false
	_check("建筑默认 1200 结构值", building.hp, GameConfig.STRUCTURE_HP_HOUSE)
	# 步枪 62 伤害 × 20 发 —— 按老口径（不分弹种）正好拆掉一栋楼
	for i in 20:
		building.take_damage(62.0)
	_check_near("普通子弹打 20 发：建筑结构值一点没掉（拍板：子弹对建筑伤害为 0）",
			building.hp, GameConfig.STRUCTURE_HP_HOUSE, 0.001)
	_check("普通子弹打 20 发：建筑还完好", building.destroyed, false)

	# ② 换重武器：主炮 280 ⇒ 5 发拆一栋标准建筑（1200 / 280 = 4.29）
	var tank_gun := WeaponTableScript.structure_damage_of("m107barrettm82")
	building.take_structure_damage(280.0 * 4.0)
	_check_near("主炮 4 发 × 280 = 1120 < 1200：还没倒", building.hp, 80.0, 0.001)
	_check("还没倒（受损段）", building.destroyed, false)
	_check_true("受损段：顶高变矮（4.0 → %.2f）" % building.effective_height(),
			building.effective_height() < building.height)
	building.take_structure_damage(280.0)
	_check("第 5 发：建筑被摧毁", building.destroyed, true)
	_check_near("摧毁段：顶高归零", building.effective_height(), 0.0, 0.001)
	_check("摧毁后退出 occluder 组（不再挡通视与子弹）",
			building.is_in_group(GameConfig.OCCLUDER_GROUP), false)

	# ③ 沙袋（吃子弹）：200 耐久，近距 62 伤害 → 4 发打坏（保留老手感）
	var sandbag = CoverScript.new()
	sandbag.half_size = Vector2(3.6, 1.1)
	sandbag.position = Vector2(600.0, 600.0)
	sandbag.height = 1.1
	sandbag.max_hp = GameConfig.COVER_HP
	sandbag.hp = sandbag.max_hp
	sandbag.absorbs_bullets = true
	for i in 3:
		sandbag.take_damage(62.0)
	_check("沙袋吃子弹：3 发（186 < 200）还没坏", sandbag.destroyed, false)
	sandbag.take_damage(62.0)
	_check("沙袋第 4 发打坏（与老手感一致）", sandbag.destroyed, true)

	# ④ 弹种表：普通子弹必须恒为 0 —— 否则「拆楼是重武器的活」这条规则就是假的
	_check("步枪（m4a1）对建筑伤害 = 0", WeaponTableScript.structure_damage_of("m4a1"), 0.0)
	_check("轻机枪（m249saw）对建筑伤害 = 0", WeaponTableScript.structure_damage_of("m249saw"), 0.0)
	_check("7.62 通用机枪（m240）对建筑伤害 = 0（口径不够就是打不动墙）",
			WeaponTableScript.structure_damage_of("m240"), 0.0)
	_check_true("12.7mm 反器材步枪（M82）能伤到建筑（%d）"
			% int(WeaponTableScript.structure_damage_of("m107barrettm82")),
			WeaponTableScript.structure_damage_of("m107barrettm82") > 0.0)
	_check_true("40mm 枪榴弹（m320）> 反器材步枪",
			WeaponTableScript.structure_damage_of("m320")
			> WeaponTableScript.structure_damage_of("m107barrettm82"))
	_check_true("反坦克火箭（at4，%d）> 12.7mm" % int(WeaponTableScript.structure_damage_of("at4rpg7")),
			WeaponTableScript.structure_damage_of("at4rpg7")
			> WeaponTableScript.structure_damage_of("m107barrettm82"))
	_check_true("反坦克导弹（javelin，%d）最狠" % int(WeaponTableScript.structure_damage_of("12javelin")),
			WeaponTableScript.structure_damage_of("12javelin")
			>= WeaponTableScript.structure_damage_of("at4rpg7"))
	# 锚点口径：反坦克火箭 600 ⇒ 2 发拆标准建筑（1200），正好落在「2–3 发」那一档
	_check_true("反坦克火箭 2 发能拆标准建筑（1200）",
			WeaponTableScript.structure_damage_of("at4rpg7") * 2.0 >= GameConfig.STRUCTURE_HP_HOUSE)
	_check_true("反坦克火箭拆小屋（800）只需 2 发以内（拍板锚点：2–3 发一栋）",
			WeaponTableScript.structure_damage_of("at4rpg7") * 2.0 >= GameConfig.STRUCTURE_HP_SMALL)

	# ⑤ 载具表：主炮 / 榴弹炮 / 机炮三档分得开（gun_structure_damage 收的是车辆行）
	var mbt := VehicleTableScript.gun_structure_damage(VehicleTableScript.get_vehicle("mbt_t1"))
	var ifv := VehicleTableScript.gun_structure_damage(VehicleTableScript.get_vehicle("ifv_a"))
	var sph := VehicleTableScript.gun_structure_damage(VehicleTableScript.get_vehicle("sph_spha"))
	var atgm := VehicleTableScript.atgm_structure_damage(VehicleTableScript.get_vehicle("ifv_a"))
	_check_true("坦克主炮 (%d) > 机炮 (%d)" % [int(mbt), int(ifv)], mbt > ifv)
	_check_true("自行榴弹炮 (%d) > 坦克主炮 (%d)" % [int(sph), int(mbt)], sph > mbt)
	_check_true("机炮对建筑伤害很低（%d < 100）" % int(ifv), ifv < 100.0)
	_check_true("反坦克导弹 (%d) > 坦克主炮 (%d)" % [int(atgm), int(mbt)], atgm > mbt)
	_check_near("坦克主炮 4 发正好把标准建筑打到 80（1200 − 4×280）",
			GameConfig.STRUCTURE_HP_HOUSE - mbt * 4.0, 80.0, 0.001)
	# ⑥ 间瞄兜底值必须与榴弹炮那一行同档（同一个数来源）
	_check_near("间瞄结构伤害 = 155mm 榴弹炮的 gun_structure_damage",
			GameConfig.INDIRECT_STRUCTURE_DAMAGE, sph, 0.001)

	building.free()
	sandbag.free()
