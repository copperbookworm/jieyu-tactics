extends RefCounted

## AI 参谋 —— 估价表（纯函数，可单测）
##
## 口径：费率一律「微元 / 百万 token」的整数。费用按整数微元累加。
## 为什么不用浮点：一分一厘累加会漂，玩家对不上账比不显示金额更糟。
## ⚠ 这是**估算**，供应商的账单以它自己为准 —— UI 必须写清「估算」三个字。
## 价格会变：改价时同时升 VERSION。账本每条记录都存了版本号，历史金额才不会自己变。
## 刻意不写 class_name：引用方 preload。

const VERSION := 1
const UPDATED := "2026-10-02"
const UNKNOWN := -1
## 币种换算基数：1 元 = 1_000_000 微元
const MICROS_PER_UNIT := 1000000

## key = 模型 id（玩家可在 UI 里手填，填了表外的就记「未知价」而不是猜一个数）
const MODELS := {
	"deepseek-chat": {"currency": "CNY", "in": 2000000, "cached_in": 500000, "out": 8000000},
	"deepseek-reasoner": {"currency": "CNY", "in": 4000000, "cached_in": 1000000, "out": 16000000},
	"moonshot-v1-8k": {"currency": "CNY", "in": 12000000, "cached_in": 12000000, "out": 12000000},
	"moonshot-v1-32k": {"currency": "CNY", "in": 24000000, "cached_in": 24000000, "out": 24000000},
	"glm-4-flash": {"currency": "CNY", "in": 0, "cached_in": 0, "out": 0},
	"glm-4-plus": {"currency": "CNY", "in": 50000000, "cached_in": 50000000, "out": 50000000},
	"gpt-4o-mini": {"currency": "USD", "in": 150000, "cached_in": 75000, "out": 600000},
	"gemini-2.0-flash": {"currency": "USD", "in": 100000, "cached_in": 25000, "out": 400000},
}


static func has_model(model_id: String) -> bool:
	return MODELS.has(model_id)


static func currency_of(model_id: String) -> String:
	if not MODELS.has(model_id):
		return ""
	return String((MODELS[model_id] as Dictionary).get("currency", ""))


## 返回微元；表里没有这个模型 → UNKNOWN(-1)，调用方据此记「未知价」
static func cost_micros(model_id: String, prompt_tokens: int, completion_tokens: int,
		cached_tokens: int) -> int:
	if not MODELS.has(model_id):
		return UNKNOWN
	var rate: Dictionary = MODELS[model_id]
	# 缓存命中的那部分按 cached_in 计价，不能既算全价又算缓存价
	var cached := clampi(cached_tokens, 0, maxi(prompt_tokens, 0))
	var billable := maxi(prompt_tokens - cached, 0)
	var total := billable * int(rate["in"])
	total += cached * int(rate["cached_in"])
	total += maxi(completion_tokens, 0) * int(rate["out"])
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
