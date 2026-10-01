# MenuBar

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`MenuBar` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/MenuBar.md`

**摘要**：A horizontal menu bar that creates a menu for each `PopupMenu` child.

## 描述

A horizontal menu bar that creates a menu for each `PopupMenu` child. New items are created by adding `PopupMenu`s to this node. Item title is determined by `Window.title`, or node name if `Window.title` is empty. Item title can be overridden using `set_menu_title`.

## 属性

- **`flat`** `bool` = `false`
  - 其它属性：getter=is_flat · setter=set_flat
- **`focus_mode`** `int` = `3` · 枚举 `Control.FocusMode`
  - 其它属性：getter=get_focus_mode · overrides=Control · setter=set_focus_mode
- **`language`** `String` = `""`
  - 其它属性：getter=get_language · setter=set_language
- **`prefer_global_menu`** `bool` = `true`
  - 其它属性：getter=is_prefer_global_menu · setter=set_prefer_global_menu
- **`start_index`** `int` = `-1`
  - 其它属性：getter=get_start_index · setter=set_start_index
- **`switch_on_hover`** `bool` = `true`
  - 其它属性：getter=is_switch_on_hover · setter=set_switch_on_hover
- **`text_direction`** `int` = `0` · 枚举 `Control.TextDirection`
  - 其它属性：getter=get_text_direction · setter=set_text_direction

## 方法

### `get_menu_count() -> int`
- 限定：qualifiers=const

Returns number of menu items.

### `get_menu_popup(menu: int) -> PopupMenu`
- 限定：qualifiers=const

Returns `PopupMenu` associated with menu item.

### `get_menu_title(menu: int) -> String`
- 限定：qualifiers=const

Returns menu item title.

### `get_menu_tooltip(menu: int) -> String`
- 限定：qualifiers=const

Returns menu item tooltip.

### `is_menu_disabled(menu: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the menu item is disabled.

### `is_menu_hidden(menu: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the menu item is hidden.

### `is_native_menu() -> bool`
- 限定：qualifiers=const

Returns `true` if the current system's global menu is supported and used by this `MenuBar`.

### `set_disable_shortcuts(disabled: bool) -> void`

If `true`, shortcuts are disabled and cannot be used to trigger the button.

### `set_menu_disabled(menu: int, disabled: bool) -> void`

If `true`, menu item is disabled.

### `set_menu_hidden(menu: int, hidden: bool) -> void`

If `true`, menu item is hidden.

### `set_menu_title(menu: int, title: String) -> void`

Sets menu item title.

### `set_menu_tooltip(menu: int, tooltip: String) -> void`

Sets menu item tooltip.

## 主题属性

### `font_color`
- data_type=color · default=Color(0.875, 0.875, 0.875, 1) · type=Color

### `font_disabled_color`
- data_type=color · default=Color(0.875, 0.875, 0.875, 0.5) · type=Color

### `font_focus_color`
- data_type=color · default=Color(0.95, 0.95, 0.95, 1) · type=Color

### `font_hover_color`
- data_type=color · default=Color(0.95, 0.95, 0.95, 1) · type=Color

### `font_hover_pressed_color`
- data_type=color · default=Color(1, 1, 1, 1) · type=Color

### `font_outline_color`
- data_type=color · default=Color(0, 0, 0, 1) · type=Color

### `font_pressed_color`
- data_type=color · default=Color(1, 1, 1, 1) · type=Color

### `h_separation`
- data_type=constant · default=4 · type=int

### `outline_size`
- data_type=constant · default=0 · type=int

### `font`
- data_type=font · type=Font

### `font_size`
- data_type=font_size · type=int

### `disabled`
- data_type=style · keywords=enabled · type=StyleBox

### `disabled_mirrored`
- data_type=style · type=StyleBox

### `hover`
- data_type=style · type=StyleBox

### `hover_mirrored`
- data_type=style · type=StyleBox

### `hover_pressed`
- data_type=style · type=StyleBox

### `hover_pressed_mirrored`
- data_type=style · type=StyleBox

### `normal`
- data_type=style · type=StyleBox

### `normal_mirrored`
- data_type=style · type=StyleBox

### `pressed`
- data_type=style · type=StyleBox

### `pressed_mirrored`
- data_type=style · type=StyleBox

