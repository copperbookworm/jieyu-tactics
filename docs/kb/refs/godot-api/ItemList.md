# ItemList

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ItemList` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/ItemList.md`

**摘要**：A vertical list of selectable items with one or multiple columns.

## 描述

This control provides a vertical list of selectable items that may be in a single or in multiple columns, with each item having options for text and an icon. Tooltips are supported and may be different for every item in the list.
		Selectable items in the list may be selected or deselected and multiple selection may be enabled. Selection with right mouse button may also be enabled to allow use of popup context menus. Items may also be "activated" by double-clicking them or by pressing Enter.
		Item text only supports single-line strings. Newline characters (e.g. `\n`) in the string won't produce a newline. Text wrapping is enabled in `ICON_MODE_TOP` mode, but the column's width is adjusted to fully fit its content by default. You need to set `fixed_column_width` greater than zero to wrap the text.
		All `set_*` methods allow negative item indices, i.e. `-1` to access the last item, `-2` to select the second-to-last item, and so on.
		**Incremental search:** Like `PopupMenu` and `Tree`, `ItemList` supports searching within the list while the control is focused. Press a key that matches the first letter of an item's name to select the first item starting with the given letter. After that point, there are two ways to perform incremental search: 1) Press the same key again before the timeout duration to select the next item starting with the same letter. 2) Press letter keys that match the rest of the word before the timeout duration to match to select the item in question directly. Both of these actions will be reset to the beginning of the list if the timeout duration has passed since the last keystroke was registered. You can adjust the timeout duration by changing `ProjectSettings.gui/timers/incremental_search_max_interval_msec`.

## 属性

- **`allow_reselect`** `bool` = `false`
  - 其它属性：getter=get_allow_reselect · setter=set_allow_reselect
- **`allow_rmb_select`** `bool` = `false`
  - 其它属性：getter=get_allow_rmb_select · setter=set_allow_rmb_select
- **`allow_search`** `bool` = `true`
  - 其它属性：getter=get_allow_search · setter=set_allow_search
- **`auto_height`** `bool` = `false`
  - 其它属性：getter=has_auto_height · setter=set_auto_height
- **`auto_width`** `bool` = `false`
  - 其它属性：getter=has_auto_width · setter=set_auto_width
- **`clip_contents`** `bool` = `true`
  - 其它属性：getter=is_clipping_contents · overrides=Control · setter=set_clip_contents
- **`fixed_column_width`** `int` = `0`
  - 其它属性：getter=get_fixed_column_width · setter=set_fixed_column_width
- **`fixed_icon_size`** `Vector2i` = `Vector2i(0, 0)`
  - 其它属性：getter=get_fixed_icon_size · setter=set_fixed_icon_size
- **`focus_mode`** `int` = `2` · 枚举 `Control.FocusMode`
  - 其它属性：getter=get_focus_mode · overrides=Control · setter=set_focus_mode
- **`icon_mode`** `int` = `1` · 枚举 `ItemList.IconMode`
  - 其它属性：getter=get_icon_mode · setter=set_icon_mode
- **`icon_scale`** `float` = `1.0`
  - 其它属性：getter=get_icon_scale · setter=set_icon_scale
- **`item_count`** `int` = `0`
  - 其它属性：getter=get_item_count · setter=set_item_count
- **`item_{index}/disabled`** `bool` = `false`
  - 其它属性：getter= · setter=
- **`item_{index}/icon`** `Texture2D`
  - 其它属性：getter= · setter=
- **`item_{index}/selectable`** `bool` = `true`
  - 其它属性：getter= · setter=
- **`item_{index}/text`** `String` = `""`
  - 其它属性：getter= · setter=
- **`max_columns`** `int` = `1`
  - 其它属性：getter=get_max_columns · setter=set_max_columns
- **`max_text_lines`** `int` = `1`
  - 其它属性：getter=get_max_text_lines · setter=set_max_text_lines
- **`same_column_width`** `bool` = `false`
  - 其它属性：getter=is_same_column_width · setter=set_same_column_width
- **`scroll_hint_mode`** `int` = `0` · 枚举 `ItemList.ScrollHintMode`
  - 其它属性：getter=get_scroll_hint_mode · setter=set_scroll_hint_mode
- **`select_mode`** `int` = `0` · 枚举 `ItemList.SelectMode`
  - 其它属性：getter=get_select_mode · setter=set_select_mode
- **`text_overrun_behavior`** `int` = `3` · 枚举 `TextServer.OverrunBehavior`
  - 其它属性：getter=get_text_overrun_behavior · setter=set_text_overrun_behavior
- **`tile_scroll_hint`** `bool` = `false`
  - 其它属性：getter=is_scroll_hint_tiled · setter=set_tile_scroll_hint
- **`wraparound_items`** `bool` = `true`
  - 其它属性：getter=has_wraparound_items · setter=set_wraparound_items

## 方法

### `add_icon_item(icon: Texture2D, selectable: bool = true) -> int`

Adds an item to the item list with no text, only an icon. Returns the index of an added item.

### `add_item(text: String, icon: Texture2D = null, selectable: bool = true) -> int`

