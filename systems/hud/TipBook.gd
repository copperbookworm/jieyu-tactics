extends RefCounted

## 对局操作提示者 · 纯逻辑（docx 4.15「对局操作提示者」，候选 O 第一轮）
##
## 定位（4.15 原文）：上下文新手提示、非强制教程、事件驱动、一次性、可在设置关闭。
## 本文件只放规则，不放文案以外的任何表现；感知（读 Main/Player）在 ui/TipPanel.gd，
## 渲染也在那里，所以本文件可被 test/tips_test.gd 直接实例化断言。
##
## 四条规则：
##   ① 每条提示只弹一次（id 记进 _seen）
##   ② 两条提示之间至少隔 TIP_MIN_INTERVAL 秒（避免开场连环弹）
##   ③ 同一时刻只显示一条；期间来的提示进「待弹位」，只留最新一条（不排队刷屏）
##   ④ enabled 总开关（4.15「可在设置关闭」；第一版只有 API + GameConfig 默认值，设置界面后置）
##
## 刻意不写 class_name：引用方 preload（见 Cover.gd 头部说明）

## 触发 id → 文案。4.15 举例的五条里，四条在此；「集结点已放置」等集结点系统落地后补。
const TIPS := {
	"quest_updated": "任务已更新：按 M 或右侧「地图」查看目标",
	"terrain_block": "准星被地形遮挡（准星变橙）——往高处或换个方向",
	"smoke_enter": "你已进入烟雾区——你看不穿，敌人也看不见你",
	"vehicle_enter": "已上车：驾驶位开车，按「换座」到武器位才能开炮",
	"reload_empty": "弹匣打空：会自动换弹，空仓换弹比战术换弹慢",
	"suppressed": "你正被压制：准心在抖、散布变差——先找掩体",
	"low_hp": "血量过低：蹲（散布 ×0.75）或卧（×0.5）能减小命中面积",
}

var enabled := GameConfig.TIP_DEFAULT_ENABLED

var _seen := {}
var _active := {}
var _pending := {}
var _cooldown := 0.0


func set_enabled(value: bool) -> void:
	enabled = value
	if not enabled:
		_active = {}
		_pending = {}


## 请求一条提示。返回「这一帧就会显示」（便于单测与集成断言）。
func request(id: String) -> bool:
	if not enabled or _seen.has(id) or not TIPS.has(id):
		return false
	_seen[id] = true
	var item := {"id": id, "text": TIPS[id], "left": GameConfig.TIP_TTL}
	if _active.is_empty() and _cooldown <= 0.0:
		_active = item
		return true
	_pending = item
	return false


func tick(delta: float) -> void:
	if not _active.is_empty():
		_active["left"] = float(_active["left"]) - delta
		if float(_active["left"]) <= 0.0:
			_active = {}
			_cooldown = GameConfig.TIP_MIN_INTERVAL
		return
	_cooldown = maxf(_cooldown - delta, 0.0)
	if _cooldown <= 0.0 and not _pending.is_empty():
		_active = _pending
		_pending = {}


func current_text() -> String:
	return "" if _active.is_empty() else String(_active["text"])


func is_showing() -> bool:
	return not _active.is_empty()


func seen(id: String) -> bool:
	return _seen.has(id)


func seen_count() -> int:
	return _seen.size()


func pending() -> bool:
	return not _pending.is_empty()
