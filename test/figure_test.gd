@tool
extends EditorScript

## 12.7.1 上下半身分离（候选 M · 第三轮）：Lower / Upper 结构、相位推进、姿态形状、玩家与敌人的接线
## 运行：脚本编辑器打开本文件 → 文件 → 运行；或 godot --headless --script res://tools/run_tests_headless.gd
## 纯规则与节点结构在这里测；「真跑一局时上半身是不是跟着准星转」跑在集成冒烟里。

const UnitFigureScript := preload("res://entities/visual/UnitFigure.gd")

var _passed := 0
var _failed := 0


func _run() -> void:
	_test_params()
	_test_phase_advance()
	_test_leg_offsets()
	_test_figure_node()
	_test_posture_shape()
	_test_player_figure()
	_test_enemy_figure()
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


func _test_params() -> void:
	_check("12.7.1：步频为正（相位推进速率）", GameConfig.FIGURE_STRIDE_HZ, 1.5)
	_check_true("12.7.1：敌我配色不同（沿用旧圆点色）",
			GameConfig.UNIT_COLOR_PLAYER != GameConfig.UNIT_COLOR_ENEMY)


## 相位：站着不动不推进、越快摆得越快、结果始终在 [0, TAU)
func _test_phase_advance() -> void:
	_check("相位：站着不动不推进", UnitFigureScript.phase_advance(0.0, 0.0, 0.5), 0.0)
	_check("相位：极慢也不推进（阈值 0.05）",
			UnitFigureScript.phase_advance(0.0, 0.04, 0.5), 0.0)
	var full := UnitFigureScript.phase_advance(0.0, 1.0, 0.5)
	_check("相位：全速 0.5 s 推进 TAU × 步频 × 0.5", full,
			fposmod(TAU * GameConfig.FIGURE_STRIDE_HZ * 0.5, TAU))
	var half := UnitFigureScript.phase_advance(0.0, 0.5, 0.5)
	_check_true("相位：半速推进得更少", half < full)
	_check_true("相位：永远落在 [0, TAU)",
			UnitFigureScript.phase_advance(TAU * 0.99, 1.0, 10.0) < TAU)
	_check("相位：速度比例被夹到 1（超速不会更快）",
			UnitFigureScript.phase_advance(0.0, 5.0, 0.5), full)


## 腿的摆动：一前一后、幅度有界
func _test_leg_offsets() -> void:
	_check("腿：相位 0 时左右腿重合（站立）", UnitFigureScript.leg_offsets(0.0), Vector2.ZERO)
	_check("腿：相位 π/2 时一前一后到极限",
			UnitFigureScript.leg_offsets(PI * 0.5), Vector2(1.0, -1.0))
	_check("腿：相位 3π/2 时反向",
			UnitFigureScript.leg_offsets(PI * 1.5), Vector2(-1.0, 1.0))
	var offsets := UnitFigureScript.leg_offsets(1.1)
	_check_true("腿：两条腿永远反向（和为零）",
			is_equal_approx(offsets.x + offsets.y, 0.0))
	_check_true("腿：幅度不超过 1",
			absf(offsets.x) <= 1.0 and absf(offsets.y) <= 1.0)


func _test_figure_node() -> void:
	var figure = UnitFigureScript.new()
	figure.setup_figure(0.4, GameConfig.UNIT_COLOR_PLAYER)
	_check_true("结构：生成了 Lower 子节点", figure.get_node_or_null("Lower") != null)
	_check_true("结构：生成了 Upper 子节点", figure.get_node_or_null("Upper") != null)
	_check("结构：Lower 就是 figure.lower", figure.get_node_or_null("Lower"), figure.lower)
	_check("结构：身体半径按调用方给的来", figure.body_radius, 0.4)
	_check("结构：颜色按调用方给的来", figure.body_color, GameConfig.UNIT_COLOR_PLAYER)
	# 注意：Node2D 的 rotation 存在变换里是 32 位浮点，不能拿 PI*0.5 精确比 —— 一律用近似比较
	figure.set_move(PI * 0.5, 1.0, 0.1)
	_check_true("结构：set_move 转动的是 Lower",
			is_equal_approx(figure.lower.rotation, PI * 0.5))
	_check_true("结构：Lower 的角度可读回",
			is_equal_approx(figure.lower_angle(), PI * 0.5))
	figure.set_aim(-PI * 0.5)
	_check_true("结构：set_aim 转动的是 Upper",
			is_equal_approx(figure.upper.rotation, -PI * 0.5))
	_check_true("结构：Upper 的角度可读回",
			is_equal_approx(figure.aim_angle(), -PI * 0.5))
	_check_true("结构：移动后相位真的推进了", figure.leg_phase > 0.0)
	figure.free()


