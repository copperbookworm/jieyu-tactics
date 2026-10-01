# Camera2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Camera2D` → `Node2D` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Camera2D.md`

**摘要**：Camera node for 2D scenes.

## 描述

Camera node for 2D scenes. It forces the screen (current layer) to scroll following this node. This makes it easier (and faster) to program scrollable scenes than manually changing the position of `CanvasItem`-based nodes.
		Cameras register themselves in the nearest `Viewport` node (when ascending the tree). Only one camera can be active per viewport. If no viewport is available ascending the tree, the camera will register in the global viewport.
		This node is intended to be a simple helper to get things going quickly, but more functionality may be desired to change how the camera works. To make your own custom camera node, inherit it from `Node2D` and change the transform of the canvas by setting `Viewport.canvas_transform` in `Viewport` (you can obtain the current `Viewport` by using `Node.get_viewport`).
		Note that the `Camera2D` node's `Node2D.global_position` doesn't represent the actual position of the screen, which may differ due to applied smoothing or limits. You can use `get_screen_center_position` to get the real position. Same for the node's `Node2D.global_rotation` which may be different due to applied rotation smoothing. You can use `get_screen_rotation` to get the current rotation of the screen.

## 属性

- **`anchor_mode`** `int` = `1` · 枚举 `Camera2D.AnchorMode`
  - 其它属性：getter=get_anchor_mode · setter=set_anchor_mode
- **`custom_viewport`** `Node`
  - 其它属性：getter=get_custom_viewport · setter=set_custom_viewport
- **`drag_bottom_margin`** `float` = `0.2`
  - 其它属性：getter=get_drag_margin · setter=set_drag_margin
- **`drag_horizontal_enabled`** `bool` = `false`
  - 其它属性：getter=is_drag_horizontal_enabled · setter=set_drag_horizontal_enabled
- **`drag_horizontal_offset`** `float` = `0.0`
  - 其它属性：getter=get_drag_horizontal_offset · setter=set_drag_horizontal_offset
- **`drag_left_margin`** `float` = `0.2`
  - 其它属性：getter=get_drag_margin · setter=set_drag_margin
- **`drag_right_margin`** `float` = `0.2`
  - 其它属性：getter=get_drag_margin · setter=set_drag_margin
- **`drag_top_margin`** `float` = `0.2`
  - 其它属性：getter=get_drag_margin · setter=set_drag_margin
- **`drag_vertical_enabled`** `bool` = `false`
  - 其它属性：getter=is_drag_vertical_enabled · setter=set_drag_vertical_enabled
- **`drag_vertical_offset`** `float` = `0.0`
  - 其它属性：getter=get_drag_vertical_offset · setter=set_drag_vertical_offset
- **`editor_draw_drag_margin`** `bool` = `false`
  - 其它属性：getter=is_margin_drawing_enabled · setter=set_margin_drawing_enabled
- **`editor_draw_limits`** `bool` = `false`
  - 其它属性：getter=is_limit_drawing_enabled · setter=set_limit_drawing_enabled
- **`editor_draw_screen`** `bool` = `true`
  - 其它属性：getter=is_screen_drawing_enabled · setter=set_screen_drawing_enabled
- **`enabled`** `bool` = `true`
  - 其它属性：getter=is_enabled · setter=set_enabled
- **`ignore_rotation`** `bool` = `true`
  - 其它属性：getter=is_ignoring_rotation · setter=set_ignore_rotation
- **`limit_bottom`** `int` = `10000000`
  - 其它属性：getter=get_limit · setter=set_limit
- **`limit_enabled`** `bool` = `true`
  - 其它属性：getter=is_limit_enabled · setter=set_limit_enabled
- **`limit_left`** `int` = `-10000000`
  - 其它属性：getter=get_limit · setter=set_limit
- **`limit_right`** `int` = `10000000`
  - 其它属性：getter=get_limit · setter=set_limit
- **`limit_smoothed`** `bool` = `false`
  - 其它属性：getter=is_limit_smoothing_enabled · setter=set_limit_smoothing_enabled
