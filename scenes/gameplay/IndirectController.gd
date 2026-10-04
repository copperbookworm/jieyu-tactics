extends Node

## 间瞄链（2026-10-01 候选 L4 动工前从 Main.gd 拆出，腾出 Main 的 ≤400 行预算）
##
## 管三件事：① 建 IndirectFire 与落点预警层 ② 「间瞄」按钮 → 开图并切到选点模式
## ③ 地图选了落点 → 请求打一发；落弹后闪预警圈 + 提示
## Main 仍保留 indirect 字段（HUD 的兵种标签与小地图都要读它的余弹），由本模块 setup 时写回——
## 这样 HUD 侧一行都不用改。
## 刻意不写 class_name：引用方 preload（见 Cover.gd 头部说明）

const IndirectFireScript := preload("res://systems/combat/IndirectFire.gd")
const IndirectOverlayScript := preload("res://ui/IndirectOverlay.gd")
const Sfx := preload("res://systems/audio/Sfx.gd")

var main = null             # Main（鸭子类型）
var fire = null             # IndirectFire（动态类型：不标才不会卡未知成员）
var overlay = null          # IndirectOverlay


func setup(main_node, player, sight) -> void:
	main = main_node
	fire = IndirectFireScript.new()
	fire.name = "IndirectFire"
	main.add_child(fire)
	fire.setup(player, sight)
	# 间瞄是「那条炮」打出去的 ⇒ 对建筑的伤害取同一门炮的 gun_structure_damage
	# （155mm 自行火炮 = 420，见 data/vehicles_data.txt；GameConfig 里是同一档的兜底值）。
	# 2026-10-03 拍板：炮击**不吃开口规则**（按落点圈 ∩ footprint 结算，不管门窗）。
	fire.structure_damage = GameConfig.INDIRECT_STRUCTURE_DAMAGE
	fire.shell_landed.connect(_on_landed)
	overlay = IndirectOverlayScript.new()
	overlay.name = "IndirectOverlay"
	overlay.setup(fire)
	main.add_child(overlay)
	main.indirect = fire  # 中转给 HUD / 小地图（它们读 main.indirect）


## 间瞄按钮：开图 + 切到选点模式（docx 4.11.3）；落点由 TacticalMap 的信号回来
func request_targeting() -> void:
	if main.hud == null or main.hud.tactical_map == null or fire == null:
		return
	if not main.hud.tactical_map.is_open():
		main.hud.toggle_map()
	main.hud.tactical_map.indirect_mode = true
	main.hud.show_hint("间瞄选点：在地图上点落点（剩余 %d 发）" % fire.ammo)


## 地图选了落点 → 请求打一发
func on_map_target(target: Vector2) -> void:
	if fire == null:
		return
	if fire.fire_at(target):
		main.hud.show_hint("间瞄已发射（剩余 %d 发）" % fire.ammo)
		return
	if fire.ammo <= 0:
		main.hud.show_hint("间瞄弹药耗尽")
	elif fire.cooldown_left() > 0.0:
		main.hud.show_hint("间瞄冷却中：%.1f s" % fire.cooldown_left())
	else:
		main.hud.show_hint("落点超出间瞄射程（%.0f~%.0f m）"
				% [GameConfig.INDIRECT_MIN_RANGE, GameConfig.INDIRECT_MAX_RANGE])


## 落弹：预警圈闪一下 + 提示
func _on_landed(target: Vector2) -> void:
	if overlay != null:
		overlay.flash_at(target)
	if main.hud != null:
		main.hud.show_hint("间瞄命中")
		main.hud.push_feed("indirect", "间瞄落弹命中区域", Color(1.0, 0.6, 0.3))
	Sfx.play("explosion")       # 10 章：落弹爆炸
