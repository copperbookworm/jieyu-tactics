# SystemFont

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`SystemFont` → `Font` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/SystemFont.md`

**摘要**：A font loaded from a system font. Falls back to a default theme font if not implemented on the host OS.

## 描述

`SystemFont` loads a font from a system font with the first matching name from `font_names`.
		It will attempt to match font style, but it's not guaranteed.
		The returned font might be part of a font collection or be a variable font with OpenType "weight", "width" and/or "italic" features set.
		You can create `FontVariation` of the system font for precise control over its features.
		**Note:** This class is implemented on iOS, Linux, macOS and Windows, on other platforms it will fallback to default theme font.

## 属性

- **`allow_system_fallback`** `bool` = `true`
  - 其它属性：getter=is_allow_system_fallback · setter=set_allow_system_fallback
- **`antialiasing`** `int` = `1` · 枚举 `TextServer.FontAntialiasing`
  - 其它属性：getter=get_antialiasing · setter=set_antialiasing
- **`disable_embedded_bitmaps`** `bool` = `true`
  - 其它属性：getter=get_disable_embedded_bitmaps · setter=set_disable_embedded_bitmaps
- **`font_italic`** `bool` = `false`
  - 其它属性：getter=get_font_italic · setter=set_font_italic
- **`font_names`** `PackedStringArray` = `PackedStringArray()`
  - 其它属性：getter=get_font_names · setter=set_font_names
- **`font_stretch`** `int` = `100`
  - 其它属性：getter=get_font_stretch · setter=set_font_stretch
- **`font_weight`** `int` = `400`
  - 其它属性：getter=get_font_weight · setter=set_font_weight
- **`force_autohinter`** `bool` = `false`
  - 其它属性：getter=is_force_autohinter · setter=set_force_autohinter
- **`generate_mipmaps`** `bool` = `false`
  - 其它属性：getter=get_generate_mipmaps · setter=set_generate_mipmaps
- **`hinting`** `int` = `1` · 枚举 `TextServer.Hinting`
  - 其它属性：getter=get_hinting · setter=set_hinting
- **`keep_rounding_remainders`** `bool` = `true`
  - 其它属性：getter=get_keep_rounding_remainders · setter=set_keep_rounding_remainders
- **`modulate_color_glyphs`** `bool` = `false`
  - 其它属性：getter=is_modulate_color_glyphs · setter=set_modulate_color_glyphs
- **`msdf_pixel_range`** `int` = `16`
  - 其它属性：getter=get_msdf_pixel_range · setter=set_msdf_pixel_range
- **`msdf_size`** `int` = `48`
  - 其它属性：getter=get_msdf_size · setter=set_msdf_size
- **`multichannel_signed_distance_field`** `bool` = `false`
  - 其它属性：getter=is_multichannel_signed_distance_field · setter=set_multichannel_signed_distance_field
- **`oversampling`** `float` = `0.0`
  - 其它属性：getter=get_oversampling · setter=set_oversampling
- **`subpixel_positioning`** `int` = `1` · 枚举 `TextServer.SubpixelPositioning`
  - 其它属性：getter=get_subpixel_positioning · setter=set_subpixel_positioning

