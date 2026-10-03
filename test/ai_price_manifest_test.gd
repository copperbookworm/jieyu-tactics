@tool
extends EditorScript

## AI 参谋 —— 远程价格清单单测（解析 / 严格校验 / 覆盖 / 回退）
##
## 为什么钉这些：这份清单是**从网上拉下来、直接决定玩家看到的金额**的东西。
## 校验松一点，一份写错的清单就能让全服玩家的估算偏掉，而玩家没有任何办法察觉。
## 所以这里逐条钉：坏 JSON、顶层不是对象、schema 不对/太新、缺 version/updated、
## version 比内置旧（**只能用新价覆盖旧价**）、source 不是 https、条目币种/时段/费率越界、
## 条数上限、以及采纳与回退后金额到底变没变。
##
## ⚠ 注意：AiPriceTable 的远程覆盖是**全局静态状态**，而跑批是同一个进程里把各测试脚本
## 依次跑完的 —— 所以本文件结束时必须 clear_remote()，否则会把远程价泄漏给后面的脚本。
## 这里在开头结尾各清一次。

const ManifestScript := preload("res://systems/ai/AiPriceManifest.gd")
const PriceTable := preload("res://systems/ai/AiPriceTable.gd")

var _passed := 0
var _failed := 0


func _run() -> void:
	PriceTable.clear_remote()   # 防止上一个脚本留下状态
	_test_valid()
	_test_errors()
	_test_apply_and_clear()
	_test_version_gate()
	_test_source_text()
	PriceTable.clear_remote()   # 绝不把远程价泄漏给后面的脚本
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


## 造一份合法清单，按需覆盖字段
func _manifest(overrides: Dictionary = {}) -> String:
	var payload := {
		"schema": 1,
		"version": PriceTable.VERSION + 1,
		"updated": "2026-10-05",
		"source": "https://api-docs.deepseek.com/zh-cn/quick_start/pricing",
		"note": "测试用",
		"models": {
			"deepseek-flash": {
				"currency": "CNY",
				"note": "测试价",
				"offpeak": {"in": 3000000, "cached_in": 60000, "out": 12000000},
				"peak": {"in": 6000000, "cached_in": 120000, "out": 24000000},
			},
		},
	}
	for k in overrides.keys():
		payload[k] = overrides[k]
	return JSON.stringify(payload)


# ────────────────────────── 合法清单 ──────────────────────────
func _test_valid() -> void:
	var r: Dictionary = ManifestScript.parse(_manifest(), PriceTable.VERSION)
	_check_true("合法清单解析通过", bool(r.get("ok", false)))
	_check("带回 version", int(r.get("version", 0)), PriceTable.VERSION + 1)
	_check("带回 updated", String(r.get("updated", "")), "2026-10-05")
	_check("带回条数", int(r.get("model_count", 0)), 1)
	var m: Dictionary = (r.get("models", {}) as Dictionary).get("deepseek-flash", {})
	_check("币种解析", String(m.get("currency", "")), "CNY")
	_check("空闲输入费率解析", int((m.get("offpeak", {}) as Dictionary).get("in", 0)), 3000000)
	_check("高峰输出费率解析", int((m.get("peak", {}) as Dictionary).get("out", 0)), 24000000)
	# 费率写成浮点的整数值（1000.0）应当被接受 —— 手写 JSON 很容易这样
	var floaty := _manifest({"models": {"deepseek-flash": {"currency": "CNY",
		"offpeak": {"in": 3000000.0, "cached_in": 0, "out": 4000000.0},
		"peak": {"in": 3000000, "cached_in": 0, "out": 4000000}}}})
	_check_true("整数值写成浮点也接受", bool(ManifestScript.parse(floaty, 1).get("ok", false)))


