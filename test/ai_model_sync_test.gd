@tool
extends EditorScript

## AI 参谋 —— 「在线同步可用模型」单测：目录元数据 + 响应解析 + 选名策略
##
## 为什么钉这些：模型名会随供应商更新而变（2026-10-03 DeepSeek 刚从 deepseek-chat 换成
## deepseek-flash），所以模型名不再写死、改为在线取。这条链一旦坏掉，玩家就会「选完供应商
## 却填不出模型名」——比不能复盘更早卡住。故把三件事都钉住：
##   ① 目录里每家都有可点的官网/文档/价格页 + 合法的 https base_url + models_path
##   ② 两种方言的「列出模型」响应都解析得对，且把非对话模型滤掉
##   ③ 同步完选哪个名字的策略（绝不擅自覆盖玩家仍有效的选择）

const CatalogScript := preload("res://systems/ai/AiProviderCatalog.gd")
const ModelParser := preload("res://systems/ai/AiModelListParser.gd")

var _passed := 0
var _failed := 0


func _run() -> void:
	_test_catalog()
	_test_parse_openai()
	_test_parse_gemini()
	_test_parse_errors()
	_test_choose_model()
	_test_describe()
	print("—— 通过 %d 项 / 失败 %d 项 ——" % [_passed, _failed])
	if _failed > 0:
		print("！！ 有 %d 项失败，往上翻看期望与实际" % _failed)


func _check(title: String, actual: Variant, expected: Variant) -> void:
	if actual == expected:
		_passed += 1
		print("[OK]   %s" % title)
	else:
		_failed += 1
		print("[FAIL] %s  期望=%s 实际=%s" % [title, str(expected), str(actual)])


func _check_true(title: String, condition: bool) -> void:
	_check(title, condition, true)


# ────────────────────────── 目录元数据 ──────────────────────────
func _test_catalog() -> void:
	# 每家「知名供应商」都必须有：可点的官网/文档/价格页 + 合法 https 的 base_url + models_path
	var bad: Array[String] = []
	for id in CatalogScript.ids():
		if id == "custom":
			continue
		var e: Dictionary = CatalogScript.resolve(id)
		var label := String(e.get("label", id))
		if not String(e.get("base_url", "")).begins_with("https://"):
			bad.append(label + " base_url")
		if not String(e.get("official_site", "")).begins_with("https://"):
			bad.append(label + " official_site")
		if not String(e.get("api_docs", "")).begins_with("https://"):
			bad.append(label + " api_docs")
		if not String(e.get("pricing_url", "")).begins_with("https://"):
			bad.append(label + " pricing_url")
		if not String(e.get("models_path", "")).begins_with("/"):
			bad.append(label + " models_path")
		if String(e.get("default_model", "")) == "":
			bad.append(label + " default_model")
		if (e.get("models", []) as Array).is_empty():
			bad.append(label + " models")
	_check("每个知名供应商的元数据都齐（base_url/官网/文档/价格页/models_path/默认名）",
			bad.size(), 0)
	if bad.size() > 0:
		print("       缺：%s" % ", ".join(bad))

	_check("deepseek 的 models_path", CatalogScript.models_path_of("deepseek"), "/models")
	_check("gemini 的 models_path", CatalogScript.models_path_of("gemini"), "/v1beta/models")
	_check_true("自定义供应商不做在线同步", not CatalogScript.supports_model_sync("custom"))
	_check_true("未知供应商 id 也不崩且不做同步", not CatalogScript.supports_model_sync("不存在的供应商"))
	_check_true("deepseek 支持在线同步", CatalogScript.supports_model_sync("deepseek"))
	_check_true("官网地址不是空串", CatalogScript.official_site_of("deepseek") != "")
	# 内置的官网/文档必须与「怎么连」分开：base_url 是接口地址，official_site 是官网
	_check_true("deepseek 的 base_url 与官网不是同一个",
			CatalogScript.resolve("deepseek").get("base_url") != CatalogScript.official_site_of("deepseek"))


# ────────────────────────── 解析：OpenAI 形状 ──────────────────────────
func _test_parse_openai() -> void:
	# DeepSeek 官方文档里那套字段（id/name/context_window/max_output_tokens）
	var body := JSON.stringify({"object": "list", "data": [
		{"id": "deepseek-flash", "object": "model", "owned_by": "deepseek",
			"name": "DeepSeek-V4.1-Flash", "context_window": 1000000, "max_output_tokens": 393216},
		{"id": "deepseek-v4-pro", "object": "model", "owned_by": "deepseek"},
	]})
	var r := ModelParser.parse(body, "openai")
	_check_true("openai 形状解析成功", bool(r.get("ok", false)))
	_check("解析出 2 个模型", (r.get("models", []) as Array).size(), 2)
	var m0: Dictionary = (r.get("models", []) as Array)[0]
	_check("第一个 id", String(m0.get("id", "")), "deepseek-flash")
	_check("带上显示名", String(m0.get("label", "")), "DeepSeek-V4.1-Flash")
	_check("带上上下文长度", int(m0.get("context", 0)), 1000000)
	_check("带上输出上限", int(m0.get("max_out", 0)), 393216)

	# OpenRouter 用的是 context_length，也要认
	var or_body := JSON.stringify({"data": [{"id": "anthropic/claude-x", "context_length": 200000}]})
	var or_parsed := ModelParser.parse(or_body, "openai")
	_check("认 OpenRouter 的 context_length",
			int(((or_parsed.get("models", []) as Array)[0] as Dictionary).get("context", 0)), 200000)

	# 非对话模型要滤掉，但 vision / reasoner / thinking 一律保留
	var mixed := JSON.stringify({"data": [
		{"id": "gpt-4o-mini"}, {"id": "text-embedding-3-small"}, {"id": "whisper-1"},
		{"id": "tts-1"}, {"id": "omni-moderation-latest"}, {"id": "dall-e-3"},
		{"id": "gpt-4o-vision-preview"}, {"id": "deepseek-reasoner"}, {"id": "bge-large-zh"},
	]})
	var mixed_parsed := ModelParser.parse(mixed, "openai")
	var ids: Array[String] = []
	for m in mixed_parsed.get("models", []):
		ids.append(String((m as Dictionary).get("id", "")))
	# 9 个里非对话的有 6 个：text-embedding-3-small / whisper-1 / tts-1 / omni-moderation-latest /
	# dall-e-3 / bge-large-zh（vision 与 reasoner 留着）
	_check("滤掉 embedding/whisper/tts/moderation/dall-e/bge",
			mixed_parsed.get("filtered", 0), 6)
	_check_true("保留 vision（能对话）", ids.has("gpt-4o-vision-preview"))
	_check_true("保留 reasoner（能对话）", ids.has("deepseek-reasoner"))
	_check("filtered/total 对得上", "%d/%d" % [mixed_parsed.get("filtered", 0), mixed_parsed.get("total", 0)], "6/9")

	# 去重
	var dup := JSON.stringify({"data": [{"id": "a"}, {"id": "a"}, {"id": "b"}]})
	_check("重复 id 去重", (ModelParser.parse(dup, "openai").get("models", []) as Array).size(), 2)

	# 把「当前在用的那个」排到最前
	var pref := ModelParser.parse(mixed, "openai", "deepseek-reasoner")
	_check("当前在用的模型被排到最前",
			String(((pref.get("models", []) as Array)[0] as Dictionary).get("id", "")), "deepseek-reasoner")


