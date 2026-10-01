# ResourceImporterDynamicFont

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ResourceImporterDynamicFont` → `ResourceImporter` → `RefCounted` → `Object`
> 附加属性：api_type=editor
> 自动生成，勿手改。文件：`refs/godot-api/ResourceImporterDynamicFont.md`

**摘要**：Imports a TTF, TTC, OTF, OTC, WOFF or WOFF2 font file for font rendering that adapts to any size.

## 描述

Unlike bitmap fonts, dynamic fonts can be resized to any size and still look crisp. Dynamic fonts also optionally support MSDF font rendering, which allows for run-time scale changes with no re-rasterization cost.
		While WOFF and especially WOFF2 tend to result in smaller file sizes, there is no universally "better" font format. In most situations, it's recommended to use the font format that was shipped on the font developer's website.
		See also `ResourceImporterBMFont` and `ResourceImporterImageFont`.

## 属性

- **`allow_system_fallback`** `bool` = `true`
  - 其它属性：getter= · setter=
- **`antialiasing`** `int` = `1`
  - 其它属性：getter= · setter=
- **`compress`** `bool` = `true`
  - 其它属性：getter= · setter=
- **`disable_embedded_bitmaps`** `bool` = `true`
  - 其它属性：getter= · setter=
- **`fallbacks`** `Array` = `[]`
  - 其它属性：getter= · setter=
- **`force_autohinter`** `bool` = `false`
  - 其它属性：getter= · setter=
- **`generate_mipmaps`** `bool` = `false`
  - 其它属性：getter= · setter=
- **`hinting`** `int` = `3`
  - 其它属性：getter= · setter=
- **`keep_rounding_remainders`** `bool` = `true`
  - 其它属性：getter= · setter=
- **`language_support`** `Dictionary` = `{}`
  - 其它属性：getter= · setter=
- **`modulate_color_glyphs`** `bool` = `false`
  - 其它属性：getter= · setter=
- **`msdf_pixel_range`** `int` = `8`
  - 其它属性：getter= · setter=
- **`msdf_size`** `int` = `48`
  - 其它属性：getter= · setter=
- **`multichannel_signed_distance_field`** `bool` = `false`
  - 其它属性：getter= · setter=
- **`opentype_features`** `Dictionary` = `{}`
  - 其它属性：getter= · setter=
- **`oversampling`** `float` = `0.0`
  - 其它属性：getter= · setter=
- **`preload`** `Array` = `[]`
  - 其它属性：getter= · setter=
- **`script_support`** `Dictionary` = `{}`
  - 其它属性：getter= · setter=
- **`subpixel_positioning`** `int` = `4`
  - 其它属性：getter= · setter=

## 教程链接

- [Dynamic fonts - Using fonts](None)

