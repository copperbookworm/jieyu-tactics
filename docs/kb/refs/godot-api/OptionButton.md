# OptionButton

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OptionButton` → `Button` → `BaseButton` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core · keywords=select, dropdown
> 自动生成，勿手改。文件：`refs/godot-api/OptionButton.md`

**摘要**：A button that brings up a dropdown with selectable options when pressed.

## 描述

`OptionButton` is a type of button that brings up a dropdown with selectable items when pressed. The item selected becomes the "current" item and is displayed as the button text.
		See also `BaseButton` which contains common properties and methods associated with this node.
		**Note:** The IDs used for items are limited to signed 32-bit integers, not the full 64 bits of `int`. These have a range of `-2^31` to `2^31 - 1`, that is, `-2147483648` to `2147483647`.
		**Note:** The `Button.text` and `Button.icon` properties are set automatically based on the selected item. They shouldn't be changed manually.

## 属性

- **`action_mode`** `int` = `0` · 枚举 `BaseButton.ActionMode`
  - 其它属性：getter=get_action_mode · overrides=BaseButton · setter=set_action_mode
- **`alignment`** `int` = `0` · 枚举 `HorizontalAlignment`
  - 其它属性：getter=get_text_alignment · overrides=Button · setter=set_text_alignment
- **`allow_reselect`** `bool` = `false`
  - 其它属性：getter=get_allow_reselect · setter=set_allow_reselect
- **`fit_to_longest_item`** `bool` = `true`
  - 其它属性：getter=is_fit_to_longest_item · setter=set_fit_to_longest_item
- **`item_count`** `int` = `0`
  - 其它属性：getter=get_item_count · setter=set_item_count
- **`popup/item_{index}/disabled`** `bool` = `false`
  - 其它属性：getter= · setter=
- **`popup/item_{index}/icon`** `Texture2D`
  - 其它属性：getter= · setter=
- **`popup/item_{index}/id`** `int` = `0`
  - 其它属性：getter= · setter=
- **`popup/item_{index}/separator`** `bool` = `false`
  - 其它属性：getter= · setter=
- **`popup/item_{index}/text`** `String` = `""`
  - 其它属性：getter= · setter=
- **`search_bar_enabled`** `bool` = `false`
  - 其它属性：getter=is_search_bar_enabled · setter=set_search_bar_enabled
- **`search_bar_fuzzy_search_enabled`** `bool` = `true`
  - 其它属性：getter=is_search_bar_fuzzy_search_enabled · setter=set_search_bar_fuzzy_search_enabled
- **`search_bar_fuzzy_search_max_misses`** `int` = `2`
  - 其它属性：getter=get_search_bar_fuzzy_search_max_misses · setter=set_search_bar_fuzzy_search_max_misses
- **`search_bar_min_item_count`** `int` = `0`
  - 其它属性：getter=get_search_bar_min_item_count · setter=set_search_bar_min_item_count
- **`selected`** `int` = `-1`
  - 其它属性：getter=get_selected · setter=_select_int
- **`toggle_mode`** `bool` = `true`
  - 其它属性：getter=is_toggle_mode · overrides=BaseButton · setter=set_toggle_mode

## 方法

### `add_icon_item(texture: Texture2D, label: String, id: int = -1) -> void`

Adds an item, with a `texture` icon, text `label` and (optionally) `id`. If no `id` is passed, the item index will be used as the item's ID. New items are appended at the end.
				**Note:** The item will be selected if there are no other items.

### `add_item(label: String, id: int = -1) -> void`

Adds an item, with text `label` and (optionally) `id`. If no `id` is passed, the item index will be used as the item's ID. New items are appended at the end.
				**Note:** The item will be selected if there are no other items.

### `add_separator(text: String = "") -> void`

Adds a separator to the list of items. Separators help to group items, and can optionally be given a `text` header. A separator also gets an index assigned, and is appended at the end of the item list.

### `clear() -> void`

Clears all the items in the `OptionButton`.

### `get_item_auto_translate_mode(idx: int) -> int`
- 限定：qualifiers=const

Returns the auto translate mode of the item at index `idx`.

### `get_item_icon(idx: int) -> Texture2D`
- 限定：qualifiers=const

Returns the icon of the item at index `idx`.

### `get_item_id(idx: int) -> int`
- 限定：qualifiers=const

Returns the ID of the item at index `idx`.

### `get_item_index(id: int) -> int`
- 限定：qualifiers=const

Returns the index of the item with the given `id`.

### `get_item_metadata(idx: int) -> Variant`
- 限定：qualifiers=const

Retrieves the metadata of an item. Metadata may be any type and can be used to store extra information about an item, such as an external string ID.

### `get_item_text(idx: int) -> String`
- 限定：qualifiers=const

Returns the text of the item at index `idx`.

### `get_item_tooltip(idx: int) -> String`
- 限定：qualifiers=const

Returns the tooltip of the item at index `idx`.

### `get_popup() -> PopupMenu`
- 限定：qualifiers=const

Returns the `PopupMenu` contained in this button.
				**Warning:** This is a required internal node, removing and freeing it may cause a crash. If you wish to hide it or any of its children, use their `Window.visible` property.

### `get_selectable_item(from_last: bool = false) -> int`
- 限定：qualifiers=const

Returns the index of the first item which is not disabled, or marked as a separator. If `from_last` is `true`, the items will be searched in reverse order.
				Returns `-1` if no item is found.

### `get_selected_id() -> int`
- 限定：qualifiers=const

Returns the ID of the selected item, or `-1` if no item is selected.

### `get_selected_metadata() -> Variant`
- 限定：qualifiers=const

Gets the metadata of the selected item. Metadata for items can be set using `set_item_metadata`.

### `has_selectable_items() -> bool`
- 限定：qualifiers=const

Returns `true` if this button contains at least one item which is not disabled, or marked as a separator.

### `is_item_disabled(idx: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the item at index `idx` is disabled.

### `is_item_separator(idx: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the item at index `idx` is marked as a separator.

### `remove_item(idx: int) -> void`

Removes the item at index `idx`.

### `select(idx: int) -> void`

Selects an item by index and makes it the current item. This will work even if the item is disabled.
				Passing `-1` as the index deselects any currently selected item.

### `set_disable_shortcuts(disabled: bool) -> void`

If `true`, shortcuts are disabled and cannot be used to trigger the button.

### `set_item_auto_translate_mode(idx: int, mode: int) -> void`

Sets the auto translate mode of the item at index `idx`.
				Items use `Node.AUTO_TRANSLATE_MODE_INHERIT` by default, which uses the same auto translate mode as the `OptionButton` itself.

### `set_item_disabled(idx: int, disabled: bool) -> void`

Sets whether the item at index `idx` is disabled.
				Disabled items are drawn differently in the dropdown and are not selectable by the user. If the current selected item is set as disabled, it will remain selected.

### `set_item_icon(idx: int, texture: Texture2D) -> void`

Sets the icon of the item at index `idx`.

### `set_item_id(idx: int, id: int) -> void`

Sets the ID of the item at index `idx`.

### `set_item_metadata(idx: int, metadata: Variant) -> void`

Sets the metadata of an item. Metadata may be of any type and can be used to store extra information about an item, such as an external string ID.

### `set_item_text(idx: int, text: String) -> void`

Sets the text of the item at index `idx`.

### `set_item_tooltip(idx: int, tooltip: String) -> void`

Sets the tooltip of the item at index `idx`.

### `show_popup() -> void`

Adjusts popup position and sizing for the `OptionButton`, then shows the `PopupMenu`. Prefer this over using `get_popup().popup()`.

## 信号

### `item_focused(index: int)`

Emitted when the user navigates to an item using the `ProjectSettings.input/ui_up` or `ProjectSettings.input/ui_down` input actions. The index of the item focused is passed as argument.

### `item_selected(index: int)`

Emitted when the current item has been changed by the user. The index of the item selected is passed as argument.
				`allow_reselect` must be enabled to reselect an item.

## 主题属性

### `arrow_margin`
- data_type=constant · default=4 · type=int

### `modulate_arrow`
- data_type=constant · default=0 · type=int

### `arrow`
- data_type=icon · type=Texture2D

