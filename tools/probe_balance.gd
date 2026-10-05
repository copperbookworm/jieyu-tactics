extends SceneTree

## 20 v 20 平衡采样（2026-10-05 · 第六十四版）
##
## 口径（严格区分，别混）：
##   · **仿真口径**（本脚本擅长）：人数随时间、首接触时间、逐节点清场时间、友军阵亡数、脚本侧每帧耗时。
##   · **帧时间 / jank**：headless **测不了**（不渲染），要真机 dumpsys gfxinfo —— 本脚本不下帧率结论。
##
## 两种脚本：
##   --push            玩家沿占领节点推进（拍板 B 想要的打法）：每节点停留 N 秒，采人数曲线
##   --stand           玩家站在出生点不动（旧部署「出生 30 秒交火」的口径）
##   --legacy          先把 20 名敌兵按**旧口径**（出生锚点前方 45~75 m + 圆周复用）重新摆位
##   --seconds <N>     总时长（默认 120）
##
## 用法：godot --headless --path . --fixed-fps 60 --script res://tools/probe_balance.gd -- --push --seconds 120

const ModeTableScript := preload("res://data/config/ModeTable.gd")
const MatchRulesScript := preload("res://systems/match/MatchRules.gd")
const MapGenScript := preload("res://systems/terrain/MapGenerator.gd")

const SAMPLE_INTERVAL := 0.5
const NODE_DWELL := 40.0
const STAGE_DISTANCE := 50.0   # 队友送到节点外这个距离：出生点到 N1 有 197 m，纯走路要 ~60 s

var _main = null
var _elapsed := 0.0
var _total := 120.0
var _push := true
var _legacy := false
var _next_sample := 0.0
var _rows: Array = []
var _first_contact := -1.0
var _frame_ms: Array = []
var _last_us := 0
var _phase := -1
var _peak_units := 0
var _tag := ""


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	for i in args.size():
		match args[i]:
			"--seconds":
				if i + 1 < args.size():
					_total = float(args[i + 1])
			"--push":
				_push = true
			"--stand":
				_push = false
			"--legacy":
				_legacy = true
	MatchRulesScript.set_mode(ModeTableScript.Mode.PVP_RANKED)
	var enemies := int(ModeTableScript.value_of(ModeTableScript.Mode.PVP_RANKED, "enemy_count", 20))
	var scene: PackedScene = load("res://scenes/gameplay/Main.tscn")
	_main = scene.instantiate()
	_main.enemy_count = enemies
	root.add_child(_main)
	current_scene = _main
	if _legacy:
		_legacy_redeploy()
	_tag = "%s · %s敌/%s友" % ["推进" if _push else "站立", str(_alive_enemies().size() + _dead_enemy_names().size()),
			str(_alive_allies().size())]
	print("===== 平衡采样：%s · 脚本=%s · 旧部署=%s · 采样 %.0f s / 每 %.1f s ====="
			% [str(enemies), "推进" if _push else "站立", str(_legacy), _total, SAMPLE_INTERVAL])
	print("t(s) | 敌存 | 友存 | 玩家hp | 敌方交战 | 阶段")
	_last_us = Time.get_ticks_usec()


func _process(delta: float) -> bool:
	var now := Time.get_ticks_usec()
	if _last_us > 0:
		_frame_ms.append(float(now - _last_us) / 1000.0)
	_last_us = now
	_elapsed += delta
	var units := get_nodes_in_group("friendly").size() + get_nodes_in_group("enemy").size()
	_peak_units = maxi(_peak_units, units)
	if _push:
		_advance_phase()
	if _first_contact < 0.0 and _enemies_engaged() > 0:
		_first_contact = _elapsed
		print("—— 首接触：%.1f s（%d 名敌人进入交战）" % [_first_contact, _enemies_engaged()])
	if _elapsed >= _next_sample:
		_next_sample = _elapsed + SAMPLE_INTERVAL
		_sample()
	if _elapsed >= _total:
		_report()
		return true
	return false


## 推进脚本：每 NODE_DWELL 秒给队友下一条「去下一个占领节点」的组任务。
## ⚠ 为什么不瞬移**玩家**（第一版探针就是这么写的，已纠正）：把玩家直接扔进未清空的节点，
## 玩家 ~2 s 就被 3 名守军打倒；玩家一倒，队友回撤、战斗停摆，曲线就全是死平线 ——
## 测出来的是「瞬移玩家会死」，不是「清一个节点要多久」。改用队友现成的组任务接口
## （org 第五十四版：order_target / order_active），玩家留在出生点（离 N1 155 m，不参与）。
func _advance_phase() -> void:
	var zones: Array = _main.capture_zones
	if zones.is_empty():
		return
	var index := mini(int(_elapsed / NODE_DWELL), zones.size() - 1)
	if index == _phase:
		return
	_phase = index
	_stage_allies((zones[index] as Node2D).global_position)


func _stage_allies(target: Vector2) -> void:
	var staged := 0
	var total := get_nodes_from_friendly().size()
	for node in get_nodes_from_friendly():
		# 送到节点外一圈：不瞬移的话 19 名队友从出生点走到 N1 要 ~60 s，曲线全是赶路
		var angle := TAU * float(staged) / maxf(float(total), 1.0)
		(node as Node2D).global_position = target \
				+ Vector2(cos(angle), sin(angle)) * STAGE_DISTANCE
		node.order_target = target
		node.order_active = true
		staged += 1
	print("—— 阶段 %d：%d 名队友受令推进到 %s（t=%.1f s，敌存 %d / 友存 %d）"
			% [_phase + 1, staged, str(target), _elapsed, _alive_enemies().size(), _alive_allies().size()])


