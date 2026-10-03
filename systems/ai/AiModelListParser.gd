extends RefCounted

## AI 参谋 —— 「列出模型」响应解析（纯函数，可单测）
##
## 为什么要有这个文件：玩家只该填 API key，模型名和 base_url 该由游戏自己弄清楚。
## base_url 变动很少（DeepSeek 一直是 https://api.deepseek.com），**模型名变动很频繁**
## （2026-10-03 实测：DeepSeek 现行名已从 deepseek-chat 换成 deepseek-flash），
## 所以模型名不该写死在包里，而应该用供应商官方的「列出模型」接口现取。
##
## ⚠ 刻意**不抓官网网页**：官网文档页是给人看的 HTML/SPA，改版就崩，解析出来的东西也无法验证；
## 而 GET {base_url}{models_path} 返回的是**给机器读的 JSON**，是供应商自己的契约。
## 官方文档（DeepSeek Lists Models）对这条接口的说明就是「列出当前可用模型」。
##
## 支持的两种形状：
##   openai（DeepSeek / Moonshot / 智谱 / OpenAI / OpenRouter）：
##     {"object":"list","data":[{"id":"deepseek-flash","object":"model","owned_by":"deepseek",
##       "name":"DeepSeek-V4.1-Flash","context_window":1000000,"max_output_tokens":393216}, ...]}
##   gemini: {"models":[{"name":"models/gemini-2.0-flash","displayName":"...",
##       "inputTokenLimit":1048576,"outputTokenLimit":8192}, ...]}
##
## 刻意不写 class_name：引用方 preload（见 Cover.gd 头部说明）。

const ERR_NONE := ""
const ERR_BAD_RESPONSE := "bad_response"
const ERR_EMPTY := "empty"
const ERR_API_ERROR := "api_error"

## 明显不是「对话用」的模型：列进下拉框只会让玩家选错。
## 保守起见只排掉这些**确定性不是 chat** 的类别，宁可多留也不误杀
## （例如带 vision / reasoner / thinking 的一律保留 —— 它们都是能对话的）。
const EXCLUDE_SUBSTR := [
	"embedding", "embed-", "-embed", "text-embedding",
	"whisper", "tts", "text-to-speech", "speech", "transcribe", "audio",
	"moderation", "rerank", "bge-", "clip", "stable-diffusion", "sora",
	"dall-e", "dall·e", "image-1", "imagen", "veo", "aqa",
]


## 解析响应体。dialect: "openai" | "gemini"。prefer_id：想排到最前面的模型（一般是当前值/默认值）。
## 返回 {ok, models:[{id,label,context,max_out}], error, total, filtered}
static func parse(body_text: String, dialect: String, prefer_id: String = "") -> Dictionary:
	var json := JSON.new()
	if json.parse(body_text) != OK:
		return _fail(ERR_BAD_RESPONSE)
	var root: Variant = json.data
	if typeof(root) != TYPE_DICTIONARY:
		return _fail(ERR_BAD_RESPONSE)
	var d: Dictionary = root
	if d.has("error"):
		# 调用方已经从 HTTP 状态码判过错误类型了，这里只说「响应体是个错误对象」
		return _fail(ERR_API_ERROR)

	var raw: Array = []
	if dialect == "gemini":
		var g: Variant = d.get("models", [])
		if typeof(g) == TYPE_ARRAY:
			raw = g
	else:
		var o: Variant = d.get("data", [])
		if typeof(o) == TYPE_ARRAY:
			raw = o
	if raw.is_empty():
		return _fail(ERR_EMPTY)

	var total := 0
	var filtered := 0
	var seen := {}
	var models: Array = []
	for entry in raw:
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		var e: Dictionary = entry
		var id := _id_of(e, dialect)
		if id == "":
			continue
		total += 1
		if _is_non_chat(id):
			filtered += 1
			continue
		if seen.has(id):
			continue
		seen[id] = true
		models.append(_entry_of(e, id, dialect))

	if models.is_empty():
		return _fail(ERR_EMPTY)

	# 把「当前正在用的那个」提到最前：玩家同步完不需要再翻找
	if prefer_id != "":
		for i in range(models.size()):
			if String((models[i] as Dictionary).get("id", "")) == prefer_id:
				var picked: Variant = models[i]
				models.remove_at(i)
				models.insert(0, picked)
				break

	return {"ok": true, "models": models, "error": ERR_NONE,
		"total": total, "filtered": filtered}


static func _fail(code: String) -> Dictionary:
	return {"ok": false, "models": [], "error": code, "total": 0, "filtered": 0}


static func _id_of(e: Dictionary, dialect: String) -> String:
	if dialect == "gemini":
		# Gemini 返回的是 "models/gemini-2.0-flash"，请求时只要后半截
		return String(e.get("name", "")).trim_prefix("models/").strip_edges()
	return String(e.get("id", "")).strip_edges()


static func _entry_of(e: Dictionary, id: String, dialect: String) -> Dictionary:
	var label := ""
	var context := 0
	var max_out := 0
	if dialect == "gemini":
		label = String(e.get("displayName", ""))
		context = int(e.get("inputTokenLimit", 0))
		max_out = int(e.get("outputTokenLimit", 0))
	else:
		label = String(e.get("name", ""))
		# OpenRouter 用 context_length，OpenAI/DeepSeek 用 context_window —— 两个都认
		context = int(e.get("context_window", e.get("context_length", 0)))
		max_out = int(e.get("max_output_tokens", e.get("max_tokens", 0)))
	return {"id": id, "label": label, "context": context, "max_out": max_out}


static func _is_non_chat(id: String) -> bool:
	var lower := id.to_lower()
	for needle in EXCLUDE_SUBSTR:
		if lower.contains(needle):
			return true
	return false


## 从同步结果里挑一个该用的模型名（纯函数，可单测）：
##   1) 玩家当前填的名字，供应商现在还提供 → 保留（不擅自改玩家的选择）
##   2) 否则目录里的默认名，供应商现在还提供 → 用它
##   3) 否则用列表第一个（同步结果已滤掉非对话模型，并把当前值排到最前）
## 空列表时原样返回 current，绝不把玩家填的名字清掉。
static func choose_model(models: Array, current: String, default_model: String) -> String:
	var ids: Array[String] = []
	for m in models:
		ids.append(String((m as Dictionary).get("id", "")))
	if current != "" and ids.has(current):
		return current
	if default_model != "" and ids.has(default_model):
		return default_model
	if ids.size() > 0:
		return ids[0]
	return current


## 给界面用的一行说明，例如「DeepSeek-V4.1-Flash ｜ 上下文 100万 ｜ 输出上限 39.3万」
static func describe(entry: Dictionary) -> String:
	var parts: Array[String] = []
	var label := String(entry.get("label", ""))
	if label != "":
		parts.append(label)
	var ctx := int(entry.get("context", 0))
	if ctx > 0:
		parts.append("上下文 " + _human_count(ctx))
	var mo := int(entry.get("max_out", 0))
	if mo > 0:
		parts.append("输出上限 " + _human_count(mo))
	return " ｜ ".join(parts)


static func _human_count(n: int) -> String:
	if n >= 10000:
		return "%.1f万" % (float(n) / 10000.0)
	return str(n)