# ────────────────────────── 各种坏清单 ──────────────────────────
func _test_errors() -> void:
	var bv: int = PriceTable.VERSION
	_check("不是 JSON", ManifestScript.parse("不是 JSON", bv).get("error", ""), ManifestScript.ERR_BAD_JSON)
	_check("顶层是数组", ManifestScript.parse("[1,2]", bv).get("error", ""), ManifestScript.ERR_NOT_OBJECT)
	_check("缺 schema", ManifestScript.parse(_manifest({"schema": null}), bv).get("error", ""), ManifestScript.ERR_BAD_SCHEMA)
	_check("schema 太新",
			ManifestScript.parse(_manifest({"schema": 99}), bv).get("error", ""), ManifestScript.ERR_SCHEMA_TOO_NEW)
	_check("schema 是字符串",
			ManifestScript.parse(_manifest({"schema": "1"}), bv).get("error", ""), ManifestScript.ERR_BAD_SCHEMA)
	_check("缺 version", ManifestScript.parse(_manifest({"version": null}), bv).get("error", ""), ManifestScript.ERR_BAD_VERSION)
	_check("version = 0", ManifestScript.parse(_manifest({"version": 0}), bv).get("error", ""), ManifestScript.ERR_BAD_VERSION)
	_check("缺 updated", ManifestScript.parse(_manifest({"updated": ""}), bv).get("error", ""), ManifestScript.ERR_BAD_UPDATED)
	_check("source 不是 https",
			ManifestScript.parse(_manifest({"source": "http://x/y.json"}), bv).get("error", ""), ManifestScript.ERR_BAD_SOURCE)
	_check("models 是空对象",
			ManifestScript.parse(_manifest({"models": {}}), bv).get("error", ""), ManifestScript.ERR_EMPTY_MODELS)
	_check("models 不是对象",
			ManifestScript.parse(_manifest({"models": []}), bv).get("error", ""), ManifestScript.ERR_BAD_MODEL)
	_check("条目不是对象",
			ManifestScript.parse(_manifest({"models": {"x": 5}}), bv).get("error", ""), ManifestScript.ERR_BAD_MODEL)

	# 条目内部：币种 / 时段 / 费率
	var bad_currency := _manifest({"models": {"m": {"currency": "JPY",
		"offpeak": {"in": 1, "cached_in": 0, "out": 1}, "peak": {"in": 1, "cached_in": 0, "out": 1}}}})
	_check("币种不认", ManifestScript.parse(bad_currency, bv).get("error", ""), ManifestScript.ERR_BAD_MODEL)
	var no_peak := _manifest({"models": {"m": {"currency": "CNY",
		"offpeak": {"in": 1, "cached_in": 0, "out": 1}}}})
	_check("缺 peak 时段", ManifestScript.parse(no_peak, bv).get("error", ""), ManifestScript.ERR_BAD_MODEL)
	var no_out := _manifest({"models": {"m": {"currency": "CNY",
		"offpeak": {"in": 1, "cached_in": 0}, "peak": {"in": 1, "cached_in": 0, "out": 1}}}})
	_check("时段里缺 out", ManifestScript.parse(no_out, bv).get("error", ""), ManifestScript.ERR_BAD_MODEL)
	var neg := _manifest({"models": {"m": {"currency": "CNY",
		"offpeak": {"in": -1, "cached_in": 0, "out": 1}, "peak": {"in": 1, "cached_in": 0, "out": 1}}}})
	_check("费率为负", ManifestScript.parse(neg, bv).get("error", ""), ManifestScript.ERR_BAD_MODEL)
	var huge := _manifest({"models": {"m": {"currency": "CNY",
		"offpeak": {"in": ManifestScript.MAX_RATE + 1, "cached_in": 0, "out": 1},
		"peak": {"in": 1, "cached_in": 0, "out": 1}}}})
	_check("费率超上限", ManifestScript.parse(huge, bv).get("error", ""), ManifestScript.ERR_BAD_MODEL)
	var frac := _manifest({"models": {"m": {"currency": "CNY",
		"offpeak": {"in": 1.5, "cached_in": 0, "out": 1}, "peak": {"in": 1, "cached_in": 0, "out": 1}}}})
	_check("费率不是整数", ManifestScript.parse(frac, bv).get("error", ""), ManifestScript.ERR_BAD_MODEL)
	var many := {}
	for i in range(ManifestScript.MAX_MODELS + 1):
		many["m%d" % i] = {"currency": "CNY",
			"offpeak": {"in": 1, "cached_in": 0, "out": 1}, "peak": {"in": 1, "cached_in": 0, "out": 1}}
	_check("条数超上限",
			ManifestScript.parse(_manifest({"models": many}), bv).get("error", ""), ManifestScript.ERR_TOO_MANY_MODELS)
	# 越界的费率必须是 0 才是「上限」的意思（0 元是合法值，不能被上限逻辑误杀）
	var zero_rate := _manifest({"models": {"m": {"currency": "CNY",
		"offpeak": {"in": 0, "cached_in": 0, "out": 0}, "peak": {"in": 0, "cached_in": 0, "out": 0}}}})
	_check_true("全 0 费率（免费模型）是合法的", bool(ManifestScript.parse(zero_rate, bv).get("ok", false)))
	# 错误文案不能是空的（面板要直接显示给玩家）
	_check_true("错误码有可读文案", ManifestScript.error_text(ManifestScript.ERR_OLD_VERSION) != "")


