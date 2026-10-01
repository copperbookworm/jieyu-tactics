# GraphEdit

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`GraphEdit` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/GraphEdit.md`

**摘要**：An editor for graph-like structures, using `GraphNode`s.

## 描述

`GraphEdit` provides tools for creation, manipulation, and display of various graphs. Its main purpose in the engine is to power the visual programming systems, such as visual shaders, but it is also available for use in user projects.
		`GraphEdit` by itself is only an empty container, representing an infinite grid where `GraphNode`s can be placed. Each `GraphNode` represents a node in the graph, a single unit of data in the connected scheme. `GraphEdit`, in turn, helps to control various interactions with nodes and between nodes. When the user attempts to connect, disconnect, or delete a `GraphNode`, a signal is emitted in the `GraphEdit`, but no action is taken by default. It is the responsibility of the programmer utilizing this control to implement the necessary logic to determine how each request should be handled.
		**Performance:** It is greatly advised to enable low-processor usage mode (see `OS.low_processor_usage_mode`) when using GraphEdits.
		**Note:** Keep in mind that `Node.get_children` will also return the connection layer node named `_connection_layer` due to technical limitations. This behavior may change in future releases.

## 属性

- **`clip_contents`** `bool` = `true`
  - 其它属性：getter=is_clipping_contents · overrides=Control · setter=set_clip_contents
- **`connection_lines_antialiased`** `bool` = `true`
  - 其它属性：getter=is_connection_lines_antialiased · setter=set_connection_lines_antialiased
- **`connection_lines_curvature`** `float` = `0.5`
  - 其它属性：getter=get_connection_lines_curvature · setter=set_connection_lines_curvature
- **`connection_lines_thickness`** `float` = `4.0`
  - 其它属性：getter=get_connection_lines_thickness · setter=set_connection_lines_thickness
- **`connections`** `Dictionary[]` = `[]`
  - 其它属性：getter=get_connection_list · setter=set_connections
- **`focus_mode`** `int` = `2` · 枚举 `Control.FocusMode`
  - 其它属性：getter=get_focus_mode · overrides=Control · setter=set_focus_mode
- **`grid_pattern`** `int` = `0` · 枚举 `GraphEdit.GridPattern`
  - 其它属性：getter=get_grid_pattern · setter=set_grid_pattern
- **`minimap_enabled`** `bool` = `true`
  - 其它属性：getter=is_minimap_enabled · setter=set_minimap_enabled
- **`minimap_opacity`** `float` = `0.65`
  - 其它属性：getter=get_minimap_opacity · setter=set_minimap_opacity
- **`minimap_size`** `Vector2` = `Vector2(240, 160)`
  - 其它属性：getter=get_minimap_size · setter=set_minimap_size
- **`panning_scheme`** `int` = `0` · 枚举 `GraphEdit.PanningScheme`
  - 其它属性：getter=get_panning_scheme · setter=set_panning_scheme
- **`right_disconnects`** `bool` = `false`
  - 其它属性：getter=is_right_disconnects_enabled · setter=set_right_disconnects
- **`scroll_offset`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_scroll_offset · setter=set_scroll_offset
- **`show_arrange_button`** `bool` = `true`
  - 其它属性：getter=is_showing_arrange_button · setter=set_show_arrange_button
- **`show_grid`** `bool` = `true`
  - 其它属性：getter=is_showing_grid · setter=set_show_grid
- **`show_grid_buttons`** `bool` = `true`
  - 其它属性：getter=is_showing_grid_buttons · setter=set_show_grid_buttons
- **`show_menu`** `bool` = `true`
  - 其它属性：getter=is_showing_menu · setter=set_show_menu
- **`show_minimap_button`** `bool` = `true`
  - 其它属性：getter=is_showing_minimap_button · setter=set_show_minimap_button
- **`show_zoom_buttons`** `bool` = `true`
  - 其它属性：getter=is_showing_zoom_buttons · setter=set_show_zoom_buttons
- **`show_zoom_label`** `bool` = `false`
  - 其它属性：getter=is_showing_zoom_label · setter=set_show_zoom_label
- **`snapping_distance`** `int` = `20`
  - 其它属性：getter=get_snapping_distance · setter=set_snapping_distance
- **`snapping_enabled`** `bool` = `true`
  - 其它属性：getter=is_snapping_enabled · setter=set_snapping_enabled
- **`type_names`** `Dictionary` = `{}`
  - 其它属性：getter=get_type_names · setter=set_type_names
- **`zoom`** `float` = `1.0`
  - 其它属性：getter=get_zoom · setter=set_zoom
- **`zoom_max`** `float` = `2.0736003`
  - 其它属性：getter=get_zoom_max · setter=set_zoom_max
- **`zoom_min`** `float` = `0.23256795`
  - 其它属性：getter=get_zoom_min · setter=set_zoom_min
- **`zoom_step`** `float` = `1.2`
  - 其它属性：getter=get_zoom_step · setter=set_zoom_step

## 方法

### `_get_connection_line(from_position: Vector2, to_position: Vector2) -> PackedVector2Array`
- 限定：qualifiers=virtual const

Virtual method which can be overridden to customize how connections are drawn.

### `_is_in_input_hotzone(in_node: Object, in_port: int, mouse_position: Vector2) -> bool`
- 限定：qualifiers=virtual

Returns whether the `mouse_position` is in the input hot zone.
				By default, a hot zone is a `Rect2` positioned such that its center is at `in_node`.`GraphNode.get_input_port_position`(`in_port`) (For output's case, call `GraphNode.get_output_port_position` instead). The hot zone's width is twice the Theme Property `port_grab_distance_horizontal`, and its height is twice the `port_grab_distance_vertical`.
				Below is a sample code to help get started:
				
```gdscript
				func _is_in_input_hotzone(in_node, in_port, mouse_position):
					var port_size = Vector2(get_theme_constant("port_grab_distance_horizontal"), get_theme_constant("port_grab_distance_vertical"))
					var port_pos = in_node.get_position() + in_node.get_input_port_position(in_port) - port_size / 2
					var rect = Rect2(port_pos, port_size)

					return rect.has_point(mouse_position)
				
