# Control

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Control.md`

**摘要**：Base class for all GUI controls. Adapts its position and size based on its parent control.

## 描述

Base class for all UI-related nodes. `Control` features a bounding rectangle that defines its extents, an anchor position relative to its parent control or the current viewport, and offsets relative to the anchor. The offsets update automatically when the node, any of its parents, or the screen size change.
		For more information on Godot's UI system, anchors, offsets, and containers, see the related tutorials in the manual. To build flexible UIs, you'll need a mix of UI elements that inherit from `Control` and `Container` nodes.
		**Note:** Since both `Node2D` and `Control` inherit from `CanvasItem`, they share several concepts from the class such as the `CanvasItem.z_index` and `CanvasItem.visible` properties.
		**User Interface nodes and input**
		Godot propagates input events via viewports. Each `Viewport` is responsible for propagating `InputEvent`s to their child nodes. As the `SceneTree.root` is a `Window`, this already happens automatically for all UI elements in your game.
		Input events are propagated through the `SceneTree` from the root node to all child nodes by calling `Node._input`. For UI elements specifically, it makes more sense to override the virtual method `_gui_input`, which filters out unrelated input events, such as by checking z-order, `mouse_filter`, focus, or if the event was inside of the control's bounding box.
		Call `accept_event` so no other node receives the event. Once you accept an input, it becomes handled so `Node._unhandled_input` will not process it.
		Only one `Control` node can be in focus. Only the node in focus will receive events. To get the focus, call `grab_focus`. `Control` nodes lose focus when another node grabs it, or if you hide the node in focus. Focus will not be represented visually if gained via mouse/touch input, only appearing with keyboard/gamepad input (for accessibility), or via `grab_focus`.
		Set `mouse_filter` to `MOUSE_FILTER_IGNORE` to tell a `Control` node to ignore mouse or touch events. You'll need it if you place an icon on top of a button.
		`Theme` resources change the control's appearance. The `theme` of a `Control` node affects all of its direct and indirect children (as long as a chain of controls is uninterrupted). To override some of the theme items, call one of the `add_theme_*_override` methods, like `add_theme_font_override`. You can also override theme items in the Inspector.
		**Note:** Theme items are *not* `Object` properties. This means you can't access their values using `Object.get` and `Object.set`. Instead, use the `get_theme_*` and `add_theme_*_override` methods provided by this class.

## 属性

- **`accessibility_controls_nodes`** `NodePath[]` = `[]`
  - 其它属性：getter=get_accessibility_controls_nodes · setter=set_accessibility_controls_nodes
- **`accessibility_described_by_nodes`** `NodePath[]` = `[]`
  - 其它属性：getter=get_accessibility_described_by_nodes · setter=set_accessibility_described_by_nodes
- **`accessibility_description`** `String` = `""`
  - 其它属性：getter=get_accessibility_description · setter=set_accessibility_description
- **`accessibility_flow_to_nodes`** `NodePath[]` = `[]`
  - 其它属性：getter=get_accessibility_flow_to_nodes · setter=set_accessibility_flow_to_nodes
- **`accessibility_labeled_by_nodes`** `NodePath[]` = `[]`
  - 其它属性：getter=get_accessibility_labeled_by_nodes · setter=set_accessibility_labeled_by_nodes
- **`accessibility_live`** `int` = `0` · 枚举 `AccessibilityServer.AccessibilityLiveMode`
  - 其它属性：getter=get_accessibility_live · setter=set_accessibility_live
- **`accessibility_name`** `String` = `""`
  - 其它属性：getter=get_accessibility_name · setter=set_accessibility_name
- **`anchor_bottom`** `float` = `0.0`
  - 其它属性：getter=get_anchor · setter=_set_anchor
- **`anchor_left`** `float` = `0.0`
  - 其它属性：getter=get_anchor · setter=_set_anchor
- **`anchor_right`** `float` = `0.0`
  - 其它属性：getter=get_anchor · setter=_set_anchor
- **`anchor_top`** `float` = `0.0`
  - 其它属性：getter=get_anchor · setter=_set_anchor
- **`auto_translate`** `bool`
  - 其它属性：deprecated=Use [member Node.auto_translate_mode] and [method Node.can_auto_translate] instead. · getter=is_auto_translating · setter=set_auto_translate
- **`clip_contents`** `bool` = `false`
  - 其它属性：getter=is_clipping_contents · setter=set_clip_contents
- **`custom_maximum_size`** `Vector2` = `Vector2(-1, -1)`
  - 其它属性：getter=get_custom_maximum_size · setter=set_custom_maximum_size
- **`custom_minimum_size`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_custom_minimum_size · setter=set_custom_minimum_size
- **`focus_behavior_recursive`** `int` = `0` · 枚举 `Control.FocusBehaviorRecursive`
  - 其它属性：getter=get_focus_behavior_recursive · setter=set_focus_behavior_recursive
- **`focus_mode`** `int` = `0` · 枚举 `Control.FocusMode`
  - 其它属性：getter=get_focus_mode · setter=set_focus_mode
- **`focus_neighbor_bottom`** `NodePath` = `NodePath("")`
  - 其它属性：getter=get_focus_neighbor · keywords=focus_neighbour_bottom · setter=set_focus_neighbor
- **`focus_neighbor_left`** `NodePath` = `NodePath("")`
  - 其它属性：getter=get_focus_neighbor · keywords=focus_neighbour_left · setter=set_focus_neighbor
- **`focus_neighbor_right`** `NodePath` = `NodePath("")`
  - 其它属性：getter=get_focus_neighbor · keywords=focus_neighbour_right · setter=set_focus_neighbor
- **`focus_neighbor_top`** `NodePath` = `NodePath("")`
  - 其它属性：getter=get_focus_neighbor · keywords=focus_neighbour_top · setter=set_focus_neighbor
- **`focus_next`** `NodePath` = `NodePath("")`
  - 其它属性：getter=get_focus_next · setter=set_focus_next
- **`focus_previous`** `NodePath` = `NodePath("")`
  - 其它属性：getter=get_focus_previous · setter=set_focus_previous
- **`global_position`** `Vector2`
  - 其它属性：getter=get_global_position · setter=_set_global_position
- **`grow_horizontal`** `int` = `1` · 枚举 `Control.GrowDirection`
  - 其它属性：getter=get_h_grow_direction · setter=set_h_grow_direction
- **`grow_vertical`** `int` = `1` · 枚举 `Control.GrowDirection`
  - 其它属性：getter=get_v_grow_direction · setter=set_v_grow_direction
- **`layout_direction`** `int` = `0` · 枚举 `Control.LayoutDirection`
  - 其它属性：getter=get_layout_direction · setter=set_layout_direction
- **`localize_numeral_system`** `bool` = `true`
  - 其它属性：getter=is_localizing_numeral_system · setter=set_localize_numeral_system
- **`mouse_behavior_recursive`** `int` = `0` · 枚举 `Control.MouseBehaviorRecursive`
  - 其它属性：getter=get_mouse_behavior_recursive · setter=set_mouse_behavior_recursive
- **`mouse_default_cursor_shape`** `int` = `0` · 枚举 `Control.CursorShape`
  - 其它属性：getter=get_default_cursor_shape · setter=set_default_cursor_shape
- **`mouse_filter`** `int` = `0` · 枚举 `Control.MouseFilter`
  - 其它属性：getter=get_mouse_filter · setter=set_mouse_filter
- **`mouse_force_pass_scroll_events`** `bool` = `true`
  - 其它属性：getter=is_force_pass_scroll_events · setter=set_force_pass_scroll_events
- **`offset_bottom`** `float` = `0.0`
  - 其它属性：getter=get_offset · setter=set_offset
- **`offset_left`** `float` = `0.0`
  - 其它属性：getter=get_offset · setter=set_offset
- **`offset_right`** `float` = `0.0`
  - 其它属性：getter=get_offset · setter=set_offset
- **`offset_top`** `float` = `0.0`
  - 其它属性：getter=get_offset · setter=set_offset
- **`offset_transform_enabled`** `bool` = `false`
  - 其它属性：getter=is_offset_transform_enabled · setter=set_offset_transform_enabled
- **`offset_transform_pivot`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_offset_transform_pivot · setter=set_offset_transform_pivot
- **`offset_transform_pivot_ratio`** `Vector2` = `Vector2(0.5, 0.5)`
  - 其它属性：getter=get_offset_transform_pivot_ratio · setter=set_offset_transform_pivot_ratio
- **`offset_transform_position`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_offset_transform_position · setter=set_offset_transform_position
- **`offset_transform_position_ratio`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_offset_transform_position_ratio · setter=set_offset_transform_position_ratio
- **`offset_transform_rotation`** `float` = `0.0`
  - 其它属性：getter=get_offset_transform_rotation · setter=set_offset_transform_rotation
- **`offset_transform_scale`** `Vector2` = `Vector2(1, 1)`
  - 其它属性：getter=get_offset_transform_scale · setter=set_offset_transform_scale
- **`offset_transform_visual_only`** `bool` = `true`
  - 其它属性：getter=is_offset_transform_visual_only · setter=set_offset_transform_visual_only
- **`physics_interpolation_mode`** `int` = `2` · 枚举 `Node.PhysicsInterpolationMode`
  - 其它属性：getter=get_physics_interpolation_mode · overrides=Node · setter=set_physics_interpolation_mode
- **`pivot_offset`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_pivot_offset · setter=set_pivot_offset
- **`pivot_offset_ratio`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_pivot_offset_ratio · setter=set_pivot_offset_ratio
- **`position`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_position · setter=_set_position
- **`propagate_maximum_size`** `bool` = `false`
  - 其它属性：getter=is_propagating_maximum_size · setter=set_propagate_maximum_size
- **`rotation`** `float` = `0.0`
  - 其它属性：getter=get_rotation · setter=set_rotation
- **`rotation_degrees`** `float`
  - 其它属性：getter=get_rotation_degrees · setter=set_rotation_degrees
- **`scale`** `Vector2` = `Vector2(1, 1)`
  - 其它属性：getter=get_scale · setter=set_scale
- **`shortcut_context`** `Node`
  - 其它属性：getter=get_shortcut_context · setter=set_shortcut_context
- **`size`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_size · setter=_set_size
- **`size_flags_horizontal`** `int` = `1` · 枚举 `Control.SizeFlags` · 位标志
  - 其它属性：getter=get_h_size_flags · is_bitfield=true · setter=set_h_size_flags
- **`size_flags_stretch_ratio`** `float` = `1.0`
  - 其它属性：getter=get_stretch_ratio · setter=set_stretch_ratio
- **`size_flags_vertical`** `int` = `1` · 枚举 `Control.SizeFlags` · 位标志
  - 其它属性：getter=get_v_size_flags · is_bitfield=true · setter=set_v_size_flags
- **`theme`** `Theme`
  - 其它属性：getter=get_theme · setter=set_theme
- **`theme_type_variation`** `StringName` = `&""`
  - 其它属性：getter=get_theme_type_variation · setter=set_theme_type_variation
- **`tooltip_auto_translate_mode`** `int` = `0` · 枚举 `Node.AutoTranslateMode`
  - 其它属性：getter=get_tooltip_auto_translate_mode · setter=set_tooltip_auto_translate_mode
- **`tooltip_text`** `String` = `""`
  - 其它属性：getter=get_tooltip_text · setter=set_tooltip_text
- **`translation_context`** `StringName` = `&""`
  - 其它属性：getter=get_translation_context · setter=set_translation_context

## 方法

### `_accessibility_get_contextual_info() -> String`
- 限定：qualifiers=virtual const

Return the description of the keyboard shortcuts and other contextual help for this control.

### `_can_drop_data(at_position: Vector2, data: Variant) -> bool`
- 限定：qualifiers=virtual const

Godot calls this method to test if `data` from a control's `_get_drag_data` can be dropped at `at_position`. `at_position` is local to this control.
				This method should only be used to test the data. Process the data in `_drop_data`.
				**Note:** If the drag was initiated by a keyboard shortcut or `accessibility_drag`, `at_position` is set to `Vector2.INF`, and the currently selected item/text position should be used as the drop position.
				`codeblocks`
				`gdscript`
				func _can_drop_data(position, data):
					# Check position if it is relevant to you
					# Otherwise, just check data
					return typeof(data) == TYPE_DICTIONARY and data.has("expected")
				
				`csharp`
				public override bool _CanDropData(Vector2 atPosition, Variant data)
				{
					// Check position if it is relevant to you
					// Otherwise, just check data
					return data.VariantType == Variant.Type.Dictionary && data.AsGodotDictionary().ContainsKey("expected");
				}

### `_drop_data(at_position: Vector2, data: Variant) -> void`
- 限定：qualifiers=virtual

Godot calls this method to pass you the `data` from a control's `_get_drag_data` result. Godot first calls `_can_drop_data` to test if `data` is allowed to drop at `at_position` where `at_position` is local to this control.
				**Note:** If the drag was initiated by a keyboard shortcut or `accessibility_drag`, `at_position` is set to `Vector2.INF`, and the currently selected item/text position should be used as the drop position.
				`codeblocks`
				`gdscript`
				func _can_drop_data(position, data):
					return typeof(data) == TYPE_DICTIONARY and data.has("color")

				func _drop_data(position, data):
					var color = data["color"]
				
				`csharp`
				public override bool _CanDropData(Vector2 atPosition, Variant data)
				{
					return data.VariantType == Variant.Type.Dictionary && data.AsGodotDictionary().ContainsKey("color");
				}

				public override void _DropData(Vector2 atPosition, Variant data)
				{
					Color color = data.AsGodotDictionary()["color"].AsColor();
				}

### `_get_accessibility_container_name(node: Node) -> String`
- 限定：qualifiers=virtual const

Override this method to return a human-readable description of the position of the child `node` in the custom container, added to the `accessibility_name`.

### `_get_cursor_shape(at_position: Vector2) -> int`
- 限定：qualifiers=virtual const

Virtual method to be implemented by the user. Returns the cursor shape for the position `at_position` in the control's local coordinates, which will typically be used while hovering over this control. See `get_cursor_shape`.
				If not overridden, defaults to `mouse_default_cursor_shape`.

### `_get_drag_data(at_position: Vector2) -> Variant`
- 限定：qualifiers=virtual

Godot calls this method to get data that can be dragged and dropped onto controls that expect drop data. Returns `null` if there is no data to drag. Controls that want to receive drop data should implement `_can_drop_data` and `_drop_data`. `at_position` is local to this control. Drag may be forced with `force_drag`.
				A preview that will follow the mouse that should represent the data can be set with `set_drag_preview`. A good time to set the preview is in this method.
				**Note:** If the drag was initiated by a keyboard shortcut or `accessibility_drag`, `at_position` is set to `Vector2.INF`, and the currently selected item/text position should be used as the drag position.
				`codeblocks`
				`gdscript`
				func _get_drag_data(position):
					var mydata = make_data() # This is your custom method generating the drag data.
					set_drag_preview(make_preview(mydata)) # This is your custom method generating the preview of the drag data.
					return mydata
				
				`csharp`
				public override Variant _GetDragData(Vector2 atPosition)
				{
					var myData = MakeData(); // This is your custom method generating the drag data.
					SetDragPreview(MakePreview(myData)); // This is your custom method generating the preview of the drag data.
					return myData;
				}

### `_get_maximum_size() -> Vector2`
- 限定：qualifiers=virtual const

Virtual method to be implemented by the user. Returns the maximum size for this control. Alternative to `custom_maximum_size` for controlling maximum size via code. The actual maximum size will be the max value of these two (in each axis separately).
				If not overridden, defaults to `Vector2.ZERO`.
				**Note:** This method will not be called when the script is attached to a `Control` node that already overrides its maximum size (e.g. `ScrollContainer`).
				**Note:** It is recommended to use `get_bound_minimum_size` instead of `get_combined_minimum_size` when implementing this method, as the former respects maximum size limits when calculating the minimum size, while the latter does not.

### `_get_minimum_size() -> Vector2`
- 限定：qualifiers=virtual const

Virtual method to be implemented by the user. Returns the minimum size for this control. Alternative to `custom_minimum_size` for controlling minimum size via code. The actual minimum size will be the max value of these two (in each axis separately).
				If not overridden, defaults to `Vector2.ZERO`.
				**Note:** This method will not be called when the script is attached to a `Control` node that already overrides its minimum size (e.g. `Label`, `Button`, `PanelContainer` etc.). It can only be used with most basic GUI nodes, like `Control`, `Container`, `Panel` etc.

### `_get_tooltip(at_position: Vector2) -> String`
- 限定：qualifiers=virtual const

Virtual method to be implemented by the user. Returns the tooltip text for the position `at_position` in the control's local coordinates, which will typically appear when the cursor is resting over this control. See `get_tooltip`.
				**Note:** If this method returns an empty `String` and `_make_custom_tooltip` is not overridden, no tooltip is displayed.

### `_get_tooltip_auto_translate_mode_at(at_position: Vector2) -> int`
- 限定：qualifiers=virtual const

Return the auto-translation mode at the given `at_position`. If not implemented, the `tooltip_auto_translate_mode` property will be used instead.

### `_gui_input(event: InputEvent) -> void`
- 限定：qualifiers=virtual

Virtual method to be implemented by the user. Override this method to handle and accept inputs on UI elements. See also `accept_event`.
				**Example:** Click on the control to print a message:
				`codeblocks`
				`gdscript`
				func _gui_input(event):
					if event is InputEventMouseButton:
						if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
							print("I've been clicked D:")
				
				`csharp`
				public override void _GuiInput(InputEvent @event)
				{
					if (@event is InputEventMouseButton mb)
					{
						if (mb.ButtonIndex == MouseButton.Left && mb.Pressed)
						{
							GD.Print("I've been clicked D:");
						}
					}
				}
				
				
				If the `event` inherits `InputEventMouse`, this method will **not** be called when:
				- the control's `mouse_filter` is set to `MOUSE_FILTER_IGNORE`;
				- the control is obstructed by another control on top, that doesn't have `mouse_filter` set to `MOUSE_FILTER_IGNORE`;
				- the control's parent has `mouse_filter` set to `MOUSE_FILTER_STOP` or has accepted the event;
				- the control's parent has `clip_contents` enabled and the `event`'s position is outside the parent's rectangle;
				- the `event`'s position is outside the control (see `_has_point`).
				**Note:** The `event`'s position is relative to this control's origin.

### `_has_point(point: Vector2) -> bool`
- 限定：qualifiers=virtual const

Virtual method to be implemented by the user. Returns whether the given `point` is inside this control.
				If not overridden, default behavior is checking if the point is within the control's Rect.
				**Note:** If you want to check if a point is inside the control, you can use `Rect2(Vector2.ZERO, size).has_point(point)`.

### `_make_custom_tooltip(for_text: String) -> Object`
- 限定：qualifiers=virtual const

Virtual method to be implemented by the user. Returns a `Control` node that should be used as a tooltip instead of the default one. `for_text` is the return value of `get_tooltip`.
				The returned node must be of type `Control` or Control-derived. It can have child nodes of any type. It is freed when the tooltip disappears, so make sure you always provide a new instance (if you want to use a pre-existing node from your scene tree, you can duplicate it and pass the duplicated instance). When `null` or a non-Control node is returned, the default tooltip will be used instead.
				The returned node will be added as child to a `PopupPanel`, so you should only provide the contents of that panel. That `PopupPanel` can be themed using `Theme.set_stylebox` for the type `"TooltipPanel"` (see `tooltip_text` for an example).
				**Note:** The tooltip is shrunk to minimal size. If you want to ensure it's fully visible, you might want to set its `custom_minimum_size` to some non-zero value.
				**Note:** The node (and any relevant children) should have their `CanvasItem.visible` set to `true` when returned, otherwise, the viewport that instantiates it will not be able to calculate its minimum size reliably.
				**Note:** If overridden, this method is called even if `get_tooltip` returns an empty string. When this happens with the default tooltip, it is not displayed. To copy this behavior, return `null` in this method when `for_text` is empty.
				**Example:** Use a constructed node as a tooltip:
				`codeblocks`
				`gdscript`
				func _make_custom_tooltip(for_text):
					var label = Label.new()
					label.text = for_text
					return label
				
				`csharp`
				public override Control _MakeCustomTooltip(string forText)
				{
					var label = new Label();
					label.Text = forText;
					return label;
				}
				
				
				**Example:** Use a scene instance as a tooltip:
				`codeblocks`
				`gdscript`
				func _make_custom_tooltip(for_text):
					var tooltip = preload("res://some_tooltip_scene.tscn").instantiate()
					tooltip.get_node("Label").text = for_text
					return tooltip
				
				`csharp`
				public override Control _MakeCustomTooltip(string forText)
				{
					Node tooltip = ResourceLoader.Load<PackedScene>("res://some_tooltip_scene.tscn").Instantiate();
					tooltip.GetNode<Label>("Label").Text = forText;
					return tooltip;
				}

### `_structured_text_parser(args: Array, text: String) -> Vector3i[]`
- 限定：qualifiers=virtual const

User defined BiDi algorithm override function.
				Returns an `Array` of `Vector3i` text ranges and text base directions, in the left-to-right order. Ranges should cover full source `text` without overlaps. BiDi algorithm will be used on each range separately.

### `accept_event() -> void`

Marks an input event as handled. Once you accept an input event, it stops propagating, even to nodes listening to `Node._unhandled_input` or `Node._unhandled_key_input`.
				**Note:** This does not affect the methods in `Input`, only the way events are propagated.

### `accessibility_drag() -> void`

Starts drag-and-drop operation without using a mouse.

### `accessibility_drop() -> void`

Ends drag-and-drop operation without using a mouse.

### `add_theme_color_override(name: StringName, color: Color) -> void`

Creates a local override for a theme `Color` with the specified `name`. Local overrides always take precedence when fetching theme items for the control. An override can be removed with `remove_theme_color_override`.
				See also `get_theme_color`.
				**Example:** Override a `Label`'s color and reset it later:
				`codeblocks`
				`gdscript`
				# Given the child Label node "MyLabel", override its font color with a custom value.
				$MyLabel.add_theme_color_override("font_color", Color(1, 0.5, 0))
				# Reset the font color of the child label.
				$MyLabel.remove_theme_color_override("font_color")
				# Alternatively it can be overridden with the default value from the Label type.
				$MyLabel.add_theme_color_override("font_color", get_theme_color("font_color", "Label"))
				
				`csharp`
				// Given the child Label node "MyLabel", override its font color with a custom value.
				GetNode<Label>("MyLabel").AddThemeColorOverride("font_color", new Color(1, 0.5f, 0));
				// Reset the font color of the child label.
				GetNode<Label>("MyLabel").RemoveThemeColorOverride("font_color");
				// Alternatively it can be overridden with the default value from the Label type.
				GetNode<Label>("MyLabel").AddThemeColorOverride("font_color", GetThemeColor("font_color", "Label"));

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
				See also `get_theme_stylebox`.
				**Example:** Modify a property in a `StyleBox` by duplicating it:
				`codeblocks`
				`gdscript`
				# The snippet below assumes the child node "MyButton" has a StyleBoxFlat assigned.
				# Resources are shared across instances, so we need to duplicate it
				# to avoid modifying the appearance of all other buttons.
				var new_stylebox_normal = $MyButton.get_theme_stylebox("normal").duplicate()
				new_stylebox_normal.border_width_top = 3
				new_stylebox_normal.border_color = Color(0, 1, 0.5)
				$MyButton.add_theme_stylebox_override("normal", new_stylebox_normal)
				# Remove the stylebox override.
				$MyButton.remove_theme_stylebox_override("normal")
				
				`csharp`
				// The snippet below assumes the child node "MyButton" has a StyleBoxFlat assigned.
				// Resources are shared across instances, so we need to duplicate it
				// to avoid modifying the appearance of all other buttons.
				StyleBoxFlat newStyleboxNormal = GetNode<Button>("MyButton").GetThemeStylebox("normal").Duplicate() as StyleBoxFlat;
				newStyleboxNormal.BorderWidthTop = 3;
				newStyleboxNormal.BorderColor = new Color(0, 1, 0.5f);
				GetNode<Button>("MyButton").AddThemeStyleboxOverride("normal", newStyleboxNormal);
				// Remove the stylebox override.
				GetNode<Button>("MyButton").RemoveThemeStyleboxOverride("normal");

### `begin_bulk_theme_override() -> void`

Prevents `*_theme_*_override` methods from emitting `NOTIFICATION_THEME_CHANGED` until `end_bulk_theme_override` is called.

### `end_bulk_theme_override() -> void`

Ends a bulk theme override update. See `begin_bulk_theme_override`.

### `find_next_valid_focus() -> Control`
- 限定：qualifiers=const

Finds the next (below in the tree) `Control` that can receive the focus.

### `find_prev_valid_focus() -> Control`
- 限定：qualifiers=const

Finds the previous (above in the tree) `Control` that can receive the focus.

### `find_valid_focus_neighbor(side: int) -> Control`
- 限定：qualifiers=const

Finds the next `Control` that can receive the focus on the specified `Side`.
				**Note:** This is different from `get_focus_neighbor`, which returns the path of a specified focus neighbor.

### `force_drag(data: Variant, preview: Control) -> void`

Forces drag and bypasses `_get_drag_data` and `set_drag_preview` by passing `data` and `preview`. Drag will start even if the mouse is neither over nor pressed on this control.
				The methods `_can_drop_data` and `_drop_data` must be implemented on controls that want to receive drop data.

### `get_anchor(side: int) -> float`
- 限定：qualifiers=const

Returns the anchor for the specified `Side`. A getter method for `anchor_bottom`, `anchor_left`, `anchor_right` and `anchor_top`.

### `get_begin() -> Vector2`
- 限定：qualifiers=const

Returns `offset_left` and `offset_top`. See also `position`.

### `get_bound_minimum_size() -> Vector2`
- 限定：qualifiers=const

Returns the bound value of `get_combined_minimum_size` by `get_combined_maximum_size`.
				This value is the true minimum size of the container, as the maximum size has priority over the minimum size.
				For example, if the combined minimum size is (100, 100) and the combined maximum size is (50, 150), the bound minimum size will be (50, 100).

### `get_combined_maximum_size() -> Vector2`
- 限定：qualifiers=const

Returns the combined maximum size from `custom_maximum_size` and `get_maximum_size`, as well as the `custom_maximum_size` of this node's parent if it is a Control node with `propagate_maximum_size` set to `true`.

### `get_combined_minimum_size() -> Vector2`
- 限定：qualifiers=const

Returns the combined minimum size from `custom_minimum_size` and `get_minimum_size`.

### `get_combined_pivot_offset() -> Vector2`
- 限定：qualifiers=const

Returns the combined value of `pivot_offset` and `pivot_offset_ratio`, in pixels. The ratio is multiplied by the control's size.

### `get_cursor_shape(at_position: Vector2 = Vector2(0, 0)) -> int`
- 限定：qualifiers=const

Returns the mouse cursor shape for this control when hovered over `at_position` in local coordinates. For most controls, this is the same as `mouse_default_cursor_shape`, but some built-in controls implement more complex logic.
				You can override `_get_cursor_shape` to implement custom behavior for this method.

### `get_end() -> Vector2`
- 限定：qualifiers=const

Returns `offset_right` and `offset_bottom`.

### `get_focus_mode_with_override() -> int`
- 限定：qualifiers=const

Returns the `focus_mode`, but takes the `focus_behavior_recursive` into account. If `focus_behavior_recursive` is set to `FOCUS_BEHAVIOR_DISABLED`, or it is set to `FOCUS_BEHAVIOR_INHERITED` and its ancestor is set to `FOCUS_BEHAVIOR_DISABLED`, then this returns `FOCUS_NONE`.

### `get_focus_neighbor(side: int) -> NodePath`
- 限定：qualifiers=const

Returns the focus neighbor for the specified `Side`. A getter method for `focus_neighbor_bottom`, `focus_neighbor_left`, `focus_neighbor_right` and `focus_neighbor_top`.
				**Note:** To find the next `Control` on the specific `Side`, even if a neighbor is not assigned, use `find_valid_focus_neighbor`.

### `get_global_rect() -> Rect2`
- 限定：qualifiers=const

Returns the position and size of the control relative to the containing canvas. See `global_position` and `size`.
				**Note:** If the node itself or any parent `CanvasItem` between the node and the canvas have a non default rotation or skew, the resulting size is likely not meaningful.
				**Note:** Setting `Viewport.gui_snap_controls_to_pixels` to `true` can lead to rounding inaccuracies between the displayed control and the returned `Rect2`.

### `get_maximum_size() -> Vector2`
- 限定：qualifiers=const

Returns the maximum size for this control. See `custom_maximum_size`.

### `get_minimum_size() -> Vector2`
- 限定：qualifiers=const

Returns the minimum size for this control. See `custom_minimum_size`.

### `get_mouse_filter_with_override() -> int`
- 限定：qualifiers=const

Returns the `mouse_filter`, but takes the `mouse_behavior_recursive` into account. If `mouse_behavior_recursive` is set to `MOUSE_BEHAVIOR_DISABLED`, or it is set to `MOUSE_BEHAVIOR_INHERITED` and its ancestor is set to `MOUSE_BEHAVIOR_DISABLED`, then this returns `MOUSE_FILTER_IGNORE`.

### `get_offset(offset: int) -> float`
- 限定：qualifiers=const

Returns the offset for the specified `Side`. A getter method for `offset_bottom`, `offset_left`, `offset_right` and `offset_top`.

### `get_parent_area_size() -> Vector2`
- 限定：qualifiers=const

Returns the width/height occupied in the parent control.

### `get_parent_control() -> Control`
- 限定：qualifiers=const

Returns the parent control node.

### `get_rect() -> Rect2`
- 限定：qualifiers=const

Returns the position and size of the control in the coordinate system of the containing node. See `position`, `scale` and `size`.
				**Note:** If `rotation` is not the default rotation, the resulting size is not meaningful.
				**Note:** Setting `Viewport.gui_snap_controls_to_pixels` to `true` can lead to rounding inaccuracies between the displayed control and the returned `Rect2`.

### `get_screen_position() -> Vector2`
- 限定：qualifiers=const

Returns the position of this `Control` in global screen coordinates (i.e. taking window position into account). Mostly useful for editor plugins.
				Equivalent to `get_screen_transform().origin` (see `CanvasItem.get_screen_transform`).
				**Example:** Show a popup at the mouse position:
				
```gdscript
				popup_menu.position = get_screen_position() + get_screen_transform().basis_xform(get_local_mouse_position())

				# The above code is equivalent to:
				popup_menu.position = get_screen_transform() * get_local_mouse_position()

				popup_menu.reset_size()
				popup_menu.popup()
				
