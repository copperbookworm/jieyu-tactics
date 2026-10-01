# DisplayServer

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`DisplayServer` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/DisplayServer.md`

**摘要**：A server interface for low-level window management.

## 描述

`DisplayServer` handles everything related to window management. It is separated from `OS` as a single operating system may support multiple display servers.
		**Headless mode:** Starting the engine with the `--headless` command line argument ($DOCS_URL/tutorials/editor/command_line_tutorial.html) disables all rendering and window management functions. Most functions from `DisplayServer` will return dummy values in this case.

## 方法

### `accessibility_create_element(window_id: int, role: int) -> RID`
- 限定：deprecated=Use [AccessibilityServer] instead.

Creates a new, empty accessibility element resource.
				**Note:** An accessibility element is created and freed automatically for each `Node`. In general, this function should not be called manually.

### `accessibility_create_sub_element(parent_rid: RID, role: int, insert_pos: int = -1) -> RID`
- 限定：deprecated=Use [AccessibilityServer] instead.

Creates a new, empty accessibility sub-element resource. Sub-elements can be used to provide accessibility information for objects which are not `Node`s, such as list items, table cells, or menu items. Sub-elements are freed automatically when the parent element is freed, or can be freed early using the `accessibility_free_element` method.

### `accessibility_create_sub_text_edit_elements(parent_rid: RID, shaped_text: RID, min_height: float, insert_pos: int = -1, is_last_line: bool = false) -> RID`
- 限定：deprecated=Use [AccessibilityServer] instead.

Creates a new, empty accessibility sub-element from the shaped text buffer. Sub-elements are freed automatically when the parent element is freed, or can be freed early using the `accessibility_free_element` method.
				If `is_last_line` is `true`, no trailing newline is appended to the text content. Set to `true` for the last line in multi-line text fields and for single-line text fields.

### `accessibility_element_get_meta(id: RID) -> Variant`
- 限定：deprecated=Use [AccessibilityServer] instead. · qualifiers=const

Returns the metadata of the accessibility element `id`.

### `accessibility_element_set_meta(id: RID, meta: Variant) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets the metadata of the accessibility element `id` to `meta`.

### `accessibility_free_element(id: RID) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Frees the accessibility element `id` created by `accessibility_create_element`, `accessibility_create_sub_element`, or `accessibility_create_sub_text_edit_elements`.

### `accessibility_get_window_root(window_id: int) -> RID`
- 限定：deprecated=Use [AccessibilityServer] instead. · qualifiers=const

Returns the main accessibility element of the OS native window.

### `accessibility_has_element(id: RID) -> bool`
- 限定：deprecated=Use [AccessibilityServer] instead. · qualifiers=const

Returns `true` if `id` is a valid accessibility element.

### `accessibility_screen_reader_active() -> int`
- 限定：qualifiers=const

Returns `1` if a screen reader, Braille display or other assistive app is active, `0` otherwise. Returns `-1` if status is unknown.
				**Note:** This method is implemented on Linux, macOS, and Windows.
				**Note:** Accessibility debugging tools, such as Accessibility Insights for Windows, Accessibility Inspector (macOS), or AT-SPI Browser (Linux/BSD), do not count as assistive apps and will not affect this value. To test your project with these tools, set `ProjectSettings.accessibility/general/accessibility_support` to `1`.

### `accessibility_set_window_focused(window_id: int, focused: bool) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets the window focused state for assistive apps.
				**Note:** This method is implemented on Linux, macOS, and Windows.
				**Note:** Advanced users only! `Window` objects call this method automatically.

### `accessibility_set_window_rect(window_id: int, rect_out: Rect2, rect_in: Rect2) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets window outer (with decorations) and inner (without decorations) bounds for assistive apps.
				**Note:** This method is implemented on Linux, macOS, and Windows.
				**Note:** Advanced users only! `Window` objects call this method automatically.

### `accessibility_should_increase_contrast() -> int`
- 限定：qualifiers=const

Returns `1` if a high-contrast user interface theme should be used, `0` otherwise. Returns `-1` if status is unknown.
				**Note:** This method is implemented on Linux (X11/Wayland, GNOME), macOS, and Windows.

### `accessibility_should_reduce_animation() -> int`
- 限定：qualifiers=const

Returns `1` if flashing, blinking, and other moving content that can cause seizures in users with photosensitive epilepsy should be disabled, `0` otherwise. Returns `-1` if status is unknown.
				**Note:** This method is implemented on macOS and Windows.

### `accessibility_should_reduce_transparency() -> int`
- 限定：qualifiers=const

Returns `1` if background images, transparency, and other features that can reduce the contrast between the foreground and background should be disabled, `0` otherwise. Returns `-1` if status is unknown.
				**Note:** This method is implemented on macOS and Windows.

### `accessibility_update_add_action(id: RID, action: int, callable: Callable) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Adds a callback for the accessibility action (action which can be performed by using a special screen reader command or buttons on the Braille display), and marks this action as supported. The action callback receives one `Variant` argument, which value depends on action type.

### `accessibility_update_add_child(id: RID, child_id: RID) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Adds a child accessibility element.
				**Note:** `Node` children and sub-elements are added to the child list automatically.

### `accessibility_update_add_custom_action(id: RID, action_id: int, action_description: String) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Adds support for a custom accessibility action. `action_id` is passed as an argument to the callback of `ACTION_CUSTOM` action.

### `accessibility_update_add_related_controls(id: RID, related_id: RID) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Adds an element that is controlled by this element.

### `accessibility_update_add_related_described_by(id: RID, related_id: RID) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Adds an element that describes this element.

### `accessibility_update_add_related_details(id: RID, related_id: RID) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Adds an element that details this element.

### `accessibility_update_add_related_flow_to(id: RID, related_id: RID) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Adds an element that this element flow into.

### `accessibility_update_add_related_labeled_by(id: RID, related_id: RID) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Adds an element that labels this element.

### `accessibility_update_add_related_radio_group(id: RID, related_id: RID) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Adds an element that is part of the same radio group.
				**Note:** This method should be called on each element of the group, using all other elements as `related_id`.

### `accessibility_update_set_active_descendant(id: RID, other_id: RID) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Adds an element that is an active descendant of this element.

### `accessibility_update_set_background_color(id: RID, color: Color) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets element background color.

### `accessibility_update_set_bounds(id: RID, rect: Rect2) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets element bounding box, relative to the node position.

### `accessibility_update_set_checked(id: RID, checekd: bool) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets element checked state.

### `accessibility_update_set_classname(id: RID, classname: String) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets element class name.

### `accessibility_update_set_color_value(id: RID, color: Color) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets element color value.

### `accessibility_update_set_description(id: RID, description: String) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets element accessibility description.

### `accessibility_update_set_error_message(id: RID, other_id: RID) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets an element which contains an error message for this element.

### `accessibility_update_set_extra_info(id: RID, name: String) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets element accessibility extra information added to the element name.

### `accessibility_update_set_flag(id: RID, flag: int, value: bool) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets element flag.

### `accessibility_update_set_focus(id: RID) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets currently focused element.

### `accessibility_update_set_foreground_color(id: RID, color: Color) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets element foreground color.

### `accessibility_update_set_in_page_link_target(id: RID, other_id: RID) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets target element for the link.

### `accessibility_update_set_language(id: RID, language: String) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets element text language.

### `accessibility_update_set_list_item_count(id: RID, size: int) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets number of items in the list.

### `accessibility_update_set_list_item_expanded(id: RID, expanded: bool) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets list/tree item expanded status.

### `accessibility_update_set_list_item_index(id: RID, index: int) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets the position of the element in the list.

### `accessibility_update_set_list_item_level(id: RID, level: int) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets the hierarchical level of the element in the list.

### `accessibility_update_set_list_item_selected(id: RID, selected: bool) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets list/tree item selected status.

### `accessibility_update_set_list_orientation(id: RID, vertical: bool) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets the orientation of the list elements.

### `accessibility_update_set_live(id: RID, live: int) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets the priority of the live region updates.

### `accessibility_update_set_member_of(id: RID, group_id: RID) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets the element to be a member of the group.

### `accessibility_update_set_name(id: RID, name: String) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets element accessibility name.

### `accessibility_update_set_next_on_line(id: RID, other_id: RID) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets next element on the line.

### `accessibility_update_set_num_jump(id: RID, jump: float) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets numeric value jump.

### `accessibility_update_set_num_range(id: RID, min: float, max: float) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets numeric value range.

### `accessibility_update_set_num_step(id: RID, step: float) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets numeric value step.

### `accessibility_update_set_num_value(id: RID, position: float) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets numeric value.

### `accessibility_update_set_placeholder(id: RID, placeholder: String) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets placeholder text.

### `accessibility_update_set_popup_type(id: RID, popup: int) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets popup type for popup buttons.

### `accessibility_update_set_previous_on_line(id: RID, other_id: RID) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets previous element on the line.

### `accessibility_update_set_role(id: RID, role: int) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets element accessibility role.

### `accessibility_update_set_role_description(id: RID, description: String) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets element accessibility role description text.

### `accessibility_update_set_scroll_x(id: RID, position: float) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets scroll bar x position.

### `accessibility_update_set_scroll_x_range(id: RID, min: float, max: float) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets scroll bar x range.

### `accessibility_update_set_scroll_y(id: RID, position: float) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets scroll bar y position.

### `accessibility_update_set_scroll_y_range(id: RID, min: float, max: float) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets scroll bar y range.

### `accessibility_update_set_shortcut(id: RID, shortcut: String) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets the list of keyboard shortcuts used by element.

### `accessibility_update_set_state_description(id: RID, description: String) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets human-readable description of the current checked state.

### `accessibility_update_set_table_cell_position(id: RID, row_index: int, column_index: int) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets cell position in the table.

### `accessibility_update_set_table_cell_span(id: RID, row_span: int, column_span: int) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets cell row/column span.

### `accessibility_update_set_table_column_count(id: RID, count: int) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets number of columns in the table.

### `accessibility_update_set_table_column_index(id: RID, index: int) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets position of the column.

### `accessibility_update_set_table_row_count(id: RID, count: int) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets number of rows in the table.

### `accessibility_update_set_table_row_index(id: RID, index: int) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets position of the row in the table.

### `accessibility_update_set_text_align(id: RID, align: int) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets element text alignment.

### `accessibility_update_set_text_decorations(id: RID, underline: bool, strikethrough: bool, overline: bool) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets text underline/overline/strikethrough.

### `accessibility_update_set_text_orientation(id: RID, vertical: bool) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets text orientation.

### `accessibility_update_set_text_selection(id: RID, text_start_id: RID, start_char: int, text_end_id: RID, end_char: int) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets text selection to the text field. `text_start_id` and `text_end_id` should be elements created by `accessibility_create_sub_text_edit_elements`. Character offsets are relative to the corresponding element.

### `accessibility_update_set_tooltip(id: RID, tooltip: String) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets tooltip text.

### `accessibility_update_set_transform(id: RID, transform: Transform2D) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets element 2D transform.

### `accessibility_update_set_url(id: RID, url: String) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets link URL.

### `accessibility_update_set_value(id: RID, value: String) -> void`
- 限定：deprecated=Use [AccessibilityServer] instead.

Sets element text value.

### `beep() -> void`
- 限定：qualifiers=const

Plays the beep sound from the operative system, if possible. Because it comes from the OS, the beep sound will be audible even if the application is muted. It may also be disabled for the entire OS by the user.
				**Note:** This method is implemented on macOS, Linux (X11/Wayland), and Windows.

### `clipboard_get() -> String`
- 限定：qualifiers=const

Returns the user's clipboard as a string if possible.

### `clipboard_get_image() -> Image`
- 限定：qualifiers=const

Returns the user's clipboard as an image if possible.
				**Note:** This method uses the copied pixel data, e.g. from an image editing software or a web browser, not an image file copied from file explorer.

### `clipboard_get_primary() -> String`
- 限定：qualifiers=const

Returns the user's primary (https://unix.stackexchange.com/questions/139191/whats-the-difference-between-primary-selection-and-clipboard-buffer) clipboard as a string if possible. This is the clipboard that is set when the user selects text in any application, rather than when pressing Ctrl + C. The clipboard data can then be pasted by clicking the middle mouse button in any application that supports the primary clipboard mechanism.
				**Note:** This method is only implemented on Linux (X11/Wayland).

### `clipboard_has() -> bool`
- 限定：qualifiers=const

Returns `true` if there is a text content on the user's clipboard.

### `clipboard_has_image() -> bool`
- 限定：qualifiers=const

Returns `true` if there is an image content on the user's clipboard.

### `clipboard_set(clipboard: String) -> void`

