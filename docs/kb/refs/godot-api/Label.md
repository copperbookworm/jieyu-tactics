# Label

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Label` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core · keywords=text
> 自动生成，勿手改。文件：`refs/godot-api/Label.md`

**摘要**：A control for displaying plain text.

## 描述

A control for displaying plain text. It gives you control over the horizontal and vertical alignment and can wrap the text inside the node's bounding rectangle. It doesn't support bold, italics, or other rich text formatting. For that, use `RichTextLabel` instead.
		**Note:** A single Label node is not designed to display huge amounts of text. To display large amounts of text in a single node, consider using `RichTextLabel` instead as it supports features like an integrated scroll bar and threading. `RichTextLabel` generally performs better when displaying large amounts of text (several pages or more).

## 属性

- **`autowrap_mode`** `int` = `0` · 枚举 `TextServer.AutowrapMode`
  - 其它属性：getter=get_autowrap_mode · setter=set_autowrap_mode
- **`autowrap_trim_flags`** `int` = `192` · 枚举 `TextServer.LineBreakFlag` · 位标志
  - 其它属性：getter=get_autowrap_trim_flags · is_bitfield=true · setter=set_autowrap_trim_flags
- **`clip_text`** `bool` = `false`
  - 其它属性：getter=is_clipping_text · setter=set_clip_text
- **`ellipsis_char`** `String` = `"…"`
  - 其它属性：getter=get_ellipsis_char · setter=set_ellipsis_char
- **`horizontal_alignment`** `int` = `0` · 枚举 `HorizontalAlignment`
  - 其它属性：getter=get_horizontal_alignment · setter=set_horizontal_alignment
- **`justification_flags`** `int` = `163` · 枚举 `TextServer.JustificationFlag` · 位标志
  - 其它属性：getter=get_justification_flags · is_bitfield=true · setter=set_justification_flags
- **`label_settings`** `LabelSettings`
  - 其它属性：getter=get_label_settings · setter=set_label_settings
- **`language`** `String` = `""`
  - 其它属性：getter=get_language · setter=set_language
- **`lines_skipped`** `int` = `0`
  - 其它属性：getter=get_lines_skipped · setter=set_lines_skipped
- **`max_lines_visible`** `int` = `-1`
  - 其它属性：getter=get_max_lines_visible · setter=set_max_lines_visible
- **`mouse_filter`** `int` = `2` · 枚举 `Control.MouseFilter`
  - 其它属性：getter=get_mouse_filter · overrides=Control · setter=set_mouse_filter
- **`paragraph_separator`** `String` = `"\\n"`
  - 其它属性：getter=get_paragraph_separator · setter=set_paragraph_separator
- **`size_flags_vertical`** `int` = `4` · 枚举 `Control.SizeFlags` · 位标志
  - 其它属性：getter=get_v_size_flags · is_bitfield=true · overrides=Control · setter=set_v_size_flags
- **`structured_text_bidi_override`** `int` = `0` · 枚举 `TextServer.StructuredTextParser`
  - 其它属性：getter=get_structured_text_bidi_override · setter=set_structured_text_bidi_override
- **`structured_text_bidi_override_options`** `Array` = `[]`
  - 其它属性：getter=get_structured_text_bidi_override_options · setter=set_structured_text_bidi_override_options
- **`tab_stops`** `PackedFloat32Array` = `PackedFloat32Array()`
  - 其它属性：getter=get_tab_stops · setter=set_tab_stops
- **`text`** `String` = `""`
  - 其它属性：getter=get_text · setter=set_text
- **`text_direction`** `int` = `0` · 枚举 `Control.TextDirection`
  - 其它属性：getter=get_text_direction · setter=set_text_direction
- **`text_overrun_behavior`** `int` = `0` · 枚举 `TextServer.OverrunBehavior`
  - 其它属性：getter=get_text_overrun_behavior · setter=set_text_overrun_behavior
- **`uppercase`** `bool` = `false`
  - 其它属性：getter=is_uppercase · setter=set_uppercase
- **`vertical_alignment`** `int` = `0` · 枚举 `VerticalAlignment`
  - 其它属性：getter=get_vertical_alignment · setter=set_vertical_alignment
- **`visible_characters`** `int` = `-1`
  - 其它属性：getter=get_visible_characters · setter=set_visible_characters
- **`visible_characters_behavior`** `int` = `0` · 枚举 `TextServer.VisibleCharactersBehavior`
  - 其它属性：getter=get_visible_characters_behavior · setter=set_visible_characters_behavior
- **`visible_ratio`** `float` = `1.0`
  - 其它属性：getter=get_visible_ratio · setter=set_visible_ratio

## 方法

### `get_character_bounds(pos: int) -> Rect2`
- 限定：qualifiers=const

Returns the bounding rectangle of the character at position `pos` in the label's local coordinate system. If the character is a non-visual character or `pos` is outside the valid range, an empty `Rect2` is returned. If the character is a part of a composite grapheme, the bounding rectangle of the whole grapheme is returned.

### `get_line_count() -> int`
- 限定：qualifiers=const

Returns the number of lines of text the Label has.

### `get_line_height(line: int = -1) -> int`
- 限定：qualifiers=const

Returns the height of the line `line`.
				If `line` is set to `-1`, returns the biggest line height.
				If there are no lines, returns font size in pixels.

### `get_total_character_count() -> int`
- 限定：qualifiers=const

Returns the total number of printable characters in the text (excluding spaces and newlines).

### `get_visible_line_count() -> int`
- 限定：qualifiers=const

Returns the number of lines shown. Useful if the `Label`'s height cannot currently display all lines.

## 主题属性

### `font_color`
- data_type=color · default=Color(1, 1, 1, 1) · type=Color

### `font_outline_color`
- data_type=color · default=Color(0, 0, 0, 1) · type=Color

### `font_shadow_color`
- data_type=color · default=Color(0, 0, 0, 0) · type=Color

### `line_spacing`
- data_type=constant · default=3 · type=int

### `outline_size`
- data_type=constant · default=0 · type=int

### `paragraph_spacing`
- data_type=constant · default=0 · type=int

### `shadow_offset_x`
- data_type=constant · default=1 · type=int

### `shadow_offset_y`
- data_type=constant · default=1 · type=int

### `shadow_outline_size`
- data_type=constant · default=1 · type=int

### `font`
- data_type=font · type=Font

### `font_size`
- data_type=font_size · type=int

### `focus`
- data_type=style · type=StyleBox

### `normal`
- data_type=style · type=StyleBox

## 教程链接

- [2D Dodge The Creeps Demo](None)