```

### `get_theme_color(name: StringName, theme_type: StringName = &"") -> Color`
- 限定：qualifiers=const

Returns a `Color` from the first matching `Theme` in the tree if that `Theme` has a color item with the specified `name` and `theme_type`. If `theme_type` is omitted the class name of the current control is used as the type, or `theme_type_variation` if it is defined. If the type is a class name its parent classes are also checked, in order of inheritance. If the type is a variation its base types are checked, in order of dependency, then the control's class name and its parent classes are checked.
				For the current control its local overrides are considered first (see `add_theme_color_override`), then its assigned `theme`. After the current control, each parent control and its assigned `theme` are considered; controls without a `theme` assigned are skipped. If no matching `Theme` is found in the tree, the custom project `Theme` (see `ProjectSettings.gui/theme/custom`) and the default `Theme` are used (see `ThemeDB`).
				`codeblocks`
				`gdscript`
				func _ready():
					# Get the font color defined for the current Control's class, if it exists.
					modulate = get_theme_color("font_color")
					# Get the font color defined for the Button class.
					modulate = get_theme_color("font_color", "Button")
				
				`csharp`
				public override void _Ready()
				{
					// Get the font color defined for the current Control's class, if it exists.
					Modulate = GetThemeColor("font_color");
					// Get the font color defined for the Button class.
					Modulate = GetThemeColor("font_color", "Button");
				}

### `get_theme_constant(name: StringName, theme_type: StringName = &"") -> int`
- 限定：qualifiers=const

Returns a constant from the first matching `Theme` in the tree if that `Theme` has a constant item with the specified `name` and `theme_type`.
				See `get_theme_color` for details.

### `get_theme_default_base_scale() -> float`
- 限定：qualifiers=const

Returns the default base scale value from the first matching `Theme` in the tree if that `Theme` has a valid `Theme.default_base_scale` value.
				See `get_theme_color` for details.

### `get_theme_default_font() -> Font`
- 限定：qualifiers=const

Returns the default font from the first matching `Theme` in the tree if that `Theme` has a valid `Theme.default_font` value.
				See `get_theme_color` for details.

### `get_theme_default_font_size() -> int`
- 限定：qualifiers=const

Returns the default font size value from the first matching `Theme` in the tree if that `Theme` has a valid `Theme.default_font_size` value.
				See `get_theme_color` for details.

### `get_theme_font(name: StringName, theme_type: StringName = &"") -> Font`
- 限定：qualifiers=const

Returns a `Font` from the first matching `Theme` in the tree if that `Theme` has a font item with the specified `name` and `theme_type`.
				See `get_theme_color` for details.

### `get_theme_font_size(name: StringName, theme_type: StringName = &"") -> int`
- 限定：qualifiers=const

Returns a font size from the first matching `Theme` in the tree if that `Theme` has a font size item with the specified `name` and `theme_type`.
				See `get_theme_color` for details.

### `get_theme_icon(name: StringName, theme_type: StringName = &"") -> Texture2D`
- 限定：qualifiers=const

Returns an icon from the first matching `Theme` in the tree if that `Theme` has an icon item with the specified `name` and `theme_type`.
				See `get_theme_color` for details.

### `get_theme_stylebox(name: StringName, theme_type: StringName = &"") -> StyleBox`
- 限定：qualifiers=const

Returns a `StyleBox` from the first matching `Theme` in the tree if that `Theme` has a stylebox item with the specified `name` and `theme_type`.
				See `get_theme_color` for details.

### `get_tooltip(at_position: Vector2 = Vector2(0, 0)) -> String`
- 限定：qualifiers=const

Returns the tooltip text for the position `at_position` in the control's local coordinates, which will typically appear when the cursor is resting over this control. By default, it returns `tooltip_text`.
				You can override `_get_tooltip` to implement custom behavior for this method.
				**Note:** If this method returns an empty `String` and `_make_custom_tooltip` is not overridden, no tooltip is displayed.

### `grab_click_focus() -> void`

Creates an `InputEventMouseButton` that attempts to click the control. If the event is received, the control gains focus.
				`codeblocks`
				`gdscript`
				func _process(delta):
					grab_click_focus() # When clicking another Control node, this node will be clicked instead.
				
				`csharp`
				public override void _Process(double delta)
				{
					GrabClickFocus(); // When clicking another Control node, this node will be clicked instead.
				}

### `grab_focus(hide_focus: bool = false) -> void`

Steal the focus from another control and become the focused control (see `focus_mode`).
				If `hide_focus` is `true`, the control will not visually show its focused state. Has no effect for `LineEdit` and `TextEdit` when `ProjectSettings.gui/common/show_focus_state_on_pointer_event` is set to `Text Input Controls`, or for any control when it is set to `Always`.
				**Note:** Using this method together with `Callable.call_deferred` makes it more reliable, especially when called inside `Node._ready`.

### `has_focus(ignore_hidden_focus: bool = false) -> bool`
- 限定：qualifiers=const

Returns `true` if this is the current focused control. See `focus_mode`.
				If `ignore_hidden_focus` is `true`, controls that have their focus hidden will always return `false`. Hidden focus happens automatically when controls gain focus via mouse input, or manually using `grab_focus` with `hide_focus` set to `true`.

### `has_theme_color(name: StringName, theme_type: StringName = &"") -> bool`
- 限定：qualifiers=const

Returns `true` if there is a matching `Theme` in the tree that has a color item with the specified `name` and `theme_type`.
				See `get_theme_color` for details.

### `has_theme_color_override(name: StringName) -> bool`
- 限定：qualifiers=const

Returns `true` if there is a local override for a theme `Color` with the specified `name` in this `Control` node.
				See `add_theme_color_override`.

### `has_theme_constant(name: StringName, theme_type: StringName = &"") -> bool`
- 限定：qualifiers=const

Returns `true` if there is a matching `Theme` in the tree that has a constant item with the specified `name` and `theme_type`.
				See `get_theme_color` for details.

### `has_theme_constant_override(name: StringName) -> bool`
- 限定：qualifiers=const

Returns `true` if there is a local override for a theme constant with the specified `name` in this `Control` node.
				See `add_theme_constant_override`.

### `has_theme_font(name: StringName, theme_type: StringName = &"") -> bool`
- 限定：qualifiers=const

Returns `true` if there is a matching `Theme` in the tree that has a font item with the specified `name` and `theme_type`.
				See `get_theme_color` for details.

### `has_theme_font_override(name: StringName) -> bool`
- 限定：qualifiers=const

Returns `true` if there is a local override for a theme `Font` with the specified `name` in this `Control` node.
				See `add_theme_font_override`.

### `has_theme_font_size(name: StringName, theme_type: StringName = &"") -> bool`
- 限定：qualifiers=const

Returns `true` if there is a matching `Theme` in the tree that has a font size item with the specified `name` and `theme_type`.
				See `get_theme_color` for details.

### `has_theme_font_size_override(name: StringName) -> bool`
- 限定：qualifiers=const

Returns `true` if there is a local override for a theme font size with the specified `name` in this `Control` node.
				See `add_theme_font_size_override`.

### `has_theme_icon(name: StringName, theme_type: StringName = &"") -> bool`
- 限定：qualifiers=const

Returns `true` if there is a matching `Theme` in the tree that has an icon item with the specified `name` and `theme_type`.
				See `get_theme_color` for details.

### `has_theme_icon_override(name: StringName) -> bool`
- 限定：qualifiers=const

Returns `true` if there is a local override for a theme icon with the specified `name` in this `Control` node.
				See `add_theme_icon_override`.

### `has_theme_stylebox(name: StringName, theme_type: StringName = &"") -> bool`
- 限定：qualifiers=const

Returns `true` if there is a matching `Theme` in the tree that has a stylebox item with the specified `name` and `theme_type`.
				See `get_theme_color` for details.

### `has_theme_stylebox_override(name: StringName) -> bool`
- 限定：qualifiers=const

Returns `true` if there is a local override for a theme `StyleBox` with the specified `name` in this `Control` node.
				See `add_theme_stylebox_override`.

### `is_drag_successful() -> bool`
- 限定：qualifiers=const

Returns `true` if a drag operation is successful. Alternative to `Viewport.gui_is_drag_successful`.
				Best used with `Node.NOTIFICATION_DRAG_END`.

### `is_layout_rtl() -> bool`
- 限定：qualifiers=const

Returns `true` if the layout is right-to-left. See also `layout_direction`.

### `release_focus() -> void`

Give up the focus. No other control will be able to receive input.

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

### `reset_size() -> void`

Resets the size to `get_combined_minimum_size`. This is equivalent to calling `set_size(Vector2())` (or any size below the minimum).

### `set_anchor(side: int, anchor: float, keep_offset: bool = false, push_opposite_anchor: bool = true) -> void`

Sets the anchor for the specified `Side` to `anchor`. A setter method for `anchor_bottom`, `anchor_left`, `anchor_right` and `anchor_top`.
				If `keep_offset` is `true`, offsets aren't updated after this operation.
				If `push_opposite_anchor` is `true` and the opposite anchor overlaps this anchor, the opposite one will have its value overridden. For example, when setting left anchor to 1 and the right anchor has value of 0.5, the right anchor will also get value of 1. If `push_opposite_anchor` was `false`, the left anchor would get value 0.5.

### `set_anchor_and_offset(side: int, anchor: float, offset: float, push_opposite_anchor: bool = false) -> void`

Works the same as `set_anchor`, but instead of `keep_offset` argument and automatic update of offset, it allows to set the offset yourself (see `set_offset`).

### `set_anchors_and_offsets_preset(preset: int, resize_mode: int = 0, margin: int = 0) -> void`

Sets both anchor preset and offset preset. See `set_anchors_preset` and `set_offsets_preset`.

### `set_anchors_preset(preset: int, keep_offsets: bool = false) -> void`

Sets the anchors to a `preset` from `Control.LayoutPreset` enum. This is the code equivalent to using the Layout menu in the 2D editor.
				If `keep_offsets` is `true`, control's position will also be updated.

### `set_begin(position: Vector2) -> void`

Sets `offset_left` and `offset_top` at the same time. Equivalent of changing `position`.

### `set_drag_forwarding(drag_func: Callable, can_drop_func: Callable, drop_func: Callable) -> void`

Sets the given callables to be used instead of the control's own drag-and-drop virtual methods. If a callable is empty, its respective virtual method is used as normal.
				The arguments for each callable should be exactly the same as their respective virtual methods, which would be:
				- `drag_func` corresponds to `_get_drag_data` and requires a `Vector2`;
				- `can_drop_func` corresponds to `_can_drop_data` and requires both a `Vector2` and a `Variant`;
				- `drop_func` corresponds to `_drop_data` and requires both a `Vector2` and a `Variant`.

### `set_drag_preview(control: Control) -> void`

Shows the given control at the mouse pointer. A good time to call this method is in `_get_drag_data`. The control must not be in the scene tree. You should not free the control, and you should not keep a reference to the control beyond the duration of the drag. It will be deleted automatically after the drag has ended.
				`codeblocks`
				`gdscript`
				@export var color = Color(1, 0, 0, 1)

				func _get_drag_data(position):
					# Use a control that is not in the tree
					var cpb = ColorPickerButton.new()
					cpb.color = color
					cpb.size = Vector2(50, 50)
					set_drag_preview(cpb)
					return color
				
				`csharp`
				`Export`
				private Color _color = new Color(1, 0, 0, 1);

				public override Variant _GetDragData(Vector2 atPosition)
				{
					// Use a control that is not in the tree
					var cpb = new ColorPickerButton();
					cpb.Color = _color;
					cpb.Size = new Vector2(50, 50);
					SetDragPreview(cpb);
					return _color;
				}

### `set_end(position: Vector2) -> void`

Sets `offset_right` and `offset_bottom` at the same time.

### `set_focus_neighbor(side: int, neighbor: NodePath) -> void`

Sets the focus neighbor for the specified `Side` to the `Control` at `neighbor` node path. A setter method for `focus_neighbor_bottom`, `focus_neighbor_left`, `focus_neighbor_right` and `focus_neighbor_top`.

### `set_global_position(position: Vector2, keep_offsets: bool = false) -> void`

Sets the `global_position` to given `position`.
				If `keep_offsets` is `true`, control's anchors will be updated instead of offsets.

### `set_offset(side: int, offset: float) -> void`

Sets the offset for the specified `Side` to `offset`. A setter method for `offset_bottom`, `offset_left`, `offset_right` and `offset_top`.

### `set_offsets_preset(preset: int, resize_mode: int = 0, margin: int = 0) -> void`

Sets the offsets to a `preset` from `Control.LayoutPreset` enum. This is the code equivalent to using the Layout menu in the 2D editor.
				Use parameter `resize_mode` with constants from `Control.LayoutPresetMode` to better determine the resulting size of the `Control`. Constant size will be ignored if used with presets that change size, e.g. `PRESET_LEFT_WIDE`.
				Use parameter `margin` to determine the gap between the `Control` and the edges.

### `set_position(position: Vector2, keep_offsets: bool = false) -> void`

Sets the `position` to given `position`.
				If `keep_offsets` is `true`, control's anchors will be updated instead of offsets.

### `set_size(size: Vector2, keep_offsets: bool = false) -> void`

Sets the size (see `size`).
				If `keep_offsets` is `true`, control's anchors will be updated instead of offsets.

### `update_maximum_size() -> void`

Invalidates the maximum size cache in this node and in parent nodes up to top level. Intended to be used with `get_maximum_size` when the return value is changed. Setting `custom_maximum_size` directly calls this method automatically.
				**Note:** Calling this method also calls `update_minimum_size` since the combined minimum size may be affected by the maximum size change.

### `update_minimum_size() -> void`

Invalidates the minimum size cache in this node and in parent nodes up to top level. Intended to be used with `get_minimum_size` when the return value is changed. Setting `custom_minimum_size` directly calls this method automatically.

### `warp_mouse(position: Vector2) -> void`

Moves the mouse cursor to `position`, relative to `position` of this `Control`.
				**Note:** `warp_mouse` is only supported on Windows, macOS and Linux. It has no effect on Android, iOS and Web.

## 信号

### `focus_entered()`

Emitted when the node gains focus.

### `focus_exited()`

Emitted when the node loses focus.

### `gui_input(event: InputEvent)`

Emitted when the node receives an `InputEvent`.

### `maximum_size_changed()`

Emitted when the node's maximum size changes.

### `minimum_size_changed()`

Emitted when the node's minimum size changes.

### `mouse_entered()`

Emitted when the mouse cursor enters the control's (or any child control's) visible area, that is not occluded behind other Controls or Windows, provided its `mouse_filter` lets the event reach it and regardless if it's currently focused or not.
				**Note:** `CanvasItem.z_index` doesn't affect, which Control receives the signal.

### `mouse_exited()`

Emitted when the mouse cursor leaves the control's (and all child control's) visible area, that is not occluded behind other Controls or Windows, provided its `mouse_filter` lets the event reach it and regardless if it's currently focused or not.
				**Note:** `CanvasItem.z_index` doesn't affect, which Control receives the signal.
				**Note:** If you want to check whether the mouse truly left the area, ignoring any top nodes, you can use code like this:
				
```gdscript
				func _on_mouse_exited():
					if not Rect2(Vector2(), size).has_point(get_local_mouse_position()):
						# Not hovering over area.
				
