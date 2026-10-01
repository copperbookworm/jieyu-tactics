# Camera3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Camera3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Camera3D.md`

**摘要**：Camera node, displays from a point of view.

## 描述

`Camera3D` is a special node that displays what is visible from its current location. Cameras register themselves in the nearest `Viewport` node (when ascending the tree). Only one camera can be active per viewport. If no viewport is available ascending the tree, the camera will register in the global viewport. In other words, a camera just provides 3D display capabilities to a `Viewport`, and, without one, a scene registered in that `Viewport` (or higher viewports) can't be displayed.

## 属性

- **`attributes`** `CameraAttributes`
  - 其它属性：getter=get_attributes · setter=set_attributes
- **`compositor`** `Compositor`
  - 其它属性：getter=get_compositor · setter=set_compositor
- **`cull_mask`** `int` = `1048575`
  - 其它属性：getter=get_cull_mask · setter=set_cull_mask
- **`current`** `bool` = `false`
  - 其它属性：getter=is_current · setter=set_current
- **`doppler_tracking`** `int` = `0` · 枚举 `Camera3D.DopplerTracking`
  - 其它属性：getter=get_doppler_tracking · setter=set_doppler_tracking
- **`environment`** `Environment`
  - 其它属性：getter=get_environment · setter=set_environment
- **`far`** `float` = `4000.0`
  - 其它属性：getter=get_far · setter=set_far
- **`fov`** `float` = `75.0`
  - 其它属性：getter=get_fov · setter=set_fov
- **`frustum_offset`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_frustum_offset · setter=set_frustum_offset
- **`h_offset`** `float` = `0.0`
  - 其它属性：getter=get_h_offset · setter=set_h_offset
- **`keep_aspect`** `int` = `1` · 枚举 `Camera3D.KeepAspect`
  - 其它属性：getter=get_keep_aspect_mode · setter=set_keep_aspect_mode
- **`near`** `float` = `0.05`
  - 其它属性：getter=get_near · setter=set_near
- **`projection`** `int` = `0` · 枚举 `Camera3D.ProjectionType`
  - 其它属性：getter=get_projection · setter=set_projection
- **`size`** `float` = `1.0`
  - 其它属性：getter=get_size · setter=set_size
- **`v_offset`** `float` = `0.0`
  - 其它属性：getter=get_v_offset · setter=set_v_offset

## 方法

### `clear_current(enable_next: bool = true) -> void`

If this is the current camera, remove it from being current. If `enable_next` is `true`, request to make the next camera current, if any.

### `get_camera_projection() -> Projection`
- 限定：qualifiers=const

Returns the projection matrix that this camera uses to render to its associated viewport. The camera must be part of the scene tree to function.

### `get_camera_rid() -> RID`
- 限定：qualifiers=const

Returns the camera's RID from the `RenderingServer`.

### `get_camera_transform() -> Transform3D`
- 限定：qualifiers=const

Returns the transform of the camera plus the vertical (`v_offset`) and horizontal (`h_offset`) offsets; and any other adjustments made to the position and orientation of the camera by subclassed cameras such as `XRCamera3D`.

### `get_cull_mask_value(layer_number: int) -> bool`
- 限定：qualifiers=const

Returns whether or not the specified layer of the `cull_mask` is enabled, given a `layer_number` between 1 and 20.

### `get_frustum() -> Plane[]`
- 限定：qualifiers=const

Returns the camera's frustum planes in world space units as an array of `Plane`s in the following order: near, far, left, top, right, bottom. Not to be confused with `frustum_offset`.

### `get_pyramid_shape_rid() -> RID`

Returns the RID of a pyramid shape encompassing the camera's view frustum, ignoring the camera's near plane. The tip of the pyramid represents the position of the camera.

### `is_position_behind(world_point: Vector3) -> bool`
- 限定：qualifiers=const