## 姿态：站 1.0 / 蹲 0.85 / 卧 0.80 且身体拉长 1.5 倍（12.7.1「卧姿单独一套身体」的近似）
func _test_posture_shape() -> void:
	var figure = UnitFigureScript.new()
	figure.setup_figure(0.4, GameConfig.UNIT_COLOR_ENEMY)
	_check("姿态：默认站立缩放 1.0", figure.posture_scale(), 1.0)
	_check("姿态：站立不拉长", figure.body_length_scale(), 1.0)
	figure.set_posture(1)
	_check("姿态：蹲姿压低到 0.85", figure.posture_scale(), 0.85)
	figure.set_posture(2)
	_check("姿态：卧姿 0.80", figure.posture_scale(), 0.80)
	_check("姿态：卧姿身体拉长 1.5 倍", figure.body_length_scale(), 1.5)
	figure.set_posture(99)
	_check("姿态：越界被夹到卧姿", figure.posture, 2)
	figure.free()


func _test_player_figure() -> void:
	var player := PlayerUnit.new()
	player._build_visual()   # 裸 new 不跑 _ready，测试里手动建一次
	_check_true("玩家：角色图已建（Figure 节点）", player.get_node_or_null("Figure") != null)
	_check_true("玩家：Figure 下有 Lower / Upper",
			player.get_node_or_null("Figure/Lower") != null
			and player.get_node_or_null("Figure/Upper") != null)
	_check_true("玩家：角色图仍压在受击闪白之下（show_behind_parent）",
			bool(player._visual.show_behind_parent))
	_check("玩家：初始上半身朝右", player._visual.aim_angle(), 0.0)
	player.set_aim_direction(Vector2.UP)
	_check_true("玩家：推准星方向后上半身转过去（UP = -π/2）",
			is_equal_approx(player._visual.aim_angle(), Vector2.UP.angle()))
	player.set_aim_direction(Vector2.ZERO)
	_check_true("玩家：零向量不会把朝向搞坏",
			is_equal_approx(player._visual.aim_angle(), Vector2.UP.angle()))
	# 姿态切换要到点才生效，并且要同步到角色图
	player.switch_posture(PlayerUnit.Posture.PRONE)
	player.tick_timers(1.0)
	_check("玩家：切到卧姿后角色图跟着变", player._visual.posture, 2)
	_check("玩家：卧姿身体拉长", player._visual.body_length_scale(), 1.5)
	# 站住不动：相位不推进
	var phase_before: float = player._visual.leg_phase
	player.tick_timers(0.5)
	_check("玩家：站着不动相位不推进", player._visual.leg_phase, phase_before)
	# 走起来：相位推进
	player.velocity = Vector2.RIGHT * player.move_speed
	player.tick_timers(0.5)
	_check_true("玩家：走动时相位推进", player._visual.leg_phase != phase_before)
	player.free()


func _test_enemy_figure() -> void:
	var enemy := Enemy.new()
	enemy._build_visual()
	_check_true("敌人：角色图已建（Figure 节点）", enemy.get_node_or_null("Figure") != null)
	_check_true("敌人：Figure 下有 Lower / Upper",
			enemy.get_node_or_null("Figure/Lower") != null
			and enemy.get_node_or_null("Figure/Upper") != null)
	_check("敌人：用的是敌方配色", enemy._visual.body_color, GameConfig.UNIT_COLOR_ENEMY)
	enemy.free()
