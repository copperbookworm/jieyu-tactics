# AccessibilityServer

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AccessibilityServer` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AccessibilityServer.md`

**摘要**：A server interface for screen reader support.

## 方法

### `create_element(window_id: int, role: int) -> RID`

Creates a new, empty accessibility element resource.
				**Note:** An accessibility element is created and freed automatically for each `Node`. In general, this function should not be called manually.

### `create_sub_element(parent_rid: RID, role: int, insert_pos: int = -1) -> RID`

Creates a new, empty accessibility sub-element resource. Sub-elements can be used to provide accessibility information for objects which are not `Node`s, such as list items, table cells, or menu items. Sub-elements are freed automatically when the parent element is freed, or can be freed early using the `free_element` method.

### `create_sub_text_edit_elements(parent_rid: RID, shaped_text: RID, min_height: float, insert_pos: int = -1, is_last_line: bool = false) -> RID`

Creates a new, empty accessibility sub-element from the shaped text buffer. Sub-elements are freed automatically when the parent element is freed, or can be freed early using the `free_element` method.
				If `is_last_line` is `true`, no trailing newline is appended to the text content. Set to `true` for the last line in multi-line text fields and for single-line text fields.

### `element_get_meta(id: RID) -> Variant`
- 限定：qualifiers=const

Returns the metadata of the accessibility element `id`.

### `element_set_meta(id: RID, meta: Variant) -> void`

Sets the metadata of the accessibility element `id` to `meta`.

### `free_element(id: RID) -> void`

Frees the accessibility element `id` created by `create_element`, `create_sub_element`, or `create_sub_text_edit_elements`.

### `get_window_root(window_id: int) -> RID`
- 限定：qualifiers=const

Returns the main accessibility element of the OS native window.

### `has_element(id: RID) -> bool`
- 限定：qualifiers=const

Returns `true` if `id` is a valid accessibility element.

### `is_supported() -> bool`
- 限定：qualifiers=const

Returns `true` if screen reader is support by this implementation.

### `set_window_focused(window_id: int, focused: bool) -> void`

Sets the window focused state for assistive apps.
				**Note:** This method is implemented on Linux, macOS, and Windows.
				**Note:** Advanced users only! `Window` objects call this method automatically.

### `set_window_rect(window_id: int, rect_out: Rect2, rect_in: Rect2) -> void`

Sets window outer (with decorations) and inner (without decorations) bounds for assistive apps.
				**Note:** This method is implemented on Linux, macOS, and Windows.
				**Note:** Advanced users only! `Window` objects call this method automatically.

### `update_add_action(id: RID, action: int, callable: Callable) -> void`

Adds a callback for the accessibility action (action which can be performed by using a special screen reader command or buttons on the Braille display), and marks this action as supported. The action callback receives one `Variant` argument, which value depends on action type.

### `update_add_child(id: RID, child_id: RID) -> void`

Adds a child accessibility element.
				**Note:** `Node` children and sub-elements are added to the child list automatically.

### `update_add_custom_action(id: RID, action_id: int, action_description: String) -> void`

Adds support for a custom accessibility action. `action_id` is passed as an argument to the callback of `ACTION_CUSTOM` action.

### `update_add_related_controls(id: RID, related_id: RID) -> void`

Adds an element that is controlled by this element.

### `update_add_related_described_by(id: RID, related_id: RID) -> void`

Adds an element that describes this element.

### `update_add_related_details(id: RID, related_id: RID) -> void`

Adds an element that details this element.

### `update_add_related_flow_to(id: RID, related_id: RID) -> void`

Adds an element that this element flow into.

### `update_add_related_labeled_by(id: RID, related_id: RID) -> void`

Adds an element that labels this element.

### `update_add_related_radio_group(id: RID, related_id: RID) -> void`

Adds an element that is part of the same radio group.
				**Note:** This method should be called on each element of the group, using all other elements as `related_id`.

