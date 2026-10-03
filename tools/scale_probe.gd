extends SceneTree

## 规模性能探针（godot-perf-profile A 路 + 自测的两条 CPU 口径）
##
## 为什么要它：技能的 scripts/perf_probe.gd 只按场景默认规模跑（2 敌 + 3 友），
## 而人数口径（docx 5.8）要 20 v 20 / 4P v 30E。本探针支持注入规模：
##   --enemies N   在 add_child **之前**写 Main.enemy_count（世界就按这个数建起来）
##   --allies N    建完后再补足 AI 队友到 N 名（Main 开局固定 3 名）
##
## ⚠ 两条口径说清楚（技能铁律 1）：
##   ① headless **没有渲染**，所以本探针一条 FPS 都不报。TIME_FPS / RENDER_* 这类 monitor
##      在 headless 下是 0，本探针不读它们、也不编数。
##   ② 主循环的墙钟间隔在 headless 下**不可信**：Godot 按物理步追赶真实时间，
##      帧比物理步快时很多帧根本不跑物理（而 AI 全在 _physics_process 里）⇒ 墙钟会被稀释。
##      所以**主口径是「脚本侧每帧 CPU 预算」**：手动把一帧该跑的钩子全跑一遍并计时
##      （main._process + 每个单位 _physics_process/_process），再按目标规模外推。
##   真机帧时间与 jank 仍必须走 dumpsys gfxinfo（B 路），两者不许互相顶替。
##
## 用法：
##   godot --headless --path . --log-file <可写路径> --script res://tools/scale_probe.gd \
##         -- --label=PVEVP --enemies=30 --allies=3 --frames=300

const DEF_SCENE := "res://scenes/gameplay/Main.tscn"
const SETTLE_FRAMES := 30
const WALL_FRAMES := 300
## 组件计时的重复次数（够摊掉计时开销，又不至于让探针自己把场景跑爆）
const BENCH_REPEAT := 150

var _scene := DEF_SCENE
var _enemies := -1          ## -1 = 用场景默认
var _allies := -1
var _label := "default"

var _main = null
var _frames := 0
var _prepared := false
var _done := false
var _last_usec := 0
var _deltas: Array = []
var _before := {}
var _after := {}


func _initialize() -> void:
	# 两种写法都吃：--enemies=30 与 --enemies 30
	var argv := OS.get_cmdline_user_args()
	var i := 0
	while i < argv.size():
		var a := String(argv[i])
		if a.begins_with("--"):
			var v := ""
			var step := 1
			if a.contains("="):
				var parts := a.split("=", true, 1)
				a = String(parts[0])
				if parts.size() > 1:
					v = String(parts[1])
			elif i + 1 < argv.size():
				v = String(argv[i + 1])
				step = 2
			if a == "--scene":
				_scene = v
			elif a == "--label":
				_label = v
			elif a == "--enemies":
				_enemies = int(v)
			elif a == "--allies":
				_allies = int(v)
			i += step
		else:
			i += 1
	print("===== 规模性能探针 [%s] enemies=%s allies=%s =====" % [_label, str(_enemies), str(_allies)])
	var packed: PackedScene = load(_scene)
	if packed == null:
		print("！！ 加载不到 %s" % _scene)
		quit(1)
		return
	_main = packed.instantiate()
	if _enemies >= 0:
		_main.enemy_count = _enemies
	root.add_child(_main)
	current_scene = _main
	# ⚠ 必须在**第一帧之前**就把双方开火伤害归零：30 个敌人一起打，玩家在 30 帧的稳定期里就会被打死，
	# 之后 Enemy._update_ai 因为 _player 无效而早退 —— 单价会从 ~750 µs 掉到 5 µs，
	# 外推出来的预算是假的（第一次跑就是这么被骗的）。队友的伤害同理：不然 19 个队友会把敌人打死。
	_freeze_combat()


