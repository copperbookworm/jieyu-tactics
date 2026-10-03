extends RefCounted

## AI 参谋 —— 本地用量账本（纯逻辑 + 文件读写，无 autoload 依赖）
##
## 存哪：<base_dir>/YYYY-MM.jsonl，一行一条。
## 为什么 JSONL 不用 SQLite：追加写天然抗崩溃、最坏只坏一行、玩家能自己用文本编辑器看，
## 而且不必为一张账本引入原生扩展（本工程此前没有任何 user:// 持久化，这是第一处）。
## 读时逐行解析，坏行跳过 —— 一行脏数据不该把整本账读废。
## 刻意不写 class_name：引用方 preload。

const DEFAULT_DIR := "user://ai_usage"

var base_dir := DEFAULT_DIR


func _init(dir := DEFAULT_DIR) -> void:
	base_dir = dir


func ensure_dir() -> bool:
	if DirAccess.dir_exists_absolute(base_dir):
		return true
	return DirAccess.make_dir_recursive_absolute(base_dir) == OK


## 从 iso 串（YYYY-MM-DDTHH:MM:SS）取月份桶 —— 用本地日期分桶，跟玩家感知一致
static func month_key_from_iso(iso: String) -> String:
	if iso.length() < 7:
		return "0000-00"
	return iso.substr(0, 7)


func path_for_month(key: String) -> String:
	return base_dir.path_join(key + ".jsonl")


## 记一条。缺的字段补默认值；返回落盘后的完整记录（调用方拿去显示）。
func record(entry: Dictionary) -> Dictionary:
	var e: Dictionary = entry.duplicate(true)
	var ts := int(e.get("ts", int(Time.get_unix_time_from_system())))
	e["ts"] = ts
	if String(e.get("iso", "")) == "":
		e["iso"] = Time.get_datetime_string_from_system(false, false)
	var defaults := {
		"id": "%d-%d" % [ts, Time.get_ticks_usec()],
		"provider": "", "model": "", "purpose": "", "phase": "",
		"prompt_tokens": 0, "completion_tokens": 0, "cached_tokens": 0,
		"reasoning_tokens": 0, "total_tokens": 0,
		"est_cost_micros": -1, "currency": "", "price_version": 0, "price_tier": "",
		"latency_ms": 0, "http_status": 0, "status": "ok",
		"error_code": "", "error_message": "", "retry_count": 0,
	}
	for k in defaults.keys():
		if not e.has(k):
			e[k] = defaults[k]
	if int(e["total_tokens"]) == 0:
		e["total_tokens"] = int(e["prompt_tokens"]) + int(e["completion_tokens"])
	ensure_dir()
	var path := path_for_month(month_key_from_iso(String(e["iso"])))
	var f := FileAccess.open(path, FileAccess.READ_WRITE)
	if f == null:
		f = FileAccess.open(path, FileAccess.WRITE)
	if f == null:
		e["_write_error"] = FileAccess.get_open_error()
		return e
	f.seek_end()
	f.store_line(JSON.stringify(e))
	f.close()
	return e


func load_month(key: String) -> Array:
	var out: Array = []
	var path := path_for_month(key)
	if not FileAccess.file_exists(path):
		return out
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		return out
	while not f.eof_reached():
		var line := f.get_line().strip_edges()
		if line == "":
			continue
		var parsed: Variant = _parse_json_line(line)
		if typeof(parsed) == TYPE_DICTIONARY:
			out.append(parsed)
		# 坏行跳过：一行脏数据不该把整本账读废
	f.close()
	return out


## 用 JSON.new().parse() 而不是 JSON.parse_string()：坏行只跳过，不往控制台刷 ERROR
static func _parse_json_line(line: String) -> Variant:
	var j := JSON.new()
	if j.parse(line) != OK:
		return null
	return j.data


## 全部记录，按 ts 升序（月份文件名本身有序）
func load_all() -> Array:
	var out: Array = []
	if not DirAccess.dir_exists_absolute(base_dir):
		return out
	var dir := DirAccess.open(base_dir)
	if dir == null:
		return out
	var names := dir.get_files()
	names.sort()
	for name in names:
		if name.ends_with(".jsonl"):
			out.append_array(load_month(name.get_basename()))
	return out