### `update_set_active_descendant(id: RID, other_id: RID) -> void`

Adds an element that is an active descendant of this element.

### `update_set_background_color(id: RID, color: Color) -> void`

Sets element background color.

### `update_set_bounds(id: RID, rect: Rect2) -> void`

Sets element bounding box, relative to the node position.

### `update_set_braille_label(id: RID, name: String) -> void`

Sets element accessibility label for Braille display.

### `update_set_braille_role_description(id: RID, description: String) -> void`

Sets element accessibility role description for Braille display.

### `update_set_checked(id: RID, checekd: bool) -> void`

Sets element checked state.

### `update_set_classname(id: RID, classname: String) -> void`

Sets element class name.

### `update_set_color_value(id: RID, color: Color) -> void`

Sets element color value.

### `update_set_description(id: RID, description: String) -> void`

Sets element accessibility description.

### `update_set_error_message(id: RID, other_id: RID) -> void`

Sets an element which contains an error message for this element.

### `update_set_extra_info(id: RID, name: String) -> void`

Sets element accessibility extra information added to the element name.

### `update_set_flag(id: RID, flag: int, value: bool) -> void`

Sets element flag.

### `update_set_focus(id: RID) -> void`

Sets currently focused element.

### `update_set_foreground_color(id: RID, color: Color) -> void`

Sets element foreground color.

### `update_set_in_page_link_target(id: RID, other_id: RID) -> void`

Sets target element for the link.

### `update_set_language(id: RID, language: String) -> void`

Sets element text language.

### `update_set_list_item_count(id: RID, size: int) -> void`

Sets number of items in the list.

### `update_set_list_item_expanded(id: RID, expanded: bool) -> void`

Sets list/tree item expanded status.

### `update_set_list_item_index(id: RID, index: int) -> void`

Sets the position of the element in the list.

### `update_set_list_item_level(id: RID, level: int) -> void`

Sets the hierarchical level of the element in the list.

### `update_set_list_item_selected(id: RID, selected: bool) -> void`

Sets list/tree item selected status.

### `update_set_list_orientation(id: RID, vertical: bool) -> void`

Sets the orientation of the list elements.

### `update_set_live(id: RID, live: int) -> void`

Sets the priority of the live region updates.

### `update_set_member_of(id: RID, group_id: RID) -> void`

Sets the element to be a member of the group.

### `update_set_name(id: RID, name: String) -> void`

Sets element accessibility name.

### `update_set_next_on_line(id: RID, other_id: RID) -> void`

Sets next element on the line.

### `update_set_num_jump(id: RID, jump: float) -> void`

Sets numeric value jump.

### `update_set_num_range(id: RID, min: float, max: float) -> void`

Sets numeric value range.

### `update_set_num_step(id: RID, step: float) -> void`

Sets numeric value step.

### `update_set_num_value(id: RID, position: float) -> void`

Sets numeric value.

### `update_set_placeholder(id: RID, placeholder: String) -> void`

Sets placeholder text.

### `update_set_popup_type(id: RID, popup: int) -> void`

Sets popup type for popup buttons.

### `update_set_previous_on_line(id: RID, other_id: RID) -> void`

Sets previous element on the line.

### `update_set_role(id: RID, role: int) -> void`

Sets element accessibility role.

### `update_set_role_description(id: RID, description: String) -> void`

Sets element accessibility role description text.

### `update_set_scroll_x(id: RID, position: float) -> void`

Sets scroll bar x position.

### `update_set_scroll_x_range(id: RID, min: float, max: float) -> void`

Sets scroll bar x range.

### `update_set_scroll_y(id: RID, position: float) -> void`

Sets scroll bar y position.

### `update_set_scroll_y_range(id: RID, min: float, max: float) -> void`

Sets scroll bar y range.

### `update_set_shortcut(id: RID, shortcut: String) -> void`

