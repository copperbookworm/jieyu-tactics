# Window

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Window` → `Viewport` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Window.md`

**摘要**：Base class for all windows, dialogs, and popups.

## 描述

A node that creates a window. The window can either be a native system window or embedded inside another `Window` (see `Viewport.gui_embed_subwindows`).
		At runtime, `Window`s will not close automatically when requested. You need to handle it manually using the `close_requested` signal (this applies both to pressing the close button and clicking outside of a popup).

## 属性

- **`accessibility_description`** `String` = `""`
  - 其它属性：getter=get_accessibility_description · setter=set_accessibility_description
- **`accessibility_name`** `String` = `""`
  - 其它属性：getter=get_accessibility_name · setter=set_accessibility_name
- **`always_on_top`** `bool` = `false`
  - 其它属性：getter=get_flag · setter=set_flag
- **`auto_translate`** `bool`
  - 其它属性：deprecated=Use [member Node.auto_translate_mode] and [method Node.can_auto_translate] instead. · getter=is_auto_translating · setter=set_auto_translate
- **`borderless`** `bool` = `false`
  - 其它属性：getter=get_flag · setter=set_flag
- **`content_scale_aspect`** `int` = `0` · 枚举 `Window.ContentScaleAspect`
  - 其它属性：getter=get_content_scale_aspect · setter=set_content_scale_aspect
- **`content_scale_factor`** `float` = `1.0`
  - 其它属性：getter=get_content_scale_factor · setter=set_content_scale_factor
- **`content_scale_mode`** `int` = `0` · 枚举 `Window.ContentScaleMode`
  - 其它属性：getter=get_content_scale_mode · setter=set_content_scale_mode
- **`content_scale_size`** `Vector2i` = `Vector2i(0, 0)`
  - 其它属性：getter=get_content_scale_size · setter=set_content_scale_size
- **`content_scale_stretch`** `int` = `0` · 枚举 `Window.ContentScaleStretch`
  - 其它属性：getter=get_content_scale_stretch · setter=set_content_scale_stretch
- **`current_screen`** `int`
  - 其它属性：getter=get_current_screen · setter=set_current_screen
- **`exclude_from_capture`** `bool` = `false`
  - 其它属性：getter=get_flag · setter=set_flag
- **`exclusive`** `bool` = `false`
  - 其它属性：getter=is_exclusive · setter=set_exclusive
- **`extend_to_title`** `bool` = `false`
  - 其它属性：getter=get_flag · setter=set_flag
- **`force_native`** `bool` = `false`
  - 其它属性：getter=get_force_native · setter=set_force_native
- **`hdr_output_requested`** `bool` = `false`
  - 其它属性：getter=is_hdr_output_requested · setter=set_hdr_output_requested
- **`initial_position`** `int` = `0` · 枚举 `Window.WindowInitialPosition`
  - 其它属性：getter=get_initial_position · setter=set_initial_position
- **`keep_title_visible`** `bool` = `false`
  - 其它属性：getter=get_keep_title_visible · setter=set_keep_title_visible
- **`max_size`** `Vector2i` = `Vector2i(0, 0)`
  - 其它属性：getter=get_max_size · setter=set_max_size
- **`maximize_disabled`** `bool` = `false`
  - 其它属性：getter=get_flag · setter=set_flag
- **`min_size`** `Vector2i` = `Vector2i(0, 0)`
  - 其它属性：getter=get_min_size · setter=set_min_size
- **`minimize_disabled`** `bool` = `false`
  - 其它属性：getter=get_flag · setter=set_flag
- **`mode`** `int` = `0` · 枚举 `Window.Mode`
  - 其它属性：getter=get_mode · setter=set_mode
- **`mouse_passthrough`** `bool` = `false`
  - 其它属性：getter=get_flag · setter=set_flag
- **`mouse_passthrough_polygon`** `PackedVector2Array` = `PackedVector2Array()`
  - 其它属性：getter=get_mouse_passthrough_polygon · setter=set_mouse_passthrough_polygon
