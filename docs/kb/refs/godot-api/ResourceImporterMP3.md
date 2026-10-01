# ResourceImporterMP3

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ResourceImporterMP3` → `ResourceImporter` → `RefCounted` → `Object`
> 附加属性：api_type=editor
> 自动生成，勿手改。文件：`refs/godot-api/ResourceImporterMP3.md`

**摘要**：Imports an MP3 audio file for playback.

## 描述

MP3 is a lossy audio format, with worse audio quality compared to `ResourceImporterOggVorbis` at a given bitrate.
		In most cases, it's recommended to use Ogg Vorbis over MP3. However, if you're using an MP3 sound source with no higher quality source available, then it's recommended to use the MP3 file directly to avoid double lossy compression.
		MP3 requires more CPU to decode than `ResourceImporterWAV`. If you need to play a lot of simultaneous sounds, it's recommended to use WAV for those sounds instead, especially if targeting low-end devices.

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

## 教程链接

- [Importing audio samples](None)

