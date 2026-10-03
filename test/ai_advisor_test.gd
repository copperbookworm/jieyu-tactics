@tool
extends EditorScript

## AI 参谋（局间顾问）· 纯逻辑单测
## 覆盖：provider 目录 / 请求构造 / 响应解析（含 usage 归一与错误分类）/ 估价表 /
##       本地用量账本（JSONL 落盘 + 汇总 + CSV）/ 密钥保管（混淆往返 + 脱敏）/
##       战局摘要（白名单收敛 + 紧凑文本 + 截断）/ 提示词契约。
## 不碰 autoload、不碰场景树、不发网络请求 —— 网络链路由 tools/ai_transport_check.gd 端到端验。

const CatalogScript := preload("res://systems/ai/AiProviderCatalog.gd")
const RequestBuilder := preload("res://systems/ai/AiRequestBuilder.gd")
const Parser := preload("res://systems/ai/AiResponseParser.gd")
const PriceTable := preload("res://systems/ai/AiPriceTable.gd")
const LedgerScript := preload("res://systems/ai/AiUsageLedger.gd")
const KeyVault := preload("res://systems/ai/AiKeyVault.gd")
const DigestScript := preload("res://systems/ai/AiBattleDigest.gd")
const PromptScript := preload("res://systems/ai/AiPrompt.gd")

const TMP_DIR := "user://ai_test_ledger"
const TMP_KEY := "user://ai_test_advisor.key"

var _passed := 0
var _failed := 0


func _run() -> void:
	_test_catalog()
	_test_request_builder()
	_test_parser_openai()
	_test_parser_gemini()
	_test_parser_errors()
	_test_price_table()
	_test_key_vault()
	_test_ledger()
	_test_digest()
	_test_prompt()
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


# ────────────────────────── provider 目录 ──────────────────────────
func _test_catalog() -> void:
	var ids: Array = CatalogScript.ids()
	_check("目录里有 7 个 provider", ids.size(), 7)
	_check_true("国内首选 deepseek 在目录里", ids.has("deepseek"))
	_check("未知 id 回落 custom", String(CatalogScript.resolve("no_such").get("id")), "custom")
	_check("deepseek 方言＝openai",
			CatalogScript.dialect_of("deepseek"), CatalogScript.DIALECT_OPENAI)
	_check("gemini 方言＝gemini",
			CatalogScript.dialect_of("gemini"), CatalogScript.DIALECT_GEMINI)
	_check("base_url 末尾斜杠会被去掉",
			CatalogScript.effective_base_url(CatalogScript.resolve("custom"), "https://x.example/"),
			"https://x.example")
	_check("覆盖 base_url 优先于目录值",
			CatalogScript.effective_base_url(CatalogScript.resolve("deepseek"), "http://127.0.0.1:8123"),
			"http://127.0.0.1:8123")


# ────────────────────────── 请求构造 ──────────────────────────
func _test_request_builder() -> void:
	var ds := CatalogScript.resolve("deepseek")
	_check("deepseek endpoint 拼接",
			RequestBuilder.endpoint(ds, "", "deepseek-chat"),
			"https://api.deepseek.com/chat/completions")
	_check("base_url 覆盖后指向本地 mock",
			RequestBuilder.endpoint(ds, "http://127.0.0.1:8123/", "deepseek-chat"),
			"http://127.0.0.1:8123/chat/completions")
	var gm := CatalogScript.resolve("gemini")
	_check("gemini 的 {model} 占位符被替换",
			RequestBuilder.endpoint(gm, "", "gemini-2.0-flash"),
			"https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent")

	var h1: PackedStringArray = RequestBuilder.headers(ds, "sk-test")
	_check("openai 方言用 Authorization: Bearer", h1[1], "Authorization: Bearer sk-test")
	var h2: PackedStringArray = RequestBuilder.headers(gm, "gm-test")
	_check("gemini 方言用 x-goog-api-key", h2[1], "x-goog-api-key: gm-test")

	var messages := [{"role": "user", "content": "hi"}]
	var b1: Dictionary = RequestBuilder.payload(ds, "deepseek-chat", messages, 128)
	_check("openai body 带 model", String(b1.get("model", "")), "deepseek-chat")
	_check("openai body 带 max_tokens", int(b1.get("max_tokens", 0)), 128)
	_check("openai body 不是流式（第一期刻意不做 SSE）", bool(b1.get("stream", true)), false)
	var b2: Dictionary = RequestBuilder.payload(gm, "gemini-2.0-flash", messages, 128)
	_check_true("gemini body 用 contents", b2.has("contents"))
	_check("gemini maxOutputTokens 落在 generationConfig",
			int((b2["generationConfig"] as Dictionary).get("maxOutputTokens", 0)), 128)
	_check_true("gemini body 不带 model 字段（模型在 URL 里）", not b2.has("model"))


