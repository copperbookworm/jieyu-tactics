# AudioStreamMP3

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AudioStreamMP3` → `AudioStream` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AudioStreamMP3.md`

**摘要**：MP3 audio stream driver.

## 描述

MP3 audio stream driver. See `data` if you want to load an MP3 file at run-time. More info can be found in `ResourceImporterMP3`.
		**Note:** This class can optionally support legacy MP1 and MP2 formats, provided that the engine is compiled with the `minimp3_extra_formats=yes` SCons option. These extra formats are not enabled by default.

## 属性

- **`bar_beats`** `int` = `4`
  - 其它属性：getter=get_bar_beats · setter=set_bar_beats
- **`beat_count`** `int` = `0`
  - 其它属性：getter=get_beat_count · setter=set_beat_count
- **`bpm`** `float` = `0.0`
  - 其它属性：getter=get_bpm · setter=set_bpm
- **`data`** `PackedByteArray` = `PackedByteArray()`
  - 其它属性：getter=get_data · setter=set_data
- **`loop`** `bool` = `false`
  - 其它属性：getter=has_loop · setter=set_loop
- **`loop_offset`** `float` = `0.0`
  - 其它属性：getter=get_loop_offset · setter=set_loop_offset

## 方法

### `load_from_buffer(stream_data: PackedByteArray) -> AudioStreamMP3`
- 限定：qualifiers=static

Creates a new `AudioStreamMP3` instance from the given buffer. The buffer must contain MP3 data.

### `load_from_file(path: String) -> AudioStreamMP3`
- 限定：qualifiers=static

Creates a new `AudioStreamMP3` instance from the given file path. The file must be in MP3 format.

## 教程链接

- [Audio streams](None)
- [Runtime file loading and saving](None)

