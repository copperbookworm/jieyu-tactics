# TabBar

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`TabBar` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/TabBar.md`

**摘要**：A control that provides a horizontal bar with tabs.

## 描述

A control that provides a horizontal bar with tabs. Similar to `TabContainer` but is only in charge of drawing tabs, not interacting with children.

## 属性

- **`clip_tabs`** `bool` = `true`
  - 其它属性：getter=get_clip_tabs · setter=set_clip_tabs
- **`close_with_middle_mouse`** `bool` = `true`
  - 其它属性：getter=get_close_with_middle_mouse · setter=set_close_with_middle_mouse
- **`current_tab`** `int` = `-1`
  - 其它属性：getter=get_current_tab · setter=set_current_tab
- **`deselect_enabled`** `bool` = `false`
  - 其它属性：getter=get_deselect_enabled · setter=set_deselect_enabled
- **`drag_to_rearrange_enabled`** `bool` = `false`
  - 其它属性：getter=get_drag_to_rearrange_enabled · setter=set_drag_to_rearrange_enabled
- **`focus_mode`** `int` = `2` · 枚举 `Control.FocusMode`
  - 其它属性：getter=get_focus_mode · overrides=Control · setter=set_focus_mode
- **`max_tab_width`** `int` = `0`
  - 其它属性：getter=get_max_tab_width · setter=set_max_tab_width
- **`scroll_to_selected`** `bool` = `true`
  - 其它属性：getter=get_scroll_to_selected · setter=set_scroll_to_selected
- **`scrolling_enabled`** `bool` = `true`
  - 其它属性：getter=get_scrolling_enabled · setter=set_scrolling_enabled
- **`select_with_rmb`** `bool` = `false`
  - 其它属性：getter=get_select_with_rmb · setter=set_select_with_rmb
- **`switch_on_drag_hover`** `bool` = `true`
  - 其它属性：getter=get_switch_on_drag_hover · setter=set_switch_on_drag_hover
- **`tab_alignment`** `int` = `0` · 枚举 `TabBar.AlignmentMode`
  - 其它属性：getter=get_tab_alignment · setter=set_tab_alignment
- **`tab_close_display_policy`** `int` = `0` · 枚举 `TabBar.CloseButtonDisplayPolicy`
  - 其它属性：getter=get_tab_close_display_policy · setter=set_tab_close_display_policy
- **`tab_count`** `int` = `0`
  - 其它属性：getter=get_tab_count · setter=set_tab_count
- **`tab_{index}/disabled`** `bool` = `false`
  - 其它属性：getter= · setter=
- **`tab_{index}/icon`** `Texture2D`
  - 其它属性：getter= · setter=
- **`tab_{index}/title`** `String` = `""`
  - 其它属性：getter= · setter=
- **`tab_{index}/tooltip`** `String` = `""`
  - 其它属性：getter= · setter=
- **`tabs_rearrange_group`** `int` = `-1`
  - 其它属性：getter=get_tabs_rearrange_group · setter=set_tabs_rearrange_group

## 方法

### `add_tab(title: String = "", icon: Texture2D = null) -> void`

Adds a new tab.

### `clear_tabs() -> void`

Clears all tabs.

### `ensure_tab_visible(idx: int) -> void`

Moves the scroll view to make the tab visible.

### `get_offset_buttons_visible() -> bool`
- 限定：qualifiers=const

Returns `true` if the offset buttons (the ones that appear when there's not enough space for all tabs) are visible.

### `get_previous_tab() -> int`
- 限定：qualifiers=const

Returns the previously active tab index.

### `get_tab_button_icon(tab_idx: int) -> Texture2D`
- 限定：qualifiers=const

Returns the icon for the right button of the tab at index `tab_idx` or `null` if the right button has no icon.

### `get_tab_icon(tab_idx: int) -> Texture2D`
- 限定：qualifiers=const

Returns the icon for the tab at index `tab_idx` or `null` if the tab has no icon.

### `get_tab_icon_max_width(tab_idx: int) -> int`
- 限定：qualifiers=const

Returns the maximum allowed width of the icon for the tab at index `tab_idx`.

### `get_tab_idx_at_point(point: Vector2) -> int`
- 限定：qualifiers=const

Returns the index of the tab at local coordinates `point`. Returns `-1` if the point is outside the control boundaries or if there's no tab at the queried position.

### `get_tab_language(tab_idx: int) -> String`
- 限定：qualifiers=const

Returns tab title language code.

### `get_tab_metadata(tab_idx: int) -> Variant`
- 限定：qualifiers=const

Returns the metadata value set to the tab at index `tab_idx` using `set_tab_metadata`. If no metadata was previously set, returns `null` by default.

### `get_tab_offset() -> int`
- 限定：qualifiers=const

Returns the number of hidden tabs offsetted to the left.

### `get_tab_rect(tab_idx: int) -> Rect2`
- 限定：qualifiers=const

Returns tab `Rect2` with local position and size.

### `get_tab_text_direction(tab_idx: int) -> int`
- 限定：qualifiers=const

Returns tab title text base writing direction.

### `get_tab_title(tab_idx: int) -> String`
- 限定：qualifiers=const

Returns the title of the tab at index `tab_idx`.

### `get_tab_tooltip(tab_idx: int) -> String`
- 限定：qualifiers=const

Returns the tooltip text of the tab at index `tab_idx`.

### `is_tab_disabled(tab_idx: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the tab at index `tab_idx` is disabled.

### `is_tab_hidden(tab_idx: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the tab at index `tab_idx` is hidden.

### `move_tab(from: int, to: int) -> void`

Moves a tab from `from` to `to`.

### `remove_tab(tab_idx: int) -> void`

Removes the tab at index `tab_idx`.

### `select_next_available() -> bool`

Selects the first available tab with greater index than the currently selected. Returns `true` if tab selection changed.

### `select_previous_available() -> bool`

Selects the first available tab with lower index than the currently selected. Returns `true` if tab selection changed.

### `set_tab_button_icon(tab_idx: int, icon: Texture2D) -> void`

Sets an `icon` for the button of the tab at index `tab_idx` (located to the right, before the close button), making it visible and clickable (See `tab_button_pressed`). Giving it a `null` value will hide the button.

### `set_tab_disabled(tab_idx: int, disabled: bool) -> void`

If `disabled` is `true`, disables the tab at index `tab_idx`, making it non-interactable.

### `set_tab_hidden(tab_idx: int, hidden: bool) -> void`

If `hidden` is `true`, hides the tab at index `tab_idx`, making it disappear from the tab area.

### `set_tab_icon(tab_idx: int, icon: Texture2D) -> void`

Sets an `icon` for the tab at index `tab_idx`.

### `set_tab_icon_max_width(tab_idx: int, width: int) -> void`

Sets the maximum allowed width of the icon for the tab at index `tab_idx`. This limit is applied on top of the default size of the icon and on top of `icon_max_width`. The height is adjusted according to the icon's ratio.

### `set_tab_language(tab_idx: int, language: String) -> void`

Sets the language code of the title for the tab at index `tab_idx` to `language`. This is used for line-breaking and text shaping algorithms. If `language` is empty, the current locale is used.

### `set_tab_metadata(tab_idx: int, metadata: Variant) -> void`

Sets the metadata value for the tab at index `tab_idx`, which can be retrieved later using `get_tab_metadata`.

### `set_tab_text_direction(tab_idx: int, direction: int) -> void`

Sets tab title base writing direction.

### `set_tab_title(tab_idx: int, title: String) -> void`

Sets a `title` for the tab at index `tab_idx`.

### `set_tab_tooltip(tab_idx: int, tooltip: String) -> void`

Sets a `tooltip` for tab at index `tab_idx`.
				**Note:** By default, if the `tooltip` is empty and the tab text is truncated (not all characters fit into the tab), the title will be displayed as a tooltip. To hide the tooltip, assign `" "` as the `tooltip` text.

## 信号

### `active_tab_rearranged(idx_to: int)`

Emitted when the active tab is rearranged via mouse drag. See `drag_to_rearrange_enabled`.

### `tab_button_pressed(tab: int)`

Emitted when a tab's right button is pressed. See `set_tab_button_icon`.

### `tab_changed(tab: int)`

Emitted when switching to another tab.

### `tab_clicked(tab: int)`

Emitted when a tab is clicked, even if it is the current tab.

### `tab_close_pressed(tab: int)`

Emitted when a tab's close button is pressed or, if `close_with_middle_mouse` is `true`, when middle-clicking on a tab.
				**Note:** Tabs are not removed automatically; this behavior needs to be coded manually. For example:
				`codeblocks`
				`gdscript`
				$TabBar.tab_close_pressed.connect($TabBar.remove_tab)
				
				`csharp`
				GetNode<TabBar>("TabBar").TabClosePressed += GetNode<TabBar>("TabBar").RemoveTab;

### `tab_hovered(tab: int)`

Emitted when a tab is hovered by the mouse.

### `tab_rmb_clicked(tab: int)`

Emitted when a tab is right-clicked.

### `tab_selected(tab: int)`

Emitted when a tab is selected via click, directional input, or script, even if it is the current tab.

## 枚举

### `AlignmentMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ALIGNMENT_LEFT` |  |
| `1` | `ALIGNMENT_CENTER` |  |
| `2` | `ALIGNMENT_RIGHT` |  |
| `3` | `ALIGNMENT_MAX` |  |

### `CloseButtonDisplayPolicy`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `CLOSE_BUTTON_SHOW_NEVER` |  |
| `1` | `CLOSE_BUTTON_SHOW_ACTIVE_ONLY` |  |
| `2` | `CLOSE_BUTTON_SHOW_ALWAYS` |  |
| `3` | `CLOSE_BUTTON_MAX` |  |

## 主题属性

### `drop_mark_color`
- data_type=color · default=Color(1, 1, 1, 1) · type=Color

### `font_disabled_color`
- data_type=color · default=Color(0.875, 0.875, 0.875, 0.5) · type=Color

### `font_hovered_color`
- data_type=color · default=Color(0.95, 0.95, 0.95, 1) · type=Color

### `font_outline_color`
- data_type=color · default=Color(0, 0, 0, 1) · type=Color

### `font_selected_color`
- data_type=color · default=Color(0.95, 0.95, 0.95, 1) · type=Color

### `font_unselected_color`
- data_type=color · default=Color(0.7, 0.7, 0.7, 1) · type=Color

### `icon_disabled_color`
- data_type=color · default=Color(1, 1, 1, 1) · type=Color

### `icon_hovered_color`
- data_type=color · default=Color(1, 1, 1, 1) · type=Color

### `icon_selected_color`
- data_type=color · default=Color(1, 1, 1, 1) · type=Color

### `icon_unselected_color`
- data_type=color · default=Color(1, 1, 1, 1) · type=Color

### `h_separation`
- data_type=constant · default=4 · type=int

### `hover_switch_wait_msec`
- data_type=constant · default=500 · type=int

### `icon_max_width`
- data_type=constant · default=0 · type=int

### `outline_size`
- data_type=constant · default=0 · type=int

### `tab_separation`
- data_type=constant · default=0 · type=int

### `font`
- data_type=font · type=Font

### `font_size`
- data_type=font_size · type=int

### `close`
- data_type=icon · type=Texture2D

### `decrement`
- data_type=icon · type=Texture2D

### `decrement_highlight`
- data_type=icon · type=Texture2D

### `drop_mark`
- data_type=icon · type=Texture2D

### `increment`
- data_type=icon · type=Texture2D

### `increment_highlight`
- data_type=icon · type=Texture2D

### `button_highlight`
- data_type=style · type=StyleBox

### `button_pressed`
- data_type=style · type=StyleBox

### `tab_disabled`
- data_type=style · type=StyleBox

### `tab_focus`
- data_type=style · type=StyleBox

### `tab_hovered`
- data_type=style · type=StyleBox

### `tab_selected`
- data_type=style · type=StyleBox

### `tab_unselected`
- data_type=style · type=StyleBox

