extends SceneTree

## 【P2 决策探针 · 2026-10-06 第七十九版】通视（has_sight）能不能并行？
##
## 背景：SightSystem 有两处**实例级共享寄存器**（_dda_cells / _occluder_cache），
## 所以唯一安全的并行形态是「每个 worker 自己持一个实例」。本探针量两件事：
##   ① **地形层**（纯网格数据，terrain_first_blocker）—— 并行理论上可行；
##   ② **完整 has_sight**（含掩体层）—— 掩体层要读 Node2D.global_position，
##      而引擎的线程安全检查禁止主线程之外访问 Node ⇒ 并行形态会被引擎直接拒掉。
##
## 口径：桌面 headless、debug、**真实 Main.tscn**（真地形 + 真掩体），顺序与并行跑同一批查询并逐条比对。
## 用法：godot --headless --path . --log-file <可写路径> --script res://tools/probe_sight_parallel.gd

const WARMUP_FRAMES := 8
const QUERY_COUNT := 400

var _main = null
var _frames := 0
var _sight = null
var _queries: Array = []
var _sequential := PackedByteArray()
var _parallel := PackedByteArray()
var _sights: Array = []
var _bands := 1
var _out := PackedByteArray()
var _use_full := false


func _initialize() -> void:
	var packed: PackedScene = load("res://scenes/gameplay/Main.tscn")
	if packed == null:
		print("！！ 加载不到 Main.tscn")
		quit(1)
		return
	_main = packed.instantiate()
	root.add_child(_main)
	current_scene = _main


func _process(_delta: float) -> bool:
	_frames += 1
	if _frames < WARMUP_FRAMES:
		return false
	_build_queries()
	_compare(false, "地形层（纯网格，无 Node 访问）")
	_compare(true, "完整 has_sight（含掩体层）")
	quit(0)
	return true


func _build_queries() -> void:
	_sight = _main.sight
	var units: Array = []
	if _main.player != null:
		units.append(_main.player)
	for n in get_nodes_in_group("enemy"):
		units.append(n)
	for n in get_nodes_in_group("friendly"):
		units.append(n)
	if _sight == null or units.size() < 2:
		print("！！ 场景没准备好（sight=%s units=%d）" % [str(_sight), units.size()])
		quit(1)
		return
	print("[通视并行] 单位=%d 掩体=%d 查询=%d cpu=%d" % [
			units.size(), get_nodes_in_group("occluder").size(), QUERY_COUNT,
			OS.get_processor_count()])
	for i in QUERY_COUNT:
		var a = units[i % units.size()]
		var b = units[(i * 7 + 3) % units.size()]
		if a == b:
			b = units[(i + 1) % units.size()]
		var pa: Vector2 = a.global_position
		var pb: Vector2 = b.global_position
		_queries.append({
			"origin": pa, "target": pb,
			"oh": _sight.unit_sight_height(pa, a),
			"th": _sight.unit_sight_height(pb, b),
		})


func _one(s, q: Dictionary) -> bool:
	if _use_full:
		return s.has_sight(q["origin"], q["oh"], q["target"], q["th"])
	return s.terrain_first_blocker(q["origin"], q["oh"], q["target"], q["th"], 0.0)["blocked"]


func _compare(full: bool, label: String) -> void:
	_use_full = full
	_sequential = PackedByteArray()
	_sequential.resize(_queries.size())
	var t := Time.get_ticks_usec()
	for i in _queries.size():
		_sequential[i] = 1 if _one(_sight, _queries[i]) else 0
	var seq_ms := float(Time.get_ticks_usec() - t) / 1000.0
	_bands = clampi(OS.get_processor_count() - 1, 2, 12)
	_sights = []
	for i in _bands:
		_sights.append(SightSystem.new(_main.grid))
	_out = PackedByteArray()
	_out.resize(_queries.size())
	var id0 := WorkerThreadPool.add_group_task(
			func(band: int) -> void: _band(band), _bands, _bands, true, "sight")
	WorkerThreadPool.wait_for_group_task_completion(id0)
	_out = PackedByteArray()
	_out.resize(_queries.size())
	t = Time.get_ticks_usec()
	var id := WorkerThreadPool.add_group_task(
			func(band: int) -> void: _band(band), _bands, _bands, true, "sight")
	WorkerThreadPool.wait_for_group_task_completion(id)
	var par_ms := float(Time.get_ticks_usec() - t) / 1000.0
	var mismatch := 0
	var first_bad := -1
	for i in _sequential.size():
		if _sequential[i] != _out[i]:
			mismatch += 1
			if first_bad < 0:
				first_bad = i
	print("[通视并行] %s：顺序 %.1f ms（%.1f µs/条）| %d 块并行 %.1f ms（%.1f µs/条）| 缩放 %.2fx | 逐条不一致 %d/%d%s" % [
			label, seq_ms, seq_ms * 1000.0 / float(_queries.size()),
			_bands, par_ms, par_ms * 1000.0 / float(_queries.size()),
			seq_ms / maxf(par_ms, 0.001), mismatch, _queries.size(),
			"" if first_bad < 0 else "（首个不一致 #%d）" % first_bad])


func _band(band: int) -> void:
	var per := int(ceil(float(_queries.size()) / float(_bands)))
	var i0 := band * per
	var i1 := mini(i0 + per, _queries.size())
	var s = _sights[band]
	for i in range(i0, i1):
		_out[i] = 1 if _one(s, _queries[i]) else 0
