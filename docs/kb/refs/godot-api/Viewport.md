# Viewport

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Viewport` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Viewport.md`

**摘要**：Abstract base class for viewports. Encapsulates drawing and interaction with a game world.

## 描述

A `Viewport` creates a different view into the screen, or a sub-view inside another viewport. Child 2D nodes will display on it, and child Camera3D 3D nodes will render on it too.
		Optionally, a viewport can have its own 2D or 3D world, so it doesn't share what it draws with other viewports.
		Viewports can also choose to be audio listeners, so they generate positional audio depending on a 2D or 3D camera child of it.
		Also, viewports can be assigned to different screens in case the devices have multiple screens.
		Finally, viewports can also behave as render targets, in which case they will not be visible unless the associated texture is used to draw.

## 属性

- **`anisotropic_filtering_level`** `int` = `2` · 枚举 `Viewport.AnisotropicFiltering`
  - 其它属性：getter=get_anisotropic_filtering_level · setter=set_anisotropic_filtering_level
- **`audio_listener_enable_2d`** `bool` = `false`
  - 其它属性：getter=is_audio_listener_2d · setter=set_as_audio_listener_2d
- **`audio_listener_enable_3d`** `bool` = `false`
  - 其它属性：getter=is_audio_listener_3d · setter=set_as_audio_listener_3d
- **`canvas_cull_mask`** `int` = `4294967295`
  - 其它属性：getter=get_canvas_cull_mask · setter=set_canvas_cull_mask
- **`canvas_item_default_texture_filter`** `int` = `1` · 枚举 `Viewport.DefaultCanvasItemTextureFilter`
  - 其它属性：getter=get_default_canvas_item_texture_filter · setter=set_default_canvas_item_texture_filter
- **`canvas_item_default_texture_repeat`** `int` = `0` · 枚举 `Viewport.DefaultCanvasItemTextureRepeat`
  - 其它属性：getter=get_default_canvas_item_texture_repeat · setter=set_default_canvas_item_texture_repeat
- **`canvas_transform`** `Transform2D`
  - 其它属性：getter=get_canvas_transform · setter=set_canvas_transform
- **`debug_draw`** `int` = `0` · 枚举 `Viewport.DebugDraw`
  - 其它属性：getter=get_debug_draw · setter=set_debug_draw
- **`disable_3d`** `bool` = `false`
  - 其它属性：getter=is_3d_disabled · setter=set_disable_3d
- **`fsr_sharpness`** `float` = `0.2`
  - 其它属性：getter=get_fsr_sharpness · setter=set_fsr_sharpness
- **`global_canvas_transform`** `Transform2D`
  - 其它属性：getter=get_global_canvas_transform · setter=set_global_canvas_transform
- **`gui_disable_input`** `bool` = `false`
  - 其它属性：getter=is_input_disabled · setter=set_disable_input
- **`gui_drag_threshold`** `int` = `10`
  - 其它属性：getter=get_drag_threshold · setter=set_drag_threshold
- **`gui_embed_subwindows`** `bool` = `false`
  - 其它属性：getter=is_embedding_subwindows · setter=set_embedding_subwindows
- **`gui_snap_controls_to_pixels`** `bool` = `true`
  - 其它属性：getter=is_snap_controls_to_pixels_enabled · setter=set_snap_controls_to_pixels
- **`handle_input_locally`** `bool` = `true`
  - 其它属性：getter=is_handling_input_locally · setter=set_handle_input_locally
- **`mesh_lod_threshold`** `float` = `1.0`
  - 其它属性：getter=get_mesh_lod_threshold · setter=set_mesh_lod_threshold
- **`msaa_2d`** `int` = `0` · 枚举 `Viewport.MSAA`
  - 其它属性：getter=get_msaa_2d · setter=set_msaa_2d
- **`msaa_3d`** `int` = `0` · 枚举 `Viewport.MSAA`
  - 其它属性：getter=get_msaa_3d · setter=set_msaa_3d
- **`oversampling`** `bool` = `true`
  - 其它属性：getter=is_using_oversampling · setter=set_use_oversampling
- **`oversampling_override`** `float` = `0.0`
  - 其它属性：getter=get_oversampling_override · setter=set_oversampling_override
