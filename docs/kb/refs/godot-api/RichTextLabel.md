# RichTextLabel

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`RichTextLabel` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/RichTextLabel.md`

**摘要**：A control for displaying text that can contain different font styles, images, and basic formatting.

## 描述

A control for displaying text that can contain custom fonts, images, and basic formatting. `RichTextLabel` manages these as an internal tag stack. It also adapts itself to given width/heights.
		**Note:** `newline`, `push_paragraph`, `"\n"`, `"\r\n"`, `p` tag, and alignment tags start a new paragraph. Each paragraph is processed independently, in its own BiDi context. If you want to force line wrapping within paragraph, any other line breaking character can be used, for example, Form Feed (U+000C), Next Line (U+0085), Line Separator (U+2028).
		**Note:** Assignments to `text` clear the tag stack and reconstruct it from the property's contents. Any edits made to `text` will erase previous edits made from other manual sources such as `append_text` and the `push_*` / `pop` methods.
		**Note:** RichTextLabel doesn't support entangled BBCode tags. For example, instead of using `skip-lint`**bold*bold italic**italic*, use `skip-lint`**bold*bold italic****italic*.
		**Note:** `push_*/pop_*` functions won't affect BBCode.
		**Note:** While `bbcode_enabled` is enabled, alignment tags such as `skip-lint``center` will take priority over the `horizontal_alignment` setting which determines the default text alignment.

## 属性

- **`autowrap_mode`** `int` = `3` · 枚举 `TextServer.AutowrapMode`
  - 其它属性：getter=get_autowrap_mode · setter=set_autowrap_mode
- **`autowrap_trim_flags`** `int` = `192` · 枚举 `TextServer.LineBreakFlag` · 位标志
  - 其它属性：getter=get_autowrap_trim_flags · is_bitfield=true · setter=set_autowrap_trim_flags
- **`bbcode_enabled`** `bool` = `false`
  - 其它属性：getter=is_using_bbcode · setter=set_use_bbcode
- **`clip_contents`** `bool` = `true`
  - 其它属性：getter=is_clipping_contents · overrides=Control · setter=set_clip_contents
- **`context_menu_enabled`** `bool` = `false`
  - 其它属性：getter=is_context_menu_enabled · setter=set_context_menu_enabled
- **`custom_effects`** `Array` = `[]`
  - 其它属性：getter=get_effects · setter=set_effects
- **`deselect_on_focus_loss_enabled`** `bool` = `true`
  - 其它属性：getter=is_deselect_on_focus_loss_enabled · setter=set_deselect_on_focus_loss_enabled
- **`drag_and_drop_selection_enabled`** `bool` = `true`
  - 其它属性：getter=is_drag_and_drop_selection_enabled · setter=set_drag_and_drop_selection_enabled
- **`fit_content`** `bool` = `false`
  - 其它属性：getter=is_fit_content_enabled · setter=set_fit_content
- **`focus_mode`** `int` = `3` · 枚举 `Control.FocusMode`
  - 其它属性：getter=get_focus_mode · overrides=Control · setter=set_focus_mode
- **`hint_underlined`** `bool` = `true`
  - 其它属性：getter=is_hint_underlined · setter=set_hint_underline
- **`horizontal_alignment`** `int` = `0` · 枚举 `HorizontalAlignment`
  - 其它属性：getter=get_horizontal_alignment · setter=set_horizontal_alignment
- **`justification_flags`** `int` = `163` · 枚举 `TextServer.JustificationFlag` · 位标志
  - 其它属性：getter=get_justification_flags · is_bitfield=true · setter=set_justification_flags
- **`language`** `String` = `""`
  - 其它属性：getter=get_language · setter=set_language
- **`meta_underlined`** `bool` = `true`
  - 其它属性：getter=is_meta_underlined · keywords=url_underlined · setter=set_meta_underline
- **`progress_bar_delay`** `int` = `1000`
  - 其它属性：getter=get_progress_bar_delay · setter=set_progress_bar_delay
- **`scroll_active`** `bool` = `true`
  - 其它属性：getter=is_scroll_active · setter=set_scroll_active
- **`scroll_following`** `bool` = `false`
  - 其它属性：getter=is_scroll_following · setter=set_scroll_follow
- **`scroll_following_visible_characters`** `bool` = `false`
  - 其它属性：getter=is_scroll_following_visible_characters · setter=set_scroll_follow_visible_characters
- **`selection_enabled`** `bool` = `false`
  - 其它属性：getter=is_selection_enabled · setter=set_selection_enabled
- **`shortcut_keys_enabled`** `bool` = `true`
  - 其它属性：getter=is_shortcut_keys_enabled · setter=set_shortcut_keys_enabled
- **`structured_text_bidi_override`** `int` = `0` · 枚举 `TextServer.StructuredTextParser`
  - 其它属性：getter=get_structured_text_bidi_override · setter=set_structured_text_bidi_override
- **`structured_text_bidi_override_options`** `Array` = `[]`
  - 其它属性：getter=get_structured_text_bidi_override_options · setter=set_structured_text_bidi_override_options
- **`tab_size`** `int` = `4`
  - 其它属性：getter=get_tab_size · setter=set_tab_size
- **`tab_stops`** `PackedFloat32Array` = `PackedFloat32Array()`
  - 其它属性：getter=get_tab_stops · setter=set_tab_stops
- **`text`** `String` = `""`
  - 其它属性：getter=get_text · setter=set_text
- **`text_direction`** `int` = `0` · 枚举 `Control.TextDirection`
  - 其它属性：getter=get_text_direction · setter=set_text_direction
- **`threaded`** `bool` = `false`
  - 其它属性：getter=is_threaded · setter=set_threaded
- **`vertical_alignment`** `int` = `0` · 枚举 `VerticalAlignment`
  - 其它属性：getter=get_vertical_alignment · setter=set_vertical_alignment
- **`visible_characters`** `int` = `-1`
  - 其它属性：getter=get_visible_characters · setter=set_visible_characters
- **`visible_characters_behavior`** `int` = `0` · 枚举 `TextServer.VisibleCharactersBehavior`
  - 其它属性：getter=get_visible_characters_behavior · setter=set_visible_characters_behavior
- **`visible_ratio`** `float` = `1.0`
  - 其它属性：getter=get_visible_ratio · setter=set_visible_ratio

## 方法

### `add_hr(width: int = 90, height: int = 2, color: Color = Color(1, 1, 1, 1), alignment: int = 1, width_in_percent: bool = true, height_in_percent: bool = false) -> void`

Adds a horizontal rule that can be used to separate content.
				If `width_in_percent` is set, `width` values are percentages of the control width instead of pixels.
				If `height_in_percent` is set, `height` values are percentages of the control width instead of pixels.

### `add_image(image: Texture2D, width: float = 0, height: float = 0, color: Color = Color(1, 1, 1, 1), inline_align: int = 5, region: Rect2 = Rect2(0, 0, 0, 0), key: Variant = null, pad: bool = false, tooltip: String = "", width_unit: int = 0, height_unit: int = 0, alt_text: String = "") -> void`

Adds an image's opening and closing tags to the tag stack, optionally providing a `width` and `height` to resize the image, a `color` to tint the image and a `region` to only use parts of the image.
				If `width` or `height` is set to 0, the image size will be adjusted in order to keep the original aspect ratio.
				If `width` and `height` are not set, but `region` is, the region's rect will be used.
				`key` is an optional identifier, that can be used to modify the image via `update_image`.
				If `pad` is set, and the image is smaller than the size specified by `width` and `height`, the image padding is added to match the size instead of upscaling.
				Parameters `width_unit` and `height_unit` determine the units used to calculate the image width and height, respectively.
				`alt_text` is used as the image description for assistive apps.

### `add_text(text: String) -> void`

Adds raw non-BBCode-parsed text to the tag stack.

### `append_text(bbcode: String) -> void`

Parses `bbcode` and adds tags to the tag stack as needed.
				**Note:** Using this method, you can't close a tag that was opened in a previous `append_text` call. This is done to improve performance, especially when updating large RichTextLabels since rebuilding the whole BBCode every time would be slower. If you absolutely need to close a tag in a future method call, append the `text` instead of using `append_text`.

### `clear() -> void`

Clears the tag stack, causing the label to display nothing.
				**Note:** This method does not affect `text`, and its contents will show again if the label is redrawn. However, setting `text` to an empty `String` also clears the stack.

### `deselect() -> void`

Clears the current selection.

### `get_character_line(character: int) -> int`

Returns the line number of the character position provided. Line and character numbers are both zero-indexed.
				**Note:** If `threaded` is enabled, this method returns a value for the loaded part of the document. Use `is_finished` or `finished` to determine whether document is fully loaded.

### `get_character_paragraph(character: int) -> int`

Returns the paragraph number of the character position provided. Paragraph and character numbers are both zero-indexed.
				**Note:** If `threaded` is enabled, this method returns a value for the loaded part of the document. Use `is_finished` or `finished` to determine whether document is fully loaded.

### `get_content_height() -> int`
- 限定：qualifiers=const

Returns the height of the content.
				**Note:** This method always returns the full content size, and is not affected by `visible_ratio` and `visible_characters`. To get the visible content size, use `get_visible_content_rect`.
				**Note:** If `threaded` is enabled, this method returns a value for the loaded part of the document. Use `is_finished` or `finished` to determine whether document is fully loaded.

### `get_content_width() -> int`
- 限定：qualifiers=const

Returns the width of the content.
				**Note:** This method always returns the full content size, and is not affected by `visible_ratio` and `visible_characters`. To get the visible content size, use `get_visible_content_rect`.
				**Note:** If `threaded` is enabled, this method returns a value for the loaded part of the document. Use `is_finished` or `finished` to determine whether document is fully loaded.

### `get_line_count() -> int`
- 限定：qualifiers=const

Returns the total number of lines in the text. Wrapped text is counted as multiple lines.
				**Note:** If `threaded` is enabled, this method returns a value for the loaded part of the document. Use `is_finished` or `finished` to determine whether document is fully loaded.

### `get_line_height(line: int) -> int`
- 限定：qualifiers=const

Returns the height of the line found at the provided index.
				**Note:** If `threaded` is enabled, this method returns a value for the loaded part of the document. Use `is_finished` or `finished` to determine whether the document is fully loaded.

### `get_line_offset(line: int) -> float`

Returns the vertical offset of the line found at the provided index.
				**Note:** If `threaded` is enabled, this method returns a value for the loaded part of the document. Use `is_finished` or `finished` to determine whether document is fully loaded.

### `get_line_range(line: int) -> Vector2i`

Returns the indexes of the first and last visible characters for the given `line`, as a `Vector2i`.
				**Note:** If `visible_characters_behavior` is set to `TextServer.VC_CHARS_BEFORE_SHAPING` only visible wrapped lines are counted.
				**Note:** If `threaded` is enabled, this method returns a value for the loaded part of the document. Use `is_finished` or `finished` to determine whether document is fully loaded.

### `get_line_width(line: int) -> int`
- 限定：qualifiers=const

Returns the width of the line found at the provided index.
				**Note:** If `threaded` is enabled, this method returns a value for the loaded part of the document. Use `is_finished` or `finished` to determine whether the document is fully loaded.

### `get_menu() -> PopupMenu`
- 限定：qualifiers=const

Returns the `PopupMenu` of this `RichTextLabel`. By default, this menu is displayed when right-clicking on the `RichTextLabel`.
				You can add custom menu items or remove standard ones. Make sure your IDs don't conflict with the standard ones (see `MenuItems`). For example:
				`codeblocks`
				`gdscript`
				func _ready():
					var menu = get_menu()
					# Remove "Select All" item.
					menu.remove_item(MENU_SELECT_ALL)
					# Add custom items.
					menu.add_separator()
					menu.add_item("Duplicate Text", MENU_MAX + 1)
					# Connect callback.
					menu.id_pressed.connect(_on_item_pressed)

				func _on_item_pressed(id):
					if id == MENU_MAX + 1:
						add_text("\n" + get_parsed_text())
				
				`csharp`
				public override void _Ready()
				{
					var menu = GetMenu();
					// Remove "Select All" item.
					menu.RemoveItem(RichTextLabel.MenuItems.SelectAll);
					// Add custom items.
					menu.AddSeparator();
					menu.AddItem("Duplicate Text", RichTextLabel.MenuItems.Max + 1);
					// Add event handler.
					menu.IdPressed += OnItemPressed;
				}

				public void OnItemPressed(int id)
				{
					if (id == TextEdit.MenuItems.Max + 1)
					{
						AddText("\n" + GetParsedText());
					}
				}
				
				
				**Warning:** This is a required internal node, removing and freeing it may cause a crash. If you wish to hide it or any of its children, use their `Window.visible` property.

### `get_paragraph_count() -> int`
- 限定：qualifiers=const

Returns the total number of paragraphs (newlines or `p` tags in the tag stack's text tags). Considers wrapped text as one paragraph.

### `get_paragraph_offset(paragraph: int) -> float`

Returns the vertical offset of the paragraph found at the provided index.
				**Note:** If `threaded` is enabled, this method returns a value for the loaded part of the document. Use `is_finished` or `finished` to determine whether document is fully loaded.

### `get_parsed_text() -> String`
- 限定：qualifiers=const

Returns the text without BBCode mark-up.

### `get_selected_text() -> String`
- 限定：qualifiers=const

Returns the current selection text. Does not include BBCodes.

### `get_selection_from() -> int`
- 限定：qualifiers=const

Returns the current selection first character index if a selection is active, `-1` otherwise. Does not include BBCodes.

### `get_selection_line_offset() -> float`
- 限定：qualifiers=const

Returns the current selection vertical line offset if a selection is active, `-1.0` otherwise.

### `get_selection_to() -> int`
- 限定：qualifiers=const

Returns the current selection last character index if a selection is active, `-1` otherwise. Does not include BBCodes.

### `get_total_character_count() -> int`
- 限定：qualifiers=const

Returns the total number of characters from text tags. Does not include BBCodes.

### `get_v_scroll_bar() -> VScrollBar`

Returns the vertical scrollbar.
				**Warning:** This is a required internal node, removing and freeing it may cause a crash. If you wish to hide it or any of its children, use their `CanvasItem.visible` property.

### `get_visible_content_rect() -> Rect2i`
- 限定：qualifiers=const

Returns the bounding rectangle of the visible content.
				**Note:** This method returns a correct value only after the label has been drawn.
				`codeblocks`
				`gdscript`
				extends RichTextLabel

				@export var background_panel: Panel

				func _ready():
					await draw
					background_panel.position = get_visible_content_rect().position
					background_panel.size = get_visible_content_rect().size
				
				`csharp`
				public partial class TestLabel : RichTextLabel
				{
					`Export`
					public Panel BackgroundPanel { get; set; }

					public override async void _Ready()
					{
						await ToSignal(this, Control.SignalName.Draw);
						BackgroundGPanel.Position = GetVisibleContentRect().Position;
						BackgroundPanel.Size = GetVisibleContentRect().Size;
					}
				}

### `get_visible_line_count() -> int`
- 限定：qualifiers=const

Returns the number of visible lines.
				**Note:** This method returns a correct value only after the label has been drawn.
				**Note:** If `threaded` is enabled, this method returns a value for the loaded part of the document. Use `is_finished` or `finished` to determine whether document is fully loaded.

### `get_visible_paragraph_count() -> int`
- 限定：qualifiers=const

Returns the number of visible paragraphs. A paragraph is considered visible if at least one of its lines is visible.
				**Note:** This method returns a correct value only after the label has been drawn.
				**Note:** If `threaded` is enabled, this method returns a value for the loaded part of the document. Use `is_finished` or `finished` to determine whether document is fully loaded.

### `install_effect(effect: Variant) -> void`

Installs a custom effect. This can also be done in the Inspector through the `custom_effects` property. `effect` should be a valid `RichTextEffect`.
				**Example:** With the following script extending from `RichTextEffect`:
				
```gdscript
				# effect.gd
				class_name MyCustomEffect
				extends RichTextEffect

				var bbcode = "my_custom_effect"

				# ...
				