# ────────────────────────── 解析：Gemini 形状 ──────────────────────────
func _test_parse_gemini() -> void:
	var body := JSON.stringify({"models": [
		{"name": "models/gemini-2.0-flash", "displayName": "Gemini 2.0 Flash",
			"inputTokenLimit": 1048576, "outputTokenLimit": 8192},
		{"name": "models/text-embedding-004", "displayName": "Embedding 004"},
		{"name": "models/gemini-2.5-pro", "displayName": "Gemini 2.5 Pro"},
	]})
	var r := ModelParser.parse(body, "gemini")
	_check_true("gemini 形状解析成功", bool(r.get("ok", false)))
	_check("gemini：滤掉 embedding 后剩 2 个", (r.get("models", []) as Array).size(), 2)
	var m0: Dictionary = (r.get("models", []) as Array)[0]
	_check("gemini 的 models/ 前缀被剥掉", String(m0.get("id", "")), "gemini-2.0-flash")
	_check("gemini 的 displayName 进 label", String(m0.get("label", "")), "Gemini 2.0 Flash")
	_check("gemini 的 inputTokenLimit 进 context", int(m0.get("context", 0)), 1048576)


# ────────────────────────── 解析：错误形状 ──────────────────────────
func _test_parse_errors() -> void:
	_check("不是 JSON", ModelParser.parse("这个不是 JSON", "openai").get("error", ""),
			ModelParser.ERR_BAD_RESPONSE)
	_check("顶层是数组（形状不对）", ModelParser.parse("[1,2,3]", "openai").get("error", ""),
			ModelParser.ERR_BAD_RESPONSE)
	_check("响应体是错误对象", ModelParser.parse(JSON.stringify({"error": {"message": "bad"}}), "openai").get("error", ""),
			ModelParser.ERR_API_ERROR)
	_check("data 是空的", ModelParser.parse(JSON.stringify({"data": []}), "openai").get("error", ""),
			ModelParser.ERR_EMPTY)
	_check("条目全都不是对话模型 ⇒ 等于空", ModelParser.parse(JSON.stringify({"data": [{"id": "whisper-1"}]}), "openai").get("error", ""),
			ModelParser.ERR_EMPTY)
	_check_true("失败时 ok 是 false", not bool(ModelParser.parse("x", "openai").get("ok", true)))


# ────────────────────────── 选名策略 ──────────────────────────
func _test_choose_model() -> void:
	var models: Array = [{"id": "deepseek-flash"}, {"id": "deepseek-v4-pro"}]
	# 玩家填的名字供应商还提供 → 不动（这是最重要的一条：别擅自改玩家的选择）
	_check("玩家填的仍有效 ⇒ 保留", ModelParser.choose_model(models, "deepseek-v4-pro", "deepseek-flash"),
			"deepseek-v4-pro")
	# 玩家填的名字供应商已不提供（被下线/改名）→ 用目录默认名
	_check("玩家填的已不存在 ⇒ 换默认名", ModelParser.choose_model(models, "deepseek-chat", "deepseek-flash"),
			"deepseek-flash")
	# 默认名也不在列表里 → 用第一个
	_check("默认名也不在 ⇒ 用第一个", ModelParser.choose_model(models, "", "glm-4"), "deepseek-flash")
	# 空列表绝不把玩家填的名字清掉
	_check("空列表 ⇒ 原样返回", ModelParser.choose_model([], "我自己填的", "x"), "我自己填的")


# ────────────────────────── 界面用的说明串 ──────────────────────────
func _test_describe() -> void:
	var text := ModelParser.describe({"id": "deepseek-flash", "label": "DeepSeek-V4.1-Flash",
		"context": 1000000, "max_out": 393216})
	_check_true("说明串带显示名", text.contains("DeepSeek-V4.1-Flash"))
	_check_true("说明串把 1000000 写成 100.0万", text.contains("100.0万"))
	_check_true("说明串带输出上限", text.contains("输出上限"))
	_check("没元数据时说明串是空的", ModelParser.describe({"id": "x"}), "")