- **`nonclient_area`** `Rect2i` = `Rect2i(0, 0, 0, 0)`
  - 其它属性：getter=get_nonclient_area · setter=set_nonclient_area
- **`popup_window`** `bool` = `false`
  - 其它属性：getter=get_flag · setter=set_flag
- **`popup_wm_hint`** `bool` = `false`
  - 其它属性：getter=get_flag · setter=set_flag
- **`position`** `Vector2i` = `Vector2i(0, 0)`
  - 其它属性：getter=get_position · setter=set_position
- **`sharp_corners`** `bool` = `false`
  - 其它属性：getter=get_flag · setter=set_flag
- **`size`** `Vector2i` = `Vector2i(100, 100)`
  - 其它属性：getter=get_size · setter=set_size
- **`theme`** `Theme`
  - 其它属性：getter=get_theme · setter=set_theme
- **`theme_type_variation`** `StringName` = `&""`
  - 其它属性：getter=get_theme_type_variation · setter=set_theme_type_variation
- **`title`** `String` = `""`
  - 其它属性：getter=get_title · setter=set_title
- **`transient`** `bool` = `false`
  - 其它属性：getter=is_transient · setter=set_transient
- **`transient_to_focused`** `bool` = `false`
  - 其它属性：getter=is_transient_to_focused · setter=set_transient_to_focused
- **`transparent`** `bool` = `false`
  - 其它属性：getter=get_flag · setter=set_flag
- **`unfocusable`** `bool` = `false`
  - 其它属性：getter=get_flag · setter=set_flag
- **`unresizable`** `bool` = `false`
  - 其它属性：getter=get_flag · setter=set_flag
- **`visible`** `bool` = `true`
  - 其它属性：getter=is_visible · setter=set_visible
- **`wrap_controls`** `bool` = `false`
  - 其它属性：getter=is_wrapping_controls · setter=set_wrap_controls

## 方法

### `_get_contents_minimum_size() -> Vector2`
- 限定：qualifiers=virtual const

Virtual method to be implemented by the user. Overrides the value returned by `get_contents_minimum_size`.

### `add_theme_color_override(name: StringName, color: Color) -> void`

Creates a local override for a theme `Color` with the specified `name`. Local overrides always take precedence when fetching theme items for the control. An override can be removed with `remove_theme_color_override`.
				See also `get_theme_color` and `Control.add_theme_color_override` for more details.

### `add_theme_constant_override(name: StringName, constant: int) -> void`

Creates a local override for a theme constant with the specified `name`. Local overrides always take precedence when fetching theme items for the control. An override can be removed with `remove_theme_constant_override`.
				See also `get_theme_constant`.

### `add_theme_font_override(name: StringName, font: Font) -> void`

Creates a local override for a theme `Font` with the specified `name`. Local overrides always take precedence when fetching theme items for the control. An override can be removed with `remove_theme_font_override`.
				See also `get_theme_font`.

### `add_theme_font_size_override(name: StringName, font_size: int) -> void`

Creates a local override for a theme font size with the specified `name`. Local overrides always take precedence when fetching theme items for the control. An override can be removed with `remove_theme_font_size_override`.
				See also `get_theme_font_size`.

### `add_theme_icon_override(name: StringName, texture: Texture2D) -> void`

Creates a local override for a theme icon with the specified `name`. Local overrides always take precedence when fetching theme items for the control. An override can be removed with `remove_theme_icon_override`.
				See also `get_theme_icon`.

### `add_theme_stylebox_override(name: StringName, stylebox: StyleBox) -> void`

Creates a local override for a theme `StyleBox` with the specified `name`. Local overrides always take precedence when fetching theme items for the control. An override can be removed with `remove_theme_stylebox_override`.
				See also `get_theme_stylebox` and `Control.add_theme_stylebox_override` for more details.

### `begin_bulk_theme_override() -> void`

Prevents `*_theme_*_override` methods from emitting `NOTIFICATION_THEME_CHANGED` until `end_bulk_theme_override` is called.

### `can_draw() -> bool`
- 限定：qualifiers=const

Returns whether the window is being drawn to the screen.

### `child_controls_changed() -> void`

