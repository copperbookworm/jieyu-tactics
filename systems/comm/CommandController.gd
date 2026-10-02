extends Node

## 快捷指令执行链（docx 4.13，候选 O 第二轮）
##
## 流程：轮盘选指令 → 冷却校验 → 落点类指令走 MarkController 落成真实标记（通视红线与时效都在那边，
## 所以小地图 / 战术地图 / 主视图天然会画）→ 无论哪类都往 4.14 的战斗播报塞一行。
##
## 由 MarkController 创建并持有：报点与快捷指令同属「局内沟通」一条链（4.13 原文把两者并列），
## 这样 Main 不必再多一个子模块（Main 的 ≤400 行是硬验收线）。
## 刻意不写 class_name：引用方 preload（见 Cover.gd 头部说明）

const CommandBookScript := preload("res://systems/comm/CommandBook.gd")

const FEED_COLOR := Color(1.0, 0.85, 0.4)

var main = null
var book = null


func setup(main_node) -> void:
	main = main_node
	book = CommandBookScript.new()


## 冷却推进：挂 _process 而不是让 Main/HUD 每帧来 tick，指令链与战局解耦
func _process(delta: float) -> void:
	if book != null:
		book.tick(delta)


## 发送一条指令；返回「这次真的发出去了吗」（冷却中为 false）
func send(id: String) -> bool:
	if book == null or main == null:
		return false
	if not CommandBookScript.has(id):
		return false
	if not book.ready(id):
		if main.hud != null:
			main.hud.show_hint("指令冷却中：%.1f s"
					% maxf(book.remaining(id), book.global_remaining()))
		return false
	book.send(id)
	var label := CommandBookScript.label_of(id)
	var mark_type := CommandBookScript.mark_type_of(id)
	if mark_type != CommandBookScript.MARK_NONE and main.mark_ctl != null:
		# 落点类指令：交给报点体系（落点＝准心、通视红线、兵种时效一次到位）
		main.mark_ctl.place_at_crosshair(mark_type)
	else:
		main.hud.show_hint("指令：%s" % label)
	if main.hud != null:
		main.hud.push_feed("command", "指令：%s" % label, FEED_COLOR)
	return true


func remaining(id: String) -> float:
	return 0.0 if book == null else book.remaining(id)
