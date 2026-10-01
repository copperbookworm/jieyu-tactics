# CodeHighlighter

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`CodeHighlighter` → `SyntaxHighlighter` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/CodeHighlighter.md`

**摘要**：A syntax highlighter intended for code.

## 描述

By adjusting various properties of this resource, you can change the colors of strings, comments, numbers, and other text patterns inside a `TextEdit` control.

## 属性

- **`color_regions`** `Dictionary` = `{}`
  - 其它属性：getter=get_color_regions · setter=set_color_regions
- **`function_color`** `Color` = `Color(0, 0, 0, 1)`
  - 其它属性：getter=get_function_color · setter=set_function_color
- **`keyword_colors`** `Dictionary` = `{}`
  - 其它属性：getter=get_keyword_colors · setter=set_keyword_colors
- **`member_keyword_colors`** `Dictionary` = `{}`
  - 其它属性：getter=get_member_keyword_colors · setter=set_member_keyword_colors
- **`member_variable_color`** `Color` = `Color(0, 0, 0, 1)`
  - 其它属性：getter=get_member_variable_color · setter=set_member_variable_color
- **`number_color`** `Color` = `Color(0, 0, 0, 1)`
  - 其它属性：getter=get_number_color · setter=set_number_color
- **`symbol_color`** `Color` = `Color(0, 0, 0, 1)`
  - 其它属性：getter=get_symbol_color · setter=set_symbol_color

## 方法

### `add_color_region(start_key: String, end_key: String, color: Color, line_only: bool = false) -> void`

Adds a color region (such as for comments or strings) from `start_key` to `end_key`. Both keys should be symbols, and `start_key` must not be shared with other delimiters.
				If `line_only` is `true` or `end_key` is an empty `String`, the region does not carry over to the next line.

### `add_keyword_color(keyword: String, color: Color) -> void`

Sets the color for a keyword.
				The keyword cannot contain any symbols except '_'.

### `add_member_keyword_color(member_keyword: String, color: Color) -> void`

Sets the color for a member keyword.
				The member keyword cannot contain any symbols except '_'.
				It will not be highlighted if preceded by a '.'.

### `clear_color_regions() -> void`

Removes all color regions.

### `clear_keyword_colors() -> void`

Removes all keywords.

### `clear_member_keyword_colors() -> void`

Removes all member keywords.

### `get_keyword_color(keyword: String) -> Color`
- 限定：qualifiers=const

Returns the color for a keyword.

### `get_member_keyword_color(member_keyword: String) -> Color`
- 限定：qualifiers=const

Returns the color for a member keyword.

### `has_color_region(start_key: String) -> bool`
- 限定：qualifiers=const

Returns `true` if the start key exists, else `false`.

### `has_keyword_color(keyword: String) -> bool`
- 限定：qualifiers=const

Returns `true` if the keyword exists, else `false`.

### `has_member_keyword_color(member_keyword: String) -> bool`
- 限定：qualifiers=const

Returns `true` if the member keyword exists, else `false`.

### `remove_color_region(start_key: String) -> void`

Removes the color region that uses that start key.

### `remove_keyword_color(keyword: String) -> void`

Removes the keyword.

### `remove_member_keyword_color(member_keyword: String) -> void`

Removes the member keyword.