Requests an update of the `Window` size to fit underlying `Control` nodes.

### `end_bulk_theme_override() -> void`

Ends a bulk theme override update. See `begin_bulk_theme_override`.

### `get_contents_minimum_size() -> Vector2`
- 限定：qualifiers=const

Returns the combined minimum size from the child `Control` nodes of the window. Use `child_controls_changed` to update it when child nodes have changed.
				The value returned by this method can be overridden with `_get_contents_minimum_size`.

### `get_flag(flag: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the `flag` is set.

### `get_focused_window() -> Window`
- 限定：qualifiers=static

Returns the focused window.

### `get_layout_direction() -> int`
- 限定：qualifiers=const

Returns layout direction and text writing direction.

### `get_output_max_linear_value() -> float`
- 限定：qualifiers=const

Returns the maximum value for linear color components that can be displayed in this window, regardless of SDR or HDR output. Returns `1.0` if HDR is not enabled or not supported. The `output_max_linear_value_changed` signal will be emitted whenever this value changes.
				This value is used by tonemapping and other `Environment` effects to ensure that bright colors are presented in the range that can be displayed by this window. When using this maximum linear value in your project, it should only be used to present colors directly to the screen without tonemapping and without influencing lighting, post-processing effects, or surrounding color. The following is an example that produces the brightest purple color that the screen can produce:
				`codeblocks`
				`gdscript`
				func _process(_delta):
					# output_max_linear_value may change often, so do this every frame.
					var max_linear_value = get_window().get_output_max_linear_value()
					# Replace this with your color:
					var original_color = Color.PURPLE
					# Normalize to max_linear_value to produce the brightest color possible,
					# regardless of SDR or HDR output:
					var bright_color = normalize_color(original_color, max_linear_value)

				func normalize_color(srgb_color, max_linear_value = 1.0):
					# Color must be linear-encoded to use math operations.
					var linear_color = srgb_color.srgb_to_linear()
					var max_rgb_value = maxf(linear_color.r, maxf(linear_color.g, linear_color.b))
					var brightness_scale = max_linear_value / max_rgb_value
					linear_color *= brightness_scale
					# Undo changes to the alpha channel, which should not be modified.
					linear_color.a = srgb_color.a
					# Convert back to nonlinear sRGB encoding, which is required for Color in
					# Godot unless stated otherwise.
					return linear_color.linear_to_srgb()
				
				
				**Note:** You will need to convert sRGB colors to linear before multiplying by this value to get correct results.

### `get_position_with_decorations() -> Vector2i`
- 限定：qualifiers=const

Returns the window's position including its border.
				**Note:** If `visible` is `false`, this method returns the same value as `position`.

### `get_size_with_decorations() -> Vector2i`
- 限定：qualifiers=const

Returns the window's size including its border.
				**Note:** If `visible` is `false`, this method returns the same value as `size`.

### `get_theme_color(name: StringName, theme_type: StringName = &"") -> Color`
- 限定：qualifiers=const

Returns a `Color` from the first matching `Theme` in the tree if that `Theme` has a color item with the specified `name` and `theme_type`.
				See `Control.get_theme_color` for more details.

### `get_theme_constant(name: StringName, theme_type: StringName = &"") -> int`
- 限定：qualifiers=const

Returns a constant from the first matching `Theme` in the tree if that `Theme` has a constant item with the specified `name` and `theme_type`.
				See `Control.get_theme_color` for more details.

### `get_theme_default_base_scale() -> float`
- 限定：qualifiers=const

Returns the default base scale value from the first matching `Theme` in the tree if that `Theme` has a valid `Theme.default_base_scale` value.
				See `Control.get_theme_color` for details.

### `get_theme_default_font() -> Font`
- 限定：qualifiers=const

Returns the default font from the first matching `Theme` in the tree if that `Theme` has a valid `Theme.default_font` value.
				See `Control.get_theme_color` for details.

### `get_theme_default_font_size() -> int`
- 限定：qualifiers=const

Returns the default font size value from the first matching `Theme` in the tree if that `Theme` has a valid `Theme.default_font_size` value.
				See `Control.get_theme_color` for details.

