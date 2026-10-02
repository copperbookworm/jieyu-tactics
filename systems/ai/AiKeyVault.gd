extends RefCounted

## AI 参谋 —— API key 的本机保管（纯函数 + 文件读写，无 autoload 依赖）
##
## ⚠ 说清性质：这是**混淆，不是加密**。密钥材料（盐）就在包里，会逆向的人一定拿得到。
## 之所以接受：key 是玩家自己的，本工程不是攻击面；最坏情形是设备被人物理翻出来。
## 正确做法在 Android 上是 EncryptedSharedPreferences（Keystore 支撑）——那需要一个
## Godot Android 插件（Java/Kotlin），列为后续；在那之前把性质如实告诉玩家，别谎称安全。
##
## 三条红线（配套约定，改动时别破）：
##   ① key 只进请求头，绝不进 URL（URL 会落进代理/日志）
##   ② key 绝不进日志、不进错误文案 —— 对外只给 redact() 的结果
##   ③ key 与普通配置分文件存（ai_advisor.key vs ai_advisor.cfg），清理配置不误伤 key
## 刻意不写 class_name：引用方 preload。

const SALT := "jieyu-ai-advisor-v1"
const PREFIX := "v1:"
const DEFAULT_KEY_PATH := "user://ai_advisor.key"

var path := DEFAULT_KEY_PATH


func _init(key_path := DEFAULT_KEY_PATH) -> void:
	path = key_path


## FNV-1a 取种子（固定常量，跨平台一致）
static func _seed() -> int:
	var h := 2166136261
	for b in SALT.to_utf8_buffer():
		h = (h ^ int(b)) * 16777619
		h = h & 0xFFFFFFFF
	return h


## xorshift32 密钥流 —— 只要确定性就够，不追求密码学强度（见头部说明）
static func _keystream(length: int) -> PackedByteArray:
	var out := PackedByteArray()
	var state := _seed()
	while out.size() < length:
		state = state ^ ((state << 13) & 0xFFFFFFFF)
		state = state ^ (state >> 17)
		state = state ^ ((state << 5) & 0xFFFFFFFF)
		state = state & 0xFFFFFFFF
		out.append(state & 0xFF)
	return out


static func obfuscate(plain: String) -> String:
	if plain == "":
		return ""
	var src := plain.to_utf8_buffer()
	var ks := _keystream(src.size())
	var out := PackedByteArray()
	for i in src.size():
		out.append(src[i] ^ ks[i])
	return PREFIX + Marshalls.raw_to_base64(out)


static func deobfuscate(blob: String) -> String:
	if blob == "":
		return ""
	var payload := blob
	if payload.begins_with(PREFIX):
		payload = payload.substr(PREFIX.length())
	var raw := Marshalls.base64_to_raw(payload)
	if raw.is_empty():
		return ""
	var ks := _keystream(raw.size())
	var out := PackedByteArray()
	for i in raw.size():
		out.append(raw[i] ^ ks[i])
	return out.get_string_from_utf8()


## 对外显示专用：永远不要直接把 key 打出去
static func redact(key: String) -> String:
	var k := key.strip_edges()
	if k == "":
		return "（未填写）"
	if k.length() <= 8:
		return "****"
	return k.substr(0, 4) + "…" + k.substr(k.length() - 4, 4)


func save_key(key: String) -> bool:
	var k := key.strip_edges()
	if k == "":
		clear()
		return true
	var f := FileAccess.open(path, FileAccess.WRITE)
	if f == null:
		return false
	f.store_string(obfuscate(k))
	f.close()
	return true


func load_key() -> String:
	if not FileAccess.file_exists(path):
		return ""
	var blob := FileAccess.get_file_as_string(path)
	return deobfuscate(blob.strip_edges())


func has_key() -> bool:
	return load_key() != ""


func clear() -> void:
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