- **`limit_top`** `int` = `-10000000`
  - 其它属性：getter=get_limit · setter=set_limit
- **`offset`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_offset · setter=set_offset
- **`position_smoothing_enabled`** `bool` = `false`
  - 其它属性：getter=is_position_smoothing_enabled · setter=set_position_smoothing_enabled
- **`position_smoothing_speed`** `float` = `5.0`
  - 其它属性：getter=get_position_smoothing_speed · setter=set_position_smoothing_speed
- **`process_callback`** `int` = `1` · 枚举 `Camera2D.Camera2DProcessCallback`
  - 其它属性：getter=get_process_callback · setter=set_process_callback
- **`rotation_smoothing_enabled`** `bool` = `false`
  - 其它属性：getter=is_rotation_smoothing_enabled · setter=set_rotation_smoothing_enabled
- **`rotation_smoothing_speed`** `float` = `5.0`
  - 其它属性：getter=get_rotation_smoothing_speed · setter=set_rotation_smoothing_speed
- **`zoom`** `Vector2` = `Vector2(1, 1)`
  - 其它属性：getter=get_zoom · setter=set_zoom

## 方法

### `align() -> void`

Aligns the camera to the tracked node.
				**Note:** Calling `force_update_scroll` after this method is not required.

### `force_update_scroll() -> void`

Forces the camera to update scroll immediately.

### `get_drag_margin(margin: int) -> float`
- 限定：qualifiers=const

Returns the specified `Side`'s margin. See also `drag_bottom_margin`, `drag_top_margin`, `drag_left_margin`, and `drag_right_margin`.

### `get_limit(margin: int) -> int`
- 限定：qualifiers=const

Returns the camera limit for the specified `Side`. See also `limit_bottom`, `limit_top`, `limit_left`, and `limit_right`.

### `get_screen_center_position() -> Vector2`
- 限定：qualifiers=const

Returns the center of the screen from this camera's point of view, in global coordinates.
				**Note:** The exact targeted position of the camera may be different. See `get_target_position`.

### `get_screen_rotation() -> float`
- 限定：qualifiers=const

Returns the current screen rotation from this camera's point of view.
				**Note:** The screen rotation can be different from `Node2D.global_rotation` if the camera is rotating smoothly due to `rotation_smoothing_enabled`.

### `get_target_position() -> Vector2`
- 限定：qualifiers=const

Returns this camera's target position, in global coordinates.
				**Note:** The returned value is not the same as `Node2D.global_position`, as it is affected by the drag properties. It is also not the same as the current position if `position_smoothing_enabled` is `true` (see `get_screen_center_position`).

### `is_current() -> bool`
- 限定：qualifiers=const

Returns `true` if this `Camera2D` is the active camera (see `Viewport.get_camera_2d`).

### `make_current() -> void`

Forces this `Camera2D` to become the current active one. `enabled` must be `true`.

### `reset_smoothing() -> void`

Sets the camera's position immediately to its current smoothing destination.
				This method has no effect if `position_smoothing_enabled` is `false`.

### `set_drag_margin(margin: int, drag_margin: float) -> void`

Sets the specified `Side`'s margin. See also `drag_bottom_margin`, `drag_top_margin`, `drag_left_margin`, and `drag_right_margin`.

### `set_limit(margin: int, limit: int) -> void`

Sets the camera limit for the specified `Side`. See also `limit_bottom`, `limit_top`, `limit_left`, and `limit_right`.

## 枚举

### `AnchorMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ANCHOR_MODE_FIXED_TOP_LEFT` |  |
| `1` | `ANCHOR_MODE_DRAG_CENTER` |  |

### `Camera2DProcessCallback`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `CAMERA2D_PROCESS_PHYSICS` |  |
| `1` | `CAMERA2D_PROCESS_IDLE` |  |

## 教程链接

- [2D Platformer Demo](None)
- [2D Isometric Demo](None)