```

### `resized()`

Emitted when the control changes size.

### `size_flags_changed()`

Emitted when one of the size flags changes. See `size_flags_horizontal` and `size_flags_vertical`.

### `theme_changed()`

Emitted when the `NOTIFICATION_THEME_CHANGED` notification is sent.

## 枚举

### `FocusMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `FOCUS_NONE` |  |
| `1` | `FOCUS_CLICK` |  |
| `2` | `FOCUS_ALL` |  |
| `3` | `FOCUS_ACCESSIBILITY` |  |

### `FocusBehaviorRecursive`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `FOCUS_BEHAVIOR_INHERITED` |  |
| `1` | `FOCUS_BEHAVIOR_DISABLED` |  |
| `2` | `FOCUS_BEHAVIOR_ENABLED` |  |

### `MouseBehaviorRecursive`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `MOUSE_BEHAVIOR_INHERITED` |  |
| `1` | `MOUSE_BEHAVIOR_DISABLED` |  |
| `2` | `MOUSE_BEHAVIOR_ENABLED` |  |

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

### `LayoutPreset`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `PRESET_TOP_LEFT` |  |
| `1` | `PRESET_TOP_RIGHT` |  |
| `2` | `PRESET_BOTTOM_LEFT` |  |
| `3` | `PRESET_BOTTOM_RIGHT` |  |
| `4` | `PRESET_CENTER_LEFT` |  |
| `5` | `PRESET_CENTER_TOP` |  |
| `6` | `PRESET_CENTER_RIGHT` |  |
| `7` | `PRESET_CENTER_BOTTOM` |  |
| `8` | `PRESET_CENTER` |  |
| `9` | `PRESET_LEFT_WIDE` |  |
| `10` | `PRESET_TOP_WIDE` |  |
| `11` | `PRESET_RIGHT_WIDE` |  |
| `12` | `PRESET_BOTTOM_WIDE` |  |
| `13` | `PRESET_VCENTER_WIDE` |  |
| `14` | `PRESET_HCENTER_WIDE` |  |
| `15` | `PRESET_FULL_RECT` |  |