- **`own_world_3d`** `bool` = `false`
  - 其它属性：getter=is_using_own_world_3d · setter=set_use_own_world_3d
- **`physics_interpolation_mode`** `int` = `1` · 枚举 `Node.PhysicsInterpolationMode`
  - 其它属性：getter=get_physics_interpolation_mode · overrides=Node · setter=set_physics_interpolation_mode
- **`physics_object_picking`** `bool` = `false`
  - 其它属性：getter=get_physics_object_picking · setter=set_physics_object_picking
- **`physics_object_picking_first_only`** `bool` = `false`
  - 其它属性：getter=get_physics_object_picking_first_only · setter=set_physics_object_picking_first_only
- **`physics_object_picking_sort`** `bool` = `false`
  - 其它属性：getter=get_physics_object_picking_sort · setter=set_physics_object_picking_sort
- **`positional_shadow_atlas_16_bits`** `bool` = `true`
  - 其它属性：getter=get_positional_shadow_atlas_16_bits · setter=set_positional_shadow_atlas_16_bits
- **`positional_shadow_atlas_quad_0`** `int` = `2` · 枚举 `Viewport.PositionalShadowAtlasQuadrantSubdiv`
  - 其它属性：getter=get_positional_shadow_atlas_quadrant_subdiv · setter=set_positional_shadow_atlas_quadrant_subdiv
- **`positional_shadow_atlas_quad_1`** `int` = `2` · 枚举 `Viewport.PositionalShadowAtlasQuadrantSubdiv`
  - 其它属性：getter=get_positional_shadow_atlas_quadrant_subdiv · setter=set_positional_shadow_atlas_quadrant_subdiv
- **`positional_shadow_atlas_quad_2`** `int` = `3` · 枚举 `Viewport.PositionalShadowAtlasQuadrantSubdiv`
  - 其它属性：getter=get_positional_shadow_atlas_quadrant_subdiv · setter=set_positional_shadow_atlas_quadrant_subdiv
- **`positional_shadow_atlas_quad_3`** `int` = `4` · 枚举 `Viewport.PositionalShadowAtlasQuadrantSubdiv`
  - 其它属性：getter=get_positional_shadow_atlas_quadrant_subdiv · setter=set_positional_shadow_atlas_quadrant_subdiv
- **`positional_shadow_atlas_size`** `int` = `2048`
  - 其它属性：getter=get_positional_shadow_atlas_size · setter=set_positional_shadow_atlas_size
- **`scaling_3d_mode`** `int` = `0` · 枚举 `Viewport.Scaling3DMode`
  - 其它属性：getter=get_scaling_3d_mode · setter=set_scaling_3d_mode
- **`scaling_3d_scale`** `float` = `1.0`
  - 其它属性：getter=get_scaling_3d_scale · setter=set_scaling_3d_scale
- **`screen_space_aa`** `int` = `0` · 枚举 `Viewport.ScreenSpaceAA`
  - 其它属性：getter=get_screen_space_aa · setter=set_screen_space_aa
- **`sdf_oversize`** `int` = `1` · 枚举 `Viewport.SDFOversize`
  - 其它属性：getter=get_sdf_oversize · setter=set_sdf_oversize
- **`sdf_scale`** `int` = `1` · 枚举 `Viewport.SDFScale`
  - 其它属性：getter=get_sdf_scale · setter=set_sdf_scale
- **`snap_2d_transforms_to_pixel`** `bool` = `false`
  - 其它属性：getter=is_snap_2d_transforms_to_pixel_enabled · setter=set_snap_2d_transforms_to_pixel
- **`snap_2d_vertices_to_pixel`** `bool` = `false`
  - 其它属性：getter=is_snap_2d_vertices_to_pixel_enabled · setter=set_snap_2d_vertices_to_pixel
- **`texture_mipmap_bias`** `float` = `0.0`
  - 其它属性：getter=get_texture_mipmap_bias · setter=set_texture_mipmap_bias
- **`transparent_bg`** `bool` = `false`
  - 其它属性：getter=has_transparent_background · setter=set_transparent_background
- **`use_debanding`** `bool` = `false`
  - 其它属性：getter=is_using_debanding · setter=set_use_debanding
