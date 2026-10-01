class_name MarkSystem
extends Node

## 报点 / 标记（docx 4.11.2 信息分层规则 + 4.11.7 确认稿）
## 三条红线：① 通视前提——落点由调用方给（Main 用准心世界坐标，准心已被地形钳制）
##          ② 最后目击位置——标记不跟随任何目标，就是个静态点
##          ③ 有时效——普通报点 30 s 后淡出；同类型近距离再次报点＝刷新，不堆叠
## 第一版不做：兵种差异（侦察兵 90 s）、权限分级（集结点只有小队长能放）、被标记者可见提示

signal mark_added(mark: Dictionary)
signal mark_expired(mark: Dictionary)

enum MarkType { ENEMY, VEHICLE, POSITION, SUPPLY, SMOKE, RALLY }

const TYPE_LABELS := ["敌人", "载具", "阵地", "补给", "烟雾", "集结点"]
const TYPE_COLORS := [
	Color(0.95, 0.30, 0.25),  # 敌人
	Color(0.95, 0.65, 0.20),  # 载具
	Color(0.55, 0.75, 1.00),  # 阵地
	Color(0.45, 0.90, 0.55),  # 补给
	Color(0.75, 0.75, 0.80),  # 烟雾
	Color(0.90, 0.85, 0.35),  # 集结点
]

var marks: Array = []


static func type_label(type: int) -> String:
	if type < 0 or type >= TYPE_LABELS.size():
		return "未知"
	return TYPE_LABELS[type]


static func type_color(type: int) -> Color:
	if type < 0 or type >= TYPE_COLORS.size():
		return Color.WHITE
	return TYPE_COLORS[type]


## 落一个标记；返回被试用的标记字典（刷新时会返回既有那条）
func add_mark(type: int, position: Vector2,
		duration: float = GameConfig.MARK_DURATION) -> Dictionary:
	for mark in marks:
		var existing: Vector2 = mark["position"]
		if mark["type"] == type \
				and existing.distance_to(position) <= GameConfig.MARK_REFRESH_RADIUS:
			mark["time_left"] = duration
			mark["duration"] = duration
			mark_added.emit(mark)
			return mark
	var mark := {"type": type, "position": position, "time_left": duration,
			"duration": duration}
	marks.append(mark)
	mark_added.emit(mark)
	return mark


func clear_all() -> void:
	marks.clear()


func _process(delta: float) -> void:
	var expired: Array = []
	for mark in marks:
		mark["time_left"] = float(mark["time_left"]) - delta
		if float(mark["time_left"]) <= 0.0:
			expired.append(mark)
	for mark in expired:
		marks.erase(mark)
		mark_expired.emit(mark)
