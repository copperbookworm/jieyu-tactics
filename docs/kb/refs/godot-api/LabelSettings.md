# LabelSettings

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`LabelSettings` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/LabelSettings.md`

**摘要**：Provides common settings to customize the text in a `Label`.

## 描述

`LabelSettings` is a resource that provides common settings to customize the text in a `Label`. It will take priority over the properties defined in `Control.theme`. The resource can be shared between multiple labels and changed on the fly, so it's convenient and flexible way to setup text style.

## 属性

- **`font`** `Font`
  - 其它属性：getter=get_font · setter=set_font
- **`font_color`** `Color` = `Color(1, 1, 1, 1)`
  - 其它属性：getter=get_font_color · setter=set_font_color
- **`font_size`** `int` = `16`
  - 其它属性：getter=get_font_size · setter=set_font_size
- **`line_spacing`** `float` = `3.0`
  - 其它属性：getter=get_line_spacing · setter=set_line_spacing
- **`outline_color`** `Color` = `Color(1, 1, 1, 1)`
  - 其它属性：getter=get_outline_color · setter=set_outline_color
- **`outline_size`** `int` = `0`
  - 其它属性：getter=get_outline_size · setter=set_outline_size
- **`paragraph_spacing`** `float` = `0.0`
  - 其它属性：getter=get_paragraph_spacing · setter=set_paragraph_spacing
- **`shadow_color`** `Color` = `Color(0, 0, 0, 0)`
  - 其它属性：getter=get_shadow_color · setter=set_shadow_color
- **`shadow_offset`** `Vector2` = `Vector2(1, 1)`
  - 其它属性：getter=get_shadow_offset · setter=set_shadow_offset
- **`shadow_size`** `int` = `1`
  - 其它属性：getter=get_shadow_size · setter=set_shadow_size
- **`stacked_outline_count`** `int` = `0`
  - 其它属性：getter=get_stacked_outline_count · setter=set_stacked_outline_count
- **`stacked_outline_{index}/color`** `Color` = `Color(0, 0, 0, 1)`
  - 其它属性：getter= · setter=
- **`stacked_outline_{index}/size`** `int` = `0`
  - 其它属性：getter= · setter=
- **`stacked_shadow_count`** `int` = `0`
  - 其它属性：getter=get_stacked_shadow_count · setter=set_stacked_shadow_count
- **`stacked_shadow_{index}/color`** `Color` = `Color(0, 0, 0, 1)`
  - 其它属性：getter= · setter=
- **`stacked_shadow_{index}/offset`** `Vector2` = `Vector2(1, 1)`
  - 其它属性：getter= · setter=
- **`stacked_shadow_{index}/outline_size`** `int` = `0`
  - 其它属性：getter= · setter=

## 方法

### `add_stacked_outline(index: int = -1) -> void`

Adds a new stacked outline to the label at the given `index`. If `index` is `-1`, the new stacked outline will be added at the end of the list.

### `add_stacked_shadow(index: int = -1) -> void`

Adds a new stacked shadow to the label at the given `index`. If `index` is `-1`, the new stacked shadow will be added at the end of the list.

### `get_stacked_outline_color(index: int) -> Color`
- 限定：qualifiers=const

Returns the color of the stacked outline at `index`.

### `get_stacked_outline_size(index: int) -> int`
- 限定：qualifiers=const

Returns the size of the stacked outline at `index`.

### `get_stacked_shadow_color(index: int) -> Color`
- 限定：qualifiers=const

Returns the color of the stacked shadow at `index`.

### `get_stacked_shadow_offset(index: int) -> Vector2`
- 限定：qualifiers=const

Returns the offset of the stacked shadow at `index`.

### `get_stacked_shadow_outline_size(index: int) -> int`
- 限定：qualifiers=const

Returns the outline size of the stacked shadow at `index`.

### `move_stacked_outline(from_index: int, to_position: int) -> void`

Moves the stacked outline at index `from_index` to the given position `to_position` in the array.

### `move_stacked_shadow(from_index: int, to_position: int) -> void`

Moves the stacked shadow at index `from_index` to the given position `to_position` in the array.

### `remove_stacked_outline(index: int) -> void`

Removes the stacked outline at index `index`.

### `remove_stacked_shadow(index: int) -> void`

Removes the stacked shadow at index `index`.

### `set_stacked_outline_color(index: int, color: Color) -> void`

Sets the color of the stacked outline identified by the given `index` to `color`.

### `set_stacked_outline_size(index: int, size: int) -> void`

Sets the size of the stacked outline identified by the given `index` to `size`.

### `set_stacked_shadow_color(index: int, color: Color) -> void`

Sets the color of the stacked shadow identified by the given `index` to `color`.

### `set_stacked_shadow_offset(index: int, offset: Vector2) -> void`

Sets the offset of the stacked shadow identified by the given `index` to `offset`.

### `set_stacked_shadow_outline_size(index: int, size: int) -> void`

Sets the outline size of the stacked shadow identified by the given `index` to `size`.