Adds an item to the item list with specified text. Returns the index of an added item.
				Specify an `icon`, or use `null` as the `icon` for a list item with no icon.
				If `selectable` is `true`, the list item will be selectable.

### `center_on_current(center_verically: bool = true, center_horizontally: bool = true) -> void`

Ensures the currently selected item (the first selected item if multiple selection is enabled) is visible, adjusting the scroll position as necessary to place the item at the center of the list if possible. See also `ensure_current_is_visible`.
				Fails and prints an error if both arguments are `false`.

### `clear() -> void`

Removes all items from the list.

### `deselect(idx: int) -> void`

Ensures the item associated with the specified index is not selected.

### `deselect_all() -> void`

Ensures there are no items selected.

### `ensure_current_is_visible() -> void`

Ensures the currently selected item (the first selected item if multiple selection is enabled) is visible, adjusting the scroll position as necessary. See also `center_on_current`.

### `force_update_list_size() -> void`

Forces an update to the list size based on its items. This happens automatically whenever size of the items, or other relevant settings like `auto_height`, change. The method can be used to trigger the update ahead of next drawing pass.

### `get_h_scroll_bar() -> HScrollBar`

Returns the horizontal scrollbar.
				**Warning:** This is a required internal node, removing and freeing it may cause a crash. If you wish to hide it or any of its children, use their `CanvasItem.visible` property.

### `get_item_at_position(position: Vector2, exact: bool = false) -> int`
- 限定：qualifiers=const

Returns the item index at the given `position`.
				When there is no item at that point, -1 will be returned if `exact` is `true`, and the closest item index will be returned otherwise.
				**Note:** The returned value is unreliable if called right after modifying the `ItemList`, before it redraws in the next frame.

### `get_item_auto_translate_mode(idx: int) -> int`
- 限定：qualifiers=const

Returns item's auto translate mode.

### `get_item_custom_bg_color(idx: int) -> Color`
- 限定：qualifiers=const

Returns the custom background color of the item specified by `idx` index.

### `get_item_custom_fg_color(idx: int) -> Color`
- 限定：qualifiers=const

Returns the custom foreground color of the item specified by `idx` index.

### `get_item_icon(idx: int) -> Texture2D`
- 限定：qualifiers=const

Returns the icon associated with the specified index.

### `get_item_icon_modulate(idx: int) -> Color`
- 限定：qualifiers=const

Returns a `Color` modulating item's icon at the specified index.

### `get_item_icon_region(idx: int) -> Rect2`
- 限定：qualifiers=const

Returns the region of item's icon used. The whole icon will be used if the region has no area.

### `get_item_language(idx: int) -> String`
- 限定：qualifiers=const

Returns item's text language code.

### `get_item_metadata(idx: int) -> Variant`
- 限定：qualifiers=const

Returns the metadata value of the specified index.

### `get_item_rect(idx: int, expand: bool = true) -> Rect2`
- 限定：qualifiers=const

Returns the position and size of the item with the specified index, in the coordinate system of the `ItemList` node. If `expand` is `true` the last column expands to fill the rest of the row.
				**Note:** The returned value is unreliable if called right after modifying the `ItemList`, before it redraws in the next frame.

### `get_item_text(idx: int) -> String`
- 限定：qualifiers=const

Returns the text associated with the specified index.

### `get_item_text_direction(idx: int) -> int`
- 限定：qualifiers=const

Returns item's text base writing direction.

### `get_item_tooltip(idx: int) -> String`
- 限定：qualifiers=const

Returns the tooltip hint associated with the specified index.

### `get_selected_items() -> PackedInt32Array`

Returns an array with the indexes of the selected items.

### `get_v_scroll_bar() -> VScrollBar`

Returns the vertical scrollbar.
				**Warning:** This is a required internal node, removing and freeing it may cause a crash. If you wish to hide it or any of its children, use their `CanvasItem.visible` property.

### `is_anything_selected() -> bool`

Returns `true` if one or more items are selected.

### `is_item_disabled(idx: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the item at the specified index is disabled.

### `is_item_icon_transposed(idx: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the item icon will be drawn transposed, i.e. the X and Y axes are swapped.

### `is_item_selectable(idx: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the item at the specified index is selectable.

### `is_item_tooltip_enabled(idx: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the tooltip is enabled for specified item index.

### `is_selected(idx: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the item at the specified index is currently selected.

### `move_item(from_idx: int, to_idx: int) -> void`

Moves item from index `from_idx` to `to_idx`.

### `remove_item(idx: int) -> void`

Removes the item specified by `idx` index from the list.

### `select(idx: int, single: bool = true) -> void`

Selects the item at the specified index.
				**Note:** This method does not trigger the item selection signal.

### `set_item_auto_translate_mode(idx: int, mode: int) -> void`

Sets the auto translate mode of the item associated with the specified index.
				Items use `Node.AUTO_TRANSLATE_MODE_INHERIT` by default, which uses the same auto translate mode as the `ItemList` itself.

### `set_item_custom_bg_color(idx: int, custom_bg_color: Color) -> void`

