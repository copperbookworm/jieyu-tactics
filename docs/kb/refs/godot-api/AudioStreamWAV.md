# AudioStreamWAV

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AudioStreamWAV` → `AudioStream` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AudioStreamWAV.md`

**摘要**：Stores audio data loaded from WAV files.

## 描述

AudioStreamWAV stores sound samples loaded from WAV files. To play the stored sound, use an `AudioStreamPlayer` (for non-positional audio) or `AudioStreamPlayer2D`/`AudioStreamPlayer3D` (for positional audio). The sound can be looped.
		This class can also be used to store dynamically-generated PCM audio data. See also `AudioStreamGenerator` for procedural audio generation.

## 属性

- **`data`** `PackedByteArray` = `PackedByteArray()`
  - 其它属性：getter=get_data · setter=set_data
- **`format`** `int` = `0` · 枚举 `AudioStreamWAV.Format`
  - 其它属性：getter=get_format · setter=set_format
- **`loop_begin`** `int` = `0`
  - 其它属性：getter=get_loop_begin · setter=set_loop_begin
- **`loop_end`** `int` = `0`
  - 其它属性：getter=get_loop_end · setter=set_loop_end
- **`loop_mode`** `int` = `0` · 枚举 `AudioStreamWAV.LoopMode`
  - 其它属性：getter=get_loop_mode · setter=set_loop_mode
- **`mix_rate`** `int` = `44100`
  - 其它属性：getter=get_mix_rate · setter=set_mix_rate
- **`stereo`** `bool` = `false`
  - 其它属性：getter=is_stereo · setter=set_stereo
- **`tags`** `Dictionary` = `{}`
  - 其它属性：getter=get_tags · setter=set_tags

## 方法

### `load_from_buffer(stream_data: PackedByteArray, options: Dictionary = {}) -> AudioStreamWAV`
- 限定：qualifiers=static

Creates a new `AudioStreamWAV` instance from the given buffer. The buffer must contain WAV data.
				The keys and values of `options` match the properties of `ResourceImporterWAV`. The usage of `options` is identical to `AudioStreamWAV.load_from_file`.

### `load_from_file(path: String, options: Dictionary = {}) -> AudioStreamWAV`
- 限定：qualifiers=static

Creates a new `AudioStreamWAV` instance from the given file path. The file must be in WAV format.
				The keys and values of `options` match the properties of `ResourceImporterWAV`.
				**Example:** Load the first file dropped as a WAV and play it:
				
```gdscript
				@onready var audio_player = $AudioStreamPlayer

				func _ready():
					get_window().files_dropped.connect(_on_files_dropped)

				func _on_files_dropped(files):
					if files[0].get_extension() == "wav":
						audio_player.stream = AudioStreamWAV.load_from_file(files[0], {
								"force/max_rate": true,
								"force/max_rate_hz": 11025
							})
						audio_player.play()
				
```

### `save_to_wav(path: String) -> int`

Saves the AudioStreamWAV as a WAV file to `path`. Samples with IMA ADPCM or Quite OK Audio formats can't be saved.
				**Note:** A `.wav` extension is automatically appended to `path` if it is missing.

## 枚举

### `Format`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `FORMAT_8_BITS` |  |
| `1` | `FORMAT_16_BITS` |  |
| `2` | `FORMAT_IMA_ADPCM` |  |
| `3` | `FORMAT_QOA` |  |

### `LoopMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `LOOP_DISABLED` |  |
| `1` | `LOOP_FORWARD` |  |
| `2` | `LOOP_PINGPONG` |  |
| `3` | `LOOP_BACKWARD` |  |

## 教程链接

- [Audio streams](None)
- [Runtime file loading and saving](None)