func clear() -> int:
	var removed := 0
	if not DirAccess.dir_exists_absolute(base_dir):
		return removed
	var dir := DirAccess.open(base_dir)
	if dir == null:
		return removed
	for name in dir.get_files():
		if name.ends_with(".jsonl") and dir.remove(name) == OK:
			removed += 1
	return removed


## 汇总。金额按币种分开装（{currency: micros}）—— 不同币种不能相加，混在一起毫无意义。
func aggregate(entries: Array) -> Dictionary:
	var agg := {
		"calls": 0, "failed": 0, "unknown_price": 0,
		"prompt_tokens": 0, "completion_tokens": 0, "cached_tokens": 0, "total_tokens": 0,
		"cost": {}, "by_day": {}, "by_model": {}, "by_purpose": {}, "by_session": {},
	}
	for raw in entries:
		if typeof(raw) != TYPE_DICTIONARY:
			continue
		var e: Dictionary = raw
		agg["calls"] = int(agg["calls"]) + 1
		if String(e.get("status", "ok")) != "ok":
			agg["failed"] = int(agg["failed"]) + 1
		var prompt := int(e.get("prompt_tokens", 0))
		var completion := int(e.get("completion_tokens", 0))
		var cached := int(e.get("cached_tokens", 0))
		var total := int(e.get("total_tokens", prompt + completion))
		agg["prompt_tokens"] = int(agg["prompt_tokens"]) + prompt
		agg["completion_tokens"] = int(agg["completion_tokens"]) + completion
		agg["cached_tokens"] = int(agg["cached_tokens"]) + cached
		agg["total_tokens"] = int(agg["total_tokens"]) + total
		var micros := int(e.get("est_cost_micros", -1))
		var currency := String(e.get("currency", ""))
		if micros < 0:
			agg["unknown_price"] = int(agg["unknown_price"]) + 1
		else:
			var cost: Dictionary = agg["cost"]
			cost[currency] = int(cost.get(currency, 0)) + micros
			agg["cost"] = cost
		var day := String(e.get("iso", "")).substr(0, 10)
		_bump(agg["by_day"], day, total, micros, currency)
		_bump(agg["by_model"], String(e.get("model", "")), total, micros, currency)
		_bump(agg["by_purpose"], String(e.get("purpose", "")), total, micros, currency)
		_bump(agg["by_session"], String(e.get("session_id", "")), total, micros, currency)
	return agg


func _bump(group: Dictionary, key: String, tokens: int, micros: int, currency: String) -> void:
	if not group.has(key):
		group[key] = {"calls": 0, "tokens": 0, "cost": {}}
	var g: Dictionary = group[key]
	g["calls"] = int(g["calls"]) + 1
	g["tokens"] = int(g["tokens"]) + tokens
	if micros >= 0:
		var c: Dictionary = g["cost"]
		c[currency] = int(c.get(currency, 0)) + micros
		g["cost"] = c
	group[key] = g


## 今天的 token 总数（预算闸门用）
func tokens_on_date(date_key: String, entries: Array = []) -> int:
	var all: Array = entries if not entries.is_empty() else load_all()
	var total := 0
	for raw in all:
		var e: Dictionary = raw
		if String(e.get("iso", "")).substr(0, 10) == date_key:
			total += int(e.get("total_tokens", 0))
	return total


const CSV_COLUMNS := ["iso", "ts", "provider", "model", "purpose", "status", "prompt_tokens",
	"completion_tokens", "cached_tokens", "reasoning_tokens", "total_tokens", "est_cost_micros",
	"currency", "price_version", "price_tier", "latency_ms", "http_status", "error_code", "session_id"]


func to_csv(entries: Array) -> String:
	var lines: Array[String] = [",".join(CSV_COLUMNS)]
	for raw in entries:
		var e: Dictionary = raw
		var cells: Array[String] = []
		for col in CSV_COLUMNS:
			cells.append(_csv_cell(str(e.get(col, ""))))
		lines.append(",".join(cells))
	return "\n".join(lines) + "\n"


static func _csv_cell(value: String) -> String:
	var v := value.replace("\"", "\"\"")
	if v.contains(",") or v.contains("\"") or v.contains("\n"):
		return "\"" + v + "\""
	return v
