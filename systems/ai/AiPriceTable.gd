extends RefCounted

## AI 参谋 —— 估价表（纯函数，可单测）
##
## 口径：费率一律「微元 / 百万 token」的整数。费用按整数微元累加。
## 为什么不用浮点：一分一厘累加会漂，玩家对不上账比不显示金额更糟。
## ⚠ 这是**估算**，供应商的账单以它自己为准 —— UI 必须写清「估算」三个字。
## 价格会变：改价时同时升 VERSION。账本每条记录都存了版本号，历史金额才不会自己变。
##
## 【VERSION 2 · 2026-10-03】按 DeepSeek 官方价格页订正：
##   https://api-docs.deepseek.com/zh-cn/quick_start/pricing
##   现行模型是 deepseek-flash / deepseek-v4-pro（旧的 deepseek-chat / deepseek-reasoner 已不在该页，
##   旧名字仍可调用但由新模型提供服务 —— 这里保留为 legacy，费率沿用旧值，仅供历史账目可比）。
##   DeepSeek 现在按**时段**计价：空闲时段 = 高峰时段价格的一半。
##   高峰 = 北京时间周一至周五（不含中国法定节假日）9:00-12:00 与 14:00-18:00；其余时段（含周末）为空闲。
##   ⚠ 中国法定节假日识别不了（没有节假日表），会被当成普通工作日 ⇒ 节假日的空闲优惠可能被少算
##   （即估算偏高）。宁可偏高也不猜低，UI 已注明是估算。
##
## 刻意不写 class_name：引用方 preload。

const VERSION := 2
const UPDATED := "2026-10-03"
const UNKNOWN := -1
## 币种换算基数：1 元 = 1_000_000 微元
const MICROS_PER_UNIT := 1000000

const TIER_PEAK := "peak"
const TIER_OFFPEAK := "offpeak"

## 北京时区相对 UTC 的偏移（秒）
const BEIJING_OFFSET := 8 * 3600
## 高峰时段（北京时间整点）：9:00-12:00 与 14:00-18:00
const PEAK_HOURS := [9, 10, 11, 14, 15, 16, 17]

## key = 模型 id（玩家可在 UI 里手填，填了表外的就记「未知价」而不是猜一个数）
## 每条 = {currency, offpeak:{in,cached_in,out}, peak:{...}, note?}，费率单位＝微元/百万 token。
## 不按时段计价的供应商：offpeak 与 peak 填同一份即可（结果与时段无关）。
const MODELS := {
	"deepseek-flash": {
		"currency": "CNY", "note": "DeepSeek-V4.1-Flash（现行）",
		"offpeak": {"in": 1000000, "cached_in": 20000, "out": 4000000},
		"peak": {"in": 2000000, "cached_in": 40000, "out": 8000000},
	},
	"deepseek-v4-pro": {
		"currency": "CNY", "note": "DeepSeek-V4-Pro-0813（现行）",
		"offpeak": {"in": 4500000, "cached_in": 150000, "out": 13500000},
		"peak": {"in": 9000000, "cached_in": 300000, "out": 27000000},
	},
	"deepseek-chat": {
		"currency": "CNY", "note": "legacy（官方价格页已不列；旧名仍可调用）",
		"offpeak": {"in": 2000000, "cached_in": 500000, "out": 8000000},
		"peak": {"in": 2000000, "cached_in": 500000, "out": 8000000},
	},
	"deepseek-reasoner": {
		"currency": "CNY", "note": "legacy（同上）",
		"offpeak": {"in": 4000000, "cached_in": 1000000, "out": 16000000},
		"peak": {"in": 4000000, "cached_in": 1000000, "out": 16000000},
	},
	"moonshot-v1-8k": {
		"currency": "CNY",
		"offpeak": {"in": 12000000, "cached_in": 12000000, "out": 12000000},
		"peak": {"in": 12000000, "cached_in": 12000000, "out": 12000000},
	},
	"moonshot-v1-32k": {
		"currency": "CNY",
		"offpeak": {"in": 24000000, "cached_in": 24000000, "out": 24000000},
		"peak": {"in": 24000000, "cached_in": 24000000, "out": 24000000},
	},
	"glm-4-flash": {
		"currency": "CNY",
		"offpeak": {"in": 0, "cached_in": 0, "out": 0},
		"peak": {"in": 0, "cached_in": 0, "out": 0},
	},
	"glm-4-plus": {
		"currency": "CNY",
		"offpeak": {"in": 50000000, "cached_in": 50000000, "out": 50000000},
		"peak": {"in": 50000000, "cached_in": 50000000, "out": 50000000},
	},
	"gpt-4o-mini": {
		"currency": "USD",
		"offpeak": {"in": 150000, "cached_in": 75000, "out": 600000},
		"peak": {"in": 150000, "cached_in": 75000, "out": 600000},
	},
	"gemini-2.0-flash": {
		"currency": "USD",
		"offpeak": {"in": 100000, "cached_in": 25000, "out": 400000},
		"peak": {"in": 100000, "cached_in": 25000, "out": 400000},
	},
}


