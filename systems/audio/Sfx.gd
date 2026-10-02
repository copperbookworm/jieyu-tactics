extends RefCounted

## 音效调用点（候选 M · 第二轮）
##
## 为什么再包一层：调用点（Player / Enemy / VehicleController / IndirectController）不该在编译期依赖
## autoload 的全局名 —— 项目既有约定就是「autoload 只防御式使用」，而 --headless --script 的跑批环境
## 更是踩过「Identifier not found: EventBus」这类坑。这里在运行时按节点名找到 autoload，
## 找不到（例如纯逻辑单测、或没注册）就什么都不做。
##
## 用法：const Sfx := preload("res://systems/audio/Sfx.gd") 然后 Sfx.play("shot")
## 刻意不写 class_name：引用方 preload（见 Cover.gd 头部说明）


## 播放一段音效；返回「真的播了吗」（找不到播放层 / 限频 / 未知音效都是 false）
static func play(id: String, volume_db: float = 0.0) -> bool:
	var audio := find_audio()
	if audio == null:
		return false
	return bool(audio.play(id, volume_db))


## 运行时找 autoload（不写全局名，因此 --script / 单测环境都安全）
static func find_audio() -> Node:
	var loop := Engine.get_main_loop() as SceneTree
	if loop == null or loop.root == null:
		return null
	var audio := loop.root.get_node_or_null("Audio")
	if audio == null or not audio.has_method("play"):
		return null
	return audio