Sets the user's clipboard content to the given string.

### `clipboard_set_primary(clipboard_primary: String) -> void`

Sets the user's primary (https://unix.stackexchange.com/questions/139191/whats-the-difference-between-primary-selection-and-clipboard-buffer) clipboard content to the given string. This is the clipboard that is set when the user selects text in any application, rather than when pressing Ctrl + C. The clipboard data can then be pasted by clicking the middle mouse button in any application that supports the primary clipboard mechanism.
				**Note:** This method is only implemented on Linux (X11/Wayland).

### `color_picker(callback: Callable) -> bool`

Displays OS native color picker.
				Callbacks have the following arguments: `status: bool, color: Color`.
				**Note:** This method is implemented if the display server has the `FEATURE_NATIVE_COLOR_PICKER` feature.
				**Note:** This method is only implemented on Linux (X11/Wayland).

### `create_status_indicator(icon: Texture2D, tooltip: String, callback: Callable) -> int`

Creates a new application status indicator with the specified icon, tooltip, and activation callback.
				`callback` should take two arguments: the pressed mouse button (one of the `MouseButton` constants) and the click position in screen coordinates (a `Vector2i`).

### `cursor_get_shape() -> int`
- 限定：qualifiers=const

Returns the default mouse cursor shape set by `cursor_set_shape`.

### `cursor_set_custom_image(cursor: Resource, shape: int = 0, hotspot: Vector2 = Vector2(0, 0)) -> void`

Sets a custom mouse cursor image for the given `shape`. This means the user's operating system and mouse cursor theme will no longer influence the mouse cursor's appearance.
				`cursor` can be either a `Texture2D` or an `Image`, and it should not be larger than 256×256 to display correctly. Optionally, `hotspot` can be set to offset the image's position relative to the click point. By default, `hotspot` is set to the top-left corner of the image. See also `cursor_set_shape`.
				**Note:** On Web, calling this method every frame can cause the cursor to flicker.

### `cursor_set_shape(shape: int) -> void`

Sets the default mouse cursor shape. The cursor's appearance will vary depending on the user's operating system and mouse cursor theme. See also `cursor_get_shape` and `cursor_set_custom_image`.

### `delete_status_indicator(id: int) -> void`

Removes the application status indicator.

### `dialog_input_text(title: String, description: String, existing_text: String, callback: Callable) -> int`

Shows a text input dialog which uses the operating system's native look-and-feel. `callback` should accept a single `String` parameter which contains the text field's contents.
				**Note:** This method is implemented if the display server has the `FEATURE_NATIVE_DIALOG_INPUT` feature. Supported platforms include macOS, Windows, and Android.

### `dialog_show(title: String, description: String, buttons: PackedStringArray, callback: Callable) -> int`

Shows a text dialog which uses the operating system's native look-and-feel. `callback` should accept a single `int` parameter which corresponds to the index of the pressed button.
				**Note:** This method is implemented if the display server has the `FEATURE_NATIVE_DIALOG` feature. Supported platforms include macOS, Windows, and Android.

### `enable_for_stealing_focus(process_id: int) -> void`

Allows the `process_id` PID to steal focus from this window. In other words, this disables the operating system's focus stealing protection for the specified PID.
				**Note:** This method is implemented only on Windows.

### `file_dialog_show(title: String, current_directory: String, filename: String, show_hidden: bool, mode: int, filters: PackedStringArray, callback: Callable, parent_window_id: int = 0) -> int`

Displays OS native dialog for selecting files or directories in the file system.
				Each filter string in the `filters` array should be formatted like this: `*.png,*.jpg,*.jpeg;Image Files;image/png,image/jpeg`. The description text of the filter is optional and can be omitted. It is recommended to set both file extension and MIME type. See also `FileDialog.filters`.
				Callbacks have the following arguments: `status: bool, selected_paths: PackedStringArray, selected_filter_index: int`. **On Android,** the third callback argument (`selected_filter_index`) is always `0`.
				**Note:** This method is implemented if the display server has the `FEATURE_NATIVE_DIALOG_FILE` feature. Supported platforms include Linux (X11/Wayland), Windows, macOS, and Android.
				**Note:** `current_directory` might be ignored.
				**Note:** Embedded file dialogs and Windows file dialogs support only file extensions, while Android, Linux, and macOS file dialogs also support MIME types.
				**Note:** On Android and Linux, `show_hidden` is ignored.
				**Note:** On Android and macOS, native file dialogs have no title.
				**Note:** On macOS, sandboxed apps will save security-scoped bookmarks to retain access to the opened folders across multiple sessions. Use `OS.get_granted_permissions` to get a list of saved bookmarks.
				**Note:** On Android, this method uses the Android Storage Access Framework (SAF).
				The file picker returns a URI instead of a filesystem path. This URI can be passed directly to `FileAccess` to perform read/write operations.
				When using `FILE_DIALOG_MODE_OPEN_DIR`, it returns a tree URI that grants full access to the selected directory. File operations inside this directory can be performed by passing a path on the form `treeUri#relative/path/to/file` to `FileAccess`.
				To avoid opening the file picker again after each app restart, you can take persistable URI permission as follows:
				`codeblocks`
				`gdscript`
				val uri = "content://com.android..." # URI of the selected file or folder.
				val persist = true # Set to false to release the persistable permission.
				var android_runtime = Engine.get_singleton("AndroidRuntime")
				android_runtime.updatePersistableUriPermission(uri, persist)
				
				
				The persistable URI permission remains valid across app restarts as long as the directory is not moved, renamed, or deleted.

### `file_dialog_with_options_show(title: String, current_directory: String, root: String, filename: String, show_hidden: bool, mode: int, filters: PackedStringArray, options: Dictionary[], callback: Callable, parent_window_id: int = 0) -> int`

Displays OS native dialog for selecting files or directories in the file system with additional user selectable options.
				Each filter string in the `filters` array should be formatted like this: `*.png,*.jpg,*.jpeg;Image Files;image/png,image/jpeg`. The description text of the filter is optional and can be omitted. It is recommended to set both file extension and MIME type. See also `FileDialog.filters`.
				`options` is array of `Dictionary`s with the following keys:
				- `"name"` - option's name `String`.
				- `"values"` - `PackedStringArray` of values. If empty, boolean option (check box) is used.
				- `"default"` - default selected option index (`int`) or default boolean value (`bool`).
				Callbacks have the following arguments: `status: bool, selected_paths: PackedStringArray, selected_filter_index: int, selected_option: Dictionary`.
				**Note:** This method is implemented if the display server has the `FEATURE_NATIVE_DIALOG_FILE_EXTRA` feature. Supported platforms include Linux (X11/Wayland), Windows, and macOS.
				**Note:** `current_directory` might be ignored.
				**Note:** Embedded file dialogs and Windows file dialogs support only file extensions, while Android, Linux, and macOS file dialogs also support MIME types.
				**Note:** On Linux (X11), `show_hidden` is ignored.
				**Note:** On macOS, native file dialogs have no title.
				**Note:** On macOS, sandboxed apps will save security-scoped bookmarks to retain access to the opened folders across multiple sessions. Use `OS.get_granted_permissions` to get a list of saved bookmarks.

### `force_process_and_drop_events() -> void`

Forces window manager processing while ignoring all `InputEvent`s. See also `process_events`.
				**Note:** This method is implemented on Windows and macOS.

### `get_accent_color() -> Color`
- 限定：qualifiers=const

Returns OS theme accent color. Returns `Color(0, 0, 0, 0)`, if accent color is unknown.
				**Note:** This method is implemented on macOS, Windows, Android, and Linux (X11/Wayland).

### `get_base_color() -> Color`
- 限定：qualifiers=const

Returns the OS theme base color (default control background). Returns `Color(0, 0, 0, 0)` if the base color is unknown.
				**Note:** This method is implemented on macOS, Windows, and Android.

### `get_display_cutouts() -> Rect2[]`
- 限定：qualifiers=const

Returns an `Array` of `Rect2`, each of which is the bounding rectangle for a display cutout or notch. These are non-functional areas on edge-to-edge screens used by cameras and sensors. Returns an empty array if the device does not have cutouts. See also `get_display_safe_area`.
				**Note:** Currently only implemented on Android. Other platforms will return an empty array even if they do have display cutouts or notches.

### `get_display_safe_area() -> Rect2i`
- 限定：qualifiers=const

Returns the unobscured area of the display where interactive controls should be rendered. See also `get_display_cutouts`.
				**Note:** Currently only implemented on Android and iOS. On other platforms, `screen_get_usable_rect(SCREEN_OF_MAIN_WINDOW)` will be returned as a fallback. See also `screen_get_usable_rect`.

### `get_keyboard_focus_screen() -> int`
- 限定：qualifiers=const

Returns the index of the screen containing the window with the keyboard focus, or the primary screen if there's no focused window.
				**Note:** This method is implemented on Linux/X11, macOS, and Windows. On other platforms, this method always returns the primary screen.

### `get_name() -> String`
- 限定：qualifiers=const

Returns the name of the `DisplayServer` currently in use. Most operating systems only have a single `DisplayServer`, but Linux has access to more than one `DisplayServer` (currently X11 and Wayland).
				The names of built-in display servers are `Windows`, `macOS`, `X11` (Linux), `Wayland` (Linux), `Android`, `iOS`, `web` (HTML5), and `headless` (when started with the `--headless` command line argument ($DOCS_URL/tutorials/editor/command_line_tutorial.html)).

### `get_primary_screen() -> int`
- 限定：qualifiers=const

Returns the index of the primary screen.
				**Note:** This method is implemented on Linux/X11, macOS, and Windows. On other platforms, this method always returns `0`.

### `get_screen_count() -> int`
- 限定：qualifiers=const

Returns the number of displays available.
				**Note:** This method is implemented on Linux (X11 and Wayland), macOS, and Windows. On other platforms, this method always returns `1`.

### `get_screen_from_rect(rect: Rect2) -> int`
- 限定：qualifiers=const

Returns the index of the screen that overlaps the most with the given rectangle. Returns `INVALID_SCREEN` if the rectangle doesn't overlap with any screen or has no area.

### `get_swap_cancel_ok() -> bool`

Returns `true` if positions of **OK** and **Cancel** buttons are swapped in dialogs. This is enabled by default on Windows to follow interface conventions, and be toggled by changing `ProjectSettings.gui/common/swap_cancel_ok`.
				**Note:** This doesn't affect native dialogs such as the ones spawned by `DisplayServer.dialog_show`.

### `get_window_at_screen_position(position: Vector2i) -> int`
- 限定：qualifiers=const

Returns the ID of the window at the specified screen `position` (in pixels). On multi-monitor setups, the screen position is relative to the virtual desktop area. On multi-monitor setups with different screen resolutions or orientations, the origin may be located outside any display like this:
				`lang=text`
				* (0, 0)        +-------+
				                |       |
				+-------------+ |       |
				|             | |       |
				|             | |       |
				+-------------+ +-------+

### `get_window_list() -> PackedInt32Array`
- 限定：qualifiers=const

Returns the list of Godot window IDs belonging to this process.
				**Note:** Native dialogs are not included in this list.

### `global_menu_add_check_item(menu_root: String, label: String, callback: Callable = Callable(), key_callback: Callable = Callable(), tag: Variant = null, accelerator: int = 0, index: int = -1) -> int`
- 限定：deprecated=Use [NativeMenu] or [PopupMenu] instead.

Adds a new checkable item with text `label` to the global menu with ID `menu_root`.
				Returns index of the inserted item, it's not guaranteed to be the same as `index` value.
				An `accelerator` can optionally be defined, which is a keyboard shortcut that can be pressed to trigger the menu button even if it's not currently open. The `accelerator` is generally a combination of `KeyModifierMask`s and `Key`s using bitwise OR such as `KEY_MASK_CTRL | KEY_A` (Ctrl + A).
				**Note:** The `callback` and `key_callback` Callables need to accept exactly one Variant parameter, the parameter passed to the Callables will be the value passed to `tag`.
				**Note:** This method is implemented only on macOS.
				**Supported system menu IDs:**
				`lang=text`
				"_main" - Main menu (macOS).
				"_dock" - Dock popup menu (macOS).
				"_apple" - Apple menu (macOS, custom items added before "Services").
				"_window" - Window menu (macOS, custom items added after "Bring All to Front").
				"_help" - Help menu (macOS).

### `global_menu_add_icon_check_item(menu_root: String, icon: Texture2D, label: String, callback: Callable = Callable(), key_callback: Callable = Callable(), tag: Variant = null, accelerator: int = 0, index: int = -1) -> int`
- 限定：deprecated=Use [NativeMenu] or [PopupMenu] instead.

