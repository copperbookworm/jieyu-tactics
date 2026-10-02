@tool
extends EditorScript

## 玩家队友（3 名强力版）测试 —— 使用者 2026-10-02
const AllyScript := preload("res://entities/ally/Ally.gd")

var _passed := 0
var _failed := 0


func _run() -> void:
	_test_formation()
	_test_power()
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


func _test_power() -> void:
	var ally := AllyScript.new()
	_check("强力：血 200（敌人 100 的两倍）", ally.max_hp, 200.0)
	_check("强力：一发 45（敌人 100 血 ⇒ 3 发带走）", ally.fire_damage, 45.0)
	_check("强力：0.35 s 一发（敌人 1.5 s）", ally.fire_interval, 0.35)
	_check_true("强力：比敌人跑得快（3.4 > 2.0）", ally.move_speed > 2.0)
	_check_true("强力：一梭子三发就能打死一个敌人",
			ally.fire_damage * 3.0 >= GameConfig.SOLDIER_HP)
	ally.free()


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
	_check("队友：挨打照常掉血", fresh.hp, 190.0)
	fresh.free()
	ally.free()