# ────────────────────────── 响应解析 ──────────────────────────
func _test_parser_openai() -> void:
	var body := JSON.stringify({
		"choices": [{"message": {"content": "  复盘正文  "}}],
		"usage": {"prompt_tokens": 1200, "completion_tokens": 300, "total_tokens": 1500,
			"prompt_cache_hit_tokens": 800},
	})
	var r: Dictionary = Parser.parse(CatalogScript.DIALECT_OPENAI, 200, body)
	_check_true("openai 200 → ok", bool(r["ok"]))
	_check("正文去掉首尾空白", String(r["text"]), "复盘正文")
	var u: Dictionary = r["usage"]
	_check("prompt_tokens 归一", int(u["prompt_tokens"]), 1200)
	_check("completion_tokens 归一", int(u["completion_tokens"]), 300)
	_check("DeepSeek 风格缓存字段被识别", int(u["cached_tokens"]), 800)
	_check("total_tokens 归一", int(u["total_tokens"]), 1500)

	# OpenAI 风格的缓存字段（prompt_tokens_details.cached_tokens）
	var body2 := JSON.stringify({
		"choices": [{"message": {"content": "x"}}],
		"usage": {"prompt_tokens": 100, "completion_tokens": 10, "total_tokens": 110,
			"prompt_tokens_details": {"cached_tokens": 64}},
	})
	var r2: Dictionary = Parser.parse(CatalogScript.DIALECT_OPENAI, 200, body2)
	_check("OpenAI 风格缓存字段被识别", int((r2["usage"] as Dictionary)["cached_tokens"]), 64)

	# 没有 usage 时不能崩，且字段要齐
	var body3 := JSON.stringify({"choices": [{"message": {"content": "y"}}]})
	var r3: Dictionary = Parser.parse(CatalogScript.DIALECT_OPENAI, 200, body3)
	_check_true("缺 usage 仍然 ok", bool(r3["ok"]))
	_check("缺 usage 时 prompt_tokens 记 0", int((r3["usage"] as Dictionary)["prompt_tokens"]), 0)


func _test_parser_gemini() -> void:
	var body := JSON.stringify({
		"candidates": [{"content": {"parts": [{"text": "前半"}, {"text": "后半"}]}}],
		"usageMetadata": {"promptTokenCount": 500, "candidatesTokenCount": 80,
			"cachedContentTokenCount": 200, "totalTokenCount": 580},
	})
	var r: Dictionary = Parser.parse(CatalogScript.DIALECT_GEMINI, 200, body)
	_check_true("gemini 200 → ok", bool(r["ok"]))
	_check("gemini 多个 part 拼接", String(r["text"]), "前半后半")
	var u: Dictionary = r["usage"]
	_check("gemini promptTokenCount 归一", int(u["prompt_tokens"]), 500)
	_check("gemini candidatesTokenCount 归一", int(u["completion_tokens"]), 80)
	_check("gemini cachedContentTokenCount 归一", int(u["cached_tokens"]), 200)


func _test_parser_errors() -> void:
	var e401: Dictionary = Parser.parse(CatalogScript.DIALECT_OPENAI, 401,
			JSON.stringify({"error": {"message": "Invalid API key"}}))
	_check("401 → bad_key", String(e401["error_code"]), Parser.ERR_KEY)
	_check_true("401 不算成功", not bool(e401["ok"]))
	_check("401 带上供应商原话", String(e401["error_message"]), "Invalid API key")
	_check("402 → 余额不足",
			String(Parser.parse(CatalogScript.DIALECT_OPENAI, 402, "{}")["error_code"]), Parser.ERR_BALANCE)
	_check("429 → 限流",
			String(Parser.parse(CatalogScript.DIALECT_OPENAI, 429, "{}")["error_code"]), Parser.ERR_RATE)
	_check("503 → 服务端错误",
			String(Parser.parse(CatalogScript.DIALECT_OPENAI, 503, "{}")["error_code"]), Parser.ERR_SERVER)
	_check("坏 JSON → bad_response",
			String(Parser.parse(CatalogScript.DIALECT_OPENAI, 200, "<html>502</html>")["error_code"]),
			Parser.ERR_SHAPE)
	_check("200 但 choices 空 → bad_response",
			String(Parser.parse(CatalogScript.DIALECT_OPENAI, 200, "{}")["error_code"]), Parser.ERR_SHAPE)
	_check("网络层失败 → network_error",
			String(Parser.network_failure(7)["error_code"]), Parser.ERR_NETWORK)
	_check_true("每个错误码都有给玩家看的一句话",
			Parser.error_text(Parser.ERR_KEY) != "" and Parser.error_text(Parser.ERR_NETWORK) != "")


