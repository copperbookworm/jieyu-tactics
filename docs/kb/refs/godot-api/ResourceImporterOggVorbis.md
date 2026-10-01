# ResourceImporterOggVorbis

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ResourceImporterOggVorbis` → `ResourceImporter` → `RefCounted` → `Object`
> 附加属性：api_type=editor
> 自动生成，勿手改。文件：`refs/godot-api/ResourceImporterOggVorbis.md`

**摘要**：Imports an Ogg Vorbis audio file for playback.

## 描述

Ogg Vorbis is a lossy audio format, with better audio quality compared to `ResourceImporterMP3` at a given bitrate.
		In most cases, it's recommended to use Ogg Vorbis over MP3. However, if you're using an MP3 sound source with no higher quality source available, then it's recommended to use the MP3 file directly to avoid double lossy compression.
		Ogg Vorbis requires more CPU to decode than `ResourceImporterWAV`. If you need to play a lot of simultaneous sounds, it's recommended to use WAV for those sounds instead, especially if targeting low-end devices.

## 属性

- **`bar_beats`** `int` = `4`
  - 其它属性：getter= · setter=
- **`beat_count`** `int` = `0`
  - 其它属性：getter= · setter=
- **`bpm`** `float` = `0`
  - 其它属性：getter= · setter=
- **`loop`** `bool` = `false`
  - 其它属性：getter= · setter=
- **`loop_offset`** `float` = `0`
  - 其它属性：getter= · setter=

## 方法

### `load_from_buffer(stream_data: PackedByteArray) -> AudioStreamOggVorbis`
- 限定：deprecated=Use [method AudioStreamOggVorbis.load_from_buffer] instead. · qualifiers=static

Creates a new `AudioStreamOggVorbis` instance from the given buffer. The buffer must contain Ogg Vorbis data.

### `load_from_file(path: String) -> AudioStreamOggVorbis`
- 限定：deprecated=Use [method AudioStreamOggVorbis.load_from_file] instead. · qualifiers=static

Creates a new `AudioStreamOggVorbis` instance from the given file path. The file must be in Ogg Vorbis format.

## 教程链接

- [Importing audio samples](None)