func _process(_delta: float) -> bool:
	if _done:
		return true
	_frames += 1
	# ⚠ _initialize 里的 add_child **不会同步跑 _ready**（引擎排到首帧），所以那里冻火时敌人还没生成、
	# 等于没冻 —— 30 个敌人会在稳定期的 30 帧里把玩家打死，之后全员退回巡逻，单价从 ~130 µs 掉到 5 µs。
	# 所以冻火必须放在这里：第一帧 _ready 已经跑完。
	if _frames == 1:
		_freeze_combat()
	if not _prepared:
		if _frames < SETTLE_FRAMES:
			return false
		_prepare()
		return false
	var now := Time.get_ticks_usec()
	if _last_usec > 0:
		_deltas.append(float(now - _last_usec) / 1000.0)
	_last_usec = now
	if _deltas.size() >= WALL_FRAMES:
		_finish()
		return true
	return false


## 建规模 + 稳住负载：补足队友，并把**双方**的开火伤害归零
## （不归零的话 19 个队友会在采样窗口里把 20 个敌人打死 15 个 —— 第一次跑就踩到了，规模会缩水）
func _prepare() -> void:
	_prepared = true
	if _allies >= 0:
		var have := get_nodes_in_group("friendly").size()
		if _allies > have and _main.world != null:
			var extra := _allies - have
			var before_list := get_nodes_in_group("friendly").duplicate()
			_main.world._spawn_allies(_main, extra)
			var added: Array = []
			for n in get_nodes_in_group("friendly"):
				if not before_list.has(n):
					added.append(n)
			# 补出来的队友按圆周散开（_spawn_allies 从下标 0 重新编号，不散开会叠在头 3 个的位置上）
			for k in added.size():
				var node = added[k]
				if node == null or not is_instance_valid(node):
					continue
				var ang := TAU * float(k) / float(maxi(added.size(), 1))
				node.global_position = _main.player.global_position \
						+ Vector2(cos(ang), sin(ang)) * (26.0 + 7.0 * float(k))
	_freeze_combat()
	# 玩家可能已经在稳定期被打倒（就算只挨了几帧也够）：救回来，否则敌人 AI 会走「不补刀」分支退回巡逻
	if _main.player != null:
		_main.player.alive = true
		_main.player.downed = false
		_main.player.downed_time_left = 0.0
		_main.player.hp = GameConfig.SOLDIER_HP
		_main.player.suppression = 0.0
		if "input_locked" in _main.player:
			_main.player.input_locked = false
	_before = _snapshot()
	_last_usec = Time.get_ticks_usec()
	print("— 已就绪：敌人 %d / 队友 %d / 节点 %d" % [
			_live("enemy").size(), _live("friendly").size(),
			int(Performance.get_monitor(Performance.OBJECT_NODE_COUNT))])


func _freeze_combat() -> void:
	for e in get_nodes_in_group("enemy"):
		if "fire_damage" in e:
			e.fire_damage = 0.0
	for a in get_nodes_in_group("friendly"):
		if "fire_damage" in a:
			a.fire_damage = 0.0
	for v in get_nodes_in_group("vehicle"):
		if "ai_enabled" in v and v.ai_enabled:
			v.ai_enabled = false


## 只取还活着的：死掉的单位 _physics_process 会早退，拿它做微基准会得出「AI 只要 1.3 µs」的假数
func _live(group: String) -> Array:
	var out: Array = []
	for n in get_nodes_in_group(group):
		if n == null or not is_instance_valid(n):
			continue
		if "alive" in n and not bool(n.alive):
			continue
		out.append(n)
	return out


func _snapshot() -> Dictionary:
	return {
		"nodes": int(Performance.get_monitor(Performance.OBJECT_NODE_COUNT)),
		"objects": int(Performance.get_monitor(Performance.OBJECT_COUNT)),
		"orphans": int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT)),
		"mem_static": int(Performance.get_monitor(Performance.MEMORY_STATIC)),
		"mem_static_max": int(Performance.get_monitor(Performance.MEMORY_STATIC_MAX)),
		"enemies": _live("enemy").size(),
		"friendlies": _live("friendly").size(),
		"vehicles": get_nodes_in_group("vehicle").size(),
	}


func _percentile(sorted_ms: Array, p: float) -> float:
	if sorted_ms.is_empty():
		return 0.0
	return float(sorted_ms[clampi(int(round(float(sorted_ms.size() - 1) * p)), 0, sorted_ms.size() - 1)])