Sets the background color of the item specified by `idx` index to the specified `Color`.

### `set_item_custom_fg_color(idx: int, custom_fg_color: Color) -> void`

Sets the foreground color of the item specified by `idx` index to the specified `Color`.

### `set_item_disabled(idx: int, disabled: bool) -> void`

Disables (or enables) the item at the specified index.
				Disabled items cannot be selected and do not trigger activation signals (when double-clicking or pressing Enter).

### `set_item_icon(idx: int, icon: Texture2D) -> void`

Sets (or replaces) the icon's `Texture2D` associated with the specified index.

### `set_item_icon_modulate(idx: int, modulate: Color) -> void`

Sets a modulating `Color` of the item associated with the specified index.

### `set_item_icon_region(idx: int, rect: Rect2) -> void`

Sets the region of item's icon used. The whole icon will be used if the region has no area.

### `set_item_icon_transposed(idx: int, transposed: bool) -> void`

Sets whether the item icon will be drawn transposed.

### `set_item_language(idx: int, language: String) -> void`

Sets the language code of the text for the item at the given index to `language`. This is used for line-breaking and text shaping algorithms. If `language` is empty, the current locale is used.

### `set_item_metadata(idx: int, metadata: Variant) -> void`

Sets a value (of any type) to be stored with the item associated with the specified index.

### `set_item_selectable(idx: int, selectable: bool) -> void`

Allows or disallows selection of the item associated with the specified index.

### `set_item_text(idx: int, text: String) -> void`

Sets text of the item associated with the specified index.

### `set_item_text_direction(idx: int, direction: int) -> void`

Sets item's text base writing direction.

### `set_item_tooltip(idx: int, tooltip: String) -> void`

Sets the tooltip hint for the item associated with the specified index.

### `set_item_tooltip_enabled(idx: int, enable: bool) -> void`

Sets whether the tooltip hint is enabled for specified item index.

### `sort_items_by_text() -> void`

Sorts items in the list by their text.

## 信号

### `empty_clicked(at_position: Vector2, mouse_button_index: int)`

Emitted when any mouse click is issued within the rect of the list but on empty space.
				`at_position` is the click position in this control's local coordinate system.

### `item_activated(index: int)`

Emitted when specified list item is activated via double-clicking or by pressing Enter.

### `item_clicked(index: int, at_position: Vector2, mouse_button_index: int)`

Emitted when specified list item has been clicked with any mouse button.
				`at_position` is the click position in this control's local coordinate system.

### `item_selected(index: int)`

Emitted when specified item has been selected. Only applicable in single selection mode.
				`allow_reselect` must be enabled to reselect an item.

### `multi_selected(index: int, selected: bool)`

Emitted when a multiple selection is altered on a list allowing multiple selection.

## 枚举

### `IconMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ICON_MODE_TOP` |  |
| `1` | `ICON_MODE_LEFT` |  |

### `SelectMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SELECT_SINGLE` |  |
| `1` | `SELECT_MULTI` |  |
| `2` | `SELECT_TOGGLE` |  |

### `ScrollHintMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SCROLL_HINT_MODE_DISABLED` |  |
| `1` | `SCROLL_HINT_MODE_BOTH` |  |
| `2` | `SCROLL_HINT_MODE_TOP` |  |
| `3` | `SCROLL_HINT_MODE_BOTTOM` |  |

## 主题属性

### `font_color`
- data_type=color · default=Color(0.65, 0.65, 0.65, 1) · type=Color

### `font_hovered_color`
- data_type=color · default=Color(0.95, 0.95, 0.95, 1) · type=Color

### `font_hovered_selected_color`
- data_type=color · default=Color(1, 1, 1, 1) · type=Color

### `font_outline_color`
- data_type=color · default=Color(0, 0, 0, 1) · type=Color

### `font_selected_color`
- data_type=color · default=Color(1, 1, 1, 1) · type=Color

### `guide_color`
- data_type=color · default=Color(0.7, 0.7, 0.7, 0.25) · type=Color

### `scroll_hint_color`
- data_type=color · default=Color(0, 0, 0, 1) · type=Color

### `h_separation`
- data_type=constant · default=4 · type=int

### `icon_margin`
- data_type=constant · default=4 · type=int

### `line_separation`
- data_type=constant · default=2 · type=int

### `outline_size`
- data_type=constant · default=0 · type=int

### `v_separation`
- data_type=constant · default=4 · type=int

### `font`
- data_type=font · type=Font

### `font_size`
- data_type=font_size · type=int

### `scroll_hint`
- data_type=icon · type=Texture2D

### `cursor`
- data_type=style · type=StyleBox

### `cursor_unfocused`
- data_type=style · type=StyleBox

### `focus`
- data_type=style · type=StyleBox

### `hovered`
- data_type=style · type=StyleBox

### `hovered_selected`
- data_type=style · type=StyleBox

### `hovered_selected_focus`
- data_type=style · type=StyleBox

### `panel`
- data_type=style · type=StyleBox

### `selected`
- data_type=style · type=StyleBox

### `selected_focus`
- data_type=style · type=StyleBox