# ────────────────────────── 估价表 ──────────────────────────
func _test_price_table() -> void:
	_check_true("deepseek-chat 在价目表里", PriceTable.has_model("deepseek-chat"))
	# ¥2/M 入 + ¥8/M 出：1000 入 + 500 出 = 2000 + 4000 = 6000 微元（¥0.006）
	_check("计价＝整数微元（1000 入 / 500 出）",
			PriceTable.cost_micros("deepseek-chat", 1000, 500, 0), 6000)
	# 全命中缓存：1000 × ¥0.5/M = 500 微元
	_check("缓存命中按缓存价算",
			PriceTable.cost_micros("deepseek-chat", 1000, 0, 1000), 500)
	# 命中数超过 prompt 时按 prompt 截断，不能算成负单价
	_check("缓存数超过 prompt 时按 prompt 截断",
			PriceTable.cost_micros("deepseek-chat", 1000, 0, 99999),
			PriceTable.cost_micros("deepseek-chat", 1000, 0, 1000))
	_check("free 模型计 0 而不是未知", PriceTable.cost_micros("glm-4-flash", 999, 999, 0), 0)
	_check("表外模型＝未知价(-1)", PriceTable.cost_micros("no-such-model", 10, 10, 0), -1)
	_check("币种随模型", PriceTable.currency_of("gpt-4o-mini"), "USD")
	# ── VERSION 2：按 DeepSeek 官方价格页订正的时段计价 ──
	_check("价目表版本已升到 2", PriceTable.VERSION, 2)
	_check_true("deepseek-flash 在表里（现行模型）", PriceTable.has_model("deepseek-flash"))
	_check_true("deepseek-v4-pro 在表里", PriceTable.has_model("deepseek-v4-pro"))
	_check_true("legacy deepseek-chat 仍保留（历史账目可比）", PriceTable.has_model("deepseek-chat"))
	# 2026-10-05 是周一、2026-10-04 是周日（已用日历核对）；下面时间戳是 UTC，+8h 得北京时间
	var monday_peak := int(Time.get_unix_time_from_datetime_dict(
			{"year": 2026, "month": 10, "day": 5, "hour": 2, "minute": 0, "second": 0}))
	var sunday_same := int(Time.get_unix_time_from_datetime_dict(
			{"year": 2026, "month": 10, "day": 4, "hour": 2, "minute": 0, "second": 0}))
	_check("北京时间周一 10:00 ＝ 高峰", PriceTable.tier_at(monday_peak), PriceTable.TIER_PEAK)
	_check("北京时间周日 10:00 ＝ 空闲", PriceTable.tier_at(sunday_same), PriceTable.TIER_OFFPEAK)
	_check("周一 08:00（高峰前一小时）＝ 空闲",
			PriceTable.tier_at(monday_peak - 2 * 3600), PriceTable.TIER_OFFPEAK)
	_check("周一 12:00（上午高峰到 12:00 不含）＝ 空闲",
			PriceTable.tier_at(monday_peak + 2 * 3600), PriceTable.TIER_OFFPEAK)
	_check("周一 14:00（下午高峰）＝ 高峰",
			PriceTable.tier_at(monday_peak + 4 * 3600), PriceTable.TIER_PEAK)
	# flash：空闲 输入 1 元 / 命中 0.02 元 / 输出 4 元；高峰 = 空闲 ×2
	_check("flash 空闲：1M 未命中输入 ＝ ¥1",
			PriceTable.cost_micros("deepseek-flash", 1000000, 0, 0, sunday_same), 1000000)
	_check("flash 高峰：1M 未命中输入 ＝ ¥2",
			PriceTable.cost_micros("deepseek-flash", 1000000, 0, 0, monday_peak), 2000000)
	_check("flash 高峰：1M 命中缓存输入 ＝ ¥0.04",
			PriceTable.cost_micros("deepseek-flash", 1000000, 0, 1000000, monday_peak), 40000)
	_check("flash 空闲：1M 输出 ＝ ¥4",
			PriceTable.cost_micros("deepseek-flash", 0, 1000000, 0, sunday_same), 4000000)
	_check("v4-pro 高峰：1M 输出 ＝ ¥27",
			PriceTable.cost_micros("deepseek-v4-pro", 0, 1000000, 0, monday_peak), 27000000)
	_check("flash 币种 ＝ CNY", PriceTable.currency_of("deepseek-flash"), "CNY")
	# 真机实测过的那次真调用（2026-10-03T08:28:47 周六，属空闲时段）：
	# prompt 304 / 命中缓存 128 / completion 512
	# ⇒ 未命中 176×¥1 + 命中 128×¥0.02 + 输出 512×¥4 = ¥2.226560 ⇒ 四舍五入 2227 微元
	_check("真机那次调用在新价目表下 ＝ 2227 微元（≈¥0.0022，空闲）",
			PriceTable.cost_micros("deepseek-flash", 304, 512, 128, sunday_same), 2227)
	_check_true("同一次调用若落在高峰则 ≈ 两倍",
			PriceTable.cost_micros("deepseek-flash", 304, 512, 128, monday_peak) == 4453)
	_check_true("legacy 模型不受时段影响",
			PriceTable.cost_micros("deepseek-chat", 1000000, 0, 0, monday_peak)
			== PriceTable.cost_micros("deepseek-chat", 1000000, 0, 0, sunday_same))
	_check_true("金额串含金额", PriceTable.format_micros(6000, "CNY").contains("0.006"))
	_check("未知价显示「未知」而不是 0", PriceTable.format_micros(-1, ""), "未知")
	_check("0 元显示 0（免费模型）", PriceTable.format_micros(0, "CNY"), "¥0")


