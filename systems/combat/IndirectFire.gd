extends Node

## 间瞄火力（docx 7.4 闭式解 + 4.11.3「地图选落点」+ 4.11.4 侦察兵标记可直接选为射击目标）
## 流程：选落点 → solve_elevation_dragged 反解仰角 → trajectory 积分出轨迹与飞行时间 →
##       落点预警倒计时 + 弹丸沿轨迹飞（撞地形就提前炸）→ 到点爆炸
## 第一版取舍：不带阻力（用 7.4 的校验基准解）、爆炸不区分掩体（打进掩体后正是间瞄的价值）
## 刻意不写 class_name：引用方用 preload + 动态变量声明（见 Cover.gd 头部说明）

signal shell_fired(target: Vector2, flight_time: float)
signal shell_landed(target: Vector2)

var ammo := GameConfig.INDIRECT_AMMO

var _pending: Array = []
var _cooldown := 0.0
var _player: Node2D = null
var _sight: SightSystem = null


## sight 用于「弹丸撞地形提前炸」（docx 7.4.1 弹道碰撞检测：h < H 即命中）
func setup(player: Node2D, sight: SightSystem) -> void:
	_player = player
	_sight = sight


func can_fire() -> bool:
	return ammo > 0 and _cooldown <= 0.0


func pending_shells() -> Array:
	return _pending


func cooldown_left() -> float:
	return _cooldown


## 请求对 target 落一发。返回 false 表示被拦下（没弹药 / 冷却中 / 太近太远 / 解算打不到）
## 解算走 docx 7.4.2 的带阻力模型（常数减速度 −30 m/s² 持续 2 s + g_eff）
func fire_at(target: Vector2) -> bool:
	if _player == null or not can_fire():
		return false
	var distance := _player.global_position.distance_to(target)
	if distance < GameConfig.INDIRECT_MIN_RANGE or distance > GameConfig.INDIRECT_MAX_RANGE:
		return false
	var elevation := BallisticsSystem.solve_elevation_dragged(distance,
			GameConfig.INDIRECT_MUZZLE_VELOCITY)
	if elevation < 0.0:
		return false
	var samples := BallisticsSystem.trajectory(GameConfig.INDIRECT_MUZZLE_VELOCITY, elevation)
	if samples.size() <= 1:
		return false
	var last: Dictionary = samples[samples.size() - 1]
	var flight := maxf(float(last["time"]), 0.2)
	ammo -= 1
	_cooldown = GameConfig.INDIRECT_COOLDOWN
	_pending.append({
		"target": target,
		"time_left": flight,
		"total": flight,
		"samples": samples,
		"direction": (target - _player.global_position).normalized(),
		"origin": _player.global_position,
		"origin_height": _origin_height(),
	})
	shell_fired.emit(target, flight)
	return true


func _process(delta: float) -> void:
	if _cooldown > 0.0:
		_cooldown = maxf(_cooldown - delta, 0.0)
	var landed: Array = []
	for shell in _pending:
		shell["time_left"] = float(shell["time_left"]) - delta
		var impact := _terrain_impact(shell)
		if impact != Vector2.INF:
			# 撞地形提前炸（docx 7.4.1：弹道高度 h < 地形高 H 即命中）
			shell["impact"] = impact
			landed.append(shell)
		elif float(shell["time_left"]) <= 0.0:
			landed.append(shell)
	for shell in landed:
		_pending.erase(shell)
		var point: Vector2 = shell.get("impact", shell["target"])
		_explode(point)
		shell_landed.emit(point)


## 枪口绝对高度（地形 + 眼高）：撞地判定与弹丸高度换算的基准
func _origin_height() -> float:
	if _sight == null or _player == null or _sight.grid == null:
		return 0.0
	return _sight.grid.sample_bilinear(_player.global_position) \
			+ GameConfig.SOLDIER_EYE_HEIGHT


## 弹丸当前状态（供表现层画弹丸与影子）：{world 世界坐标, height 相对枪口高度, progress}
func shell_state(shell: Dictionary) -> Dictionary:
	var samples: Array = shell["samples"]
	var total := maxf(float(shell["total"]), 0.001)
	var elapsed := clampf(total - float(shell["time_left"]), 0.0, total)
	var sample := _sample_at_time(samples, elapsed)
	var origin: Vector2 = shell["origin"]
	var direction: Vector2 = shell["direction"]
	return {
		"world": origin + direction * float(sample["x"]),
		"height": float(sample["height"]),
		"progress": clampf(elapsed / total, 0.0, 1.0),
	}


## 在弹道采样表里按「时间」插值（时间与水平距离不同步，必须按 time 查，不能按进度乘距离）
func _sample_at_time(samples: Array, elapsed: float) -> Dictionary:
	var previous: Dictionary = samples[0]
	for sample in samples:
		if float(sample["time"]) >= elapsed:
			var span := float(sample["time"]) - float(previous["time"])
			var ratio := 0.0
			if span > 0.0001:
				ratio = (elapsed - float(previous["time"])) / span
			return {
				"x": lerpf(float(previous["x"]), float(sample["x"]), ratio),
				"height": lerpf(float(previous["height"]), float(sample["height"]), ratio),
			}
		previous = sample
	var last: Dictionary = samples[samples.size() - 1]
	return {"x": float(last["x"]), "height": float(last["height"])}


## 撞地判定：弹丸绝对高度低于该处地形高就算命中，返回落点（否则 Vector2.INF）
func _terrain_impact(shell: Dictionary) -> Vector2:
	if _sight == null or _sight.grid == null:
		return Vector2.INF
	var state := shell_state(shell)
	var world: Vector2 = state["world"]
	var ground := _sight.grid.sample_bilinear(world)
	var absolute := float(shell["origin_height"]) + float(state["height"])
	if absolute <= ground:
		return world
	return Vector2.INF


## 爆炸：范围内敌人按距离衰减受伤；掩体也吃伤害（间瞄本来就是用来砸掩体的）
func _explode(target: Vector2) -> void:
	var loop := Engine.get_main_loop() as SceneTree
	if loop == null:
		return
	for node in loop.get_nodes_in_group("enemy"):
		var enemy = node
		if enemy == null or not enemy.has_method("take_damage"):
			continue
		if not bool(enemy.alive):
			continue
		var distance := target.distance_to(enemy.global_position)
		var damage := blast_damage_at(distance)
		if damage > 0.0:
			enemy.take_damage(damage)
	for node in loop.get_nodes_in_group(GameConfig.OCCLUDER_GROUP):
		var cover = node
		if cover == null or not cover.has_method("take_damage"):
			continue
		var cover_distance := target.distance_to(cover.global_position)
		var cover_damage := blast_damage_at(cover_distance)
		if cover_damage > 0.0:
			cover.take_damage(cover_damage)


## 爆心向外线性衰减：爆心 90 → 半径处 25；半径外 0
static func blast_damage_at(distance: float,
		radius: float = GameConfig.INDIRECT_BLAST_RADIUS) -> float:
	if distance >= radius:
		return 0.0
	return lerpf(GameConfig.INDIRECT_BLAST_DAMAGE, GameConfig.INDIRECT_BLAST_MIN_DAMAGE,
			clampf(distance / radius, 0.0, 1.0))