func get_nodes_from_friendly() -> Array:
	var out: Array = []
	for node in get_nodes_in_group("friendly"):
		if String(node.name).begins_with("Ally") and float(node.hp) > 0.0:
			out.append(node)
	return out


func _sample() -> void:
	_rows.append({
		"t": _elapsed,
		"enemy": _alive_enemies().size(),
		"ally": _alive_allies().size(),
		"hp": float(_main.player.hp) if _main.player != null else 0.0,
		"engaged": _enemies_engaged(),
		"phase": _phase + 1,
		"ally_near": _nearest_ally_distance(),
	})
	var row: Dictionary = _rows[-1]
	print("%5.1f | %4d | %4d | %6.0f | %8d | 节点 %d | 最近队友距节点 %5.1f m"
			% [row["t"], row["enemy"], row["ally"], row["hp"], row["engaged"], row["phase"],
			row["ally_near"]])


func _report() -> void:
	print("===== 汇总（%s · 旧部署=%s）=====" % [_tag, str(_legacy)])
	print("首接触时间：%s" % ("%.1f s" % _first_contact if _first_contact >= 0.0 else "未接触"))
	print("敌存：%d → %d（起始 %d）" % [_rows[0]["enemy"] if _rows else 0,
			_rows[-1]["enemy"] if _rows else 0, _rows[0]["enemy"] if _rows else 0])
	print("友存：%d → %d" % [_rows[0]["ally"] if _rows else 0, _rows[-1]["ally"] if _rows else 0])
	print("峰值同场单位：%d（含穿插兵 / 乘员）" % _peak_units)
	print("脚本侧每帧（headless 不受 vsync 限制，可当仿真成本）：中位 %.2f ms / p95 %.2f ms / %d 帧"
			% [_median(_frame_ms), _p95(_frame_ms), _frame_ms.size()])
	print("对象数 / 节点数：%d / %d；静态内存 %.1f MB"
			% [Performance.get_monitor(Performance.OBJECT_COUNT),
			Performance.get_monitor(Performance.OBJECT_NODE_COUNT),
			Performance.get_monitor(Performance.MEMORY_STATIC) / 1048576.0])


## 旧部署（拍板 B 之前）：出生锚点前方 45~75 m，点位不够时循环复用 + 圆周散开
## 还原「旧口径」要**两件事**一起做（只搬敌人是不够的，第一版探针就漏了后半句）：
##   ① 敌人搬回出生锚点前方（旧摆位）；② 清掉队友的组任务，让他们回到「跟随玩家」的旧行为 ——
##      否则队友会自己按组任务往占领节点走，在路过时顺手把敌人清掉，测出来的不是旧症状。
func _legacy_redeploy() -> void:
	for node in get_nodes_in_group("friendly"):
		if String(node.name).begins_with("Ally"):
			node.order_active = false
	var points: Array = MapGenScript.demo_enemy_points()
	var index := 0
	for node in get_nodes_in_group("enemy"):
		var enemy_name := String(node.name)
		if not enemy_name.begins_with("Enemy") or enemy_name.contains("TankCrew") \
				or enemy_name.contains("Vehicle"):
			continue
		(node as Node2D).global_position = _main.world._enemy_spawn_position(points, index)
		node.set_move_target((node as Node2D).global_position)
		index += 1
	# 与推进场景同口径：把队友送到**敌方集群**外一圈，直接量「19 队友 vs 扎堆的 20 敌」
	var centroid := Vector2.ZERO
	var counted := 0
	for node in get_nodes_in_group("enemy"):
		var enemy_name := String(node.name)
		if enemy_name.begins_with("Enemy") and not enemy_name.contains("TankCrew") \
				and not enemy_name.contains("Vehicle"):
			centroid += (node as Node2D).global_position
			counted += 1
	if counted > 0:
		_stage_allies(centroid / float(counted))


func _alive_enemies() -> Array:
	var out: Array = []
	for node in get_nodes_in_group("enemy"):
		var enemy_name := String(node.name)
		if enemy_name.begins_with("Enemy") and not enemy_name.contains("TankCrew") \
				and not enemy_name.contains("Vehicle") and float(node.hp) > 0.0:
			out.append(node)
	return out


func _alive_allies() -> Array:
	var out: Array = []
	for node in get_nodes_in_group("friendly"):
		if String(node.name).begins_with("Ally") and float(node.hp) > 0.0:
			out.append(node)
	return out


func _dead_enemy_names() -> Array:
	return []


func _enemies_engaged() -> int:
	var count := 0
	for node in get_nodes_in_group("enemy"):
		if int(node._state) == 1:
			count += 1
	return count


## 最近的队友离当前阶段目标多远（判断「有没有真的推进」的直读指标）
func _nearest_ally_distance() -> float:
	var zones: Array = _main.capture_zones
	if zones.is_empty():
		return -1.0
	var target := (zones[clampi(_phase, 0, zones.size() - 1)] as Node2D).global_position
	var best := 99999.0
	for node in get_nodes_from_friendly():
		best = minf(best, (node as Node2D).global_position.distance_to(target))
	return best if best < 99999.0 else -1.0


func _median(values: Array) -> float:
	if values.is_empty():
		return 0.0
	var sorted := values.duplicate()
	sorted.sort()
	return float(sorted[sorted.size() / 2])


func _p95(values: Array) -> float:
	if values.is_empty():
		return 0.0
	var sorted := values.duplicate()
	sorted.sort()
	return float(sorted[mini(int(float(sorted.size()) * 0.95), sorted.size() - 1)])
