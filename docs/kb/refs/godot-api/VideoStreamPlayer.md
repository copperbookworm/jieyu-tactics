# VideoStreamPlayer

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VideoStreamPlayer` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VideoStreamPlayer.md`

**摘要**：A control used for video playback.

## 描述

A control used for playback of `VideoStream` resources.
		Supported video formats are Ogg Theora (https://www.theora.org/) (`.ogv`, `VideoStreamTheora`) and any format exposed via a GDExtension plugin.
		**Warning:** On Web, video playback *will* perform poorly due to missing architecture-specific assembly optimizations.

## 属性

- **`audio_track`** `int` = `0`
  - 其它属性：getter=get_audio_track · setter=set_audio_track
- **`autoplay`** `bool` = `false`
  - 其它属性：getter=has_autoplay · setter=set_autoplay
- **`buffering_msec`** `int` = `500`
  - 其它属性：getter=get_buffering_msec · setter=set_buffering_msec
- **`bus`** `StringName` = `&"Master"`
  - 其它属性：getter=get_bus · setter=set_bus
- **`expand`** `bool` = `false`
  - 其它属性：getter=has_expand · setter=set_expand
- **`loop`** `bool` = `false`
  - 其它属性：getter=has_loop · setter=set_loop
- **`paused`** `bool` = `false`
  - 其它属性：getter=is_paused · setter=set_paused
- **`speed_scale`** `float` = `1.0`
  - 其它属性：getter=get_speed_scale · setter=set_speed_scale
- **`stream`** `VideoStream`
  - 其它属性：getter=get_stream · setter=set_stream
- **`stream_position`** `float`
  - 其它属性：getter=get_stream_position · setter=set_stream_position
- **`volume`** `float`
  - 其它属性：getter=get_volume · setter=set_volume
- **`volume_db`** `float` = `0.0`
  - 其它属性：getter=get_volume_db · setter=set_volume_db

## 方法

### `get_stream_length() -> float`
- 限定：qualifiers=const

The length of the current stream, in seconds.

### `get_stream_name() -> String`
- 限定：qualifiers=const

Returns the video stream's name, or `"<No Stream>"` if no video stream is assigned.

### `get_video_texture() -> Texture2D`
- 限定：qualifiers=const

Returns the current frame as a `Texture2D`.

### `is_playing() -> bool`
- 限定：qualifiers=const

Returns `true` if the video is playing.
				**Note:** The video is still considered playing if paused during playback.

### `play() -> void`

Starts the video playback from the beginning. If the video is paused, this will not unpause the video.

### `stop() -> void`

Stops the video playback and sets the stream position to 0.
				**Note:** Although the stream position will be set to 0, the first frame of the video stream won't become the current frame.

## 信号

### `finished()`

Emitted when playback is finished.

## 教程链接

- [Playing videos](None)

