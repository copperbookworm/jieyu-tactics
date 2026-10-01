# LineEdit

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`LineEdit` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core · keywords=text, input
> 自动生成，勿手改。文件：`refs/godot-api/LineEdit.md`

**摘要**：An input field for single-line text.

## 描述

`LineEdit` provides an input field for editing a single line of text.
		- When the `LineEdit` control is focused using the keyboard arrow keys, it will only gain focus and not enter edit mode.
		- To enter edit mode, click on the control with the mouse, see also `keep_editing_on_text_submit`.
		- To exit edit mode, press `ui_text_submit` or `ui_cancel` (by default Escape) actions.
		- Check `edit`, `unedit`, `is_editing`, and `editing_toggled` for more information.
		While entering text, it is possible to insert special characters using Unicode, OEM or Windows alt codes:
		- To enter Unicode codepoints, hold Alt and type the codepoint on the numpad. For example, to enter the character `á` (U+00E1), hold Alt and type +E1 on the numpad (the leading zeroes can be omitted).
		- To enter OEM codepoints, hold Alt and type the code on the numpad. For example, to enter the character `á` (OEM 160), hold Alt and type `160` on the numpad.
		- To enter Windows codepoints, hold Alt and type the code on the numpad. For example, to enter the character `á` (Windows 0225), hold Alt and type 0, 2, 2, 5 on the numpad. The leading zero here must **not** be omitted, as this is how Windows codepoints are distinguished from OEM codepoints.
		**Important:**
		- Focusing the `LineEdit` with `ui_focus_next` (by default Tab) or `ui_focus_prev` (by default Shift + Tab) or `Control.grab_focus` still enters edit mode (for compatibility).
		`LineEdit` features many built-in shortcuts that are always available (Ctrl here maps to Cmd on macOS):
		- Ctrl + C: Copy
		- Ctrl + X: Cut
		- Ctrl + V or Ctrl + Y: Paste/"yank"
		- Ctrl + Z: Undo
		- Ctrl + ~: Swap input direction.
		- Ctrl + Shift + Z: Redo
		- Ctrl + U: Delete text from the caret position to the beginning of the line
		- Ctrl + K: Delete text from the caret position to the end of the line
		- Ctrl + A: Select all text
		- Up Arrow/Down Arrow: Move the caret to the beginning/end of the line
		On macOS, some extra keyboard shortcuts are available:
		- Cmd + F: Same as Right Arrow, move the caret one character right
		- Cmd + B: Same as Left Arrow, move the caret one character left
		- Cmd + P: Same as Up Arrow, move the caret to the previous line
		- Cmd + N: Same as Down Arrow, move the caret to the next line
		- Cmd + D: Same as Delete, delete the character on the right side of caret
		- Cmd + H: Same as Backspace, delete the character on the left side of the caret
		- Cmd + A: Same as Home, move the caret to the beginning of the line
		- Cmd + E: Same as End, move the caret to the end of the line
		- Cmd + Left Arrow: Same as Home, move the caret to the beginning of the line
		- Cmd + Right Arrow: Same as End, move the caret to the end of the line
		**Note:** Caret movement shortcuts listed above are not affected by `shortcut_keys_enabled`.

## 属性

- **`alignment`** `int` = `0` · 枚举 `HorizontalAlignment`
  - 其它属性：getter=get_horizontal_alignment · setter=set_horizontal_alignment
- **`backspace_deletes_composite_character_enabled`** `bool` = `false`
  - 其它属性：getter=is_backspace_deletes_composite_character_enabled · setter=set_backspace_deletes_composite_character_enabled
- **`caret_blink`** `bool` = `false`
  - 其它属性：getter=is_caret_blink_enabled · setter=set_caret_blink_enabled
- **`caret_blink_interval`** `float` = `0.65`
  - 其它属性：getter=get_caret_blink_interval · setter=set_caret_blink_interval
- **`caret_column`** `int` = `0`
  - 其它属性：getter=get_caret_column · setter=set_caret_column
- **`caret_force_displayed`** `bool` = `false`
  - 其它属性：getter=is_caret_force_displayed · setter=set_caret_force_displayed
- **`caret_mid_grapheme`** `bool` = `false`
  - 其它属性：getter=is_caret_mid_grapheme_enabled · setter=set_caret_mid_grapheme_enabled