Adds a new checkable item with text `label` and icon `icon` to the global menu with ID `menu_root`.
				Returns index of the inserted item, it's not guaranteed to be the same as `index` value.
				An `accelerator` can optionally be defined, which is a keyboard shortcut that can be pressed to trigger the menu button even if it's not currently open. The `accelerator` is generally a combination of `KeyModifierMask`s and `Key`s using bitwise OR such as `KEY_MASK_CTRL | KEY_A` (Ctrl + A).
				**Note:** The `callback` and `key_callback` Callables need to accept exactly one Variant parameter, the parameter passed to the Callables will be the value passed to `tag`.
				**Note:** This method is implemented only on macOS.
				**Supported system menu IDs:**
				`lang=text`
				"_main" - Main menu (macOS).
				"_dock" - Dock popup menu (macOS).
				"_apple" - Apple menu (macOS, custom items added before "Services").
				"_window" - Window menu (macOS, custom items added after "Bring All to Front").
				"_help" - Help menu (macOS).

### `global_menu_add_icon_item(menu_root: String, icon: Texture2D, label: String, callback: Callable = Callable(), key_callback: Callable = Callable(), tag: Variant = null, accelerator: int = 0, index: int = -1) -> int`
- 限定：deprecated=Use [NativeMenu] or [PopupMenu] instead.

Adds a new item with text `label` and icon `icon` to the global menu with ID `menu_root`.
				Returns index of the inserted item, it's not guaranteed to be the same as `index` value.
				An `accelerator` can optionally be defined, which is a keyboard shortcut that can be pressed to trigger the menu button even if it's not currently open. The `accelerator` is generally a combination of `KeyModifierMask`s and `Key`s using bitwise OR such as `KEY_MASK_CTRL | KEY_A` (Ctrl + A).
				**Note:** The `callback` and `key_callback` Callables need to accept exactly one Variant parameter, the parameter passed to the Callables will be the value passed to `tag`.
				**Note:** This method is implemented only on macOS.
				**Supported system menu IDs:**
				`lang=text`
				"_main" - Main menu (macOS).
				"_dock" - Dock popup menu (macOS).
				"_apple" - Apple menu (macOS, custom items added before "Services").
				"_window" - Window menu (macOS, custom items added after "Bring All to Front").
				"_help" - Help menu (macOS).

### `global_menu_add_icon_radio_check_item(menu_root: String, icon: Texture2D, label: String, callback: Callable = Callable(), key_callback: Callable = Callable(), tag: Variant = null, accelerator: int = 0, index: int = -1) -> int`
- 限定：deprecated=Use [NativeMenu] or [PopupMenu] instead.

Adds a new radio-checkable item with text `label` and icon `icon` to the global menu with ID `menu_root`.
				Returns index of the inserted item, it's not guaranteed to be the same as `index` value.
				An `accelerator` can optionally be defined, which is a keyboard shortcut that can be pressed to trigger the menu button even if it's not currently open. The `accelerator` is generally a combination of `KeyModifierMask`s and `Key`s using bitwise OR such as `KEY_MASK_CTRL | KEY_A` (Ctrl + A).
				**Note:** Radio-checkable items just display a checkmark, but don't have any built-in checking behavior and must be checked/unchecked manually. See `global_menu_set_item_checked` for more info on how to control it.
				**Note:** The `callback` and `key_callback` Callables need to accept exactly one Variant parameter, the parameter passed to the Callables will be the value passed to `tag`.
				**Note:** This method is implemented only on macOS.
				**Supported system menu IDs:**
				`lang=text`
				"_main" - Main menu (macOS).
				"_dock" - Dock popup menu (macOS).
				"_apple" - Apple menu (macOS, custom items added before "Services").
				"_window" - Window menu (macOS, custom items added after "Bring All to Front").
				"_help" - Help menu (macOS).

### `global_menu_add_item(menu_root: String, label: String, callback: Callable = Callable(), key_callback: Callable = Callable(), tag: Variant = null, accelerator: int = 0, index: int = -1) -> int`
- 限定：deprecated=Use [NativeMenu] or [PopupMenu] instead.

Adds a new item with text `label` to the global menu with ID `menu_root`.
				Returns index of the inserted item, it's not guaranteed to be the same as `index` value.
				An `accelerator` can optionally be defined, which is a keyboard shortcut that can be pressed to trigger the menu button even if it's not currently open. The `accelerator` is generally a combination of `KeyModifierMask`s and `Key`s using bitwise OR such as `KEY_MASK_CTRL | KEY_A` (Ctrl + A).
				**Note:** The `callback` and `key_callback` Callables need to accept exactly one Variant parameter, the parameter passed to the Callables will be the value passed to `tag`.
				**Note:** This method is implemented only on macOS.
				**Supported system menu IDs:**
				`lang=text`
				"_main" - Main menu (macOS).
				"_dock" - Dock popup menu (macOS).
				"_apple" - Apple menu (macOS, custom items added before "Services").
				"_window" - Window menu (macOS, custom items added after "Bring All to Front").
				"_help" - Help menu (macOS).

### `global_menu_add_multistate_item(menu_root: String, label: String, max_states: int, default_state: int, callback: Callable = Callable(), key_callback: Callable = Callable(), tag: Variant = null, accelerator: int = 0, index: int = -1) -> int`
- 限定：deprecated=Use [NativeMenu] or [PopupMenu] instead.

Adds a new item with text `label` to the global menu with ID `menu_root`.
				Contrarily to normal binary items, multistate items can have more than two states, as defined by `max_states`. Each press or activate of the item will increase the state by one. The default value is defined by `default_state`.
				Returns index of the inserted item, it's not guaranteed to be the same as `index` value.
				An `accelerator` can optionally be defined, which is a keyboard shortcut that can be pressed to trigger the menu button even if it's not currently open. The `accelerator` is generally a combination of `KeyModifierMask`s and `Key`s using bitwise OR such as `KEY_MASK_CTRL | KEY_A` (Ctrl + A).
				**Note:** By default, there's no indication of the current item state, it should be changed manually.
				**Note:** The `callback` and `key_callback` Callables need to accept exactly one Variant parameter, the parameter passed to the Callables will be the value passed to `tag`.
				**Note:** This method is implemented only on macOS.
				**Supported system menu IDs:**
				`lang=text`
				"_main" - Main menu (macOS).
				"_dock" - Dock popup menu (macOS).
				"_apple" - Apple menu (macOS, custom items added before "Services").
				"_window" - Window menu (macOS, custom items added after "Bring All to Front").
				"_help" - Help menu (macOS).

### `global_menu_add_radio_check_item(menu_root: String, label: String, callback: Callable = Callable(), key_callback: Callable = Callable(), tag: Variant = null, accelerator: int = 0, index: int = -1) -> int`
- 限定：deprecated=Use [NativeMenu] or [PopupMenu] instead.

Adds a new radio-checkable item with text `label` to the global menu with ID `menu_root`.
				Returns index of the inserted item, it's not guaranteed to be the same as `index` value.
				An `accelerator` can optionally be defined, which is a keyboard shortcut that can be pressed to trigger the menu button even if it's not currently open. The `accelerator` is generally a combination of `KeyModifierMask`s and `Key`s using bitwise OR such as `KEY_MASK_CTRL | KEY_A` (Ctrl + A).
				**Note:** Radio-checkable items just display a checkmark, but don't have any built-in checking behavior and must be checked/unchecked manually. See `global_menu_set_item_checked` for more info on how to control it.
				**Note:** The `callback` and `key_callback` Callables need to accept exactly one Variant parameter, the parameter passed to the Callables will be the value passed to `tag`.
				**Note:** This method is implemented only on macOS.
				**Supported system menu IDs:**
				`lang=text`
				"_main" - Main menu (macOS).
				"_dock" - Dock popup menu (macOS).
				"_apple" - Apple menu (macOS, custom items added before "Services").
				"_window" - Window menu (macOS, custom items added after "Bring All to Front").
				"_help" - Help menu (macOS).

### `global_menu_add_separator(menu_root: String, index: int = -1) -> int`
- 限定：deprecated=Use [NativeMenu] or [PopupMenu] instead.

Adds a separator between items to the global menu with ID `menu_root`. Separators also occupy an index.
				Returns index of the inserted item, it's not guaranteed to be the same as `index` value.
				**Note:** This method is implemented only on macOS.
				**Supported system menu IDs:**
				`lang=text`
				"_main" - Main menu (macOS).
				"_dock" - Dock popup menu (macOS).
				"_apple" - Apple menu (macOS, custom items added before "Services").
				"_window" - Window menu (macOS, custom items added after "Bring All to Front").
				"_help" - Help menu (macOS).

### `global_menu_add_submenu_item(menu_root: String, label: String, submenu: String, index: int = -1) -> int`
- 限定：deprecated=Use [NativeMenu] or [PopupMenu] instead.

Adds an item that will act as a submenu of the global menu `menu_root`. The `submenu` argument is the ID of the global menu root that will be shown when the item is clicked.
				Returns index of the inserted item, it's not guaranteed to be the same as `index` value.
				**Note:** This method is implemented only on macOS.
				**Supported system menu IDs:**
				`lang=text`
				"_main" - Main menu (macOS).
				"_dock" - Dock popup menu (macOS).
				"_apple" - Apple menu (macOS, custom items added before "Services").
				"_window" - Window menu (macOS, custom items added after "Bring All to Front").
				"_help" - Help menu (macOS).

### `global_menu_clear(menu_root: String) -> void`
- 限定：deprecated=Use [NativeMenu] or [PopupMenu] instead.

Removes all items from the global menu with ID `menu_root`.
				**Note:** This method is implemented only on macOS.
				**Supported system menu IDs:**
				`lang=text`
				"_main" - Main menu (macOS).
				"_dock" - Dock popup menu (macOS).
				"_apple" - Apple menu (macOS, custom items added before "Services").
				"_window" - Window menu (macOS, custom items added after "Bring All to Front").
				"_help" - Help menu (macOS).

### `global_menu_get_item_accelerator(menu_root: String, idx: int) -> int`
- 限定：deprecated=Use [NativeMenu] or [PopupMenu] instead. · qualifiers=const

Returns the accelerator of the item at index `idx`. Accelerators are special combinations of keys that activate the item, no matter which control is focused.
				**Note:** This method is implemented only on macOS.

### `global_menu_get_item_callback(menu_root: String, idx: int) -> Callable`
- 限定：deprecated=Use [NativeMenu] or [PopupMenu] instead. · qualifiers=const

Returns the callback of the item at index `idx`.
				**Note:** This method is implemented only on macOS.

### `global_menu_get_item_count(menu_root: String) -> int`
- 限定：deprecated=Use [NativeMenu] or [PopupMenu] instead. · qualifiers=const

Returns number of items in the global menu with ID `menu_root`.
				**Note:** This method is implemented only on macOS.

### `global_menu_get_item_icon(menu_root: String, idx: int) -> Texture2D`
- 限定：deprecated=Use [NativeMenu] or [PopupMenu] instead. · qualifiers=const

Returns the icon of the item at index `idx`.
				**Note:** This method is implemented only on macOS.

### `global_menu_get_item_indentation_level(menu_root: String, idx: int) -> int`
- 限定：deprecated=Use [NativeMenu] or [PopupMenu] instead. · qualifiers=const

Returns the horizontal offset of the item at the given `idx`.
				**Note:** This method is implemented only on macOS.

### `global_menu_get_item_index_from_tag(menu_root: String, tag: Variant) -> int`
- 限定：deprecated=Use [NativeMenu] or [PopupMenu] instead. · qualifiers=const

Returns the index of the item with the specified `tag`. Indices are automatically assigned to each item by the engine, and cannot be set manually.
				**Note:** This method is implemented only on macOS.

### `global_menu_get_item_index_from_text(menu_root: String, text: String) -> int`
- 限定：deprecated=Use [NativeMenu] or [PopupMenu] instead. · qualifiers=const

Returns the index of the item with the specified `text`. Indices are automatically assigned to each item by the engine, and cannot be set manually.
				**Note:** This method is implemented only on macOS.

### `global_menu_get_item_key_callback(menu_root: String, idx: int) -> Callable`
- 限定：deprecated=Use [NativeMenu] or [PopupMenu] instead. · qualifiers=const

Returns the callback of the item accelerator at index `idx`.
				**Note:** This method is implemented only on macOS.

### `global_menu_get_item_max_states(menu_root: String, idx: int) -> int`
- 限定：deprecated=Use [NativeMenu] or [PopupMenu] instead. · qualifiers=const

Returns number of states of a multistate item. See `global_menu_add_multistate_item` for details.
				**Note:** This method is implemented only on macOS.

### `global_menu_get_item_state(menu_root: String, idx: int) -> int`
- 限定：deprecated=Use [NativeMenu] or [PopupMenu] instead. · qualifiers=const

Returns the state of a multistate item. See `global_menu_add_multistate_item` for details.
				**Note:** This method is implemented only on macOS.