static func has_model(model_id: String) -> bool:
	return MODELS.has(model_id)


static func currency_of(model_id: String) -> String:
	if not MODELS.has(model_id):
		return ""
	return String((MODELS[model_id] as Dictionary).get("currency", ""))


static func note_of(model_id: String) -> String:
	if not MODELS.has(model_id):
		return ""
	return String((MODELS[model_id] as Dictionary).get("note", ""))


## 某个时刻属于高峰还是空闲（按北京时间算）。at_unix <= 0 表示「现在」。
static func tier_at(at_unix: int = 0) -> String:
	var t := at_unix if at_unix > 0 else int(Time.get_unix_time_from_system())
	# Godot 的 get_datetime_dict_from_unix_time 返回 UTC；加 8 小时即北京时间
	var d := Time.get_datetime_dict_from_unix_time(t + BEIJING_OFFSET)
	var weekday := int(d["weekday"])   # 0 = 周日, 1 = 周一 … 6 = 周六
	if weekday < 1 or weekday > 5:
		return TIER_OFFPEAK
	var hour := int(d["hour"])
	if PEAK_HOURS.has(hour):
		return TIER_PEAK
	return TIER_OFFPEAK


## 返回微元；表里没有这个模型 → UNKNOWN(-1)，调用方据此记「未知价」
static func cost_micros(model_id: String, prompt_tokens: int, completion_tokens: int,
		cached_tokens: int, at_unix: int = 0) -> int:
	if not MODELS.has(model_id):
		return UNKNOWN
	var entry: Dictionary = MODELS[model_id]
	var tier: Dictionary = entry.get(tier_at(at_unix), entry.get(TIER_OFFPEAK, {}))
	if tier.is_empty():
		return UNKNOWN
	# 缓存命中的那部分按 cached_in 计价，不能既算全价又算缓存价
	var cached := clampi(cached_tokens, 0, maxi(prompt_tokens, 0))
	var billable := maxi(prompt_tokens - cached, 0)
	var total := billable * int(tier["in"])
	total += cached * int(tier["cached_in"])
	total += maxi(completion_tokens, 0) * int(tier["out"])
	# 四舍五入到微元（+半个单位再整除）
	return (total + MICROS_PER_UNIT / 2) / MICROS_PER_UNIT


## 给玩家看的金额串。micros < 0 = 未知价 → 明确说「未知」，不显示 0 假装免费
static func format_micros(micros: int, currency: String) -> String:
	if micros < 0:
		return "未知"
	var symbol := ""
	match currency:
		"CNY": symbol = "¥"
		"USD": symbol = "$"
		_: symbol = ""
	var units := float(micros) / float(MICROS_PER_UNIT)
	if micros == 0:
		return symbol + "0"
	if units < 0.01:
		return "%s%.5f" % [symbol, units]
	return "%s%.4f" % [symbol, units]
