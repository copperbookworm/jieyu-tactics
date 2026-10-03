extends RefCounted

## AI 参谋 —— 远程价格清单（纯函数，可单测）
##
## 为什么要有它：模型名能靠供应商的「列出模型」接口现取，但**「多少钱」没有同类接口**
## （OpenRouter 的 /models 里带 pricing，DeepSeek / OpenAI 都不带）。价格一变，
## 玩家就只能等发新版。本模块让维护者把价格放在一份**静态 JSON** 里，游戏拉一次就更新，
## 于是改价不用再发版。
##
## ⚠ 这块是给玩家算钱的，宁可拒绝也不猜。边界如下：
##   · 只接受 **https** 清单地址（http 明文清单能被中间人换成任意价格）
##   · **严格校验**：schema 版本、字段类型、费率上下限、模型条数上限；多余的字段直接拒绝
##   · **版本只能升不能降**：清单 version < 内置 VERSION ⇒ 整份不采纳，绝不用旧价覆盖新价
##   · 校验不过 ⇒ 保持内置表，只写一行提示；**绝不半采纳**
##   · 只影响**显示用的估算**，永远不参与计费、也不进游戏状态（估算本身标着「估算」）
##   · 清单里没有玩家任何信息：游戏只发一个 GET，不带 key、不带任何标识
##
## 清单格式（schema 1）：
##   {
##     "schema": 1,
##     "version": 3,
##     "updated": "2026-10-05",
##     "source": "https://…",              // 便于玩家自己核对
##     "note": "…",
##     "models": {
##       "deepseek-flash": {"currency": "CNY",
##           "offpeak": {"in": 1000000, "cached_in": 20000, "out": 4000000},
##           "peak":    {"in": 2000000, "cached_in": 40000, "out": 8000000},
##           "note": "…"}
##     }
##   }
## 覆盖语义：**按模型整体替换**（清单里给了某个模型就用清单那一份，不做字段级半合并）；
## 清单没提到的模型继续用内置值。半合并看着聪明，出问题时找不到是谁写的。
##
## 刻意不写 class_name：引用方 preload。

const SCHEMA := 1
## 条数上限：一份清单塞几千个模型没有意义，只会是写错了
const MAX_MODELS := 256
## 费率上限（微元 / 百万 token）：1000 元每百万 token。再贵也不像正常对话模型的价格，
## 多半是把「分」当成了「元」之类的笔误 —— 宁可拒绝，也不让玩家的估算被离谱数字带偏。
const MAX_RATE := 1000000000
const CURRENCIES := ["CNY", "USD"]
const TIER_KEYS := ["in", "cached_in", "out"]

const ERR_NONE := ""
const ERR_BAD_JSON := "bad_json"
const ERR_NOT_OBJECT := "not_object"
const ERR_BAD_SCHEMA := "bad_schema"
const ERR_SCHEMA_TOO_NEW := "schema_too_new"
const ERR_BAD_VERSION := "bad_version"
const ERR_OLD_VERSION := "old_version"
const ERR_BAD_UPDATED := "bad_updated"
const ERR_BAD_SOURCE := "bad_source"
const ERR_TOO_MANY_MODELS := "too_many_models"
const ERR_EMPTY_MODELS := "empty_models"
const ERR_BAD_MODEL := "bad_model"


## 解析并校验清单。bundled_version = 包内置表版本（清单比它旧就整份不采纳）。
## 返回 {ok, error, error_detail, schema, version, updated, source, note, models, model_count}
static func parse(text: String, bundled_version: int) -> Dictionary:
	var json := JSON.new()
	if json.parse(text) != OK:
		return _fail(ERR_BAD_JSON, "")
	var root: Variant = json.data
	if typeof(root) != TYPE_DICTIONARY:
		return _fail(ERR_NOT_OBJECT, "")

	var d: Dictionary = root
	var schema_val: Variant = d.get("schema", null)
	if not _is_number(schema_val):
		return _fail(ERR_BAD_SCHEMA, "schema 不是数字")
	var schema := int(schema_val)
	if schema > SCHEMA:
		return _fail(ERR_SCHEMA_TOO_NEW, "清单 schema %d 比本程序认识的 %d 新" % [schema, SCHEMA])
	if schema != SCHEMA:
		return _fail(ERR_BAD_SCHEMA, "schema = %d" % schema)

	var version_val: Variant = d.get("version", null)
	if not _is_number(version_val):
		return _fail(ERR_BAD_VERSION, "version 不是数字")
	var version := int(version_val)
	if version <= 0:
		return _fail(ERR_BAD_VERSION, "version = %d" % version)
	if version < bundled_version:
		return _fail(ERR_OLD_VERSION, "清单 version %d 比内置 %d 旧" % [version, bundled_version])

	var updated := String(d.get("updated", "")).strip_edges()
	if updated == "":
		return _fail(ERR_BAD_UPDATED, "缺 updated")

	var source := String(d.get("source", "")).strip_edges()
	if source != "" and not source.begins_with("https://"):
		return _fail(ERR_BAD_SOURCE, "source 必须是 https")

	var models_val: Variant = d.get("models", null)
	if typeof(models_val) != TYPE_DICTIONARY:
		return _fail(ERR_BAD_MODEL, "models 不是对象")
	var raw: Dictionary = models_val
	if raw.is_empty():
		return _fail(ERR_EMPTY_MODELS, "")
	if raw.size() > MAX_MODELS:
		return _fail(ERR_TOO_MANY_MODELS, "%d 条 > 上限 %d" % [raw.size(), MAX_MODELS])

	var models := {}
	for key in raw.keys():
		var id := String(key).strip_edges()
		if id == "":
			return _fail(ERR_BAD_MODEL, "空模型名")
		var entry_val: Variant = raw[key]
		if typeof(entry_val) != TYPE_DICTIONARY:
			return _fail(ERR_BAD_MODEL, "%s：条目不是对象" % id)
		var entry: Dictionary = entry_val
		var checked := _check_entry(id, entry)
		if not bool(checked.get("ok", false)):
			return _fail(ERR_BAD_MODEL, String(checked.get("detail", id)))
		models[id] = checked.get("entry", {})

	return {
		"ok": true, "error": ERR_NONE, "error_detail": "",
		"schema": schema, "version": version, "updated": updated,
		"source": source, "note": String(d.get("note", "")),
		"models": models, "model_count": models.size(),
	}


