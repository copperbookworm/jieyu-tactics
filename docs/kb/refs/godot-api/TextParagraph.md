# TextParagraph

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`TextParagraph` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/TextParagraph.md`

**摘要**：Holds a paragraph of text.

## 描述

Abstraction over `TextServer` for handling a single paragraph of text.

## 属性

- **`alignment`** `int` = `0` · 枚举 `HorizontalAlignment`
  - 其它属性：getter=get_alignment · setter=set_alignment
- **`break_flags`** `int` = `3` · 枚举 `TextServer.LineBreakFlag` · 位标志
  - 其它属性：getter=get_break_flags · is_bitfield=true · setter=set_break_flags
- **`custom_punctuation`** `String` = `""`
  - 其它属性：getter=get_custom_punctuation · setter=set_custom_punctuation
- **`direction`** `int` = `0` · 枚举 `TextServer.Direction`
  - 其它属性：getter=get_direction · setter=set_direction
- **`ellipsis_char`** `String` = `"…"`
  - 其它属性：getter=get_ellipsis_char · setter=set_ellipsis_char
- **`justification_flags`** `int` = `163` · 枚举 `TextServer.JustificationFlag` · 位标志
  - 其它属性：getter=get_justification_flags · is_bitfield=true · setter=set_justification_flags
- **`line_spacing`** `float` = `0.0`
  - 其它属性：getter=get_line_spacing · setter=set_line_spacing
- **`max_lines_visible`** `int` = `-1`
  - 其它属性：getter=get_max_lines_visible · setter=set_max_lines_visible
- **`orientation`** `int` = `0` · 枚举 `TextServer.Orientation`
  - 其它属性：getter=get_orientation · setter=set_orientation
- **`preserve_control`** `bool` = `false`
  - 其它属性：getter=get_preserve_control · setter=set_preserve_control
- **`preserve_invalid`** `bool` = `true`
  - 其它属性：getter=get_preserve_invalid · setter=set_preserve_invalid
- **`text_overrun_behavior`** `int` = `0` · 枚举 `TextServer.OverrunBehavior`
  - 其它属性：getter=get_text_overrun_behavior · setter=set_text_overrun_behavior
- **`width`** `float` = `-1.0`
  - 其它属性：getter=get_width · setter=set_width

## 方法

### `add_object(key: Variant, size: Vector2, inline_align: int = 5, length: int = 1, baseline: float = 0.0) -> bool`

Adds inline object to the text buffer, `key` must be unique. In the text, object is represented as `length` object replacement characters.

### `add_string(text: String, font: Font, font_size: int, language: String = "", meta: Variant = null) -> bool`

Adds text span and font to draw it.

### `clear() -> void`

Clears text paragraph (removes text and inline objects).

### `clear_dropcap() -> void`

Removes dropcap.

### `draw(canvas: RID, pos: Vector2, color: Color = Color(1, 1, 1, 1), dc_color: Color = Color(1, 1, 1, 1), oversampling: float = 0.0) -> void`
- 限定：qualifiers=const

Draw all lines of the text and drop cap into a canvas item at a given position, with `color`. `pos` specifies the top left corner of the bounding box. If `oversampling` is greater than zero, it is used as font oversampling factor, otherwise viewport oversampling settings are used.

### `draw_dropcap(canvas: RID, pos: Vector2, color: Color = Color(1, 1, 1, 1), oversampling: float = 0.0) -> void`
- 限定：qualifiers=const

Draw drop cap into a canvas item at a given position, with `color`. `pos` specifies the top left corner of the bounding box. If `oversampling` is greater than zero, it is used as font oversampling factor, otherwise viewport oversampling settings are used.

### `draw_dropcap_outline(canvas: RID, pos: Vector2, outline_size: int = 1, color: Color = Color(1, 1, 1, 1), oversampling: float = 0.0) -> void`
- 限定：qualifiers=const

Draw drop cap outline into a canvas item at a given position, with `color`. `pos` specifies the top left corner of the bounding box. If `oversampling` is greater than zero, it is used as font oversampling factor, otherwise viewport oversampling settings are used.

### `draw_line(canvas: RID, pos: Vector2, line: int, color: Color = Color(1, 1, 1, 1), oversampling: float = 0.0) -> void`
- 限定：qualifiers=const

Draw single line of text into a canvas item at a given position, with `color`. `pos` specifies the top left corner of the bounding box. If `oversampling` is greater than zero, it is used as font oversampling factor, otherwise viewport oversampling settings are used.

### `draw_line_outline(canvas: RID, pos: Vector2, line: int, outline_size: int = 1, color: Color = Color(1, 1, 1, 1), oversampling: float = 0.0) -> void`
- 限定：qualifiers=const

Draw outline of the single line of text into a canvas item at a given position, with `color`. `pos` specifies the top left corner of the bounding box. If `oversampling` is greater than zero, it is used as font oversampling factor, otherwise viewport oversampling settings are used.

### `draw_outline(canvas: RID, pos: Vector2, outline_size: int = 1, color: Color = Color(1, 1, 1, 1), dc_color: Color = Color(1, 1, 1, 1), oversampling: float = 0.0) -> void`
- 限定：qualifiers=const

Draw outlines of all lines of the text and drop cap into a canvas item at a given position, with `color`. `pos` specifies the top left corner of the bounding box. If `oversampling` is greater than zero, it is used as font oversampling factor, otherwise viewport oversampling settings are used.

### `duplicate() -> TextParagraph`
- 限定：qualifiers=const

Duplicates this `TextParagraph`.

### `get_dropcap_lines() -> int`
- 限定：qualifiers=const

Returns number of lines used by dropcap.

### `get_dropcap_rid() -> RID`
- 限定：qualifiers=const

Returns drop cap text buffer RID.

### `get_dropcap_size() -> Vector2`
- 限定：qualifiers=const

Returns drop cap bounding box size.

### `get_inferred_direction() -> int`
- 限定：qualifiers=const

Returns the text writing direction inferred by the BiDi algorithm.

### `get_line_ascent(line: int) -> float`
- 限定：qualifiers=const

Returns the text line ascent (number of pixels above the baseline for horizontal layout or to the left of baseline for vertical).

### `get_line_count() -> int`
- 限定：qualifiers=const

Returns number of lines in the paragraph.

### `get_line_descent(line: int) -> float`
- 限定：qualifiers=const

Returns the text line descent (number of pixels below the baseline for horizontal layout or to the right of baseline for vertical).

### `get_line_object_rect(line: int, key: Variant) -> Rect2`
- 限定：qualifiers=const

Returns bounding rectangle of the inline object.

### `get_line_objects(line: int) -> Array`
- 限定：qualifiers=const

Returns array of inline objects in the line.

### `get_line_range(line: int) -> Vector2i`
- 限定：qualifiers=const

Returns character range of the line.

### `get_line_rid(line: int) -> RID`
- 限定：qualifiers=const

Returns TextServer line buffer RID.

### `get_line_size(line: int) -> Vector2`
- 限定：qualifiers=const

Returns size of the bounding box of the line of text. Returned size is rounded up.

### `get_line_underline_position(line: int) -> float`
- 限定：qualifiers=const

Returns pixel offset of the underline below the baseline.

### `get_line_underline_thickness(line: int) -> float`
- 限定：qualifiers=const

Returns thickness of the underline.

### `get_line_width(line: int) -> float`
- 限定：qualifiers=const

Returns width (for horizontal layout) or height (for vertical) of the line of text.

### `get_non_wrapped_size() -> Vector2`
- 限定：qualifiers=const

Returns the size of the bounding box of the paragraph, without line breaks.

### `get_range() -> Vector2i`
- 限定：qualifiers=const

Returns the character range of the paragraph.

### `get_rid() -> RID`
- 限定：qualifiers=const

Returns TextServer full string buffer RID.

### `get_size() -> Vector2`
- 限定：qualifiers=const

Returns the size of the bounding box of the paragraph.

### `has_object(key: Variant) -> bool`
- 限定：qualifiers=const

Returns `true` if an object with `key` is embedded in this shaped text buffer.

### `hit_test(coords: Vector2) -> int`
- 限定：qualifiers=const

Returns caret character offset at the specified coordinates. This function always returns a valid position.

### `resize_object(key: Variant, size: Vector2, inline_align: int = 5, baseline: float = 0.0) -> bool`

Sets new size and alignment of embedded object.

### `set_bidi_override(override: Array) -> void`

Overrides BiDi for the structured text.
				Override ranges should cover full source text without overlaps. BiDi algorithm will be used on each range separately.

### `set_dropcap(text: String, font: Font, font_size: int, dropcap_margins: Rect2 = Rect2(0, 0, 0, 0), language: String = "") -> bool`

Sets drop cap, overrides previously set drop cap. Drop cap (dropped capital) is a decorative element at the beginning of a paragraph that is larger than the rest of the text.

### `tab_align(tab_stops: PackedFloat32Array) -> void`

Aligns paragraph to the given tab-stops.