### `LayoutPresetMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `PRESET_MODE_MINSIZE` |  |
| `1` | `PRESET_MODE_KEEP_WIDTH` |  |
| `2` | `PRESET_MODE_KEEP_HEIGHT` |  |
| `3` | `PRESET_MODE_KEEP_SIZE` |  |

### `SizeFlags`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SIZE_SHRINK_BEGIN` | （位标志） |
| `1` | `SIZE_FILL` | （位标志） |
| `2` | `SIZE_EXPAND` | （位标志） |
| `3` | `SIZE_EXPAND_FILL` | （位标志） |
| `4` | `SIZE_SHRINK_CENTER` | （位标志） |
| `8` | `SIZE_SHRINK_END` | （位标志） |

### `MouseFilter`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `MOUSE_FILTER_STOP` |  |
| `1` | `MOUSE_FILTER_PASS` |  |
| `2` | `MOUSE_FILTER_IGNORE` |  |

### `GrowDirection`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `GROW_DIRECTION_BEGIN` |  |
| `1` | `GROW_DIRECTION_END` |  |
| `2` | `GROW_DIRECTION_BOTH` |  |

### `Anchor`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ANCHOR_BEGIN` |  |
| `1` | `ANCHOR_END` |  |

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

### `TextDirection`

| 值 | 名称 | 说明 |
|---|---|---|
| `3` | `TEXT_DIRECTION_INHERITED` |  |
| `0` | `TEXT_DIRECTION_AUTO` |  |
| `1` | `TEXT_DIRECTION_LTR` |  |
| `2` | `TEXT_DIRECTION_RTL` |  |

## 常量

- **`NOTIFICATION_RESIZED`** = `40`
- **`NOTIFICATION_MOUSE_ENTER`** = `41`
- **`NOTIFICATION_MOUSE_EXIT`** = `42`
- **`NOTIFICATION_MOUSE_ENTER_SELF`** = `60`
- **`NOTIFICATION_MOUSE_EXIT_SELF`** = `61`
- **`NOTIFICATION_FOCUS_ENTER`** = `43`
- **`NOTIFICATION_FOCUS_EXIT`** = `44`
- **`NOTIFICATION_THEME_CHANGED`** = `45`
- **`NOTIFICATION_SCROLL_BEGIN`** = `47`
- **`NOTIFICATION_SCROLL_END`** = `48`
- **`NOTIFICATION_LAYOUT_DIRECTION_CHANGED`** = `49`
## 教程链接

- [GUI documentation index](None)
- [Custom drawing in 2D](None)
- [Control node gallery](None)
- [Multiple resolutions](None)
- [All GUI Demos](None)