# ────────────────────────── 采纳 / 回退 ──────────────────────────
func _test_apply_and_clear() -> void:
	_price_case("采纳前用内置价", 1000000)
	var r: Dictionary = ManifestScript.parse(_manifest(), PriceTable.VERSION)
	_check_true("采纳这份清单", PriceTable.apply_remote(
			r.get("models", {}), int(r.get("version", 0)), String(r.get("updated", "")), String(r.get("source", ""))))
	_check_true("已标记为有远程清单", PriceTable.has_remote())
	_check("生效版本改成远程的", PriceTable.effective_version(), PriceTable.VERSION + 1)
	_check("来源标 remote", PriceTable.source_of("deepseek-flash"), "remote")
	_check("清单没提到的模型仍是内置来源", PriceTable.source_of("deepseek-reasoner"), "bundled")
	_check("表外模型没有来源", PriceTable.source_of("查无此模型"), "")
	_check("清单里的币种生效", PriceTable.currency_of("deepseek-flash"), "CNY")
	_check("清单里的备注生效", PriceTable.note_of("deepseek-flash"), "测试价")
	# 清单把 deepseek-flash 空闲输入改成 3 元 ⇒ 1M 未命中输入应收 3_000_000 微元
	_check("采纳后用远程价算钱", PriceTable.cost_micros("deepseek-flash", 1000000, 0, 0,
			_sunday_offpeak()), 3000000)
	# 没被清单覆盖的模型必须还是内置价
	_check("未被覆盖的模型仍用内置价", PriceTable.cost_micros("deepseek-reasoner", 1000000, 0, 0,
			_sunday_offpeak()), 4000000)
	PriceTable.clear_remote()
	_check_true("清掉后回到内置", not PriceTable.has_remote())
	_check("生效版本回到内置", PriceTable.effective_version(), PriceTable.VERSION)
	_check("来源回到 bundled", PriceTable.source_of("deepseek-flash"), "bundled")
	_price_case("清掉后金额回到内置价", 1000000)


func _price_case(title: String, expected: int) -> void:
	_check(title, PriceTable.cost_micros("deepseek-flash", 1000000, 0, 0, _sunday_offpeak()), expected)


## 2026-10-04 是周日 ⇒ 全天空闲时段（与 ai_advisor_test 用同一套时间口径）
func _sunday_offpeak() -> int:
	return int(Time.get_unix_time_from_datetime_dict(
			{"year": 2026, "month": 10, "day": 4, "hour": 2, "minute": 0, "second": 0}))


# ────────────────────────── 版本闸门 ──────────────────────────
func _test_version_gate() -> void:
	# 比内置旧：**只能用新价覆盖旧价**，整份不采纳
	var old_payload := _manifest({"version": maxi(PriceTable.VERSION - 1, 1)})
	var parsed: Dictionary = ManifestScript.parse(old_payload, PriceTable.VERSION)
	if PriceTable.VERSION > 1:
		_check("解析阶段就拒绝旧版本", parsed.get("error", ""), ManifestScript.ERR_OLD_VERSION)
		_check_true("旧版本没被采纳", not PriceTable.apply_remote(
				parsed.get("models", {}), 1, "2020-01-01", ""))
		_check_true("拒绝后仍是内置", not PriceTable.has_remote())
	# 同版本：允许（维护者可以只改某个模型的价而不升 version，但那属于自找麻烦；
	# 这里只保证「不因为平版本而崩」，闸门卡的是「更旧」）
	var same: Dictionary = ManifestScript.parse(_manifest({"version": PriceTable.VERSION}), PriceTable.VERSION)
	_check_true("同版本可以通过解析", bool(same.get("ok", false)))
	# 空模型表不许采纳（否则等于把整张表清空）
	_check_true("空模型表不采纳", not PriceTable.apply_remote({}, 99, "x", ""))
	_check_true("拒绝空表后仍是内置", not PriceTable.has_remote())


# ────────────────────────── 来源说明串 ──────────────────────────
func _test_source_text() -> void:
	var bundled_text := PriceTable.source_text()
	_check_true("内置态说明里写着内置版本", bundled_text.contains("内置 VERSION"))
	_check_true("内置态说明里带日期", bundled_text.contains(PriceTable.UPDATED))
	var r: Dictionary = ManifestScript.parse(_manifest(), PriceTable.VERSION)
	PriceTable.apply_remote(r.get("models", {}), int(r.get("version", 0)), "2026-10-05", "https://x/y.json")
	var remote_text := PriceTable.source_text()
	_check_true("在线态说明里写着在线版本", remote_text.contains("在线 VERSION"))
	_check_true("在线态说明里同时保留内置版本（便于对照）", remote_text.contains("内置 VERSION"))
	_check_true("在线态说明里带条数", remote_text.contains("1 个模型"))
	PriceTable.clear_remote()