- **`use_hdr_2d`** `bool` = `false`
  - 其它属性：getter=is_using_hdr_2d · setter=set_use_hdr_2d
- **`use_occlusion_culling`** `bool` = `false`
  - 其它属性：getter=is_using_occlusion_culling · setter=set_use_occlusion_culling
- **`use_taa`** `bool` = `false`
  - 其它属性：getter=is_using_taa · setter=set_use_taa
- **`use_xr`** `bool` = `false`
  - 其它属性：getter=is_using_xr · setter=set_use_xr
- **`vrs_mode`** `int` = `0` · 枚举 `Viewport.VRSMode`
  - 其它属性：getter=get_vrs_mode · setter=set_vrs_mode
- **`vrs_texture`** `Texture2D`
  - 其它属性：getter=get_vrs_texture · setter=set_vrs_texture
- **`vrs_update_mode`** `int` = `1` · 枚举 `Viewport.VRSUpdateMode`
  - 其它属性：getter=get_vrs_update_mode · setter=set_vrs_update_mode
- **`world_2d`** `World2D`
  - 其它属性：getter=get_world_2d · setter=set_world_2d
- **`world_3d`** `World3D`
  - 其它属性：getter=get_world_3d · setter=set_world_3d

## 方法

### `find_world_2d() -> World2D`
- 限定：qualifiers=const

Returns the first valid `World2D` for this viewport, searching the `world_2d` property of itself and any Viewport ancestor.

### `find_world_3d() -> World3D`
- 限定：qualifiers=const

Returns the first valid `World3D` for this viewport, searching the `world_3d` property of itself and any Viewport ancestor.

### `get_audio_listener_2d() -> AudioListener2D`
- 限定：qualifiers=const

Returns the currently active 2D audio listener. Returns `null` if there are no active 2D audio listeners, in which case the active 2D camera will be treated as listener.

### `get_audio_listener_3d() -> AudioListener3D`
- 限定：qualifiers=const

Returns the currently active 3D audio listener. Returns `null` if there are no active 3D audio listeners, in which case the active 3D camera will be treated as listener.

### `get_camera_2d() -> Camera2D`
- 限定：qualifiers=const

Returns the currently active 2D camera. Returns `null` if there are no active cameras.
				**Note:** If called while the *Camera Override* system is active in editor, this will return the internally managed override camera. It is therefore advised to avoid caching the return value, or to check that the cached value is still a valid instance and is the current camera before use. See `@GlobalScope.is_instance_valid` and `Camera2D.is_current`.

### `get_camera_3d() -> Camera3D`
- 限定：qualifiers=const

Returns the currently active 3D camera. Returns `null` if there are no active cameras.
				**Note:** If called while the *Camera Override* system is active in editor, this will return the internally managed override camera. It is therefore advised to avoid caching the return value, or to check that the cached value is a valid instance and is the current camera before use. See `@GlobalScope.is_instance_valid` and `Camera3D.current`.

### `get_canvas_cull_mask_bit(layer: int) -> bool`
- 限定：qualifiers=const

Returns an individual bit on the rendering layer mask.

### `get_embedded_subwindows() -> Window[]`
- 限定：qualifiers=const

Returns a list of the visible embedded `Window`s inside the viewport.
				**Note:** `Window`s inside other viewports will not be listed.

### `get_final_transform() -> Transform2D`
- 限定：qualifiers=const

Returns the transform from the viewport's coordinate system to the embedder's coordinate system.

### `get_mouse_position() -> Vector2`
- 限定：qualifiers=const

Returns the mouse's position in this `Viewport` using the coordinate system of this `Viewport`.

### `get_oversampling() -> float`
- 限定：qualifiers=const

Returns viewport oversampling factor.

### `get_positional_shadow_atlas_quadrant_subdiv(quadrant: int) -> int`
- 限定：qualifiers=const

Returns the positional shadow atlas quadrant subdivision of the specified quadrant.

### `get_render_info(type: int, info: int) -> int`

Returns rendering statistics of the given type.

### `get_screen_transform() -> Transform2D`
- 限定：qualifiers=const

Returns the transform from the Viewport's coordinates to the screen coordinates of the containing window manager window.

### `get_stretch_transform() -> Transform2D`
- 限定：qualifiers=const

