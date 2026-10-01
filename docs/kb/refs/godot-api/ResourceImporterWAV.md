# ResourceImporterWAV

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ResourceImporterWAV` → `ResourceImporter` → `RefCounted` → `Object`
> 附加属性：api_type=editor
> 自动生成，勿手改。文件：`refs/godot-api/ResourceImporterWAV.md`

**摘要**：Imports a WAV audio file for playback.

## 描述

WAV is an uncompressed format, which can provide higher quality compared to Ogg Vorbis and MP3. It also has the lowest CPU cost to decode. This means high numbers of WAV sounds can be played at the same time, even on low-end devices.
		By default, Godot imports WAV files using the lossy Quite OK Audio compression. You may change this by setting the `compress/mode` property.

## 属性

- **`compress/mode`** `int` = `2`
  - 其它属性：getter= · setter=
- **`edit/loop_begin`** `int` = `0`
  - 其它属性：getter= · setter=
- **`edit/loop_end`** `int` = `-1`
  - 其它属性：getter= · setter=
- **`edit/loop_mode`** `int` = `0`
  - 其它属性：getter= · setter=
- **`edit/normalize`** `bool` = `false`
  - 其它属性：getter= · setter=
- **`edit/trim`** `bool` = `false`
  - 其它属性：getter= · setter=
- **`force/8_bit`** `bool` = `false`
  - 其它属性：getter= · setter=
- **`force/max_rate`** `bool` = `false`
  - 其它属性：getter= · setter=
- **`force/max_rate_hz`** `float` = `44100`
  - 其它属性：getter= · setter=
- **`force/mono`** `bool` = `false`
  - 其它属性：getter= · setter=

## 教程链接

- [Importing audio samples](None)

