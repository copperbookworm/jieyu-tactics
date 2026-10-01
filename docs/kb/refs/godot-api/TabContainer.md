# TabContainer

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`TabContainer` → `Container` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/TabContainer.md`

**摘要**：A container that creates a tab for each child control, displaying only the active tab's control.

## 描述

Arranges child controls into a tabbed view, creating a tab for each one. The active tab's corresponding control is made visible, while all other child controls are hidden. Ignores non-control children.
		**Note:** The drawing of the clickable tabs is handled by this node; `TabBar` is not needed.

## 属性

- **`all_tabs_in_front`** `bool`
  - 其它属性：deprecated=Due to internal changes this doesn't do anything anymore, as they're always in front. · getter=is_all_tabs_in_front · setter=set_all_tabs_in_front
- **`clip_tabs`** `bool` = `true`
  - 其它属性：getter=get_clip_tabs · setter=set_clip_tabs
- **`current_tab`** `int` = `-1`
  - 其它属性：getter=get_current_tab · setter=set_current_tab
- **`deselect_enabled`** `bool` = `false`
  - 其它属性：getter=get_deselect_enabled · setter=set_deselect_enabled
- **`drag_to_rearrange_enabled`** `bool` = `false`
  - 其它属性：getter=get_drag_to_rearrange_enabled · setter=set_drag_to_rearrange_enabled
- **`switch_on_drag_hover`** `bool` = `true`
  - 其它属性：getter=get_switch_on_drag_hover · setter=set_switch_on_drag_hover
- **`tab_alignment`** `int` = `0` · 枚举 `TabBar.AlignmentMode`
  - 其它属性：getter=get_tab_alignment · setter=set_tab_alignment
- **`tab_focus_mode`** `int` = `2` · 枚举 `Control.FocusMode`
  - 其它属性：getter=get_tab_focus_mode · setter=set_tab_focus_mode
- **`tab_{index}/disabled`** `bool` = `false`
  - 其它属性：getter= · setter=
- **`tab_{index}/hidden`** `bool` = `false`
  - 其它属性：getter= · setter=
- **`tab_{index}/icon`** `Texture2D`
  - 其它属性：getter= · setter=
- **`tab_{index}/title`** `String` = `""`
  - 其它属性：getter= · setter=
- **`tabs_position`** `int` = `0` · 枚举 `TabContainer.TabPosition`
  - 其它属性：getter=get_tabs_position · setter=set_tabs_position
- **`tabs_rearrange_group`** `int` = `-1`
  - 其它属性：getter=get_tabs_rearrange_group · setter=set_tabs_rearrange_group
- **`tabs_visible`** `bool` = `true`
  - 其它属性：getter=are_tabs_visible · setter=set_tabs_visible
- **`use_hidden_tabs_for_min_size`** `bool` = `false`
  - 其它属性：getter=get_use_hidden_tabs_for_min_size · setter=set_use_hidden_tabs_for_min_size

## 方法

### `get_current_tab_control() -> Control`
- 限定：qualifiers=const

Returns the child `Control` node located at the active tab index.

### `get_popup() -> Popup`
- 限定：qualifiers=const

Returns the `Popup` node instance if one has been set already with `set_popup`.
				**Warning:** This is a required internal node, removing and freeing it may cause a crash. If you wish to hide it or any of its children, use their `Window.visible` property.

### `get_previous_tab() -> int`
- 限定：qualifiers=const

Returns the previously active tab index.

### `get_tab_bar() -> TabBar`
- 限定：qualifiers=const

Returns the `TabBar` contained in this container.
				**Warning:** This is a required internal node, removing and freeing it or editing its tabs may cause a crash. If you wish to edit the tabs, use the methods provided in `TabContainer`.

### `get_tab_button_icon(tab_idx: int) -> Texture2D`
- 限定：qualifiers=const

Returns the button icon from the tab at index `tab_idx`.

### `get_tab_control(tab_idx: int) -> Control`
- 限定：qualifiers=const

Returns the `Control` node from the tab at index `tab_idx`.

### `get_tab_count() -> int`
- 限定：qualifiers=const

Returns the number of tabs.

### `get_tab_icon(tab_idx: int) -> Texture2D`
- 限定：qualifiers=const

Returns the `Texture2D` for the tab at index `tab_idx` or `null` if the tab has no `Texture2D`.

### `get_tab_icon_max_width(tab_idx: int) -> int`
- 限定：qualifiers=const

Returns the maximum allowed width of the icon for the tab at index `tab_idx`.

### `get_tab_idx_at_point(point: Vector2) -> int`
- 限定：qualifiers=const

Returns the index of the tab at local coordinates `point`. Returns `-1` if the point is outside the control boundaries or if there's no tab at the queried position.

### `get_tab_idx_from_control(control: Control) -> int`
- 限定：qualifiers=const

Returns the index of the tab tied to the given `control`. The control must be a child of the `TabContainer`.

### `get_tab_metadata(tab_idx: int) -> Variant`
- 限定：qualifiers=const

Returns the metadata value set to the tab at index `tab_idx` using `set_tab_metadata`. If no metadata was previously set, returns `null` by default.

### `get_tab_title(tab_idx: int) -> String`
- 限定：qualifiers=const

Returns the title of the tab at index `tab_idx`. Tab titles default to the name of the indexed child node, but this can be overridden with `set_tab_title`.

### `get_tab_tooltip(tab_idx: int) -> String`
- 限定：qualifiers=const

Returns the tooltip text of the tab at index `tab_idx`.

### `is_tab_disabled(tab_idx: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the tab at index `tab_idx` is disabled.

### `is_tab_hidden(tab_idx: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the tab at index `tab_idx` is hidden.

### `select_next_available() -> bool`

Selects the first available tab with greater index than the currently selected. Returns `true` if tab selection changed.

### `select_previous_available() -> bool`

Selects the first available tab with lower index than the currently selected. Returns `true` if tab selection changed.

### `set_popup(popup: Node) -> void`

If set on a `Popup` node instance, a popup menu icon appears in the top-right corner of the `TabContainer` (setting it to `null` will make it go away). Clicking it will expand the `Popup` node.

### `set_tab_button_icon(tab_idx: int, icon: Texture2D) -> void`

Sets the button icon from the tab at index `tab_idx`.

### `set_tab_disabled(tab_idx: int, disabled: bool) -> void`

If `disabled` is `true`, disables the tab at index `tab_idx`, making it non-interactable.

### `set_tab_hidden(tab_idx: int, hidden: bool) -> void`

If `hidden` is `true`, hides the tab at index `tab_idx`, making it disappear from the tab area.

### `set_tab_icon(tab_idx: int, icon: Texture2D) -> void`

Sets an icon for the tab at index `tab_idx`.

### `set_tab_icon_max_width(tab_idx: int, width: int) -> void`

Sets the maximum allowed width of the icon for the tab at index `tab_idx`. This limit is applied on top of the default size of the icon and on top of `icon_max_width`. The height is adjusted according to the icon's ratio.

### `set_tab_metadata(tab_idx: int, metadata: Variant) -> void`

Sets the metadata value for the tab at index `tab_idx`, which can be retrieved later using `get_tab_metadata`.

### `set_tab_title(tab_idx: int, title: String) -> void`

Sets a custom title for the tab at index `tab_idx` (tab titles default to the name of the indexed child node). Set it back to the child's name to make the tab default to it again.

### `set_tab_tooltip(tab_idx: int, tooltip: String) -> void`

Sets a custom tooltip text for tab at index `tab_idx`.
				**Note:** By default, if the `tooltip` is empty and the tab text is truncated (not all characters fit into the tab), the title will be displayed as a tooltip. To hide the tooltip, assign `" "` as the `tooltip` text.

## 信号

### `active_tab_rearranged(idx_to: int)`

Emitted when the active tab is rearranged via mouse drag. See `drag_to_rearrange_enabled`.

### `pre_popup_pressed()`

Emitted when the `TabContainer`'s `Popup` button is clicked. See `set_popup` for details.

### `tab_button_pressed(tab: int)`

Emitted when the user clicks on the button icon on this tab.

### `tab_changed(tab: int)`

Emitted when switching to another tab.

### `tab_clicked(tab: int)`

Emitted when a tab is clicked, even if it is the current tab.

### `tab_hovered(tab: int)`

Emitted when a tab is hovered by the mouse.

### `tab_selected(tab: int)`

Emitted when a tab is selected via click, directional input, or script, even if it is the current tab.

## 枚举

### `TabPosition`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `POSITION_TOP` |  |
| `1` | `POSITION_BOTTOM` |  |
| `2` | `POSITION_MAX` |  |

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

### `icon_max_width`
- data_type=constant · default=0 · type=int

### `icon_separation`
- data_type=constant · default=4 · type=int

### `outline_size`
- data_type=constant · default=0 · type=int

### `side_margin`
- data_type=constant · default=8 · type=int

### `tab_separation`
- data_type=constant · default=0 · type=int

### `font`
- data_type=font · type=Font

### `font_size`
- data_type=font_size · type=int

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

### `menu`
- data_type=icon · type=Texture2D

### `menu_highlight`
- data_type=icon · type=Texture2D

### `panel`
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

### `tabbar_background`
- data_type=style · type=StyleBox

## 教程链接

- [Using Containers](None)