```

				The above effect can be installed in `RichTextLabel` from a script:
				
```gdscript
				# rich_text_label.gd
				extends RichTextLabel

				func _ready():
					install_effect(MyCustomEffect.new())

					# Alternatively, if not using `class_name` in the script that extends RichTextEffect:
					install_effect(preload("res://effect.gd").new())
				
```

### `invalidate_paragraph(paragraph: int) -> bool`

Invalidates `paragraph` and all subsequent paragraphs cache.

### `is_finished() -> bool`
- 限定：qualifiers=const

If `threaded` is enabled, returns `true` if the background thread has finished text processing, otherwise always return `true`.

### `is_menu_visible() -> bool`
- 限定：qualifiers=const

Returns whether the menu is visible. Use this instead of `get_menu().visible` to improve performance (so the creation of the menu is avoided).

### `is_ready() -> bool`
- 限定：deprecated=Use [method is_finished] instead. · qualifiers=const

If `threaded` is enabled, returns `true` if the background thread has finished text processing, otherwise always return `true`.

### `menu_option(option: int) -> void`

Executes a given action as defined in the `MenuItems` enum.

### `newline() -> void`

Adds a newline tag to the tag stack.

### `parse_bbcode(bbcode: String) -> void`

The assignment version of `append_text`. Clears the tag stack and inserts the new content.

### `parse_expressions_for_values(expressions: PackedStringArray) -> Dictionary`

Parses BBCode parameter `expressions` into a dictionary.

### `pop() -> void`

Terminates the current tag. Use after `push_*` methods to close BBCodes manually. Does not need to follow `add_*` methods.

### `pop_all() -> void`

Terminates all tags opened by `push_*` methods.

### `pop_context() -> void`

Terminates tags opened after the last `push_context` call (including context marker), or all tags if there's no context marker on the stack.

### `push_bgcolor(bgcolor: Color) -> void`

Adds a `skip-lint``bgcolor` tag to the tag stack.
				**Note:** The background color has padding applied by default, which is controlled using `text_highlight_h_padding` and `text_highlight_v_padding`. This can lead to overlapping highlights if background colors are placed on neighboring lines/columns, so consider setting those theme items to `0` if you want to avoid this.

### `push_bold() -> void`

Adds a `skip-lint``font` tag with a bold font to the tag stack. This is the same as adding a `skip-lint``b` tag if not currently in a `skip-lint``i` tag.

### `push_bold_italics() -> void`

Adds a `skip-lint``font` tag with a bold italics font to the tag stack.

### `push_cell() -> void`

Adds a `skip-lint``cell` tag to the tag stack. Must be inside a `skip-lint``table` tag. See `push_table` for details. Use `set_table_column_expand` to set column expansion ratio, `set_cell_border_color` to set cell border, `set_cell_row_background_color` to set cell background, `set_cell_size_override` to override cell size, and `set_cell_padding` to set padding.

### `push_color(color: Color) -> void`

Adds a `skip-lint``color` tag to the tag stack.

### `push_context() -> void`

Adds a context marker to the tag stack. See `pop_context`.

### `push_customfx(effect: RichTextEffect, env: Dictionary) -> void`

Adds a custom effect tag to the tag stack. The effect does not need to be in `custom_effects`. The environment is directly passed to the effect.

### `push_dropcap(string: String, font: Font, size: int, dropcap_margins: Rect2 = Rect2(0, 0, 0, 0), color: Color = Color(1, 1, 1, 1), outline_size: int = 0, outline_color: Color = Color(0, 0, 0, 0)) -> void`

Adds a `skip-lint``dropcap` tag to the tag stack. Drop cap (dropped capital) is a decorative element at the beginning of a paragraph that is larger than the rest of the text.

### `push_fgcolor(fgcolor: Color) -> void`

Adds a `skip-lint``fgcolor` tag to the tag stack.
				**Note:** The foreground color has padding applied by default, which is controlled using `text_highlight_h_padding` and `text_highlight_v_padding`. This can lead to overlapping highlights if foreground colors are placed on neighboring lines/columns, so consider setting those theme items to `0` if you want to avoid this.

### `push_font(font: Font, font_size: int = 0) -> void`

Adds a `skip-lint``font` tag to the tag stack. Overrides default fonts for its duration.
				Passing `0` to `font_size` will use the existing default font size.

### `push_font_size(font_size: int) -> void`

Adds a `skip-lint``font_size` tag to the tag stack. Overrides default font size for its duration.

### `push_hint(description: String) -> void`

Adds a `skip-lint``hint` tag to the tag stack. Same as BBCode `skip-lint`[hint=something]{text}.

### `push_indent(level: int) -> void`

Adds an `skip-lint``indent` tag to the tag stack. Multiplies `level` by current `tab_size` to determine new margin length.

### `push_italics() -> void`

Adds a `skip-lint``font` tag with an italics font to the tag stack. This is the same as adding an `skip-lint``i` tag if not currently in a `skip-lint``b` tag.

### `push_language(language: String) -> void`

Adds language code used for text shaping algorithm and Open-Type font features.

### `push_list(level: int, type: int, capitalize: bool, bullet: String = "•") -> void`

Adds `skip-lint``ol` or `skip-lint``ul` tag to the tag stack. Multiplies `level` by current `tab_size` to determine new margin length.

### `push_meta(data: Variant, underline_mode: int = 1, tooltip: String = "") -> void`
- 限定：keywords=push_url

Adds a meta tag to the tag stack. Similar to the BBCode `skip-lint`{text} (something), but supports non-`String` metadata types.
				If `meta_underlined` is `true`, meta tags display an underline. This behavior can be customized with `underline_mode`.
				**Note:** Meta tags do nothing by default when clicked. To assign behavior when clicked, connect `meta_clicked` to a function that is called when the meta tag is clicked.

### `push_mono() -> void`

Adds a `skip-lint``font` tag with a monospace font to the tag stack.

### `push_normal() -> void`

Adds a `skip-lint``font` tag with a normal font to the tag stack.

### `push_outline_color(color: Color) -> void`

Adds a `skip-lint``outline_color` tag to the tag stack. Adds text outline for its duration.

### `push_outline_size(outline_size: int) -> void`

Adds a `skip-lint``outline_size` tag to the tag stack. Overrides default text outline size for its duration.

### `push_paragraph(alignment: int, base_direction: int = 0, language: String = "", st_parser: int = 0, justification_flags: int = 163, tab_stops: PackedFloat32Array = PackedFloat32Array()) -> void`

Adds a `skip-lint``p` tag to the tag stack.

### `push_strikethrough(color: Color = Color(0, 0, 0, 0)) -> void`

Adds a `skip-lint``s` tag to the tag stack. If `color`'s alpha value is `0.0`, the current font's color with its alpha multiplied by `strikethrough_alpha` is used.

### `push_table(columns: int, inline_align: int = 0, align_to_row: int = -1, name: String = "") -> void`

Adds a `skip-lint`[table=columns,inline_align] tag to the tag stack. Use `set_table_column_expand` to set column expansion ratio. Use `push_cell` to add cells. `name` is used as the table name for assistive apps.

### `push_underline(color: Color = Color(0, 0, 0, 0)) -> void`

Adds a `skip-lint` tag to the tag stack. If `color`'s alpha value is `0.0`, the current font's color with its alpha multiplied by `underline_alpha` is used.

### `reload_effects() -> void`

Reloads custom effects. Useful when `custom_effects` is modified manually.

### `remove_paragraph(paragraph: int, no_invalidate: bool = false) -> bool`

Removes a paragraph of content from the label. Returns `true` if the paragraph exists.
				The `paragraph` argument is the index of the paragraph to remove, it can take values in the interval `[0, get_paragraph_count() - 1]`.
				If `no_invalidate` is set to `true`, cache for the subsequent paragraphs is not invalidated. Use it for faster updates if deleted paragraph is fully self-contained (have no unclosed tags), or this call is part of the complex edit operation and `invalidate_paragraph` will be called at the end of operation.

### `scroll_to_line(line: int) -> void`

Scrolls the window's top line to match `line`.

### `scroll_to_paragraph(paragraph: int) -> void`

Scrolls the window's top line to match first line of the `paragraph`.

### `scroll_to_selection() -> void`

Scrolls to the beginning of the current selection.

### `select_all() -> void`

Select all the text.
				If `selection_enabled` is `false`, no selection will occur.

### `set_cell_border_color(color: Color) -> void`

Sets color of a table cell border.

### `set_cell_padding(padding: Rect2) -> void`

Sets inner padding of a table cell.

### `set_cell_row_background_color(odd_row_bg: Color, even_row_bg: Color) -> void`

Sets color of a table cell. Separate colors for alternating rows can be specified.

### `set_cell_size_override(min_size: Vector2, max_size: Vector2) -> void`

Sets minimum and maximum size overrides for a table cell.

### `set_table_column_expand(column: int, expand: bool, ratio: int = 1, shrink: bool = true) -> void`

Edits the selected column's expansion options. If `expand` is `true`, the column expands in proportion to its expansion ratio versus the other columns' ratios.
				For example, 2 columns with ratios 3 and 4 plus 70 pixels in available width would expand 30 and 40 pixels, respectively.
				If `expand` is `false`, the column will not contribute to the total ratio.

### `set_table_column_name(column: int, name: String) -> void`

Sets table column name for assistive apps.

### `update_image(key: Variant, mask: int, image: Texture2D, width: float = 0, height: float = 0, color: Color = Color(1, 1, 1, 1), inline_align: int = 5, region: Rect2 = Rect2(0, 0, 0, 0), pad: bool = false, tooltip: String = "", width_unit: int = 0, height_unit: int = 0) -> void`

Updates the existing images with the key `key`. Only properties specified by `mask` bits are updated. See `add_image`.

## 信号

### `finished()`

Triggered when the document is fully loaded.
				**Note:** This can happen before the text is processed for drawing. Scrolling values may not be valid until the document is drawn for the first time after this signal.

### `meta_clicked(meta: Variant)`

Triggered when the user clicks on content between meta (URL) tags. If the meta is defined in BBCode, e.g. `skip-lint`Text ({"key": "value"}), then the parameter for this signal will always be a `String` type. If a particular type or an object is desired, the `push_meta` method must be used to manually insert the data into the tag stack. Alternatively, you can convert the `String` input to the desired type based on its contents (such as calling `JSON.parse` on it).
				For example, the following method can be connected to `meta_clicked` to open clicked URLs using the user's default web browser:
				`codeblocks`
				`gdscript`
				# This assumes RichTextLabel's `meta_clicked` signal was connected to
				# the function below using the signal connection dialog.
				func _richtextlabel_on_meta_clicked(meta):
					# `meta` is of Variant type, so convert it to a String to avoid script errors at run-time.
					OS.shell_open(str(meta))

### `meta_hover_ended(meta: Variant)`

Triggers when the mouse exits a meta tag.

### `meta_hover_started(meta: Variant)`

Triggers when the mouse enters a meta tag.

## 枚举

### `ListType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `LIST_NUMBERS` |  |
| `1` | `LIST_LETTERS` |  |
| `2` | `LIST_ROMAN` |  |
| `3` | `LIST_DOTS` |  |

