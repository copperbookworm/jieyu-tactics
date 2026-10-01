# TextEdit

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`TextEdit` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core · keywords=textarea
> 自动生成，勿手改。文件：`refs/godot-api/TextEdit.md`

**摘要**：A multiline text editor.

## 描述

A multiline text editor. It also has limited facilities for editing code, such as syntax highlighting support. For more advanced facilities for editing code, see `CodeEdit`.
		While entering text, it is possible to insert special characters using Unicode, OEM or Windows alt codes:
		- To enter Unicode codepoints, hold Alt and type the codepoint on the numpad. For example, to enter the character `á` (U+00E1), hold Alt and type +E1 on the numpad (the leading zeroes can be omitted).
		- To enter OEM codepoints, hold Alt and type the code on the numpad. For example, to enter the character `á` (OEM 160), hold Alt and type `160` on the numpad.
		- To enter Windows codepoints, hold Alt and type the code on the numpad. For example, to enter the character `á` (Windows 0225), hold Alt and type 0, 2, 2, 5 on the numpad. The leading zero here must **not** be omitted, as this is how Windows codepoints are distinguished from OEM codepoints.
		**Note:** Most viewport, caret, and edit methods contain a `caret_index` argument for `caret_multiple` support. The argument should be one of the following: `-1` for all carets, `0` for the main caret, or greater than `0` for secondary carets in the order they were created.
		**Note:** When holding down Alt, the vertical scroll wheel will scroll 5 times as fast as it would normally do. This also works in the Godot script editor.

## 属性

- **`autowrap_mode`** `int` = `3` · 枚举 `TextServer.AutowrapMode`
  - 其它属性：getter=get_autowrap_mode · setter=set_autowrap_mode
- **`backspace_deletes_composite_character_enabled`** `bool` = `false`
  - 其它属性：getter=is_backspace_deletes_composite_character_enabled · setter=set_backspace_deletes_composite_character_enabled
- **`caret_blink`** `bool` = `false`
  - 其它属性：getter=is_caret_blink_enabled · setter=set_caret_blink_enabled
- **`caret_blink_interval`** `float` = `0.65`
  - 其它属性：getter=get_caret_blink_interval · setter=set_caret_blink_interval
- **`caret_draw_when_editable_disabled`** `bool` = `false`
  - 其它属性：getter=is_drawing_caret_when_editable_disabled · setter=set_draw_caret_when_editable_disabled
- **`caret_mid_grapheme`** `bool` = `false`
  - 其它属性：getter=is_caret_mid_grapheme_enabled · setter=set_caret_mid_grapheme_enabled
- **`caret_move_on_right_click`** `bool` = `true`
  - 其它属性：getter=is_move_caret_on_right_click_enabled · setter=set_move_caret_on_right_click_enabled
- **`caret_multiple`** `bool` = `true`
  - 其它属性：getter=is_multiple_carets_enabled · setter=set_multiple_carets_enabled
- **`caret_type`** `int` = `0` · 枚举 `TextEdit.CaretType`
  - 其它属性：getter=get_caret_type · setter=set_caret_type
- **`context_menu_enabled`** `bool` = `true`
  - 其它属性：getter=is_context_menu_enabled · setter=set_context_menu_enabled
- **`custom_word_separators`** `String` = `""`
  - 其它属性：getter=get_custom_word_separators · setter=set_custom_word_separators
- **`deselect_on_focus_loss_enabled`** `bool` = `true`
  - 其它属性：getter=is_deselect_on_focus_loss_enabled · setter=set_deselect_on_focus_loss_enabled
- **`drag_and_drop_selection_enabled`** `bool` = `true`
  - 其它属性：getter=is_drag_and_drop_selection_enabled · setter=set_drag_and_drop_selection_enabled
- **`draw_control_chars`** `bool` = `false`
  - 其它属性：getter=get_draw_control_chars · setter=set_draw_control_chars
- **`draw_spaces`** `bool` = `false`
  - 其它属性：getter=is_drawing_spaces · setter=set_draw_spaces
- **`draw_tabs`** `bool` = `false`
  - 其它属性：getter=is_drawing_tabs · setter=set_draw_tabs
- **`editable`** `bool` = `true`
  - 其它属性：getter=is_editable · keywords=readonly, disabled, enabled · setter=set_editable
- **`emoji_menu_enabled`** `bool` = `true`
  - 其它属性：getter=is_emoji_menu_enabled · setter=set_emoji_menu_enabled
- **`empty_selection_clipboard_enabled`** `bool` = `true`
  - 其它属性：getter=is_empty_selection_clipboard_enabled · setter=set_empty_selection_clipboard_enabled
- **`focus_mode`** `int` = `2` · 枚举 `Control.FocusMode`
  - 其它属性：getter=get_focus_mode · overrides=Control · setter=set_focus_mode
- **`highlight_all_occurrences`** `bool` = `false`
  - 其它属性：getter=is_highlight_all_occurrences_enabled · setter=set_highlight_all_occurrences
- **`highlight_current_line`** `bool` = `false`
  - 其它属性：getter=is_highlight_current_line_enabled · setter=set_highlight_current_line
- **`indent_wrapped_lines`** `bool` = `false`
  - 其它属性：getter=is_indent_wrapped_lines · setter=set_indent_wrapped_lines
- **`language`** `String` = `""`
  - 其它属性：getter=get_language · setter=set_language
- **`middle_mouse_paste_enabled`** `bool` = `true`
  - 其它属性：getter=is_middle_mouse_paste_enabled · setter=set_middle_mouse_paste_enabled
- **`minimap_draw`** `bool` = `false`
  - 其它属性：getter=is_drawing_minimap · setter=set_draw_minimap
- **`minimap_width`** `int` = `80`
  - 其它属性：getter=get_minimap_width · setter=set_minimap_width
- **`mouse_default_cursor_shape`** `int` = `1` · 枚举 `Control.CursorShape`
  - 其它属性：getter=get_default_cursor_shape · overrides=Control · setter=set_default_cursor_shape
- **`placeholder_text`** `String` = `""`
  - 其它属性：getter=get_placeholder · setter=set_placeholder