### `get_theme_font(name: StringName, theme_type: StringName = &"") -> Font`
- 限定：qualifiers=const

Returns a `Font` from the first matching `Theme` in the tree if that `Theme` has a font item with the specified `name` and `theme_type`.
				See `Control.get_theme_color` for details.

### `get_theme_font_size(name: StringName, theme_type: StringName = &"") -> int`
- 限定：qualifiers=const

Returns a font size from the first matching `Theme` in the tree if that `Theme` has a font size item with the specified `name` and `theme_type`.
				See `Control.get_theme_color` for details.

### `get_theme_icon(name: StringName, theme_type: StringName = &"") -> Texture2D`
- 限定：qualifiers=const

Returns an icon from the first matching `Theme` in the tree if that `Theme` has an icon item with the specified `name` and `theme_type`.
				See `Control.get_theme_color` for details.

### `get_theme_stylebox(name: StringName, theme_type: StringName = &"") -> StyleBox`
- 限定：qualifiers=const

Returns a `StyleBox` from the first matching `Theme` in the tree if that `Theme` has a stylebox item with the specified `name` and `theme_type`.
				See `Control.get_theme_color` for details.

### `get_window_id() -> int`
- 限定：qualifiers=const

Returns the ID of the window.

### `grab_focus() -> void`

Causes the window to grab focus, allowing it to receive user input.

### `has_focus() -> bool`
- 限定：qualifiers=const

Returns `true` if the window is focused.

### `has_theme_color(name: StringName, theme_type: StringName = &"") -> bool`
- 限定：qualifiers=const

Returns `true` if there is a matching `Theme` in the tree that has a color item with the specified `name` and `theme_type`.
				See `Control.get_theme_color` for details.

### `has_theme_color_override(name: StringName) -> bool`
- 限定：qualifiers=const

Returns `true` if there is a local override for a theme `Color` with the specified `name` in this `Control` node.
				See `add_theme_color_override`.

### `has_theme_constant(name: StringName, theme_type: StringName = &"") -> bool`
- 限定：qualifiers=const

Returns `true` if there is a matching `Theme` in the tree that has a constant item with the specified `name` and `theme_type`.
				See `Control.get_theme_color` for details.

### `has_theme_constant_override(name: StringName) -> bool`
- 限定：qualifiers=const

Returns `true` if there is a local override for a theme constant with the specified `name` in this `Control` node.
				See `add_theme_constant_override`.

### `has_theme_font(name: StringName, theme_type: StringName = &"") -> bool`
- 限定：qualifiers=const

Returns `true` if there is a matching `Theme` in the tree that has a font item with the specified `name` and `theme_type`.
				See `Control.get_theme_color` for details.

### `has_theme_font_override(name: StringName) -> bool`
- 限定：qualifiers=const

Returns `true` if there is a local override for a theme `Font` with the specified `name` in this `Control` node.
				See `add_theme_font_override`.

### `has_theme_font_size(name: StringName, theme_type: StringName = &"") -> bool`
- 限定：qualifiers=const

Returns `true` if there is a matching `Theme` in the tree that has a font size item with the specified `name` and `theme_type`.
				See `Control.get_theme_color` for details.

### `has_theme_font_size_override(name: StringName) -> bool`
- 限定：qualifiers=const

Returns `true` if there is a local override for a theme font size with the specified `name` in this `Control` node.
				See `add_theme_font_size_override`.

### `has_theme_icon(name: StringName, theme_type: StringName = &"") -> bool`
- 限定：qualifiers=const

Returns `true` if there is a matching `Theme` in the tree that has an icon item with the specified `name` and `theme_type`.
				See `Control.get_theme_color` for details.

### `has_theme_icon_override(name: StringName) -> bool`
- 限定：qualifiers=const

Returns `true` if there is a local override for a theme icon with the specified `name` in this `Control` node.
				See `add_theme_icon_override`.

### `has_theme_stylebox(name: StringName, theme_type: StringName = &"") -> bool`
- 限定：qualifiers=const