```

### `_is_in_output_hotzone(in_node: Object, in_port: int, mouse_position: Vector2) -> bool`
- 限定：qualifiers=virtual

Returns whether the `mouse_position` is in the output hot zone. For more information on hot zones, see `_is_in_input_hotzone`.
				Below is a sample code to help get started:
				
```gdscript
				func _is_in_output_hotzone(in_node, in_port, mouse_position):
					var port_size = Vector2(get_theme_constant("port_grab_distance_horizontal"), get_theme_constant("port_grab_distance_vertical"))
					var port_pos = in_node.get_position() + in_node.get_output_port_position(in_port) - port_size / 2
					var rect = Rect2(port_pos, port_size)

					return rect.has_point(mouse_position)
				
```

### `_is_node_hover_valid(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> bool`
- 限定：qualifiers=virtual

This virtual method can be used to insert additional error detection while the user is dragging a connection over a valid port.
				Return `true` if the connection is indeed valid or return `false` if the connection is impossible. If the connection is impossible, no snapping to the port and thus no connection request to that port will happen.
				In this example a connection to same node is suppressed:
				`codeblocks`
				`gdscript`
				func _is_node_hover_valid(from, from_port, to, to_port):
					return from != to
				
				`csharp`
				public override bool _IsNodeHoverValid(StringName fromNode, int fromPort, StringName toNode, int toPort)
				{
					return fromNode != toNode;
				}

### `add_valid_connection_type(from_type: int, to_type: int) -> void`

Allows the connection between two different port types. The port type is defined individually for the left and the right port of each slot with the `GraphNode.set_slot` method.
				See also `is_valid_connection_type` and `remove_valid_connection_type`.

### `add_valid_left_disconnect_type(type: int) -> void`

Allows to disconnect nodes when dragging from the left port of the `GraphNode`'s slot if it has the specified type. See also `remove_valid_left_disconnect_type`.

### `add_valid_right_disconnect_type(type: int) -> void`

Allows to disconnect nodes when dragging from the right port of the `GraphNode`'s slot if it has the specified type. See also `remove_valid_right_disconnect_type`.

### `arrange_nodes() -> void`

Rearranges selected nodes in a layout with minimum crossings between connections and uniform horizontal and vertical gap between nodes.

### `attach_graph_element_to_frame(element: StringName, frame: StringName) -> void`

Attaches the `element` `GraphElement` to the `frame` `GraphFrame`.

### `clear_connections() -> void`

Removes all connections between nodes.

### `connect_node(from_node: StringName, from_port: int, to_node: StringName, to_port: int, keep_alive: bool = false) -> int`

Create a connection between the `from_port` of the `from_node` `GraphNode` and the `to_port` of the `to_node` `GraphNode`. If the connection already exists, no connection is created.
				Connections with `keep_alive` set to `false` may be deleted automatically if invalid during a redraw.

### `detach_graph_element_from_frame(element: StringName) -> void`

Detaches the `element` `GraphElement` from the `GraphFrame` it is currently attached to.

### `disconnect_node(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void`

Removes the connection between the `from_port` of the `from_node` `GraphNode` and the `to_port` of the `to_node` `GraphNode`. If the connection does not exist, no connection is removed.

### `force_connection_drag_end() -> void`

Ends the creation of the current connection. In other words, if you are dragging a connection you can use this method to abort the process and remove the line that followed your cursor.
				This is best used together with `connection_drag_started` and `connection_drag_ended` to add custom behavior like node addition through shortcuts.
				**Note:** This method suppresses any other connection request signals apart from `connection_drag_ended`.

### `get_attached_nodes_of_frame(frame: StringName) -> StringName[]`

Returns an array of node names that are attached to the `GraphFrame` with the given name.

### `get_closest_connection_at_point(point: Vector2, max_distance: float = 4.0) -> Dictionary`
- 限定：qualifiers=const

Returns the closest connection to the given point in screen space. If no connection is found within `max_distance` pixels, an empty `Dictionary` is returned.
				A connection is represented as a `Dictionary` in the form of:
				
```gdscript
				{
					from_node: StringName,
					from_port: int,
					to_node: StringName,
					to_port: int,
					keep_alive: bool
				}
				
```

				For example, getting a connection at a given mouse position can be achieved like this:
				`codeblocks`
				`gdscript`
				var connection = get_closest_connection_at_point(mouse_event.get_position())

### `get_connection_count(from_node: StringName, from_port: int) -> int`

Returns the number of connections from `from_port` of `from_node`.

### `get_connection_line(from_node: Vector2, to_node: Vector2) -> PackedVector2Array`
- 限定：qualifiers=const

Returns the points which would make up a connection between `from_node` and `to_node`.

### `get_connection_list_from_node(node: StringName) -> Dictionary[]`
- 限定：qualifiers=const

Returns an `Array` containing a list of all connections for `node`.
				A connection is represented as a `Dictionary` in the form of:
				
```gdscript
				{
					from_node: StringName,
					from_port: int,
					to_node: StringName,
					to_port: int,
					keep_alive: bool
				}
				
```

				**Example:** Get all connections on a specific port:
				
```gdscript
				func get_connection_list_from_port(node, port):
					var connections = get_connection_list_from_node(node)
					var result = []
					for connection in connections:
						var dict = {}
						if connection["from_node"] == node and connection["from_port"] == port:
							dict["node"] = connection["to_node"]
							dict["port"] = connection["to_port"]
							dict["type"] = "left"
							result.push_back(dict)
						elif connection["to_node"] == node and connection["to_port"] == port:
							dict["node"] = connection["from_node"]
							dict["port"] = connection["from_port"]
							dict["type"] = "right"
							result.push_back(dict)
					return result
				
```

### `get_connections_intersecting_with_rect(rect: Rect2) -> Dictionary[]`
- 限定：qualifiers=const

Returns an `Array` containing the list of connections that intersect with the given `Rect2`.
				A connection is represented as a `Dictionary` in the form of:
				
```gdscript
				{
					from_node: StringName,
					from_port: int,
					to_node: StringName,
					to_port: int,
					keep_alive: bool
				}
				
```

### `get_element_frame(element: StringName) -> GraphFrame`

Returns the `GraphFrame` that contains the `GraphElement` with the given name.

### `get_menu_hbox() -> HBoxContainer`

Gets the `HBoxContainer` that contains the zooming and grid snap controls in the top left of the graph. You can use this method to reposition the toolbar or to add your own custom controls to it.
				**Warning:** This is a required internal node, removing and freeing it may cause a crash. If you wish to hide it or any of its children, use their `CanvasItem.visible` property.

### `is_node_connected(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> bool`

Returns `true` if the `from_port` of the `from_node` `GraphNode` is connected to the `to_port` of the `to_node` `GraphNode`.

### `is_valid_connection_type(from_type: int, to_type: int) -> bool`
- 限定：qualifiers=const

Returns whether it's possible to make a connection between two different port types. The port type is defined individually for the left and the right port of each slot with the `GraphNode.set_slot` method.
				See also `add_valid_connection_type` and `remove_valid_connection_type`.

### `remove_valid_connection_type(from_type: int, to_type: int) -> void`

Disallows the connection between two different port types previously allowed by `add_valid_connection_type`. The port type is defined individually for the left and the right port of each slot with the `GraphNode.set_slot` method.
				See also `is_valid_connection_type`.

### `remove_valid_left_disconnect_type(type: int) -> void`

Disallows to disconnect nodes when dragging from the left port of the `GraphNode`'s slot if it has the specified type. Use this to disable a disconnection previously allowed with `add_valid_left_disconnect_type`.

### `remove_valid_right_disconnect_type(type: int) -> void`

Disallows to disconnect nodes when dragging from the right port of the `GraphNode`'s slot if it has the specified type. Use this to disable a disconnection previously allowed with `add_valid_right_disconnect_type`.

### `set_connection_activity(from_node: StringName, from_port: int, to_node: StringName, to_port: int, amount: float) -> void`

Sets the coloration of the connection between `from_node`'s `from_port` and `to_node`'s `to_port` with the color provided in the `activity` theme property. The color is linearly interpolated between the connection color and the activity color using `amount` as weight.

### `set_selected(node: Node) -> void`

Sets the specified `node` as the one selected.

## 信号

### `begin_node_move()`

Emitted at the beginning of a `GraphElement`'s movement.

### `connection_drag_ended()`

Emitted at the end of a connection drag.

### `connection_drag_started(from_node: StringName, from_port: int, is_output: bool)`

Emitted at the beginning of a connection drag.

### `connection_from_empty(to_node: StringName, to_port: int, release_position: Vector2)`

Emitted when user drags a connection from an input port into the empty space of the graph.

### `connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int)`

Emitted to the GraphEdit when the connection between the `from_port` of the `from_node` `GraphNode` and the `to_port` of the `to_node` `GraphNode` is attempted to be created.

### `connection_to_empty(from_node: StringName, from_port: int, release_position: Vector2)`

Emitted when user drags a connection from an output port into the empty space of the graph.

### `copy_nodes_request()`

Emitted when this `GraphEdit` captures a `ui_copy` action (Ctrl + C by default). In general, this signal indicates that the selected `GraphElement`s should be copied.

### `cut_nodes_request()`

Emitted when this `GraphEdit` captures a `ui_cut` action (Ctrl + X by default). In general, this signal indicates that the selected `GraphElement`s should be cut.

### `delete_nodes_request(nodes: StringName[])`

Emitted when this `GraphEdit` captures a `ui_graph_delete` action (Delete by default).
				`nodes` is an array of node names that should be removed. These usually include all selected nodes.

### `disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int)`

Emitted to the GraphEdit when the connection between `from_port` of `from_node` `GraphNode` and `to_port` of `to_node` `GraphNode` is attempted to be removed.

### `duplicate_nodes_request()`

Emitted when this `GraphEdit` captures a `ui_graph_duplicate` action (Ctrl + D by default). In general, this signal indicates that the selected `GraphElement`s should be duplicated.

### `end_node_move()`

Emitted at the end of a `GraphElement`'s movement.

### `frame_rect_changed(frame: GraphFrame, new_rect: Rect2)`

Emitted when the `GraphFrame` `frame` is resized to `new_rect`.

### `graph_elements_linked_to_frame_request(elements: Array, frame: StringName)`

Emitted when one or more `GraphElement`s are dropped onto the `GraphFrame` named `frame`, when they were not previously attached to any other one.
				`elements` is an array of `GraphElement`s to be attached.

### `node_deselected(node: Node)`

Emitted when the given `GraphElement` node is deselected.

### `node_selected(node: Node)`

Emitted when the given `GraphElement` node is selected.

### `paste_nodes_request()`

Emitted when this `GraphEdit` captures a `ui_paste` action (Ctrl + V by default). In general, this signal indicates that previously copied `GraphElement`s should be pasted.

### `popup_request(at_position: Vector2)`

Emitted when a popup is requested. Happens on right-clicking in the GraphEdit. `at_position` is the position of the mouse pointer when the signal is sent.

### `scroll_offset_changed(offset: Vector2)`

Emitted when the scroll offset is changed by the user. It will not be emitted when changed in code.

## 枚举

### `PanningScheme`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SCROLL_ZOOMS` |  |
| `1` | `SCROLL_PANS` |  |

### `GridPattern`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `GRID_PATTERN_LINES` |  |
| `1` | `GRID_PATTERN_DOTS` |  |

## 主题属性

### `activity`
- data_type=color · default=Color(1, 1, 1, 1) · type=Color

### `connection_hover_tint_color`
- data_type=color · default=Color(0, 0, 0, 0.3) · type=Color

### `connection_rim_color`
- data_type=color · default=Color(0.1, 0.1, 0.1, 0.6) · type=Color

### `connection_valid_target_tint_color`
- data_type=color · default=Color(1, 1, 1, 0.4) · type=Color

### `grid_major`
- data_type=color · default=Color(1, 1, 1, 0.2) · type=Color

### `grid_minor`
- data_type=color · default=Color(1, 1, 1, 0.05) · type=Color

### `selection_fill`
- data_type=color · default=Color(1, 1, 1, 0.3) · type=Color

### `selection_stroke`
- data_type=color · default=Color(1, 1, 1, 0.8) · type=Color

### `connection_hover_thickness`
- data_type=constant · default=0 · type=int

### `port_hotzone_inner_extent`
- data_type=constant · default=22 · type=int

### `port_hotzone_outer_extent`
- data_type=constant · default=26 · type=int

### `grid_toggle`
- data_type=icon · type=Texture2D

### `layout`
- data_type=icon · type=Texture2D

### `minimap_toggle`
- data_type=icon · type=Texture2D

### `snapping_toggle`
- data_type=icon · type=Texture2D

### `zoom_in`
- data_type=icon · type=Texture2D

### `zoom_out`
- data_type=icon · type=Texture2D

### `zoom_reset`
- data_type=icon · type=Texture2D

### `menu_panel`
- data_type=style · type=StyleBox

### `panel`
- data_type=style · type=StyleBox

### `panel_focus`
- data_type=style · type=StyleBox