## 前 K 个活单位各自的一帧代价（µs）；不够 K 个就有几个算几个
func _unit_costs(units: Array, dt: float, with_process: bool) -> Array:
	var costs: Array = []
	for i in mini(units.size(), 8):
		var u = units[i]
		if u == null or not is_instance_valid(u):
			continue
		var c := _us_per(Callable(u, "_physics_process").bind(dt), BENCH_REPEAT)
		if with_process and u.has_method("_process"):
			c += _us_per(Callable(u, "_process").bind(dt), BENCH_REPEAT)
		costs.append(c)
	return costs


func _median(values: Array) -> float:
	if values.is_empty():
		return 0.0
	var s := values.duplicate()
	s.sort()
	return float(s[s.size() / 2])


func _max_of(values: Array) -> float:
	var m := 0.0
	for v in values:
		m = maxf(m, float(v))
	return m


func _us_per(callable: Callable, n: int) -> float:
	var t0 := Time.get_ticks_usec()
	for _i in n:
		callable.call()
	return float(Time.get_ticks_usec() - t0) / float(n)


## 脚本侧每帧 CPU 预算：把「一帧该跑的钩子」全跑 n 遍再除以 n。
## 单位数按**当前场景的实际活单位数**算，于是同一份代码可以直接外推到 20 v 20 / 4P v 30E。
func _bench() -> Dictionary:
	var out := {"unit_us": 0.0, "main_us": 0.0, "sight_us": 0.0,
			"pass_us": 0.0, "n_enemy": 0, "n_ally": 0, "n_vehicle": 0}
	var dt := 1.0 / 60.0
	var enemies := _live("enemy")
	var allies := _live("friendly")
	var vehicles := get_nodes_in_group("vehicle")
	out["n_enemy"] = enemies.size()
	out["n_ally"] = allies.size()
	out["n_vehicle"] = vehicles.size()
	# ① 逐单位计时：**不能只看 [0]** —— 单位的花费取决于它在什么状态
	# （巡逻态 _update_ai 早早返回 ≈ 6 µs；交战态要查通视 + 开火 ≈ 166 µs）。
	# 第一次跑就踩到了：不同规模下 [0] 恰好是不同的状态，单价差 30 倍，外推全是错的。
	# 所以取前 K 个活单位各自计时，报中位数（典型）与最大值（交战态 / 最坏）。
	# 把敌人拉到玩家附近，逼它们进交战态再计时：
	# 巡逻态单价约 5 µs、交战态约 750 µs，差两个数量级；拿巡逻态外推会得出「40 个单位很轻松」的假结论。
	if _main.player != null:
		for k in enemies.size():
			var en = enemies[k]
			if en != null and is_instance_valid(en):
				en.global_position = _main.player.global_position \
						+ Vector2(55.0 + 11.0 * float(k % 12), 16.0 * float(k / 12))
	var e_costs := _unit_costs(enemies, dt, true)
	var a_costs := _unit_costs(allies, dt, false)
	out["enemy_med"] = _median(e_costs)
	out["enemy_max"] = _max_of(e_costs)
	out["ally_med"] = _median(a_costs)
	out["ally_max"] = _max_of(a_costs)
	out["enemy_us"] = out["enemy_med"]
	out["ally_us"] = out["ally_med"]
	# ③ 一次通视查询（最底层的单价，能解释上面两个数为什么是这个量级）
	if _main.sight != null and _main.player != null:
		var f: Vector2 = _main.player.global_position
		var t: Vector2 = f + Vector2(180.0, 60.0)
		out["sight_us"] = _us_per(Callable(_main.sight, "has_sight").bind(
				f, _main.sight.eye_height_at(f), t, _main.sight.eye_height_at(t)), BENCH_REPEAT)
	# ④ HUD + 载具控制器（Main._process 的活）
	out["main_us"] = _us_per(Callable(_main, "_process").bind(dt), BENCH_REPEAT)
	# ⑤ 整帧一遍（把上面全加起来跑，摊掉逐次调用的开销）—— 这是主口径
	var t0 := Time.get_ticks_usec()
	for _i in 60:
		_main._process(dt)
		for e2 in enemies:
			e2._physics_process(dt)
			if e2.has_method("_process"):
				e2._process(dt)
		for a2 in allies:
			a2._physics_process(dt)
	out["pass_us"] = float(Time.get_ticks_usec() - t0) / 60.0
	return out