Returns `true` if there is a matching `Theme` in the tree that has a stylebox item with the specified `name` and `theme_type`.
				See `Control.get_theme_color` for details.

### `has_theme_stylebox_override(name: StringName) -> bool`
- 限定：qualifiers=const

Returns `true` if there is a local override for a theme `StyleBox` with the specified `name` in this `Control` node.
				See `add_theme_stylebox_override`.

### `hide() -> void`

Hides the window. This is not the same as minimized state. Hidden window can't be interacted with and needs to be made visible with `show`.

### `is_embedded() -> bool`
- 限定：qualifiers=const

Returns `true` if the window is currently embedded in another window.

### `is_layout_rtl() -> bool`
- 限定：qualifiers=const

Returns `true` if the layout is right-to-left.

### `is_maximize_allowed() -> bool`
- 限定：qualifiers=const

Returns `true` if the window can be maximized (the maximize button is enabled).

### `is_using_font_oversampling() -> bool`
- 限定：qualifiers=const

Returns `true` if font oversampling is enabled. See `set_use_font_oversampling`.

### `move_to_center() -> void`

Centers the window in the current screen. If the window is embedded, it is centered in the embedder `Viewport` instead.

### `move_to_foreground() -> void`
- 限定：deprecated=Use [method Window.grab_focus] instead.

Causes the window to grab focus, allowing it to receive user input.

### `popup(rect: Rect2i = Rect2i(0, 0, 0, 0)) -> void`

Shows the `Window` and makes it transient (see `transient`). If `rect` is provided, it will be set as the `Window`'s size. Fails if called on the main window.
				If `ProjectSettings.display/window/subwindows/embed_subwindows` is `true` (single-window mode), `rect`'s coordinates are global and relative to the main window's top-left corner (excluding window decorations). If `rect`'s position coordinates are negative, the window will be located outside the main window and may not be visible as a result.
				If `ProjectSettings.display/window/subwindows/embed_subwindows` is `false` (multi-window mode), `rect`'s coordinates are global and relative to the top-left corner of the leftmost screen. If `rect`'s position coordinates are negative, the window will be placed at the top-left corner of the screen.
				**Note:** `rect` must be in global coordinates if specified.

### `popup_centered(minsize: Vector2i = Vector2i(0, 0)) -> void`

Popups the `Window` at the center of the current screen, with optionally given minimum size. If the `Window` is embedded, it will be centered in the parent `Viewport` instead.
				**Note:** Calling it with the default value of `minsize` is equivalent to calling it with `size`.

### `popup_centered_clamped(minsize: Vector2i = Vector2i(0, 0), fallback_ratio: float = 0.75) -> void`
- 限定：keywords=minsize

Popups the `Window` centered inside its parent `Window`. `fallback_ratio` determines the maximum size of the `Window`, in relation to its parent.
				**Note:** Calling it with the default value of `minsize` is equivalent to calling it with `size`.

### `popup_centered_ratio(ratio: float = 0.8) -> void`

If `Window` is embedded, popups the `Window` centered inside its embedder and sets its size as a `ratio` of embedder's size.
				If `Window` is a native window, popups the `Window` centered inside the screen of its parent `Window` and sets its size as a `ratio` of the screen size.

### `popup_exclusive(from_node: Node, rect: Rect2i = Rect2i(0, 0, 0, 0)) -> void`

Attempts to parent this dialog to the last exclusive window relative to `from_node`, and then calls `Window.popup` on it. The dialog must have no current parent, otherwise the method fails.
				See also `set_unparent_when_invisible` and `Node.get_last_exclusive_window`.

### `popup_exclusive_centered(from_node: Node, minsize: Vector2i = Vector2i(0, 0)) -> void`

Attempts to parent this dialog to the last exclusive window relative to `from_node`, and then calls `Window.popup_centered` on it. The dialog must have no current parent, otherwise the method fails.
				See also `set_unparent_when_invisible` and `Node.get_last_exclusive_window`.

### `popup_exclusive_centered_clamped(from_node: Node, minsize: Vector2i = Vector2i(0, 0), fallback_ratio: float = 0.75) -> void`
- 限定：keywords=minsize

