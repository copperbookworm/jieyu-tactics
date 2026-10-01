# ResourceImporterTexture

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ResourceImporterTexture` → `ResourceImporter` → `RefCounted` → `Object`
> 附加属性：api_type=editor
> 自动生成，勿手改。文件：`refs/godot-api/ResourceImporterTexture.md`

**摘要**：Imports an image for use in 2D or 3D rendering.

## 描述

This importer imports `CompressedTexture2D` resources. If you need to process the image in scripts in a more convenient way, use `ResourceImporterImage` instead. See also `ResourceImporterLayeredTexture`.

## 属性

- **`compress/channel_pack`** `int` = `0`
  - 其它属性：getter= · setter=
- **`compress/hdr_compression`** `int` = `1`
  - 其它属性：getter= · setter=
- **`compress/high_quality`** `bool` = `false`
  - 其它属性：getter= · setter=
- **`compress/lossy_quality`** `float` = `0.7`
  - 其它属性：getter= · setter=
- **`compress/mode`** `int` = `0`
  - 其它属性：getter= · setter=
- **`compress/normal_map`** `int` = `0`
  - 其它属性：getter= · setter=
- **`compress/rdo_quality_loss`** `float` = `0.0`
  - 其它属性：getter= · setter=
- **`compress/uastc_level`** `int` = `0`
  - 其它属性：getter= · setter=
- **`detect_3d/compress_to`** `int` = `1`
  - 其它属性：getter= · setter=
- **`editor/convert_colors_with_editor_theme`** `bool` = `false`
  - 其它属性：getter= · setter=
- **`editor/scale_with_editor_scale`** `bool` = `false`
  - 其它属性：getter= · setter=
- **`mipmaps/generate`** `bool` = `false`
  - 其它属性：getter= · setter=
- **`mipmaps/limit`** `int` = `-1`
  - 其它属性：getter= · setter=
- **`process/channel_remap/alpha`** `int` = `3`
  - 其它属性：getter= · setter=
- **`process/channel_remap/blue`** `int` = `2`
  - 其它属性：getter= · setter=
- **`process/channel_remap/green`** `int` = `1`
  - 其它属性：getter= · setter=
- **`process/channel_remap/red`** `int` = `0`
  - 其它属性：getter= · setter=
- **`process/fix_alpha_border`** `bool` = `true`
  - 其它属性：getter= · setter=
- **`process/hdr_as_srgb`** `bool` = `false`
  - 其它属性：getter= · setter=
- **`process/hdr_clamp_exposure`** `bool` = `false`
  - 其它属性：getter= · setter=
- **`process/normal_map_invert_y`** `bool` = `false`
  - 其它属性：deprecated=The same result can be achieved by setting [member process/channel_remap/green] to [code]Green Inverted[/code]. · getter= · setter=
- **`process/premult_alpha`** `bool` = `false`
  - 其它属性：getter= · setter=
- **`process/size_limit`** `int` = `0`
  - 其它属性：getter= · setter=
- **`roughness/mode`** `int` = `0`
  - 其它属性：getter= · setter=
- **`roughness/src_normal`** `String` = `""`
  - 其它属性：getter= · setter=
- **`svg/scale`** `float` = `1.0`
  - 其它属性：getter= · setter=

## 教程链接

- [Importing images](None)

