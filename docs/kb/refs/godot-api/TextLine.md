# TextLine

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`TextLine` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/TextLine.md`

**摘要**：Holds a line of text.

## 描述

Abstraction over `TextServer` for handling a single line of text.

## 属性

- **`alignment`** `int` = `0` · 枚举 `HorizontalAlignment`
  - 其它属性：getter=get_horizontal_alignment · setter=set_horizontal_alignment
- **`direction`** `int` = `0` · 枚举 `TextServer.Direction`
  - 其它属性：getter=get_direction · setter=set_direction
- **`ellipsis_char`** `String` = `"…"`
  - 其它属性：getter=get_ellipsis_char · setter=set_ellipsis_char
- **`flags`** `int` = `3` · 枚举 `TextServer.JustificationFlag` · 位标志
  - 其它属性：getter=get_flags · is_bitfield=true · setter=set_flags
- **`orientation`** `int` = `0` · 枚举 `TextServer.Orientation`
  - 其它属性：getter=get_orientation · setter=set_orientation
- **`preserve_control`** `bool` = `false`
  - 其它属性：getter=get_preserve_control · setter=set_preserve_control
- **`preserve_invalid`** `bool` = `true`
  - 其它属性：getter=get_preserve_invalid · setter=set_preserve_invalid
- **`text_overrun_behavior`** `int` = `3` · 枚举 `TextServer.OverrunBehavior`
  - 其它属性：getter=get_text_overrun_behavior · setter=set_text_overrun_behavior
- **`width`** `float` = `-1.0`
  - 其它属性：getter=get_width · setter=set_width

## 方法

### `add_object(key: Variant, size: Vector2, inline_align: int = 5, length: int = 1, baseline: float = 0.0) -> bool`

Adds inline object to the text buffer, `key` must be unique. In the text, object is represented as `length` object replacement characters.

### `add_string(text: String, font: Font, font_size: int, language: String = "", meta: Variant = null) -> bool`

Adds text span and font to draw it.

### `clear() -> void`

Clears text line (removes text and inline objects).

### `draw(canvas: RID, pos: Vector2, color: Color = Color(1, 1, 1, 1), oversampling: float = 0.0) -> void`
- 限定：qualifiers=const

Draw text into a canvas item at a given position, with `color`. `pos` specifies the top left corner of the bounding box. If `oversampling` is greater than zero, it is used as font oversampling factor, otherwise viewport oversampling settings are used.

### `draw_outline(canvas: RID, pos: Vector2, outline_size: int = 1, color: Color = Color(1, 1, 1, 1), oversampling: float = 0.0) -> void`
- 限定：qualifiers=const

Draw text into a canvas item at a given position, with `color`. `pos` specifies the top left corner of the bounding box. If `oversampling` is greater than zero, it is used as font oversampling factor, otherwise viewport oversampling settings are used.

### `duplicate() -> TextLine`
- 限定：qualifiers=const

Duplicates this `TextLine`.

### `get_inferred_direction() -> int`
- 限定：qualifiers=const

Returns the text writing direction inferred by the BiDi algorithm.

### `get_line_ascent() -> float`
- 限定：qualifiers=const

Returns the text ascent (number of pixels above the baseline for horizontal layout or to the left of baseline for vertical).

### `get_line_descent() -> float`
- 限定：qualifiers=const

Returns the text descent (number of pixels below the baseline for horizontal layout or to the right of baseline for vertical).

### `get_line_underline_position() -> float`
- 限定：qualifiers=const

Returns pixel offset of the underline below the baseline.

### `get_line_underline_thickness() -> float`
- 限定：qualifiers=const

Returns thickness of the underline.

### `get_line_width() -> float`
- 限定：qualifiers=const

Returns width (for horizontal layout) or height (for vertical) of the text.

### `get_object_rect(key: Variant) -> Rect2`
- 限定：qualifiers=const

Returns bounding rectangle of the inline object.

### `get_objects() -> Array`
- 限定：qualifiers=const

Returns array of inline objects.

### `get_rid() -> RID`
- 限定：qualifiers=const

Returns TextServer buffer RID.

### `get_size() -> Vector2`
- 限定：qualifiers=const

Returns size of the bounding box of the text.

### `has_object(key: Variant) -> bool`
- 限定：qualifiers=const

Returns `true` if an object with `key` is embedded in this line.

### `hit_test(coords: float) -> int`
- 限定：qualifiers=const

Returns caret character offset at the specified pixel offset at the baseline. This function always returns a valid position.

### `resize_object(key: Variant, size: Vector2, inline_align: int = 5, baseline: float = 0.0) -> bool`

Sets new size and alignment of embedded object.

### `set_bidi_override(override: Array) -> void`

Overrides BiDi for the structured text.
				Override ranges should cover full source text without overlaps. BiDi algorithm will be used on each range separately.

### `tab_align(tab_stops: PackedFloat32Array) -> void`

Aligns text to the given tab-stops.

