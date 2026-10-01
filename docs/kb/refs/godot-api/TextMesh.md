# TextMesh

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`TextMesh` → `PrimitiveMesh` → `Mesh` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/TextMesh.md`

**摘要**：Generate a `PrimitiveMesh` from the text.

## 描述

Generate a `PrimitiveMesh` from the text.
		TextMesh can be generated only when using dynamic fonts with vector glyph contours. Bitmap fonts (including bitmap data in the TrueType/OpenType containers, like color emoji fonts) are not supported.
		The UV layout is arranged in 4 horizontal strips, top to bottom: 40% of the height for the front face, 40% for the back face, 10% for the outer edges and 10% for the inner edges.

## 属性

- **`autowrap_mode`** `int` = `0` · 枚举 `TextServer.AutowrapMode`
  - 其它属性：getter=get_autowrap_mode · setter=set_autowrap_mode
- **`curve_step`** `float` = `0.5`
  - 其它属性：getter=get_curve_step · setter=set_curve_step
- **`depth`** `float` = `0.05`
  - 其它属性：getter=get_depth · setter=set_depth
- **`font`** `Font`
  - 其它属性：getter=get_font · setter=set_font
- **`font_size`** `int` = `16`
  - 其它属性：getter=get_font_size · setter=set_font_size
- **`horizontal_alignment`** `int` = `1` · 枚举 `HorizontalAlignment`
  - 其它属性：getter=get_horizontal_alignment · setter=set_horizontal_alignment
- **`justification_flags`** `int` = `163` · 枚举 `TextServer.JustificationFlag` · 位标志
  - 其它属性：getter=get_justification_flags · is_bitfield=true · setter=set_justification_flags
- **`language`** `String` = `""`
  - 其它属性：getter=get_language · setter=set_language
- **`line_spacing`** `float` = `0.0`
  - 其它属性：getter=get_line_spacing · setter=set_line_spacing
- **`offset`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_offset · setter=set_offset
- **`pixel_size`** `float` = `0.01`
  - 其它属性：getter=get_pixel_size · setter=set_pixel_size
- **`structured_text_bidi_override`** `int` = `0` · 枚举 `TextServer.StructuredTextParser`
  - 其它属性：getter=get_structured_text_bidi_override · setter=set_structured_text_bidi_override
- **`structured_text_bidi_override_options`** `Array` = `[]`
  - 其它属性：getter=get_structured_text_bidi_override_options · setter=set_structured_text_bidi_override_options
- **`text`** `String` = `""`
  - 其它属性：getter=get_text · setter=set_text
- **`text_direction`** `int` = `0` · 枚举 `TextServer.Direction`
  - 其它属性：getter=get_text_direction · setter=set_text_direction
- **`uppercase`** `bool` = `false`
  - 其它属性：getter=is_uppercase · setter=set_uppercase
- **`vertical_alignment`** `int` = `1` · 枚举 `VerticalAlignment`
  - 其它属性：getter=get_vertical_alignment · setter=set_vertical_alignment
- **`width`** `float` = `500.0`
  - 其它属性：getter=get_width · setter=set_width

## 教程链接

- [3D text](None)