Returns the automatically computed 2D stretch transform, taking the `Viewport`'s stretch settings into account. The final value is multiplied by `Window.content_scale_factor`, but only for the root viewport. If this method is called on a `SubViewport` (e.g., in a scene tree with `SubViewportContainer` and `SubViewport`), the scale factor of the root window will not be applied. Using `Transform2D.get_scale` on the returned value, this can be used to compensate for scaling when zooming a `Camera2D` node, or to scale down a `TextureRect` to be pixel-perfect regardless of the automatically computed scale factor.
				**Note:** Due to how pixel scaling works, the returned transform's X and Y scale may differ slightly, even when `Window.content_scale_aspect` is set to a mode that preserves the pixels' aspect ratio. If `Window.content_scale_aspect` is `Window.CONTENT_SCALE_ASPECT_IGNORE`, the X and Y scale may differ *significantly*.

### `get_texture() -> ViewportTexture`
- 限定：qualifiers=const

Returns the viewport's texture.
				**Note:** When trying to store the current texture (e.g. in a file), it might be completely black or outdated if used too early, especially when used in e.g. `Node._ready`. To make sure the texture you get is correct, you can await `RenderingServer.frame_post_draw` signal.
				`codeblocks`
				`gdscript`
				func _ready():
				    await RenderingServer.frame_post_draw
				    $Viewport.get_texture().get_image().save_png("user://Screenshot.png")
				
				`csharp`
				public async override void _Ready()
				{
				    await ToSignal(RenderingServer.Singleton, RenderingServer.SignalName.FramePostDraw);
				    var viewport = GetNode<Viewport>("Viewport");
				    viewport.GetTexture().GetImage().SavePng("user://Screenshot.png");
				}
				
				
				**Note:** When `use_hdr_2d` is `true` the returned texture will be an HDR image using linear encoding.

### `get_viewport_rid() -> RID`
- 限定：qualifiers=const

Returns the viewport's RID from the `RenderingServer`.

### `get_visible_rect() -> Rect2`
- 限定：qualifiers=const

Returns the visible rectangle in global screen coordinates.

### `gui_cancel_drag() -> void`

Cancels the drag operation that was previously started through `Control._get_drag_data` or forced with `Control.force_drag`.

### `gui_get_drag_data() -> Variant`
- 限定：qualifiers=const

Returns the drag data from the GUI, that was previously returned by `Control._get_drag_data`.

### `gui_get_drag_description() -> String`
- 限定：qualifiers=const

Returns the human-readable description of the drag data, used for assistive apps.

### `gui_get_focus_owner() -> Control`
- 限定：qualifiers=const

Returns the currently focused `Control` within this viewport. If no `Control` is focused, returns `null`.

### `gui_get_hovered_control() -> Control`
- 限定：qualifiers=const

Returns the `Control` that the mouse is currently hovering over in this viewport. If no `Control` has the cursor, returns `null`.
				Typically the leaf `Control` node or deepest level of the subtree which claims hover. This is very useful when used together with `Node.is_ancestor_of` to find if the mouse is within a control tree.

### `gui_is_drag_successful() -> bool`
- 限定：qualifiers=const

Returns `true` if the drag operation is successful.

### `gui_is_dragging() -> bool`
- 限定：qualifiers=const

Returns `true` if a drag operation is currently ongoing and where the drop action could happen in this viewport.
				Alternative to `Node.NOTIFICATION_DRAG_BEGIN` and `Node.NOTIFICATION_DRAG_END` when you prefer polling the value.

### `gui_release_focus() -> void`

Removes the focus from the currently focused `Control` within this viewport. If no `Control` has the focus, does nothing.

### `gui_set_drag_description(description: String) -> void`

Sets the human-readable description of the drag data to `description`, used for assistive apps.

### `is_input_handled() -> bool`
- 限定：qualifiers=const

Returns whether the current `InputEvent` has been handled. Input events are not handled until `set_input_as_handled` has been called during the lifetime of an `InputEvent`.
				This is usually done as part of input handling methods like `Node._input`, `Control._gui_input` or others, as well as in corresponding signal handlers.
				If `handle_input_locally` is set to `false`, this method will try finding the first parent viewport that is set to handle input locally, and return its value for `is_input_handled` instead.

