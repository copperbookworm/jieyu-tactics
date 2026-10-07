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
## 每个节点停留多久再推进。默认 40 s 比**真实步行**快得多（节点间距 ~300 m、队友 2.4 m/s
## ⇒ 实际要 ~125 s），所以「守军走路增援」在这条时间线上永远来不及 —— 要量增援/集中就得
## 用 --dwell 150 把节奏调到与步行一致（第八十五版实测踩到，见 --with-player 的说明）。
const DEFAULT_NODE_DWELL := 40.0
var _node_dwell := DEFAULT_NODE_DWELL
const STAGE_DISTANCE := 50.0   # 队友送到节点外这个距离：出生点到 N1 有 197 m，纯走路要 ~60 s

var _main = null
var _elapsed := 0.0
var _total := 120.0
var _push := true
var _legacy := false
## --even：把双方拉成一排、在出生区平地**正面接触**（配平 A/B 专用，见 _even_redeploy 的说明）
var _even := false
## 正面对撞里战斗结束的时刻（一方归零），-1 = 没结束
var _battle_over := -1.0
## --with-player：推进时**玩家跟着走**（第八十五版新增）。
## 为什么必须要它：CaptureZone 只统计**玩家**（队友不算占领兵力）⇒ 玩家留在出生点时
## 没有任何节点会翻蓝、flag_state_changed 一次都不发 ⇒ 预备队支援 / 下一条防线集中
## 这些**旗点驱动的 AI 行为整段测不到**（第八十五版实测：探针完全看不见增援）。
## 代价（写在明处）：玩家不参战，但会被敌人当成目标之一 —— 所以本模式把玩家血量拉满（不参战、不阵亡）。
var _with_player := false
## 摆位要等**第一帧**再做：_initialize() 里 add_child 之后 Main._ready() 还没跑完
## （实测：那时 get_nodes_in_group 拿到 0 个单位，摆位静默落空 ⇒ 量出来的是原部署）
var _redeploy_pending := false
var _next_sample := 0.0
var _rows: Array = []
var _first_contact := -1.0
var _frame_ms: Array = []
var _last_us := 0
var _phase := -1
var _peak_units := 0
var _tag := ""


## 【2026-10-06 第七十九版·三】固定随机种子：敌人 AI 用的是**全局 randf()**（开火散布 / 可见性抖动 /
## 盲射判定），不固定种子的话同一配置两轮就能落在不同档（实测 40.1 s 与 81.3/82.1 s 首接触）⇒
## 任何 A/B 都做不出来。这里默认固定，并允许 `--seed N` 覆盖（要测"多局均值"时换种子跑多轮）。
const DEFAULT_SEED := 20261006

var _seed_value := DEFAULT_SEED


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	for i in args.size():
		match args[i]:
			"--seed":
				if i + 1 < args.size():
					_seed_value = int(args[i + 1])
			"--seconds":
				if i + 1 < args.size():
					_total = float(args[i + 1])
			"--push":
				_push = true
			"--stand":
				_push = false
			"--legacy":
				_legacy = true
			"--even":
				_even = true
			"--with-player":
				_with_player = true
			"--dwell":
				if i + 1 < args.size():
					_node_dwell = float(args[i + 1])
	seed(_seed_value)        # 全局 RNG：让整局可复现（见文件头注释）
	print("[平衡采样] 随机种子 = %d（--seed N 可换）" % _seed_value)
	MatchRulesScript.set_mode(ModeTableScript.Mode.PVP_RANKED)
	var enemies := int(ModeTableScript.value_of(ModeTableScript.Mode.PVP_RANKED, "enemy_count", 20))
	var scene: PackedScene = load("res://scenes/gameplay/Main.tscn")
	_main = scene.instantiate()
	_main.enemy_count = enemies
	root.add_child(_main)
	current_scene = _main
	if _even:
		_push = false          # 正面对撞不做节点推进（推进与「公平交换比」是两件事）
	# 摆位等第一帧（见 _redeploy_pending 的说明）；不做摆位就现在打抬头
	_redeploy_pending = _legacy or _even
	if not _redeploy_pending:
		_print_header(enemies)
	_last_us = Time.get_ticks_usec()