- **`clear_button_enabled`** `bool` = `false`
  - 其它属性：getter=is_clear_button_enabled · setter=set_clear_button_enabled
- **`context_menu_enabled`** `bool` = `true`
  - 其它属性：getter=is_context_menu_enabled · setter=set_context_menu_enabled
- **`deselect_on_focus_loss_enabled`** `bool` = `true`
  - 其它属性：getter=is_deselect_on_focus_loss_enabled · setter=set_deselect_on_focus_loss_enabled
- **`drag_and_drop_selection_enabled`** `bool` = `true`
  - 其它属性：getter=is_drag_and_drop_selection_enabled · setter=set_drag_and_drop_selection_enabled
- **`draw_control_chars`** `bool` = `false`
  - 其它属性：getter=get_draw_control_chars · setter=set_draw_control_chars
- **`editable`** `bool` = `true`
  - 其它属性：getter=is_editable · keywords=readonly, disabled, enabled · setter=set_editable
- **`emoji_menu_enabled`** `bool` = `true`
  - 其它属性：getter=is_emoji_menu_enabled · setter=set_emoji_menu_enabled
- **`expand_to_text_length`** `bool` = `false`
  - 其它属性：getter=is_expand_to_text_length_enabled · setter=set_expand_to_text_length_enabled
- **`flat`** `bool` = `false`
  - 其它属性：getter=is_flat · setter=set_flat
- **`focus_mode`** `int` = `2` · 枚举 `Control.FocusMode`
  - 其它属性：getter=get_focus_mode · overrides=Control · setter=set_focus_mode
- **`icon_expand_mode`** `int` = `0` · 枚举 `LineEdit.ExpandMode`
  - 其它属性：getter=get_icon_expand_mode · setter=set_icon_expand_mode
- **`keep_editing_on_text_submit`** `bool` = `false`
  - 其它属性：getter=is_editing_kept_on_text_submit · setter=set_keep_editing_on_text_submit
- **`language`** `String` = `""`
  - 其它属性：getter=get_language · setter=set_language
- **`max_length`** `int` = `0`
  - 其它属性：getter=get_max_length · setter=set_max_length
- **`middle_mouse_paste_enabled`** `bool` = `true`
  - 其它属性：getter=is_middle_mouse_paste_enabled · setter=set_middle_mouse_paste_enabled
- **`mouse_default_cursor_shape`** `int` = `1` · 枚举 `Control.CursorShape`
  - 其它属性：getter=get_default_cursor_shape · overrides=Control · setter=set_default_cursor_shape
- **`placeholder_text`** `String` = `""`
  - 其它属性：getter=get_placeholder · setter=set_placeholder
- **`right_icon`** `Texture2D`
  - 其它属性：getter=get_right_icon · setter=set_right_icon
- **`right_icon_scale`** `float` = `1.0`
  - 其它属性：getter=get_right_icon_scale · setter=set_right_icon_scale
- **`secret`** `bool` = `false`
  - 其它属性：getter=is_secret · setter=set_secret
- **`secret_character`** `String` = `"•"`
  - 其它属性：getter=get_secret_character · setter=set_secret_character
- **`select_all_on_focus`** `bool` = `false`
  - 其它属性：getter=is_select_all_on_focus · setter=set_select_all_on_focus
- **`selecting_enabled`** `bool` = `true`
  - 其它属性：getter=is_selecting_enabled · setter=set_selecting_enabled
- **`shortcut_keys_enabled`** `bool` = `true`
  - 其它属性：getter=is_shortcut_keys_enabled · setter=set_shortcut_keys_enabled
- **`structured_text_bidi_override`** `int` = `0` · 枚举 `TextServer.StructuredTextParser`
  - 其它属性：getter=get_structured_text_bidi_override · setter=set_structured_text_bidi_override
- **`structured_text_bidi_override_options`** `Array` = `[]`
  - 其它属性：getter=get_structured_text_bidi_override_options · setter=set_structured_text_bidi_override_options
- **`text`** `String` = `""`
  - 其它属性：getter=get_text · setter=set_text
- **`text_direction`** `int` = `0` · 枚举 `Control.TextDirection`
  - 其它属性：getter=get_text_direction · setter=set_text_direction
