extends Node

## 玩家步兵射击链（2026-10-04 · 从 Main 拆出）
##
## 拆它的**直接原因**：Main.gd 被上一轮的「建筑结构值结算」顶到 403 行，破了「≤400」硬线。
## 拆它的**口径原因**：这一段本来就是一条自洽的链 ——
##   开火前门禁（装配是否就绪 / 战术地图是否开着 / 人是否在载具里）
##   → 取准心方向 → 组装目标（enemy 组 + 敌方 FOB）→ player.shoot()
##   → 画曳光 → 结算（掩体耐久 / 建筑结构值 / 敌人工事伤害）→ 对敌压制
## 载具操炮**不在这里**（那是 VehicleController 的活），这里只有「玩家扣下扳机」这一条。
##
## 刻意不写 class_name：Main 用 preload 引用（与其它六个子模块一致），
## 模块通过鸭子类型读 Main 的公开字段（player / hud / vehicles / camera_controller / player_role）。

var main = null


func setup(main_node) -> void:
	main = main_node


func fire() -> void:
	if main == null or main.player == null or main.grid == null or main.camera_controller == null:
		# 只在「按了开火键却什么都没发生」时打印，方便真机用 logcat 定位是哪一段拦下的
		print("[开火] 未执行：装配没就绪（player=%s grid=%s camera_controller=%s）" % [
				str(main != null and main.player != null),
				str(main != null and main.grid != null),
				str(main != null and main.camera_controller != null)])
		return
	# 开图期间不能开火（docx 4.11.7 ①）
	if main.hud != null and main.hud.is_map_open():
		print("[开火] 未执行：战术地图开着")
		return
	# 人在载具里：步兵的枪收起来；只有武器位能开炮（8.1 座位分工）
	if main.vehicles != null and main.vehicles.vehicle != null \
			and main.vehicles.vehicle.is_occupied():
		if main.vehicles.is_gunner(main.player):
			main.vehicles.fire()
		else:
			print("[开火] 载具分支：坐在驾驶位，不出炮")
			main.hud.show_hint("驾驶位不能开炮——先按「换座」到武器位")
		return
	var direction: Vector2 = main.camera_controller.crosshair_world - main.player.global_position
	if direction.length() < 0.001:
		direction = main.player.facing
	else:
		direction = direction.normalized()
	var enemies: Array = main.get_tree().get_nodes_in_group("enemy")
	# 候选 L2：敌方 FOB（工事）也在可打目标里 —— 它自带 3 m 命中半径（BallisticsSystem 按 hit_radius() 取）。
	# 压制列表仍然只用 enemy 组（压制是打步兵的手感机制，不该被工事带偏）
	var targets: Array = enemies.duplicate()
	targets.append_array(main.get_tree().get_nodes_in_group("fob_enemy"))
	var result: Dictionary = main.player.shoot(direction, targets)
	# 被射速冷却 / 换弹拦下时什么都不做：触屏会把一次点按变成 touch + 模拟鼠标两次调用，
	# 第二次本来就该被拦（原来是继续打印 0.0 m 并画一条零长曳光，纯噪音）
	if not result.get("fired", false):
		return
	print("[开火] 距离=%.1fm 命中=%s" % [result["distance"], str(result["hit"])])
	main.spawn_tracer(main.player.global_position, direction, result["distance"])
	if result.get("cover_hit", false):
		_resolve_cover_hit(result)
	elif result["hit"]:
		_resolve_unit_hit(result)
	_suppress_enemies(enemies, direction)


## 子弹打在掩体上：扣掩体耐久（打光就破，之后不再挡通视与子弹）
func _resolve_cover_hit(result: Dictionary) -> void:
	var cover = result.get("cover")
	if cover == null or not cover.has_method("take_damage"):
		return
	cover.take_damage(main.player.damage_at(result["distance"])
			* RoleTable.damage_scale(main.player_role))
	# 建筑结构值（2026-10-03 拍板）：普通子弹 structure_damage = 0 ⇒ 对建筑毫无作用；
	# 重武器才扣得动（1200 结构值、主炮 280 ⇒ 4~5 发一栋）
	var structure := float(result.get("structure_damage", 0.0))
	if structure > 0.0 and cover.has_method("take_structure_damage"):
		cover.take_structure_damage(structure)


## 打中的是单位：步兵先记压制再结算伤害；不是步兵就是工事（FOB），照样扣
func _resolve_unit_hit(result: Dictionary) -> void:
	var enemy := result["target"] as Enemy
	if enemy != null:
		# 先记压制再结算伤害：被打死时 alive=false，add_suppression 会直接返回（2026-09-28 修）
		enemy.add_suppression(GameConfig.SUPPRESSION_HIT_BONUS)
		enemy.take_damage(main.player.damage_at(result["distance"])
				* RoleTable.damage_scale(main.player_role))
	elif result["target"] != null and result["target"].has_method("take_damage"):
		result["target"].take_damage(main.player.damage_at(result["distance"])
				* RoleTable.damage_scale(main.player_role))


## 玩家火力对敌人的压制（docx 7.3 反向）：命中额外叠加，未命中按「弹道离它多近」计算
func _suppress_enemies(enemies: Array, direction: Vector2) -> void:
	if main == null or main.player == null:
		return
	for node in enemies:
		var enemy := node as Enemy
		if enemy == null or not enemy.alive:
			continue
		var factor := SuppressionSystem.near_miss_factor(main.player.global_position, direction,
				enemy.global_position)
		if factor <= 0.0:
			continue
		enemy.add_suppression(SuppressionSystem.per_shot_amount(factor))