func _print_header(enemies: int) -> void:
	var mode_text := "正面对撞" if _even else ("推进" if _push else "站立")
	_tag = "%s · %s敌/%s友" % [mode_text, str(_alive_enemies().size() + _dead_enemy_names().size()),
			str(_alive_allies().size())]
	print("===== 平衡采样：%s · 脚本=%s · 旧部署=%s · 采样 %.0f s / 每 %.1f s ====="
			% [str(enemies), mode_text, str(_legacy), _total, SAMPLE_INTERVAL])
	if _with_player:
		print("[口径] --with-player：玩家随阶段推进（血量拉满＝不参战、不阵亡）——")
		print("       旗点只有玩家能翻，不带玩家这一段就完全测不到『预备队支援 / 下一条防线集中』。")
	print("t(s) | 敌存 | 友存 | 玩家hp | 敌方交战 | 阶段")


func _process(delta: float) -> bool:
	# 第一帧：等 Main._ready() 把单位都建好之后再摆位（否则摆位落空，测的是原部署）
	if _redeploy_pending:
		_redeploy_pending = false
		if _legacy:
			_legacy_redeploy()
		if _even:
			_even_redeploy()
		_print_header(int(ModeTableScript.value_of(ModeTableScript.Mode.PVP_RANKED, "enemy_count", 20)))
		_last_us = Time.get_ticks_usec()
		return false
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
	if _battle_over < 0.0 and _even \
			and (_alive_enemies().size() == 0 or _alive_allies().size() == 0):
		_battle_over = _elapsed
		print("—— 战斗结束：t=%.1f s（敌存 %d / 友存 %d）"
				% [_battle_over, _alive_enemies().size(), _alive_allies().size()])
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
	var index := mini(int(_elapsed / maxf(_node_dwell, 1.0)), zones.size() - 1)
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
	# --with-player：玩家也跟到节点上（旗点才会真的翻；血量拉满＝不参战也不阵亡，见字段注释）
	# ⚠ 必须放进**圈内**（CaptureZone 半径 15 m）：放到 STAGE_DISTANCE(50 m) 就等于没来，
	# 旗点照样不会翻（第八十五版第一次就踩了这个 —— 位移量用了「队友站位」那个参数）。
	if _with_player and _main.player != null:
		_main.player.global_position = target + Vector2(-6.0, 0.0)
		_main.player.hp = 1.0e9
		_main.player.downed = false
		_main.player.alive = true
	print("—— 阶段 %d：%d 名队友受令推进到 %s（t=%.1f s，敌存 %d / 友存 %d）"
			% [_phase + 1, staged, str(target), _elapsed, _alive_enemies().size(), _alive_allies().size()])


func get_nodes_from_friendly() -> Array:
	var out: Array = []
	for node in get_nodes_in_group("friendly"):
		if String(node.name).begins_with("Ally") and float(node.hp) > 0.0:
			out.append(node)
	return out


## 【2026-10-07 第八十四版 · ㊹ 配平 A/B 专用】--even：双方在出生区平地**正面接触**
##
## 为什么非要加它：默认的 --push 场景是「19 名队友打 3 名守军」（敌人按 RAAS 节点 3/3/3/3/3 驻守），
## 局部兵力 ≈ 6:1 ⇒ 单兵数值怎么调，清一个节点都只要一两秒，0.5 s 的采样根本分辨不出来。
## 实测（配平前后各跑一次 130 s 推进）：都是「敌 20 → 2~3」，差异落在噪声量级。
## 要回答「队友单兵战力现在到底是不是和敌人一个量级」，只有把局部兵力拉平再打。
func _even_redeploy() -> void:
	var center: Vector2 = _main.spawn_anchor
	if center == Vector2.ZERO and _main.player != null:
		center = _main.player.global_position
	# 玩家挪开：本探针量的是 AI 之间的交换比，玩家参战会污染结论
	if _main.player != null:
		_main.player.global_position = center + Vector2(0.0, 260.0)
	var allies := get_nodes_from_friendly()
	for i in allies.size():
		var pos: Vector2 = center + Vector2(-25.0, 0.0) + _even_offset(i)
		(allies[i] as Node2D).global_position = pos
		# 用组任务把队友钉在原地（order_active = false 时他们会掉头去追 260 m 外的玩家）
		allies[i].order_target = pos
		allies[i].order_active = true
	var enemies: Array = []
	for node in get_nodes_in_group("enemy"):
		var n := String(node.name)
		if n.begins_with("Enemy") and not n.contains("TankCrew") and not n.contains("Vehicle"):
			enemies.append(node)
	for i in enemies.size():
		var pos: Vector2 = center + Vector2(25.0, 0.0) + _even_offset(i)
		(enemies[i] as Node2D).global_position = pos
		# 钉住巡逻目标：不让它们在接敌前自己巡逻走开
		enemies[i].set_move_target(pos)
	print("[--even] 双方拉到出生区平地正面接触：友 %d vs 敌 %d（面距 50 m，玩家挪开 260 m）"
			% [allies.size(), enemies.size()])
	_los_selfcheck(allies, enemies)


