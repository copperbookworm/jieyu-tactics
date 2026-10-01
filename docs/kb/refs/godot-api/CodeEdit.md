# CodeEdit

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`CodeEdit` → `TextEdit` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/CodeEdit.md`

**摘要**：A multiline text editor designed for editing code.

## 描述

CodeEdit is a specialized `TextEdit` designed for editing plain text code files. It has many features commonly found in code editors such as line numbers, line folding, code completion, indent management, and string/comment management.
		**Note:** Regardless of locale, `CodeEdit` will by default always use left-to-right text direction to correctly display source code.

## 属性

- **`auto_brace_completion_enabled`** `bool` = `false`
  - 其它属性：getter=is_auto_brace_completion_enabled · setter=set_auto_brace_completion_enabled
- **`auto_brace_completion_highlight_matching`** `bool` = `false`
  - 其它属性：getter=is_highlight_matching_braces_enabled · setter=set_highlight_matching_braces_enabled
- **`auto_brace_completion_pairs`** `Dictionary` = `{ "\"": "\"", "'": "'", "(": ")", "[": "]", "{": "}" }`
  - 其它属性：getter=get_auto_brace_completion_pairs · setter=set_auto_brace_completion_pairs
- **`code_completion_enabled`** `bool` = `false`
  - 其它属性：getter=is_code_completion_enabled · setter=set_code_completion_enabled
- **`code_completion_prefixes`** `String[]` = `[]`
  - 其它属性：getter=get_code_completion_prefixes · setter=set_code_completion_prefixes
- **`delimiter_comments`** `String[]` = `[]`
  - 其它属性：getter=get_comment_delimiters · setter=set_comment_delimiters
- **`delimiter_strings`** `String[]` = `["' '", "\" \""]`
  - 其它属性：getter=get_string_delimiters · setter=set_string_delimiters
- **`gutters_draw_bookmarks`** `bool` = `false`
  - 其它属性：getter=is_drawing_bookmarks_gutter · setter=set_draw_bookmarks_gutter
- **`gutters_draw_breakpoints_gutter`** `bool` = `false`
  - 其它属性：getter=is_drawing_breakpoints_gutter · setter=set_draw_breakpoints_gutter
- **`gutters_draw_executing_lines`** `bool` = `false`
  - 其它属性：getter=is_drawing_executing_lines_gutter · setter=set_draw_executing_lines_gutter
- **`gutters_draw_fold_gutter`** `bool` = `false`
  - 其它属性：getter=is_drawing_fold_gutter · setter=set_draw_fold_gutter
- **`gutters_draw_line_numbers`** `bool` = `false`
  - 其它属性：getter=is_draw_line_numbers_enabled · setter=set_draw_line_numbers
- **`gutters_line_numbers_min_digits`** `int` = `3`
  - 其它属性：getter=get_line_numbers_min_digits · setter=set_line_numbers_min_digits
- **`gutters_zero_pad_line_numbers`** `bool` = `false`
  - 其它属性：getter=is_line_numbers_zero_padded · setter=set_line_numbers_zero_padded
- **`indent_automatic`** `bool` = `false`
  - 其它属性：getter=is_auto_indent_enabled · setter=set_auto_indent_enabled
- **`indent_automatic_prefixes`** `String[]` = `[":", "{", "[", "("]`
  - 其它属性：getter=get_auto_indent_prefixes · setter=set_auto_indent_prefixes
- **`indent_size`** `int` = `4`
  - 其它属性：getter=get_indent_size · setter=set_indent_size
- **`indent_use_spaces`** `bool` = `false`
  - 其它属性：getter=is_indent_using_spaces · setter=set_indent_using_spaces
- **`layout_direction`** `int` = `2` · 枚举 `Control.LayoutDirection`
  - 其它属性：getter=get_layout_direction · overrides=Control · setter=set_layout_direction
- **`line_folding`** `bool` = `false`
  - 其它属性：getter=is_line_folding_enabled · setter=set_line_folding_enabled
- **`line_length_guidelines`** `int[]` = `[]`
  - 其它属性：getter=get_line_length_guidelines · setter=set_line_length_guidelines
- **`symbol_lookup_on_click`** `bool` = `false`
  - 其它属性：getter=is_symbol_lookup_on_click_enabled · setter=set_symbol_lookup_on_click_enabled
- **`symbol_tooltip_on_hover`** `bool` = `false`
  - 其它属性：getter=is_symbol_tooltip_on_hover_enabled · setter=set_symbol_tooltip_on_hover_enabled
- **`text_direction`** `int` = `1` · 枚举 `Control.TextDirection`
  - 其它属性：getter=get_text_direction · overrides=TextEdit · setter=set_text_direction

## 方法

### `_confirm_code_completion(replace: bool) -> void`
- 限定：qualifiers=virtual

Override this method to define how the selected entry should be inserted. If `replace` is `true`, any existing text should be replaced.

### `_filter_code_completion_candidates(candidates: Dictionary[]) -> Dictionary[]`
- 限定：qualifiers=virtual const

Override this method to define what items in `candidates` should be displayed.
				Both `candidates` and the return is an `Array` of `Dictionary`, see `get_code_completion_option` for `Dictionary` content.

### `_request_code_completion(force: bool) -> void`
- 限定：qualifiers=virtual

Override this method to define what happens when the user requests code completion. If `force` is `true`, any checks should be bypassed.

### `add_auto_brace_completion_pair(start_key: String, end_key: String) -> void`

Adds a brace pair.
				Both the start and end keys must be symbols. Only the start key has to be unique.

### `add_code_completion_option(type: int, display_text: String, insert_text: String, text_color: Color = Color(1, 1, 1, 1), icon: Resource = null, value: Variant = null, location: int = 1024) -> void`

Submits an item to the queue of potential candidates for the autocomplete menu. Call `update_code_completion_options` to update the list.
				`location` indicates location of the option relative to the location of the code completion query. See `CodeEdit.CodeCompletionLocation` for how to set this value.
				**Note:** This list will replace all current candidates.

### `add_comment_delimiter(start_key: String, end_key: String, line_only: bool = false) -> void`

Adds a comment delimiter from `start_key` to `end_key`. Both keys should be symbols, and `start_key` must not be shared with other delimiters.
				If `line_only` is `true` or `end_key` is an empty `String`, the region does not carry over to the next line.

### `add_string_delimiter(start_key: String, end_key: String, line_only: bool = false) -> void`

Defines a string delimiter from `start_key` to `end_key`. Both keys should be symbols, and `start_key` must not be shared with other delimiters.
				If `line_only` is `true` or `end_key` is an empty `String`, the region does not carry over to the next line.

### `can_fold_line(line: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the given line is foldable. A line is foldable if it is the start of a valid code region (see `get_code_region_start_tag`), if it is the start of a comment or string block, or if the next non-empty line is more indented (see `TextEdit.get_indent_level`).

### `cancel_code_completion() -> void`

Cancels the autocomplete menu.

### `clear_bookmarked_lines() -> void`

Clears all bookmarked lines.

### `clear_breakpointed_lines() -> void`

Clears all breakpointed lines.

### `clear_comment_delimiters() -> void`

Removes all comment delimiters.

### `clear_executing_lines() -> void`

Clears all executed lines.

### `clear_string_delimiters() -> void`

Removes all string delimiters.

### `confirm_code_completion(replace: bool = false) -> void`

Inserts the selected entry into the text. If `replace` is `true`, any existing text is replaced rather than merged.

### `convert_indent(from_line: int = -1, to_line: int = -1) -> void`

Converts the indents of lines between `from_line` and `to_line` to tabs or spaces as set by `indent_use_spaces`.
				Values of `-1` convert the entire text.

### `create_code_region() -> void`

Creates a new code region with the selection. At least one single line comment delimiter have to be defined (see `add_comment_delimiter`).
				A code region is a part of code that is highlighted when folded and can help organize your script.
				Code region start and end tags can be customized (see `set_code_region_tags`).
				Code regions are delimited using start and end tags (respectively `region` and `endregion` by default) preceded by one line comment delimiter. (eg. `#region` and `#endregion`)

### `delete_lines() -> void`

Deletes all lines that are selected or have a caret on them.

### `do_indent() -> void`

If there is no selection, indentation is inserted at the caret. Otherwise, the selected lines are indented like `indent_lines`. Equivalent to the `ProjectSettings.input/ui_text_indent` action. The indentation characters used depend on `indent_use_spaces` and `indent_size`.

### `duplicate_lines() -> void`

Duplicates all lines currently selected with any caret. Duplicates the entire line beneath the current one no matter where the caret is within the line.

### `duplicate_selection() -> void`

Duplicates all selected text and duplicates all lines with a caret on them.

### `fold_all_lines() -> void`

Folds all lines that are possible to be folded (see `can_fold_line`).

### `fold_line(line: int) -> void`

Folds the given line, if possible (see `can_fold_line`).

### `get_auto_brace_completion_close_key(open_key: String) -> String`
- 限定：qualifiers=const

Gets the matching auto brace close key for `open_key`.

### `get_bookmarked_lines() -> PackedInt32Array`
- 限定：qualifiers=const

Gets all bookmarked lines.

### `get_breakpointed_lines() -> PackedInt32Array`
- 限定：qualifiers=const

Gets all breakpointed lines.

### `get_code_completion_option(index: int) -> Dictionary`
- 限定：qualifiers=const

Gets the completion option at `index`. The return `Dictionary` has the following key-values:
				`kind`: `CodeCompletionKind`
				`display_text`: Text that is shown on the autocomplete menu.
				`insert_text`: Text that is to be inserted when this item is selected.
				`font_color`: Color of the text on the autocomplete menu.
				`icon`: Icon to draw on the autocomplete menu.
				`default_value`: Value of the symbol.

### `get_code_completion_options() -> Dictionary[]`
- 限定：qualifiers=const

Gets all completion options, see `get_code_completion_option` for return content.

### `get_code_completion_selected_index() -> int`
- 限定：qualifiers=const

Gets the index of the current selected completion option.

### `get_code_region_end_tag() -> String`
- 限定：qualifiers=const

Returns the code region end tag (without comment delimiter).

### `get_code_region_start_tag() -> String`
- 限定：qualifiers=const

Returns the code region start tag (without comment delimiter).

### `get_delimiter_end_key(delimiter_index: int) -> String`
- 限定：qualifiers=const

Gets the end key for a string or comment region index.

### `get_delimiter_end_position(line: int, column: int) -> Vector2`
- 限定：qualifiers=const

If `line` `column` is in a string or comment, returns the end position of the region. If not or no end could be found, both `Vector2` values will be `-1`.

### `get_delimiter_start_key(delimiter_index: int) -> String`
- 限定：qualifiers=const

Gets the start key for a string or comment region index.

### `get_delimiter_start_position(line: int, column: int) -> Vector2`
- 限定：qualifiers=const

If `line` `column` is in a string or comment, returns the start position of the region. If not or no start could be found, both `Vector2` values will be `-1`.

### `get_executing_lines() -> PackedInt32Array`
- 限定：qualifiers=const

Gets all executing lines.

### `get_folded_lines() -> int[]`
- 限定：qualifiers=const

Returns all lines that are currently folded.

### `get_text_for_code_completion() -> String`
- 限定：qualifiers=const

Returns the full text with char `0xFFFF` at the caret location.

### `get_text_for_symbol_lookup() -> String`
- 限定：qualifiers=const

Returns the full text with char `0xFFFF` at the cursor location.

### `get_text_with_cursor_char(line: int, column: int) -> String`
- 限定：qualifiers=const

Returns the full text with char `0xFFFF` at the specified location.

### `has_auto_brace_completion_close_key(close_key: String) -> bool`
- 限定：qualifiers=const

Returns `true` if close key `close_key` exists.

### `has_auto_brace_completion_open_key(open_key: String) -> bool`
- 限定：qualifiers=const

Returns `true` if open key `open_key` exists.

### `has_comment_delimiter(start_key: String) -> bool`
- 限定：qualifiers=const

Returns `true` if comment `start_key` exists.

### `has_string_delimiter(start_key: String) -> bool`
- 限定：qualifiers=const

Returns `true` if string `start_key` exists.

### `indent_lines() -> void`

Indents all lines that are selected or have a caret on them. Uses spaces or a tab depending on `indent_use_spaces`. See `unindent_lines`.

### `is_in_comment(line: int, column: int = -1) -> int`
- 限定：qualifiers=const

Returns delimiter index if `line` `column` is in a comment. If `column` is not provided, will return delimiter index if the entire `line` is a comment. Otherwise `-1`.

### `is_in_string(line: int, column: int = -1) -> int`
- 限定：qualifiers=const

Returns the delimiter index if `line` `column` is in a string. If `column` is not provided, will return the delimiter index if the entire `line` is a string. Otherwise `-1`.

### `is_line_bookmarked(line: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the given line is bookmarked. See `set_line_as_bookmarked`.

### `is_line_breakpointed(line: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the given line is breakpointed. See `set_line_as_breakpoint`.

### `is_line_code_region_end(line: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the given line is a code region end. See `set_code_region_tags`.

### `is_line_code_region_start(line: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the given line is a code region start. See `set_code_region_tags`.

### `is_line_executing(line: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the given line is marked as executing. See `set_line_as_executing`.

### `is_line_folded(line: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the given line is folded. See `fold_line`.

### `join_lines(line_ending: String = " ") -> void`

Joins all selected lines or lines containing a caret with their next line. Whitespace in between will be removed. If the next line has content, the `line_ending` will be inserted in between.

### `move_lines_down() -> void`

Moves all lines down that are selected or have a caret on them.

### `move_lines_up() -> void`

Moves all lines up that are selected or have a caret on them.

### `remove_comment_delimiter(start_key: String) -> void`

Removes the comment delimiter with `start_key`.

### `remove_string_delimiter(start_key: String) -> void`

Removes the string delimiter with `start_key`.

### `request_code_completion(force: bool = false) -> void`

Emits `code_completion_requested`, if `force` is `true` will bypass all checks. Otherwise will check that the caret is in a word or in front of a prefix. Will ignore the request if all current options are of type file path, node path, or signal.

### `set_code_completion_selected_index(index: int) -> void`

Sets the current selected completion option.

### `set_code_hint(code_hint: String) -> void`

Sets the code hint text. Pass an empty string to clear.

### `set_code_hint_draw_below(draw_below: bool) -> void`

If `true`, the code hint will draw below the main caret. If `false`, the code hint will draw above the main caret. See `set_code_hint`.

### `set_code_region_tags(start: String = "region", end: String = "endregion") -> void`

Sets the code region start and end tags (without comment delimiter).

### `set_line_as_bookmarked(line: int, bookmarked: bool) -> void`

Sets the given line as bookmarked. If `true` and `gutters_draw_bookmarks` is `true`, draws the `bookmark` icon in the gutter for this line. See `get_bookmarked_lines` and `is_line_bookmarked`.

### `set_line_as_breakpoint(line: int, breakpointed: bool) -> void`

Sets the given line as a breakpoint. If `true` and `gutters_draw_breakpoints_gutter` is `true`, draws the `breakpoint` icon in the gutter for this line. See `get_breakpointed_lines` and `is_line_breakpointed`.

### `set_line_as_executing(line: int, executing: bool) -> void`

Sets the given line as executing. If `true` and `gutters_draw_executing_lines` is `true`, draws the `executing_line` icon in the gutter for this line. See `get_executing_lines` and `is_line_executing`.

### `set_symbol_lookup_word_as_valid(valid: bool) -> void`

Sets the symbol emitted by `symbol_validate` as a valid lookup.

### `toggle_foldable_line(line: int) -> void`

Toggle the folding of the code block at the given line.

### `toggle_foldable_lines_at_carets() -> void`

Toggle the folding of the code block on all lines with a caret on them.

### `unfold_all_lines() -> void`

Unfolds all lines that are folded.

### `unfold_line(line: int) -> void`

Unfolds the given line if it is folded or if it is hidden under a folded line.

### `unindent_lines() -> void`

Unindents all lines that are selected or have a caret on them. Uses spaces or a tab depending on `indent_use_spaces`. Equivalent to the `ProjectSettings.input/ui_text_dedent` action. See `indent_lines`.

### `update_code_completion_options(force: bool) -> void`

Submits all completion options added with `add_code_completion_option`. Will try to force the autocomplete menu to popup, if `force` is `true`.
				**Note:** This will replace all current candidates.

## 信号

### `breakpoint_toggled(line: int)`

Emitted when a breakpoint is added or removed from a line. If the line is removed via backspace, a signal is emitted at the old line.

### `code_completion_requested()`

Emitted when the user requests code completion. This signal will not be sent if `_request_code_completion` is overridden or `code_completion_enabled` is `false`.

### `symbol_hovered(symbol: String, line: int, column: int)`

Emitted when the user hovers over a symbol. Unlike `Control.mouse_entered`, this signal is not emitted immediately, but when the cursor is over the symbol for `ProjectSettings.gui/timers/tooltip_delay_sec` seconds.
				**Note:** `symbol_tooltip_on_hover` must be `true` for this signal to be emitted.

### `symbol_lookup(symbol: String, line: int, column: int)`

Emitted when the user has clicked on a valid symbol.

### `symbol_validate(symbol: String)`

Emitted when the user hovers over a symbol. The symbol should be validated and responded to, by calling `set_symbol_lookup_word_as_valid`.
				**Note:** `symbol_lookup_on_click` must be `true` for this signal to be emitted.

## 枚举

### `CodeCompletionKind`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `KIND_CLASS` |  |
| `1` | `KIND_FUNCTION` |  |
| `2` | `KIND_SIGNAL` |  |
| `3` | `KIND_VARIABLE` |  |
| `4` | `KIND_MEMBER` |  |
| `5` | `KIND_ENUM` |  |
| `6` | `KIND_CONSTANT` |  |
| `7` | `KIND_NODE_PATH` |  |
| `8` | `KIND_FILE_PATH` |  |
| `9` | `KIND_PLAIN_TEXT` |  |
| `10` | `KIND_KEYWORD` |  |

### `CodeCompletionLocation`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `LOCATION_LOCAL` |  |
| `256` | `LOCATION_PARENT_MASK` |  |
| `512` | `LOCATION_OTHER_USER_CODE` |  |
| `1024` | `LOCATION_OTHER` |  |

## 主题属性

### `bookmark_color`
- data_type=color · default=Color(0.5, 0.64, 1, 0.8) · type=Color

### `brace_mismatch_color`
- data_type=color · default=Color(1, 0.2, 0.2, 1) · type=Color

### `breakpoint_color`
- data_type=color · default=Color(0.9, 0.29, 0.3, 1) · type=Color

### `code_folding_color`
- data_type=color · default=Color(0.8, 0.8, 0.8, 0.8) · type=Color

### `completion_background_color`
- data_type=color · default=Color(0.17, 0.16, 0.2, 1) · type=Color

### `completion_existing_color`
- data_type=color · default=Color(0.87, 0.87, 0.87, 0.13) · type=Color

### `completion_scroll_color`
- data_type=color · default=Color(1, 1, 1, 0.29) · type=Color

### `completion_scroll_hovered_color`
- data_type=color · default=Color(1, 1, 1, 0.4) · type=Color

### `completion_selected_color`
- data_type=color · default=Color(0.26, 0.26, 0.27, 1) · type=Color

### `executing_line_color`
- data_type=color · default=Color(0.98, 0.89, 0.27, 1) · type=Color

### `folded_code_region_color`
- data_type=color · default=Color(0.68, 0.46, 0.77, 0.2) · type=Color

### `line_length_guideline_color`
- data_type=color · default=Color(0.3, 0.5, 0.8, 0.1) · type=Color

### `line_number_color`
- data_type=color · default=Color(0.67, 0.67, 0.67, 0.4) · type=Color

### `completion_lines`
- data_type=constant · default=7 · type=int

### `completion_max_width`
- data_type=constant · default=50 · type=int

### `completion_scroll_width`
- data_type=constant · default=6 · type=int

### `bookmark`
- data_type=icon · type=Texture2D

### `breakpoint`
- data_type=icon · type=Texture2D

### `can_fold`
- data_type=icon · type=Texture2D

### `can_fold_code_region`
- data_type=icon · type=Texture2D

### `completion_color_bg`
- data_type=icon · type=Texture2D

### `executing_line`
- data_type=icon · type=Texture2D

### `folded`
- data_type=icon · type=Texture2D

### `folded_code_region`
- data_type=icon · type=Texture2D

### `folded_eol_icon`
- data_type=icon · type=Texture2D

### `completion`
- data_type=style · type=StyleBox

