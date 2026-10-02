extends RefCounted

## 对局内战斗播报 · 纯逻辑（docx 4.14「对局内战斗播报」，候选 O 第一轮）
##
## 把「事件 → 播报行」拆成可单测的纯规则：同类合并、限频、时效、行数上限。
## 视图（ui/CombatFeedPanel.gd）只负责把它渲染成 HUD 上的几行彩色文字。
##
## 4.14 的两条硬要求落在这里：
##   ① 同类事件合并 —— FEED_MERGE_WINDOW 内再来同类事件不新增行，只把计数 +1 并续命
##   ② 频率控制 —— 逻辑条数上限 FEED_MAX_ENTRIES + 显示行数上限 FEED_MAX_LINES，避免刷屏
## 全部数值走 GameConfig（本项目的唯一数值出口）。
##
## 刻意不写 class_name：引用方 preload（见 Cover.gd 头部说明）

var _entries: Array[Dictionary] = []


## 记一条播报。kind 是同类合并的键；text 是给人看的文案；color 是行颜色。
func push(kind: String, text: String, color: Color = Color.WHITE,
		ttl: float = GameConfig.FEED_TTL) -> void:
	for entry in _entries:
		if String(entry["kind"]) == kind and float(entry["age"]) <= GameConfig.FEED_MERGE_WINDOW:
			entry["count"] = int(entry["count"]) + 1
			entry["age"] = 0.0
			entry["ttl"] = ttl
			return
	_entries.append({"kind": kind, "text": text, "color": color, "age": 0.0,
			"ttl": ttl, "count": 1})
	while _entries.size() > GameConfig.FEED_MAX_ENTRIES:
		_entries.pop_front()


## 推进时间：过期的播报丢掉
func tick(delta: float) -> void:
	if _entries.is_empty():
		return
	var alive: Array[Dictionary] = []
	for entry in _entries:
		entry["age"] = float(entry["age"]) + delta
		if float(entry["age"]) < float(entry["ttl"]):
			alive.append(entry)
	_entries = alive


## 当前该显示的行（新的在上，最多 FEED_MAX_LINES 行）。计数 > 1 时文案带 ×N。
func lines() -> Array[Dictionary]:
	var out: Array[Dictionary] = []
	var start: int = maxi(_entries.size() - GameConfig.FEED_MAX_LINES, 0)
	for i in range(_entries.size() - 1, start - 1, -1):
		var entry := _entries[i]
		var text := String(entry["text"])
		var count := int(entry["count"])
		if count > 1:
			text = "%s ×%d" % [text, count]
		out.append({"text": text, "color": entry["color"]})
	return out


## RichTextLabel 用的 BBCode：每行一个颜色
func to_bbcode() -> String:
	var parts: Array[String] = []
	for line in lines():
		var color: Color = line["color"]
		parts.append("[color=#%s]%s[/color]" % [color.to_html(false), String(line["text"])])
	return "\n".join(parts)


func size() -> int:
	return _entries.size()


func is_empty() -> bool:
	return _entries.is_empty()


func clear() -> void:
	_entries.clear()
