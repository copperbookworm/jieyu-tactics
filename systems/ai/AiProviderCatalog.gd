extends RefCounted

## 《解域》AI 参谋 —— provider 目录（纯数据 + 纯查表，无 autoload 依赖）
##
## 为什么单独一份：玩家自备 API key ⇒ 供应商必须可换。绝大多数国内供应商都兼容
## OpenAI 的 /chat/completions，所以「方言(dialect) + base_url + path」三件套就够了；
## Gemini 的请求/响应形状不同，单独一个 dialect。
##
## 刻意不写 class_name：引用方 preload（见 Cover.gd 头部说明）。
## ⚠ 本文件不得引用 EventBus / Audio / 任何 autoload（--script 跑批环境下编译期拿不到）。

const CATALOG_VERSION := 1

const DIALECT_OPENAI := "openai"
const DIALECT_GEMINI := "gemini"

## 价格口径见 AiPriceTable.gd（按 model id 查）。providers 只放「怎么连」，不放「多少钱」。
const PROVIDERS := {
	"deepseek": {
		"label": "DeepSeek 官方",
		"dialect": DIALECT_OPENAI,
		"base_url": "https://api.deepseek.com",
		"path": "/chat/completions",
		"default_model": "deepseek-chat",
		"models": ["deepseek-chat", "deepseek-reasoner"],
		"key_hint": "platform.deepseek.com",
	},
	"moonshot": {
		"label": "月之暗面 Kimi",
		"dialect": DIALECT_OPENAI,
		"base_url": "https://api.moonshot.cn",
		"path": "/v1/chat/completions",
		"default_model": "moonshot-v1-8k",
		"models": ["moonshot-v1-8k", "moonshot-v1-32k"],
		"key_hint": "platform.moonshot.cn",
	},
	"zhipu": {
		"label": "智谱 GLM",
		"dialect": DIALECT_OPENAI,
		"base_url": "https://open.bigmodel.cn/api/paas/v4",
		"path": "/chat/completions",
		"default_model": "glm-4-flash",
		"models": ["glm-4-flash", "glm-4-plus"],
		"key_hint": "open.bigmodel.cn",
	},
	"openai": {
		"label": "OpenAI 官方",
		"dialect": DIALECT_OPENAI,
		"base_url": "https://api.openai.com",
		"path": "/v1/chat/completions",
		"default_model": "gpt-4o-mini",
		"models": ["gpt-4o-mini"],
		"key_hint": "platform.openai.com",
	},
	"openrouter": {
		"label": "OpenRouter（聚合）",
		"dialect": DIALECT_OPENAI,
		"base_url": "https://openrouter.ai/api",
		"path": "/v1/chat/completions",
		"default_model": "",
		"models": [],
		"key_hint": "openrouter.ai/keys",
	},
	"gemini": {
		"label": "Google Gemini",
		"dialect": DIALECT_GEMINI,
		"base_url": "https://generativelanguage.googleapis.com",
		"path": "/v1beta/models/{model}:generateContent",
		"default_model": "gemini-2.0-flash",
		"models": ["gemini-2.0-flash"],
		"key_hint": "aistudio.google.com",
	},
	"custom": {
		"label": "自定义（OpenAI 兼容 / 中转站）",
		"dialect": DIALECT_OPENAI,
		"base_url": "",
		"path": "/v1/chat/completions",
		"default_model": "",
		"models": [],
		"key_hint": "自己填 base_url 与模型名",
	},
}


## 全部 provider id（稳定的展示顺序：国内优先，玩家在国内直连得通）
static func ids() -> Array:
	return ["deepseek", "moonshot", "zhipu", "openai", "openrouter", "gemini", "custom"]


## 查一条 provider 配置；未知 id 回落 custom（不让一条脏配置把整条链弄崩）
static func resolve(provider_id: String) -> Dictionary:
	if PROVIDERS.has(provider_id):
		var entry: Dictionary = PROVIDERS[provider_id].duplicate()
		entry["id"] = provider_id
		return entry
	var fallback: Dictionary = PROVIDERS["custom"].duplicate()
	fallback["id"] = "custom"
	return fallback


static func label_of(provider_id: String) -> String:
	return String(resolve(provider_id).get("label", provider_id))


static func dialect_of(provider_id: String) -> String:
	return String(resolve(provider_id).get("dialect", DIALECT_OPENAI))


## 玩家填了 base_url 覆盖就优先用它（中转站 / 自建网关都靠这个）
static func effective_base_url(provider: Dictionary, override: String) -> String:
	var trimmed := override.strip_edges()
	if trimmed != "":
		return trimmed.trim_suffix("/")
	return String(provider.get("base_url", "")).trim_suffix("/")