Attempts to parent this dialog to the last exclusive window relative to `from_node`, and then calls `Window.popup_centered_clamped` on it. The dialog must have no current parent, otherwise the method fails.
				See also `set_unparent_when_invisible` and `Node.get_last_exclusive_window`.

### `popup_exclusive_centered_ratio(from_node: Node, ratio: float = 0.8) -> void`

Attempts to parent this dialog to the last exclusive window relative to `from_node`, and then calls `Window.popup_centered_ratio` on it. The dialog must have no current parent, otherwise the method fails.
				See also `set_unparent_when_invisible` and `Node.get_last_exclusive_window`.

### `popup_exclusive_on_parent(from_node: Node, parent_rect: Rect2i) -> void`

Attempts to parent this dialog to the last exclusive window relative to `from_node`, and then calls `Window.popup_on_parent` on it. The dialog must have no current parent, otherwise the method fails.
				See also `set_unparent_when_invisible` and `Node.get_last_exclusive_window`.

### `popup_on_parent(parent_rect: Rect2i) -> void`

Popups the `Window` with a position shifted by parent `Window`'s position. If the `Window` is embedded, has the same effect as `popup`.

### `remove_theme_color_override(name: StringName) -> void`

Removes a local override for a theme `Color` with the specified `name` previously added by `add_theme_color_override` or via the Inspector dock.

### `remove_theme_constant_override(name: StringName) -> void`

Removes a local override for a theme constant with the specified `name` previously added by `add_theme_constant_override` or via the Inspector dock.

### `remove_theme_font_override(name: StringName) -> void`

Removes a local override for a theme `Font` with the specified `name` previously added by `add_theme_font_override` or via the Inspector dock.

### `remove_theme_font_size_override(name: StringName) -> void`

Removes a local override for a theme font size with the specified `name` previously added by `add_theme_font_size_override` or via the Inspector dock.

### `remove_theme_icon_override(name: StringName) -> void`

Removes a local override for a theme icon with the specified `name` previously added by `add_theme_icon_override` or via the Inspector dock.

### `remove_theme_stylebox_override(name: StringName) -> void`

Removes a local override for a theme `StyleBox` with the specified `name` previously added by `add_theme_stylebox_override` or via the Inspector dock.

### `request_attention() -> void`

Tells the OS that the `Window` needs an attention. This makes the window stand out in some way depending on the system, e.g. it might blink on the task bar.

### `reset_size() -> void`

Resets the size to the minimum size, which is the max of `min_size` and (if `wrap_controls` is enabled) `get_contents_minimum_size`. This is equivalent to calling `set_size(Vector2i())` (or any size below the minimum).

### `set_flag(flag: int, enabled: bool) -> void`

Sets a specified window flag.

### `set_ime_active(active: bool) -> void`

If `active` is `true`, enables system's native IME (Input Method Editor).

### `set_ime_position(position: Vector2i) -> void`

Moves IME to the given position.

### `set_layout_direction(direction: int) -> void`

Sets layout direction and text writing direction. Right-to-left layouts are necessary for certain languages (e.g. Arabic and Hebrew).

### `set_taskbar_progress_state(state: int) -> void`

Sets the type and state of the progress bar on the taskbar/dock icon of the `Window`. See `DisplayServer.ProgressState` for possible values and how each mode behaves.
				**Note:** This method is implemented only on Windows and macOS.

### `set_taskbar_progress_value(value: float) -> void`

Creates a progress bar on the taskbar/dock icon of the `Window` if it does not exist, sets the progress of the icon.
				`value` acts as a relative percentage value, ranges from `0.0` (lowest) to `1.0` (highest).
				**Note:** This method is implemented only on Windows and macOS.

### `set_unparent_when_invisible(unparent: bool) -> void`

If `unparent` is `true`, the window is automatically unparented when going invisible.
				**Note:** Make sure to keep a reference to the node, otherwise it will be orphaned. You also need to manually call `Node.queue_free` to free the window if it's not parented.

### `set_use_font_oversampling(enable: bool) -> void`

Enables font oversampling. This makes fonts look better when they are scaled up.

