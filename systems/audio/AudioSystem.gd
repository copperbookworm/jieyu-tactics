extends Node

## 10 章基础音效的播放层（候选 M · 第二轮）—— 注册为 autoload，名字 `Audio`。
##
## 为什么用 autoload：音频是跨场景的（重开一局不该重新合成 PCM），而调用点很多
## （玩家 / 敌人 / 载具 / 间瞄 / 旗点）。播放层不写进 Main —— Main 的 ≤400 行是硬验收线。
## 调用点统一走 systems/audio/Sfx.gd 这个静态入口（它按名字找 autoload，调用点因此不在编译期依赖全局名）。
##
## 并发与限频：每种音效有自己的最小间隔（SFX_MIN_INTERVAL），并按 SFX_MAX_VOICES 轮换复用 player，
## 避免连发时几十个 AudioStreamPlayer 一起炸。
##
## 未做：2D/3D 定位与距离衰减（第一版全是非定位播放）、音量设置界面。

const Procedural := preload("res://systems/audio/ProceduralAudio.gd")

var enabled := true
var master_volume_db := 0.0

var _streams := {}       ## id -> AudioStreamWAV（懒生成，只建一次）
var _players := {}       ## id -> Array[AudioStreamPlayer]
var _next_voice := {}    ## id -> 下一个要用的声部下标
var _last_played := {}   ## id -> 上次播放时刻（秒）


func _ready() -> void:
	# 战局类音效走事件总线（开火 / 命中这类由调用点直接 Sfx.play）
	if EventBus != null and EventBus.has_signal("flag_state_changed"):
		EventBus.connect("flag_state_changed", _on_flag_state_changed)
	if EventBus != null and EventBus.has_signal("enemy_killed"):
		EventBus.connect("enemy_killed", _on_enemy_killed)
	if EventBus != null and EventBus.has_signal("player_downed"):
		EventBus.connect("player_downed", _on_player_downed)
	if EventBus != null and EventBus.has_signal("match_finished"):
		EventBus.connect("match_finished", _on_match_finished)


## 取（必要时合成）一段音效
func stream_for(id: String) -> AudioStreamWAV:
	if _streams.has(id):
		return _streams[id]
	var stream := Procedural.build(id)
	if stream != null:
		_streams[id] = stream
	return stream


## 播放。返回「这次真的播了吗」——关闭 / 未知音效 / 限频拦下都算没播。
func play(id: String, volume_db: float = 0.0) -> bool:
	if not enabled or not Procedural.has_sound(id):
		return false
	var now := Time.get_ticks_msec() / 1000.0
	if now - float(_last_played.get(id, -9999.0)) < GameConfig.SFX_MIN_INTERVAL:
		return false
	var player := _take_player(id)
	if player == null:
		return false
	_last_played[id] = now
	player.volume_db = master_volume_db + volume_db
	player.play()
	return true


## 轮换声部（懒建：第一次播这个音时才建 player）
func _take_player(id: String) -> AudioStreamPlayer:
	var voices: Array = _players.get(id, [])
	if voices.is_empty():
		var stream := stream_for(id)
		if stream == null:
			return null
		for i in GameConfig.SFX_MAX_VOICES:
			var player := AudioStreamPlayer.new()
			player.name = "Sfx_%s_%d" % [id, i]
			player.stream = stream
			add_child(player)
			voices.append(player)
		_players[id] = voices
	var index := int(_next_voice.get(id, 0))
	_next_voice[id] = (index + 1) % voices.size()
	return voices[index]


## 测试 / 调试用：某个音效建了几个声部
func voice_count(id: String) -> int:
	var voices: Array = _players.get(id, [])
	return voices.size()


## 正在播的声部数（测试用）
func playing_count() -> int:
	var count := 0
	for id in _players.keys():
		for player in _players[id]:
			if player.playing:
				count += 1
	return count


func stop_all() -> void:
	for id in _players.keys():
		for player in _players[id]:
			player.stop()


func _on_flag_state_changed(_zone_name, _state) -> void:
	play("flag")


func _on_enemy_killed(_enemy) -> void:
	play("kill")


func _on_player_downed() -> void:
	play("down")


func _on_match_finished(_winner) -> void:
	play("match")
