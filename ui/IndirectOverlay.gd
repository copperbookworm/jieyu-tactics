extends Node2D

## 间瞄落点预警（世界坐标）：外圈＝爆炸半径，内圈随剩余时间收缩（收缩到 0 就是落地）
## 命中瞬间闪一下白光，让玩家确认「打到了」
## 刻意不写 class_name：引用方用 preload + 动态变量声明（见 Cover.gd 头部说明）

var _fire = null              # IndirectFire（动态类型，不标注以免静态检查卡未知方法/属性）
var _flash_time := 0.0
var _flash_target := Vector2.ZERO


func setup(fire) -> void:
	_fire = fire


## 命中闪光（Main 连 IndirectFire.shell_landed 时调用）
func flash_at(target: Vector2) -> void:
	_flash_target = target
	_flash_time = 0.35


func _process(delta: float) -> void:
	if _flash_time > 0.0:
		_flash_time = maxf(_flash_time - delta, 0.0)
	queue_redraw()


func _draw() -> void:
	if _fire == null:
		return
	for shell in _fire.pending_shells():
		var target: Vector2 = shell["target"]
		# 只保留「落点级反馈」：外圈＝爆炸半径，内圈随剩余时间收缩（收缩到 0 就是落地）
		# 高抛弧线 / 弹丸飞行 / 影子这套弹道表现已于 2026-09-28 全部删除：
		# 2D 俯视下只能靠「高度换算成屏幕偏移」硬表达，玩家感受不到弹道意图，判定鸡肋
		var total := maxf(float(shell["total"]), 0.001)
		var left := clampf(float(shell["time_left"]) / total, 0.0, 1.0)
		draw_arc(target, GameConfig.INDIRECT_BLAST_RADIUS, 0.0, TAU, 48,
				Color(1.0, 0.55, 0.20, 0.75), 2.0)
		draw_arc(target, GameConfig.INDIRECT_BLAST_RADIUS * left, 0.0, TAU, 32,
				Color(1.0, 0.35, 0.15, 0.95), 3.0)
		draw_line(target + Vector2(-6.0, 0.0), target + Vector2(6.0, 0.0),
				Color(1.0, 0.80, 0.40, 0.90), 2.0)
		draw_line(target + Vector2(0.0, -6.0), target + Vector2(0.0, 6.0),
				Color(1.0, 0.80, 0.40, 0.90), 2.0)
	if _flash_time > 0.0:
		var alpha := _flash_time / 0.35
		draw_circle(_flash_target, GameConfig.INDIRECT_BLAST_RADIUS,
				Color(1.0, 0.75, 0.35, 0.45 * alpha))
