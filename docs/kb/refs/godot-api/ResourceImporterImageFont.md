# ResourceImporterImageFont

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ResourceImporterImageFont` → `ResourceImporter` → `RefCounted` → `Object`
> 附加属性：api_type=editor
> 自动生成，勿手改。文件：`refs/godot-api/ResourceImporterImageFont.md`

**摘要**：Imports a bitmap font where all glyphs have the same width and height.

## 描述

This image-based workflow can be easier to use than `ResourceImporterBMFont`, but it requires all glyphs to have the same width and height, glyph advances and drawing offsets can be customized. This makes `ResourceImporterImageFont` most suited to fixed-width fonts.
		See also `ResourceImporterDynamicFont`.

## 属性

- **`ascent`** `int` = `0`
  - 其它属性：getter= · setter=
- **`character_margin`** `Rect2i` = `Rect2i(0, 0, 0, 0)`
  - 其它属性：getter= · setter=
- **`character_ranges`** `PackedStringArray` = `PackedStringArray()`
  - 其它属性：getter= · setter=
- **`columns`** `int` = `1`
  - 其它属性：getter= · setter=
- **`compress`** `bool` = `true`
  - 其它属性：getter= · setter=
- **`descent`** `int` = `0`
  - 其它属性：getter= · setter=
- **`fallbacks`** `Array` = `[]`
  - 其它属性：getter= · setter=
- **`image_margin`** `Rect2i` = `Rect2i(0, 0, 0, 0)`
  - 其它属性：getter= · setter=
- **`kerning_pairs`** `PackedStringArray` = `PackedStringArray()`
  - 其它属性：getter= · setter=
- **`rows`** `int` = `1`
  - 其它属性：getter= · setter=
- **`scaling_mode`** `int` = `2`
  - 其它属性：getter= · setter=

## 教程链接

- [Bitmap fonts - Using fonts](None)