### `MenuItems`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `MENU_COPY` |  |
| `1` | `MENU_SELECT_ALL` |  |
| `2` | `MENU_MAX` |  |

### `MetaUnderline`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `META_UNDERLINE_NEVER` |  |
| `1` | `META_UNDERLINE_ALWAYS` |  |
| `2` | `META_UNDERLINE_ON_HOVER` |  |

### `ImageUpdateMask`

| 值 | 名称 | 说明 |
|---|---|---|
| `1` | `UPDATE_TEXTURE` | （位标志） |
| `2` | `UPDATE_SIZE` | （位标志） |
| `4` | `UPDATE_COLOR` | （位标志） |
| `8` | `UPDATE_ALIGNMENT` | （位标志） |
| `16` | `UPDATE_REGION` | （位标志） |
| `32` | `UPDATE_PAD` | （位标志） |
| `64` | `UPDATE_TOOLTIP` | （位标志） |
| `128` | `UPDATE_WIDTH_UNIT` | （位标志） |

### `ImageUnit`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `IMAGE_UNIT_PIXEL` |  |
| `1` | `IMAGE_UNIT_PERCENT` |  |
| `2` | `IMAGE_UNIT_EM` |  |

## 主题属性

### `default_color`
- data_type=color · default=Color(1, 1, 1, 1) · type=Color