## 校验一条模型条目：币种合法 + 两个时段齐全 + 每个费率是 0..MAX_RATE 的整数
static func _check_entry(id: String, entry: Dictionary) -> Dictionary:
	var currency := String(entry.get("currency", ""))
	if not CURRENCIES.has(currency):
		return {"ok": false, "detail": "%s：currency = \"%s\"（只认 %s）" % [id, currency, "/".join(CURRENCIES)]}
	var tiers := {}
	for tier_name in ["offpeak", "peak"]:
		var tier_val: Variant = entry.get(tier_name, null)
		if typeof(tier_val) != TYPE_DICTIONARY:
			return {"ok": false, "detail": "%s：缺 %s" % [id, tier_name]}
		var tier: Dictionary = tier_val
		var out := {}
		for k in TIER_KEYS:
			var rate := _rate_of(tier.get(k, null))
			if rate < 0:
				return {"ok": false, "detail": "%s.%s.%s 不是 0..%d 的整数" % [id, tier_name, k, MAX_RATE]}
			out[k] = rate
		tiers[tier_name] = out
	return {"ok": true, "detail": "", "entry": {
		"currency": currency, "note": String(entry.get("note", "")),
		"offpeak": tiers["offpeak"], "peak": tiers["peak"],
	}}


## 合法费率 → 整数；非法 → -1（费率不可能是负数，用它当哨兵很安全）
static func _rate_of(v: Variant) -> int:
	if not _is_number(v):
		return -1
	var f := float(v)
	var n := int(v)
	if float(n) != f:
		return -1
	if n < 0 or n > MAX_RATE:
		return -1
	return n


static func _is_number(v: Variant) -> bool:
	return typeof(v) == TYPE_INT or typeof(v) == TYPE_FLOAT


static func _fail(code: String, detail: String) -> Dictionary:
	return {"ok": false, "error": code, "error_detail": detail,
		"schema": 0, "version": 0, "updated": "", "source": "", "note": "",
		"models": {}, "model_count": 0}


## 给维护者用的生成器：按同一套 schema 组装清单（tools/price_manifest_build.gd 用它），
## 于是「格式定义」只有这一处，生成与解析不会各写一套。
static func build_payload(models: Dictionary, version: int, updated: String,
		source: String, note: String) -> Dictionary:
	return {
		"schema": SCHEMA,
		"version": version,
		"updated": updated,
		"source": source,
		"note": note,
		"models": models,
	}


## 错误的玩家可读说法（面板/日志用）
static func error_text(code: String) -> String:
	match code:
		ERR_NONE: return ""
		ERR_BAD_JSON: return "清单不是合法 JSON"
		ERR_NOT_OBJECT: return "清单顶层不是对象"
		ERR_BAD_SCHEMA: return "清单格式版本不对"
		ERR_SCHEMA_TOO_NEW: return "清单用的格式比本程序新，请更新游戏"
		ERR_BAD_VERSION: return "清单缺 version 或它不是正整数"
		ERR_OLD_VERSION: return "清单比内置价格表旧 —— 不采纳（绝不用旧价覆盖新价）"
		ERR_BAD_UPDATED: return "清单缺 updated"
		ERR_BAD_SOURCE: return "清单的 source 不是 https"
		ERR_TOO_MANY_MODELS: return "清单模型条数超过上限"
		ERR_EMPTY_MODELS: return "清单里一个模型都没有"
		ERR_BAD_MODEL: return "清单里有不合格的模型条目"
		_: return "清单有问题（%s）" % code
