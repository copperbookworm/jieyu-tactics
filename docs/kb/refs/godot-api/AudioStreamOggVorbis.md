# AudioStreamOggVorbis

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AudioStreamOggVorbis` → `AudioStream` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AudioStreamOggVorbis.md`

**摘要**：A class representing an Ogg Vorbis audio stream.

## 描述

The AudioStreamOggVorbis class is a specialized `AudioStream` for handling Ogg Vorbis file formats. It offers functionality for loading and playing back Ogg Vorbis files, as well as managing looping and other playback properties. More info can be found in `ResourceImporterOggVorbis`.
		This class is part of the audio stream system, which also supports WAV files through the `AudioStreamWAV` class, and MP3 files through the `AudioStreamMP3` class.

## 属性

- **`bar_beats`** `int` = `4`
  - 其它属性：getter=get_bar_beats · setter=set_bar_beats
- **`beat_count`** `int` = `0`
  - 其它属性：getter=get_beat_count · setter=set_beat_count
- **`bpm`** `float` = `0.0`
  - 其它属性：getter=get_bpm · setter=set_bpm
- **`loop`** `bool` = `false`
  - 其它属性：getter=has_loop · setter=set_loop
- **`loop_offset`** `float` = `0.0`
  - 其它属性：getter=get_loop_offset · setter=set_loop_offset
- **`packet_sequence`** `OggPacketSequence`
  - 其它属性：getter=get_packet_sequence · setter=set_packet_sequence
- **`tags`** `Dictionary` = `{}`
  - 其它属性：getter=get_tags · setter=set_tags

## 方法

### `load_from_buffer(stream_data: PackedByteArray) -> AudioStreamOggVorbis`
- 限定：qualifiers=static

Creates a new `AudioStreamOggVorbis` instance from the given buffer. The buffer must contain Ogg Vorbis data.

### `load_from_file(path: String) -> AudioStreamOggVorbis`
- 限定：qualifiers=static

Creates a new `AudioStreamOggVorbis` instance from the given file path. The file must be in Ogg Vorbis format.

## 教程链接

- [Audio streams](None)
- [Runtime file loading and saving](None)