# ────────────────────────── 密钥保管 ──────────────────────────
func _test_key_vault() -> void:
	var raw := "sk-abcdef123456"
	var blob := KeyVault.obfuscate(raw)
	_check_true("落盘串带版本前缀", blob.begins_with(KeyVault.PREFIX))
	_check_true("落盘串不含明文", not blob.contains(raw))
	_check("混淆往返一致", KeyVault.deobfuscate(blob), raw)
	_check("空串混淆后仍是空串", KeyVault.obfuscate(""), "")
	_check("脱敏只露头尾", KeyVault.redact(raw), "sk-a…3456")
	_check("空 key 的脱敏文案", KeyVault.redact(""), "（未填写）")
	_check("短 key 全遮", KeyVault.redact("short"), "****")

	# 文件往返
	var vault = KeyVault.new(TMP_KEY)
	vault.clear()
	_check("没存过时读出来是空", vault.load_key(), "")
	_check_true("保存成功", vault.save_key(raw))
	_check("从文件读回来一致", vault.load_key(), raw)
	_check_true("has_key 认得出来", vault.has_key())
	vault.clear()
	_check("清掉后读不到", vault.load_key(), "")


# ────────────────────────── 本地用量账本 ──────────────────────────
func _test_ledger() -> void:
	var ledger = LedgerScript.new(TMP_DIR)
	ledger.clear()
	_check("起始账本为空", ledger.load_all().size(), 0)

	ledger.record({"iso": "2026-10-01T20:00:00", "provider": "deepseek", "model": "deepseek-chat",
		"purpose": "debrief", "prompt_tokens": 1000, "completion_tokens": 200,
		"cached_tokens": 600, "est_cost_micros": 5000, "currency": "CNY",
		"price_version": PriceTable.VERSION, "status": "ok", "session_id": "s1"})
	ledger.record({"iso": "2026-10-02T10:00:00", "provider": "deepseek", "model": "deepseek-chat",
		"purpose": "debrief", "prompt_tokens": 1200, "completion_tokens": 300,
		"cached_tokens": 800, "est_cost_micros": 6200, "currency": "CNY", "status": "ok",
		"session_id": "s2"})
	var failed: Dictionary = ledger.record({"iso": "2026-10-02T11:00:00", "provider": "deepseek",
		"model": "no-such-model", "purpose": "debrief", "prompt_tokens": 10, "completion_tokens": 0,
		"est_cost_micros": -1, "currency": "", "status": "error", "error_code": "rate_limited",
		"session_id": "s2"})

	_check("id 自动补上", String(failed.get("id", "")) != "", true)
	_check("缺失字段补默认值（latency_ms）", int(failed.get("latency_ms", -1)), 0)
	_check("total_tokens 自动算出来", int(failed.get("total_tokens", 0)), 10)

	var all: Array = ledger.load_all()
	_check("三条都落盘并能读回", all.size(), 3)

	var agg: Dictionary = ledger.aggregate(all)
	_check("汇总：调用次数", int(agg["calls"]), 3)
	_check("汇总：失败次数", int(agg["failed"]), 1)
	_check("汇总：未知价条目数", int(agg["unknown_price"]), 1)
	_check("汇总：prompt token 合计", int(agg["prompt_tokens"]), 2210)
	_check("汇总：总 token 合计", int(agg["total_tokens"]), 2710)
	var cost: Dictionary = agg["cost"]
	_check("汇总：金额按币种装（CNY 11200 微元）", int(cost.get("CNY", 0)), 11200)
	_check_true("汇总：不同币种不相加（只有 CNY）", not cost.has("USD"))
	_check("按天分组有两天", (agg["by_day"] as Dictionary).size(), 2)
	_check("按模型分组", (agg["by_model"] as Dictionary).size(), 2)
	_check("10-02 那天两条", int(((agg["by_day"] as Dictionary)["2026-10-02"] as Dictionary)["calls"]), 2)
	_check("按会话分组", (agg["by_session"] as Dictionary).size(), 2)
	_check("指定日期的 token 合计", ledger.tokens_on_date("2026-10-01", all), 1200)

	var csv: String = ledger.to_csv(all)
	var lines: PackedStringArray = csv.split("\n")
	_check_true("CSV 有表头", lines[0].contains("est_cost_micros"))
	_check("CSV 行数＝表头 + 3 条（末尾换行）", lines.size(), 5)
	_check_true("CSV 含模型名", csv.contains("deepseek-chat"))
	_check("CSV 转义引号", LedgerScript._csv_cell("a\"b"), "\"a\"\"b\"")

	# clear() 返回删掉的文件数：两条同月记录落在同一个 .jsonl 里 ⇒ 1 个文件
	_check("清空：删掉同月那 1 个文件", ledger.clear(), 1)
	_check("清空后读不到", ledger.load_all().size(), 0)