### `notify_mouse_entered() -> void`

Inform the Viewport that the mouse has entered its area. Use this function before sending an `InputEventMouseButton` or `InputEventMouseMotion` to the `Viewport` with `Viewport.push_input`. See also `notify_mouse_exited`.
				**Note:** In most cases, it is not necessary to call this function because `SubViewport` nodes that are children of `SubViewportContainer` are notified automatically. This is only necessary when interacting with viewports in non-default ways, for example as textures in `TextureRect` or with an `Area3D` that forwards input events.

### `notify_mouse_exited() -> void`

Inform the Viewport that the mouse has left its area. Use this function when the node that displays the viewport notices the mouse has left the area of the displayed viewport. See also `notify_mouse_entered`.
				**Note:** In most cases, it is not necessary to call this function because `SubViewport` nodes that are children of `SubViewportContainer` are notified automatically. This is only necessary when interacting with viewports in non-default ways, for example as textures in `TextureRect` or with an `Area3D` that forwards input events.

### `push_input(event: InputEvent, in_local_coords: bool = false) -> void`

Triggers the given `event` in this `Viewport`. This can be used to pass an `InputEvent` between viewports, or to locally apply inputs that were sent over the network or saved to a file.
				If `in_local_coords` is `false`, the event's position is in the embedder's coordinates and will be converted to viewport coordinates. If `in_local_coords` is `true`, the event's position is in viewport coordinates.
				While this method serves a similar purpose as `Input.parse_input_event`, it does not remap the specified `event` based on project settings like `ProjectSettings.input_devices/pointing/emulate_touch_from_mouse`.
				Calling this method will propagate calls to child nodes for following methods in the given order:
				- `Node._input`
				- `Control._gui_input` for `Control` nodes
				- `Node._shortcut_input`
				- `Node._unhandled_key_input`
				- `Node._unhandled_input`
				If an earlier method marks the input as handled via `set_input_as_handled`, any later method in this list will not be called.
				If none of the methods handle the event and `physics_object_picking` is `true`, the event is used for physics object picking.

### `push_text_input(text: String) -> void`

Helper method which calls the `set_text()` method on the currently focused `Control`, provided that it is defined (e.g. if the focused Control is `Button` or `LineEdit`).

### `push_unhandled_input(event: InputEvent, in_local_coords: bool = false) -> void`
- 限定：deprecated=Use [method push_input] instead.

Triggers the given `event` in this `Viewport`. This can be used to pass an `InputEvent` between viewports, or to locally apply inputs that were sent over the network or saved to a file.
				If `in_local_coords` is `false`, the event's position is in the embedder's coordinates and will be converted to viewport coordinates. If `in_local_coords` is `true`, the event's position is in viewport coordinates.
				Calling this method will propagate calls to child nodes for following methods in the given order:
				- `Node._shortcut_input`
				- `Node._unhandled_key_input`
				- `Node._unhandled_input`
				If an earlier method marks the input as handled via `set_input_as_handled`, any later method in this list will not be called.
				If none of the methods handle the event and `physics_object_picking` is `true`, the event is used for physics object picking.
				**Note:** This method doesn't propagate input events to embedded `Window`s or `SubViewport`s.

### `set_canvas_cull_mask_bit(layer: int, enable: bool) -> void`

Set/clear individual bits on the rendering layer mask. This simplifies editing this `Viewport`'s layers.

### `set_input_as_handled() -> void`

Stops the input from propagating further up the `SceneTree`.
				**Note:** This does not affect the methods in `Input`, only the way events are propagated.

### `set_positional_shadow_atlas_quadrant_subdiv(quadrant: int, subdiv: int) -> void`

Sets the number of subdivisions to use in the specified quadrant. A higher number of subdivisions allows you to have more shadows in the scene at once, but reduces the quality of the shadows. A good practice is to have quadrants with a varying number of subdivisions and to have as few subdivisions as possible.

### `update_mouse_cursor_state() -> void`

Force instantly updating the display based on the current mouse cursor position. This includes updating the mouse cursor shape and sending necessary `Control.mouse_entered`, `CollisionObject2D.mouse_entered`, `CollisionObject3D.mouse_entered` and `Window.mouse_entered` signals and their respective `mouse_exited` counterparts.