Returns `true` if the given position is behind the camera (the blue part of the linked diagram). See this diagram (https://raw.githubusercontent.com/godotengine/godot-docs/master/img/camera3d_position_frustum.png) for an overview of position query methods.
				**Note:** A position which returns `false` may still be outside the camera's field of view.

### `is_position_in_frustum(world_point: Vector3) -> bool`
- 限定：qualifiers=const

Returns `true` if the given position is inside the camera's frustum (the green part of the linked diagram). See this diagram (https://raw.githubusercontent.com/godotengine/godot-docs/master/img/camera3d_position_frustum.png) for an overview of position query methods.

### `make_current() -> void`

Makes this camera the current camera for the `Viewport` (see class description). If the camera node is outside the scene tree, it will attempt to become current once it's added.

### `project_local_ray_normal(screen_point: Vector2) -> Vector3`
- 限定：qualifiers=const

Returns a normal vector from the screen point location directed along the camera. Orthogonal cameras are normalized. Perspective cameras account for perspective, screen width/height, etc.

### `project_position(screen_point: Vector2, z_depth: float) -> Vector3`
- 限定：qualifiers=const

Returns the 3D point in world space that maps to the given 2D coordinate in the `Viewport` rectangle on a plane that is the given `z_depth` distance into the scene away from the camera.

### `project_ray_normal(screen_point: Vector2) -> Vector3`
- 限定：qualifiers=const

Returns a normal vector in world space, that is the result of projecting a point on the `Viewport` rectangle by the inverse camera projection. This is useful for casting rays in the form of (origin, normal) for object intersection or picking.

### `project_ray_origin(screen_point: Vector2) -> Vector3`
- 限定：qualifiers=const

Returns a 3D position in world space, that is the result of projecting a point on the `Viewport` rectangle by the inverse camera projection. This is useful for casting rays in the form of (origin, normal) for object intersection or picking.

### `set_cull_mask_value(layer_number: int, value: bool) -> void`

Based on `value`, enables or disables the specified layer in the `cull_mask`, given a `layer_number` between 1 and 20.

### `set_frustum(size: float, offset: Vector2, z_near: float, z_far: float) -> void`

Sets the camera projection to frustum mode (see `PROJECTION_FRUSTUM`), by specifying a `size`, an `offset`, and the `z_near` and `z_far` clip planes in world space units. The `size` parameter represents the size of the near plane, either its width or height depending on the value of `keep_aspect`. See also `frustum_offset`.

### `set_orthogonal(size: float, z_near: float, z_far: float) -> void`

Sets the camera projection to orthogonal mode (see `PROJECTION_ORTHOGONAL`), by specifying a `size`, and the `z_near` and `z_far` clip planes in world space units.
				As a hint, 3D games that look 2D often use this projection, with `size` specified in pixels.

### `set_perspective(fov: float, z_near: float, z_far: float) -> void`

Sets the camera projection to perspective mode (see `PROJECTION_PERSPECTIVE`), by specifying a `fov` (field of view) angle in degrees, and the `z_near` and `z_far` clip planes in world space units.

### `unproject_position(world_point: Vector3) -> Vector2`
- 限定：qualifiers=const

Returns the 2D coordinate in the `Viewport` rectangle that maps to the given 3D point in world space.
				**Note:** When using this to position GUI elements over a 3D viewport, use `is_position_behind` to prevent them from appearing if the 3D point is behind the camera:
				
```gdscript
				# This code block is part of a script that inherits from Node3D.
				# `control` is a reference to a node inheriting from Control.
				control.visible = not get_viewport().get_camera_3d().is_position_behind(global_transform.origin)
				control.position = get_viewport().get_camera_3d().unproject_position(global_transform.origin)
				
```

## 枚举

### `ProjectionType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `PROJECTION_PERSPECTIVE` |  |
| `1` | `PROJECTION_ORTHOGONAL` |  |
| `2` | `PROJECTION_FRUSTUM` |  |

### `KeepAspect`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `KEEP_WIDTH` |  |
| `1` | `KEEP_HEIGHT` |  |

### `DopplerTracking`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `DOPPLER_TRACKING_DISABLED` |  |
| `1` | `DOPPLER_TRACKING_IDLE_STEP` |  |
| `2` | `DOPPLER_TRACKING_PHYSICS_STEP` |  |

## 教程链接

- [Third Person Shooter (TPS) Demo](None)