# ────────────────────────── 战局摘要 ──────────────────────────
func _test_digest() -> void:
	var snapshot := {
		"outcome": "player", "reason": "时间到：占领数 3 : 1", "duration_s": 842,
		"overtime": false, "score": 240, "kills": 37, "deaths": 2, "respawn_left": 6,
		"role_name": "步枪兵",
		"zones": [{"n": 1, "side": "ours", "progress": 0.82},
			{"n": 2, "side": "enemy", "progress": -0.31}, {"n": 3, "side": "neutral", "progress": 0.0}],
		"quests": {"main": "占领 N1", "done": ["占领 N1"], "failed": ["守住通路"],
			"completed_count": 1},
		"vehicles": "我方存活，敌方被击毁",
		"huge_unused_blob": "x".repeat(10000),
	}
	var d: Dictionary = DigestScript.build(snapshot)
	_check_true("白名单：上游多塞的字段被丢掉", not d.has("huge_unused_blob"))
	_check("结局收敛", String(d["outcome"]), "player")

	var text: String = DigestScript.to_text(d)
	_check_true("战报含结局", text.contains("结局: 我方胜利"))
	_check_true("战报含判定依据", text.contains("时间到：占领数 3 : 1"))
	_check_true("战报含节点归属", text.contains("N1=我方(0.82)"))
	_check_true("战报含击杀阵亡", text.contains("击杀: 37") and text.contains("阵亡: 2"))
	_check_true("战报含任务结果", text.contains("占领 N1") and text.contains("守住通路"))
	_check_true("战报紧凑（不到 700 字符）", text.length() < 700)
	_check_true("战报 token 粗估在 500 以内", DigestScript.estimate_tokens(text) < 500)

	_check("超长文本被截断", DigestScript.truncate("x".repeat(100), 10).length() > 10, true)
	_check_true("截断有提示", DigestScript.truncate("x".repeat(100), 10).contains("截断"))
	_check("空快照也能出文本不崩", DigestScript.to_text(DigestScript.build({})) != "", true)


# ────────────────────────── 提示词契约 ──────────────────────────
func _test_prompt() -> void:
	var messages: Array = PromptScript.debrief_messages("结局: 我方胜利")
	_check("两条消息：system + user", messages.size(), 2)
	_check("第一条是 system", String((messages[0] as Dictionary)["role"]), "system")
	_check("第二条是 user", String((messages[1] as Dictionary)["role"]), "user")
	_check_true("user 里带战报原文",
			String((messages[1] as Dictionary)["content"]).contains("结局: 我方胜利"))
	_check_true("system 规定四段结构", PromptScript.SYSTEM_PROMPT.contains("【战局判定】"))
	_check_true("system 要求只用给定数据（防编造）",
			PromptScript.SYSTEM_PROMPT.contains("不得编造"))
	_check_true("token 预估是个正数", PromptScript.estimate_prompt_tokens("结局: 我方胜利") > 0)
