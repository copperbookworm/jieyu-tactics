extends RefCounted

## AI 参谋 —— 响应解析（纯函数，可单测）
##
## 三件事：① 取正文 ② 归一滴定 usage ③ 把失败分类成玩家看得懂的 error_code。
## 刻意不写 class_name：引用方 preload。

const CatalogScript := preload("res://systems/ai/AiProviderCatalog.gd")

const ERR_KEY := "bad_key"            ## 401 / 403
const ERR_BALANCE := "no_balance"     ## 402
const ERR_RATE := "rate_limited"      ## 429
const ERR_SERVER := "server_error"    ## 5xx
const ERR_NETWORK := "network_error"  ## HTTPRequest 层失败（result != OK）
const ERR_SHAPE := "bad_response"     ## 拿不到正文 / JSON 坏
const ERR_HTTP := "http_error"


## 空壳结果，保证调用方拿到的字段永远齐
static func empty() -> Dictionary:
	return {
		"ok": false,
		"text": "",
		"usage": {"prompt_tokens": 0, "completion_tokens": 0, "cached_tokens": 0,
			"reasoning_tokens": 0, "total_tokens": 0},
		"error_code": "",
		"error_message": "",
		"http_status": 0,
	}


## HTTPRequest 层直接失败（连不上 / 超时 / DNS）
static func network_failure(result_code: int) -> Dictionary:
	var r := empty()
	r["error_code"] = ERR_NETWORK
	r["error_message"] = "网络请求失败（HTTPRequest 错误码 %d）" % result_code
	return r


static func parse(dialect: String, http_status: int, body_text: String) -> Dictionary:
	var out := empty()
	out["http_status"] = http_status
	var parsed: Variant = _parse_json(body_text)
	var body_ok: bool = typeof(parsed) == TYPE_DICTIONARY
	var is_gemini: bool = dialect == CatalogScript.DIALECT_GEMINI

	if http_status != 200:
		out["error_code"] = _classify_http(http_status)
		out["error_message"] = _error_message(parsed, body_text, http_status)
		# 失败响应里也可能带 usage（部分供应商按已生成计费）—— 有就收下，别丢
		if body_ok:
			out["usage"] = _norm_gemini_usage(parsed) if is_gemini else _norm_openai_usage(parsed)
		return out

	if not body_ok:
		out["error_code"] = ERR_SHAPE
		out["error_message"] = "响应不是合法 JSON（前 120 字：%s）" % body_text.substr(0, 120)
		return out

	var body: Dictionary = parsed
	if is_gemini:
		out["text"] = _gemini_text(body)
		out["usage"] = _norm_gemini_usage(body)
	else:
		out["text"] = _openai_text(body)
		out["usage"] = _norm_openai_usage(body)

	if String(out["text"]) == "":
		out["error_code"] = ERR_SHAPE
		out["error_message"] = "响应里没有正文（choices / candidates 为空）"
		return out

	out["ok"] = true
	return out


static func _classify_http(status: int) -> String:
	if status == 401 or status == 403:
		return ERR_KEY
	if status == 402:
		return ERR_BALANCE
	if status == 429:
		return ERR_RATE
	if status >= 500:
		return ERR_SERVER
	return ERR_HTTP


static func _error_message(parsed: Variant, raw: String, status: int) -> String:
	if typeof(parsed) == TYPE_DICTIONARY:
		var err: Variant = (parsed as Dictionary).get("error", null)
		if typeof(err) == TYPE_DICTIONARY:
			var msg := String((err as Dictionary).get("message", ""))
			if msg != "":
				return msg.substr(0, 200)
		if typeof(err) == TYPE_STRING and String(err) != "":
			return String(err).substr(0, 200)
	return "HTTP %d：%s" % [status, raw.substr(0, 120)]


static func _openai_text(body: Dictionary) -> String:
	var choices: Variant = body.get("choices", [])
	if typeof(choices) != TYPE_ARRAY or (choices as Array).is_empty():
		return ""
	var first: Variant = (choices as Array)[0]
	if typeof(first) != TYPE_DICTIONARY:
		return ""
	var message: Variant = (first as Dictionary).get("message", null)
	if typeof(message) == TYPE_DICTIONARY:
		return String((message as Dictionary).get("content", "")).strip_edges()
	return String((first as Dictionary).get("text", "")).strip_edges()