- **`scroll_fit_content_height`** `bool` = `false`
  - 其它属性：getter=is_fit_content_height_enabled · setter=set_fit_content_height_enabled
- **`scroll_fit_content_width`** `bool` = `false`
  - 其它属性：getter=is_fit_content_width_enabled · setter=set_fit_content_width_enabled
- **`scroll_horizontal`** `int` = `0`
  - 其它属性：getter=get_h_scroll · setter=set_h_scroll
- **`scroll_past_end_of_file`** `bool` = `false`
  - 其它属性：getter=is_scroll_past_end_of_file_enabled · setter=set_scroll_past_end_of_file_enabled
- **`scroll_smooth`** `bool` = `false`
  - 其它属性：getter=is_smooth_scroll_enabled · setter=set_smooth_scroll_enabled
- **`scroll_v_scroll_speed`** `float` = `80.0`
  - 其它属性：getter=get_v_scroll_speed · setter=set_v_scroll_speed
- **`scroll_vertical`** `float` = `0.0`
  - 其它属性：getter=get_v_scroll · setter=set_v_scroll
- **`selecting_enabled`** `bool` = `true`
  - 其它属性：getter=is_selecting_enabled · setter=set_selecting_enabled
- **`shortcut_keys_enabled`** `bool` = `true`
  - 其它属性：getter=is_shortcut_keys_enabled · setter=set_shortcut_keys_enabled
- **`structured_text_bidi_override`** `int` = `0` · 枚举 `TextServer.StructuredTextParser`
  - 其它属性：getter=get_structured_text_bidi_override · setter=set_structured_text_bidi_override
- **`structured_text_bidi_override_options`** `Array` = `[]`
  - 其它属性：getter=get_structured_text_bidi_override_options · setter=set_structured_text_bidi_override_options
- **`syntax_highlighter`** `SyntaxHighlighter`
  - 其它属性：getter=get_syntax_highlighter · setter=set_syntax_highlighter
- **`tab_input_mode`** `bool` = `true`
  - 其它属性：getter=get_tab_input_mode · setter=set_tab_input_mode
- **`text`** `String` = `""`
  - 其它属性：getter=get_text · setter=set_text
- **`text_direction`** `int` = `0` · 枚举 `Control.TextDirection`
  - 其它属性：getter=get_text_direction · setter=set_text_direction
- **`use_custom_word_separators`** `bool` = `false`
  - 其它属性：getter=is_custom_word_separators_enabled · setter=set_use_custom_word_separators
- **`use_default_word_separators`** `bool` = `true`
  - 其它属性：getter=is_default_word_separators_enabled · setter=set_use_default_word_separators
- **`virtual_keyboard_enabled`** `bool` = `true`
  - 其它属性：getter=is_virtual_keyboard_enabled · setter=set_virtual_keyboard_enabled
- **`virtual_keyboard_show_on_focus`** `bool` = `true`
  - 其它属性：getter=get_virtual_keyboard_show_on_focus · setter=set_virtual_keyboard_show_on_focus
- **`wrap_mode`** `int` = `0` · 枚举 `TextEdit.LineWrappingMode`
  - 其它属性：getter=get_line_wrapping_mode · setter=set_line_wrapping_mode

## 方法

### `_backspace(caret_index: int) -> void`
- 限定：qualifiers=virtual

Override this method to define what happens when the user presses the backspace key.

### `_copy(caret_index: int) -> void`
- 限定：qualifiers=virtual

Override this method to define what happens when the user performs a copy operation.

### `_cut(caret_index: int) -> void`
- 限定：qualifiers=virtual

Override this method to define what happens when the user performs a cut operation.

### `_handle_unicode_input(unicode_char: int, caret_index: int) -> void`
- 限定：qualifiers=virtual

Override this method to define what happens when the user types in the provided key `unicode_char`.

### `_paste(caret_index: int) -> void`
- 限定：qualifiers=virtual

Override this method to define what happens when the user performs a paste operation.

### `_paste_primary_clipboard(caret_index: int) -> void`
- 限定：qualifiers=virtual

Override this method to define what happens when the user performs a paste operation with middle mouse button.
				**Note:** This method is only implemented on Linux.

### `add_caret(line: int, column: int) -> int`

Adds a new caret at the given location. Returns the index of the new caret, or `-1` if the location is invalid.

### `add_caret_at_carets(below: bool) -> void`

Adds an additional caret above or below every caret. If `below` is `true` the new caret will be added below and above otherwise.

### `add_gutter(at: int = -1) -> void`

Register a new gutter to this `TextEdit`. Use `at` to have a specific gutter order. A value of `-1` appends the gutter to the right.

### `add_selection_for_next_occurrence() -> void`

Adds a selection and a caret for the next occurrence of the current selection. If there is no active selection, selects word under caret.

### `adjust_carets_after_edit(caret: int, from_line: int, from_col: int, to_line: int, to_col: int) -> void`
- 限定：deprecated=No longer necessary since methods now adjust carets themselves.

This method does nothing.

### `adjust_viewport_to_caret(caret_index: int = 0) -> void`

Adjust the viewport so the caret is visible.

### `apply_ime() -> void`