### `warp_mouse(position: Vector2) -> void`

Moves the mouse pointer to the specified position in this `Viewport` using the coordinate system of this `Viewport`.
				**Note:** `warp_mouse` is only supported on Windows, macOS and Linux. It has no effect on Android, iOS and Web.

## 信号

### `gui_focus_changed(node: Control)`

Emitted when a Control node grabs keyboard focus.
				**Note:** A Control node losing focus doesn't cause this signal to be emitted.

### `size_changed()`

Emitted when the size of the viewport is changed, whether by resizing of window, or some other means.

## 枚举

### `PositionalShadowAtlasQuadrantSubdiv`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SHADOW_ATLAS_QUADRANT_SUBDIV_DISABLED` |  |
| `1` | `SHADOW_ATLAS_QUADRANT_SUBDIV_1` |  |
| `2` | `SHADOW_ATLAS_QUADRANT_SUBDIV_4` |  |
| `3` | `SHADOW_ATLAS_QUADRANT_SUBDIV_16` |  |
| `4` | `SHADOW_ATLAS_QUADRANT_SUBDIV_64` |  |
| `5` | `SHADOW_ATLAS_QUADRANT_SUBDIV_256` |  |
| `6` | `SHADOW_ATLAS_QUADRANT_SUBDIV_1024` |  |
| `7` | `SHADOW_ATLAS_QUADRANT_SUBDIV_MAX` |  |

### `Scaling3DMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SCALING_3D_MODE_BILINEAR` |  |
| `1` | `SCALING_3D_MODE_FSR` |  |
| `2` | `SCALING_3D_MODE_FSR2` |  |
| `3` | `SCALING_3D_MODE_METALFX_SPATIAL` |  |
| `4` | `SCALING_3D_MODE_METALFX_TEMPORAL` |  |
| `5` | `SCALING_3D_MODE_NEAREST` |  |
| `6` | `SCALING_3D_MODE_MAX` |  |

### `MSAA`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `MSAA_DISABLED` |  |
| `1` | `MSAA_2X` |  |
| `2` | `MSAA_4X` |  |
| `3` | `MSAA_8X` |  |
| `4` | `MSAA_MAX` |  |

### `AnisotropicFiltering`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ANISOTROPY_DISABLED` |  |
| `1` | `ANISOTROPY_2X` |  |
| `2` | `ANISOTROPY_4X` |  |
| `3` | `ANISOTROPY_8X` |  |
| `4` | `ANISOTROPY_16X` |  |
| `5` | `ANISOTROPY_MAX` |  |

### `ScreenSpaceAA`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SCREEN_SPACE_AA_DISABLED` |  |
| `1` | `SCREEN_SPACE_AA_FXAA` |  |
| `2` | `SCREEN_SPACE_AA_SMAA` |  |
| `3` | `SCREEN_SPACE_AA_MAX` |  |

### `RenderInfo`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `RENDER_INFO_OBJECTS_IN_FRAME` |  |
| `1` | `RENDER_INFO_PRIMITIVES_IN_FRAME` |  |
| `2` | `RENDER_INFO_DRAW_CALLS_IN_FRAME` |  |
| `3` | `RENDER_INFO_MAX` |  |

### `RenderInfoType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `RENDER_INFO_TYPE_VISIBLE` |  |
| `1` | `RENDER_INFO_TYPE_SHADOW` |  |
| `2` | `RENDER_INFO_TYPE_CANVAS` |  |
| `3` | `RENDER_INFO_TYPE_MAX` |  |