static func _gemini_text(body: Dictionary) -> String:
	var cands: Variant = body.get("candidates", [])
	if typeof(cands) != TYPE_ARRAY or (cands as Array).is_empty():
		return ""
	var content: Variant = ((cands as Array)[0] as Dictionary).get("content", {})
	if typeof(content) != TYPE_DICTIONARY:
		return ""
	var parts: Variant = (content as Dictionary).get("parts", [])
	if typeof(parts) != TYPE_ARRAY:
		return ""
	var text := ""
	for p in (parts as Array):
		if typeof(p) == TYPE_DICTIONARY:
			text += String((p as Dictionary).get("text", ""))
	return text.strip_edges()


## OpenAI 形状。缓存命中字段各家叫法不同，三个都试：
## DeepSeek 的 prompt_cache_hit_tokens、OpenAI 的 prompt_tokens_details.cached_tokens。
static func _norm_openai_usage(body: Dictionary) -> Dictionary:
	var u: Variant = body.get("usage", null)
	if typeof(u) != TYPE_DICTIONARY:
		return (empty()["usage"] as Dictionary).duplicate()
	var d: Dictionary = u
	var prompt := int(d.get("prompt_tokens", 0))
	var completion := int(d.get("completion_tokens", 0))
	var cached := int(d.get("prompt_cache_hit_tokens", 0))
	var details: Variant = d.get("prompt_tokens_details", null)
	if typeof(details) == TYPE_DICTIONARY:
		cached = maxi(cached, int((details as Dictionary).get("cached_tokens", 0)))
	var reasoning := 0
	var cdetails: Variant = d.get("completion_tokens_details", null)
	if typeof(cdetails) == TYPE_DICTIONARY:
		reasoning = int((cdetails as Dictionary).get("reasoning_tokens", 0))
	return {"prompt_tokens": prompt, "completion_tokens": completion, "cached_tokens": cached,
		"reasoning_tokens": reasoning, "total_tokens": int(d.get("total_tokens", prompt + completion))}


## Gemini 形状：usageMetadata
static func _norm_gemini_usage(body: Dictionary) -> Dictionary:
	var u: Variant = body.get("usageMetadata", null)
	if typeof(u) != TYPE_DICTIONARY:
		return (empty()["usage"] as Dictionary).duplicate()
	var d: Dictionary = u
	var prompt := int(d.get("promptTokenCount", 0))
	var thoughts := int(d.get("thoughtsTokenCount", 0))
	var completion := int(d.get("candidatesTokenCount", 0)) + thoughts
	return {"prompt_tokens": prompt, "completion_tokens": completion,
		"cached_tokens": int(d.get("cachedContentTokenCount", 0)), "reasoning_tokens": thoughts,
		"total_tokens": int(d.get("totalTokenCount", prompt + completion))}


## 用 JSON.new().parse() 而不是 JSON.parse_string()：后者遇到坏 JSON 会往控制台打 ERROR。
## 供应商返回 HTML 错误页是**常规情况**（网关 502、被运营商劫持），不该在日志里刷红。
static func _parse_json(text: String) -> Variant:
	if text.strip_edges() == "":
		return null
	var j := JSON.new()
	if j.parse(text) != OK:
		return null
	return j.data


## 给玩家看的一句话（UI 直接用）
static func error_text(code: String) -> String:
	match code:
		ERR_KEY:
			return "API key 无效或没有权限（检查是否填对、是否已吊销）"
		ERR_BALANCE:
			return "账户余额不足"
		ERR_RATE:
			return "请求太频繁被限流，稍后再试"
		ERR_SERVER:
			return "供应商服务端报错，稍后再试"
		ERR_NETWORK:
			return "网络不通（检查手机网络；国内直连不了海外供应商时可换中转 base_url）"
		ERR_SHAPE:
			return "响应格式认不出来（可能是模型不支持该接口）"
		_:
			return "请求失败"