### `global_menu_get_item_submenu(menu_root: String, idx: int) -> String`
- 限定：deprecated=Use [NativeMenu] or [PopupMenu] instead. · qualifiers=const

Returns the submenu ID of the item at index `idx`. See `global_menu_add_submenu_item` for more info on how to add a submenu.
				**Note:** This method is implemented only on macOS.

### `global_menu_get_item_tag(menu_root: String, idx: int) -> Variant`
- 限定：deprecated=Use [NativeMenu] or [PopupMenu] instead. · qualifiers=const

Returns the metadata of the specified item, which might be of any type. You can set it with `global_menu_set_item_tag`, which provides a simple way of assigning context data to items.
				**Note:** This method is implemented only on macOS.

### `global_menu_get_item_text(menu_root: String, idx: int) -> String`
- 限定：deprecated=Use [NativeMenu] or [PopupMenu] instead. · qualifiers=const

Returns the text of the item at index `idx`.
				**Note:** This method is implemented only on macOS.

### `global_menu_get_item_tooltip(menu_root: String, idx: int) -> String`
- 限定：deprecated=Use [NativeMenu] or [PopupMenu] instead. · qualifiers=const

Returns the tooltip associated with the specified index `idx`.
				**Note:** This method is implemented only on macOS.

### `global_menu_get_system_menu_roots() -> Dictionary`
- 限定：deprecated=Use [NativeMenu] or [PopupMenu] instead. · qualifiers=const

Returns Dictionary of supported system menu IDs and names.
				**Note:** This method is implemented only on macOS.

### `global_menu_is_item_checkable(menu_root: String, idx: int) -> bool`
- 限定：deprecated=Use [NativeMenu] or [PopupMenu] instead. · qualifiers=const

Returns `true` if the item at index `idx` is checkable in some way, i.e. if it has a checkbox or radio button.
				**Note:** This method is implemented only on macOS.

### `global_menu_is_item_checked(menu_root: String, idx: int) -> bool`
- 限定：deprecated=Use [NativeMenu] or [PopupMenu] instead. · qualifiers=const

Returns `true` if the item at index `idx` is checked.
				**Note:** This method is implemented only on macOS.

### `global_menu_is_item_disabled(menu_root: String, idx: int) -> bool`
- 限定：deprecated=Use [NativeMenu] or [PopupMenu] instead. · qualifiers=const

Returns `true` if the item at index `idx` is disabled. When it is disabled it can't be selected, or its action invoked.
				See `global_menu_set_item_disabled` for more info on how to disable an item.
				**Note:** This method is implemented only on macOS.

### `global_menu_is_item_hidden(menu_root: String, idx: int) -> bool`
- 限定：deprecated=Use [NativeMenu] or [PopupMenu] instead. · qualifiers=const

Returns `true` if the item at index `idx` is hidden.
				See `global_menu_set_item_hidden` for more info on how to hide an item.
				**Note:** This method is implemented only on macOS.

### `global_menu_is_item_radio_checkable(menu_root: String, idx: int) -> bool`
- 限定：deprecated=Use [NativeMenu] or [PopupMenu] instead. · qualifiers=const

Returns `true` if the item at index `idx` has radio button-style checkability.
				**Note:** This is purely cosmetic; you must add the logic for checking/unchecking items in radio groups.
				**Note:** This method is implemented only on macOS.

### `global_menu_remove_item(menu_root: String, idx: int) -> void`
- 限定：deprecated=Use [NativeMenu] or [PopupMenu] instead.

Removes the item at index `idx` from the global menu `menu_root`.
				**Note:** The indices of items after the removed item will be shifted by one.
				**Note:** This method is implemented only on macOS.

### `global_menu_set_item_accelerator(menu_root: String, idx: int, keycode: int) -> void`
- 限定：deprecated=Use [NativeMenu] or [PopupMenu] instead.

Sets the accelerator of the item at index `idx`. `keycode` can be a single `Key`, or a combination of `KeyModifierMask`s and `Key`s using bitwise OR such as `KEY_MASK_CTRL | KEY_A` (Ctrl + A).
				**Note:** This method is implemented only on macOS.

### `global_menu_set_item_callback(menu_root: String, idx: int, callback: Callable) -> void`
- 限定：deprecated=Use [NativeMenu] or [PopupMenu] instead.

Sets the callback of the item at index `idx`. Callback is emitted when an item is pressed.
				**Note:** The `callback` Callable needs to accept exactly one Variant parameter, the parameter passed to the Callable will be the value passed to the `tag` parameter when the menu item was created.
				**Note:** This method is implemented only on macOS.

### `global_menu_set_item_checkable(menu_root: String, idx: int, checkable: bool) -> void`
- 限定：deprecated=Use [NativeMenu] or [PopupMenu] instead.

Sets whether the item at index `idx` has a checkbox. If `false`, sets the type of the item to plain text.
				**Note:** This method is implemented only on macOS.

### `global_menu_set_item_checked(menu_root: String, idx: int, checked: bool) -> void`
- 限定：deprecated=Use [NativeMenu] or [PopupMenu] instead.

Sets the checkstate status of the item at index `idx`.
				**Note:** This method is implemented only on macOS.

### `global_menu_set_item_disabled(menu_root: String, idx: int, disabled: bool) -> void`
- 限定：deprecated=Use [NativeMenu] or [PopupMenu] instead.

Enables/disables the item at index `idx`. When it is disabled, it can't be selected and its action can't be invoked.
				**Note:** This method is implemented only on macOS.

### `global_menu_set_item_hidden(menu_root: String, idx: int, hidden: bool) -> void`
- 限定：deprecated=Use [NativeMenu] or [PopupMenu] instead.

Hides/shows the item at index `idx`. When it is hidden, an item does not appear in a menu and its action cannot be invoked.
				**Note:** This method is implemented only on macOS.

### `global_menu_set_item_hover_callbacks(menu_root: String, idx: int, callback: Callable) -> void`
- 限定：deprecated=Use [NativeMenu] or [PopupMenu] instead.

Sets the callback of the item at index `idx`. The callback is emitted when an item is hovered.
				**Note:** The `callback` Callable needs to accept exactly one Variant parameter, the parameter passed to the Callable will be the value passed to the `tag` parameter when the menu item was created.
				**Note:** This method is implemented only on macOS.

### `global_menu_set_item_icon(menu_root: String, idx: int, icon: Texture2D) -> void`
- 限定：deprecated=Use [NativeMenu] or [PopupMenu] instead.

Replaces the `Texture2D` icon of the specified `idx`.
				**Note:** This method is implemented only on macOS.
				**Note:** This method is not supported by macOS "_dock" menu items.

### `global_menu_set_item_indentation_level(menu_root: String, idx: int, level: int) -> void`
- 限定：deprecated=Use [NativeMenu] or [PopupMenu] instead.

Sets the horizontal offset of the item at the given `idx`.
				**Note:** This method is implemented only on macOS.

### `global_menu_set_item_key_callback(menu_root: String, idx: int, key_callback: Callable) -> void`
- 限定：deprecated=Use [NativeMenu] or [PopupMenu] instead.

Sets the callback of the item at index `idx`. Callback is emitted when its accelerator is activated.
				**Note:** The `key_callback` Callable needs to accept exactly one Variant parameter, the parameter passed to the Callable will be the value passed to the `tag` parameter when the menu item was created.
				**Note:** This method is implemented only on macOS.

### `global_menu_set_item_max_states(menu_root: String, idx: int, max_states: int) -> void`
- 限定：deprecated=Use [NativeMenu] or [PopupMenu] instead.

Sets number of state of a multistate item. See `global_menu_add_multistate_item` for details.
				**Note:** This method is implemented only on macOS.

### `global_menu_set_item_radio_checkable(menu_root: String, idx: int, checkable: bool) -> void`
- 限定：deprecated=Use [NativeMenu] or [PopupMenu] instead.

Sets the type of the item at the specified index `idx` to radio button. If `false`, sets the type of the item to plain text.
				**Note:** This is purely cosmetic; you must add the logic for checking/unchecking items in radio groups.
				**Note:** This method is implemented only on macOS.

### `global_menu_set_item_state(menu_root: String, idx: int, state: int) -> void`
- 限定：deprecated=Use [NativeMenu] or [PopupMenu] instead.

Sets the state of a multistate item. See `global_menu_add_multistate_item` for details.
				**Note:** This method is implemented only on macOS.

### `global_menu_set_item_submenu(menu_root: String, idx: int, submenu: String) -> void`
- 限定：deprecated=Use [NativeMenu] or [PopupMenu] instead.

Sets the submenu of the item at index `idx`. The submenu is the ID of a global menu root that would be shown when the item is clicked.
				**Note:** This method is implemented only on macOS.

### `global_menu_set_item_tag(menu_root: String, idx: int, tag: Variant) -> void`
- 限定：deprecated=Use [NativeMenu] or [PopupMenu] instead.

Sets the metadata of an item, which may be of any type. You can later get it with `global_menu_get_item_tag`, which provides a simple way of assigning context data to items.
				**Note:** This method is implemented only on macOS.

### `global_menu_set_item_text(menu_root: String, idx: int, text: String) -> void`
- 限定：deprecated=Use [NativeMenu] or [PopupMenu] instead.

Sets the text of the item at index `idx`.
				**Note:** This method is implemented only on macOS.

### `global_menu_set_item_tooltip(menu_root: String, idx: int, tooltip: String) -> void`
- 限定：deprecated=Use [NativeMenu] or [PopupMenu] instead.

Sets the `String` tooltip of the item at the specified index `idx`.
				**Note:** This method is implemented only on macOS.

### `global_menu_set_popup_callbacks(menu_root: String, open_callback: Callable, close_callback: Callable) -> void`
- 限定：deprecated=Use [NativeMenu] or [PopupMenu] instead.

Registers callables to emit when the menu is respectively about to show or closed. Callback methods should have zero arguments.

### `has_additional_outputs() -> bool`
- 限定：qualifiers=const

Returns `true` if any additional outputs have been registered via `register_additional_output`.

### `has_feature(feature: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the specified `feature` is supported by the current `DisplayServer`, `false` otherwise.

### `has_hardware_keyboard() -> bool`
- 限定：qualifiers=const

Returns `true` if a hardware keyboard is connected.
				**Note:** This method is implemented on Android and iOS. On other platforms, this method always returns `true`.

### `help_set_search_callbacks(search_callback: Callable, action_callback: Callable) -> void`

Sets native help system search callbacks.
				`search_callback` has the following arguments: `String search_string, int result_limit` and return a `Dictionary` with "key, display name" pairs for the search results. Called when the user enters search terms in the `Help` menu.
				`action_callback` has the following arguments: `String key`. Called when the user selects a search result in the `Help` menu.
				**Note:** This method is implemented only on macOS.

### `ime_get_selection() -> Vector2i`
- 限定：qualifiers=const