### `DebugDraw`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `DEBUG_DRAW_DISABLED` |  |
| `1` | `DEBUG_DRAW_UNSHADED` |  |
| `2` | `DEBUG_DRAW_LIGHTING` |  |
| `3` | `DEBUG_DRAW_OVERDRAW` |  |
| `4` | `DEBUG_DRAW_WIREFRAME` |  |
| `5` | `DEBUG_DRAW_NORMAL_BUFFER` |  |
| `6` | `DEBUG_DRAW_VOXEL_GI_ALBEDO` |  |
| `7` | `DEBUG_DRAW_VOXEL_GI_LIGHTING` |  |
| `8` | `DEBUG_DRAW_VOXEL_GI_EMISSION` |  |
| `9` | `DEBUG_DRAW_SHADOW_ATLAS` |  |
| `10` | `DEBUG_DRAW_DIRECTIONAL_SHADOW_ATLAS` |  |
| `11` | `DEBUG_DRAW_SCENE_LUMINANCE` |  |
| `12` | `DEBUG_DRAW_SSAO` |  |
| `13` | `DEBUG_DRAW_SSIL` |  |
| `14` | `DEBUG_DRAW_PSSM_SPLITS` |  |
| `15` | `DEBUG_DRAW_DECAL_ATLAS` |  |
| `16` | `DEBUG_DRAW_SDFGI` |  |
| `17` | `DEBUG_DRAW_SDFGI_PROBES` |  |
| `18` | `DEBUG_DRAW_GI_BUFFER` |  |
| `19` | `DEBUG_DRAW_DISABLE_LOD` |  |
| `20` | `DEBUG_DRAW_CLUSTER_OMNI_LIGHTS` |  |
| `21` | `DEBUG_DRAW_CLUSTER_SPOT_LIGHTS` |  |
| `22` | `DEBUG_DRAW_CLUSTER_DECALS` |  |
| `23` | `DEBUG_DRAW_CLUSTER_REFLECTION_PROBES` |  |
| `24` | `DEBUG_DRAW_OCCLUDERS` |  |
| `25` | `DEBUG_DRAW_MOTION_VECTORS` |  |
| `26` | `DEBUG_DRAW_INTERNAL_BUFFER` |  |
| `27` | `DEBUG_DRAW_CLUSTER_AREA_LIGHTS` |  |
| `28` | `DEBUG_DRAW_AREA_LIGHT_ATLAS` |  |

### `DefaultCanvasItemTextureFilter`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST` |  |
| `1` | `DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_LINEAR` |  |
| `2` | `DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_LINEAR_WITH_MIPMAPS` |  |
| `3` | `DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST_WITH_MIPMAPS` |  |
| `4` | `DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_PARENT_NODE` |  |
| `5` | `DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_MAX` |  |

### `DefaultCanvasItemTextureRepeat`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `DEFAULT_CANVAS_ITEM_TEXTURE_REPEAT_DISABLED` |  |
| `1` | `DEFAULT_CANVAS_ITEM_TEXTURE_REPEAT_ENABLED` |  |
| `2` | `DEFAULT_CANVAS_ITEM_TEXTURE_REPEAT_MIRROR` |  |
| `3` | `DEFAULT_CANVAS_ITEM_TEXTURE_REPEAT_PARENT_NODE` |  |
| `4` | `DEFAULT_CANVAS_ITEM_TEXTURE_REPEAT_MAX` |  |

### `SDFOversize`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SDF_OVERSIZE_100_PERCENT` |  |
| `1` | `SDF_OVERSIZE_120_PERCENT` |  |
| `2` | `SDF_OVERSIZE_150_PERCENT` |  |
| `3` | `SDF_OVERSIZE_200_PERCENT` |  |
| `4` | `SDF_OVERSIZE_MAX` |  |

### `SDFScale`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SDF_SCALE_100_PERCENT` |  |
| `1` | `SDF_SCALE_50_PERCENT` |  |
| `2` | `SDF_SCALE_25_PERCENT` |  |
| `3` | `SDF_SCALE_MAX` |  |

### `VRSMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `VRS_DISABLED` |  |
| `1` | `VRS_TEXTURE` |  |
| `2` | `VRS_XR` |  |
| `3` | `VRS_MAX` |  |

### `VRSUpdateMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `VRS_UPDATE_DISABLED` |  |
| `1` | `VRS_UPDATE_ONCE` |  |
| `2` | `VRS_UPDATE_ALWAYS` |  |
| `3` | `VRS_UPDATE_MAX` |  |

## 教程链接

- [Using Viewports](None)
- [Viewport and canvas transforms](None)
- [GUI in 3D Viewport Demo](None)
- [3D in 2D Viewport Demo](None)
- [2D in 3D Viewport Demo](None)
- [Screen Capture Demo](None)
- [Dynamic Split Screen Demo](None)
- [3D Resolution Scaling Demo](None)