### `font_outline_color`
- data_type=color · default=Color(0, 0, 0, 1) · type=Color

### `font_selected_color`
- data_type=color · default=Color(0, 0, 0, 0) · type=Color

### `font_shadow_color`
- data_type=color · default=Color(0, 0, 0, 0) · type=Color

### `selection_color`
- data_type=color · default=Color(0.1, 0.1, 1, 0.8) · type=Color

### `table_border`
- data_type=color · default=Color(0, 0, 0, 0) · type=Color

### `table_even_row_bg`
- data_type=color · default=Color(0, 0, 0, 0) · type=Color

### `table_odd_row_bg`
- data_type=color · default=Color(0, 0, 0, 0) · type=Color

### `line_separation`
- data_type=constant · default=0 · type=int

### `outline_size`
- data_type=constant · default=0 · type=int

### `paragraph_separation`
- data_type=constant · default=0 · type=int

### `shadow_offset_x`
- data_type=constant · default=1 · type=int

### `shadow_offset_y`
- data_type=constant · default=1 · type=int

### `shadow_outline_size`
- data_type=constant · default=1 · type=int

### `strikethrough_alpha`
- data_type=constant · default=50 · type=int

### `table_h_separation`
- data_type=constant · default=3 · type=int

### `table_v_separation`
- data_type=constant · default=3 · type=int

### `text_highlight_h_padding`
- data_type=constant · default=3 · type=int

### `text_highlight_v_padding`
- data_type=constant · default=3 · type=int

### `underline_alpha`
- data_type=constant · default=50 · type=int

### `bold_font`
- data_type=font · type=Font

### `bold_italics_font`
- data_type=font · type=Font

### `italics_font`
- data_type=font · type=Font

### `mono_font`
- data_type=font · type=Font

### `normal_font`
- data_type=font · type=Font

### `bold_font_size`
- data_type=font_size · type=int

### `bold_italics_font_size`
- data_type=font_size · type=int

### `italics_font_size`
- data_type=font_size · type=int

### `mono_font_size`
- data_type=font_size · type=int

### `normal_font_size`
- data_type=font_size · type=int

### `horizontal_rule`
- data_type=icon · type=Texture2D

### `focus`
- data_type=style · type=StyleBox

### `normal`
- data_type=style · type=StyleBox

## 教程链接

- [BBCode in RichTextLabel](None)
- [Rich Text Label with BBCode Demo](None)
- [Operating System Testing Demo](None)