Returns the text selection in the Input Method Editor (https://en.wikipedia.org/wiki/Input_method) composition string, with the `Vector2i`'s `x` component being the caret position and `y` being the length of the selection.
				**Note:** This method is implemented only on macOS.

### `ime_get_text() -> String`
- 限定：qualifiers=const

Returns the composition string contained within the Input Method Editor (https://en.wikipedia.org/wiki/Input_method) window.
				**Note:** This method is implemented only on macOS.

### `is_dark_mode() -> bool`
- 限定：qualifiers=const

Returns `true` if OS is using dark mode.
				**Note:** This method is implemented on Android, iOS, macOS, Windows, and Linux (X11/Wayland).

### `is_dark_mode_supported() -> bool`
- 限定：qualifiers=const

Returns `true` if OS supports dark mode.
				**Note:** This method is implemented on Android, iOS, macOS, Windows, and Linux (X11/Wayland).

### `is_in_pip_mode(window_id: int = 0) -> bool`

Returns `true` if the application is in picture-in-picture mode.
				**Note:** This method is implemented on Android.

### `is_touchscreen_available() -> bool`
- 限定：qualifiers=const

Returns `true` if touch events are available (Android or iOS), the capability is detected on the Web platform or if `ProjectSettings.input_devices/pointing/emulate_touch_from_mouse` is `true`.

### `is_window_transparency_available() -> bool`
- 限定：qualifiers=const

Returns `true` if the window background can be made transparent. This method returns `false` if `ProjectSettings.display/window/per_pixel_transparency/allowed` is set to `false`, or if transparency is not supported by the renderer or OS compositor.

### `keyboard_get_current_layout() -> int`
- 限定：qualifiers=const

Returns active keyboard layout index.
				**Note:** This method is implemented on Linux (X11/Wayland), macOS, and Windows.

### `keyboard_get_keycode_from_physical(keycode: int) -> int`
- 限定：qualifiers=const

Converts a physical (US QWERTY) `keycode` to one in the active keyboard layout.
				**Note:** This method is implemented on Linux (X11/Wayland), macOS and Windows.

### `keyboard_get_label_from_physical(keycode: int) -> int`
- 限定：qualifiers=const

Converts a physical (US QWERTY) `keycode` to localized label printed on the key in the active keyboard layout.
				**Note:** This method is implemented on Linux (X11/Wayland), macOS and Windows.

### `keyboard_get_layout_count() -> int`
- 限定：qualifiers=const

Returns the number of keyboard layouts.
				**Note:** This method is implemented on Linux (X11/Wayland), macOS and Windows.

### `keyboard_get_layout_language(index: int) -> String`
- 限定：qualifiers=const

Returns the ISO-639/BCP-47 language code of the keyboard layout at position `index`.
				**Note:** This method is implemented on Linux (X11/Wayland), macOS and Windows.

### `keyboard_get_layout_name(index: int) -> String`
- 限定：qualifiers=const

Returns the localized name of the keyboard layout at position `index`.
				**Note:** This method is implemented on Linux (X11/Wayland), macOS and Windows.

### `keyboard_set_current_layout(index: int) -> void`

Sets the active keyboard layout.
				**Note:** This method is implemented on Linux (X11/Wayland), macOS and Windows.

### `mouse_get_button_state() -> int`
- 限定：qualifiers=const

Returns the current state of mouse buttons (whether each button is pressed) as a bitmask. If multiple mouse buttons are pressed at the same time, the bits are added together. Equivalent to `Input.get_mouse_button_mask`.

### `mouse_get_mode() -> int`
- 限定：qualifiers=const

Returns the current mouse mode. See also `mouse_set_mode`.

### `mouse_get_position() -> Vector2i`
- 限定：qualifiers=const

Returns the mouse cursor's current position in screen coordinates.

### `mouse_set_mode(mouse_mode: int) -> void`

Sets the current mouse mode. See also `mouse_get_mode`.

### `pip_mode_enter(window_id: int = 0) -> void`

Enters picture-in-picture mode.
				**Note:** This method is implemented on Android.

### `pip_mode_set_aspect_ratio(numerator: int, denominator: int, window_id: int = 0) -> void`

Specifies the aspect ratio for picture-in-picture mode.
				**Note:** This method is implemented on Android.

### `pip_mode_set_auto_enter_on_background(auto_enter_on_background: bool, window_id: int = 0) -> void`

Specifies whether picture-in-picture mode should be entered automatically when the application goes in the background.
				**Note:** This method is implemented on Android.

### `process_events() -> void`

Perform window manager processing, including input flushing. See also `force_process_and_drop_events`, `Input.flush_buffered_events` and `Input.use_accumulated_input`.

### `register_additional_output(object: Object) -> void`

Registers an `Object` which represents an additional output that will be rendered too, beyond normal windows. The `Object` is only used as an identifier, which can be later passed to `unregister_additional_output`.
				This can be used to prevent Godot from skipping rendering when no normal windows are visible.

### `screen_get_dpi(screen: int = -1) -> int`
- 限定：qualifiers=const

Returns the dots per inch density of the specified screen. Returns platform specific default value if `screen` is invalid.
				**Note:** One of the following constants can be used as `screen`: `SCREEN_OF_MAIN_WINDOW`, `SCREEN_PRIMARY`, `SCREEN_WITH_MOUSE_FOCUS`, or `SCREEN_WITH_KEYBOARD_FOCUS`.
				**Note:** On macOS, returned value is inaccurate if fractional display scaling mode is used.
				**Note:** On Android devices, the actual screen densities are grouped into six generalized densities:
				`lang=text`
				   ldpi - 120 dpi
				   mdpi - 160 dpi
				   hdpi - 240 dpi
				  xhdpi - 320 dpi
				 xxhdpi - 480 dpi
				xxxhdpi - 640 dpi
				
				**Note:** This method is implemented on Android, iOS, Linux (X11/Wayland), macOS, Web, and Windows. On other platforms, this method always returns `72`.

### `screen_get_image(screen: int = -1) -> Image`
- 限定：qualifiers=const

Returns a screenshot of the `screen`. Returns `null` if `screen` is invalid or the `DisplayServer` fails to capture screenshot.
				**Note:** One of the following constants can be used as `screen`: `SCREEN_OF_MAIN_WINDOW`, `SCREEN_PRIMARY`, `SCREEN_WITH_MOUSE_FOCUS`, or `SCREEN_WITH_KEYBOARD_FOCUS`.
				**Note:** This method is implemented on Linux (X11, excluding XWayland), macOS, and Windows. On other platforms, this method always returns `null`.
				**Note:** On macOS, this method requires the "Screen Recording" permission. If permission is not granted, this method returns a screenshot that will not include other application windows or OS elements not related to the application.

### `screen_get_image_rect(rect: Rect2i) -> Image`
- 限定：qualifiers=const

Returns a screenshot of the screen region defined by `rect`. Returns `null` if `rect` is outside screen bounds or the `DisplayServer` fails to capture screenshot.
				**Note:** This method is implemented on macOS and Windows. On other platforms, this method always returns `null`.
				**Note:** On macOS, this method requires the "Screen Recording" permission. If permission is not granted, this method returns a screenshot that will not include other application windows or OS elements not related to the application.

### `screen_get_max_scale() -> float`
- 限定：qualifiers=const

Returns the greatest scale factor of all screens.
				**Note:** On macOS returned value is `2.0` if there is at least one hiDPI (Retina) screen in the system, and `1.0` in all other cases.
				**Note:** This method is implemented only on macOS.

### `screen_get_orientation(screen: int = -1) -> int`
- 限定：qualifiers=const

Returns the `screen`'s current orientation. See also `screen_set_orientation`. Returns `SCREEN_LANDSCAPE` if `screen` is invalid.
				**Note:** One of the following constants can be used as `screen`: `SCREEN_OF_MAIN_WINDOW`, `SCREEN_PRIMARY`, `SCREEN_WITH_MOUSE_FOCUS`, or `SCREEN_WITH_KEYBOARD_FOCUS`.
				**Note:** This method is implemented on Android and iOS. On other platforms, this method always returns `SCREEN_LANDSCAPE`.

### `screen_get_pixel(position: Vector2i) -> Color`
- 限定：qualifiers=const

Returns the color of the pixel at the given screen `position`. On multi-monitor setups, the screen position is relative to the virtual desktop area.
				**Note:** This method is implemented on Linux (X11, excluding XWayland), macOS, and Windows. On other platforms, this method always returns `Color(0, 0, 0, 1)`.
				**Note:** On macOS, this method requires the "Screen Recording" permission. If permission is not granted, this method returns a color from a screenshot that will not include other application windows or OS elements not related to the application.

### `screen_get_position(screen: int = -1) -> Vector2i`
- 限定：qualifiers=const

Returns the screen's top-left corner position in pixels. Returns `Vector2i.ZERO` if `screen` is invalid. On multi-monitor setups, the screen position is relative to the virtual desktop area. On multi-monitor setups with different screen resolutions or orientations, the origin might be located outside any display like this:
				`lang=text`
				* (0, 0)        +-------+
				                |       |
				+-------------+ |       |
				|             | |       |
				|             | |       |
				+-------------+ +-------+
				
				See also `screen_get_size`.
				**Note:** One of the following constants can be used as `screen`: `SCREEN_OF_MAIN_WINDOW`, `SCREEN_PRIMARY`, `SCREEN_WITH_MOUSE_FOCUS`, or `SCREEN_WITH_KEYBOARD_FOCUS`.

### `screen_get_refresh_rate(screen: int = -1) -> float`
- 限定：keywords=vsync · qualifiers=const

Returns the current refresh rate of the specified screen. When V-Sync is enabled, this returns the maximum framerate the project can effectively reach. Returns `-1.0` if `screen` is invalid or the `DisplayServer` fails to find the refresh rate for the specified screen.
				To fallback to a default refresh rate if the method fails, try:
				
```gdscript
				var refresh_rate = DisplayServer.screen_get_refresh_rate()
				if refresh_rate < 0:
					refresh_rate = 60.0
				
```

				**Note:** One of the following constants can be used as `screen`: `SCREEN_OF_MAIN_WINDOW`, `SCREEN_PRIMARY`, `SCREEN_WITH_MOUSE_FOCUS`, or `SCREEN_WITH_KEYBOARD_FOCUS`.
				**Note:** This method is implemented on Android, iOS, macOS, Linux (X11 and Wayland), and Windows. On other platforms, this method always returns `-1.0`.

### `screen_get_scale(screen: int = -1) -> float`
- 限定：qualifiers=const

Returns the scale factor of the specified screen by index. Returns `1.0` if `screen` is invalid.
				**Note:** One of the following constants can be used as `screen`: `SCREEN_OF_MAIN_WINDOW`, `SCREEN_PRIMARY`, `SCREEN_WITH_MOUSE_FOCUS`, or `SCREEN_WITH_KEYBOARD_FOCUS`.
				**Note:** On macOS, the returned value is `2.0` for hiDPI (Retina) screens, and `1.0` for all other cases.
				**Note:** On Linux (Wayland), the returned value is accurate only when `screen` is `SCREEN_OF_MAIN_WINDOW`. Due to API limitations, passing a direct index will return a rounded-up integer, if the screen has a fractional scale (e.g. `1.25` would get rounded up to `2.0`).
				**Note:** This method is implemented on Android, iOS, Web, macOS, and Linux (Wayland). On other platforms, this method always returns `1.0`.

### `screen_get_size(screen: int = -1) -> Vector2i`
- 限定：qualifiers=const

Returns the screen's size in pixels. See also `screen_get_position` and `screen_get_usable_rect`. Returns `Vector2i.ZERO` if `screen` is invalid.
				**Note:** One of the following constants can be used as `screen`: `SCREEN_OF_MAIN_WINDOW`, `SCREEN_PRIMARY`, `SCREEN_WITH_MOUSE_FOCUS`, or `SCREEN_WITH_KEYBOARD_FOCUS`.

### `screen_get_usable_rect(screen: int = -1) -> Rect2i`
- 限定：qualifiers=const

Returns the portion of the screen that is not obstructed by a status bar in pixels. See also `screen_get_size`.
				**Note:** One of the following constants can be used as `screen`: `SCREEN_OF_MAIN_WINDOW`, `SCREEN_PRIMARY`, `SCREEN_WITH_MOUSE_FOCUS`, or `SCREEN_WITH_KEYBOARD_FOCUS`.
				**Note:** This method is implemented on Linux/X11, macOS, and Windows. On other platforms, this method always returns `Rect2i(screen_get_position(screen), screen_get_size(screen))`.

### `screen_is_kept_on() -> bool`
- 限定：qualifiers=const

Returns `true` if the screen should never be turned off by the operating system's power-saving measures. See also `screen_set_keep_on`.

### `screen_set_keep_on(enable: bool) -> void`

Sets whether the screen should never be turned off by the operating system's power-saving measures. See also `screen_is_kept_on`.

### `screen_set_orientation(orientation: int, screen: int = -1) -> void`

Sets the `screen`'s `orientation`. See also `screen_get_orientation`.
				**Note:** One of the following constants can be used as `screen`: `SCREEN_OF_MAIN_WINDOW`, `SCREEN_PRIMARY`, `SCREEN_WITH_MOUSE_FOCUS`, or `SCREEN_WITH_KEYBOARD_FOCUS`.
				**Note:** This method is implemented on Android and iOS.
				**Note:** On iOS, this method has no effect if `ProjectSettings.display/window/handheld/orientation` is not set to `SCREEN_SENSOR`.

### `set_hardware_keyboard_connection_change_callback(callable: Callable) -> void`

Sets the callback that should be called when a hardware keyboard is connected or disconnected. `callable` should accept a single `bool` argument indicating whether the keyboard has been connected (`true`) or disconnected (`false`).
				**Note:** This method is only implemented on Android.

### `set_icon(image: Image) -> void`

Sets the application icon and icons of all windows with an `Image`. To use icons in the operating system's native format, use `set_native_icon` instead.
				**Note:** Requires support for `FEATURE_ICON`.

### `set_native_icon(filename: String) -> void`

Sets the window icon (usually displayed in the top-left corner) in the operating system's *native* format. The file at `filename` must be in `.ico` format on Windows or `.icns` on macOS. By using specially crafted `.ico` or `.icns` icons, `set_native_icon` allows specifying different icons depending on the size the icon is displayed at. This size is determined by the operating system and user preferences (including the display scale factor). To use icons in other formats, use `set_icon` instead.
				**Note:** Requires support for `FEATURE_NATIVE_ICON`.

### `set_system_theme_change_callback(callable: Callable) -> void`

Sets the callback that should be called when the system's theme settings are changed. `callable` should accept zero arguments.
				**Note:** This method is implemented on Android, iOS, macOS, Windows, and Linux (X11/Wayland).

### `show_emoji_and_symbol_picker() -> void`
- 限定：qualifiers=const

Opens system emoji and symbol picker.
				**Note:** This method is implemented on macOS and Windows.

### `status_indicator_get_rect(id: int) -> Rect2`
- 限定：qualifiers=const

Returns the rectangle for the given status indicator `id` in screen coordinates. If the status indicator is not visible, returns an empty `Rect2`.
				**Note:** This method is implemented on macOS and Windows.

### `status_indicator_set_callback(id: int, callback: Callable) -> void`

Sets the application status indicator activation callback. `callback` should take two arguments: `int` mouse button index (one of `MouseButton` values) and `Vector2i` click position in screen coordinates.
				**Note:** This method is implemented on macOS and Windows.

### `status_indicator_set_icon(id: int, icon: Texture2D) -> void`

Sets the application status indicator icon.
				**Note:** This method is implemented on macOS and Windows.

### `status_indicator_set_menu(id: int, menu_rid: RID) -> void`

Sets the application status indicator native popup menu.
				**Note:** On macOS, the menu is activated by any mouse button. Its activation callback is *not* triggered.
				**Note:** On Windows, the menu is activated by the right mouse button, selecting the status icon and pressing Shift + F10, or the applications key. The menu's activation callback for the other mouse buttons is still triggered.
				**Note:** Native popup is only supported if `NativeMenu` supports the `NativeMenu.FEATURE_POPUP_MENU` feature.

### `status_indicator_set_tooltip(id: int, tooltip: String) -> void`

Sets the application status indicator tooltip.
				**Note:** This method is implemented on macOS and Windows.

### `tablet_get_current_driver() -> String`
- 限定：qualifiers=const

Returns current active tablet driver name.
				**Note:** This method is implemented only on Windows.

### `tablet_get_driver_count() -> int`
- 限定：qualifiers=const

Returns the total number of available tablet drivers.
				**Note:** This method is implemented only on Windows.

### `tablet_get_driver_name(idx: int) -> String`
- 限定：qualifiers=const

Returns the tablet driver name for the given index.
				**Note:** This method is implemented only on Windows.

### `tablet_set_current_driver(name: String) -> void`

Set active tablet driver name.
				Supported drivers:
				- `winink`: Windows Ink API, default.
				- `wintab`: Wacom Wintab API (compatible device driver required).
				- `dummy`: Dummy driver, tablet input is disabled.
				**Note:** This method is implemented only on Windows.

### `tts_get_voices() -> Dictionary[]`
- 限定：qualifiers=const

Returns an `Array` of voice information dictionaries.
				Each `Dictionary` contains two `String` entries:
				- `name` is voice name.
				- `id` is voice identifier.
				- `language` is language code in `lang_Variant` format. The `lang` part is a 2 or 3-letter code based on the ISO-639 standard, in lowercase. The `skip-lint`Variant part is an engine-dependent string describing country, region or/and dialect.
				Note that Godot depends on system libraries for text-to-speech functionality. These libraries are installed by default on Windows and macOS, but not on all Linux distributions. If they are not present, this method will return an empty list. This applies to both Godot users on Linux, as well as end-users on Linux running Godot games that use text-to-speech.
				**Note:** This method is implemented on Android, iOS, Web, Linux (X11/Wayland), macOS, and Windows.

### `tts_get_voices_for_language(language: String) -> PackedStringArray`
- 限定：qualifiers=const

Returns a `PackedStringArray` of voice identifiers for the `language`.
				**Note:** This method is implemented on Android, iOS, Web, Linux (X11/Wayland), macOS, and Windows.

### `tts_is_paused() -> bool`
- 限定：qualifiers=const

Returns `true` if the synthesizer is in a paused state.
				**Note:** This method is implemented on Android, iOS, Web, Linux (X11/Wayland), macOS, and Windows.

### `tts_is_speaking() -> bool`
- 限定：qualifiers=const

Returns `true` if the synthesizer is generating speech, or have utterance waiting in the queue.
				**Note:** This method is implemented on Android, iOS, Web, Linux (X11/Wayland), macOS, and Windows.

### `tts_pause() -> void`

Puts the synthesizer into a paused state.
				**Note:** This method is implemented on Android, iOS, Web, Linux (X11/Wayland), macOS, and Windows.

### `tts_resume() -> void`

Resumes the synthesizer if it was paused.
				**Note:** This method is implemented on Android, iOS, Web, Linux (X11/Wayland), macOS, and Windows.

### `tts_set_utterance_callback(event: int, callable: Callable) -> void`

Adds a callback, which is called when the utterance has started, finished, canceled or reached a text boundary.
				- `TTS_UTTERANCE_STARTED`, `TTS_UTTERANCE_ENDED`, and `TTS_UTTERANCE_CANCELED` callable's method should take one `int` parameter, the utterance ID.
				- `TTS_UTTERANCE_BOUNDARY` callable's method should take two `int` parameters, the index of the character and the utterance ID.
				**Note:** The granularity of the boundary callbacks is engine dependent.
				**Note:** This method is implemented on Android, iOS, Web, Linux (X11/Wayland), macOS, and Windows.

### `tts_speak(text: String, voice: String, volume: int = 50, pitch: float = 1.0, rate: float = 1.0, utterance_id: int = 0, interrupt: bool = false) -> void`

Adds an utterance to the queue. If `interrupt` is `true`, the queue is cleared first.
				- `voice` identifier is one of the `"id"` values returned by `tts_get_voices` or one of the values returned by `tts_get_voices_for_language`.
				- `volume` ranges from `0` (lowest) to `100` (highest).
				- `pitch` ranges from `0.0` (lowest) to `2.0` (highest), `1.0` is default pitch for the current voice.
				- `rate` ranges from `0.1` (lowest) to `10.0` (highest), `1.0` is a normal speaking rate. Other values act as a percentage relative.
				- `utterance_id` is passed as a parameter to the callback functions.
				**Note:** On Windows and Linux (X11/Wayland), utterance `text` can use SSML markup. SSML support is engine and voice dependent. If the engine does not support SSML, you should strip out all XML markup before calling `tts_speak`.
				**Note:** The granularity of pitch, rate, and volume is engine and voice dependent. Values may be truncated.
				**Note:** This method is implemented on Android, iOS, Web, Linux (X11/Wayland), macOS, and Windows.

### `tts_stop() -> void`

Stops synthesis in progress and removes all utterances from the queue.
				**Note:** This method is implemented on Android, iOS, Web, Linux (X11/Wayland), macOS, and Windows.

### `unregister_additional_output(object: Object) -> void`

Unregisters an `Object` representing an additional output, that was registered via `register_additional_output`.

### `virtual_keyboard_get_height() -> int`
- 限定：qualifiers=const

Returns the on-screen keyboard's height in pixels. Returns `0` if there is no keyboard or if it is currently hidden.
				**Note:** On Android 7 and 8, the keyboard height may return `0` the first time the keyboard is opened in non-immersive mode. This behavior does not occur in immersive mode.

### `virtual_keyboard_hide() -> void`

Hides the virtual keyboard if it is shown, does nothing otherwise.

### `virtual_keyboard_show(existing_text: String, position: Rect2 = Rect2(0, 0, 0, 0), type: int = 0, max_length: int = -1, cursor_start: int = -1, cursor_end: int = -1) -> void`

Shows the virtual keyboard if the platform has one.
				`existing_text` parameter is useful for implementing your own `LineEdit` or `TextEdit`, as it tells the virtual keyboard what text has already been typed (the virtual keyboard uses it for auto-correct and predictions).
				`position` parameter is the screen space `Rect2` of the edited text.
				`type` parameter allows configuring which type of virtual keyboard to show.
				`max_length` limits the number of characters that can be entered if different from `-1`.
				`cursor_start` can optionally define the current text cursor position if `cursor_end` is not set.
				`cursor_start` and `cursor_end` can optionally define the current text selection.
				**Note:** This method is implemented on Android, iOS and Web.

### `warp_mouse(position: Vector2i) -> void`

Sets the mouse cursor position to the given `position` relative to an origin at the upper left corner of the currently focused game Window Manager window.
				**Note:** `warp_mouse` is only supported on Windows, macOS, and Linux (X11/Wayland). It has no effect on Android, iOS, and Web.

### `window_can_draw(window_id: int = 0) -> bool`
- 限定：qualifiers=const

Returns `true` if anything can be drawn in the window specified by `window_id`, `false` otherwise. Using the `--disable-render-loop` command line argument or a headless build will return `false`.

### `window_get_active_popup() -> int`
- 限定：qualifiers=const

Returns ID of the active popup window, or `INVALID_WINDOW_ID` if there is none.

### `window_get_attached_instance_id(window_id: int = 0) -> int`
- 限定：qualifiers=const

Returns the `Object.get_instance_id` of the `Window` the `window_id` is attached to.

### `window_get_current_screen(window_id: int = 0) -> int`
- 限定：qualifiers=const

Returns the screen the window specified by `window_id` is currently positioned on. If the screen overlaps multiple displays, the screen where the window's center is located is returned. See also `window_set_current_screen`. Returns `INVALID_SCREEN` if `window_id` is invalid.
				**Note:** This method is implemented on Linux/X11, macOS, and Windows. On other platforms, this method always returns `0`.

### `window_get_flag(flag: int, window_id: int = 0) -> bool`
- 限定：qualifiers=const

Returns the current value of the given window's `flag`.

### `window_get_hdr_output_current_max_luminance(window_id: int = 0) -> float`
- 限定：experimental= · qualifiers=const

When `window_is_hdr_output_enabled` returns `true`, this returns the current maximum luminance in nits (cd/m²) for HDR output by the window specified by `window_id`. If the maximum luminance is being automatically adjusted based on the screen's capabilities, this method will return that value. Otherwise, it will return the value set by `window_set_hdr_output_max_luminance`. This maximum luminance value is used when calculating `window_get_output_max_linear_value`.
				**Note:** This maximum luminance may not match the physical behavior of the screen, but will always be proportionally correct relative to `window_get_hdr_output_current_reference_luminance`.

### `window_get_hdr_output_current_reference_luminance(window_id: int = 0) -> float`
- 限定：qualifiers=const

When `window_is_hdr_output_enabled` returns `true`, this returns the current reference white luminance in nits (cd/m²) for HDR output by the window specified by `window_id`. If the reference luminance is being automatically adjusted to match the operating system brightness, this will return that value. Otherwise, it will return the value set by `window_set_hdr_output_reference_luminance`. This reference luminance value is used when calculating `window_get_output_max_linear_value`.
				**Note:** This reference white luminance may not match the physical behavior of the screen, but will always be proportionally correct relative to `window_get_hdr_output_current_max_luminance`.

### `window_get_hdr_output_max_luminance(window_id: int = 0) -> float`
- 限定：experimental= · qualifiers=const

Returns the maximum luminance in nits (cd/m²) set for HDR output by the window specified by `window_id`. Negative values indicate that the value is being automatically adjusted based on the screen's capabilities. See also `window_get_hdr_output_current_max_luminance`.

### `window_get_hdr_output_reference_luminance(window_id: int = 0) -> float`
- 限定：qualifiers=const

Returns the reference white luminance in nits (cd/m²) set for HDR output by the window specified by `window_id`. Negative values indicate that the value is being automatically adjusted to match the operating system brightness. See also `window_get_hdr_output_current_reference_luminance`.

### `window_get_max_size(window_id: int = 0) -> Vector2i`
- 限定：qualifiers=const

Returns the window's maximum size (in pixels). See also `window_set_max_size`.

### `window_get_min_size(window_id: int = 0) -> Vector2i`
- 限定：qualifiers=const

Returns the window's minimum size (in pixels). See also `window_set_min_size`.

### `window_get_mode(window_id: int = 0) -> int`
- 限定：qualifiers=const

Returns the mode of the given window.

### `window_get_native_handle(handle_type: int, window_id: int = 0) -> int`
- 限定：qualifiers=const

Returns internal structure pointers for use in plugins.
				**Note:** This method is implemented on Android, Linux (X11/Wayland), macOS, and Windows.

### `window_get_output_max_linear_value(window_id: int = 0) -> float`
- 限定：qualifiers=const

Returns the maximum value for linear color components that can be displayed for the window specified by `window_id`, regardless of SDR or HDR output. Returns `1.0` if HDR is not enabled or not supported. When HDR output is enabled, this is calculated based on `window_get_hdr_output_current_reference_luminance` and `window_get_hdr_output_current_max_luminance`. The `Window.output_max_linear_value_changed` signal will be emitted whenever this value changes. This value is used by tonemapping and other `Environment` effects to ensure that bright colors are presented in the range that can be displayed by this window. Corresponds to `Window.get_output_max_linear_value`.

### `window_get_popup_safe_rect(window: int) -> Rect2i`
- 限定：qualifiers=const

Returns the bounding box of control, or menu item that was used to open the popup window, in the screen coordinate system.

### `window_get_position(window_id: int = 0) -> Vector2i`
- 限定：qualifiers=const

Returns the position of the client area of the given window on the screen.

### `window_get_position_with_decorations(window_id: int = 0) -> Vector2i`
- 限定：qualifiers=const

Returns the position of the given window on the screen including the borders drawn by the operating system. See also `window_get_position`.

### `window_get_safe_title_margins(window_id: int = 0) -> Vector3i`
- 限定：qualifiers=const

Returns left margins (`x`), right margins (`y`) and height (`z`) of the title that are safe to use (contains no buttons or other elements) when `WINDOW_FLAG_EXTEND_TO_TITLE` flag is set.

### `window_get_size(window_id: int = 0) -> Vector2i`
- 限定：qualifiers=const

Returns the size of the window specified by `window_id` (in pixels), excluding the borders drawn by the operating system. This is also called the "client area". See also `window_get_size_with_decorations`, `window_set_size` and `window_get_position`.

### `window_get_size_with_decorations(window_id: int = 0) -> Vector2i`
- 限定：qualifiers=const

Returns the size of the window specified by `window_id` (in pixels), including the borders drawn by the operating system. See also `window_get_size`.

### `window_get_title_size(title: String, window_id: int = 0) -> Vector2i`
- 限定：qualifiers=const

Returns the estimated window title bar size (including text and window buttons) for the window specified by `window_id` (in pixels). This method does not change the window title.
				**Note:** This method is implemented on macOS and Windows.

### `window_get_vsync_mode(window_id: int = 0) -> int`
- 限定：qualifiers=const

Returns the V-Sync mode of the given window.

### `window_is_focused(window_id: int = 0) -> bool`
- 限定：qualifiers=const

Returns `true` if the window specified by `window_id` is focused.

### `window_is_hdr_output_enabled(window_id: int = 0) -> bool`
- 限定：qualifiers=const

Returns `true` if HDR output is currently enabled for the window specified by `window_id`. The returned value may change dynamically based on system settings, screen capabilities, and which screen the window is currently on.

### `window_is_hdr_output_requested(window_id: int = 0) -> bool`
- 限定：qualifiers=const

Returns `true` if HDR output is requested for the window specified by `window_id`. Corresponds to `Window.hdr_output_requested`.

### `window_is_hdr_output_supported(window_id: int = 0) -> bool`
- 限定：qualifiers=const

Returns `true` if the window specified by `window_id` supports HDR output. This depends on the platform, screen capabilities, system settings, and the screen the window is currently on.

### `window_is_maximize_allowed(window_id: int = 0) -> bool`
- 限定：qualifiers=const

Returns `true` if the given window can be maximized (the maximize button is enabled).

### `window_maximize_on_title_dbl_click() -> bool`
- 限定：qualifiers=const

Returns `true` if double-clicking on a window's title should maximize it.
				**Note:** This method is implemented only on macOS.

### `window_minimize_on_title_dbl_click() -> bool`
- 限定：qualifiers=const

Returns `true` if double-clicking on a window's title should minimize it.
				**Note:** This method is implemented only on macOS.

### `window_move_to_foreground(window_id: int = 0) -> void`

Moves the window specified by `window_id` to the foreground, so that it is visible over other windows.

### `window_request_attention(window_id: int = 0) -> void`

Makes the window specified by `window_id` request attention, which is materialized by the window title and taskbar entry blinking until the window is focused. This usually has no visible effect if the window is currently focused. The exact behavior varies depending on the operating system.

### `window_request_hdr_output(enable: bool, window_id: int = 0) -> void`

If `enable` is `true`, HDR output is requested for the window specified by `window_id`. The window will automatically switch between HDR and SDR if it is moved between screens, screen capabilities change, or system settings are modified. This will internally force `Viewport.use_hdr_2d` to be enabled on the main `Viewport`. All other `SubViewport` of the `Window` must have their `Viewport.use_hdr_2d` property enabled to produce HDR output. Corresponds to `Window.hdr_output_requested`.

### `window_set_color(color: Color) -> void`

Sets the background color of the root window.
				**Note:** This method is implemented only on Android.

### `window_set_current_screen(screen: int, window_id: int = 0) -> void`

Moves the window specified by `window_id` to the specified `screen`. See also `window_get_current_screen`.
				**Note:** One of the following constants can be used as `screen`: `SCREEN_OF_MAIN_WINDOW`, `SCREEN_PRIMARY`, `SCREEN_WITH_MOUSE_FOCUS`, or `SCREEN_WITH_KEYBOARD_FOCUS`.
				**Note:** This method is implemented on Linux/X11, macOS, and Windows.

### `window_set_drop_files_callback(callback: Callable, window_id: int = 0) -> void`

Sets the `callback` that should be called when files are dropped from the operating system's file manager to the window specified by `window_id`. `callback` should take one `PackedStringArray` argument, which is the list of dropped files.
				**Warning:** Advanced users only! Adding such a callback to a `Window` node will override its default implementation, which can introduce bugs.
				**Note:** This method is implemented on Windows, macOS, Linux (X11/Wayland), and Web.

### `window_set_exclusive(window_id: int, exclusive: bool) -> void`

If set to `true`, this window will always stay on top of its parent window, parent window will ignore input while this window is opened.
				**Note:** On macOS, exclusive windows are confined to the same space (virtual desktop or screen) as the parent window.
				**Note:** This method is implemented on macOS and Windows.

### `window_set_flag(flag: int, enabled: bool, window_id: int = 0) -> void`

Enables or disables the given window's given `flag`.

### `window_set_hdr_output_max_luminance(max_luminance: float, window_id: int = 0) -> void`
- 限定：experimental=

Sets the maximum luminance in nits (cd/m²) for HDR output by the window specified by `window_id`. If `max_luminance` is negative, the window uses the screen's maximum luminance that is reported by the operating system. By default, this luminance is set to `-1.0` for every window. Typically this property should be left at this default value, but may optionally be exposed through in-game settings to allow the player to correct an inaccurate maximum luminance reported by the operating system. See also `window_get_hdr_output_current_max_luminance` and `window_get_hdr_output_max_luminance`.
				**Note:** This method is only implemented on macOS and Windows. Other platforms will always use the screen's maximum luminance that is reported by the operating system.

### `window_set_hdr_output_reference_luminance(reference_luminance: float, window_id: int = 0) -> void`

Sets the reference white luminance in nits (cd/m²) for HDR output by the window specified by `window_id`. If `reference_luminance` is negative, the window automatically adjusts to the brightness set by the operating system. By default, this luminance is set to `-1.0` for every window. Typically this property should be left at this default value, but may optionally be exposed as an "HDR Brightness" in-game setting to allow the player to adjust the brightness of their game, independently of their device settings. See also `window_get_hdr_output_current_reference_luminance` and `window_get_hdr_output_reference_luminance`.
				**Note:** This method is only implemented on Windows. Other platforms will always use the reference luminance that is reported by the operating system.

### `window_set_icon(icon: Image, window_id: int = 0) -> void`

Sets the window icon (usually displayed in the top-left corner) for the window specified by `window_id`.
				**Note:** This method is implemented on Linux and Windows.

### `window_set_ime_active(active: bool, window_id: int = 0) -> void`

Sets whether Input Method Editor (https://en.wikipedia.org/wiki/Input_method) should be enabled for the window specified by `window_id`. See also `window_set_ime_position`.

### `window_set_ime_position(position: Vector2i, window_id: int = 0) -> void`

Sets the position of the Input Method Editor (https://en.wikipedia.org/wiki/Input_method) popup for the specified `window_id`. Only effective if `window_set_ime_active` was set to `true` for the specified `window_id`.

### `window_set_input_event_callback(callback: Callable, window_id: int = 0) -> void`

Sets the `callback` that should be called when any `InputEvent` is sent to the window specified by `window_id`.
				**Warning:** Advanced users only! Adding such a callback to a `Window` node will override its default implementation, which can introduce bugs.

### `window_set_input_text_callback(callback: Callable, window_id: int = 0) -> void`

Sets the `callback` that should be called when text is entered using the virtual keyboard to the window specified by `window_id`.
				**Warning:** Advanced users only! Adding such a callback to a `Window` node will override its default implementation, which can introduce bugs.

### `window_set_max_size(max_size: Vector2i, window_id: int = 0) -> void`

Sets the maximum size of the window specified by `window_id` in pixels. Normally, the user will not be able to drag the window to make it larger than the specified size. See also `window_get_max_size`.
				**Note:** It's recommended to change this value using `Window.max_size` instead.
				**Note:** Using third-party tools, it is possible for users to disable window geometry restrictions and therefore bypass this limit.

### `window_set_min_size(min_size: Vector2i, window_id: int = 0) -> void`

Sets the minimum size for the given window to `min_size` in pixels. Normally, the user will not be able to drag the window to make it smaller than the specified size. See also `window_get_min_size`.
				**Note:** It's recommended to change this value using `Window.min_size` instead.
				**Note:** By default, the main window has a minimum size of `Vector2i(64, 64)`. This prevents issues that can arise when the window is resized to a near-zero size.
				**Note:** Using third-party tools, it is possible for users to disable window geometry restrictions and therefore bypass this limit.

### `window_set_mode(mode: int, window_id: int = 0) -> void`

Sets window mode for the given window to `mode`.
				**Note:** On Android, setting it to `WINDOW_MODE_FULLSCREEN` or `WINDOW_MODE_EXCLUSIVE_FULLSCREEN` will enable immersive mode.
				**Note:** Setting the window to full screen forcibly sets the borderless flag to `true`, so make sure to set it back to `false` when not wanted.

### `window_set_mouse_passthrough(region: PackedVector2Array, window_id: int = 0) -> void`

Sets a polygonal region of the window which accepts mouse events. Mouse events outside the region will be passed through.
				Passing an empty array will disable passthrough support (all mouse events will be intercepted by the window, which is the default behavior).
				`codeblocks`
				`gdscript`
				# Set region, using Path2D node.
				DisplayServer.window_set_mouse_passthrough($Path2D.curve.get_baked_points())

				# Set region, using Polygon2D node.
				DisplayServer.window_set_mouse_passthrough($Polygon2D.polygon)

				# Reset region to default.
				DisplayServer.window_set_mouse_passthrough([])
				
				`csharp`
				// Set region, using Path2D node.
				DisplayServer.WindowSetMousePassthrough(GetNode<Path2D>("Path2D").Curve.GetBakedPoints());

				// Set region, using Polygon2D node.
				DisplayServer.WindowSetMousePassthrough(GetNode<Polygon2D>("Polygon2D").Polygon);

				// Reset region to default.
				DisplayServer.WindowSetMousePassthrough([]);
				
				
				**Note:** On Windows, the portion of a window that lies outside the region is not drawn, while on Linux (X11) and macOS it is.
				**Note:** This method is implemented on Linux (X11), macOS and Windows.

### `window_set_popup_safe_rect(window: int, rect: Rect2i) -> void`

Sets the bounding box of control, or menu item that was used to open the popup window, in the screen coordinate system. Clicking this area will not auto-close this popup.

### `window_set_position(position: Vector2i, window_id: int = 0) -> void`

Sets the position of the given window to `position`. On multi-monitor setups, the screen position is relative to the virtual desktop area. On multi-monitor setups with different screen resolutions or orientations, the origin may be located outside any display like this:
				`lang=text`
				* (0, 0)        +-------+
				                |       |
				+-------------+ |       |
				|             | |       |
				|             | |       |
				+-------------+ +-------+
				
				See also `window_get_position` and `window_set_size`.
				**Note:** It's recommended to change this value using `Window.position` instead.
				**Note:** On Linux (Wayland): this method is a no-op.

### `window_set_rect_changed_callback(callback: Callable, window_id: int = 0) -> void`

Sets the `callback` that will be called when the window specified by `window_id` is moved or resized.
				**Warning:** Advanced users only! Adding such a callback to a `Window` node will override its default implementation, which can introduce bugs.

### `window_set_size(size: Vector2i, window_id: int = 0) -> void`

Sets the size of the given window to `size` (in pixels). See also `window_get_size` and `window_get_position`.
				**Note:** It's recommended to change this value using `Window.size` instead.

### `window_set_taskbar_progress_state(state: int, window_id: int = 0) -> void`

Sets the type and state of the progress bar on the taskbar/dock icon of the window specified by `window_id`. See `ProgressState` for possible values and how each mode behaves.
				**Note:** This method is implemented only on Windows and macOS.
				**Note:** On macOS, the progress bar is displayed only for the main window.

### `window_set_taskbar_progress_value(value: float, window_id: int = 0) -> void`

Creates a progress bar on the taskbar/dock icon of the window specified by `window_id` if it does not exist, sets the progress of the icon.
				`value` acts as a relative percentage value, ranges from `0.0` (lowest) to `1.0` (highest).
				**Note:** This method is implemented only on Windows and macOS.
				**Note:** On macOS, the progress bar is displayed only for the main window.

### `window_set_title(title: String, window_id: int = 0) -> void`

Sets the title of the given window to `title`.
				**Note:** It's recommended to change this value using `Window.title` instead.
				**Note:** Avoid changing the window title every frame, as this can cause performance issues on certain window managers. Try to change the window title only a few times per second at most.

### `window_set_transient(window_id: int, parent_window_id: int) -> void`

Sets window transient parent. Transient window will be destroyed with its transient parent and will return focus to their parent when closed. The transient window is displayed on top of a non-exclusive full-screen parent window. Transient windows can't enter full-screen mode.
				**Note:** It's recommended to change this value using `Window.transient` instead.
				**Note:** The behavior might be different depending on the platform.

### `window_set_vsync_mode(vsync_mode: int, window_id: int = 0) -> void`

Sets the V-Sync mode of the given window. See also `ProjectSettings.display/window/vsync/vsync_mode`.
				Depending on the platform and used renderer, the engine will fall back to `VSYNC_ENABLED` if the desired mode is not supported.
				**Note:** V-Sync modes other than `VSYNC_ENABLED` are only supported in the Forward+ and Mobile rendering methods, not Compatibility.

### `window_set_window_buttons_offset(offset: Vector2i, window_id: int = 0) -> void`

When `WINDOW_FLAG_EXTEND_TO_TITLE` flag is set, set offset to the center of the first titlebar button.
				**Note:** This flag is implemented only on macOS.

### `window_set_window_event_callback(callback: Callable, window_id: int = 0) -> void`

Sets the `callback` that will be called when an event occurs in the window specified by `window_id`.
				**Warning:** Advanced users only! Adding such a callback to a `Window` node will override its default implementation, which can introduce bugs.

### `window_start_drag(window_id: int = 0) -> void`

Starts an interactive drag operation on the window with the given `window_id`, using the current mouse position. Call this method when handling a mouse button being pressed to simulate a pressed event on the window's title bar. Using this method allows the window to participate in space switching, tiling, and other system features.
				**Note:** This method is implemented on Linux (X11/Wayland), macOS, and Windows.

### `window_start_resize(edge: int, window_id: int = 0) -> void`

Starts an interactive resize operation on the window with the given `window_id`, using the current mouse position. Call this method when handling a mouse button being pressed to simulate a pressed event on the window's edge.
				**Note:** This method is implemented on Linux (X11/Wayland), macOS, and Windows.

## 信号

### `orientation_changed(orientation: int)`

Emitted when the device orientation changes. `orientation` is the new orientation.
				Returns `1` for portrait, `2` for landscape, and `0` if the orientation is undefined.
				**Note:** This method is implemented on Android and iOS.

## 枚举

### `Feature`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `FEATURE_GLOBAL_MENU` |  |
| `1` | `FEATURE_SUBWINDOWS` |  |
| `2` | `FEATURE_TOUCHSCREEN` |  |
| `3` | `FEATURE_MOUSE` |  |
| `4` | `FEATURE_MOUSE_WARP` |  |
| `5` | `FEATURE_CLIPBOARD` |  |
| `6` | `FEATURE_VIRTUAL_KEYBOARD` |  |
| `7` | `FEATURE_CURSOR_SHAPE` |  |
| `8` | `FEATURE_CUSTOM_CURSOR_SHAPE` |  |
| `9` | `FEATURE_NATIVE_DIALOG` |  |
| `10` | `FEATURE_IME` |  |
| `11` | `FEATURE_WINDOW_TRANSPARENCY` |  |
| `12` | `FEATURE_HIDPI` |  |
| `13` | `FEATURE_ICON` |  |
| `14` | `FEATURE_NATIVE_ICON` |  |
| `15` | `FEATURE_ORIENTATION` |  |
| `16` | `FEATURE_SWAP_BUFFERS` |  |
| `18` | `FEATURE_CLIPBOARD_PRIMARY` |  |
| `19` | `FEATURE_TEXT_TO_SPEECH` |  |
| `20` | `FEATURE_EXTEND_TO_TITLE` |  |
| `21` | `FEATURE_SCREEN_CAPTURE` |  |
| `22` | `FEATURE_STATUS_INDICATOR` |  |
| `23` | `FEATURE_NATIVE_HELP` |  |
| `24` | `FEATURE_NATIVE_DIALOG_INPUT` |  |
| `25` | `FEATURE_NATIVE_DIALOG_FILE` |  |
| `26` | `FEATURE_NATIVE_DIALOG_FILE_EXTRA` |  |
| `27` | `FEATURE_WINDOW_DRAG` |  |
| `28` | `FEATURE_SCREEN_EXCLUDE_FROM_CAPTURE` |  |
| `29` | `FEATURE_WINDOW_EMBEDDING` |  |
| `30` | `FEATURE_NATIVE_DIALOG_FILE_MIME` |  |
| `31` | `FEATURE_EMOJI_AND_SYMBOL_PICKER` |  |
| `32` | `FEATURE_NATIVE_COLOR_PICKER` |  |
| `33` | `FEATURE_SELF_FITTING_WINDOWS` |  |
| `34` | `FEATURE_ACCESSIBILITY_SCREEN_READER` |  |
| `35` | `FEATURE_HDR_OUTPUT` |  |
| `36` | `FEATURE_PIP_MODE` |  |

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

### `MouseMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `MOUSE_MODE_VISIBLE` |  |
| `1` | `MOUSE_MODE_HIDDEN` |  |
| `2` | `MOUSE_MODE_CAPTURED` |  |
| `3` | `MOUSE_MODE_CONFINED` |  |
| `4` | `MOUSE_MODE_CONFINED_HIDDEN` |  |
| `5` | `MOUSE_MODE_MAX` |  |

### `ScreenOrientation`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SCREEN_LANDSCAPE` |  |
| `1` | `SCREEN_PORTRAIT` |  |
| `2` | `SCREEN_REVERSE_LANDSCAPE` |  |
| `3` | `SCREEN_REVERSE_PORTRAIT` |  |
| `4` | `SCREEN_SENSOR_LANDSCAPE` |  |
| `5` | `SCREEN_SENSOR_PORTRAIT` |  |
| `6` | `SCREEN_SENSOR` |  |

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

### `CursorShape`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `CURSOR_ARROW` |  |
| `1` | `CURSOR_IBEAM` |  |
| `2` | `CURSOR_POINTING_HAND` |  |
| `3` | `CURSOR_CROSS` |  |
| `4` | `CURSOR_WAIT` |  |
| `5` | `CURSOR_BUSY` |  |
| `6` | `CURSOR_DRAG` |  |
| `7` | `CURSOR_CAN_DROP` |  |
| `8` | `CURSOR_FORBIDDEN` |  |
| `9` | `CURSOR_VSIZE` |  |
| `10` | `CURSOR_HSIZE` |  |
| `11` | `CURSOR_BDIAGSIZE` |  |
| `12` | `CURSOR_FDIAGSIZE` |  |
| `13` | `CURSOR_MOVE` |  |
| `14` | `CURSOR_VSPLIT` |  |
| `15` | `CURSOR_HSPLIT` |  |
| `16` | `CURSOR_HELP` |  |
| `17` | `CURSOR_MAX` |  |

### `FileDialogMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `FILE_DIALOG_MODE_OPEN_FILE` |  |
| `1` | `FILE_DIALOG_MODE_OPEN_FILES` |  |
| `2` | `FILE_DIALOG_MODE_OPEN_DIR` |  |
| `3` | `FILE_DIALOG_MODE_OPEN_ANY` |  |
| `4` | `FILE_DIALOG_MODE_SAVE_FILE` |  |

### `WindowMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `WINDOW_MODE_WINDOWED` |  |
| `1` | `WINDOW_MODE_MINIMIZED` |  |
| `2` | `WINDOW_MODE_MAXIMIZED` |  |
| `3` | `WINDOW_MODE_FULLSCREEN` |  |
| `4` | `WINDOW_MODE_EXCLUSIVE_FULLSCREEN` |  |

### `ProgressState`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `PROGRESS_STATE_NOPROGRESS` |  |
| `1` | `PROGRESS_STATE_INDETERMINATE` |  |
| `2` | `PROGRESS_STATE_NORMAL` |  |
| `3` | `PROGRESS_STATE_ERROR` |  |
| `4` | `PROGRESS_STATE_PAUSED` |  |

### `WindowFlags`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `WINDOW_FLAG_RESIZE_DISABLED` |  |
| `1` | `WINDOW_FLAG_BORDERLESS` |  |
| `2` | `WINDOW_FLAG_ALWAYS_ON_TOP` |  |
| `3` | `WINDOW_FLAG_TRANSPARENT` |  |
| `4` | `WINDOW_FLAG_NO_FOCUS` |  |
| `5` | `WINDOW_FLAG_POPUP` |  |
| `6` | `WINDOW_FLAG_EXTEND_TO_TITLE` |  |
| `7` | `WINDOW_FLAG_MOUSE_PASSTHROUGH` |  |
| `8` | `WINDOW_FLAG_SHARP_CORNERS` |  |
| `9` | `WINDOW_FLAG_EXCLUDE_FROM_CAPTURE` |  |
| `10` | `WINDOW_FLAG_POPUP_WM_HINT` |  |
| `11` | `WINDOW_FLAG_MINIMIZE_DISABLED` |  |
| `12` | `WINDOW_FLAG_MAXIMIZE_DISABLED` |  |
| `13` | `WINDOW_FLAG_MAX` |  |

### `WindowEvent`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `WINDOW_EVENT_MOUSE_ENTER` |  |
| `1` | `WINDOW_EVENT_MOUSE_EXIT` |  |
| `2` | `WINDOW_EVENT_FOCUS_IN` |  |
| `3` | `WINDOW_EVENT_FOCUS_OUT` |  |
| `4` | `WINDOW_EVENT_CLOSE_REQUEST` |  |
| `5` | `WINDOW_EVENT_GO_BACK_REQUEST` |  |
| `6` | `WINDOW_EVENT_DPI_CHANGE` |  |
| `7` | `WINDOW_EVENT_TITLEBAR_CHANGE` |  |
| `8` | `WINDOW_EVENT_FORCE_CLOSE` |  |
| `9` | `WINDOW_EVENT_OUTPUT_MAX_LINEAR_VALUE_CHANGED` |  |

### `WindowResizeEdge`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `WINDOW_EDGE_TOP_LEFT` |  |
| `1` | `WINDOW_EDGE_TOP` |  |
| `2` | `WINDOW_EDGE_TOP_RIGHT` |  |
| `3` | `WINDOW_EDGE_LEFT` |  |
| `4` | `WINDOW_EDGE_RIGHT` |  |
| `5` | `WINDOW_EDGE_BOTTOM_LEFT` |  |
| `6` | `WINDOW_EDGE_BOTTOM` |  |
| `7` | `WINDOW_EDGE_BOTTOM_RIGHT` |  |
| `8` | `WINDOW_EDGE_MAX` |  |

### `VSyncMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `VSYNC_DISABLED` |  |
| `1` | `VSYNC_ENABLED` |  |
| `2` | `VSYNC_ADAPTIVE` |  |
| `3` | `VSYNC_MAILBOX` |  |

### `HandleType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `DISPLAY_HANDLE` |  |
| `1` | `WINDOW_HANDLE` |  |
| `2` | `WINDOW_VIEW` |  |
| `3` | `OPENGL_CONTEXT` |  |
| `4` | `EGL_DISPLAY` |  |
| `5` | `EGL_CONFIG` |  |
| `6` | `GLX_VISUALID` |  |
| `7` | `GLX_FBCONFIG` |  |

### `TTSUtteranceEvent`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `TTS_UTTERANCE_STARTED` |  |
| `1` | `TTS_UTTERANCE_ENDED` |  |
| `2` | `TTS_UTTERANCE_CANCELED` |  |
| `3` | `TTS_UTTERANCE_BOUNDARY` |  |

## 常量

- **`INVALID_SCREEN`** = `-1`
- **`SCREEN_WITH_MOUSE_FOCUS`** = `-4`
- **`SCREEN_WITH_KEYBOARD_FOCUS`** = `-3`
- **`SCREEN_PRIMARY`** = `-2`
- **`SCREEN_OF_MAIN_WINDOW`** = `-1`
- **`MAIN_WINDOW_ID`** = `0`
- **`INVALID_WINDOW_ID`** = `-1`
- **`INVALID_INDICATOR_ID`** = `-1`