func _finish() -> void:
	_done = true
	var b := _bench()
	_after = _snapshot()
	var sorted_ms := _deltas.duplicate()
	sorted_ms.sort()
	var total := 0.0
	for v in sorted_ms:
		total += float(v)
	var mean := total / float(maxi(sorted_ms.size(), 1))
	var pass_ms := float(b["pass_us"]) / 1000.0
	print("【结果 %s】" % _label)
	print("  规模        : 敌 %d / 友 %d / 车 %d（采样窗口内活单位数）" % [
			_after["enemies"], _after["friendlies"], _after["vehicles"]])
	print("  节点/对象   : %d → %d 节点 / %d 对象（孤儿 %d）" % [
			_before["nodes"], _after["nodes"], _after["objects"], _after["orphans"]])
	print("  静态内存    : %.1f MB → %.1f MB（峰值 %.1f MB）" % [
			float(_before["mem_static"]) / 1048576.0, float(_after["mem_static"]) / 1048576.0,
			float(_after["mem_static_max"]) / 1048576.0])
	var e: int = int(_after["enemies"])
	var a: int = int(_after["friendlies"])
	var typical: float = float(b["main_us"]) + float(e) * float(b["enemy_med"]) + float(a) * float(b["ally_med"])
	var worst: float = float(b["main_us"]) + float(e) * float(b["enemy_max"]) + float(a) * float(b["ally_max"])
	print("  ★脚本侧每帧 : 实测 %.2f ms ｜ 典型外推 %.2f ms ｜ 最坏外推 %.2f ms（敌方 %d × 友方 %d）" % [
			pass_ms, typical / 1000.0, worst / 1000.0, e, a])
	print("  单价        : 通视 %.1f µs/次" % b["sight_us"])
	print("  敌人一帧    : 中位 %.0f µs / 最大 %.0f µs（巡逻态 → 交战态）" % [b["enemy_med"], b["enemy_max"]])
	print("  队友一帧    : 中位 %.0f µs / 最大 %.0f µs（队友常驻交战态，所以比敌人中位贵）" % [b["ally_med"], b["ally_max"]])
	print("  墙钟帧间隔  : 均值 %.2f ms / p50 %.2f / p90 %.2f / p99 %.2f（**仅供参考**：headless 按物理步追赶，很多帧不跑物理）" % [
			mean, _percentile(sorted_ms, 0.5), _percentile(sorted_ms, 0.9), _percentile(sorted_ms, 0.99)])
	print("  一帧预算占比: 实测 %.0f%% ｜ 典型 %.0f%% ｜ 最坏 %.0f%%（预算 16.67 ms，**不含物理引擎与渲染**）" % [
			pass_ms / 16.67 * 100.0, typical / 16670.0 * 100.0, worst / 16670.0 * 100.0])
	# 诊断：这几个字段直接决定 Enemy._update_ai 会不会早退
	# （ai_enabled=false 或 玩家 incapacitated ⇒ 退回巡逻，单价从 ~130 µs 掉到 ~5 µs）
	var p = _main.player
	var es := _live("enemy")
	var e0 = es[0] if not es.is_empty() else null
	print("  诊断        : 玩家 alive=%s downed=%s incapacitated=%s ｜ 样本敌 ai_enabled=%s state=%s" % [
			str(p.alive), str(p.downed),
			str(p.is_incapacitated() if p.has_method("is_incapacitated") else "n/a"),
			str(e0.ai_enabled if e0 != null and "ai_enabled" in e0 else "n/a"),
			str(int(e0._state) if e0 != null and "_state" in e0 else "n/a")])
	print("  ⚠ 本探针是 **debug 编辑器构建**：GDScript 未优化，绝对值偏悲观；看规模趋势与占比，不看绝对值")
	quit(0)