### `show() -> void`

Makes the `Window` appear. This enables interactions with the `Window` and doesn't change any of its property other than visibility (unlike e.g. `popup`).

### `start_drag() -> void`

Starts an interactive drag operation on the window, using the current mouse position. Call this method when handling a mouse button being pressed to simulate a pressed event on the window's title bar. Using this method allows the window to participate in space switching, tiling, and other system features.

### `start_resize(edge: int) -> void`

Starts an interactive resize operation on the window, using the current mouse position. Call this method when handling a mouse button being pressed to simulate a pressed event on the window's edge.

## 信号

### `about_to_popup()`

Emitted right after `popup` call, before the `Window` appears or does anything.

### `close_requested()`

Emitted when the `Window`'s close button is pressed or when `popup_window` is enabled and user clicks outside the window.
				This signal can be used to handle window closing, e.g. by connecting it to `hide`.

### `dpi_changed()`

Emitted when the `Window`'s DPI changes as a result of OS-level changes (e.g. moving the window from a Retina display to a lower resolution one).
				**Note:** Only implemented on macOS and Linux (Wayland).

### `files_dropped(files: PackedStringArray)`

Emitted when files are dragged from the OS file manager and dropped in the game window. The argument is a list of file paths.
				
```gdscript
				func _ready():
					get_window().files_dropped.connect(on_files_dropped)

				func on_files_dropped(files):
					print(files)
				
```

				**Note:** This signal only works with native windows, i.e. the main window and `Window`-derived nodes when `Viewport.gui_embed_subwindows` is disabled in the main viewport.

### `focus_entered()`

Emitted when the `Window` gains focus.

### `focus_exited()`

Emitted when the `Window` loses its focus.

### `go_back_requested()`

Emitted when a go back request is sent (e.g. pressing the "Back" button on Android), right after `Node.NOTIFICATION_WM_GO_BACK_REQUEST`.

### `mouse_entered()`

Emitted when the mouse cursor enters the `Window`'s visible area, that is not occluded behind other `Control`s or windows, provided its `Viewport.gui_disable_input` is `false` and regardless if it's currently focused or not.

### `mouse_exited()`

Emitted when the mouse cursor leaves the `Window`'s visible area, that is not occluded behind other `Control`s or windows, provided its `Viewport.gui_disable_input` is `false` and regardless if it's currently focused or not.

### `nonclient_window_input(event: InputEvent)`

Emitted when the mouse event is received by the custom decoration area defined by `nonclient_area`, and normal input to the window is blocked (such as when it has an exclusive child opened). `event`'s position is in the embedder's coordinate system.

### `output_max_linear_value_changed(output_max_linear_value: float)`

Emitted when the output max linear value returned by `Window.get_output_max_linear_value` has changed. This occurs when HDR output is enabled or disabled and when any HDR output luminance values of the window have changed, such as when the player adjusts their screen brightness setting or moves the window to a different screen. `output_max_linear_value` is the new value.

### `theme_changed()`

Emitted when the `NOTIFICATION_THEME_CHANGED` notification is sent.

### `title_changed()`

Emitted when window title bar text is changed.

### `titlebar_changed()`

Emitted when window title bar decorations are changed, e.g. macOS window enter/exit full screen mode, or extend-to-title flag is changed.

### `visibility_changed()`

Emitted when `Window` is made visible or disappears.

### `window_input(event: InputEvent)`

Emitted when the `Window` is currently focused and receives any input, passing the received event as an argument. The event's position, if present, is in the embedder's coordinate system.

## 枚举

### `Mode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `MODE_WINDOWED` |  |
| `1` | `MODE_MINIMIZED` |  |
| `2` | `MODE_MAXIMIZED` |  |
| `3` | `MODE_FULLSCREEN` |  |
| `4` | `MODE_EXCLUSIVE_FULLSCREEN` |  |

