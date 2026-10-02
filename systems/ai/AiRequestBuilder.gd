extends RefCounted

## AI 参谋 —— 请求构造（纯函数，可单测）
##
## 两种方言：
##   openai  → POST {base_url}{path}   Authorization: Bearer <key>   {"model","messages","max_tokens"}
##   gemini  → POST {base_url}{path}   x-goog-api-key: <key>         {"contents","generationConfig"}
## 刻意不写 class_name：引用方 preload。

const CatalogScript := preload("res://systems/ai/AiProviderCatalog.gd")


## 拼完整 URL；gemini 的 path 里带 {model} 占位符，这里替换掉
static func endpoint(provider: Dictionary, base_url_override: String, model: String) -> String:
	var base := CatalogScript.effective_base_url(provider, base_url_override)
	var path := String(provider.get("path", "/v1/chat/completions")).replace("{model}", model)
	if base == "":
		return ""
	return base + path


## 认证头。key 只进请求头 —— 绝不进 URL query（否则会落在日志 / 代理记录里）
static func headers(provider: Dictionary, api_key: String) -> PackedStringArray:
	var out := PackedStringArray()
	out.append("Content-Type: application/json")
	if String(provider.get("dialect", CatalogScript.DIALECT_OPENAI)) == CatalogScript.DIALECT_GEMINI:
		out.append("x-goog-api-key: " + api_key)
	else:
		out.append("Authorization: Bearer " + api_key)
	return out


## 请求体。messages 统一用 [{role, content}]，方言差异只在这一层收敛。
static func payload(provider: Dictionary, model: String, messages: Array, max_tokens: int) -> Dictionary:
	if String(provider.get("dialect", CatalogScript.DIALECT_OPENAI)) == CatalogScript.DIALECT_GEMINI:
		var parts: Array = []
		for m in messages:
			parts.append({"text": String((m as Dictionary).get("content", ""))})
		return {
			"contents": [{"role": "user", "parts": parts}],
			"generationConfig": {"maxOutputTokens": max_tokens, "temperature": 0.4},
		}
	return {
		"model": model,
		"messages": messages,
		"max_tokens": max_tokens,
		"temperature": 0.4,
		"stream": false,
	}


static func payload_json(provider: Dictionary, model: String, messages: Array, max_tokens: int) -> String:
	return JSON.stringify(payload(provider, model, messages, max_tokens))
