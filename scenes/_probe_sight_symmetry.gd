extends Node

## 【临时 · 通视方向对称性探针】跑完可删（2026-10-06 · 第七十七版）
##
## 为什么要有它：施工单 `改动1.md` §5 的 A 改动（显隐复用 AI 已算出的通视结果）建立在
## 「`_update_visibility` 里的 `has_sight(玩家→敌)` 与 `_can_see(_player)` 里的 `core(敌→玩家)`
## 是同一个谓词、只差新鲜度」之上。但 `SightSystem.terrain_first_blocker` 第 81 行是
## `for i in range(1, cells.size())` —— **跳过起点格**，于是两个方向跳过的是**不同的格子**
## （玩家所在格 vs 敌人所在格）⇒ 等价性存在边界反例。
##
## 本探针把"到底差多少"量出来，而不是靠推理下结论。
## 判据：① 真实单位对（玩家 ↔ 每个活敌）② 随机对（±60 m、随机眼高），两个方向各算一次。
##
## 用法：godot --headless --path <proj> res://scenes/_probe_sight_symmetry.tscn

const ModeTableScript := preload("res://data/config/ModeTable.gd")
const MatchRulesScript := preload("res://systems/match/MatchRules.gd")

const WARMUP_S := 4.0
const SAMPLES := 6            # 每轮采样间隔（秒）；采 SAMPLES 轮后出结论
const RANDOM_PAIRS := 4000    # 每轮随机对数量

var _main: Node = null
var _t := 0.0
var _tick := 0
var _pair_total := 0
var _pair_bad := 0
var _rand_total := 0
var _rand_bad := 0
var _rand_core_bad := 0
var _examples: Array = []


func _ready() -> void:
	MatchRulesScript.set_mode(ModeTableScript.Mode.PVP_CASUAL)
	var packed: PackedScene = load("res://scenes/gameplay/Main.tscn")
	_main = packed.instantiate()
	_main.enemy_count = ModeTableScript.enemy_count(ModeTableScript.Mode.PVP_CASUAL)
	add_child(_main)
	print("[通视对称性] 起对局：敌人 %d、队友 %d｜预热 %.0fs 后采 %d 轮" % [
			_main.enemy_count, MatchRulesScript.ally_count(), WARMUP_S, SAMPLES])


func _process(delta: float) -> void:
	_t += delta
	if _t < WARMUP_S:
		return
	if _tick >= SAMPLES:
		_finish()
		return
	_tick += 1
	_t = 0.0
	_sample()


func _alive_of(group: String) -> Array:
	var out: Array = []
	for n in get_tree().get_nodes_in_group(group):
		if not is_instance_valid(n):
			continue
		if n.get("alive") == false:
			continue
		out.append(n)
	return out


func _sample() -> void:
	var sight = _main.sight
	if sight == null or sight.grid == null:
		return
	var player = _main.player
	if player == null or not is_instance_valid(player):
		return
	var hp: float = float(sight.unit_sight_height(player.global_position, player))
	var pp: Vector2 = player.global_position

	# ① 真实单位对：玩家 ↔ 每个活着的敌人（这正是 A 要复用的那一对）
	for e in _alive_of("enemy"):
		var ep: Vector2 = e.global_position
		var he: float = float(sight.eye_height_at(ep))
		var a: bool = bool(sight.has_sight(pp, hp, ep, he))   # 玩家 → 敌（_update_visibility 用的方向）
		var b: bool = bool(sight.has_sight(ep, he, pp, hp))   # 敌 → 玩家（_can_see 用的方向）
		_pair_total += 1
		if a != b:
			_pair_bad += 1
			if _examples.size() < 4:
				_examples.append("真实对 P=(%.1f,%.1f,眼%.2f) E=(%.1f,%.1f,眼%.2f) P→E=%s E→P=%s" % [
						pp.x, pp.y, hp, ep.x, ep.y, he, str(a), str(b)])

	# ② 随机对：样本大得多，用来估"边界反例"的出现频率
	var rng := RandomNumberGenerator.new()
	rng.seed = 20261006 + _tick
	for i in RANDOM_PAIRS:
		var ap: Vector2 = pp + Vector2(rng.randf_range(-60.0, 60.0), rng.randf_range(-60.0, 60.0))
		var bp: Vector2 = pp + Vector2(rng.randf_range(-60.0, 60.0), rng.randf_range(-60.0, 60.0))
		var ah: float = float(sight.eye_height_at(ap)) + rng.randf_range(-0.4, 0.4)
		var bh: float = float(sight.eye_height_at(bp)) + rng.randf_range(-0.4, 0.4)
		var f: bool = bool(sight.has_sight(ap, ah, bp, bh))
		var r: bool = bool(sight.has_sight(bp, bh, ap, ah))
		_rand_total += 1
		if f != r:
			_rand_bad += 1
			if _examples.size() < 10:
				_examples.append("随机对 A=(%.1f,%.1f,h%.2f) B=(%.1f,%.1f,h%.2f) A→B=%s B→A=%s" % [
						ap.x, ap.y, ah, bp.x, bp.y, bh, str(f), str(r)])
		var cf: bool = bool(sight.sight_core(ap, ah, bp, bh))
		var cr: bool = bool(sight.sight_core(bp, bh, ap, ah))
		if cf != cr:
			_rand_core_bad += 1


func _finish() -> void:
	print("[通视对称性·结论]")
	if _pair_total > 0:
		print("  ① 真实单位对（玩家 ↔ 活敌）：%d 对，方向不等价 **%d 对（%.1f%%）**" % [
				_pair_total, _pair_bad, 100.0 * float(_pair_bad) / float(_pair_total)])
	if _rand_total > 0:
		print("  ② 随机对（±60 m、随机眼高）：%d 对" % _rand_total)
		print("     has_sight 方向不等价 **%d 对（%.2f%%）**｜sight_core 不等价 %d 对（%.2f%%）" % [
				_rand_bad, 100.0 * float(_rand_bad) / float(_rand_total),
				_rand_core_bad, 100.0 * float(_rand_core_bad) / float(_rand_total)])
	for ex in _examples:
		print("    " + str(ex))
	if _pair_bad == 0 and _rand_bad == 0:
		print("  ⇒ 两个方向经验上等价：A 改动的前提成立")
	else:
		print("  ⇒ **不等价**：A（把 core(敌→玩家) 当 has_sight(玩家→敌) 用）会改变显隐结果，不能按原方案做")
	get_tree().quit(0)
