extends Node2D

## 敌方前进作战基地 FOB（docx 4.10.11 T-S2「摧毁敌方 FOB」的实体）
##
## 第一版只做三件事：
##   ① 是个大目标——自带 hit_radius()，子弹（BallisticsSystem 按目标半径算）、车载炮、间瞄爆炸都能打
##   ② 有结构值，打光即摧毁（GameConfig.FOB_MAX_HP）
##   ③ 摧毁时发 wrecked 信号，任务系统订阅它推进 T-S2
## 「暴露」判定不在本文件：QuestSystem 要求 FOB 附近有未过期的阵地/补给报点（官方触发条件：
## 「敌方 FOB 被标记暴露」），所以它必须先被侦察到、再被打掉。
## 刻意不写 class_name：引用方用 preload（见 Cover.gd 头部说明）

signal wrecked(fob: Node2D)

@export var friendly := false
@export var max_hp := GameConfig.FOB_MAX_HP

var hp := GameConfig.FOB_MAX_HP
var destroyed := false
## 是否已被我方侦察到（2026-10-01 ④）。
## docx 4.11.2 红线：敌方单位默认不上地图，只有被己方目击并报点后才出现。
## QuestSystem 判「FOB 被标记暴露」（附近有未过期的阵地 / 补给报点）成立时调 mark_revealed() 置位；
## 工事不会移动，所以暴露一次就长显——等于「最后目击位置」永久有效。
var revealed := false


func _ready() -> void:
	hp = max_hp
	add_to_group("fob")
	if not friendly:
		add_to_group("fob_enemy")


## 被我方侦察到（幂等；地图图层据此决定要不要画它）
func mark_revealed() -> void:
	if revealed:
		return
	revealed = true
	queue_redraw()


## 地图图层判据：暴露过、或者已经被打掉（自己打掉的当然知道在哪）
func is_known_to_player() -> bool:
	return revealed or destroyed


## 弹道命中半径（大工事：3 m，不是步兵的 0.25 m）
func hit_radius() -> float:
	return GameConfig.FOB_HIT_RADIUS


func take_damage(amount: float) -> void:
	if destroyed or amount <= 0.0:
		return
	hp = maxf(hp - amount, 0.0)
	if hp <= 0.0:
		destroyed = true
		wrecked.emit(self)
	queue_redraw()


func is_destroyed() -> bool:
	return destroyed


func health_ratio() -> float:
	return hp / maxf(max_hp, 0.001)


func _draw() -> void:
	var rect := Rect2(-GameConfig.FOB_HALF_X, -GameConfig.FOB_HALF_Y,
			GameConfig.FOB_HALF_X * 2.0, GameConfig.FOB_HALF_Y * 2.0)
	if destroyed:
		# 残骸：半透明焦黑，明确表示「这里已经不再是目标」
		draw_rect(rect, Color(0.18, 0.15, 0.13, 0.55))
		draw_rect(rect, Color(0.35, 0.30, 0.26, 0.55), false, 2.0)
		return
	# 受损越重越暗（满耐久暗红工事，打光成焦褐）
	var life := health_ratio()
	var body := Color(0.45, 0.22, 0.20, 0.95).lerp(Color(0.26, 0.16, 0.14, 0.95), 1.0 - life)
	draw_rect(rect, body)
	# 沙袋墙 + 顶部白色识别条（工事感；与载具/掩体的画法区分开）
	draw_rect(rect.grow(-2.0), Color(0.62, 0.55, 0.42, 0.85), false, 2.0)
	draw_rect(Rect2(-2.0, -GameConfig.FOB_HALF_Y - 4.0, 4.0, 3.0), Color(0.95, 0.9, 0.75, 0.95))
	# 耐久条：挨过打才显示
	if life < 0.999:
		var bar := Rect2(Vector2(-GameConfig.FOB_HALF_X, -GameConfig.FOB_HALF_Y - 9.0),
				Vector2(GameConfig.FOB_HALF_X * 2.0, 3.0))
		draw_rect(bar, Color(0.0, 0.0, 0.0, 0.45))
		draw_rect(Rect2(bar.position, Vector2(bar.size.x * life, bar.size.y)),
				Color(0.90, 0.35, 0.30, 0.95))
