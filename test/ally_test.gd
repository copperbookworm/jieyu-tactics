@tool
extends EditorScript

## 玩家队友测试 —— 使用者 2026-10-02；2026-10-07 第八十四版按 docx 19 ㊹ 重新配平
## 覆盖：编队 · **配平（战力比 / 与敌人共用精度基线）** · 倒地与补刀
const AllyScript := preload("res://entities/ally/Ally.gd")
const AiAccuracyScript := preload("res://systems/combat/AiAccuracy.gd")

var _passed := 0
var _failed := 0


func _run() -> void:
	_test_formation()
	_test_power()
	_test_shared_accuracy()
	_test_downed_and_finish_off()
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


func _test_formation() -> void:
	_check("编队：小队规模 = 3", GameConfig.ALLY_SQUAD_SIZE, 3)
	var a := AllyScript.formation_offset(0, 6.0)
	var b := AllyScript.formation_offset(1, 6.0)
	var c := AllyScript.formation_offset(2, 6.0)
	_check_true("编队：三人在玩家后方（x 分量为负）", a.x < 0.0 and b.x < 0.0 and c.x < 0.0)
	_check_true("编队：三个位置互不重合", a != b and b != c and a != c)
	_check_true("编队：间距都对（模长 = follow_distance）",
			is_equal_approx(a.length(), 6.0) and is_equal_approx(b.length(), 6.0)
			and is_equal_approx(c.length(), 6.0))
	_check_true("编队：0/1 号分列左右（y 符号相反）", a.y * b.y < 0.0)


## 敌人基线（Enemy.gd 的 @export 默认值）：写在这里当**参照值** —— 改敌人就得同步改这里，
## 否则「配平比」这条纪律会被悄悄绕过。敌人：血 100 / 一发 20 / 1.5 s 一发 / 2.0 m/s / 探测 120 m。
const ENEMY_HP := 100.0
const ENEMY_DAMAGE := 20.0
const ENEMY_INTERVAL := 1.5
const ENEMY_SPEED := 2.0
const ENEMY_DETECT := 120.0


## 单兵战力粗量 ≈ DPS × 血（Lanchester 的简化）：两个 AI 阵营之间够用了。
func _power(damage: float, interval: float, hp: float) -> float:
	return (damage / maxf(interval, 0.001)) * hp


## 2026-10-07 第八十四版 · docx 19 ㊹「20 v 20 压队友强度」。
## 配平前是「强力一档」（血 200 / 一发 45 / 0.35 s / 交战 220 m / 零散布）⇒ 单兵战力 ≈ 19×，
## 实测 130 s 推进**敌 20 → 2、友 19 → 19（零阵亡）**。配平后取「同一套基线 + 轻微友军优势」。
## ⚠ 这些数字是**配平结论**不是随手值：动它们必须重跑 tools/probe_balance.gd --push 并更新验收数字。
func _test_power() -> void:
	var ally := AllyScript.new()
	_check("配平：血 120（敌人 100 的 1.2 倍）", ally.max_hp, 120.0)
	_check("配平：一发 22（敌人 100 血 ⇒ 5 发带走）", ally.fire_damage, 22.0)
	_check("配平：1.3 s 一发（敌人 1.5 s）", ally.fire_interval, 1.3)
	_check("配平：跑 2.4 m/s（敌人 2.0）", ally.move_speed, 2.4)
	_check("配平：开火距离 150 m（敌人探测 120 m，留 30 m 接敌窗口）", ally.engage_range, 150.0)

	var ally_power := _power(ally.fire_damage, ally.fire_interval, ally.max_hp)
	var enemy_power := _power(ENEMY_DAMAGE, ENEMY_INTERVAL, ENEMY_HP)
	var ratio := ally_power / enemy_power
	_check_true("配平：单兵战力仍在敌人的 2 倍以内（配平前 ≈ 19×）", ratio < 2.0)
	_check_true("配平：仍略强于敌人（进攻方需要一档优势，不是被压到更弱）", ratio > 1.0)
	_check_true("配平：五发带走一个敌人（不再是一梭子秒杀）",
			ally.fire_damage * 5.0 >= GameConfig.SOLDIER_HP)
	_check_true("配平：两发打不掉敌人（避免又回到秒杀）",
			ally.fire_damage * 2.0 < GameConfig.SOLDIER_HP)
	_check_true("配平：比敌人跑得快（保留的那一档小优势）", ally.move_speed > ENEMY_SPEED)
	_check_true("配平：比敌人看得近的那一档优势收窄了（交战距离 < 220 m）",
			ally.engage_range < 220.0 and ally.engage_range > ENEMY_DETECT)
	ally.free()


## 双方 AI 共用同一条射击精度基线（2026-10-07 ㊹）：配平前**队友零散布必中、敌人 3 MOA** ——
## 这是「20 v 20 一边倒」里最大的一条不对称。公式收在 systems/combat/AiAccuracy.gd，两侧 preload 同一个。
func _test_shared_accuracy() -> void:
	_check("精度：共用常量 = 3 MOA", GameConfig.AI_BASE_MOA, 3.0)
	_check("精度：敌人的旧名字已指向共用常量", GameConfig.ENEMY_BASE_MOA, GameConfig.AI_BASE_MOA)
	_check_true("精度：不是零散布（零散布必中就是配平前的 bug）", AiAccuracyScript.base_spread_deg() > 0.0)
	_check("精度：3 MOA = 0.05°", AiAccuracyScript.base_spread_deg(), 0.05)

	var right := Vector2.RIGHT
	_check("精度：level = 0 不打偏（正中）", AiAccuracyScript.apply_base_spread(right, 0.0), right)
	var tilted := AiAccuracyScript.apply_base_spread(right, 1.0)
	_check_true("精度：level = 1 偏到最大（角度 > 0）", tilted.angle() > 0.0)
	_check_true("精度：偏角不超过基线（±0.05°）",
			absf(tilted.angle()) <= deg_to_rad(AiAccuracyScript.base_spread_deg()) + 0.0001)
	_check("精度：越界的 level 被夹住", AiAccuracyScript.apply_base_spread(right, 99.0), tilted)
	_check("精度：零向量原样返回（不产生 NaN）",
			AiAccuracyScript.apply_base_spread(Vector2.ZERO, 1.0), Vector2.ZERO)
	# 横向偏差 vs 命中半径 0.25 m：150 m（队友交战距离）打得中，600 m 会飘
	_check_true("精度：150 m 上的最大横向偏差仍小于命中半径（队友近战照样准）",
			AiAccuracyScript.max_lateral_m(150.0) < GameConfig.ENEMY_HIT_RADIUS)
	_check_true("精度：600 m 上会超过命中半径（远距离真的会飘）",
			AiAccuracyScript.max_lateral_m(600.0) > GameConfig.ENEMY_HIT_RADIUS)


func _test_downed_and_finish_off() -> void:
	var ally := AllyScript.new()
	ally._build_visual()
	ally.take_damage(ally.max_hp + 1.0)
	_check_true("队友：血打光是倒地（不是立刻阵亡）", ally.downed and ally.alive)
	_check_true("队友：倒地也躺平", ally._visual.downed)
	ally.take_damage(1.0)
	_check_true("队友：被补刀才阵亡", not ally.alive)
	var fresh := AllyScript.new()
	fresh.take_damage(10.0)
	_check("队友：挨打照常掉血（120 − 10）", fresh.hp, 110.0)
	fresh.free()
	ally.free()