Applies text from the Input Method Editor (https://en.wikipedia.org/wiki/Input_method) (IME) to each caret and closes the IME if it is open.

### `backspace(caret_index: int = -1) -> void`

Called when the user presses the backspace key. Can be overridden with `_backspace`.

### `begin_complex_operation() -> void`

Starts a multipart edit. All edits will be treated as one action until `end_complex_operation` is called.

### `begin_multicaret_edit() -> void`

Starts an edit for multiple carets. The edit must be ended with `end_multicaret_edit`. Multicaret edits can be used to edit text at multiple carets and delay merging the carets until the end, so the caret indexes aren't affected immediately. `begin_multicaret_edit` and `end_multicaret_edit` can be nested, and the merge will happen at the last `end_multicaret_edit`.
				
```gdscript
				begin_complex_operation()
				begin_multicaret_edit()
				for i in range(get_caret_count()):
					if multicaret_edit_ignore_caret(i):
						continue
					# Logic here.
				end_multicaret_edit()
				end_complex_operation()
				
```

### `cancel_ime() -> void`

Closes the Input Method Editor (https://en.wikipedia.org/wiki/Input_method) (IME) if it is open. Any text in the IME will be lost.

### `center_viewport_to_caret(caret_index: int = 0) -> void`

Centers the viewport on the line the editing caret is at. This also resets the `scroll_horizontal` value to `0`.

### `clear() -> void`

Performs a full reset of `TextEdit`, including undo history.

### `clear_undo_history() -> void`

Clears the undo history.

### `collapse_carets(from_line: int, from_column: int, to_line: int, to_column: int, inclusive: bool = false) -> void`

Collapse all carets in the given range to the `from_line` and `from_column` position.
				`inclusive` applies to both ends.
				If `is_in_mulitcaret_edit` is `true`, carets that are collapsed will be `true` for `multicaret_edit_ignore_caret`.
				`merge_overlapping_carets` will be called if any carets were collapsed.

### `copy(caret_index: int = -1) -> void`

Copies the current text selection. Can be overridden with `_copy`.

### `cut(caret_index: int = -1) -> void`

Cut's the current selection. Can be overridden with `_cut`.

### `delete_selection(caret_index: int = -1) -> void`

Deletes the selected text.

### `deselect(caret_index: int = -1) -> void`

Deselects the current selection.

### `end_action() -> void`

Marks the end of steps in the current action started with `start_action`.

### `end_complex_operation() -> void`

Ends a multipart edit, started with `begin_complex_operation`. If called outside a complex operation, the current operation is pushed onto the undo/redo stack.

### `end_multicaret_edit() -> void`

Ends an edit for multiple carets, that was started with `begin_multicaret_edit`. If this was the last `end_multicaret_edit` and `merge_overlapping_carets` was called, carets will be merged.

### `get_caret_column(caret_index: int = 0) -> int`
- 限定：qualifiers=const

Returns the column the editing caret is at.

### `get_caret_count() -> int`
- 限定：qualifiers=const

Returns the number of carets in this `TextEdit`.

### `get_caret_draw_pos(caret_index: int = 0) -> Vector2`
- 限定：qualifiers=const

Returns the caret pixel draw position.

### `get_caret_index_edit_order() -> PackedInt32Array`
- 限定：deprecated=Carets no longer need to be edited in any specific order. If the carets need to be sorted, use [method get_sorted_carets] instead.

Returns a list of caret indexes in their edit order, this done from bottom to top. Edit order refers to the way actions such as `insert_text_at_caret` are applied.

### `get_caret_line(caret_index: int = 0) -> int`
- 限定：qualifiers=const

Returns the line the editing caret is on.

### `get_caret_wrap_index(caret_index: int = 0) -> int`
- 限定：qualifiers=const

Returns the wrap index the editing caret is on.

### `get_first_non_whitespace_column(line: int) -> int`
- 限定：qualifiers=const

Returns the first column containing a non-whitespace character on the given line. If there is only whitespace, returns the number of characters.

### `get_first_visible_line() -> int`
- 限定：qualifiers=const

Returns the first visible line.

### `get_gutter_count() -> int`
- 限定：qualifiers=const

Returns the number of gutters registered.

### `get_gutter_name(gutter: int) -> String`
- 限定：qualifiers=const

Returns the name of the gutter at the given index.

### `get_gutter_type(gutter: int) -> int`
- 限定：qualifiers=const

Returns the type of the gutter at the given index. Gutters can contain icons, text, or custom visuals.

### `get_gutter_width(gutter: int) -> int`
- 限定：qualifiers=const

Returns the width of the gutter at the given index.

### `get_h_scroll_bar() -> HScrollBar`
- 限定：qualifiers=const

Returns the `HScrollBar` used by `TextEdit`.

### `get_indent_level(line: int) -> int`
- 限定：qualifiers=const

Returns the indent level of the given line. This is the number of spaces and tabs at the beginning of the line, with the tabs taking the tab size into account (see `get_tab_size`).

### `get_last_full_visible_line() -> int`
- 限定：qualifiers=const

Returns the last visible line. Use `get_last_full_visible_line_wrap_index` for the wrap index.

### `get_last_full_visible_line_wrap_index() -> int`
- 限定：qualifiers=const

Returns the last visible wrap index of the last visible line.

### `get_last_unhidden_line() -> int`
- 限定：qualifiers=const

Returns the last unhidden line in the entire `TextEdit`.

### `get_line(line: int) -> String`
- 限定：qualifiers=const

Returns the text of a specific line.

### `get_line_background_color(line: int) -> Color`
- 限定：qualifiers=const

Returns the custom background color of the given line. If no color is set, returns `Color(0, 0, 0, 0)`.

### `get_line_column_at_pos(position: Vector2i, clamp_line: bool = true, clamp_column: bool = true) -> Vector2i`
- 限定：qualifiers=const

Returns the line and column at the given position. In the returned vector, `x` is the column and `y` is the line.
				If `clamp_line` is `false` and `position` is below the last line, `Vector2i(-1, -1)` is returned.
				If `clamp_column` is `false` and `position` is outside the column range of the line, `Vector2i(-1, -1)` is returned.

### `get_line_count() -> int`
- 限定：qualifiers=const

Returns the number of lines in the text.

### `get_line_gutter_icon(line: int, gutter: int) -> Texture2D`
- 限定：qualifiers=const

Returns the icon currently in `gutter` at `line`. This only works when the gutter type is `GUTTER_TYPE_ICON` (see `set_gutter_type`).

### `get_line_gutter_item_color(line: int, gutter: int) -> Color`
- 限定：qualifiers=const

Returns the color currently in `gutter` at `line`.

### `get_line_gutter_metadata(line: int, gutter: int) -> Variant`
- 限定：qualifiers=const

Returns the metadata currently in `gutter` at `line`.

### `get_line_gutter_text(line: int, gutter: int) -> String`
- 限定：qualifiers=const

Returns the text currently in `gutter` at `line`. This only works when the gutter type is `GUTTER_TYPE_STRING` (see `set_gutter_type`).

### `get_line_height() -> int`
- 限定：qualifiers=const

Returns the maximum value of the line height among all lines.
				**Note:** The return value is influenced by `line_spacing` and `font_size`. And it will not be less than `1`.

### `get_line_ranges_from_carets(only_selections: bool = false, merge_adjacent: bool = true) -> Vector2i[]`
- 限定：qualifiers=const

Returns an `Array` of line ranges where `x` is the first line and `y` is the last line. All lines within these ranges will have a caret on them or be part of a selection. Each line will only be part of one line range, even if it has multiple carets on it.
				If a selection's end column (`get_selection_to_column`) is at column `0`, that line will not be included. If a selection begins on the line after another selection ends and `merge_adjacent` is `true`, or they begin and end on the same line, one line range will include both selections.

### `get_line_width(line: int, wrap_index: int = -1) -> int`
- 限定：qualifiers=const

Returns the width in pixels of the `wrap_index` on `line`.

### `get_line_with_ime(line: int) -> String`
- 限定：qualifiers=const

Returns line text as it is currently displayed, including IME composition string.

### `get_line_wrap_count(line: int) -> int`
- 限定：qualifiers=const

Returns the number of times the given line is wrapped.

### `get_line_wrap_index_at_column(line: int, column: int) -> int`
- 限定：qualifiers=const

Returns the wrap index of the given column on the given line. This ranges from `0` to `get_line_wrap_count`.

### `get_line_wrapped_text(line: int) -> PackedStringArray`
- 限定：qualifiers=const

Returns an array of `String`s representing each wrapped index.

### `get_local_mouse_pos() -> Vector2`
- 限定：qualifiers=const

Returns the local mouse position adjusted for the text direction.

### `get_menu() -> PopupMenu`
- 限定：qualifiers=const

Returns the `PopupMenu` of this `TextEdit`. By default, this menu is displayed when right-clicking on the `TextEdit`.
				You can add custom menu items or remove standard ones. Make sure your IDs don't conflict with the standard ones (see `MenuItems`). For example:
				`codeblocks`
				`gdscript`
				func _ready():
					var menu = get_menu()
					# Remove all items after "Redo".
					menu.item_count = menu.get_item_index(MENU_REDO) + 1
					# Add custom items.
					menu.add_separator()
					menu.add_item("Insert Date", MENU_MAX + 1)
					# Connect callback.
					menu.id_pressed.connect(_on_item_pressed)

				func _on_item_pressed(id):
					if id == MENU_MAX + 1:
						insert_text_at_caret(Time.get_date_string_from_system())
				
				`csharp`
				public override void _Ready()
				{
					var menu = GetMenu();
					// Remove all items after "Redo".
					menu.ItemCount = menu.GetItemIndex(TextEdit.MenuItems.Redo) + 1;
					// Add custom items.
					menu.AddSeparator();
					menu.AddItem("Insert Date", TextEdit.MenuItems.Max + 1);
					// Add event handler.
					menu.IdPressed += OnItemPressed;
				}

				public void OnItemPressed(int id)
				{
					if (id == TextEdit.MenuItems.Max + 1)
					{
						InsertTextAtCaret(Time.GetDateStringFromSystem());
					}
				}
				
				
				**Warning:** This is a required internal node, removing and freeing it may cause a crash. If you wish to hide it or any of its children, use their `Window.visible` property.

### `get_minimap_line_at_pos(position: Vector2i) -> int`
- 限定：qualifiers=const

Returns the equivalent minimap line at `position`.

### `get_minimap_visible_lines() -> int`
- 限定：qualifiers=const

Returns the number of lines that may be drawn on the minimap.

### `get_next_composite_character_column(line: int, column: int) -> int`
- 限定：qualifiers=const

Returns the correct column at the end of a composite character like ❤️‍🩹 (mending heart; Unicode: `U+2764 U+FE0F U+200D U+1FA79`) which is comprised of more than one Unicode code point, if the caret is at the start of the composite character. Also returns the correct column with the caret at mid grapheme and for non-composite characters.
				**Note:** To check at caret location use `get_next_composite_character_column(get_caret_line(), get_caret_column())`

### `get_next_visible_line_index_offset_from(line: int, wrap_index: int, visible_amount: int) -> Vector2i`
- 限定：qualifiers=const

Similar to `get_next_visible_line_offset_from`, but takes into account the line wrap indexes. In the returned vector, `x` is the line, `y` is the wrap index.

### `get_next_visible_line_offset_from(line: int, visible_amount: int) -> int`
- 限定：qualifiers=const

Returns the count to the next visible line from `line` to `line + visible_amount`. Can also count backwards. For example if a `TextEdit` has 5 lines with lines 2 and 3 hidden, calling this with `line = 1, visible_amount = 1` would return 3.

### `get_pos_at_line_column(line: int, column: int) -> Vector2i`
- 限定：qualifiers=const

Returns the local position for the given `line` and `column`. If `x` or `y` of the returned vector equal `-1`, the position is outside of the viewable area of the control.
				**Note:** The Y position corresponds to the bottom side of the line. Use `get_rect_at_line_column` to get the top side position.

### `get_previous_composite_character_column(line: int, column: int) -> int`
- 限定：qualifiers=const

Returns the correct column at the start of a composite character like ❤️‍🩹 (mending heart; Unicode: `U+2764 U+FE0F U+200D U+1FA79`) which is comprised of more than one Unicode code point, if the caret is at the end of the composite character. Also returns the correct column with the caret at mid grapheme and for non-composite characters.
				**Note:** To check at caret location use `get_previous_composite_character_column(get_caret_line(), get_caret_column())`

### `get_rect_at_line_column(line: int, column: int) -> Rect2i`
- 限定：qualifiers=const

Returns the local position and size for the grapheme at the given `line` and `column`. If `x` or `y` position of the returned rect equal `-1`, the position is outside of the viewable area of the control.
				**Note:** The Y position of the returned rect corresponds to the top side of the line, unlike `get_pos_at_line_column` which returns the bottom side.

### `get_saved_version() -> int`
- 限定：qualifiers=const

Returns the last tagged saved version from `tag_saved_version`.

### `get_scroll_pos_for_line(line: int, wrap_index: int = 0) -> float`
- 限定：qualifiers=const

Returns the scroll position for `wrap_index` of `line`.

### `get_selected_text(caret_index: int = -1) -> String`

Returns the text inside the selection of a caret, or all the carets if `caret_index` is its default value `-1`.

### `get_selection_at_line_column(line: int, column: int, include_edges: bool = true, only_selections: bool = true) -> int`
- 限定：qualifiers=const

Returns the caret index of the selection at the given `line` and `column`, or `-1` if there is none.
				If `include_edges` is `false`, the position must be inside the selection and not at either end. If `only_selections` is `false`, carets without a selection will also be considered.

### `get_selection_column(caret_index: int = 0) -> int`
- 限定：deprecated=Use [method get_selection_origin_column] instead. · qualifiers=const

Returns the original start column of the selection.

### `get_selection_from_column(caret_index: int = 0) -> int`
- 限定：qualifiers=const

Returns the selection begin column. Returns the caret column if there is no selection.

### `get_selection_from_line(caret_index: int = 0) -> int`
- 限定：qualifiers=const

Returns the selection begin line. Returns the caret line if there is no selection.

### `get_selection_line(caret_index: int = 0) -> int`
- 限定：deprecated=Use [method get_selection_origin_line] instead. · qualifiers=const

Returns the original start line of the selection.

### `get_selection_mode() -> int`
- 限定：qualifiers=const

Returns the current selection mode.

### `get_selection_origin_column(caret_index: int = 0) -> int`
- 限定：qualifiers=const

Returns the origin column of the selection. This is the opposite end from the caret.

### `get_selection_origin_line(caret_index: int = 0) -> int`
- 限定：qualifiers=const

Returns the origin line of the selection. This is the opposite end from the caret.

### `get_selection_to_column(caret_index: int = 0) -> int`
- 限定：qualifiers=const

Returns the selection end column. Returns the caret column if there is no selection.

### `get_selection_to_line(caret_index: int = 0) -> int`
- 限定：qualifiers=const

Returns the selection end line. Returns the caret line if there is no selection.

### `get_sorted_carets(include_ignored_carets: bool = false) -> PackedInt32Array`
- 限定：qualifiers=const

Returns the carets sorted by selection beginning from lowest line and column to highest (from top to bottom of text).
				If `include_ignored_carets` is `false`, carets from `multicaret_edit_ignore_caret` will be ignored.

### `get_tab_size() -> int`
- 限定：qualifiers=const

Returns the `TextEdit`'s' tab size.

### `get_total_gutter_width() -> int`
- 限定：qualifiers=const

Returns the total width of all gutters and internal padding.

### `get_total_visible_line_count() -> int`
- 限定：qualifiers=const

Returns the total number of lines in the text. This includes wrapped lines and excludes folded lines. If `wrap_mode` is set to `LINE_WRAPPING_NONE` and no lines are folded (see `CodeEdit.is_line_folded`) then this is equivalent to `get_line_count`. See `get_visible_line_count_in_range` for a limited range of lines.

### `get_v_scroll_bar() -> VScrollBar`
- 限定：qualifiers=const

Returns the `VScrollBar` of the `TextEdit`.

### `get_version() -> int`
- 限定：qualifiers=const

Returns the current version of the `TextEdit`. The version is a count of recorded operations by the undo/redo history.

### `get_visible_line_count() -> int`
- 限定：qualifiers=const

Returns the number of lines that can visually fit, rounded down, based on this control's height.

### `get_visible_line_count_in_range(from_line: int, to_line: int) -> int`
- 限定：qualifiers=const

Returns the total number of lines between `from_line` and `to_line` (inclusive) in the text. This includes wrapped lines and excludes folded lines. If the range covers all lines it is equivalent to `get_total_visible_line_count`.

### `get_word_at_pos(position: Vector2) -> String`
- 限定：qualifiers=const

Returns the word at `position`.

### `get_word_under_caret(caret_index: int = -1) -> String`
- 限定：qualifiers=const

Returns a `String` text with the word under the caret's location.

### `has_ime_text() -> bool`
- 限定：qualifiers=const

Returns `true` if the user has text in the Input Method Editor (https://en.wikipedia.org/wiki/Input_method) (IME).

### `has_redo() -> bool`
- 限定：qualifiers=const

Returns `true` if a "redo" action is available.

### `has_selection(caret_index: int = -1) -> bool`
- 限定：qualifiers=const

Returns `true` if the user has selected text.

### `has_undo() -> bool`
- 限定：qualifiers=const

Returns `true` if an "undo" action is available.

### `insert_line_at(line: int, text: String) -> void`

Inserts a new line with `text` at `line`.

### `insert_text(text: String, line: int, column: int, before_selection_begin: bool = true, before_selection_end: bool = false) -> void`

Inserts the `text` at `line` and `column`.
				If `before_selection_begin` is `true`, carets and selections that begin at `line` and `column` will moved to the end of the inserted text, along with all carets after it.
				If `before_selection_end` is `true`, selections that end at `line` and `column` will be extended to the end of the inserted text. These parameters can be used to insert text inside of or outside of selections.

### `insert_text_at_caret(text: String, caret_index: int = -1) -> void`

Insert the specified text at the caret position.

### `is_caret_after_selection_origin(caret_index: int = 0) -> bool`
- 限定：qualifiers=const

Returns `true` if the caret of the selection is after the selection origin. This can be used to determine the direction of the selection.

### `is_caret_visible(caret_index: int = 0) -> bool`
- 限定：qualifiers=const

Returns `true` if the caret is visible, `false` otherwise. A caret will be considered hidden if it is outside the scrollable area when scrolling is enabled.
				**Note:** `is_caret_visible` does not account for a caret being off-screen if it is still within the scrollable area. It will return `true` even if the caret is off-screen as long as it meets `TextEdit`'s own conditions for being visible. This includes uses of `scroll_fit_content_width` and `scroll_fit_content_height` that cause the `TextEdit` to expand beyond the viewport's bounds.
				**Note:** This method does *not* guarantee an accurate visibility check immediately after setting the caret position. The correct value may only be available in the next frame after the `TextEdit` has finished drawing. This also applies to any operation that causes the `TextEdit` to change in size.

### `is_dragging_cursor() -> bool`
- 限定：qualifiers=const

Returns `true` if the user is dragging their mouse for scrolling, selecting, or text dragging.

### `is_gutter_clickable(gutter: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the gutter at the given index is clickable. See `set_gutter_clickable`.

### `is_gutter_drawn(gutter: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the gutter at the given index is currently drawn. See `set_gutter_draw`.

### `is_gutter_overwritable(gutter: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the gutter at the given index is overwritable. See `set_gutter_overwritable`.

### `is_in_mulitcaret_edit() -> bool`
- 限定：qualifiers=const

Returns `true` if a `begin_multicaret_edit` has been called and `end_multicaret_edit` has not yet been called.

### `is_line_gutter_clickable(line: int, gutter: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the gutter at the given index on the given line is clickable. See `set_line_gutter_clickable`.

### `is_line_in_viewport(line: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the given line is within the scope of the scrollable area of the viewport.

### `is_line_wrapped(line: int) -> bool`
- 限定：qualifiers=const

Returns if the given line is wrapped.

### `is_menu_visible() -> bool`
- 限定：qualifiers=const

Returns `true` if the menu is visible. Use this instead of `get_menu().visible` to improve performance (so the creation of the menu is avoided). See `get_menu`.

### `is_mouse_over_selection(edges: bool, caret_index: int = -1) -> bool`
- 限定：qualifiers=const

Returns `true` if the mouse is over a selection. If `edges` is `true`, the edges are considered part of the selection.

### `is_overtype_mode_enabled() -> bool`
- 限定：qualifiers=const

Returns `true` if overtype mode is enabled. See `set_overtype_mode_enabled`.

### `menu_option(option: int) -> void`

Executes a given action as defined in the `MenuItems` enum.

### `merge_gutters(from_line: int, to_line: int) -> void`

Merge the gutters from `from_line` into `to_line`. Only overwritable gutters will be copied. See `set_gutter_overwritable`.

### `merge_overlapping_carets() -> void`

Merges any overlapping carets. Will favor the newest caret, or the caret with a selection.
				If `is_in_mulitcaret_edit` is `true`, the merge will be queued to happen at the end of the multicaret edit. See `begin_multicaret_edit` and `end_multicaret_edit`.
				**Note:** This is not called when a caret changes position but after certain actions, so it is possible to get into a state where carets overlap.

### `multicaret_edit_ignore_caret(caret_index: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the given `caret_index` should be ignored as part of a multicaret edit. See `begin_multicaret_edit` and `end_multicaret_edit`. Carets that should be ignored are ones that were part of removed text and will likely be merged at the end of the edit, or carets that were added during the edit.
				It is recommended to `continue` within a loop iterating on multiple carets if a caret should be ignored.

### `paste(caret_index: int = -1) -> void`

Paste at the current location. Can be overridden with `_paste`.

### `paste_primary_clipboard(caret_index: int = -1) -> void`

Pastes the primary clipboard.

### `redo() -> void`

Perform redo operation.

### `remove_caret(caret: int) -> void`

Removes the given caret index.
				**Note:** This can result in adjustment of all other caret indices.

### `remove_gutter(gutter: int) -> void`

Removes the gutter at the given index.

### `remove_line_at(line: int, move_carets_down: bool = true) -> void`

Removes the line of text at `line`. Carets on this line will attempt to match their previous visual x position.
				If `move_carets_down` is `true` carets will move to the next line down, otherwise carets will move up.

### `remove_secondary_carets() -> void`

Removes all additional carets.

### `remove_text(from_line: int, from_column: int, to_line: int, to_column: int) -> void`

Removes text between the given positions.

### `search(text: String, flags: int, from_line: int, from_column: int) -> Vector2i`
- 限定：qualifiers=const

Perform a search inside the text. Search flags can be specified in the `SearchFlags` enum.
				In the returned vector, `x` is the column, `y` is the line. If no results are found, both are equal to `-1`.
				`codeblocks`
				`gdscript`
				var result = search("print", SEARCH_WHOLE_WORDS, 0, 0)
				if result.x != -1:
					# Result found.
					var line_number = result.y
					var column_number = result.x
				
				`csharp`
				Vector2I result = Search("print", (uint)TextEdit.SearchFlags.WholeWords, 0, 0);
				if (result.X != -1)
				{
					// Result found.
					int lineNumber = result.Y;
					int columnNumber = result.X;
				}

### `select(origin_line: int, origin_column: int, caret_line: int, caret_column: int, caret_index: int = 0) -> void`

Selects text from `origin_line` and `origin_column` to `caret_line` and `caret_column` for the given `caret_index`. This moves the selection origin and the caret. If the positions are the same, the selection will be deselected.
				If `selecting_enabled` is `false`, no selection will occur.
				**Note:** If supporting multiple carets this will not check for any overlap. See `merge_overlapping_carets`.

### `select_all() -> void`

Select all the text.
				If `selecting_enabled` is `false`, no selection will occur.

### `select_word_under_caret(caret_index: int = -1) -> void`

Selects the word under the caret.

### `set_caret_column(column: int, adjust_viewport: bool = true, caret_index: int = 0) -> void`

Moves the caret to the specified `column` index.
				If `adjust_viewport` is `true`, the viewport will center at the caret position after the move occurs.
				**Note:** If supporting multiple carets this will not check for any overlap. See `merge_overlapping_carets`.

### `set_caret_line(line: int, adjust_viewport: bool = true, can_be_hidden: bool = true, wrap_index: int = 0, caret_index: int = 0) -> void`

Moves the caret to the specified `line` index. The caret column will be moved to the same visual position it was at the last time `set_caret_column` was called, or clamped to the end of the line.
				If `adjust_viewport` is `true`, the viewport will center at the caret position after the move occurs.
				If `can_be_hidden` is `true`, the specified `line` can be hidden.
				If `wrap_index` is `-1`, the caret column will be clamped to the `line`'s length. If `wrap_index` is greater than `-1`, the column will be moved to attempt to match the visual x position on the line's `wrap_index` to the position from the last time `set_caret_column` was called.
				**Note:** If supporting multiple carets this will not check for any overlap. See `merge_overlapping_carets`.

### `set_gutter_clickable(gutter: int, clickable: bool) -> void`

If `true`, the mouse cursor will change to a pointing hand (`Control.CURSOR_POINTING_HAND`) when hovering over the gutter at the given index. See `is_gutter_clickable` and `set_line_gutter_clickable`.

### `set_gutter_custom_draw(column: int, draw_callback: Callable) -> void`

Set a custom draw callback for the gutter at the given index. `draw_callback` must take the following arguments: A line index `int`, a gutter index `int`, and an area `Rect2`. This callback only works when the gutter type is `GUTTER_TYPE_CUSTOM` (see `set_gutter_type`).

### `set_gutter_draw(gutter: int, draw: bool) -> void`

If `true`, the gutter at the given index is drawn. The gutter type (`set_gutter_type`) determines how it is drawn. See `is_gutter_drawn`.

### `set_gutter_name(gutter: int, name: String) -> void`

Sets the name of the gutter at the given index.

### `set_gutter_overwritable(gutter: int, overwritable: bool) -> void`

If `true`, the line data of the gutter at the given index can be overridden when using `merge_gutters`. See `is_gutter_overwritable`.

### `set_gutter_type(gutter: int, type: int) -> void`

Sets the type of gutter at the given index. Gutters can contain icons, text, or custom visuals.

### `set_gutter_width(gutter: int, width: int) -> void`

Set the width of the gutter at the given index.

### `set_line(line: int, new_text: String) -> void`

Sets the text for a specific `line`.
				Carets on the line will attempt to keep their visual x position.

### `set_line_as_center_visible(line: int, wrap_index: int = 0) -> void`

Positions the `wrap_index` of `line` at the center of the viewport.

### `set_line_as_first_visible(line: int, wrap_index: int = 0) -> void`

Positions the `wrap_index` of `line` at the top of the viewport.

### `set_line_as_last_visible(line: int, wrap_index: int = 0) -> void`

Positions the `wrap_index` of `line` at the bottom of the viewport.

### `set_line_background_color(line: int, color: Color) -> void`

Sets the custom background color of the given line. If transparent, this color is applied on top of the default background color (See `background_color`). If set to `Color(0, 0, 0, 0)`, no additional color is applied.

### `set_line_gutter_clickable(line: int, gutter: int, clickable: bool) -> void`

If `clickable` is `true`, makes the `gutter` on the given `line` clickable. This is like `set_gutter_clickable`, but for a single line. If `is_gutter_clickable` is `true`, this will not have any effect. See `is_line_gutter_clickable` and `gutter_clicked`.

### `set_line_gutter_icon(line: int, gutter: int, icon: Texture2D) -> void`

Sets the icon for `gutter` on `line` to `icon`. This only works when the gutter type is `GUTTER_TYPE_ICON` (see `set_gutter_type`).

### `set_line_gutter_item_color(line: int, gutter: int, color: Color) -> void`

Sets the color for `gutter` on `line` to `color`.

### `set_line_gutter_metadata(line: int, gutter: int, metadata: Variant) -> void`

Sets the metadata for `gutter` on `line` to `metadata`.

### `set_line_gutter_text(line: int, gutter: int, text: String) -> void`

Sets the text for `gutter` on `line` to `text`. This only works when the gutter type is `GUTTER_TYPE_STRING` (see `set_gutter_type`).

### `set_overtype_mode_enabled(enabled: bool) -> void`

If `true`, enables overtype mode. In this mode, typing overrides existing text instead of inserting text. The `ProjectSettings.input/ui_text_toggle_insert_mode` action toggles overtype mode. See `is_overtype_mode_enabled`.

### `set_search_flags(flags: int) -> void`

Sets the search `flags`. This is used with `set_search_text` to highlight occurrences of the searched text. Search flags can be specified from the `SearchFlags` enum.

### `set_search_text(search_text: String) -> void`

Sets the search text. See `set_search_flags`.

### `set_selection_mode(mode: int) -> void`

Sets the current selection mode.

### `set_selection_origin_column(column: int, caret_index: int = 0) -> void`

Sets the selection origin column to the `column` for the given `caret_index`. If the selection origin is moved to the caret position, the selection will deselect.

### `set_selection_origin_line(line: int, can_be_hidden: bool = true, wrap_index: int = -1, caret_index: int = 0) -> void`

Sets the selection origin line to the `line` for the given `caret_index`. If the selection origin is moved to the caret position, the selection will deselect.
				If `can_be_hidden` is `false`, The line will be set to the nearest unhidden line below or above.
				If `wrap_index` is `-1`, the selection origin column will be clamped to the `line`'s length. If `wrap_index` is greater than `-1`, the column will be moved to attempt to match the visual x position on the line's `wrap_index` to the position from the last time `set_selection_origin_column` or `select` was called.

### `set_tab_size(size: int) -> void`

Sets the tab size for the `TextEdit` to use.

### `set_tooltip_request_func(callback: Callable) -> void`

Provide custom tooltip text. The callback method must take the following args: `hovered_word: String`.

### `skip_selection_for_next_occurrence() -> void`

Moves a selection and a caret for the next occurrence of the current selection. If there is no active selection, moves to the next occurrence of the word under caret.

### `start_action(action: int) -> void`

Starts an action, will end the current action if `action` is different.
				An action will also end after a call to `end_action`, after `ProjectSettings.gui/timers/text_edit_idle_detect_sec` is triggered or a new undoable step outside the `start_action` and `end_action` calls.

### `swap_lines(from_line: int, to_line: int) -> void`

Swaps the two lines. Carets will be swapped with the lines.

### `tag_saved_version() -> void`

Tag the current version as saved.

### `undo() -> void`

Perform undo operation.

## 信号

### `caret_changed()`

Emitted when any caret changes position.

### `gutter_added()`

Emitted when a gutter is added.

### `gutter_clicked(line: int, gutter: int)`

Emitted when a gutter is clicked.

### `gutter_removed()`

Emitted when a gutter is removed.

### `lines_edited_from(from_line: int, to_line: int)`

Emitted immediately when the text changes.
				When text is added `from_line` will be less than `to_line`. On a remove `to_line` will be less than `from_line`.

### `text_changed()`

Emitted when the text changes.

### `text_set()`

Emitted when `clear` is called or `text` is set.

## 枚举

### `MenuItems`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `MENU_CUT` |  |
| `1` | `MENU_COPY` |  |
| `2` | `MENU_PASTE` |  |
| `3` | `MENU_CLEAR` |  |
| `4` | `MENU_SELECT_ALL` |  |
| `5` | `MENU_UNDO` |  |
| `6` | `MENU_REDO` |  |
| `7` | `MENU_SUBMENU_TEXT_DIR` |  |
| `8` | `MENU_DIR_INHERITED` |  |
| `9` | `MENU_DIR_AUTO` |  |
| `10` | `MENU_DIR_LTR` |  |
| `11` | `MENU_DIR_RTL` |  |
| `12` | `MENU_DISPLAY_UCC` |  |
| `13` | `MENU_SUBMENU_INSERT_UCC` |  |
| `14` | `MENU_INSERT_LRM` |  |
| `15` | `MENU_INSERT_RLM` |  |
| `16` | `MENU_INSERT_LRE` |  |
| `17` | `MENU_INSERT_RLE` |  |
| `18` | `MENU_INSERT_LRO` |  |
| `19` | `MENU_INSERT_RLO` |  |
| `20` | `MENU_INSERT_PDF` |  |
| `21` | `MENU_INSERT_ALM` |  |
| `22` | `MENU_INSERT_LRI` |  |
| `23` | `MENU_INSERT_RLI` |  |
| `24` | `MENU_INSERT_FSI` |  |
| `25` | `MENU_INSERT_PDI` |  |
| `26` | `MENU_INSERT_ZWJ` |  |
| `27` | `MENU_INSERT_ZWNJ` |  |
| `28` | `MENU_INSERT_WJ` |  |
| `29` | `MENU_INSERT_SHY` |  |
| `30` | `MENU_EMOJI_AND_SYMBOL` |  |
| `31` | `MENU_MAX` |  |

### `EditAction`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ACTION_NONE` |  |
| `1` | `ACTION_TYPING` |  |
| `2` | `ACTION_BACKSPACE` |  |
| `3` | `ACTION_DELETE` |  |

### `SearchFlags`

| 值 | 名称 | 说明 |
|---|---|---|
| `1` | `SEARCH_MATCH_CASE` |  |
| `2` | `SEARCH_WHOLE_WORDS` |  |
| `4` | `SEARCH_BACKWARDS` |  |

### `CaretType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `CARET_TYPE_LINE` |  |
| `1` | `CARET_TYPE_BLOCK` |  |

### `SelectionMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SELECTION_MODE_NONE` |  |
| `1` | `SELECTION_MODE_SHIFT` |  |
| `2` | `SELECTION_MODE_POINTER` |  |
| `3` | `SELECTION_MODE_WORD` |  |
| `4` | `SELECTION_MODE_LINE` |  |

### `LineWrappingMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `LINE_WRAPPING_NONE` |  |
| `1` | `LINE_WRAPPING_BOUNDARY` |  |

### `GutterType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `GUTTER_TYPE_STRING` |  |
| `1` | `GUTTER_TYPE_ICON` |  |
| `2` | `GUTTER_TYPE_CUSTOM` |  |

## 主题属性

### `background_color`
- data_type=color · default=Color(0, 0, 0, 0) · deprecated=Assign a [StyleBoxFlat] to [theme_item normal] instead, and set [member StyleBoxFlat.bg_color] to the desired background color. · type=Color

### `caret_background_color`
- data_type=color · default=Color(0, 0, 0, 1) · type=Color

### `caret_color`
- data_type=color · default=Color(0.875, 0.875, 0.875, 1) · type=Color

### `current_line_color`
- data_type=color · default=Color(0.25, 0.25, 0.26, 0.8) · type=Color

### `font_color`
- data_type=color · default=Color(0.875, 0.875, 0.875, 1) · type=Color

### `font_outline_color`
- data_type=color · default=Color(0, 0, 0, 1) · type=Color

### `font_placeholder_color`
- data_type=color · default=Color(0.875, 0.875, 0.875, 0.6) · type=Color

### `font_readonly_color`
- data_type=color · default=Color(0.875, 0.875, 0.875, 0.5) · type=Color

### `font_selected_color`
- data_type=color · default=Color(0, 0, 0, 0) · type=Color

### `search_result_border_color`
- data_type=color · default=Color(0.3, 0.3, 0.3, 0.4) · type=Color

### `search_result_color`
- data_type=color · default=Color(0.3, 0.3, 0.3, 1) · type=Color

### `selection_color`
- data_type=color · default=Color(0.5, 0.5, 0.5, 1) · type=Color

### `word_highlighted_color`
- data_type=color · default=Color(0.5, 0.5, 0.5, 0.25) · type=Color

### `caret_width`
- data_type=constant · default=1 · type=int

### `line_spacing`
- data_type=constant · default=4 · type=int

### `outline_size`
- data_type=constant · default=0 · type=int

### `wrap_offset`
- data_type=constant · default=10 · type=int

### `font`
- data_type=font · type=Font

### `font_size`
- data_type=font_size · type=int

### `space`
- data_type=icon · type=Texture2D

### `tab`
- data_type=icon · type=Texture2D

### `focus`
- data_type=style · type=StyleBox

### `normal`
- data_type=style · type=StyleBox

### `read_only`
- data_type=style · keywords=enabled, disabled, editable · type=StyleBox