### `Flags`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `FLAG_RESIZE_DISABLED` |  |
| `1` | `FLAG_BORDERLESS` |  |
| `2` | `FLAG_ALWAYS_ON_TOP` |  |
| `3` | `FLAG_TRANSPARENT` |  |
| `4` | `FLAG_NO_FOCUS` |  |
| `5` | `FLAG_POPUP` |  |
| `6` | `FLAG_EXTEND_TO_TITLE` |  |
| `7` | `FLAG_MOUSE_PASSTHROUGH` |  |
| `8` | `FLAG_SHARP_CORNERS` |  |
| `9` | `FLAG_EXCLUDE_FROM_CAPTURE` |  |
| `10` | `FLAG_POPUP_WM_HINT` |  |
| `11` | `FLAG_MINIMIZE_DISABLED` |  |
| `12` | `FLAG_MAXIMIZE_DISABLED` |  |
| `13` | `FLAG_MAX` |  |

### `ContentScaleMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `CONTENT_SCALE_MODE_DISABLED` |  |
| `1` | `CONTENT_SCALE_MODE_CANVAS_ITEMS` |  |
| `2` | `CONTENT_SCALE_MODE_VIEWPORT` |  |

### `ContentScaleAspect`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `CONTENT_SCALE_ASPECT_IGNORE` |  |
| `1` | `CONTENT_SCALE_ASPECT_KEEP` |  |
| `2` | `CONTENT_SCALE_ASPECT_KEEP_WIDTH` |  |
| `3` | `CONTENT_SCALE_ASPECT_KEEP_HEIGHT` |  |
| `4` | `CONTENT_SCALE_ASPECT_EXPAND` |  |

### `ContentScaleStretch`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `CONTENT_SCALE_STRETCH_FRACTIONAL` |  |
| `1` | `CONTENT_SCALE_STRETCH_INTEGER` |  |

### `LayoutDirection`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `LAYOUT_DIRECTION_INHERITED` |  |
| `1` | `LAYOUT_DIRECTION_APPLICATION_LOCALE` |  |
| `2` | `LAYOUT_DIRECTION_LTR` |  |
| `3` | `LAYOUT_DIRECTION_RTL` |  |
| `4` | `LAYOUT_DIRECTION_SYSTEM_LOCALE` |  |
| `5` | `LAYOUT_DIRECTION_MAX` |  |
| `1` | `LAYOUT_DIRECTION_LOCALE` |  |

### `WindowInitialPosition`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `WINDOW_INITIAL_POSITION_ABSOLUTE` |  |
| `1` | `WINDOW_INITIAL_POSITION_CENTER_PRIMARY_SCREEN` |  |
| `2` | `WINDOW_INITIAL_POSITION_CENTER_MAIN_WINDOW_SCREEN` |  |
| `3` | `WINDOW_INITIAL_POSITION_CENTER_OTHER_SCREEN` |  |
| `4` | `WINDOW_INITIAL_POSITION_CENTER_SCREEN_WITH_MOUSE_FOCUS` |  |
| `5` | `WINDOW_INITIAL_POSITION_CENTER_SCREEN_WITH_KEYBOARD_FOCUS` |  |

## 常量

- **`NOTIFICATION_VISIBILITY_CHANGED`** = `30`
- **`NOTIFICATION_THEME_CHANGED`** = `32`
## 主题属性

### `title_color`
- data_type=color · default=Color(0.875, 0.875, 0.875, 1) · type=Color

### `title_outline_modulate`
- data_type=color · default=Color(0, 0, 0, 1) · type=Color

### `close_h_offset`
- data_type=constant · default=18 · type=int

### `close_v_offset`
- data_type=constant · default=24 · type=int

### `resize_margin`
- data_type=constant · default=4 · type=int

### `title_height`
- data_type=constant · default=36 · type=int

### `title_outline_size`
- data_type=constant · default=0 · type=int

### `title_font`
- data_type=font · type=Font

### `title_font_size`
- data_type=font_size · type=int

### `close`
- data_type=icon · type=Texture2D

### `close_pressed`
- data_type=icon · type=Texture2D

### `embedded_border`
- data_type=style · type=StyleBox

### `embedded_unfocused_border`
- data_type=style · type=StyleBox

## 教程链接

- [HDR output](None)
- [Multiple Windows demo](None)

