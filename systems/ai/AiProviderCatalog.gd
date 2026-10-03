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
		# 2026-10-03 按官方价格页订正：现行是 flash / v4-pro；旧名 chat / reasoner 仍可调用但已不在价格页
		"default_model": "deepseek-flash",
		"models": ["deepseek-flash", "deepseek-v4-pro", "deepseek-chat", "deepseek-reasoner"],
		"key_hint": "platform.deepseek.com",
		"official_site": "https://www.deepseek.com",
		"api_docs": "https://api-docs.deepseek.com/",
		"pricing_url": "https://api-docs.deepseek.com/zh-cn/quick_start/pricing",
		"models_path": "/models",
	},
	"moonshot": {
		"label": "月之暗面 Kimi",
		"dialect": DIALECT_OPENAI,
		"base_url": "https://api.moonshot.cn",
		"path": "/v1/chat/completions",
		"default_model": "moonshot-v1-8k",
		"models": ["moonshot-v1-8k", "moonshot-v1-32k"],
		"key_hint": "platform.moonshot.cn",
		"official_site": "https://www.moonshot.cn",
		# ↓ 会 308 跳到规范地址（浏览器/Intent 会自动跟），不是坏链
		"api_docs": "https://platform.moonshot.cn/docs",
		"pricing_url": "https://platform.moonshot.cn/docs/pricing/chat",
		"models_path": "/v1/models",
	},
	"zhipu": {
		"label": "智谱 GLM",
		"dialect": DIALECT_OPENAI,
		"base_url": "https://open.bigmodel.cn/api/paas/v4",
		"path": "/chat/completions",
		"default_model": "glm-4-flash",
		"models": ["glm-4-flash", "glm-4-plus"],
		"key_hint": "open.bigmodel.cn",
		"official_site": "https://www.bigmodel.cn",
		"api_docs": "https://open.bigmodel.cn/dev/api",
		"pricing_url": "https://www.bigmodel.cn/pricing",
		"models_path": "/models",
	},
	"openai": {
		"label": "OpenAI 官方",
		"dialect": DIALECT_OPENAI,
		"base_url": "https://api.openai.com",
		"path": "/v1/chat/completions",
		"default_model": "gpt-4o-mini",
		"models": ["gpt-4o-mini"],
		"key_hint": "platform.openai.com",
		# ↓ 这三个对非浏览器 UA 会返 403（Cloudflare 拦机器人），地址本身没错
		"official_site": "https://openai.com",
		"api_docs": "https://platform.openai.com/docs",
		"pricing_url": "https://platform.openai.com/docs/pricing",
		"models_path": "/v1/models",
	},
	"openrouter": {
		"label": "OpenRouter（聚合）",
		"dialect": DIALECT_OPENAI,
		"base_url": "https://openrouter.ai/api",
		"path": "/v1/chat/completions",
		# 2026-10-03 实测：openrouter/auto 确实在它家 466 个模型的列表里（这是它自己的自动路由型号，
		# 寿命最长的一个）。聚合站的第三方模型 id 天天变（同一家 DeepSeek 在这里叫
		# "deepseek/deepseek-v4.1-flash"，直连叫 "deepseek-flash"），所以内置列表只放这一个兜底，
		# 其余靠在线同步现取。
		"default_model": "openrouter/auto",
		"models": ["openrouter/auto"],
		"key_hint": "openrouter.ai/keys",
		"official_site": "https://openrouter.ai",
		"api_docs": "https://openrouter.ai/docs",
		"pricing_url": "https://openrouter.ai/models",
		"models_path": "/v1/models",
	},
	"gemini": {
		"label": "Google Gemini",
		"dialect": DIALECT_GEMINI,
		"base_url": "https://generativelanguage.googleapis.com",
		"path": "/v1beta/models/{model}:generateContent",
		"default_model": "gemini-2.0-flash",
		"models": ["gemini-2.0-flash"],
		"key_hint": "aistudio.google.com",
		"official_site": "https://ai.google.dev",
		"api_docs": "https://ai.google.dev/gemini-api/docs",
		"pricing_url": "https://ai.google.dev/gemini-api/docs/pricing",
		"models_path": "/v1beta/models",
	},
	"custom": {
		"label": "自定义（OpenAI 兼容 / 中转站）",
		"dialect": DIALECT_OPENAI,
		"base_url": "",
		"path": "/v1/chat/completions",
		"default_model": "",
		"models": [],
		"key_hint": "自己填 base_url 与模型名",
		# 自定义/中转站没有统一的「列出模型」约定，留空 = 不做在线同步，只用手填
		"official_site": "",
		"api_docs": "",
		"pricing_url": "",
		"models_path": "",
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


## 下面四个是「给玩家看/给玩家点」的元数据。空串 = 该供应商没有这项（如自定义）。
static func official_site_of(provider_id: String) -> String:
	return String(resolve(provider_id).get("official_site", ""))


static func api_docs_of(provider_id: String) -> String:
	return String(resolve(provider_id).get("api_docs", ""))


static func pricing_url_of(provider_id: String) -> String:
	return String(resolve(provider_id).get("pricing_url", ""))


## 「列出模型」接口相对 base_url 的路径。空串 = 该供应商不支持在线同步（只能手填模型名）。
static func models_path_of(provider_id: String) -> String:
	return String(resolve(provider_id).get("models_path", ""))


## 不做在线同步的供应商（自定义/中转站）——面板据此把「同步」按钮置灰
static func supports_model_sync(provider_id: String) -> bool:
	return models_path_of(provider_id) != ""


## 玩家填了 base_url 覆盖就优先用它（中转站 / 自建网关都靠这个）
static func effective_base_url(provider: Dictionary, override: String) -> String:
	var trimmed := override.strip_edges()
	if trimmed != "":
		return trimmed.trim_suffix("/")
	return String(provider.get("base_url", "")).trim_suffix("/")