Sets the list of keyboard shortcuts used by element.

### `update_set_state_description(id: RID, description: String) -> void`

Sets human-readable description of the current checked state.

### `update_set_table_cell_position(id: RID, row_index: int, column_index: int) -> void`

Sets cell position in the table.

### `update_set_table_cell_span(id: RID, row_span: int, column_span: int) -> void`

Sets cell row/column span.

### `update_set_table_column_count(id: RID, count: int) -> void`

Sets number of columns in the table.

### `update_set_table_column_index(id: RID, index: int) -> void`

Sets position of the column.

### `update_set_table_row_count(id: RID, count: int) -> void`

Sets number of rows in the table.

### `update_set_table_row_index(id: RID, index: int) -> void`

Sets position of the row in the table.

### `update_set_text_align(id: RID, align: int) -> void`

Sets element text alignment.

### `update_set_text_decorations(id: RID, underline: bool, strikethrough: bool, overline: bool, color: Color = Color(0, 0, 0, 1)) -> void`

Sets text underline/overline/strikethrough.

### `update_set_text_orientation(id: RID, vertical: bool) -> void`

Sets text orientation.

### `update_set_text_selection(id: RID, text_start_id: RID, start_char: int, text_end_id: RID, end_char: int) -> void`

Sets text selection to the text field. `text_start_id` and `text_end_id` should be elements created by `create_sub_text_edit_elements`. Character offsets are relative to the corresponding element.

### `update_set_tooltip(id: RID, tooltip: String) -> void`

Sets tooltip text.

### `update_set_transform(id: RID, transform: Transform2D) -> void`

Sets element 2D transform.

### `update_set_url(id: RID, url: String) -> void`

Sets link URL.

### `update_set_value(id: RID, value: String) -> void`

Sets element text value.

## 枚举

### `AccessibilityRole`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ROLE_UNKNOWN` |  |
| `1` | `ROLE_DEFAULT_BUTTON` |  |
| `2` | `ROLE_AUDIO` |  |
| `3` | `ROLE_VIDEO` |  |
| `4` | `ROLE_STATIC_TEXT` |  |
| `5` | `ROLE_CONTAINER` |  |
| `6` | `ROLE_PANEL` |  |
| `7` | `ROLE_BUTTON` |  |
| `8` | `ROLE_LINK` |  |
| `9` | `ROLE_CHECK_BOX` |  |
| `10` | `ROLE_RADIO_BUTTON` |  |
| `11` | `ROLE_CHECK_BUTTON` |  |
| `12` | `ROLE_SCROLL_BAR` |  |
| `13` | `ROLE_SCROLL_VIEW` |  |
| `14` | `ROLE_SPLITTER` |  |
| `15` | `ROLE_SLIDER` |  |
| `16` | `ROLE_SPIN_BUTTON` |  |
| `17` | `ROLE_PROGRESS_INDICATOR` |  |
| `18` | `ROLE_TEXT_FIELD` |  |
| `19` | `ROLE_MULTILINE_TEXT_FIELD` |  |
| `20` | `ROLE_COLOR_PICKER` |  |
| `21` | `ROLE_TABLE` |  |
| `22` | `ROLE_CELL` |  |
| `23` | `ROLE_ROW` |  |
| `24` | `ROLE_ROW_GROUP` |  |
| `25` | `ROLE_ROW_HEADER` |  |
| `26` | `ROLE_COLUMN_HEADER` |  |
| `27` | `ROLE_TREE` |  |
| `28` | `ROLE_TREE_ITEM` |  |
| `29` | `ROLE_LIST` |  |
| `30` | `ROLE_LIST_ITEM` |  |
| `31` | `ROLE_LIST_BOX` |  |
| `32` | `ROLE_LIST_BOX_OPTION` |  |
| `33` | `ROLE_TAB_BAR` |  |
| `34` | `ROLE_TAB` |  |
| `35` | `ROLE_TAB_PANEL` |  |
| `36` | `ROLE_MENU_BAR` |  |
| `37` | `ROLE_MENU` |  |
| `38` | `ROLE_MENU_ITEM` |  |
| `39` | `ROLE_MENU_ITEM_CHECK_BOX` |  |
| `40` | `ROLE_MENU_ITEM_RADIO` |  |
| `41` | `ROLE_IMAGE` |  |
| `42` | `ROLE_WINDOW` |  |
| `43` | `ROLE_TITLE_BAR` |  |
| `44` | `ROLE_DIALOG` |  |
| `45` | `ROLE_TOOLTIP` |  |
| `46` | `ROLE_REGION` |  |
| `47` | `ROLE_TEXT_RUN` |  |