- **`virtual_keyboard_enabled`** `bool` = `true`
  - 其它属性：getter=is_virtual_keyboard_enabled · setter=set_virtual_keyboard_enabled
- **`virtual_keyboard_show_on_focus`** `bool` = `true`
  - 其它属性：getter=get_virtual_keyboard_show_on_focus · setter=set_virtual_keyboard_show_on_focus
- **`virtual_keyboard_type`** `int` = `0` · 枚举 `LineEdit.VirtualKeyboardType`
  - 其它属性：getter=get_virtual_keyboard_type · setter=set_virtual_keyboard_type

## 方法

### `apply_ime() -> void`

Applies text from the Input Method Editor (https://en.wikipedia.org/wiki/Input_method) (IME) and closes the IME if it is open.

### `cancel_ime() -> void`

Closes the Input Method Editor (https://en.wikipedia.org/wiki/Input_method) (IME) if it is open. Any text in the IME will be lost.

### `clear() -> void`

Erases the `LineEdit`'s `text`.

### `delete_char_at_caret() -> void`

Deletes one character at the caret's current position (equivalent to pressing Delete).

### `delete_text(from_column: int, to_column: int) -> void`

Deletes a section of the `text` going from position `from_column` to `to_column`. Both parameters should be within the text's length.

### `deselect() -> void`

Clears the current selection.

### `edit(hide_focus: bool = false) -> void`

Allows entering edit mode whether the `LineEdit` is focused or not. If `hide_focus` is `true`, the focused state will not be shown (see `Control.grab_focus`).
				See also `keep_editing_on_text_submit`.

### `get_menu() -> PopupMenu`
- 限定：qualifiers=const

Returns the `PopupMenu` of this `LineEdit`. By default, this menu is displayed when right-clicking on the `LineEdit`.
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
					menu.ItemCount = menu.GetItemIndex(LineEdit.MenuItems.Redo) + 1;
					// Add custom items.
					menu.AddSeparator();
					menu.AddItem("Insert Date", LineEdit.MenuItems.Max + 1);
					// Add event handler.
					menu.IdPressed += OnItemPressed;
				}

				public void OnItemPressed(int id)
				{
					if (id == LineEdit.MenuItems.Max + 1)
					{
						InsertTextAtCaret(Time.GetDateStringFromSystem());
					}
				}
				
				
				**Warning:** This is a required internal node, removing and freeing it may cause a crash. If you wish to hide it or any of its children, use their `Window.visible` property.

### `get_next_composite_character_column(column: int) -> int`
- 限定：qualifiers=const

Returns the correct column at the end of a composite character like ❤️‍🩹 (mending heart; Unicode: `U+2764 U+FE0F U+200D U+1FA79`) which is comprised of more than one Unicode code point, if the caret is at the start of the composite character. Also returns the correct column with the caret at mid grapheme and for non-composite characters.
				**Note:** To check at caret location use `get_next_composite_character_column(get_caret_column())`

### `get_previous_composite_character_column(column: int) -> int`
- 限定：qualifiers=const

Returns the correct column at the start of a composite character like ❤️‍🩹 (mending heart; Unicode: `U+2764 U+FE0F U+200D U+1FA79`) which is comprised of more than one Unicode code point, if the caret is at the end of the composite character. Also returns the correct column with the caret at mid grapheme and for non-composite characters.
				**Note:** To check at caret location use `get_previous_composite_character_column(get_caret_column())`

### `get_scroll_offset() -> float`
- 限定：qualifiers=const

Returns the scroll offset due to `caret_column`, as a number of characters.

### `get_selected_text() -> String`

Returns the text inside the selection.

### `get_selection_from_column() -> int`
- 限定：qualifiers=const

Returns the selection begin column.

### `get_selection_to_column() -> int`
- 限定：qualifiers=const

Returns the selection end column.

### `has_ime_text() -> bool`
- 限定：qualifiers=const

Returns `true` if the user has text in the Input Method Editor (https://en.wikipedia.org/wiki/Input_method) (IME).

### `has_redo() -> bool`
- 限定：qualifiers=const

Returns `true` if a "redo" action is available.

### `has_selection() -> bool`
- 限定：qualifiers=const

Returns `true` if the user has selected text.

### `has_undo() -> bool`
- 限定：qualifiers=const

Returns `true` if an "undo" action is available.

### `insert_text_at_caret(text: String) -> void`

Inserts `text` at the caret. If the resulting value is longer than `max_length`, nothing happens.

### `is_editing() -> bool`
- 限定：qualifiers=const

Returns whether the `LineEdit` is being edited.

### `is_menu_visible() -> bool`
- 限定：qualifiers=const

Returns whether the menu is visible. Use this instead of `get_menu().visible` to improve performance (so the creation of the menu is avoided).

### `menu_option(option: int) -> void`

Executes a given action as defined in the `MenuItems` enum.

### `select(from: int = 0, to: int = -1) -> void`

Selects characters inside `LineEdit` between `from` and `to`. By default, `from` is at the beginning and `to` at the end.
				`codeblocks`
				`gdscript`
				text = "Welcome"
				select() # Will select "Welcome".
				select(4) # Will select "ome".
				select(2, 5) # Will select "lco".
				
				`csharp`
				Text = "Welcome";
				Select(); // Will select "Welcome".
				Select(4); // Will select "ome".
				Select(2, 5); // Will select "lco".

### `select_all() -> void`

Selects the whole `String`.

### `unedit() -> void`

Allows exiting edit mode while preserving focus.

## 信号

### `editing_toggled(toggled_on: bool)`

Emitted when the `LineEdit` switches in or out of edit mode.

### `text_change_rejected(rejected_substring: String)`

Emitted when appending text that overflows the `max_length`. The appended text is truncated to fit `max_length`, and the part that couldn't fit is passed as the `rejected_substring` argument.

### `text_changed(new_text: String)`

Emitted when the text changes.

### `text_submitted(new_text: String)`

Emitted when the user presses the `ui_text_submit` action (by default: Enter or Kp Enter) while the `LineEdit` has focus.

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

### `VirtualKeyboardType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `KEYBOARD_TYPE_DEFAULT` |  |
| `1` | `KEYBOARD_TYPE_MULTILINE` |  |
| `2` | `KEYBOARD_TYPE_NUMBER` |  |
| `3` | `KEYBOARD_TYPE_NUMBER_DECIMAL` |  |
| `4` | `KEYBOARD_TYPE_PHONE` |  |
| `5` | `KEYBOARD_TYPE_EMAIL_ADDRESS` |  |
| `6` | `KEYBOARD_TYPE_PASSWORD` |  |
| `7` | `KEYBOARD_TYPE_URL` |  |

### `ExpandMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `EXPAND_MODE_ORIGINAL_SIZE` |  |
| `1` | `EXPAND_MODE_FIT_TO_TEXT` |  |
| `2` | `EXPAND_MODE_FIT_TO_LINE_EDIT` |  |

## 主题属性

### `caret_color`
- data_type=color · default=Color(0.95, 0.95, 0.95, 1) · type=Color

### `clear_button_color`
- data_type=color · default=Color(0.875, 0.875, 0.875, 1) · type=Color

### `clear_button_color_pressed`
- data_type=color · default=Color(1, 1, 1, 1) · type=Color

### `font_color`
- data_type=color · default=Color(0.875, 0.875, 0.875, 1) · type=Color

### `font_outline_color`
- data_type=color · default=Color(0, 0, 0, 1) · type=Color

### `font_placeholder_color`
- data_type=color · default=Color(0.875, 0.875, 0.875, 0.6) · type=Color

### `font_selected_color`
- data_type=color · default=Color(1, 1, 1, 1) · type=Color

### `font_uneditable_color`
- data_type=color · default=Color(0.875, 0.875, 0.875, 0.5) · type=Color

### `selection_color`
- data_type=color · default=Color(0.5, 0.5, 0.5, 1) · type=Color

### `caret_width`
- data_type=constant · default=1 · type=int

### `minimum_character_width`
- data_type=constant · default=4 · type=int

### `outline_size`
- data_type=constant · default=0 · type=int

### `font`
- data_type=font · type=Font

### `font_size`
- data_type=font_size · type=int

### `clear`
- data_type=icon · type=Texture2D

### `focus`
- data_type=style · type=StyleBox

### `normal`
- data_type=style · type=StyleBox

### `read_only`
- data_type=style · keywords=enabled, disabled, editable · type=StyleBox

