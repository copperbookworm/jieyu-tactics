# AudioStreamPlaybackInteractive

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AudioStreamPlaybackInteractive` → `AudioStreamPlayback` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AudioStreamPlaybackInteractive.md`

**摘要**：Playback component of `AudioStreamInteractive`.

## 描述

Playback component of `AudioStreamInteractive`. Contains functions to change the currently played clip.

## 方法

### `get_current_clip_index() -> int`
- 限定：qualifiers=const

Return the index of the currently playing clip. You can use this to get the name of the currently playing clip with `AudioStreamInteractive.get_clip_name`.
				**Example:** Get the currently playing clip name from inside an `AudioStreamPlayer` node.
				`codeblocks`
				`gdscript`
				var playing_clip_name = stream.get_clip_name(get_stream_playback().get_current_clip_index())

### `switch_to_clip(clip_index: int) -> void`

Switch to a clip (by index).

### `switch_to_clip_by_name(clip_name: StringName) -> void`

Switch to a clip (by name).