### `AccessibilityPopupType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `POPUP_MENU` |  |
| `1` | `POPUP_LIST` |  |
| `2` | `POPUP_TREE` |  |
| `3` | `POPUP_DIALOG` |  |

### `AccessibilityFlags`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `FLAG_HIDDEN` |  |
| `1` | `FLAG_MULTISELECTABLE` |  |
| `2` | `FLAG_REQUIRED` |  |
| `3` | `FLAG_VISITED` |  |
| `4` | `FLAG_BUSY` |  |
| `5` | `FLAG_MODAL` |  |
| `6` | `FLAG_TOUCH_PASSTHROUGH` |  |
| `7` | `FLAG_READONLY` |  |
| `8` | `FLAG_DISABLED` |  |
| `9` | `FLAG_CLIPS_CHILDREN` |  |

### `AccessibilityAction`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ACTION_CLICK` |  |
| `1` | `ACTION_FOCUS` |  |
| `2` | `ACTION_BLUR` |  |
| `3` | `ACTION_COLLAPSE` |  |
| `4` | `ACTION_EXPAND` |  |
| `5` | `ACTION_DECREMENT` |  |
| `6` | `ACTION_INCREMENT` |  |
| `7` | `ACTION_HIDE_TOOLTIP` |  |
| `8` | `ACTION_SHOW_TOOLTIP` |  |
| `9` | `ACTION_SET_TEXT_SELECTION` |  |
| `10` | `ACTION_REPLACE_SELECTED_TEXT` |  |
| `11` | `ACTION_SCROLL_BACKWARD` |  |
| `12` | `ACTION_SCROLL_DOWN` |  |
| `13` | `ACTION_SCROLL_FORWARD` |  |
| `14` | `ACTION_SCROLL_LEFT` |  |
| `15` | `ACTION_SCROLL_RIGHT` |  |
| `16` | `ACTION_SCROLL_UP` |  |
| `17` | `ACTION_SCROLL_INTO_VIEW` |  |
| `18` | `ACTION_SCROLL_TO_POINT` |  |
| `19` | `ACTION_SET_SCROLL_OFFSET` |  |
| `20` | `ACTION_SET_VALUE` |  |
| `21` | `ACTION_SHOW_CONTEXT_MENU` |  |
| `22` | `ACTION_CUSTOM` |  |

### `AccessibilityLiveMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `LIVE_OFF` |  |
| `1` | `LIVE_POLITE` |  |
| `2` | `LIVE_ASSERTIVE` |  |

### `AccessibilityScrollUnit`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SCROLL_UNIT_ITEM` |  |
| `1` | `SCROLL_UNIT_PAGE` |  |

### `AccessibilityScrollHint`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SCROLL_HINT_TOP_LEFT` |  |
| `1` | `SCROLL_HINT_BOTTOM_RIGHT` |  |
| `2` | `SCROLL_HINT_TOP_EDGE` |  |
| `3` | `SCROLL_HINT_BOTTOM_EDGE` |  |
| `4` | `SCROLL_HINT_LEFT_EDGE` |  |
| `5` | `SCROLL_HINT_RIGHT_EDGE` |  |