## 摆完位立刻自检一次「到底看不看得见」：如果通视率为 0，这一轮量的就不是交换比，
## 而是「两队人隔着山头站着」——先把这件事钉死，别把噪声当结论。
func _los_selfcheck(allies: Array, enemies: Array) -> void:
	if allies.is_empty() or enemies.is_empty():
		return
	var seeing := 0
	var seen := 0
	for a in allies:
		for e in enemies:
			if _pair_sight(a, e):
				seeing += 1
				break
	for e in enemies:
		for a in allies:
			if _pair_sight(e, a):
				seen += 1
				break
	print("[--even] 通视自检：%d/%d 名队友至少看得见 1 个敌人；%d/%d 名敌人至少看得见 1 个队友"
			% [seeing, allies.size(), seen, enemies.size()])
	print("[--even] 首单位距离 %.1f m ｜ 出生锚点 %s ｜ 玩家 %s"
			% [(allies[0] as Node2D).global_position.distance_to((enemies[0] as Node2D).global_position),
			str(_main.spawn_anchor), str(_main.player.global_position)])


func _pair_sight(a, b) -> bool:
	if a == null or b == null or a._sight == null or a._grid == null:
		return false
	var origin: float = a._grid.sample_bilinear(a.global_position) + GameConfig.SOLDIER_EYE_HEIGHT
	return a._sight.has_sight(a.global_position, origin, b.global_position,
			a._sight.eye_height_at(b.global_position))


## 阵列偏移：7 列、列距 4 m、行距 4 m —— 40 个单位摊成 24 m × 12 m 的一片，双方面距 50 m
func _even_offset(index: int) -> Vector2:
	var col := index % 7
	var row := index / 7
	return Vector2(float(row) * 4.0, (float(col) - 3.0) * 4.0)


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
	# 正面对撞才打这行：血量合计能区分「真的在互相扣血」与「死的是别的原因」
	if _even:
		print("        └ 敌血 %.0f ｜ 友血 %.0f ｜ 有目标的队友 %d ｜ 有目标的敌人 %d"
				% [_total_hp("enemy"), _total_hp("friendly"),
				_with_target("friendly"), _with_target("enemy")])


## 某一组还活着的单位血量和
func _total_hp(group_name: String) -> float:
	var sum := 0.0
	for node in get_nodes_in_group(group_name):
		if bool(node.get("alive")):
			sum += float(node.get("hp"))
	return sum


## 某一组里「已经锁上目标」的单位数（锁上 = 会开火，而不是只在走路）
func _with_target(group_name: String) -> int:
	var count := 0
	for node in get_nodes_in_group(group_name):
		if bool(node.get("alive")) and node.get("_target") != null:
			count += 1
	return count


func _report() -> void:
	print("===== 汇总（%s · 旧部署=%s）=====" % [_tag, str(_legacy)])
	print("首接触时间：%s" % ("%.1f s" % _first_contact if _first_contact >= 0.0 else "未接触"))
	if _even:
		print("战斗结束（一方归零）：%s" % ("%.1f s" % _battle_over if _battle_over >= 0.0 else "未结束"))
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
