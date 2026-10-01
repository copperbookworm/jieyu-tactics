# AudioStreamPolyphonic

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AudioStreamPolyphonic` → `AudioStream` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AudioStreamPolyphonic.md`

**摘要**：AudioStream that lets the user play custom streams at any time from code, simultaneously using a single player.

## 描述

AudioStream that lets the user play custom streams at any time from code, simultaneously using a single player.
		Playback control is done via the `AudioStreamPlaybackPolyphonic` instance set inside the player, which can be obtained via `AudioStreamPlayer.get_stream_playback`, `AudioStreamPlayer2D.get_stream_playback` or `AudioStreamPlayer3D.get_stream_playback` methods. Obtaining the playback instance is only valid after the `stream` property is set as an `AudioStreamPolyphonic` in those players.

## 属性

- **`polyphony`** `int` = `32`
  - 其它属性：getter=get_polyphony · setter=set_polyphony

## 教程链接

- [Audio streams](None)

