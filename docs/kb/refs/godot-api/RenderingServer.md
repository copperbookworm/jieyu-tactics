# RenderingServer

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`RenderingServer` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/RenderingServer.md`

**摘要**：Server for anything visible.

## 描述

The rendering server is the API backend for everything visible. The whole scene system mounts on it to display. The rendering server is completely opaque: the internals are entirely implementation-specific and cannot be accessed.
		The rendering server can be used to bypass the scene/`Node` system entirely. This can improve performance in cases where the scene system is the bottleneck, but won't improve performance otherwise (for instance, if the GPU is already fully utilized).
		Resources are created using the `*_create` functions. These functions return `RID`s which are not references to the objects themselves, but opaque *pointers* towards these objects.
		All objects are drawn to a viewport. You can use the `Viewport` attached to the `SceneTree` or you can create one yourself with `viewport_create`. When using a custom scenario or canvas, the scenario or canvas needs to be attached to the viewport using `viewport_set_scenario` or `viewport_attach_canvas`.
		**Scenarios:** In 3D, all visual objects must be associated with a scenario. The scenario is a visual representation of the world. If accessing the rendering server from a running game, the scenario can be accessed from the scene tree from any `Node3D` node with `Node3D.get_world_3d`. Otherwise, a scenario can be created with `scenario_create`.
		Similarly, in 2D, a canvas is needed to draw all canvas items.
		**3D:** In 3D, all visible objects are comprised of a resource and an instance. A resource can be a mesh, a particle system, a light, or any other 3D object. In order to be visible resources must be attached to an instance using `instance_set_base`. The instance must also be attached to the scenario using `instance_set_scenario` in order to be visible. RenderingServer methods that don't have a prefix are usually 3D-specific (but not always).
		**2D:** In 2D, all visible objects are some form of canvas item. In order to be visible, a canvas item needs to be the child of a canvas attached to a viewport, or it needs to be the child of another canvas item that is eventually attached to the canvas. 2D-specific RenderingServer methods generally start with `canvas_*`.
		**Headless mode:** Starting the engine with the `--headless` command line argument ($DOCS_URL/tutorials/editor/command_line_tutorial.html) disables all rendering and window management functions. Most functions from `RenderingServer` will return dummy values in this case.

## 属性

- **`render_loop_enabled`** `bool`
  - 其它属性：getter=is_render_loop_enabled · setter=set_render_loop_enabled

## 方法

### `area_light_create() -> RID`

Creates a new area light and adds it to the RenderingServer. It can be accessed with the RID that is returned. This RID can be used in most `light_*` RenderingServer functions.
				Once finished with your RID, you will want to free the RID using the RenderingServer's `free_rid` method.
				To place in a scene, attach this area light to an instance using `instance_set_base` using the returned RID.
				**Note:** The equivalent node is `AreaLight3D`.

### `bake_render_uv2(base: RID, material_overrides: RID[], image_size: Vector2i) -> Image[]`

Bakes the material data of the Mesh passed in the `base` parameter with optional `material_overrides` to a set of `Image`s of size `image_size`. Returns an array of `Image`s containing material properties as specified in `BakeChannels`.

### `call_on_render_thread(callable: Callable) -> void`

As the RenderingServer actual logic may run on a separate thread, accessing its internals from the main (or any other) thread will result in errors. To make it easier to run code that can safely access the rendering internals (such as `RenderingDevice` and similar RD classes), push a callable via this function so it will be executed on the render thread.

### `camera_attributes_create() -> RID`

Creates a camera attributes object and adds it to the RenderingServer. It can be accessed with the RID that is returned. This RID will be used in all `camera_attributes_` RenderingServer functions.
				Once finished with your RID, you will want to free the RID using the RenderingServer's `free_rid` method.
				**Note:** The equivalent resource is `CameraAttributes`.

### `camera_attributes_set_auto_exposure(camera_attributes: RID, enable: bool, min_sensitivity: float, max_sensitivity: float, speed: float, scale: float) -> void`

Sets the parameters to use with the auto-exposure effect. These parameters take on the same meaning as their counterparts in `CameraAttributes` and `CameraAttributesPractical`.

### `camera_attributes_set_dof_blur(camera_attributes: RID, far_enable: bool, far_distance: float, far_transition: float, near_enable: bool, near_distance: float, near_transition: float, amount: float) -> void`

Sets the parameters to use with the DOF blur effect. These parameters take on the same meaning as their counterparts in `CameraAttributesPractical`.

### `camera_attributes_set_dof_blur_bokeh_shape(shape: int) -> void`

Sets the shape of the DOF bokeh pattern to `shape`. Different shapes may be used to achieve artistic effect, or to meet performance targets.

### `camera_attributes_set_dof_blur_quality(quality: int, use_jitter: bool) -> void`

Sets the quality level of the DOF blur effect to `quality`. `use_jitter` can be used to jitter samples taken during the blur pass to hide artifacts at the cost of looking more fuzzy.

### `camera_attributes_set_exposure(camera_attributes: RID, multiplier: float, normalization: float) -> void`

Sets the exposure values that will be used by the renderers. The normalization amount is used to bake a given Exposure Value (EV) into rendering calculations to reduce the dynamic range of the scene.
				The normalization factor can be calculated from exposure value (EV100) as follows:
				
```gdscript
				func get_exposure_normalization(ev100: float):
					return 1.0 / (pow(2.0, ev100) * 1.2)
				
```

				The exposure value can be calculated from aperture (in f-stops), shutter speed (in seconds), and sensitivity (in ISO) as follows:
				
```gdscript
				func get_exposure(aperture: float, shutter_speed: float, sensitivity: float):
					return log((aperture * aperture) / shutter_speed * (100.0 / sensitivity)) / log(2)
				
```

### `camera_create() -> RID`

Creates a 3D camera and adds it to the RenderingServer. It can be accessed with the RID that is returned. This RID will be used in all `camera_*` RenderingServer functions.
				Once finished with your RID, you will want to free the RID using the RenderingServer's `free_rid` method.
				**Note:** The equivalent node is `Camera3D`.

### `camera_set_camera_attributes(camera: RID, effects: RID) -> void`

Sets the camera_attributes created with `camera_attributes_create` to the given camera.

### `camera_set_compositor(camera: RID, compositor: RID) -> void`

Sets the compositor used by this camera. Equivalent to `Camera3D.compositor`.

### `camera_set_cull_mask(camera: RID, layers: int) -> void`

Sets the cull mask associated with this camera. The cull mask describes which 3D layers are rendered by this camera. Equivalent to `Camera3D.cull_mask`.

### `camera_set_environment(camera: RID, env: RID) -> void`

Sets the environment used by this camera. Equivalent to `Camera3D.environment`.

### `camera_set_frustum(camera: RID, size: float, offset: Vector2, z_near: float, z_far: float) -> void`

Sets camera to use frustum projection. This mode allows adjusting the `offset` argument to create "tilted frustum" effects.

### `camera_set_orthogonal(camera: RID, size: float, z_near: float, z_far: float) -> void`

Sets camera to use orthogonal projection, also known as orthographic projection. Objects remain the same size on the screen no matter how far away they are.

### `camera_set_perspective(camera: RID, fovy_degrees: float, z_near: float, z_far: float) -> void`

Sets camera to use perspective projection. Objects on the screen becomes smaller when they are far away.

### `camera_set_transform(camera: RID, transform: Transform3D) -> void`

Sets `Transform3D` of camera.

### `camera_set_use_vertical_aspect(camera: RID, enable: bool) -> void`

If `true`, preserves the horizontal aspect ratio which is equivalent to `Camera3D.KEEP_WIDTH`. If `false`, preserves the vertical aspect ratio which is equivalent to `Camera3D.KEEP_HEIGHT`.

### `canvas_create() -> RID`

Creates a canvas and returns the assigned `RID`. It can be accessed with the RID that is returned. This RID will be used in all `canvas_*` RenderingServer functions.
				Once finished with your RID, you will want to free the RID using the RenderingServer's `free_rid` method.
				Canvas has no `Resource` or `Node` equivalent.

### `canvas_item_add_animation_slice(item: RID, animation_length: float, slice_begin: float, slice_end: float, offset: float = 0.0) -> void`

Subsequent drawing commands will be ignored unless they fall within the specified animation slice. This is a faster way to implement animations that loop on background rather than redrawing constantly.

### `canvas_item_add_circle(item: RID, pos: Vector2, radius: float, color: Color, antialiased: bool = false) -> void`

Draws a circle on the `CanvasItem` pointed to by the `item` `RID`. See also `CanvasItem.draw_circle`.

### `canvas_item_add_clip_ignore(item: RID, ignore: bool) -> void`

If `ignore` is `true`, ignore clipping on items drawn with this canvas item until this is called again with `ignore` set to `false`.

### `canvas_item_add_ellipse(item: RID, pos: Vector2, major: float, minor: float, color: Color, antialiased: bool = false) -> void`

Draws an ellipse with semi-major axis `major` and semi-minor axis `minor` on the `CanvasItem` pointed to by the `item` `RID`. See also `CanvasItem.draw_ellipse`.

### `canvas_item_add_lcd_texture_rect_region(item: RID, rect: Rect2, texture: RID, src_rect: Rect2, modulate: Color) -> void`

See also `CanvasItem.draw_lcd_texture_rect_region`.

### `canvas_item_add_line(item: RID, from: Vector2, to: Vector2, color: Color, width: float = -1.0, antialiased: bool = false) -> void`

Draws a line on the `CanvasItem` pointed to by the `item` `RID`. See also `CanvasItem.draw_line`.

### `canvas_item_add_mesh(item: RID, mesh: RID, transform: Transform2D = Transform2D(1, 0, 0, 1, 0, 0), modulate: Color = Color(1, 1, 1, 1), texture: RID = RID()) -> void`

Draws a mesh created with `mesh_create` with given `transform`, `modulate` color, and `texture`. This is used internally by `MeshInstance2D`.

### `canvas_item_add_msdf_texture_rect_region(item: RID, rect: Rect2, texture: RID, src_rect: Rect2, modulate: Color = Color(1, 1, 1, 1), outline_size: int = 0, px_range: float = 1.0, scale: float = 1.0) -> void`

See also `CanvasItem.draw_msdf_texture_rect_region`.

### `canvas_item_add_multiline(item: RID, points: PackedVector2Array, colors: PackedColorArray, width: float = -1.0, antialiased: bool = false) -> void`

Draws a 2D multiline on the `CanvasItem` pointed to by the `item` `RID`. See also `CanvasItem.draw_multiline` and `CanvasItem.draw_multiline_colors`.

### `canvas_item_add_multimesh(item: RID, mesh: RID, texture: RID = RID()) -> void`

Draws a 2D `MultiMesh` on the `CanvasItem` pointed to by the `item` `RID`. See also `CanvasItem.draw_multimesh`.

### `canvas_item_add_nine_patch(item: RID, rect: Rect2, source: Rect2, texture: RID, topleft: Vector2, bottomright: Vector2, x_axis_mode: int = 0, y_axis_mode: int = 0, draw_center: bool = true, modulate: Color = Color(1, 1, 1, 1)) -> void`

Draws a nine-patch rectangle on the `CanvasItem` pointed to by the `item` `RID`.

### `canvas_item_add_particles(item: RID, particles: RID, texture: RID) -> void`

Draws particles on the `CanvasItem` pointed to by the `item` `RID`.

### `canvas_item_add_polygon(item: RID, points: PackedVector2Array, colors: PackedColorArray, uvs: PackedVector2Array = PackedVector2Array(), texture: RID = RID()) -> void`

Draws a 2D polygon on the `CanvasItem` pointed to by the `item` `RID`. If you need more flexibility (such as being able to use bones), use `canvas_item_add_triangle_array` instead. See also `CanvasItem.draw_polygon`.
				**Note:** If you frequently redraw the same polygon with a large number of vertices, consider pre-calculating the triangulation with `Geometry2D.triangulate_polygon` and using `CanvasItem.draw_mesh`, `CanvasItem.draw_multimesh`, or `canvas_item_add_triangle_array`.

### `canvas_item_add_polyline(item: RID, points: PackedVector2Array, colors: PackedColorArray, width: float = -1.0, antialiased: bool = false) -> void`

Draws a 2D polyline on the `CanvasItem` pointed to by the `item` `RID`. See also `CanvasItem.draw_polyline` and `CanvasItem.draw_polyline_colors`.

### `canvas_item_add_primitive(item: RID, points: PackedVector2Array, colors: PackedColorArray, uvs: PackedVector2Array, texture: RID) -> void`

Draws a 2D primitive on the `CanvasItem` pointed to by the `item` `RID`. See also `CanvasItem.draw_primitive`.

### `canvas_item_add_rect(item: RID, rect: Rect2, color: Color, antialiased: bool = false) -> void`

Draws a rectangle on the `CanvasItem` pointed to by the `item` `RID`. See also `CanvasItem.draw_rect`.

### `canvas_item_add_set_transform(item: RID, transform: Transform2D) -> void`

Sets a `Transform2D` that will be used to transform subsequent canvas item commands.

### `canvas_item_add_texture_rect(item: RID, rect: Rect2, texture: RID, tile: bool = false, modulate: Color = Color(1, 1, 1, 1), transpose: bool = false) -> void`

Draws a 2D textured rectangle on the `CanvasItem` pointed to by the `item` `RID`. See also `CanvasItem.draw_texture_rect` and `Texture2D.draw_rect`.

### `canvas_item_add_texture_rect_region(item: RID, rect: Rect2, texture: RID, src_rect: Rect2, modulate: Color = Color(1, 1, 1, 1), transpose: bool = false, clip_uv: bool = true) -> void`

Draws the specified region of a 2D textured rectangle on the `CanvasItem` pointed to by the `item` `RID`. See also `CanvasItem.draw_texture_rect_region` and `Texture2D.draw_rect_region`.

### `canvas_item_add_triangle_array(item: RID, indices: PackedInt32Array, points: PackedVector2Array, colors: PackedColorArray, uvs: PackedVector2Array = PackedVector2Array(), bones: PackedInt32Array = PackedInt32Array(), weights: PackedFloat32Array = PackedFloat32Array(), texture: RID = RID(), count: int = -1) -> void`

Draws a triangle array on the `CanvasItem` pointed to by the `item` `RID`. This is internally used by `Line2D` and `StyleBoxFlat` for rendering. `canvas_item_add_triangle_array` is highly flexible, but more complex to use than `canvas_item_add_polygon`.
				**Note:** If `count` is set to a non-negative value, only the first `count * 3` indices (corresponding to `skip-lint`count triangles) will be drawn. Otherwise, all indices are drawn.

### `canvas_item_attach_skeleton(item: RID, skeleton: RID) -> void`

Attaches a skeleton to the `CanvasItem`. Removes the previous skeleton.

### `canvas_item_clear(item: RID) -> void`

Clears the `CanvasItem` and removes all commands in it.

### `canvas_item_create() -> RID`

Creates a new CanvasItem instance and returns its `RID`. It can be accessed with the RID that is returned. This RID will be used in all `canvas_item_*` RenderingServer functions.
				Once finished with your RID, you will want to free the RID using the RenderingServer's `free_rid` method.
				**Note:** The equivalent node is `CanvasItem`.

### `canvas_item_get_instance_shader_parameter(instance: RID, parameter: StringName) -> Variant`
- 限定：qualifiers=const

Returns the value of the per-instance shader uniform from the specified canvas item instance. Equivalent to `CanvasItem.get_instance_shader_parameter`.

### `canvas_item_get_instance_shader_parameter_default_value(instance: RID, parameter: StringName) -> Variant`
- 限定：qualifiers=const

Returns the default value of the per-instance shader uniform from the specified canvas item instance. Equivalent to `CanvasItem.get_instance_shader_parameter`.

### `canvas_item_get_instance_shader_parameter_list(instance: RID) -> Dictionary[]`
- 限定：qualifiers=const

Returns a dictionary of per-instance shader uniform names of the per-instance shader uniform from the specified canvas item instance.
				The returned dictionary is in PropertyInfo format, with the keys `name`, `class_name`, `type`, `hint`, `hint_string`, and `usage`.

### `canvas_item_reset_physics_interpolation(item: RID) -> void`

Prevents physics interpolation for the current physics tick.
				This is useful when moving a canvas item to a new location, to give an instantaneous change rather than interpolation from the previous location.

### `canvas_item_set_canvas_group_mode(item: RID, mode: int, clear_margin: float = 5.0, fit_empty: bool = false, fit_margin: float = 0.0, blur_mipmaps: bool = false) -> void`

Sets the canvas group mode used during 2D rendering for the canvas item specified by the `item` RID. For faster but more limited clipping, use `canvas_item_set_clip` instead.
				**Note:** The equivalent node functionality is found in `CanvasGroup` and `CanvasItem.clip_children`.

### `canvas_item_set_clip(item: RID, clip: bool) -> void`

If `clip` is `true`, makes the canvas item specified by the `item` RID not draw anything outside of its rect's coordinates. This clipping is fast, but works only with axis-aligned rectangles. This means that rotation is ignored by the clipping rectangle. For more advanced clipping shapes, use `canvas_item_set_canvas_group_mode` instead.
				**Note:** The equivalent node functionality is found in `Label.clip_text`, `RichTextLabel` (always enabled) and more.

### `canvas_item_set_copy_to_backbuffer(item: RID, enabled: bool, rect: Rect2) -> void`

Sets the `CanvasItem` to copy a rect to the backbuffer.

### `canvas_item_set_custom_rect(item: RID, use_custom_rect: bool, rect: Rect2 = Rect2(0, 0, 0, 0)) -> void`

If `use_custom_rect` is `true`, sets the custom visibility rectangle (used for culling) to `rect` for the canvas item specified by `item`. Setting a custom visibility rect can reduce CPU load when drawing lots of 2D instances. If `use_custom_rect` is `false`, automatically computes a visibility rectangle based on the canvas item's draw commands.

### `canvas_item_set_default_texture_filter(item: RID, filter: int) -> void`

Sets the default texture filter mode for the canvas item specified by the `item` RID. Equivalent to `CanvasItem.texture_filter`.

### `canvas_item_set_default_texture_repeat(item: RID, repeat: int) -> void`

Sets the default texture repeat mode for the canvas item specified by the `item` RID. Equivalent to `CanvasItem.texture_repeat`.

### `canvas_item_set_distance_field_mode(item: RID, enabled: bool) -> void`

If `enabled` is `true`, enables multichannel signed distance field rendering mode for the canvas item specified by the `item` RID. This is meant to be used for font rendering, or with specially generated images using msdfgen (https://github.com/Chlumsky/msdfgen).

### `canvas_item_set_draw_behind_parent(item: RID, enabled: bool) -> void`

If `enabled` is `true`, draws the canvas item specified by the `item` RID behind its parent. Equivalent to `CanvasItem.show_behind_parent`.

### `canvas_item_set_draw_index(item: RID, index: int) -> void`

Sets the index for the `CanvasItem`.

### `canvas_item_set_instance_shader_parameter(instance: RID, parameter: StringName, value: Variant) -> void`

Sets the per-instance shader uniform on the specified canvas item instance. Equivalent to `CanvasItem.set_instance_shader_parameter`.

### `canvas_item_set_interpolated(item: RID, interpolated: bool) -> void`

If `interpolated` is `true`, turns on physics interpolation for the canvas item.

### `canvas_item_set_light_mask(item: RID, mask: int) -> void`

Sets the light `mask` for the canvas item specified by the `item` RID. Equivalent to `CanvasItem.light_mask`.

### `canvas_item_set_material(item: RID, material: RID) -> void`

Sets a new `material` to the canvas item specified by the `item` RID. Equivalent to `CanvasItem.material`.

### `canvas_item_set_modulate(item: RID, color: Color) -> void`

Multiplies the color of the canvas item specified by the `item` RID, while affecting its children. See also `canvas_item_set_self_modulate`. Equivalent to `CanvasItem.modulate`.

### `canvas_item_set_parent(item: RID, parent: RID) -> void`

Sets a parent `CanvasItem` to the `CanvasItem`. The item will inherit transform, modulation and visibility from its parent, like `CanvasItem` nodes in the scene tree.

### `canvas_item_set_self_modulate(item: RID, color: Color) -> void`

Multiplies the color of the canvas item specified by the `item` RID, without affecting its children. See also `canvas_item_set_modulate`. Equivalent to `CanvasItem.self_modulate`.

### `canvas_item_set_sort_children_by_y(item: RID, enabled: bool) -> void`

If `enabled` is `true`, child nodes with the lowest Y position are drawn before those with a higher Y position. Y-sorting only affects children that inherit from the canvas item specified by the `item` RID, not the canvas item itself. Equivalent to `CanvasItem.y_sort_enabled`.

### `canvas_item_set_transform(item: RID, transform: Transform2D) -> void`

Sets the `transform` of the canvas item specified by the `item` RID. This affects where and how the item will be drawn. Child canvas items' transforms are multiplied by their parent's transform. Equivalent to `Node2D.transform`.

### `canvas_item_set_use_parent_material(item: RID, enabled: bool) -> void`

Sets if the `CanvasItem` uses its parent's material.

### `canvas_item_set_visibility_layer(item: RID, visibility_layer: int) -> void`

Sets the rendering visibility layer associated with this `CanvasItem`. Only `Viewport` nodes with a matching rendering mask will render this `CanvasItem`.

### `canvas_item_set_visibility_notifier(item: RID, enable: bool, area: Rect2, enter_callable: Callable, exit_callable: Callable) -> void`

Sets the given `CanvasItem` as visibility notifier. `area` defines the area of detecting visibility. `enter_callable` is called when the `CanvasItem` enters the screen, `exit_callable` is called when the `CanvasItem` exits the screen. If `enable` is `false`, the item will no longer function as notifier.
				This method can be used to manually mimic `VisibleOnScreenNotifier2D`.

### `canvas_item_set_visible(item: RID, visible: bool) -> void`

Sets the visibility of the `CanvasItem`.

### `canvas_item_set_z_as_relative_to_parent(item: RID, enabled: bool) -> void`

If this is enabled, the Z index of the parent will be added to the children's Z index.

### `canvas_item_set_z_index(item: RID, z_index: int) -> void`

Sets the `CanvasItem`'s Z index, i.e. its draw order (lower indexes are drawn first).

### `canvas_item_transform_physics_interpolation(item: RID, transform: Transform2D) -> void`

Transforms both the current and previous stored transform for a canvas item.
				This allows transforming a canvas item without creating a "glitch" in the interpolation, which is particularly useful for large worlds utilizing a shifting origin.

### `canvas_light_attach_to_canvas(light: RID, canvas: RID) -> void`

Attaches the canvas light to the canvas. Removes it from its previous canvas.

### `canvas_light_create() -> RID`

Creates a canvas light and adds it to the RenderingServer. It can be accessed with the RID that is returned. This RID will be used in all `canvas_light_*` RenderingServer functions.
				Once finished with your RID, you will want to free the RID using the RenderingServer's `free_rid` method.
				**Note:** The equivalent node is `Light2D`.

### `canvas_light_occluder_attach_to_canvas(occluder: RID, canvas: RID) -> void`

Attaches a light occluder to the canvas. Removes it from its previous canvas.

### `canvas_light_occluder_create() -> RID`

Creates a light occluder and adds it to the RenderingServer. It can be accessed with the RID that is returned. This RID will be used in all `canvas_light_occluder_*` RenderingServer functions.
				Once finished with your RID, you will want to free the RID using the RenderingServer's `free_rid` method.
				**Note:** The equivalent node is `LightOccluder2D`.

### `canvas_light_occluder_reset_physics_interpolation(occluder: RID) -> void`

Prevents physics interpolation for the current physics tick.
				This is useful when moving an occluder to a new location, to give an instantaneous change rather than interpolation from the previous location.

### `canvas_light_occluder_set_as_sdf_collision(occluder: RID, enable: bool) -> void`

Enables or disables using the light occluder as a signed distance field for 2D particle collision.

### `canvas_light_occluder_set_enabled(occluder: RID, enabled: bool) -> void`

Enables or disables light occluder.

### `canvas_light_occluder_set_interpolated(occluder: RID, interpolated: bool) -> void`

If `interpolated` is `true`, turns on physics interpolation for the light occluder.

### `canvas_light_occluder_set_light_mask(occluder: RID, mask: int) -> void`

The light mask. See `LightOccluder2D` for more information on light masks.

### `canvas_light_occluder_set_polygon(occluder: RID, polygon: RID) -> void`

Sets a light occluder's polygon.

### `canvas_light_occluder_set_transform(occluder: RID, transform: Transform2D) -> void`

Sets a light occluder's `Transform2D`.

### `canvas_light_occluder_transform_physics_interpolation(occluder: RID, transform: Transform2D) -> void`

Transforms both the current and previous stored transform for a light occluder.
				This allows transforming an occluder without creating a "glitch" in the interpolation, which is particularly useful for large worlds utilizing a shifting origin.

### `canvas_light_reset_physics_interpolation(light: RID) -> void`

Prevents physics interpolation for the current physics tick.
				This is useful when moving a canvas item to a new location, to give an instantaneous change rather than interpolation from the previous location.

### `canvas_light_set_blend_mode(light: RID, mode: int) -> void`

Sets the blend mode for the given canvas light to `mode`. Equivalent to `Light2D.blend_mode`.

### `canvas_light_set_color(light: RID, color: Color) -> void`

Sets the color for a light.

### `canvas_light_set_enabled(light: RID, enabled: bool) -> void`

Enables or disables a canvas light.

### `canvas_light_set_energy(light: RID, energy: float) -> void`

Sets a canvas light's energy.

### `canvas_light_set_height(light: RID, height: float) -> void`

Sets a canvas light's height.

### `canvas_light_set_interpolated(light: RID, interpolated: bool) -> void`

If `interpolated` is `true`, turns on physics interpolation for the canvas light.

### `canvas_light_set_item_cull_mask(light: RID, mask: int) -> void`

The light mask. See `LightOccluder2D` for more information on light masks.

### `canvas_light_set_item_shadow_cull_mask(light: RID, mask: int) -> void`

The binary mask used to determine which layers this canvas light's shadows affects. See `LightOccluder2D` for more information on light masks.

### `canvas_light_set_layer_range(light: RID, min_layer: int, max_layer: int) -> void`

The layer range that gets rendered with this light.

### `canvas_light_set_mode(light: RID, mode: int) -> void`

Sets the mode of the canvas light.

### `canvas_light_set_shadow_color(light: RID, color: Color) -> void`

Sets the color of the canvas light's shadow.

### `canvas_light_set_shadow_enabled(light: RID, enabled: bool) -> void`

Enables or disables the canvas light's shadow.

### `canvas_light_set_shadow_filter(light: RID, filter: int) -> void`

Sets the canvas light's shadow's filter.

### `canvas_light_set_shadow_smooth(light: RID, smooth: float) -> void`

Smoothens the shadow. The lower, the smoother.

### `canvas_light_set_texture(light: RID, texture: RID) -> void`

Sets the texture to be used by a `PointLight2D`. Equivalent to `PointLight2D.texture`.

### `canvas_light_set_texture_offset(light: RID, offset: Vector2) -> void`

Sets the offset of a `PointLight2D`'s texture. Equivalent to `PointLight2D.offset`.

### `canvas_light_set_texture_scale(light: RID, scale: float) -> void`

Sets the scale factor of a `PointLight2D`'s texture. Equivalent to `PointLight2D.texture_scale`.

### `canvas_light_set_transform(light: RID, transform: Transform2D) -> void`

Sets the canvas light's `Transform2D`.

### `canvas_light_set_z_range(light: RID, min_z: int, max_z: int) -> void`

Sets the Z range of objects that will be affected by this light. Equivalent to `Light2D.range_z_min` and `Light2D.range_z_max`.

### `canvas_light_transform_physics_interpolation(light: RID, transform: Transform2D) -> void`

Transforms both the current and previous stored transform for a canvas light.
				This allows transforming a light without creating a "glitch" in the interpolation, which is particularly useful for large worlds utilizing a shifting origin.

### `canvas_occluder_polygon_create() -> RID`

Creates a new light occluder polygon and adds it to the RenderingServer. It can be accessed with the RID that is returned. This RID will be used in all `canvas_occluder_polygon_*` RenderingServer functions.
				Once finished with your RID, you will want to free the RID using the RenderingServer's `free_rid` method.
				**Note:** The equivalent resource is `OccluderPolygon2D`.

### `canvas_occluder_polygon_set_cull_mode(occluder_polygon: RID, mode: int) -> void`

Sets an occluder polygon's cull mode.

### `canvas_occluder_polygon_set_shape(occluder_polygon: RID, shape: PackedVector2Array, closed: bool) -> void`

Sets the shape of the occluder polygon.

### `canvas_set_disable_scale(disable: bool) -> void`

If `disable` is `true`, makes 2D rendering ignore the canvas scale defined for each canvas layer. This affects `CanvasLayer`s with the `CanvasLayer.follow_viewport_enabled` property set to `true`.
				In the editor, this is set to `true` by default, and set to `false` when **View > Preview Canvas Scale** is enabled at the top of the 2D editor viewport.
				**Note:** Setting this to `true` does not impact the behavior of `CanvasLayer.scale`, `Node2D.scale`, or `Control.scale`.

### `canvas_set_item_mirroring(canvas: RID, item: RID, mirroring: Vector2) -> void`

A copy of the canvas item will be drawn with a local offset of the `mirroring`.
				**Note:** This is equivalent to calling `canvas_set_item_repeat` like `canvas_set_item_repeat(item, mirroring, 1)`, with an additional check ensuring `canvas` is a parent of `item`.

### `canvas_set_item_repeat(item: RID, repeat_size: Vector2, repeat_times: int) -> void`

A copy of the canvas item will be drawn with a local offset of the `repeat_size` by the number of times of the `repeat_times`. As the `repeat_times` increases, the copies will spread away from the origin texture.

### `canvas_set_modulate(canvas: RID, color: Color) -> void`

Modulates all colors in the given canvas.

### `canvas_set_shadow_texture_size(size: int) -> void`

Sets the `ProjectSettings.rendering/2d/shadow_atlas/size` to use for `Light2D` shadow rendering (in pixels). The value is rounded up to the nearest power of 2.

### `canvas_texture_create() -> RID`

Creates a canvas texture and adds it to the RenderingServer. It can be accessed with the RID that is returned. This RID will be used in all `canvas_texture_*` RenderingServer functions.
				Once finished with your RID, you will want to free the RID using the RenderingServer's `free_rid` method. See also `texture_2d_create`.
				**Note:** The equivalent resource is `CanvasTexture` and is only meant to be used in 2D rendering, not 3D.

### `canvas_texture_set_channel(canvas_texture: RID, channel: int, texture: RID) -> void`

Sets the `channel`'s `texture` for the canvas texture specified by the `canvas_texture` RID. Equivalent to `CanvasTexture.diffuse_texture`, `CanvasTexture.normal_texture` and `CanvasTexture.specular_texture`.

### `canvas_texture_set_shading_parameters(canvas_texture: RID, base_color: Color, shininess: float) -> void`

Sets the `base_color` and `shininess` to use for the canvas texture specified by the `canvas_texture` RID. Equivalent to `CanvasTexture.specular_color` and `CanvasTexture.specular_shininess`.

### `canvas_texture_set_texture_filter(canvas_texture: RID, filter: int) -> void`

Sets the texture `filter` mode to use for the canvas texture specified by the `canvas_texture` RID.

### `canvas_texture_set_texture_repeat(canvas_texture: RID, repeat: int) -> void`

Sets the texture `repeat` mode to use for the canvas texture specified by the `canvas_texture` RID.

### `compositor_create() -> RID`

Creates a new compositor and adds it to the RenderingServer. It can be accessed with the RID that is returned.
				Once finished with your RID, you will want to free the RID using the RenderingServer's `free_rid` method.

### `compositor_effect_create() -> RID`

Creates a new rendering effect and adds it to the RenderingServer. It can be accessed with the RID that is returned.
				Once finished with your RID, you will want to free the RID using the RenderingServer's `free_rid` method.

### `compositor_effect_set_callback(effect: RID, callback_type: int, callback: Callable) -> void`

Sets the callback type (`callback_type`) and callback method(`callback`) for this rendering effect.

### `compositor_effect_set_enabled(effect: RID, enabled: bool) -> void`

Enables/disables this rendering effect.

### `compositor_effect_set_flag(effect: RID, flag: int, set: bool) -> void`

Sets the flag (`flag`) for this rendering effect to `true` or `false` (`set`).

### `compositor_set_compositor_effects(compositor: RID, effects: RID[]) -> void`

Sets the compositor effects for the specified compositor RID. `effects` should be an array containing RIDs created with `compositor_effect_create`.

### `create_local_rendering_device() -> RenderingDevice`
- 限定：qualifiers=const

Creates a RenderingDevice that can be used to do draw and compute operations on a separate thread. Cannot draw to the screen nor share data with the global RenderingDevice.
				**Note:** When using the OpenGL rendering driver or when running in headless mode, this function always returns `null`.

### `debug_canvas_item_get_rect(item: RID) -> Rect2`

Returns the bounding rectangle for a canvas item in local space, as calculated by the renderer. This bound is used internally for culling.
				**Warning:** This function is intended for debugging in the editor, and will pass through and return a zero `Rect2` in exported projects.

### `decal_create() -> RID`

Creates a decal and adds it to the RenderingServer. It can be accessed with the RID that is returned. This RID will be used in all `decal_*` RenderingServer functions.
				Once finished with your RID, you will want to free the RID using the RenderingServer's `free_rid` method.
				To place in a scene, attach this decal to an instance using `instance_set_base` using the returned RID.
				**Note:** The equivalent node is `Decal`.

### `decal_set_albedo_mix(decal: RID, albedo_mix: float) -> void`

Sets the `albedo_mix` in the decal specified by the `decal` RID. Equivalent to `Decal.albedo_mix`.

### `decal_set_cull_mask(decal: RID, mask: int) -> void`

Sets the cull `mask` in the decal specified by the `decal` RID. Equivalent to `Decal.cull_mask`.

### `decal_set_distance_fade(decal: RID, enabled: bool, begin: float, length: float) -> void`
- 限定：keywords=decal_set_lod

Sets the distance fade parameters in the decal specified by the `decal` RID. Equivalent to `Decal.distance_fade_enabled`, `Decal.distance_fade_begin` and `Decal.distance_fade_length`.

### `decal_set_emission_energy(decal: RID, energy: float) -> void`

Sets the emission `energy` in the decal specified by the `decal` RID. Equivalent to `Decal.emission_energy`.

### `decal_set_fade(decal: RID, above: float, below: float) -> void`

Sets the upper fade (`above`) and lower fade (`below`) in the decal specified by the `decal` RID. Equivalent to `Decal.upper_fade` and `Decal.lower_fade`.

### `decal_set_modulate(decal: RID, color: Color) -> void`

Sets the color multiplier in the decal specified by the `decal` RID to `color`. Equivalent to `Decal.modulate`.

### `decal_set_normal_fade(decal: RID, fade: float) -> void`

Sets the normal `fade` in the decal specified by the `decal` RID. Equivalent to `Decal.normal_fade`.

### `decal_set_size(decal: RID, size: Vector3) -> void`

Sets the `size` of the decal specified by the `decal` RID. Equivalent to `Decal.size`.

### `decal_set_texture(decal: RID, type: int, texture: RID) -> void`

Sets the `texture` in the given texture `type` slot for the specified decal. Equivalent to `Decal.set_texture`.

### `decals_set_filter(filter: int) -> void`

Sets the texture `filter` mode to use when rendering decals. This parameter is global and cannot be set on a per-decal basis.

### `directional_light_create() -> RID`

Creates a directional light and adds it to the RenderingServer. It can be accessed with the RID that is returned. This RID can be used in most `light_*` RenderingServer functions.
				Once finished with your RID, you will want to free the RID using the RenderingServer's `free_rid` method.
				To place in a scene, attach this directional light to an instance using `instance_set_base` using the returned RID.
				**Note:** The equivalent node is `DirectionalLight3D`.

### `directional_shadow_atlas_set_size(size: int, is_16bits: bool) -> void`

Sets the `size` of the directional light shadows in 3D. See also `ProjectSettings.rendering/lights_and_shadows/directional_shadow/size`. This parameter is global and cannot be set on a per-viewport basis.

### `directional_soft_shadow_filter_set_quality(quality: int) -> void`

Sets the filter `quality` for directional light shadows in 3D. See also `ProjectSettings.rendering/lights_and_shadows/directional_shadow/soft_shadow_filter_quality`. This parameter is global and cannot be set on a per-viewport basis.

### `environment_bake_panorama(environment: RID, bake_irradiance: bool, size: Vector2i) -> Image`

Generates and returns an `Image` containing the radiance map for the specified `environment` RID's sky. This supports built-in sky material and custom sky shaders. If `bake_irradiance` is `true`, the irradiance map is saved instead of the radiance map. The radiance map is used to render reflected light, while the irradiance map is used to render ambient light. See also `sky_bake_panorama`.
				**Note:** The image is saved using linear encoding without any tonemapping performed, which means it will look too dark if viewed directly in an image editor.
				**Note:** `size` should be a 2:1 aspect ratio for the generated panorama to have square pixels. For radiance maps, there is no point in using a height greater than `Sky.radiance_size`, as it won't increase detail. Irradiance maps only contain low-frequency data, so there is usually no point in going past a size of 128×64 pixels when saving an irradiance map.

### `environment_create() -> RID`

Creates an environment and adds it to the RenderingServer. It can be accessed with the RID that is returned. This RID will be used in all `environment_*` RenderingServer functions.
				Once finished with your RID, you will want to free the RID using the RenderingServer's `free_rid` method.
				**Note:** The equivalent resource is `Environment`.

### `environment_glow_set_use_bicubic_upscale(enable: bool) -> void`

If `enable` is `true`, enables bicubic upscaling for glow which improves quality at the cost of performance. Equivalent to `ProjectSettings.rendering/environment/glow/upscale_mode`.
				**Note:** This setting is only effective when using the Forward+ or Mobile rendering methods, as Compatibility uses a different glow implementation.

### `environment_set_adjustment(env: RID, enable: bool, brightness: float, contrast: float, saturation: float, use_1d_color_correction: bool, color_correction: RID) -> void`

Sets the values to be used with the "adjustments" post-process effect. See `Environment` for more details.

### `environment_set_ambient_light(env: RID, color: Color, ambient: int = 0, energy: float = 1.0, sky_contribution: float = 0.0, reflection_source: int = 0) -> void`

Sets the values to be used for ambient light rendering. See `Environment` for more details.

### `environment_set_background(env: RID, bg: int) -> void`

Sets the environment's background mode. Equivalent to `Environment.background_mode`.

### `environment_set_bg_color(env: RID, color: Color) -> void`

Color displayed for clear areas of the scene. Only effective if using the `ENV_BG_COLOR` background mode.

### `environment_set_bg_energy(env: RID, multiplier: float, exposure_value: float) -> void`

Sets the intensity of the background color.

### `environment_set_camera_id(env: RID, id: int) -> void`

Sets the camera ID to be used as environment background.

### `environment_set_canvas_max_layer(env: RID, max_layer: int) -> void`

Sets the maximum layer to use if using Canvas background mode.

### `environment_set_fog(env: RID, enable: bool, light_color: Color, light_energy: float, sun_scatter: float, density: float, height: float, height_density: float, aerial_perspective: float, sky_affect: float, fog_mode: int = 0) -> void`

Configures fog for the specified environment RID. See `fog_*` properties in `Environment` for more information.

### `environment_set_fog_depth(env: RID, curve: float, begin: float, end: float) -> void`

Configures fog depth for the specified environment RID. Only has an effect when the fog mode of the environment is `ENV_FOG_MODE_DEPTH`. See `fog_depth_*` properties in `Environment` for more information.

### `environment_set_glow(env: RID, enable: bool, levels: PackedFloat32Array, intensity: float, strength: float, mix: float, bloom_threshold: float, blend_mode: int, hdr_bleed_threshold: float, hdr_bleed_scale: float, hdr_luminance_cap: float, glow_map_strength: float, glow_map: RID) -> void`

Configures glow for the specified environment RID. See `glow_*` properties in `Environment` for more information.

### `environment_set_sdfgi(env: RID, enable: bool, cascades: int, min_cell_size: float, y_scale: int, use_occlusion: bool, bounce_feedback: float, read_sky: bool, energy: float, normal_bias: float, probe_bias: float) -> void`

Configures signed distance field global illumination for the specified environment RID. See `sdfgi_*` properties in `Environment` for more information.

### `environment_set_sdfgi_frames_to_converge(frames: int) -> void`

Sets the number of frames to use for converging signed distance field global illumination. Equivalent to `ProjectSettings.rendering/global_illumination/sdfgi/frames_to_converge`.

### `environment_set_sdfgi_frames_to_update_light(frames: int) -> void`

Sets the update speed for dynamic lights' indirect lighting when computing signed distance field global illumination. Equivalent to `ProjectSettings.rendering/global_illumination/sdfgi/frames_to_update_lights`.

### `environment_set_sdfgi_ray_count(ray_count: int) -> void`

Sets the number of rays to throw per frame when computing signed distance field global illumination. Equivalent to `ProjectSettings.rendering/global_illumination/sdfgi/probe_ray_count`.

### `environment_set_sky(env: RID, sky: RID) -> void`

Sets the `Sky` to be used as the environment's background when using *BGMode* sky. Equivalent to `Environment.sky`.

### `environment_set_sky_custom_fov(env: RID, scale: float) -> void`

Sets a custom field of view for the background `Sky`. Equivalent to `Environment.sky_custom_fov`.

### `environment_set_sky_orientation(env: RID, orientation: Basis) -> void`

Sets the rotation of the background `Sky` expressed as a `Basis`. Equivalent to `Environment.sky_rotation`, where the rotation vector is used to construct the `Basis`.

### `environment_set_ssao(env: RID, enable: bool, radius: float, intensity: float, power: float, detail: float, horizon: float, sharpness: float, light_affect: float, ao_channel_affect: float) -> void`

Sets the variables to be used with the screen-space ambient occlusion (SSAO) post-process effect. See `Environment` for more details.

### `environment_set_ssao_quality(quality: int, half_size: bool, adaptive_target: float, blur_passes: int, fadeout_from: float, fadeout_to: float) -> void`

Sets the quality level of the screen-space ambient occlusion (SSAO) post-process effect. See `Environment` for more details.

### `environment_set_ssil_quality(quality: int, half_size: bool, adaptive_target: float, blur_passes: int, fadeout_from: float, fadeout_to: float) -> void`

Sets the quality level of the screen-space indirect lighting (SSIL) post-process effect. See `Environment` for more details.

### `environment_set_ssr(env: RID, enable: bool, max_steps: int, fade_in: float, fade_out: float, depth_tolerance: float) -> void`

Sets the variables to be used with the screen-space reflections (SSR) post-process effect. See `Environment` for more details.

### `environment_set_ssr_half_size(half_size: bool) -> void`

Sets whether screen-space reflections will be rendered at full or half size. Half size is faster, but may look pixelated or cause flickering.

### `environment_set_ssr_roughness_quality(quality: int) -> void`
- 限定：deprecated=This option no longer does anything.

### `environment_set_tonemap(env: RID, tone_mapper: int, exposure: float, white: float) -> void`

Sets the variables to be used with the "tonemap" post-process effect. See `Environment` for more details.

### `environment_set_tonemap_agx_contrast(env: RID, agx_contrast: float) -> void`

See `Environment.tonemap_agx_contrast` for more details.

### `environment_set_volumetric_fog(env: RID, enable: bool, density: float, albedo: Color, emission: Color, emission_energy: float, anisotropy: float, length: float, detail_spread: float, gi_inject: float, temporal_reprojection: bool, temporal_reprojection_amount: float, ambient_inject: float, sky_affect: float) -> void`

Sets the variables to be used with the volumetric fog post-process effect. See `Environment` for more details.

### `environment_set_volumetric_fog_filter_active(active: bool) -> void`

Enables filtering of the volumetric fog scattering buffer. This results in much smoother volumes with very few under-sampling artifacts.

### `environment_set_volumetric_fog_volume_size(size: int, depth: int) -> void`

Sets the resolution of the volumetric fog's froxel buffer. `size` is modified by the screen's aspect ratio and then used to set the width and height of the buffer. While `depth` is directly used to set the depth of the buffer.

### `fog_volume_create() -> RID`

Creates a new fog volume and adds it to the RenderingServer. It can be accessed with the RID that is returned. This RID will be used in all `fog_volume_*` RenderingServer functions.
				Once finished with your RID, you will want to free the RID using the RenderingServer's `free_rid` method.
				**Note:** The equivalent node is `FogVolume`.

### `fog_volume_set_material(fog_volume: RID, material: RID) -> void`

Sets the `Material` of the fog volume. Can be either a `FogMaterial` or a custom `ShaderMaterial`.

### `fog_volume_set_shape(fog_volume: RID, shape: int) -> void`

Sets the shape of the fog volume to either `RenderingServer.FOG_VOLUME_SHAPE_ELLIPSOID`, `RenderingServer.FOG_VOLUME_SHAPE_CONE`, `RenderingServer.FOG_VOLUME_SHAPE_CYLINDER`, `RenderingServer.FOG_VOLUME_SHAPE_BOX` or `RenderingServer.FOG_VOLUME_SHAPE_WORLD`.

### `fog_volume_set_size(fog_volume: RID, size: Vector3) -> void`

Sets the size of the fog volume when shape is `RenderingServer.FOG_VOLUME_SHAPE_ELLIPSOID`, `RenderingServer.FOG_VOLUME_SHAPE_CONE`, `RenderingServer.FOG_VOLUME_SHAPE_CYLINDER` or `RenderingServer.FOG_VOLUME_SHAPE_BOX`.

### `force_draw(swap_buffers: bool = true, frame_step: float = 0.0) -> void`

Forces redrawing of all viewports at once. Must be called from the main thread.

### `force_sync() -> void`

Forces a synchronization between the CPU and GPU, which may be required in certain cases. Only call this when needed, as CPU-GPU synchronization has a performance cost.

### `free_rid(rid: RID) -> void`

Tries to free an object in the RenderingServer. To avoid memory leaks, this should be called after using an object as memory management does not occur automatically when using RenderingServer directly.

### `get_current_rendering_driver_name() -> String`
- 限定：qualifiers=const

Returns the name of the current rendering driver. This can be `vulkan`, `d3d12`, `metal`, `opengl3`, `opengl3_es`, or `opengl3_angle`. See also `get_current_rendering_method`.
				When `ProjectSettings.rendering/renderer/rendering_method` is `forward_plus` or `mobile`, the rendering driver is determined by `ProjectSettings.rendering/rendering_device/driver`.
				When `ProjectSettings.rendering/renderer/rendering_method` is `gl_compatibility`, the rendering driver is determined by `ProjectSettings.rendering/gl_compatibility/driver`.
				The rendering driver is also determined by the `--rendering-driver` command line argument that overrides this project setting, or an automatic fallback that is applied depending on the hardware.

### `get_current_rendering_method() -> String`
- 限定：qualifiers=const

Returns the name of the current rendering method. This can be `forward_plus`, `mobile`, or `gl_compatibility`. See also `get_current_rendering_driver_name`.
				The rendering method is determined by `ProjectSettings.rendering/renderer/rendering_method`, the `--rendering-method` command line argument that overrides this project setting, or an automatic fallback that is applied depending on the hardware.

### `get_default_clear_color() -> Color`

Returns the default clear color which is used when a specific clear color has not been selected. See also `set_default_clear_color`.

### `get_frame_setup_time_cpu() -> float`
- 限定：qualifiers=const

Returns the time taken to setup rendering on the CPU in milliseconds. This value is shared across all viewports and does *not* require `viewport_set_measure_render_time` to be enabled on a viewport to be queried. See also `viewport_get_measured_render_time_cpu`.

### `get_rendering_device() -> RenderingDevice`
- 限定：qualifiers=const

Returns the global RenderingDevice.
				**Note:** When using the OpenGL rendering driver or when running in headless mode, this function always returns `null`.

### `get_rendering_info(info: int) -> int`

Returns a statistic about the rendering engine which can be used for performance profiling. See also `viewport_get_render_info`, which returns information specific to a viewport.
				**Note:** Only 3D rendering is currently taken into account by some of these values, such as the number of draw calls.
				**Note:** Rendering information is not available until at least 2 frames have been rendered by the engine. If rendering information is not available, `get_rendering_info` returns `0`. To print rendering information in `_ready()` successfully, use the following:
				
```gdscript
				func _ready():
					for _i in 2:
						await get_tree().process_frame

					print(RenderingServer.get_rendering_info(RENDERING_INFO_TOTAL_DRAW_CALLS_IN_FRAME))
				
```

### `get_shader_parameter_list(shader: RID) -> Dictionary[]`
- 限定：qualifiers=const

Returns the parameters of a shader.

### `get_test_cube() -> RID`

Returns the RID of the test cube. This mesh will be created and returned on the first call to `get_test_cube`, then it will be cached for subsequent calls. See also `make_sphere_mesh`.

### `get_test_texture() -> RID`

Returns the RID of a 256×256 texture with a testing pattern on it (in `Image.FORMAT_RGB8` format). This texture will be created and returned on the first call to `get_test_texture`, then it will be cached for subsequent calls. See also `get_white_texture`.
				**Example:** Get the test texture and apply it to a `Sprite2D` node:
				
```gdscript
				var texture_rid = RenderingServer.get_test_texture()
				var texture = ImageTexture.create_from_image(RenderingServer.texture_2d_get(texture_rid))
				$Sprite2D.texture = texture
				
```

### `get_video_adapter_api_version() -> String`
- 限定：qualifiers=const

Returns the version of the graphics video adapter *currently in use* (e.g. "1.2.189" for Vulkan, "3.3.0 NVIDIA 510.60.02" for OpenGL). This version may be different from the actual latest version supported by the hardware, as Godot may not always request the latest version. See also `OS.get_video_adapter_driver_info`.
				**Note:** When running a headless or server binary, this function returns an empty string.

### `get_video_adapter_name() -> String`
- 限定：qualifiers=const

Returns the name of the video adapter (e.g. "GeForce GTX 1080/PCIe/SSE2").
				**Note:** When running a headless or server binary, this function returns an empty string.
				**Note:** On the web platform, some browsers such as Firefox may report a different, fixed GPU name such as "GeForce GTX 980" (regardless of the user's actual GPU model). This is done to make fingerprinting more difficult.

### `get_video_adapter_type() -> int`
- 限定：qualifiers=const

Returns the type of the video adapter. Since dedicated graphics cards from a given generation will *usually* be significantly faster than integrated graphics made in the same generation, the device type can be used as a basis for automatic graphics settings adjustment. However, this is not always true, so make sure to provide users with a way to manually override graphics settings.
				**Note:** When using the OpenGL rendering driver or when running in headless mode, this function always returns `RenderingDevice.DEVICE_TYPE_OTHER`.

### `get_video_adapter_vendor() -> String`
- 限定：qualifiers=const

Returns the vendor of the video adapter (e.g. "NVIDIA Corporation").
				**Note:** When running a headless or server binary, this function returns an empty string.

### `get_white_texture() -> RID`

Returns the ID of a 4×4 white texture (in `Image.FORMAT_RGB8` format). This texture will be created and returned on the first call to `get_white_texture`, then it will be cached for subsequent calls. See also `get_test_texture`.
				**Example:** Get the white texture and apply it to a `Sprite2D` node:
				
```gdscript
				var texture_rid = RenderingServer.get_white_texture()
				var texture = ImageTexture.create_from_image(RenderingServer.texture_2d_get(texture_rid))
				$Sprite2D.texture = texture
				
```

### `gi_set_use_half_resolution(half_resolution: bool) -> void`

If `half_resolution` is `true`, renders `VoxelGI` and SDFGI (`Environment.sdfgi_enabled`) buffers at halved resolution on each axis (e.g. 960×540 when the viewport size is 1920×1080). This improves performance significantly when VoxelGI or SDFGI is enabled, at the cost of artifacts that may be visible on polygon edges. The loss in quality becomes less noticeable as the viewport resolution increases. `LightmapGI` rendering is not affected by this setting. Equivalent to `ProjectSettings.rendering/global_illumination/gi/use_half_resolution`.

### `global_shader_parameter_add(name: StringName, type: int, default_value: Variant) -> void`

Creates a new global shader uniform.
				**Note:** Global shader parameter names are case-sensitive.

### `global_shader_parameter_get(name: StringName) -> Variant`
- 限定：qualifiers=const

Returns the value of the global shader uniform specified by `name`.
				**Note:** `global_shader_parameter_get` has a large performance penalty as the rendering thread needs to synchronize with the calling thread, which is slow. Do not use this method during gameplay to avoid stuttering. If you need to read values in a script after setting them, consider creating an autoload where you store the values you need to query at the same time you're setting them as global parameters.

### `global_shader_parameter_get_list() -> StringName[]`
- 限定：qualifiers=const

Returns the list of global shader uniform names.
				**Note:** `global_shader_parameter_get` has a large performance penalty as the rendering thread needs to synchronize with the calling thread, which is slow. Do not use this method during gameplay to avoid stuttering. If you need to read values in a script after setting them, consider creating an autoload where you store the values you need to query at the same time you're setting them as global parameters.

### `global_shader_parameter_get_type(name: StringName) -> int`
- 限定：qualifiers=const

Returns the type associated to the global shader uniform specified by `name`.
				**Note:** `global_shader_parameter_get` has a large performance penalty as the rendering thread needs to synchronize with the calling thread, which is slow. Do not use this method during gameplay to avoid stuttering. If you need to read values in a script after setting them, consider creating an autoload where you store the values you need to query at the same time you're setting them as global parameters.

### `global_shader_parameter_remove(name: StringName) -> void`

Removes the global shader uniform specified by `name`.

### `global_shader_parameter_set(name: StringName, value: Variant) -> void`

Sets the global shader uniform `name` to `value`.

### `global_shader_parameter_set_override(name: StringName, value: Variant) -> void`

Overrides the global shader uniform `name` with `value`. Equivalent to the `ShaderGlobalsOverride` node.

### `has_changed() -> bool`
- 限定：qualifiers=const

Returns `true` if changes have been made to the RenderingServer's data. `force_draw` is usually called if this happens.

### `has_feature(feature: int) -> bool`
- 限定：deprecated=This method has not been used since Godot 3.0. · qualifiers=const

This method does nothing and always returns `false`.

### `has_os_feature(feature: String) -> bool`
- 限定：qualifiers=const

Returns `true` if the OS supports a certain `feature`. Features might be `s3tc`, `etc`, and `etc2`.

### `instance_attach_object_instance_id(instance: RID, id: int) -> void`

Attaches a unique Object ID to instance. Object ID must be attached to instance for proper culling with `instances_cull_aabb`, `instances_cull_convex`, and `instances_cull_ray`.

### `instance_attach_skeleton(instance: RID, skeleton: RID) -> void`

Attaches a skeleton to an instance. Removes the previous skeleton from the instance.

### `instance_create() -> RID`

Creates a visual instance and adds it to the RenderingServer. It can be accessed with the RID that is returned. This RID will be used in all `instance_*` RenderingServer functions.
				Once finished with your RID, you will want to free the RID using the RenderingServer's `free_rid` method.
				An instance is a way of placing a 3D object in the scenario. Objects like particles, meshes, reflection probes and decals need to be associated with an instance to be visible in the scenario using `instance_set_base`.
				**Note:** The equivalent node is `VisualInstance3D`.

### `instance_create2(base: RID, scenario: RID) -> RID`

Creates a visual instance, adds it to the RenderingServer, and sets both base and scenario. It can be accessed with the RID that is returned. This RID will be used in all `instance_*` RenderingServer functions.
				Once finished with your RID, you will want to free the RID using the RenderingServer's `free_rid` method. This is a shorthand for using `instance_create` and setting the base and scenario manually.

### `instance_geometry_get_shader_parameter(instance: RID, parameter: StringName) -> Variant`
- 限定：qualifiers=const

Returns the value of the per-instance shader uniform from the specified 3D geometry instance. Equivalent to `GeometryInstance3D.get_instance_shader_parameter`.
				**Note:** Per-instance shader parameter names are case-sensitive.

### `instance_geometry_get_shader_parameter_default_value(instance: RID, parameter: StringName) -> Variant`
- 限定：qualifiers=const

Returns the default value of the per-instance shader uniform from the specified 3D geometry instance. Equivalent to `GeometryInstance3D.get_instance_shader_parameter`.

### `instance_geometry_get_shader_parameter_list(instance: RID) -> Dictionary[]`
- 限定：qualifiers=const

Returns a dictionary of per-instance shader uniform names of the per-instance shader uniform from the specified 3D geometry instance. The returned dictionary is in PropertyInfo format, with the keys `name`, `class_name`, `type`, `hint`, `hint_string` and `usage`. Equivalent to `GeometryInstance3D.get_instance_shader_parameter`.

### `instance_geometry_set_cast_shadows_setting(instance: RID, shadow_casting_setting: int) -> void`

Sets the shadow casting setting. Equivalent to `GeometryInstance3D.cast_shadow`.

### `instance_geometry_set_flag(instance: RID, flag: int, enabled: bool) -> void`

Sets the `flag` for a given `instance` to `enabled`.

### `instance_geometry_set_lightmap(instance: RID, lightmap: RID, lightmap_uv_scale: Rect2, lightmap_slice: int) -> void`

Sets the lightmap GI instance to use for the specified 3D geometry instance. The lightmap UV scale for the specified instance (equivalent to `GeometryInstance3D.gi_lightmap_scale`) and lightmap atlas slice must also be specified.

### `instance_geometry_set_lod_bias(instance: RID, lod_bias: float) -> void`

Sets the level of detail bias to use when rendering the specified 3D geometry instance. Higher values result in higher detail from further away. Equivalent to `GeometryInstance3D.lod_bias`.

### `instance_geometry_set_material_overlay(instance: RID, material: RID) -> void`

Sets a material that will be rendered for all surfaces on top of active materials for the mesh associated with this instance. Equivalent to `GeometryInstance3D.material_overlay`.

### `instance_geometry_set_material_override(instance: RID, material: RID) -> void`

Sets a material that will override the material for all surfaces on the mesh associated with this instance. Equivalent to `GeometryInstance3D.material_override`.

### `instance_geometry_set_shader_parameter(instance: RID, parameter: StringName, value: Variant) -> void`

Sets the per-instance shader uniform on the specified 3D geometry instance. Equivalent to `GeometryInstance3D.set_instance_shader_parameter`.

### `instance_geometry_set_transparency(instance: RID, transparency: float) -> void`

Sets the transparency for the given geometry instance. Equivalent to `GeometryInstance3D.transparency`.
				A transparency of `0.0` is fully opaque, while `1.0` is fully transparent. Values greater than `0.0` (exclusive) will force the geometry's materials to go through the transparent pipeline, which is slower to render and can exhibit rendering issues due to incorrect transparency sorting. However, unlike using a transparent material, setting `transparency` to a value greater than `0.0` (exclusive) will *not* disable shadow rendering.
				In spatial shaders, `1.0 - transparency` is set as the default value of the `ALPHA` built-in.
				**Note:** `transparency` is clamped between `0.0` and `1.0`, so this property cannot be used to make transparent materials more opaque than they originally are.

### `instance_geometry_set_visibility_range(instance: RID, min: float, max: float, min_margin: float, max_margin: float, fade_mode: int) -> void`

Sets the visibility range values for the given geometry instance. Equivalent to `GeometryInstance3D.visibility_range_begin` and related properties.

### `instance_set_base(instance: RID, base: RID) -> void`

Sets the base of the instance. A base can be any of the 3D objects that are created in the RenderingServer that can be displayed. For example, any of the light types, mesh, multimesh, particle system, reflection probe, decal, lightmap, voxel GI and visibility notifiers are all types that can be set as the base of an instance in order to be displayed in the scenario.

### `instance_set_blend_shape_weight(instance: RID, shape: int, weight: float) -> void`

Sets the weight for a given blend shape associated with this instance.

### `instance_set_custom_aabb(instance: RID, aabb: AABB) -> void`

Sets a custom AABB to use when culling objects from the view frustum. Equivalent to setting `GeometryInstance3D.custom_aabb`.

### `instance_set_extra_visibility_margin(instance: RID, margin: float) -> void`

Sets a margin to increase the size of the AABB when culling objects from the view frustum. This allows you to avoid culling objects that fall outside the view frustum. Equivalent to `GeometryInstance3D.extra_cull_margin`.

### `instance_set_ignore_culling(instance: RID, enabled: bool) -> void`

If `true`, ignores all culling on the specified 3D geometry instance, including frustum culling, occlusion culling, and layer culling. This is not the same as `GeometryInstance3D.ignore_occlusion_culling`, which only ignores occlusion culling but leaves frustum and layer culling intact.

### `instance_set_layer_mask(instance: RID, mask: int) -> void`

Sets the render layers that this instance will be drawn to. Equivalent to `VisualInstance3D.layers`.

### `instance_set_pivot_data(instance: RID, sorting_offset: float, use_aabb_center: bool) -> void`

Sets the sorting offset and switches between using the bounding box or instance origin for depth sorting.

### `instance_set_scenario(instance: RID, scenario: RID) -> void`

Sets the scenario that the instance is in. The scenario is the 3D world that the objects will be displayed in.

### `instance_set_surface_override_material(instance: RID, surface: int, material: RID) -> void`

Sets the override material of a specific surface. Equivalent to `MeshInstance3D.set_surface_override_material`.

### `instance_set_transform(instance: RID, transform: Transform3D) -> void`

Sets the world space transform of the instance. Equivalent to `Node3D.global_transform`.

### `instance_set_visibility_parent(instance: RID, parent: RID) -> void`

Sets the visibility parent for the given instance. Equivalent to `Node3D.visibility_parent`.

### `instance_set_visible(instance: RID, visible: bool) -> void`

Sets whether an instance is drawn or not. Equivalent to `Node3D.visible`.

### `instance_teleport(instance: RID) -> void`

Resets motion vectors and other interpolated values. Use this *after* teleporting a mesh from one position to another to avoid ghosting artifacts.

### `instances_cull_aabb(aabb: AABB, scenario: RID = RID()) -> PackedInt64Array`
- 限定：qualifiers=const

Returns an array of object IDs intersecting with the provided AABB. Only 3D nodes that inherit from `VisualInstance3D` are considered, such as `MeshInstance3D` or `DirectionalLight3D`. Use `@GlobalScope.instance_from_id` to obtain the actual nodes. A scenario RID must be provided, which is available in the `World3D` you want to query. This forces an update for all resources queued to update.
				**Warning:** This function is primarily intended for editor usage. For in-game use cases, prefer physics collision.

### `instances_cull_convex(convex: Plane[], scenario: RID = RID()) -> PackedInt64Array`
- 限定：qualifiers=const

Returns an array of object IDs intersecting with the provided convex shape. Only 3D nodes that inherit from `VisualInstance3D` are considered, such as `MeshInstance3D` or `DirectionalLight3D`. Use `@GlobalScope.instance_from_id` to obtain the actual nodes. A scenario RID must be provided, which is available in the `World3D` you want to query. This forces an update for all resources queued to update.
				**Warning:** This function is primarily intended for editor usage. For in-game use cases, prefer physics collision.

### `instances_cull_ray(from: Vector3, to: Vector3, scenario: RID = RID()) -> PackedInt64Array`
- 限定：qualifiers=const

Returns an array of object IDs intersecting with the provided 3D ray. Only 3D nodes that inherit from `VisualInstance3D` are considered, such as `MeshInstance3D` or `DirectionalLight3D`. Use `@GlobalScope.instance_from_id` to obtain the actual nodes. A scenario RID must be provided, which is available in the `World3D` you want to query. This forces an update for all resources queued to update.
				**Warning:** This function is primarily intended for editor usage. For in-game use cases, prefer physics collision.

### `is_on_render_thread() -> bool`

Returns `true` if our code is currently executing on the rendering thread.

### `light_area_set_normalize_energy(light: RID, enable: bool) -> void`

Defines whether the energy of an `AreaLight3D` is normalized (divided) by its area. If set to `true`, changing the size does not affect the total energy output. Equivalent to `AreaLight3D.area_normalize_energy`.

### `light_area_set_size(light: RID, size: Vector2) -> void`

Sets the extents (width and height) in meters for this area light. Equivalent to `AreaLight3D.area_size`.

### `light_directional_set_blend_splits(light: RID, enable: bool) -> void`

If `true`, this directional light will blend between shadow map splits resulting in a smoother transition between them. Equivalent to `DirectionalLight3D.directional_shadow_blend_splits`.

### `light_directional_set_shadow_mode(light: RID, mode: int) -> void`

Sets the shadow mode for this directional light. Equivalent to `DirectionalLight3D.directional_shadow_mode`.

### `light_directional_set_sky_mode(light: RID, mode: int) -> void`

If `true`, this light will not be used for anything except sky shaders. Use this for lights that impact your sky shader that you may want to hide from affecting the rest of the scene. For example, you may want to enable this when the sun in your sky shader falls below the horizon.

### `light_omni_set_shadow_mode(light: RID, mode: int) -> void`

Sets whether to use a dual paraboloid or a cubemap for the shadow map. Dual paraboloid is faster but may suffer from artifacts. Equivalent to `OmniLight3D.omni_shadow_mode`.

### `light_projectors_set_filter(filter: int) -> void`

Sets the texture filter mode to use when rendering light projectors. This parameter is global and cannot be set on a per-light basis.

### `light_set_bake_mode(light: RID, bake_mode: int) -> void`

Sets the bake mode to use for the specified 3D light. Equivalent to `Light3D.light_bake_mode`.

### `light_set_color(light: RID, color: Color) -> void`

Sets the color of the light. Equivalent to `Light3D.light_color`.

### `light_set_cull_mask(light: RID, mask: int) -> void`

Sets the cull mask for this 3D light. Lights only affect objects in the selected layers. Equivalent to `Light3D.light_cull_mask`.

### `light_set_distance_fade(decal: RID, enabled: bool, begin: float, shadow: float, length: float) -> void`
- 限定：keywords=light_set_lod

Sets the distance fade for this 3D light. This acts as a form of level of detail (LOD) and can be used to improve performance. Equivalent to `Light3D.distance_fade_enabled`, `Light3D.distance_fade_begin`, `Light3D.distance_fade_shadow`, and `Light3D.distance_fade_length`.

### `light_set_max_sdfgi_cascade(light: RID, cascade: int) -> void`

Sets the maximum SDFGI cascade in which the 3D light's indirect lighting is rendered. Higher values allow the light to be rendered in SDFGI further away from the camera.

### `light_set_negative(light: RID, enable: bool) -> void`

If `true`, the 3D light will subtract light instead of adding light. Equivalent to `Light3D.light_negative`.

### `light_set_param(light: RID, param: int, value: float) -> void`

Sets the specified 3D light parameter. Equivalent to `Light3D.set_param`.

### `light_set_projector(light: RID, texture: RID) -> void`
- 限定：keywords=light_set_cookie

Sets the projector texture to use for the specified 3D light. Equivalent to `Light3D.light_projector`.

### `light_set_reverse_cull_face_mode(light: RID, enabled: bool) -> void`

If `true`, reverses the backface culling of the mesh. This can be useful when you have a flat mesh that has a light behind it. If you need to cast a shadow on both sides of the mesh, set the mesh to use double-sided shadows with `instance_geometry_set_cast_shadows_setting`. Equivalent to `Light3D.shadow_reverse_cull_face`.

### `light_set_shadow(light: RID, enabled: bool) -> void`

If `true`, light will cast shadows. Equivalent to `Light3D.shadow_enabled`.

### `light_set_shadow_caster_mask(light: RID, mask: int) -> void`

Sets the shadow caster mask for this 3D light. Shadows will only be cast using objects in the selected layers. Equivalent to `Light3D.shadow_caster_mask`.

### `lightmap_create() -> RID`

Creates a new lightmap global illumination instance and adds it to the RenderingServer. It can be accessed with the RID that is returned. This RID will be used in all `lightmap_*` RenderingServer functions.
				Once finished with your RID, you will want to free the RID using the RenderingServer's `free_rid` method.
				**Note:** The equivalent node is `LightmapGI`.

### `lightmap_get_probe_capture_bsp_tree(lightmap: RID) -> PackedInt32Array`
- 限定：qualifiers=const

Returns the BSP tree data used for accelerating probe lookups. The BSP data is structured as a series of six signed 32-bit values per BSP node in this order: `float plane_x`, `float plane_y`, `float plane_z`, `float plane_distance`, `int32_t over`, `int32_t under`. An empty leaf is denoted by the value `-2147483648` (the minimum 32-bit signed integer). See also `lightmap_set_probe_capture_data`.

### `lightmap_get_probe_capture_points(lightmap: RID) -> PackedVector3Array`
- 限定：qualifiers=const

Returns the *local space* positions of each lightmap probe capture point. Keep in mind the lightmap instance may have a non-zero transform, which will affect the position of the probe capture points. See also `lightmap_set_probe_capture_data`.

### `lightmap_get_probe_capture_sh(lightmap: RID) -> PackedColorArray`
- 限定：qualifiers=const

Returns the L0, L1, and L2 spherical harmonics (https://en.wikipedia.org/wiki/Spherical_harmonics) data for each lightmap probe capture point. This is specified as 9 `Color` values per probe, which means the size of the returned data is always 9 times the number of probe points. See also `lightmap_set_probe_capture_data`.

### `lightmap_get_probe_capture_tetrahedra(lightmap: RID) -> PackedInt32Array`
- 限定：qualifiers=const

Returns the tetrahedralization data used for interpolating between lightmap probe capture points. Each tetrahedron is specified as a series of 4 numbers, each being an index into the probe capture points array returned by `lightmap_get_probe_capture_points`. See also `lightmap_set_probe_capture_data`.

### `lightmap_set_baked_exposure_normalization(lightmap: RID, baked_exposure: float) -> void`

Used to inform the renderer what exposure normalization value was used while baking the lightmap. This value will be used and modulated at run time to ensure that the lightmap maintains a consistent level of exposure even if the scene-wide exposure normalization is changed at run time. For more information see `camera_attributes_set_exposure`.

### `lightmap_set_probe_bounds(lightmap: RID, bounds: AABB) -> void`

Sets the bounds that this lightmap instance should visually affect, both in terms of static lightmap baking and probe-based global illumination.

### `lightmap_set_probe_capture_data(lightmap: RID, points: PackedVector3Array, point_sh: PackedColorArray, tetrahedra: PackedInt32Array, bsp_tree: PackedInt32Array) -> void`

Sets the probe capture data for the given lightmap instance. See `lightmap_get_probe_capture_points`, `lightmap_get_probe_capture_sh`, `lightmap_get_probe_capture_tetrahedra`, and `lightmap_get_probe_capture_bsp_tree` for the expected data formats.

### `lightmap_set_probe_capture_update_speed(speed: float) -> void`

The framerate-independent update speed when representing dynamic object lighting from `LightmapProbe`s. Higher values make dynamic object lighting update faster. Higher values can prevent fast-moving objects from having "outdated" indirect lighting displayed on them, at the cost of possible flickering when an object moves from a bright area to a shaded area. See also `ProjectSettings.rendering/lightmapping/probe_capture/update_speed`.

### `lightmap_set_probe_interior(lightmap: RID, interior: bool) -> void`

Sets whether the lightmap instance should be considered as interior (when `interior` is `true`). If the lightmap is marked as interior, environment lighting is ignored when baking lightmaps.

### `lightmap_set_textures(lightmap: RID, light: RID, uses_sh: bool) -> void`

Set the textures on the given `lightmap` GI instance to the texture array pointed to by the `light` RID. If the lightmap texture was baked with `LightmapGI.directional` set to `true`, then `uses_sh` must also be `true`.

### `lightmaps_set_bicubic_filter(enable: bool) -> void`

Toggles whether a bicubic filter should be used when lightmaps are sampled. This smoothens their appearance at a performance cost.

### `make_sphere_mesh(latitudes: int, longitudes: int, radius: float) -> RID`

Returns a mesh of a sphere with the given number of horizontal subdivisions, vertical subdivisions and radius. See also `get_test_cube`.

### `material_create() -> RID`

Creates an empty material and adds it to the RenderingServer. It can be accessed with the RID that is returned. This RID will be used in all `material_*` RenderingServer functions.
				Once finished with your RID, you will want to free the RID using the RenderingServer's `free_rid` method.
				**Note:** The equivalent resource is `Material`.

### `material_get_param(material: RID, parameter: StringName) -> Variant`
- 限定：qualifiers=const

Returns the value of a certain material's parameter.

### `material_set_next_pass(material: RID, next_material: RID) -> void`

Sets an object's next material.

### `material_set_param(material: RID, parameter: StringName, value: Variant) -> void`

Sets a material's parameter.

### `material_set_render_priority(material: RID, priority: int) -> void`

Sets a material's render priority.

### `material_set_shader(shader_material: RID, shader: RID) -> void`

Sets a shader material's shader.

### `material_set_use_debanding(enable: bool) -> void`

When using the Mobile renderer, `material_set_use_debanding` can be used to enable or disable the debanding feature of 3D materials (`BaseMaterial3D` and `ShaderMaterial`).
				`material_set_use_debanding` has no effect when using the Compatibility or Forward+ renderer. In Forward+, `Viewport` debanding can be used instead.
				See also `ProjectSettings.rendering/anti_aliasing/quality/use_debanding` and `RenderingServer.viewport_set_use_debanding`.

### `mesh_add_surface(mesh: RID, surface: Dictionary) -> void`

Creates a new surface on the given `mesh`. Equivalent to `mesh_add_surface_from_arrays`, but takes a single `Dictionary` argument instead of separate arguments. The dictionary must follow this structure:
				
```gdscript
				{
					# Required:
				    "primitive": RenderingServer.PrimitiveType,
				    "format": RenderingServer.ArrayFormat,
				    "vertex_data": PackedByteArray,
				    "vertex_count": int,
				    "aabb": AABB,

					# Optional:
					"attribute_data": PackedByteArray,
					"skin_data": PackedByteArray,
					"index_data": PackedByteArray,
					"index_count": int, # Required if `index_data` is specified.
					"uv_scale": Vector4,
					"lods": [
						# Both values are required for each LOD level.
						{
							"edge_length": float,
							"index_data": PackedByteArray,
						},
					],
					"bone_aabbs": Array`AABB`,
					"blend_shape_data": PackedByteArray,
					"material": Material,
				}
				
```

				See also `mesh_get_surface`, which returns data in the same structure defined above.

### `mesh_add_surface_from_arrays(mesh: RID, primitive: int, arrays: Array, blend_shapes: Array = [], lods: Dictionary = {}, compress_format: int = 0) -> void`

Creates a new surface on the given `mesh`. `mesh_get_surface_count` will become the surface index for this new surface.
				Surfaces are created to be rendered using a `primitive`, which may be any of the values defined in `Mesh.PrimitiveType`.
				The `arrays` argument is an array of arrays. Each of the `Mesh.ARRAY_MAX` elements contains an array with some of the mesh data for this surface as described by the corresponding member of `Mesh.ArrayType` or `null` if it is not used by the surface. For example, `arrays[0]` is the array of vertices. That first vertex sub-array is always required; the others are optional. Adding an index array puts this surface into "index mode" where the vertex and other arrays become the sources of data and the index array defines the vertex order. All sub-arrays must have the same length as the vertex array (or be an exact multiple of the vertex array's length, when multiple elements of a sub-array correspond to a single vertex) or be empty, except for `Mesh.ARRAY_INDEX` if it is used.
				The `blend_shapes` argument is an array of vertex data for each blend shape. Each element is an array of the same structure as `arrays`, but `Mesh.ARRAY_VERTEX`, `Mesh.ARRAY_NORMAL`, and `Mesh.ARRAY_TANGENT` are set if and only if they are set in `arrays` and all other entries are `null`.
				The `lods` argument is a dictionary with `float` keys and `PackedInt32Array` values. Each entry in the dictionary represents an LOD level of the surface, where the value is the `Mesh.ARRAY_INDEX` array to use for the LOD level and the key is roughly proportional to the distance at which the LOD stats being used. I.e., increasing the key of an LOD also increases the distance that the objects has to be from the camera before the LOD is used.
				The `compress_format` argument is the bitwise OR of, as required: One value of `ArrayFormat` left shifted by `ARRAY_FORMAT_CUSTOMn_SHIFT` for each custom channel in use, `ARRAY_FLAG_USE_DYNAMIC_UPDATE`, `ARRAY_FLAG_USE_8_BONE_WEIGHTS`, or `ARRAY_FLAG_USES_EMPTY_VERTEX_ARRAY`.
				See `ArrayMesh.add_surface_from_arrays` and `ImporterMesh.add_surface` for higher-level equivalents of this method.
				**Note:** When using indices, it is recommended to only use points, lines, or triangles.

### `mesh_clear(mesh: RID) -> void`

Removes all surfaces from a mesh.

### `mesh_create() -> RID`

Creates a new mesh and adds it to the RenderingServer. It can be accessed with the RID that is returned. This RID will be used in all `mesh_*` RenderingServer functions.
				Once finished with your RID, you will want to free the RID using the RenderingServer's `free_rid` method.
				To place in a scene, attach this mesh to an instance using `instance_set_base` using the returned RID.
				**Note:** The equivalent resource is `Mesh`.

### `mesh_create_from_surfaces(surfaces: Dictionary[], blend_shape_count: int = 0) -> RID`

Creates a new mesh with predefined surfaces for it and adds the mesh to the RenderingServer. It can be accessed with the RID that is returned. This RID will be used in all `mesh_*` RenderingServer functions. This method is more efficient for creating meshes with multiple surfaces compared to creating an empty mesh with `mesh_create` and adding surfaces one by one with `mesh_add_surface`.
				Each element in the `surfaces` array must follow the same structure as described in `mesh_add_surface`. The `blend_shape_count` parameter must match the blend shape data defined in all surfaces.
				Once finished with your RID, you will want to free the RID using the RenderingServer's `free_rid` method.
				To place in a scene, attach this mesh to an instance using `instance_set_base` using the returned RID.
				**Note:** The equivalent resource is `Mesh`.

### `mesh_get_blend_shape_count(mesh: RID) -> int`
- 限定：qualifiers=const

Returns a mesh's blend shape count.

### `mesh_get_blend_shape_mode(mesh: RID) -> int`
- 限定：qualifiers=const

Returns a mesh's blend shape mode.

### `mesh_get_custom_aabb(mesh: RID) -> AABB`
- 限定：qualifiers=const

Returns a mesh's custom aabb.

### `mesh_get_surface(mesh: RID, surface: int) -> Dictionary`

Returns a mesh's surface as a dictionary following the same structure as described in `mesh_add_surface`.

### `mesh_get_surface_count(mesh: RID) -> int`
- 限定：qualifiers=const

Returns a mesh's number of surfaces.

### `mesh_set_blend_shape_mode(mesh: RID, mode: int) -> void`

Sets a mesh's blend shape mode.

### `mesh_set_custom_aabb(mesh: RID, aabb: AABB) -> void`

Sets a mesh's custom aabb.

### `mesh_set_shadow_mesh(mesh: RID, shadow_mesh: RID) -> void`

Sets an optional second mesh which can be used for rendering shadows and the depth prepass. Can be used to increase performance by supplying a mesh with fused vertices and only vertex position data (without normals, UVs, colors, etc.).
				**Note:** This mesh must have exactly the same vertex positions as the source mesh (including the source mesh's LODs, if present). If vertex positions differ, then the mesh will not draw correctly.

### `mesh_surface_get_arrays(mesh: RID, surface: int) -> Array`
- 限定：qualifiers=const

Returns a mesh's surface's buffer arrays.

### `mesh_surface_get_blend_shape_arrays(mesh: RID, surface: int) -> Array[]`
- 限定：qualifiers=const

Returns a mesh's surface's arrays for blend shapes.

### `mesh_surface_get_format_attribute_stride(format: int, vertex_count: int) -> int`
- 限定：qualifiers=const

Returns the stride of the attribute buffer for a mesh with given `format`.

### `mesh_surface_get_format_index_stride(format: int, vertex_count: int) -> int`
- 限定：qualifiers=const

Returns the stride of the index buffer for a mesh with the given `format`.

### `mesh_surface_get_format_normal_tangent_stride(format: int, vertex_count: int) -> int`
- 限定：qualifiers=const

Returns the stride of the combined normals and tangents for a mesh with given `format`. Note importantly that, while normals and tangents are in the vertex buffer with vertices, they are only interleaved with each other and so have a different stride than vertex positions.

### `mesh_surface_get_format_offset(format: int, vertex_count: int, array_index: int) -> int`
- 限定：qualifiers=const

Returns the offset of a given attribute by `array_index` in the start of its respective buffer.

### `mesh_surface_get_format_skin_stride(format: int, vertex_count: int) -> int`
- 限定：qualifiers=const

Returns the stride of the skin buffer for a mesh with given `format`.

### `mesh_surface_get_format_vertex_stride(format: int, vertex_count: int) -> int`
- 限定：qualifiers=const

Returns the stride of the vertex positions for a mesh with given `format`. Note importantly that vertex positions are stored consecutively and are not interleaved with the other attributes in the vertex buffer (normals and tangents).

### `mesh_surface_get_material(mesh: RID, surface: int) -> RID`
- 限定：qualifiers=const

Returns a mesh's surface's material.

### `mesh_surface_remove(mesh: RID, surface: int) -> void`

Removes the surface at the given index from the Mesh, shifting surfaces with higher index down by one.

### `mesh_surface_set_material(mesh: RID, surface: int, material: RID) -> void`

Sets a mesh's surface's material.

### `mesh_surface_update_attribute_region(mesh: RID, surface: int, offset: int, data: PackedByteArray) -> void`

Updates the attribute buffer of the mesh surface with the given `data`. The expected data per attribute is 8 or 12 bytes (4 bytes per float, 2 floats per `Vector2`, and 3 floats per `Vector3`) depending on if the mesh is using `Vector2` or `Vector3` vertices. This value can be determined with `mesh_surface_get_format_attribute_stride` instead.
				The starting point of the updates can be changed with `offset`. The value of `offset` should be a multiple of 12 bytes in most cases to align to each attribute.
				A `PackedVector3Array` of attribute locations can be converted into a `PackedByteArray` using `PackedVector3Array.to_byte_array` for use in `data`.

### `mesh_surface_update_index_region(mesh: RID, surface: int, offset: int, data: PackedByteArray) -> void`

Updates the index buffer of the mesh surface with the given `data`. The expected data are 16 or 32-bit unsigned integers, which can be determined with `mesh_surface_get_format_index_stride`.

### `mesh_surface_update_skin_region(mesh: RID, surface: int, offset: int, data: PackedByteArray) -> void`

Updates the skin buffer of the mesh surface with the given `data`. The expected data per skin is 8 or 12 bytes (4 bytes per float, 2 floats per `Vector2`, and 3 floats per `Vector3`) depending on if the mesh is using `Vector2` or `Vector3` vertices. This value can be determined with `mesh_surface_get_format_skin_stride` instead.
				The starting point of the updates can be changed with `offset`. The value of `offset` should be a multiple of 12 bytes in most cases to align to each skin.
				A `PackedVector3Array` of skin locations can be converted into a `PackedByteArray` using `PackedVector3Array.to_byte_array` for use in `data`.

### `mesh_surface_update_vertex_region(mesh: RID, surface: int, offset: int, data: PackedByteArray) -> void`

Updates the vertex buffer of the mesh surface with the given `data`. The expected data per vertex is 8 or 12 bytes (4 bytes per float, 2 floats per `Vector2`, and 3 floats per `Vector3`) depending on if the mesh is using `Vector2` or `Vector3` vertices. This value can be determined with `mesh_surface_get_format_vertex_stride` instead.
				The starting point of the updates can be changed with `offset`. The value of `offset` should be a multiple of 12 bytes in most cases to align to each vertex.
				A `PackedVector3Array` of vertex locations can be converted into a `PackedByteArray` using `PackedVector3Array.to_byte_array` for use in `data`.

### `multimesh_allocate_data(multimesh: RID, instances: int, transform_format: int, color_format: bool = false, custom_data_format: bool = false, use_indirect: bool = false) -> void`

Sets up the multimesh using the specified data. The number of instances is set by `instances`. The format of the instance transforms is set by `transform_format`, which should be set according to whether the multimesh is meant to be rendered in 2D or 3D. If `color_format` is `true`, each instance will have a color associated with it. If `custom_data_format` is `true`, each instance will have a custom data vector associated with it. If `use_indirect` is `true`, an indirect command buffer will be created for this multimesh, allowing the instance count to be modified directly on the GPU. See also `multimesh_get_command_buffer_rd_rid`.

### `multimesh_create() -> RID`

Creates a new multimesh on the RenderingServer and returns an `RID` handle. This RID will be used in all `multimesh_*` RenderingServer functions.
				Once finished with your RID, you will want to free the RID using the RenderingServer's `free_rid` method.
				To place in a scene, attach this multimesh to an instance using `instance_set_base` using the returned RID.
				**Note:** The equivalent resource is `MultiMesh`.

### `multimesh_get_aabb(multimesh: RID) -> AABB`
- 限定：qualifiers=const

Calculates and returns the axis-aligned bounding box that encloses all instances within the multimesh.

### `multimesh_get_buffer(multimesh: RID) -> PackedFloat32Array`
- 限定：qualifiers=const

Returns the MultiMesh data (such as instance transforms, colors, etc.). See `multimesh_set_buffer` for details on the returned data.
				**Note:** If the buffer is in the engine's internal cache, it will have to be fetched from GPU memory and possibly decompressed. This means `multimesh_get_buffer` is potentially a slow operation and should be avoided whenever possible.

### `multimesh_get_buffer_rd_rid(multimesh: RID) -> RID`
- 限定：qualifiers=const

Returns the `RenderingDevice` `RID` handle of the `MultiMesh`, which can be used as any other buffer on the Rendering Device.

### `multimesh_get_command_buffer_rd_rid(multimesh: RID) -> RID`
- 限定：qualifiers=const

Returns the `RenderingDevice` `RID` handle of the `MultiMesh` command buffer. This `RID` is only valid if `use_indirect` is set to `true` when allocating data through `multimesh_allocate_data`. It can be used to directly modify the instance count via buffer.
				The data structure is dependent on both how many surfaces the mesh contains and whether it is indexed or not, the buffer has 5 integers in it, with the last unused if the mesh is not indexed.
				Each of the values in the buffer correspond to these options:
				`lang=text`
				Indexed:
				  0 - indexCount;
				  1 - instanceCount;
				  2 - firstIndex;
				  3 - vertexOffset;
				  4 - firstInstance;
				Non-indexed:
				  0 - vertexCount;
				  1 - instanceCount;
				  2 - firstVertex;
				  3 - firstInstance;
				  4 - unused;

### `multimesh_get_custom_aabb(multimesh: RID) -> AABB`
- 限定：qualifiers=const

Returns the custom AABB defined for this MultiMesh resource.

### `multimesh_get_instance_count(multimesh: RID) -> int`
- 限定：qualifiers=const

Returns the number of instances allocated for this multimesh.

### `multimesh_get_mesh(multimesh: RID) -> RID`
- 限定：qualifiers=const

Returns the RID of the mesh that will be used in drawing this multimesh.

### `multimesh_get_visible_instances(multimesh: RID) -> int`
- 限定：qualifiers=const

Returns the number of visible instances for this multimesh.

### `multimesh_instance_get_color(multimesh: RID, index: int) -> Color`
- 限定：qualifiers=const

Returns the color by which the specified instance will be modulated.

### `multimesh_instance_get_custom_data(multimesh: RID, index: int) -> Color`
- 限定：qualifiers=const

Returns the custom data associated with the specified instance.

### `multimesh_instance_get_transform(multimesh: RID, index: int) -> Transform3D`
- 限定：qualifiers=const

Returns the `Transform3D` of the specified instance.

### `multimesh_instance_get_transform_2d(multimesh: RID, index: int) -> Transform2D`
- 限定：qualifiers=const

Returns the `Transform2D` of the specified instance. For use when the multimesh is set to use 2D transforms.

### `multimesh_instance_reset_physics_interpolation(multimesh: RID, index: int) -> void`

Prevents physics interpolation for the specified instance during the current physics tick.
				This is useful when moving an instance to a new location, to give an instantaneous change rather than interpolation from the previous location.

### `multimesh_instance_set_color(multimesh: RID, index: int, color: Color) -> void`

Sets the color by which this instance will be modulated. Equivalent to `MultiMesh.set_instance_color`.

### `multimesh_instance_set_custom_data(multimesh: RID, index: int, custom_data: Color) -> void`

Sets the custom data for this instance. Custom data is passed as a `Color`, but is interpreted as a `vec4` in the shader. Equivalent to `MultiMesh.set_instance_custom_data`.

### `multimesh_instance_set_transform(multimesh: RID, index: int, transform: Transform3D) -> void`

Sets the `Transform3D` for this instance. Equivalent to `MultiMesh.set_instance_transform`.

### `multimesh_instance_set_transform_2d(multimesh: RID, index: int, transform: Transform2D) -> void`

Sets the `Transform2D` for this instance. For use when multimesh is used in 2D. Equivalent to `MultiMesh.set_instance_transform_2d`.

### `multimesh_instances_reset_physics_interpolation(multimesh: RID) -> void`

Prevents physics interpolation for all instances during the current physics tick.
				This is useful when moving all instances to new locations, to give instantaneous changes rather than interpolation from the previous locations.

### `multimesh_set_buffer(multimesh: RID, buffer: PackedFloat32Array) -> void`

Set the entire data to use for drawing the `multimesh` at once to `buffer` (such as instance transforms and colors). `buffer`'s size must match the number of instances multiplied by the per-instance data size (which depends on the enabled MultiMesh fields). Otherwise, an error message is printed and nothing is rendered. See also `multimesh_get_buffer`.
				The per-instance data size and expected data order is:
				`lang=text`
				2D:
				  - Position: 8 floats (8 floats for Transform2D)
				  - Position + Vertex color: 12 floats (8 floats for Transform2D, 4 floats for Color)
				  - Position + Custom data: 12 floats (8 floats for Transform2D, 4 floats of custom data)
				  - Position + Vertex color + Custom data: 16 floats (8 floats for Transform2D, 4 floats for Color, 4 floats of custom data)
				3D:
				  - Position: 12 floats (12 floats for Transform3D)
				  - Position + Vertex color: 16 floats (12 floats for Transform3D, 4 floats for Color)
				  - Position + Custom data: 16 floats (12 floats for Transform3D, 4 floats of custom data)
				  - Position + Vertex color + Custom data: 20 floats (12 floats for Transform3D, 4 floats for Color, 4 floats of custom data)
				
				Instance transforms are in row-major order. Specifically:
				- For `Transform2D` the float-order is: `(x.x, y.x, padding_float, origin.x, x.y, y.y, padding_float, origin.y)`.
				- For `Transform3D` the float-order is: `(basis.x.x, basis.y.x, basis.z.x, origin.x, basis.x.y, basis.y.y, basis.z.y, origin.y, basis.x.z, basis.y.z, basis.z.z, origin.z)`.

### `multimesh_set_buffer_interpolated(multimesh: RID, buffer: PackedFloat32Array, buffer_previous: PackedFloat32Array) -> void`

Alternative version of `multimesh_set_buffer` for use with physics interpolation.
				Takes both an array of current data and an array of data for the previous physics tick.

### `multimesh_set_custom_aabb(multimesh: RID, aabb: AABB) -> void`

Sets the custom AABB for this MultiMesh resource.

### `multimesh_set_mesh(multimesh: RID, mesh: RID) -> void`

Sets the mesh to be drawn by the multimesh. Equivalent to `MultiMesh.mesh`.

### `multimesh_set_physics_interpolated(multimesh: RID, interpolated: bool) -> void`

Turns on and off physics interpolation for this MultiMesh resource.

### `multimesh_set_physics_interpolation_quality(multimesh: RID, quality: int) -> void`

Sets the physics interpolation quality for the `MultiMesh`.
				A value of `MULTIMESH_INTERP_QUALITY_FAST` gives fast but low quality interpolation, a value of `MULTIMESH_INTERP_QUALITY_HIGH` gives slower but higher quality interpolation.

### `multimesh_set_visible_instances(multimesh: RID, visible: int) -> void`

Sets the number of instances visible at a given time. If -1, all instances that have been allocated are drawn. Equivalent to `MultiMesh.visible_instance_count`.

### `occluder_create() -> RID`

Creates an occluder instance and adds it to the RenderingServer. It can be accessed with the RID that is returned. This RID will be used in all `occluder_*` RenderingServer functions.
				Once finished with your RID, you will want to free the RID using the RenderingServer's `free_rid` method.
				**Note:** The equivalent resource is `Occluder3D` (not to be confused with the `OccluderInstance3D` node).

### `occluder_set_mesh(occluder: RID, vertices: PackedVector3Array, indices: PackedInt32Array) -> void`

Sets the mesh data for the given occluder RID, which controls the shape of the occlusion culling that will be performed.

### `omni_light_create() -> RID`

Creates a new omni light and adds it to the RenderingServer. It can be accessed with the RID that is returned. This RID can be used in most `light_*` RenderingServer functions.
				Once finished with your RID, you will want to free the RID using the RenderingServer's `free_rid` method.
				To place in a scene, attach this omni light to an instance using `instance_set_base` using the returned RID.
				**Note:** The equivalent node is `OmniLight3D`.

### `particles_collision_create() -> RID`

Creates a new 3D GPU particle collision or attractor and adds it to the RenderingServer. It can be accessed with the RID that is returned. This RID can be used in most `particles_collision_*` RenderingServer functions.
				**Note:** The equivalent nodes are `GPUParticlesCollision3D` and `GPUParticlesAttractor3D`.

### `particles_collision_height_field_update(particles_collision: RID) -> void`

Requests an update for the 3D GPU particle collision heightfield. This may be automatically called by the 3D GPU particle collision heightfield depending on its `GPUParticlesCollisionHeightField3D.update_mode`.

### `particles_collision_set_attractor_attenuation(particles_collision: RID, curve: float) -> void`

Sets the attenuation `curve` for the 3D GPU particles attractor specified by the `particles_collision` RID. Only used for attractors, not colliders. Equivalent to `GPUParticlesAttractor3D.attenuation`.

### `particles_collision_set_attractor_directionality(particles_collision: RID, amount: float) -> void`

Sets the directionality `amount` for the 3D GPU particles attractor specified by the `particles_collision` RID. Only used for attractors, not colliders. Equivalent to `GPUParticlesAttractor3D.directionality`.

### `particles_collision_set_attractor_strength(particles_collision: RID, strength: float) -> void`

Sets the `strength` for the 3D GPU particles attractor specified by the `particles_collision` RID. Only used for attractors, not colliders. Equivalent to `GPUParticlesAttractor3D.strength`.

### `particles_collision_set_box_extents(particles_collision: RID, extents: Vector3) -> void`

Sets the `extents` for the 3D GPU particles collision by the `particles_collision` RID. Equivalent to `GPUParticlesCollisionBox3D.size`, `GPUParticlesCollisionSDF3D.size`, `GPUParticlesCollisionHeightField3D.size`, `GPUParticlesAttractorBox3D.size` or `GPUParticlesAttractorVectorField3D.size` depending on the `particles_collision` type.

### `particles_collision_set_collision_type(particles_collision: RID, type: int) -> void`

Sets the collision or attractor shape `type` for the 3D GPU particles collision or attractor specified by the `particles_collision` RID.

### `particles_collision_set_cull_mask(particles_collision: RID, mask: int) -> void`

Sets the cull `mask` for the 3D GPU particles collision or attractor specified by the `particles_collision` RID. Equivalent to `GPUParticlesCollision3D.cull_mask` or `GPUParticlesAttractor3D.cull_mask` depending on the `particles_collision` type.

### `particles_collision_set_field_texture(particles_collision: RID, texture: RID) -> void`

Sets the signed distance field `texture` for the 3D GPU particles collision specified by the `particles_collision` RID. Equivalent to `GPUParticlesCollisionSDF3D.texture` or `GPUParticlesAttractorVectorField3D.texture` depending on the `particles_collision` type.

### `particles_collision_set_height_field_mask(particles_collision: RID, mask: int) -> void`

Sets the heightfield `mask` for the 3D GPU particles heightfield collision specified by the `particles_collision` RID. Equivalent to `GPUParticlesCollisionHeightField3D.heightfield_mask`.

### `particles_collision_set_height_field_resolution(particles_collision: RID, resolution: int) -> void`

Sets the heightmap `resolution` for the 3D GPU particles heightfield collision specified by the `particles_collision` RID. Equivalent to `GPUParticlesCollisionHeightField3D.resolution`.

### `particles_collision_set_sphere_radius(particles_collision: RID, radius: float) -> void`

Sets the `radius` for the 3D GPU particles sphere collision or attractor specified by the `particles_collision` RID. Equivalent to `GPUParticlesCollisionSphere3D.radius` or `GPUParticlesAttractorSphere3D.radius` depending on the `particles_collision` type.

### `particles_create() -> RID`

Creates a GPU-based particle system and adds it to the RenderingServer. It can be accessed with the RID that is returned. This RID will be used in all `particles_*` RenderingServer functions.
				Once finished with your RID, you will want to free the RID using the RenderingServer's `free_rid` method.
				To place in a scene, attach these particles to an instance using `instance_set_base` using the returned RID.
				**Note:** The equivalent nodes are `GPUParticles2D` and `GPUParticles3D`.
				**Note:** All `particles_*` methods only apply to GPU-based particles, not CPU-based particles. `CPUParticles2D` and `CPUParticles3D` do not have equivalent RenderingServer functions available, as these use `MultiMeshInstance2D` and `MultiMeshInstance3D` under the hood (see `multimesh_*` methods).

### `particles_emit(particles: RID, transform: Transform3D, velocity: Vector3, color: Color, custom: Color, emit_flags: int) -> void`

Manually emits particles from the `particles` instance.

### `particles_get_current_aabb(particles: RID) -> AABB`

Calculates and returns the axis-aligned bounding box that contains all the particles. Equivalent to `GPUParticles3D.capture_aabb`.

### `particles_get_emitting(particles: RID) -> bool`

Returns `true` if particles are currently set to emitting.

### `particles_is_inactive(particles: RID) -> bool`

Returns `true` if particles are not emitting and particles are set to inactive.

### `particles_request_process(particles: RID) -> void`

Add particle system to list of particle systems that need to be updated. Update will take place on the next frame, or on the next call to `instances_cull_aabb`, `instances_cull_convex`, or `instances_cull_ray`.

### `particles_request_process_time(particles: RID, process_time: float, process_time_residual: float = 0.0) -> void`

Requests the particles to process for extra process time during a single frame.
				`process_time` defines the time that the particles will process while emitting is on. `process_time_residual` defines the time that particles will process with emitting turned off for the simulation. When combined with the particles' speed scale set to `0.0`, this is useful to be able to seek a particle system timeline.

### `particles_restart(particles: RID) -> void`

Reset the particles on the next update. Equivalent to `GPUParticles3D.restart`.

### `particles_set_amount(particles: RID, amount: int) -> void`

Sets the number of particles to be drawn and allocates the memory for them. Equivalent to `GPUParticles3D.amount`.

### `particles_set_amount_ratio(particles: RID, ratio: float) -> void`

Sets the amount ratio for particles to be emitted. Equivalent to `GPUParticles3D.amount_ratio`.

### `particles_set_collision_base_size(particles: RID, size: float) -> void`

Sets the base size for particle collision. Equivalent to `GPUParticles3D.collision_base_size`.

### `particles_set_custom_aabb(particles: RID, aabb: AABB) -> void`

Sets a custom axis-aligned bounding box for the particle system. Equivalent to `GPUParticles3D.visibility_aabb`.

### `particles_set_draw_order(particles: RID, order: int) -> void`

Sets the draw order of the particles. Equivalent to `GPUParticles3D.draw_order`.

### `particles_set_draw_pass_mesh(particles: RID, pass: int, mesh: RID) -> void`

Sets the mesh to be used for the specified draw pass. Equivalent to `GPUParticles3D.draw_pass_1`, `GPUParticles3D.draw_pass_2`, `GPUParticles3D.draw_pass_3`, and `GPUParticles3D.draw_pass_4`.

### `particles_set_draw_passes(particles: RID, count: int) -> void`

Sets the number of draw passes to use. Equivalent to `GPUParticles3D.draw_passes`.

### `particles_set_emission_transform(particles: RID, transform: Transform3D) -> void`

Sets the `Transform3D` that will be used by the particles when they first emit.

### `particles_set_emitter_velocity(particles: RID, velocity: Vector3) -> void`

Sets the velocity of a particle node, that will be used by `ParticleProcessMaterial.inherit_velocity_ratio`.

### `particles_set_emitting(particles: RID, emitting: bool) -> void`

If `true`, particles will emit over time. Setting to `false` does not reset the particles, but only stops their emission. Equivalent to `GPUParticles3D.emitting`.

### `particles_set_explosiveness_ratio(particles: RID, ratio: float) -> void`

Sets the explosiveness ratio. Equivalent to `GPUParticles3D.explosiveness`.

### `particles_set_fixed_fps(particles: RID, fps: int) -> void`

Sets the frame rate that the particle system rendering will be fixed to. Equivalent to `GPUParticles3D.fixed_fps`.

### `particles_set_fractional_delta(particles: RID, enable: bool) -> void`

If `true`, uses fractional delta which smooths the movement of the particles. Equivalent to `GPUParticles3D.fract_delta`.

### `particles_set_interp_to_end(particles: RID, factor: float) -> void`

Sets the value that informs a `ParticleProcessMaterial` to rush all particles towards the end of their lifetime.

### `particles_set_interpolate(particles: RID, enable: bool) -> void`

Sets whether particles should use interpolation between fixed steps. Equivalent to `GPUParticles3D.interpolate`.

### `particles_set_lifetime(particles: RID, lifetime: float) -> void`

Sets the lifetime of each particle in the system. Equivalent to `GPUParticles3D.lifetime`.

### `particles_set_mode(particles: RID, mode: int) -> void`

Sets whether the GPU particles specified by the `particles` RID should be rendered in 2D or 3D according to `mode`.

### `particles_set_one_shot(particles: RID, one_shot: bool) -> void`

If `true`, particles will emit once and then stop. Equivalent to `GPUParticles3D.one_shot`.

### `particles_set_pre_process_time(particles: RID, time: float) -> void`

Sets the preprocess time for the particles' animation. This lets you delay starting an animation until after the particles have begun emitting. Equivalent to `GPUParticles3D.preprocess`.

### `particles_set_process_material(particles: RID, material: RID) -> void`

Sets the material for processing the particles.
				**Note:** This is not the material used to draw the materials. Equivalent to `GPUParticles3D.process_material`.

### `particles_set_randomness_ratio(particles: RID, ratio: float) -> void`

Sets the emission randomness ratio. This randomizes the emission of particles within their phase. Equivalent to `GPUParticles3D.randomness`.

### `particles_set_speed_scale(particles: RID, scale: float) -> void`

Sets the speed scale of the particle system. Equivalent to `GPUParticles3D.speed_scale`.

### `particles_set_subemitter(particles: RID, subemitter_particles: RID) -> void`

Sets the subemitter particles for the particle system. Equivalent to `GPUParticles3D.sub_emitter`.

### `particles_set_trail_bind_poses(particles: RID, bind_poses: Transform3D[]) -> void`

Sets the trail bind poses for the particle system. This specified as an array of `Transform3D`s representing the bind pose for each draw pass. See `GPUParticles3D.draw_skin`, `Skin.get_bind_count`, and `Skin.get_bind_pose`. Set the value for each draw pass to `Transform3D.IDENTITY` to use the default behavior, which is what built-in trails use (`RibbonTrailMesh` and `TubeTrailMesh`).

### `particles_set_trails(particles: RID, enable: bool, length_sec: float) -> void`

If `enable` is `true`, enables trails for the `particles` with the specified `length_sec` in seconds. Equivalent to `GPUParticles3D.trail_enabled` and `GPUParticles3D.trail_lifetime`.

### `particles_set_transform_align(particles: RID, align: int) -> void`

Sets the transform alignment for the particle system. Equivalent to `GPUParticles3D.transform_align`.

### `particles_set_transform_align_axis(particles: RID, rotation_axis: int) -> void`

Sets which axis to use for transform alignment.

### `particles_set_transform_align_channel_filter(particles: RID, channel_filter: int) -> void`

When using Z-Billboarding, which CUSTOM channel to read from.

### `particles_set_use_local_coordinates(particles: RID, enable: bool) -> void`

If `true`, particles use local coordinates. If `false` they use global coordinates. Equivalent to `GPUParticles3D.local_coords`.

### `positional_soft_shadow_filter_set_quality(quality: int) -> void`

Sets the filter quality for omni and spot light shadows in 3D. See also `ProjectSettings.rendering/lights_and_shadows/positional_shadow/soft_shadow_filter_quality`. This parameter is global and cannot be set on a per-viewport basis.

### `reflection_probe_create() -> RID`

Creates a reflection probe and adds it to the RenderingServer. It can be accessed with the RID that is returned. This RID will be used in all `reflection_probe_*` RenderingServer functions.
				Once finished with your RID, you will want to free the RID using the RenderingServer's `free_rid` method.
				To place in a scene, attach this reflection probe to an instance using `instance_set_base` using the returned RID.
				**Note:** The equivalent node is `ReflectionProbe`.

### `reflection_probe_set_ambient_color(probe: RID, color: Color) -> void`

Sets the reflection probe's custom ambient light color. Equivalent to `ReflectionProbe.ambient_color`.

### `reflection_probe_set_ambient_energy(probe: RID, energy: float) -> void`

Sets the reflection probe's custom ambient light energy. Equivalent to `ReflectionProbe.ambient_color_energy`.

### `reflection_probe_set_ambient_mode(probe: RID, mode: int) -> void`

Sets the reflection probe's ambient light mode. Equivalent to `ReflectionProbe.ambient_mode`.

### `reflection_probe_set_as_interior(probe: RID, enable: bool) -> void`

If `true`, reflections will ignore sky contribution. Equivalent to `ReflectionProbe.interior`.

### `reflection_probe_set_blend_distance(probe: RID, blend_distance: float) -> void`

Sets the distance in meters over which a probe blends into the scene.

### `reflection_probe_set_cull_mask(probe: RID, layers: int) -> void`

Sets the render cull mask for this reflection probe. Only instances with a matching layer will be reflected by this probe. Equivalent to `ReflectionProbe.cull_mask`.

### `reflection_probe_set_enable_box_projection(probe: RID, enable: bool) -> void`

If `true`, uses box projection. This can make reflections look more correct in certain situations. Equivalent to `ReflectionProbe.box_projection`.

### `reflection_probe_set_enable_shadows(probe: RID, enable: bool) -> void`

If `true`, computes shadows in the reflection probe. This makes the reflection much slower to compute. Equivalent to `ReflectionProbe.enable_shadows`.

### `reflection_probe_set_intensity(probe: RID, intensity: float) -> void`

Sets the intensity of the reflection probe. Intensity modulates the strength of the reflection. Equivalent to `ReflectionProbe.intensity`.

### `reflection_probe_set_max_distance(probe: RID, distance: float) -> void`

Sets the max distance away from the probe an object can be before it is culled. Equivalent to `ReflectionProbe.max_distance`.

### `reflection_probe_set_mesh_lod_threshold(probe: RID, pixels: float) -> void`

Sets the mesh level of detail to use in the reflection probe rendering. Higher values will use less detailed versions of meshes that have LOD variations generated, which can improve performance. Equivalent to `ReflectionProbe.mesh_lod_threshold`.

### `reflection_probe_set_origin_offset(probe: RID, offset: Vector3) -> void`

Sets the origin offset to be used when this reflection probe is in box project mode. Equivalent to `ReflectionProbe.origin_offset`.

### `reflection_probe_set_reflection_mask(probe: RID, layers: int) -> void`

Sets the render reflection mask for this reflection probe. Only instances with a matching layer will have reflections applied from this probe. Equivalent to `ReflectionProbe.reflection_mask`.

### `reflection_probe_set_resolution(probe: RID, resolution: int) -> void`
- 限定：deprecated=This method has not done anything since Godot 3.

Deprecated. This method does nothing.

### `reflection_probe_set_size(probe: RID, size: Vector3) -> void`

Sets the size of the area that the reflection probe will capture. Equivalent to `ReflectionProbe.size`.

### `reflection_probe_set_update_mode(probe: RID, mode: int) -> void`

Sets how often the reflection probe updates. Can either be once or every frame.

### `request_frame_drawn_callback(callable: Callable) -> void`

Schedules a callback to the given callable after a frame has been drawn.

### `scenario_create() -> RID`

Creates a scenario and adds it to the RenderingServer. It can be accessed with the RID that is returned. This RID will be used in all `scenario_*` RenderingServer functions.
				Once finished with your RID, you will want to free the RID using the RenderingServer's `free_rid` method.
				The scenario is the 3D world that all the visual instances exist in.

### `scenario_set_camera_attributes(scenario: RID, effects: RID) -> void`

Sets the camera attributes (`effects`) that will be used with this scenario. See also `CameraAttributes`.

### `scenario_set_compositor(scenario: RID, compositor: RID) -> void`

Sets the compositor (`compositor`) that will be used with this scenario. See also `Compositor`.

### `scenario_set_environment(scenario: RID, environment: RID) -> void`

Sets the environment that will be used with this scenario. See also `Environment`.

### `scenario_set_fallback_environment(scenario: RID, environment: RID) -> void`

Sets the fallback environment to be used by this scenario. The fallback environment is used if no environment is set. Internally, this is used by the editor to provide a default environment.

### `screen_space_roughness_limiter_set_active(enable: bool, amount: float, limit: float) -> void`

Sets the screen-space roughness limiter parameters, such as whether it should be enabled and its thresholds. Equivalent to `ProjectSettings.rendering/anti_aliasing/screen_space_roughness_limiter/enabled`, `ProjectSettings.rendering/anti_aliasing/screen_space_roughness_limiter/amount` and `ProjectSettings.rendering/anti_aliasing/screen_space_roughness_limiter/limit`.

### `set_boot_image(image: Image, color: Color, scale: bool, use_filter: bool = true) -> void`
- 限定：deprecated=Use [method set_boot_image_with_stretch] instead.

Sets a boot image. The `color` defines the background color. The value of `scale` indicates if the image will be scaled to fit the screen size. If `use_filter` is `true`, the image will be scaled with linear interpolation. If `use_filter` is `false`, the image will be scaled with nearest-neighbor interpolation.

### `set_boot_image_with_stretch(image: Image, color: Color, stretch_mode: int, use_filter: bool = true) -> void`

Sets a boot image. The `color` defines the background color. The value of `stretch_mode` indicates how the image will be stretched (see `SplashStretchMode` for possible values). If `use_filter` is `true`, the image will be scaled with linear interpolation. If `use_filter` is `false`, the image will be scaled with nearest-neighbor interpolation.

### `set_debug_generate_wireframes(generate: bool) -> void`

If `generate` is `true`, generates debug wireframes for all meshes that are loaded when using the Compatibility renderer. By default, the engine does not generate debug wireframes at runtime, since they slow down loading of assets and take up VRAM.
				**Note:** You must call this method before loading any meshes when using the Compatibility renderer. Otherwise, wireframes will not be used.

### `set_default_clear_color(color: Color) -> void`

Sets the default clear color which is used when a specific clear color has not been selected. See also `get_default_clear_color`.

### `shader_create() -> RID`

Creates an empty shader and adds it to the RenderingServer. It can be accessed with the RID that is returned. This RID will be used in all `shader_*` RenderingServer functions.
				Once finished with your RID, you will want to free the RID using the RenderingServer's `free_rid` method.
				**Note:** The equivalent resource is `Shader`.

### `shader_get_code(shader: RID) -> String`
- 限定：qualifiers=const

Returns a shader's source code as a string.

### `shader_get_default_texture_parameter(shader: RID, name: StringName, index: int = 0) -> RID`
- 限定：qualifiers=const

Returns a default texture from a shader searched by name.
				**Note:** If the sampler array is used use `index` to access the specified texture.

### `shader_get_parameter_default(shader: RID, name: StringName) -> Variant`
- 限定：qualifiers=const

Returns the default value for the specified shader uniform. This is usually the value written in the shader source code.

### `shader_set_code(shader: RID, code: String) -> void`

Sets the shader's source code (which triggers recompilation after being changed).

### `shader_set_default_texture_parameter(shader: RID, name: StringName, texture: RID, index: int = 0) -> void`

Sets a shader's default texture. Overwrites the texture given by name.
				**Note:** If the sampler array is used use `index` to access the specified texture.

### `shader_set_path_hint(shader: RID, path: String) -> void`

Sets the path hint for the specified shader. This should generally match the `Shader` resource's `Resource.resource_path`.

### `skeleton_allocate_data(skeleton: RID, bones: int, is_2d_skeleton: bool = false) -> void`

Allocates data for this skeleton using the number of bones specified in `bones`. If `is_2d_skeleton` is `true`, the skeleton will be treated as a 2D skeleton instead of a 3D skeleton. See also `skeleton_get_bone_count`.

### `skeleton_bone_get_transform(skeleton: RID, bone: int) -> Transform3D`
- 限定：qualifiers=const

Returns the `Transform3D` set for a specific bone of this skeleton.

### `skeleton_bone_get_transform_2d(skeleton: RID, bone: int) -> Transform2D`
- 限定：qualifiers=const

Returns the `Transform2D` set for a specific bone of this skeleton.

### `skeleton_bone_set_transform(skeleton: RID, bone: int, transform: Transform3D) -> void`

Sets the `Transform3D` for a specific bone of this skeleton.

### `skeleton_bone_set_transform_2d(skeleton: RID, bone: int, transform: Transform2D) -> void`

Sets the `Transform2D` for a specific bone of this skeleton.

### `skeleton_create() -> RID`

Creates a skeleton and adds it to the RenderingServer. It can be accessed with the RID that is returned. This RID will be used in all `skeleton_*` RenderingServer functions.
				Once finished with your RID, you will want to free the RID using the RenderingServer's `free_rid` method.

### `skeleton_get_bone_count(skeleton: RID) -> int`
- 限定：qualifiers=const

Returns the number of bones allocated for this skeleton. See also `skeleton_allocate_data`.

### `skeleton_set_base_transform_2d(skeleton: RID, base_transform: Transform2D) -> void`

Sets the base `Transform2D` to use for the specified skeleton.

### `sky_bake_panorama(sky: RID, energy: float, bake_irradiance: bool, size: Vector2i) -> Image`

Generates and returns an `Image` containing the radiance map for the specified `sky` RID. This supports built-in sky material and custom sky shaders. If `bake_irradiance` is `true`, the irradiance map is saved instead of the radiance map. The radiance map is used to render reflected light, while the irradiance map is used to render ambient light. See also `environment_bake_panorama`.
				**Note:** The image is saved using linear encoding without any tonemapping performed, which means it will look too dark if viewed directly in an image editor. `energy` values above `1.0` can be used to brighten the resulting image.
				**Note:** `size` should be a 2:1 aspect ratio for the generated panorama to have square pixels. For radiance maps, there is no point in using a height greater than `Sky.radiance_size`, as it won't increase detail. Irradiance maps only contain low-frequency data, so there is usually no point in going past a size of 128×64 pixels when saving an irradiance map.

### `sky_create() -> RID`

Creates an empty sky and adds it to the RenderingServer. It can be accessed with the RID that is returned. This RID will be used in all `sky_*` RenderingServer functions.
				Once finished with your RID, you will want to free the RID using the RenderingServer's `free_rid` method.

### `sky_set_material(sky: RID, material: RID) -> void`

Sets the material that the sky uses to render the background, ambient and reflection maps.

### `sky_set_mode(sky: RID, mode: int) -> void`

Sets the process `mode` of the sky specified by the `sky` RID. Equivalent to `Sky.process_mode`.

### `sky_set_radiance_size(sky: RID, radiance_size: int) -> void`

Sets the `radiance_size` of the sky specified by the `sky` RID (in pixels). Equivalent to `Sky.radiance_size`.

### `spot_light_create() -> RID`

Creates a spot light and adds it to the RenderingServer. It can be accessed with the RID that is returned. This RID can be used in most `light_*` RenderingServer functions.
				Once finished with your RID, you will want to free the RID using the RenderingServer's `free_rid` method.
				To place in a scene, attach this spot light to an instance using `instance_set_base` using the returned RID.

### `sub_surface_scattering_set_quality(quality: int) -> void`

Sets `ProjectSettings.rendering/environment/subsurface_scattering/subsurface_scattering_quality` to use when rendering materials that have subsurface scattering enabled.

### `sub_surface_scattering_set_scale(scale: float, depth_scale: float) -> void`

Sets the `ProjectSettings.rendering/environment/subsurface_scattering/subsurface_scattering_scale` and `ProjectSettings.rendering/environment/subsurface_scattering/subsurface_scattering_depth_scale` to use when rendering materials that have subsurface scattering enabled.

### `texture_2d_create(image: Image) -> RID`

Creates a 2-dimensional texture and adds it to the RenderingServer. It can be accessed with the RID that is returned. This RID will be used in all `texture_2d_*` RenderingServer functions.
				Once finished with your RID, you will want to free the RID using the RenderingServer's `free_rid` method.
				**Note:** The equivalent resource is `Texture2D`.
				**Note:** Not to be confused with `RenderingDevice.texture_create`, which creates the graphics API's own texture type as opposed to the Godot-specific `Texture2D` resource.

### `texture_2d_get(texture: RID) -> Image`
- 限定：qualifiers=const

Returns an `Image` instance from the given `texture` `RID`.
				**Example:** Get the test texture from `get_test_texture` and apply it to a `Sprite2D` node:
				
```gdscript
				var texture_rid = RenderingServer.get_test_texture()
				var texture = ImageTexture.create_from_image(RenderingServer.texture_2d_get(texture_rid))
				$Sprite2D.texture = texture
				
```

### `texture_2d_layer_get(texture: RID, layer: int) -> Image`
- 限定：qualifiers=const

Returns an `Image` instance from the given `texture` `RID` and `layer`.

### `texture_2d_layered_create(layers: Image[], layered_type: int) -> RID`

Creates a 2-dimensional layered texture and adds it to the RenderingServer. It can be accessed with the RID that is returned. This RID will be used in all `texture_2d_layered_*` RenderingServer functions.
				Once finished with your RID, you will want to free the RID using the RenderingServer's `free_rid` method.
				**Note:** The equivalent resource is `TextureLayered`.

### `texture_2d_layered_placeholder_create(layered_type: int) -> RID`

Creates a placeholder for a 2-dimensional layered texture and adds it to the RenderingServer. It can be accessed with the RID that is returned. This RID will be used in all `texture_2d_layered_*` RenderingServer functions, although it does nothing when used. See also `texture_2d_placeholder_create`.
				**Note:** The equivalent resource is `PlaceholderTextureLayered`.

### `texture_2d_placeholder_create() -> RID`

Creates a placeholder for a 2-dimensional layered texture and adds it to the RenderingServer. It can be accessed with the RID that is returned. This RID will be used in all `texture_2d_layered_*` RenderingServer functions, although it does nothing when used. See also `texture_2d_layered_placeholder_create`.
				Once finished with your RID, you will want to free the RID using the RenderingServer's `free_rid` method.
				**Note:** The equivalent resource is `PlaceholderTexture2D`.

### `texture_2d_update(texture: RID, image: Image, layer: int) -> void`

Updates the texture specified by the `texture` `RID` with the data in `image`. A `layer` must also be specified, which should be `0` when updating a single-layer texture (`Texture2D`).
				**Note:** The `image` must have the same width, height and format as the current `texture` data. Otherwise, an error will be printed and the original texture won't be modified. If you need to use different width, height or format, use `texture_replace` instead.

### `texture_3d_create(format: int, width: int, height: int, depth: int, mipmaps: bool, data: Image[]) -> RID`

**Note:** The equivalent resource is `Texture3D`.

### `texture_3d_get(texture: RID) -> Image[]`
- 限定：qualifiers=const

Returns 3D texture data as an array of `Image`s for the specified texture `RID`.

### `texture_3d_placeholder_create() -> RID`

Creates a placeholder for a 3-dimensional texture and adds it to the RenderingServer. It can be accessed with the RID that is returned. This RID will be used in all `texture_3d_*` RenderingServer functions, although it does nothing when used.
				Once finished with your RID, you will want to free the RID using the RenderingServer's `free_rid` method.
				**Note:** The equivalent resource is `PlaceholderTexture3D`.

### `texture_3d_update(texture: RID, data: Image[]) -> void`

Updates the texture specified by the `texture` `RID`'s data with the data in `data`. All the texture's layers must be replaced at once.
				**Note:** The `texture` must have the same width, height, depth and format as the current texture data. Otherwise, an error will be printed and the original texture won't be modified. If you need to use different width, height, depth or format, use `texture_replace` instead.

### `texture_create_from_native_handle(type: int, format: int, native_handle: int, width: int, height: int, depth: int, layers: int = 1, layered_type: int = 0) -> RID`

Creates a texture based on a native handle that was created outside of Godot's renderer.
				**Note:** If using only the rendering device renderer, it's recommend to use `RenderingDevice.texture_create_from_extension` together with `RenderingServer.texture_rd_create`, rather than this method. This way, the texture's format and usage can be controlled more effectively.

### `texture_drawable_blit_rect(textures: RID[], rect: Rect2i, material: RID, modulate: Color, source_textures: RID[], to_mipmap: int = 0) -> void`

Draws to `rect` on up to 4 given Drawable `textures`, using a TextureBlit Shader from `material`. `modulate` and up to 4 `source_textures` are uniforms for the Shader to process with. `to_mipmap` can specify to perform this draw to a lower mipmap level.
				**Note:** All `textures` must be the same size and format.

### `texture_drawable_create(width: int, height: int, format: int, color: Color = Color(1, 1, 1, 1), with_mipmaps: bool = false) -> RID`

Creates a 2-dimensional texture and adds it to the RenderingServer. It can be accessed with the RID that is returned. This RID will be used in all `texture_drawable*` RenderingServer functions.
				Once finished with your RID, you will want to free the RID using the RenderingServer's `free_rid` method.
				**Note:** The equivalent resource is `DrawableTexture2D`.

### `texture_drawable_generate_mipmaps(texture: RID) -> void`

Calculates new MipMaps for the given Drawable `texture`.

### `texture_drawable_get_default_material() -> RID`
- 限定：qualifiers=const

Returns a ShaderMaterial with the default texture_blit Shader.

### `texture_get_format(texture: RID) -> int`
- 限定：qualifiers=const

Returns the format for the texture.

### `texture_get_native_handle(texture: RID, srgb: bool = false) -> int`
- 限定：qualifiers=const

Returns the internal graphics handle for this texture object. For use when communicating with third-party APIs mostly with GDExtension.
				`srgb` should be `true` when the texture uses nonlinear sRGB encoding and `false` when the texture uses linear encoding.
				**Note:** This function returns a `uint64_t` which internally maps to a `GLuint` (OpenGL) or `VkImage` (Vulkan).

### `texture_get_path(texture: RID) -> String`
- 限定：qualifiers=const

Returns the resource path (starting with `res://` or `uid://`) for the specified texture RID. Returns an empty `String` if the resource is built-in. See also `texture_set_path`.

### `texture_get_rd_texture(texture: RID, srgb: bool = false) -> RID`
- 限定：qualifiers=const

Returns a texture `RID` that can be used with `RenderingDevice`.
				`srgb` should be `true` when the texture uses nonlinear sRGB encoding and `false` when the texture uses linear encoding.

### `texture_proxy_create(base: RID) -> RID`
- 限定：deprecated=ProxyTexture was removed in Godot 4.

This method does nothing and always returns an invalid `RID`.

### `texture_proxy_update(texture: RID, proxy_to: RID) -> void`
- 限定：deprecated=ProxyTexture was removed in Godot 4.

This method does nothing.

### `texture_rd_create(rd_texture: RID, layer_type: int = 0) -> RID`

Creates a new texture object based on a texture created directly on the `RenderingDevice`. If the texture contains layers, `layer_type` is used to define the layer type.
				Once finished with your RID, you will want to free the RID using the RenderingServer's `free_rid` method.
				**Note:** The RenderingServer's `free_rid` won't free the underlying `rd_texture`, you will want to free the `rd_texture` using `RenderingDevice.free_rid`.

### `texture_replace(texture: RID, by_texture: RID) -> void`

Replaces `texture`'s texture data by the texture specified by the `by_texture` RID, without changing `texture`'s RID.

### `texture_set_force_redraw_if_visible(texture: RID, enable: bool) -> void`

Sets whether the texture RID should force redrawing when it's visible on screen when `OS.low_processor_usage_mode` is `true`. This is used by `AnimatedTexture` to force redrawing.

### `texture_set_path(texture: RID, path: String) -> void`

Sets the resource path for this texture RID. See also `texture_get_path`.
				**Note:** This is purely a hint and does not cause the texture to be automatically saved when set to a `res://` path.

### `texture_set_size_override(texture: RID, width: int, height: int) -> void`

Sets the size at which the texture should be *displayed* in 2D, ignoring its original size. This does not rescale the texture data itself, only how it is drawn in 2D. Set `width` and `height` to 0 to disable the size override.

### `viewport_attach_camera(viewport: RID, camera: RID) -> void`

Sets a viewport's camera.

### `viewport_attach_canvas(viewport: RID, canvas: RID) -> void`

Sets a viewport's canvas.

### `viewport_attach_to_screen(viewport: RID, rect: Rect2 = Rect2(0, 0, 0, 0), screen: int = 0) -> void`

Copies the viewport to a region of the screen specified by `rect`. If `viewport_set_render_direct_to_screen` is `true`, then the viewport does not use a framebuffer and the contents of the viewport are rendered directly to screen. However, note that the root viewport is drawn last, therefore it will draw over the screen. Accordingly, you must set the root viewport to an area that does not cover the area that you have attached this viewport to.
				For example, you can set the root viewport to not render at all with the following code:
				`codeblocks`
				`gdscript`
				func _ready():
					RenderingServer.viewport_attach_to_screen(get_viewport().get_viewport_rid(), Rect2())
					RenderingServer.viewport_attach_to_screen($Viewport.get_viewport_rid(), Rect2(0, 0, 600, 600))
				
				
				Using this can result in significant optimization, especially on lower-end devices. However, it comes at the cost of having to manage your viewports manually. For further optimization, see `viewport_set_render_direct_to_screen`.

### `viewport_create() -> RID`

Creates an empty viewport and adds it to the RenderingServer. It can be accessed with the RID that is returned. This RID will be used in all `viewport_*` RenderingServer functions.
				Once finished with your RID, you will want to free the RID using the RenderingServer's `free_rid` method.
				**Note:** The equivalent node is `Viewport`.

### `viewport_get_measured_render_time_cpu(viewport: RID) -> float`
- 限定：qualifiers=const

Returns the CPU time taken to render the last frame in milliseconds. This *only* includes time spent in rendering-related operations; scripts' `_process` functions and other engine subsystems are not included in this readout. To get a complete readout of CPU time spent to render the scene, sum the render times of all viewports that are drawn every frame plus `get_frame_setup_time_cpu`. Unlike `Engine.get_frames_per_second`, this method will accurately reflect CPU utilization even if framerate is capped via V-Sync or `Engine.max_fps`. See also `viewport_get_measured_render_time_gpu`.
				**Note:** Requires measurements to be enabled on the specified `viewport` using `viewport_set_measure_render_time`. Otherwise, this method returns `0.0`.

### `viewport_get_measured_render_time_gpu(viewport: RID) -> float`
- 限定：qualifiers=const

Returns the GPU time taken to render the last frame in milliseconds. To get a complete readout of GPU time spent to render the scene, sum the render times of all viewports that are drawn every frame. Unlike `Engine.get_frames_per_second`, this method accurately reflects GPU utilization even if framerate is capped via V-Sync or `Engine.max_fps`. See also `viewport_get_measured_render_time_cpu`.
				**Note:** Requires measurements to be enabled on the specified `viewport` using `viewport_set_measure_render_time`. Otherwise, this method returns `0.0`.
				**Note:** When GPU utilization is low enough during a certain period of time, GPUs will decrease their power state (which in turn decreases core and memory clock speeds). This can cause the reported GPU time to increase if GPU utilization is kept low enough by a framerate cap (compared to what it would be at the GPU's highest power state). Keep this in mind when benchmarking using `viewport_get_measured_render_time_gpu`. This behavior can be overridden in the graphics driver settings at the cost of higher power usage.

### `viewport_get_render_info(viewport: RID, type: int, info: int) -> int`

Returns a statistic about the rendering engine which can be used for performance profiling. This is separated into render pass `type`s, each of them having the same `info`s you can query (different passes will return different values).
				See also `get_rendering_info`, which returns global information across all viewports.
				**Note:** Viewport rendering information is not available until at least 2 frames have been rendered by the engine. If rendering information is not available, `viewport_get_render_info` returns `0`. To print rendering information in `_ready()` successfully, use the following:
				
```gdscript
				func _ready():
					for _i in 2:
						await get_tree().process_frame

					print(
							RenderingServer.viewport_get_render_info(get_viewport().get_viewport_rid(),
							RenderingServer.VIEWPORT_RENDER_INFO_TYPE_VISIBLE,
							RenderingServer.VIEWPORT_RENDER_INFO_DRAW_CALLS_IN_FRAME)
					)
				
```

### `viewport_get_render_target(viewport: RID) -> RID`
- 限定：qualifiers=const

Returns the render target for the viewport.

### `viewport_get_texture(viewport: RID) -> RID`
- 限定：qualifiers=const

Returns the viewport's last rendered frame.

### `viewport_get_update_mode(viewport: RID) -> int`
- 限定：qualifiers=const

Returns the viewport's update mode.
				**Warning:** Calling this from any thread other than the rendering thread will be detrimental to performance.

### `viewport_remove_canvas(viewport: RID, canvas: RID) -> void`

Detaches a viewport from a canvas.

### `viewport_set_active(viewport: RID, active: bool) -> void`

If `true`, sets the viewport active, else sets it inactive.

### `viewport_set_anisotropic_filtering_level(viewport: RID, anisotropic_filtering_level: int) -> void`

Sets the maximum number of samples to take when using anisotropic filtering on textures (as a power of two). A higher sample count will result in sharper textures at oblique angles, but is more expensive to compute. A value of `0` forcibly disables anisotropic filtering, even on materials where it is enabled.
				The anisotropic filtering level also affects decals and light projectors if they are configured to use anisotropic filtering. See `ProjectSettings.rendering/textures/decals/filter` and `ProjectSettings.rendering/textures/light_projectors/filter`.
				**Note:** In 3D, for this setting to have an effect, set `BaseMaterial3D.texture_filter` to `BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC` or `BaseMaterial3D.TEXTURE_FILTER_NEAREST_WITH_MIPMAPS_ANISOTROPIC` on materials.
				**Note:** In 2D, for this setting to have an effect, set `CanvasItem.texture_filter` to `CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC` or `CanvasItem.TEXTURE_FILTER_NEAREST_WITH_MIPMAPS_ANISOTROPIC` on the `CanvasItem` node displaying the texture (or in `CanvasTexture`). However, anisotropic filtering is rarely useful in 2D, so only enable it for textures in 2D if it makes a meaningful visual difference.

### `viewport_set_canvas_cull_mask(viewport: RID, canvas_cull_mask: int) -> void`

Sets the rendering mask associated with this `Viewport`. Only `CanvasItem` nodes with a matching rendering visibility layer will be rendered by this `Viewport`.

### `viewport_set_canvas_stacking(viewport: RID, canvas: RID, layer: int, sublayer: int) -> void`

Sets the stacking order for a viewport's canvas.
				`layer` is the actual canvas layer, while `sublayer` specifies the stacking order of the canvas among those in the same layer.
				**Note:** `layer` should be between `CANVAS_LAYER_MIN` and `CANVAS_LAYER_MAX` (inclusive). Any other value will wrap around.

### `viewport_set_canvas_transform(viewport: RID, canvas: RID, offset: Transform2D) -> void`

Sets the transformation of a viewport's canvas.

### `viewport_set_clear_mode(viewport: RID, clear_mode: int) -> void`

Sets the clear mode of a viewport.

### `viewport_set_debug_draw(viewport: RID, draw: int) -> void`

Sets the debug draw mode of a viewport.

### `viewport_set_default_canvas_item_texture_filter(viewport: RID, filter: int) -> void`

Sets the default texture filtering mode for the specified `viewport` RID.

### `viewport_set_default_canvas_item_texture_repeat(viewport: RID, repeat: int) -> void`

Sets the default texture repeat mode for the specified `viewport` RID.

### `viewport_set_disable_2d(viewport: RID, disable: bool) -> void`

If `true`, the viewport's canvas (i.e. 2D and GUI elements) is not rendered.

### `viewport_set_disable_3d(viewport: RID, disable: bool) -> void`

If `true`, the viewport's 3D elements are not rendered.

### `viewport_set_environment_mode(viewport: RID, mode: int) -> void`

Sets the viewport's environment mode which allows enabling or disabling rendering of 3D environment over 2D canvas. When disabled, 2D will not be affected by the environment. When enabled, 2D will be affected by the environment if the environment background mode is `ENV_BG_CANVAS`. The default behavior is to inherit the setting from the viewport's parent. If the topmost parent is also set to `VIEWPORT_ENVIRONMENT_INHERIT`, then the behavior will be the same as if it was set to `VIEWPORT_ENVIRONMENT_ENABLED`.

### `viewport_set_fsr_sharpness(viewport: RID, sharpness: float) -> void`

Determines how sharp the upscaled image will be when using the FSR upscaling mode. Sharpness halves with every whole number. Values go from 0.0 (sharpest) to 2.0. Values above 2.0 won't make a visible difference.

### `viewport_set_global_canvas_transform(viewport: RID, transform: Transform2D) -> void`

Sets the viewport's global transformation matrix.

### `viewport_set_measure_render_time(viewport: RID, enable: bool) -> void`

Sets the measurement for the given `viewport` RID (obtained using `Viewport.get_viewport_rid`). Once enabled, `viewport_get_measured_render_time_cpu` and `viewport_get_measured_render_time_gpu` will return values greater than `0.0` when queried with the given `viewport`.

### `viewport_set_msaa_2d(viewport: RID, msaa: int) -> void`

Sets the multisample antialiasing mode for 2D/Canvas on the specified `viewport` RID. Equivalent to `ProjectSettings.rendering/anti_aliasing/quality/msaa_2d` or `Viewport.msaa_2d`.

### `viewport_set_msaa_3d(viewport: RID, msaa: int) -> void`

Sets the multisample antialiasing mode for 3D on the specified `viewport` RID. Equivalent to `ProjectSettings.rendering/anti_aliasing/quality/msaa_3d` or `Viewport.msaa_3d`.

### `viewport_set_occlusion_culling_build_quality(quality: int) -> void`

Sets the `ProjectSettings.rendering/occlusion_culling/bvh_build_quality` to use for occlusion culling. This parameter is global and cannot be set on a per-viewport basis.

### `viewport_set_occlusion_rays_per_thread(rays_per_thread: int) -> void`

Sets the `ProjectSettings.rendering/occlusion_culling/occlusion_rays_per_thread` to use for occlusion culling. This parameter is global and cannot be set on a per-viewport basis.

### `viewport_set_parent_viewport(viewport: RID, parent_viewport: RID) -> void`

Sets the viewport's parent to the viewport specified by the `parent_viewport` RID.

### `viewport_set_positional_shadow_atlas_quadrant_subdivision(viewport: RID, quadrant: int, subdivision: int) -> void`

Sets the number of subdivisions to use in the specified shadow atlas `quadrant` for omni and spot shadows. See also `Viewport.set_positional_shadow_atlas_quadrant_subdiv`.

### `viewport_set_positional_shadow_atlas_size(viewport: RID, size: int, use_16_bits: bool = false) -> void`

Sets the `size` of the shadow atlas's images (used for omni and spot lights) on the viewport specified by the `viewport` RID. The value is rounded up to the nearest power of 2. If `use_16_bits` is `true`, use 16 bits for the omni/spot shadow depth map. Enabling this results in shadows having less precision and may result in shadow acne, but can lead to performance improvements on some devices.
				**Note:** If this is set to `0`, no positional shadows will be visible at all. This can improve performance significantly on low-end systems by reducing both the CPU and GPU load (as fewer draw calls are needed to draw the scene without shadows).

### `viewport_set_render_direct_to_screen(viewport: RID, enabled: bool) -> void`

If `true`, render the contents of the viewport directly to screen. This allows a low-level optimization where you can skip drawing a viewport to the root viewport. While this optimization can result in a significant increase in speed (especially on older devices), it comes at a cost of usability. When this is enabled, you cannot read from the viewport or from the screen_texture. You also lose the benefit of certain window settings, such as the various stretch modes. Another consequence to be aware of is that in 2D the rendering happens in window coordinates, so if you have a viewport that is double the size of the window, and you set this, then only the portion that fits within the window will be drawn, no automatic scaling is possible, even if your game scene is significantly larger than the window size.

### `viewport_set_scaling_3d_mode(viewport: RID, scaling_3d_mode: int) -> void`

Sets the 3D resolution scaling mode. Bilinear scaling renders at different resolution to either undersample or supersample the viewport. FidelityFX Super Resolution 1.0, abbreviated to FSR, is an upscaling technology that produces high quality images at fast framerates by using a spatially aware upscaling algorithm. FSR is slightly more expensive than bilinear, but it produces significantly higher image quality. FSR should be used where possible.

### `viewport_set_scaling_3d_scale(viewport: RID, scale: float) -> void`

Scales the 3D render buffer based on the viewport size uses an image filter specified in `ViewportScaling3DMode` to scale the output image to the full viewport size. Values lower than `1.0` can be used to speed up 3D rendering at the cost of quality (undersampling). Values greater than `1.0` are only valid for bilinear mode and can be used to improve 3D rendering quality at a high performance cost (supersampling). See also `ViewportMSAA` for multi-sample antialiasing, which is significantly cheaper but only smoothens the edges of polygons.
				When using FSR upscaling, AMD recommends exposing the following values as preset options to users "Ultra Quality: 0.77", "Quality: 0.67", "Balanced: 0.59", "Performance: 0.5" instead of exposing the entire scale.

### `viewport_set_scenario(viewport: RID, scenario: RID) -> void`

Sets a viewport's scenario. The scenario contains information about environment information, reflection atlas, etc.

### `viewport_set_screen_space_aa(viewport: RID, mode: int) -> void`

Sets the viewport's screen-space antialiasing mode. Equivalent to `ProjectSettings.rendering/anti_aliasing/quality/screen_space_aa` or `Viewport.screen_space_aa`.

### `viewport_set_sdf_oversize_and_scale(viewport: RID, oversize: int, scale: int) -> void`

Sets the viewport's 2D signed distance field `ProjectSettings.rendering/2d/sdf/oversize` and `ProjectSettings.rendering/2d/sdf/scale`. This is used when sampling the signed distance field in `CanvasItem` shaders as well as `GPUParticles2D` collision. This is *not* used by SDFGI in 3D rendering.

### `viewport_set_size(viewport: RID, width: int, height: int, view_count: int = 1) -> void`

Sets the viewport's `width` and `height` in pixels. Optionally the `view_count` can be set to increase the number of view layers for stereo rendering.

### `viewport_set_snap_2d_transforms_to_pixel(viewport: RID, enabled: bool) -> void`

If `true`, canvas item transforms (i.e. origin position) are snapped to the nearest pixel when rendering. This can lead to a crisper appearance at the cost of less smooth movement, especially when `Camera2D` smoothing is enabled. Equivalent to `ProjectSettings.rendering/2d/snap/snap_2d_transforms_to_pixel`.

### `viewport_set_snap_2d_vertices_to_pixel(viewport: RID, enabled: bool) -> void`

If `true`, canvas item vertices (i.e. polygon points) are snapped to the nearest pixel when rendering. This can lead to a crisper appearance at the cost of less smooth movement, especially when `Camera2D` smoothing is enabled. Equivalent to `ProjectSettings.rendering/2d/snap/snap_2d_vertices_to_pixel`.

### `viewport_set_texture_mipmap_bias(viewport: RID, mipmap_bias: float) -> void`

Affects the final texture sharpness by reading from a lower or higher mipmap (also called "texture LOD bias"). Negative values make mipmapped textures sharper but grainier when viewed at a distance, while positive values make mipmapped textures blurrier (even when up close). To get sharper textures at a distance without introducing too much graininess, set this between `-0.75` and `0.0`. Enabling temporal antialiasing (`ProjectSettings.rendering/anti_aliasing/quality/use_taa`) can help reduce the graininess visible when using negative mipmap bias.
				**Note:** When the 3D scaling mode is set to FSR 1.0, this value is used to adjust the automatic mipmap bias which is calculated internally based on the scale factor. The formula for this is `-log2(1.0 / scale) + mipmap_bias`.
				**Note:** This method is only supported in the Forward+ and Mobile renderers, not Compatibility. In Compatibility, this method is always treated as if `mipmap_bias` was set to `0.0`.

### `viewport_set_transparent_background(viewport: RID, enabled: bool) -> void`

If `true`, the viewport renders its background as transparent.

### `viewport_set_update_mode(viewport: RID, update_mode: int) -> void`

Sets when the viewport should be updated.

### `viewport_set_use_debanding(viewport: RID, enable: bool) -> void`

Equivalent to `Viewport.use_debanding`. See also `ProjectSettings.rendering/anti_aliasing/quality/use_debanding`.

### `viewport_set_use_hdr_2d(viewport: RID, enabled: bool) -> void`

If `true`, 2D rendering will use a high dynamic range (HDR) `RGBA16` format framebuffer. Additionally, 2D rendering will be performed on linear values and will be converted using the appropriate transfer function immediately before blitting to the screen (if the Viewport is attached to the screen).
				Practically speaking, this means that the end result of the Viewport will not be clamped to the `0-1` range and can be used in 3D rendering without color encoding adjustments. This allows 2D rendering to take advantage of effects requiring high dynamic range (e.g. 2D glow) as well as substantially improves the appearance of effects requiring highly detailed gradients. This setting has the same effect as `Viewport.use_hdr_2d`.

### `viewport_set_use_occlusion_culling(viewport: RID, enable: bool) -> void`

If `true`, enables occlusion culling on the specified viewport. Equivalent to `ProjectSettings.rendering/occlusion_culling/use_occlusion_culling`.

### `viewport_set_use_taa(viewport: RID, enable: bool) -> void`

If `true`, use temporal antialiasing. Equivalent to `ProjectSettings.rendering/anti_aliasing/quality/use_taa` or `Viewport.use_taa`.

### `viewport_set_use_xr(viewport: RID, use_xr: bool) -> void`

If `true`, the viewport uses augmented or virtual reality technologies. See `XRInterface`.

### `viewport_set_vrs_mode(viewport: RID, mode: int) -> void`

Sets the Variable Rate Shading (VRS) mode for the viewport. If the GPU does not support VRS, this property is ignored. Equivalent to `ProjectSettings.rendering/vrs/mode`.

### `viewport_set_vrs_texture(viewport: RID, texture: RID) -> void`

The texture to use when the VRS mode is set to `RenderingServer.VIEWPORT_VRS_TEXTURE`. Equivalent to `ProjectSettings.rendering/vrs/texture`.

### `viewport_set_vrs_update_mode(viewport: RID, mode: int) -> void`

Sets the update mode for Variable Rate Shading (VRS) for the viewport. VRS requires the input texture to be converted to the format usable by the VRS method supported by the hardware. The update mode defines how often this happens. If the GPU does not support VRS, or VRS is not enabled, this property is ignored.
				If set to `RenderingServer.VIEWPORT_VRS_UPDATE_ONCE`, the input texture is copied once and the mode is changed to `RenderingServer.VIEWPORT_VRS_UPDATE_DISABLED`.

### `visibility_notifier_create() -> RID`

Creates a new 3D visibility notifier object and adds it to the RenderingServer. It can be accessed with the RID that is returned. This RID will be used in all `visibility_notifier_*` RenderingServer functions.
				Once finished with your RID, you will want to free the RID using the RenderingServer's `free_rid` method.
				To place in a scene, attach this notifier to an instance using `instance_set_base` using the returned RID.
				**Note:** The equivalent node is `VisibleOnScreenNotifier3D`.

### `visibility_notifier_set_aabb(notifier: RID, aabb: AABB) -> void`

Sets the AABB of the specified visibility notifier.

### `visibility_notifier_set_callbacks(notifier: RID, enter_callable: Callable, exit_callable: Callable) -> void`

Sets the methods to be called when the notifier enters or exits the view.

### `voxel_gi_allocate_data(voxel_gi: RID, to_cell_xform: Transform3D, aabb: AABB, octree_size: Vector3i, octree_cells: PackedByteArray, data_cells: PackedByteArray, distance_field: PackedByteArray, level_counts: PackedInt32Array) -> void`

Allocates and initializes the voxel GI data for the specified `voxel_gi` RID. `octree_cells` must be a multiple of 32. `octree_cells` must be double the size of `data_cells`. The allocated data can be retrieved later using the various `voxel_gi_get_*` methods.

### `voxel_gi_create() -> RID`

Creates a new voxel-based global illumination object and adds it to the RenderingServer. It can be accessed with the RID that is returned. This RID will be used in all `voxel_gi_*` RenderingServer functions.
				Once finished with your RID, you will want to free the RID using the RenderingServer's `free_rid` method.
				**Note:** The equivalent node is `VoxelGI`.

### `voxel_gi_get_data_cells(voxel_gi: RID) -> PackedByteArray`
- 限定：qualifiers=const

Returns the data cells for the specified voxel GI data instance. See also `voxel_gi_allocate_data`.

### `voxel_gi_get_distance_field(voxel_gi: RID) -> PackedByteArray`
- 限定：qualifiers=const

Returns the distance field data for the specified voxel GI data instance. See also `voxel_gi_allocate_data`.

### `voxel_gi_get_level_counts(voxel_gi: RID) -> PackedInt32Array`
- 限定：qualifiers=const

Returns the level counts for the specified voxel GI data instance. See also `voxel_gi_allocate_data`.

### `voxel_gi_get_octree_cells(voxel_gi: RID) -> PackedByteArray`
- 限定：qualifiers=const

Returns the octree cell data for the specified voxel GI data instance. See also `voxel_gi_allocate_data`.

### `voxel_gi_get_octree_size(voxel_gi: RID) -> Vector3i`
- 限定：qualifiers=const

Returns the octree size for the specified voxel GI data instance, which corresponds to the number of subdivisions per axis. This can be viewed in the editor by hovering the **Bake VoxelGI** button at the top of the 3D editor viewport when a `VoxelGI` node is selected and looking at the **Subdivisions** field in the tooltip.

### `voxel_gi_get_to_cell_xform(voxel_gi: RID) -> Transform3D`
- 限定：qualifiers=const

Returns the transform to cell space for the specified voxel GI data instance. See also `voxel_gi_allocate_data`.

### `voxel_gi_set_baked_exposure_normalization(voxel_gi: RID, baked_exposure: float) -> void`

Used to inform the renderer what exposure normalization value was used while baking the voxel gi. This value will be used and modulated at run time to ensure that the voxel gi maintains a consistent level of exposure even if the scene-wide exposure normalization is changed at run time. For more information see `camera_attributes_set_exposure`.

### `voxel_gi_set_bias(voxel_gi: RID, bias: float) -> void`

Sets the `VoxelGIData.bias` value to use on the specified `voxel_gi`'s `RID`.

### `voxel_gi_set_dynamic_range(voxel_gi: RID, range: float) -> void`

Sets the `VoxelGIData.dynamic_range` value to use on the specified `voxel_gi`'s `RID`.

### `voxel_gi_set_energy(voxel_gi: RID, energy: float) -> void`

Sets the `VoxelGIData.energy` value to use on the specified `voxel_gi`'s `RID`.

### `voxel_gi_set_interior(voxel_gi: RID, enable: bool) -> void`

Sets the `VoxelGIData.interior` value to use on the specified `voxel_gi`'s `RID`.

### `voxel_gi_set_normal_bias(voxel_gi: RID, bias: float) -> void`

Sets the `VoxelGIData.normal_bias` value to use on the specified `voxel_gi`'s `RID`.

### `voxel_gi_set_propagation(voxel_gi: RID, amount: float) -> void`

Sets the `VoxelGIData.propagation` value to use on the specified `voxel_gi`'s `RID`.

### `voxel_gi_set_quality(quality: int) -> void`

Sets the `ProjectSettings.rendering/global_illumination/voxel_gi/quality` value to use when rendering. This parameter is global and cannot be set on a per-VoxelGI basis.

### `voxel_gi_set_use_two_bounces(voxel_gi: RID, enable: bool) -> void`

Sets the `VoxelGIData.use_two_bounces` value to use on the specified `voxel_gi`'s `RID`.

## 信号

### `frame_post_draw()`

Emitted at the end of the frame, after the RenderingServer has finished updating all the Viewports.

### `frame_pre_draw()`

Emitted at the beginning of the frame, before the RenderingServer updates all the Viewports.

## 枚举

### `TextureType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `TEXTURE_TYPE_2D` |  |
| `1` | `TEXTURE_TYPE_LAYERED` |  |
| `2` | `TEXTURE_TYPE_3D` |  |

### `TextureLayeredType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `TEXTURE_LAYERED_2D_ARRAY` |  |
| `1` | `TEXTURE_LAYERED_CUBEMAP` |  |
| `2` | `TEXTURE_LAYERED_CUBEMAP_ARRAY` |  |

### `CubeMapLayer`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `CUBEMAP_LAYER_LEFT` |  |
| `1` | `CUBEMAP_LAYER_RIGHT` |  |
| `2` | `CUBEMAP_LAYER_BOTTOM` |  |
| `3` | `CUBEMAP_LAYER_TOP` |  |
| `4` | `CUBEMAP_LAYER_FRONT` |  |
| `5` | `CUBEMAP_LAYER_BACK` |  |

### `TextureDrawableFormat`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `TEXTURE_DRAWABLE_FORMAT_RGBA8` |  |
| `1` | `TEXTURE_DRAWABLE_FORMAT_RGBA8_SRGB` |  |
| `2` | `TEXTURE_DRAWABLE_FORMAT_RGBAH` |  |
| `3` | `TEXTURE_DRAWABLE_FORMAT_RGBAF` |  |

### `ShaderMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SHADER_SPATIAL` |  |
| `1` | `SHADER_CANVAS_ITEM` |  |
| `2` | `SHADER_PARTICLES` |  |
| `3` | `SHADER_SKY` |  |
| `4` | `SHADER_FOG` |  |
| `5` | `SHADER_TEXTURE_BLIT` |  |
| `6` | `SHADER_MAX` |  |

### `ArrayType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ARRAY_VERTEX` |  |
| `1` | `ARRAY_NORMAL` |  |
| `2` | `ARRAY_TANGENT` |  |
| `3` | `ARRAY_COLOR` |  |
| `4` | `ARRAY_TEX_UV` |  |
| `5` | `ARRAY_TEX_UV2` |  |
| `6` | `ARRAY_CUSTOM0` |  |
| `7` | `ARRAY_CUSTOM1` |  |
| `8` | `ARRAY_CUSTOM2` |  |
| `9` | `ARRAY_CUSTOM3` |  |
| `10` | `ARRAY_BONES` |  |
| `11` | `ARRAY_WEIGHTS` |  |
| `12` | `ARRAY_INDEX` |  |
| `13` | `ARRAY_MAX` |  |

### `ArrayCustomFormat`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ARRAY_CUSTOM_RGBA8_UNORM` |  |
| `1` | `ARRAY_CUSTOM_RGBA8_SNORM` |  |
| `2` | `ARRAY_CUSTOM_RG_HALF` |  |
| `3` | `ARRAY_CUSTOM_RGBA_HALF` |  |
| `4` | `ARRAY_CUSTOM_R_FLOAT` |  |
| `5` | `ARRAY_CUSTOM_RG_FLOAT` |  |
| `6` | `ARRAY_CUSTOM_RGB_FLOAT` |  |
| `7` | `ARRAY_CUSTOM_RGBA_FLOAT` |  |
| `8` | `ARRAY_CUSTOM_MAX` |  |

### `ArrayFormat`

| 值 | 名称 | 说明 |
|---|---|---|
| `1` | `ARRAY_FORMAT_VERTEX` | （位标志） |
| `2` | `ARRAY_FORMAT_NORMAL` | （位标志） |
| `4` | `ARRAY_FORMAT_TANGENT` | （位标志） |
| `8` | `ARRAY_FORMAT_COLOR` | （位标志） |
| `16` | `ARRAY_FORMAT_TEX_UV` | （位标志） |
| `32` | `ARRAY_FORMAT_TEX_UV2` | （位标志） |
| `64` | `ARRAY_FORMAT_CUSTOM0` | （位标志） |
| `128` | `ARRAY_FORMAT_CUSTOM1` | （位标志） |
| `256` | `ARRAY_FORMAT_CUSTOM2` | （位标志） |
| `512` | `ARRAY_FORMAT_CUSTOM3` | （位标志） |
| `1024` | `ARRAY_FORMAT_BONES` | （位标志） |
| `2048` | `ARRAY_FORMAT_WEIGHTS` | （位标志） |
| `4096` | `ARRAY_FORMAT_INDEX` | （位标志） |
| `7` | `ARRAY_FORMAT_BLEND_SHAPE_MASK` | （位标志） |
| `13` | `ARRAY_FORMAT_CUSTOM_BASE` | （位标志） |
| `3` | `ARRAY_FORMAT_CUSTOM_BITS` | （位标志） |
| `13` | `ARRAY_FORMAT_CUSTOM0_SHIFT` | （位标志） |
| `16` | `ARRAY_FORMAT_CUSTOM1_SHIFT` | （位标志） |
| `19` | `ARRAY_FORMAT_CUSTOM2_SHIFT` | （位标志） |
| `22` | `ARRAY_FORMAT_CUSTOM3_SHIFT` | （位标志） |
| `7` | `ARRAY_FORMAT_CUSTOM_MASK` | （位标志） |
| `25` | `ARRAY_COMPRESS_FLAGS_BASE` | （位标志） |
| `33554432` | `ARRAY_FLAG_USE_2D_VERTICES` | （位标志） |
| `67108864` | `ARRAY_FLAG_USE_DYNAMIC_UPDATE` | （位标志） |
| `134217728` | `ARRAY_FLAG_USE_8_BONE_WEIGHTS` | （位标志） |
| `268435456` | `ARRAY_FLAG_USES_EMPTY_VERTEX_ARRAY` | （位标志） |
| `536870912` | `ARRAY_FLAG_COMPRESS_ATTRIBUTES` | （位标志） |
| `35` | `ARRAY_FLAG_FORMAT_VERSION_BASE` | （位标志） |
| `35` | `ARRAY_FLAG_FORMAT_VERSION_SHIFT` | （位标志） |
| `0` | `ARRAY_FLAG_FORMAT_VERSION_1` | （位标志） |
| `34359738368` | `ARRAY_FLAG_FORMAT_VERSION_2` | （位标志） |
| `34359738368` | `ARRAY_FLAG_FORMAT_CURRENT_VERSION` | （位标志） |
| `255` | `ARRAY_FLAG_FORMAT_VERSION_MASK` | （位标志） |

### `PrimitiveType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `PRIMITIVE_POINTS` |  |
| `1` | `PRIMITIVE_LINES` |  |
| `2` | `PRIMITIVE_LINE_STRIP` |  |
| `3` | `PRIMITIVE_TRIANGLES` |  |
| `4` | `PRIMITIVE_TRIANGLE_STRIP` |  |
| `5` | `PRIMITIVE_MAX` |  |

### `BlendShapeMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `BLEND_SHAPE_MODE_NORMALIZED` |  |
| `1` | `BLEND_SHAPE_MODE_RELATIVE` |  |

### `MultimeshTransformFormat`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `MULTIMESH_TRANSFORM_2D` |  |
| `1` | `MULTIMESH_TRANSFORM_3D` |  |

### `MultimeshPhysicsInterpolationQuality`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `MULTIMESH_INTERP_QUALITY_FAST` |  |
| `1` | `MULTIMESH_INTERP_QUALITY_HIGH` |  |

### `LightProjectorFilter`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `LIGHT_PROJECTOR_FILTER_NEAREST` |  |
| `1` | `LIGHT_PROJECTOR_FILTER_LINEAR` |  |
| `2` | `LIGHT_PROJECTOR_FILTER_NEAREST_MIPMAPS` |  |
| `3` | `LIGHT_PROJECTOR_FILTER_LINEAR_MIPMAPS` |  |
| `4` | `LIGHT_PROJECTOR_FILTER_NEAREST_MIPMAPS_ANISOTROPIC` |  |
| `5` | `LIGHT_PROJECTOR_FILTER_LINEAR_MIPMAPS_ANISOTROPIC` |  |

### `LightType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `LIGHT_DIRECTIONAL` |  |
| `1` | `LIGHT_OMNI` |  |
| `2` | `LIGHT_SPOT` |  |
| `3` | `LIGHT_AREA` |  |

### `LightParam`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `LIGHT_PARAM_ENERGY` |  |
| `1` | `LIGHT_PARAM_INDIRECT_ENERGY` |  |
| `2` | `LIGHT_PARAM_VOLUMETRIC_FOG_ENERGY` |  |
| `3` | `LIGHT_PARAM_SPECULAR` |  |
| `4` | `LIGHT_PARAM_RANGE` |  |
| `5` | `LIGHT_PARAM_SIZE` |  |
| `6` | `LIGHT_PARAM_ATTENUATION` |  |
| `7` | `LIGHT_PARAM_SPOT_ANGLE` |  |
| `8` | `LIGHT_PARAM_SPOT_ATTENUATION` |  |
| `9` | `LIGHT_PARAM_SHADOW_MAX_DISTANCE` |  |
| `10` | `LIGHT_PARAM_SHADOW_SPLIT_1_OFFSET` |  |
| `11` | `LIGHT_PARAM_SHADOW_SPLIT_2_OFFSET` |  |
| `12` | `LIGHT_PARAM_SHADOW_SPLIT_3_OFFSET` |  |
| `13` | `LIGHT_PARAM_SHADOW_FADE_START` |  |
| `14` | `LIGHT_PARAM_SHADOW_NORMAL_BIAS` |  |
| `15` | `LIGHT_PARAM_SHADOW_BIAS` |  |
| `16` | `LIGHT_PARAM_SHADOW_PANCAKE_SIZE` |  |
| `17` | `LIGHT_PARAM_SHADOW_OPACITY` |  |
| `18` | `LIGHT_PARAM_SHADOW_BLUR` |  |
| `19` | `LIGHT_PARAM_TRANSMITTANCE_BIAS` |  |
| `20` | `LIGHT_PARAM_INTENSITY` |  |
| `21` | `LIGHT_PARAM_MAX` |  |

### `LightBakeMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `LIGHT_BAKE_DISABLED` |  |
| `1` | `LIGHT_BAKE_STATIC` |  |
| `2` | `LIGHT_BAKE_DYNAMIC` |  |

### `LightOmniShadowMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `LIGHT_OMNI_SHADOW_DUAL_PARABOLOID` |  |
| `1` | `LIGHT_OMNI_SHADOW_CUBE` |  |

### `LightDirectionalShadowMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `LIGHT_DIRECTIONAL_SHADOW_ORTHOGONAL` |  |
| `1` | `LIGHT_DIRECTIONAL_SHADOW_PARALLEL_2_SPLITS` |  |
| `2` | `LIGHT_DIRECTIONAL_SHADOW_PARALLEL_4_SPLITS` |  |

### `LightDirectionalSkyMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `LIGHT_DIRECTIONAL_SKY_MODE_LIGHT_AND_SKY` |  |
| `1` | `LIGHT_DIRECTIONAL_SKY_MODE_LIGHT_ONLY` |  |
| `2` | `LIGHT_DIRECTIONAL_SKY_MODE_SKY_ONLY` |  |

### `ShadowQuality`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SHADOW_QUALITY_HARD` |  |
| `1` | `SHADOW_QUALITY_SOFT_VERY_LOW` |  |
| `2` | `SHADOW_QUALITY_SOFT_LOW` |  |
| `3` | `SHADOW_QUALITY_SOFT_MEDIUM` |  |
| `4` | `SHADOW_QUALITY_SOFT_HIGH` |  |
| `5` | `SHADOW_QUALITY_SOFT_ULTRA` |  |
| `6` | `SHADOW_QUALITY_MAX` |  |

### `ReflectionProbeUpdateMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `REFLECTION_PROBE_UPDATE_ONCE` |  |
| `1` | `REFLECTION_PROBE_UPDATE_ALWAYS` |  |

### `ReflectionProbeAmbientMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `REFLECTION_PROBE_AMBIENT_DISABLED` |  |
| `1` | `REFLECTION_PROBE_AMBIENT_ENVIRONMENT` |  |
| `2` | `REFLECTION_PROBE_AMBIENT_COLOR` |  |

### `DecalTexture`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `DECAL_TEXTURE_ALBEDO` |  |
| `1` | `DECAL_TEXTURE_NORMAL` |  |
| `2` | `DECAL_TEXTURE_ORM` |  |
| `3` | `DECAL_TEXTURE_EMISSION` |  |
| `4` | `DECAL_TEXTURE_MAX` |  |

### `DecalFilter`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `DECAL_FILTER_NEAREST` |  |
| `1` | `DECAL_FILTER_LINEAR` |  |
| `2` | `DECAL_FILTER_NEAREST_MIPMAPS` |  |
| `3` | `DECAL_FILTER_LINEAR_MIPMAPS` |  |
| `4` | `DECAL_FILTER_NEAREST_MIPMAPS_ANISOTROPIC` |  |
| `5` | `DECAL_FILTER_LINEAR_MIPMAPS_ANISOTROPIC` |  |

### `VoxelGIQuality`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `VOXEL_GI_QUALITY_LOW` |  |
| `1` | `VOXEL_GI_QUALITY_HIGH` |  |

### `ParticlesMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `PARTICLES_MODE_2D` |  |
| `1` | `PARTICLES_MODE_3D` |  |

### `ParticlesTransformAlign`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `PARTICLES_TRANSFORM_ALIGN_DISABLED` |  |
| `1` | `PARTICLES_TRANSFORM_ALIGN_Z_BILLBOARD` |  |
| `2` | `PARTICLES_TRANSFORM_ALIGN_Y_TO_VELOCITY` |  |
| `3` | `PARTICLES_TRANSFORM_ALIGN_Z_BILLBOARD_Y_TO_VELOCITY` |  |
| `4` | `PARTICLES_TRANSFORM_ALIGN_LOCAL_BILLBOARD` |  |

### `ParticlesTransformAlignCustomSrc`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `PARTICLES_ALIGN_CHANNEL_FILTER_DISABLED` |  |
| `1` | `PARTICLES_ALIGN_CHANNEL_FILTER_X` |  |
| `2` | `PARTICLES_ALIGN_CHANNEL_FILTER_Y` |  |
| `3` | `PARTICLES_ALIGN_CHANNEL_FILTER_Z` |  |
| `4` | `PARTICLES_ALIGN_CHANNEL_FILTER_W` |  |

### `ParticlesTransformAlignAxis`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `PARTICLES_ALIGN_AXIS_X` |  |
| `1` | `PARTICLES_ALIGN_AXIS_Y` |  |

### `ParticlesDrawOrder`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `PARTICLES_DRAW_ORDER_INDEX` |  |
| `1` | `PARTICLES_DRAW_ORDER_LIFETIME` |  |
| `2` | `PARTICLES_DRAW_ORDER_REVERSE_LIFETIME` |  |
| `3` | `PARTICLES_DRAW_ORDER_VIEW_DEPTH` |  |

### `ParticlesCollisionType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `PARTICLES_COLLISION_TYPE_SPHERE_ATTRACT` |  |
| `1` | `PARTICLES_COLLISION_TYPE_BOX_ATTRACT` |  |
| `2` | `PARTICLES_COLLISION_TYPE_VECTOR_FIELD_ATTRACT` |  |
| `3` | `PARTICLES_COLLISION_TYPE_SPHERE_COLLIDE` |  |
| `4` | `PARTICLES_COLLISION_TYPE_BOX_COLLIDE` |  |
| `5` | `PARTICLES_COLLISION_TYPE_SDF_COLLIDE` |  |
| `6` | `PARTICLES_COLLISION_TYPE_HEIGHTFIELD_COLLIDE` |  |

### `ParticlesCollisionHeightfieldResolution`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `PARTICLES_COLLISION_HEIGHTFIELD_RESOLUTION_256` |  |
| `1` | `PARTICLES_COLLISION_HEIGHTFIELD_RESOLUTION_512` |  |
| `2` | `PARTICLES_COLLISION_HEIGHTFIELD_RESOLUTION_1024` |  |
| `3` | `PARTICLES_COLLISION_HEIGHTFIELD_RESOLUTION_2048` |  |
| `4` | `PARTICLES_COLLISION_HEIGHTFIELD_RESOLUTION_4096` |  |
| `5` | `PARTICLES_COLLISION_HEIGHTFIELD_RESOLUTION_8192` |  |
| `6` | `PARTICLES_COLLISION_HEIGHTFIELD_RESOLUTION_MAX` |  |

### `FogVolumeShape`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `FOG_VOLUME_SHAPE_ELLIPSOID` |  |
| `1` | `FOG_VOLUME_SHAPE_CONE` |  |
| `2` | `FOG_VOLUME_SHAPE_CYLINDER` |  |
| `3` | `FOG_VOLUME_SHAPE_BOX` |  |
| `4` | `FOG_VOLUME_SHAPE_WORLD` |  |
| `5` | `FOG_VOLUME_SHAPE_MAX` |  |

### `ViewportScaling3DMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `VIEWPORT_SCALING_3D_MODE_BILINEAR` |  |
| `1` | `VIEWPORT_SCALING_3D_MODE_FSR` |  |
| `2` | `VIEWPORT_SCALING_3D_MODE_FSR2` |  |
| `3` | `VIEWPORT_SCALING_3D_MODE_METALFX_SPATIAL` |  |
| `4` | `VIEWPORT_SCALING_3D_MODE_METALFX_TEMPORAL` |  |
| `5` | `VIEWPORT_SCALING_3D_MODE_NEAREST` |  |
| `6` | `VIEWPORT_SCALING_3D_MODE_MAX` |  |

### `ViewportUpdateMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `VIEWPORT_UPDATE_DISABLED` |  |
| `1` | `VIEWPORT_UPDATE_ONCE` |  |
| `2` | `VIEWPORT_UPDATE_WHEN_VISIBLE` |  |
| `3` | `VIEWPORT_UPDATE_WHEN_PARENT_VISIBLE` |  |
| `4` | `VIEWPORT_UPDATE_ALWAYS` |  |

### `ViewportClearMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `VIEWPORT_CLEAR_ALWAYS` |  |
| `1` | `VIEWPORT_CLEAR_NEVER` |  |
| `2` | `VIEWPORT_CLEAR_ONLY_NEXT_FRAME` |  |

### `ViewportEnvironmentMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `VIEWPORT_ENVIRONMENT_DISABLED` |  |
| `1` | `VIEWPORT_ENVIRONMENT_ENABLED` |  |
| `2` | `VIEWPORT_ENVIRONMENT_INHERIT` |  |
| `3` | `VIEWPORT_ENVIRONMENT_MAX` |  |

### `ViewportSDFOversize`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `VIEWPORT_SDF_OVERSIZE_100_PERCENT` |  |
| `1` | `VIEWPORT_SDF_OVERSIZE_120_PERCENT` |  |
| `2` | `VIEWPORT_SDF_OVERSIZE_150_PERCENT` |  |
| `3` | `VIEWPORT_SDF_OVERSIZE_200_PERCENT` |  |
| `4` | `VIEWPORT_SDF_OVERSIZE_MAX` |  |

### `ViewportSDFScale`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `VIEWPORT_SDF_SCALE_100_PERCENT` |  |
| `1` | `VIEWPORT_SDF_SCALE_50_PERCENT` |  |
| `2` | `VIEWPORT_SDF_SCALE_25_PERCENT` |  |
| `3` | `VIEWPORT_SDF_SCALE_MAX` |  |

### `ViewportMSAA`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `VIEWPORT_MSAA_DISABLED` |  |
| `1` | `VIEWPORT_MSAA_2X` |  |
| `2` | `VIEWPORT_MSAA_4X` |  |
| `3` | `VIEWPORT_MSAA_8X` |  |
| `4` | `VIEWPORT_MSAA_MAX` |  |

### `ViewportAnisotropicFiltering`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `VIEWPORT_ANISOTROPY_DISABLED` |  |
| `1` | `VIEWPORT_ANISOTROPY_2X` |  |
| `2` | `VIEWPORT_ANISOTROPY_4X` |  |
| `3` | `VIEWPORT_ANISOTROPY_8X` |  |
| `4` | `VIEWPORT_ANISOTROPY_16X` |  |
| `5` | `VIEWPORT_ANISOTROPY_MAX` |  |

### `ViewportScreenSpaceAA`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `VIEWPORT_SCREEN_SPACE_AA_DISABLED` |  |
| `1` | `VIEWPORT_SCREEN_SPACE_AA_FXAA` |  |
| `2` | `VIEWPORT_SCREEN_SPACE_AA_SMAA` |  |
| `3` | `VIEWPORT_SCREEN_SPACE_AA_MAX` |  |

### `ViewportOcclusionCullingBuildQuality`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `VIEWPORT_OCCLUSION_BUILD_QUALITY_LOW` |  |
| `1` | `VIEWPORT_OCCLUSION_BUILD_QUALITY_MEDIUM` |  |
| `2` | `VIEWPORT_OCCLUSION_BUILD_QUALITY_HIGH` |  |

### `ViewportRenderInfo`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `VIEWPORT_RENDER_INFO_OBJECTS_IN_FRAME` |  |
| `1` | `VIEWPORT_RENDER_INFO_PRIMITIVES_IN_FRAME` |  |
| `2` | `VIEWPORT_RENDER_INFO_DRAW_CALLS_IN_FRAME` |  |
| `3` | `VIEWPORT_RENDER_INFO_MAX` |  |

### `ViewportRenderInfoType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `VIEWPORT_RENDER_INFO_TYPE_VISIBLE` |  |
| `1` | `VIEWPORT_RENDER_INFO_TYPE_SHADOW` |  |
| `2` | `VIEWPORT_RENDER_INFO_TYPE_CANVAS` |  |
| `3` | `VIEWPORT_RENDER_INFO_TYPE_MAX` |  |

### `ViewportDebugDraw`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `VIEWPORT_DEBUG_DRAW_DISABLED` |  |
| `1` | `VIEWPORT_DEBUG_DRAW_UNSHADED` |  |
| `2` | `VIEWPORT_DEBUG_DRAW_LIGHTING` |  |
| `3` | `VIEWPORT_DEBUG_DRAW_OVERDRAW` |  |
| `4` | `VIEWPORT_DEBUG_DRAW_WIREFRAME` |  |
| `5` | `VIEWPORT_DEBUG_DRAW_NORMAL_BUFFER` |  |
| `6` | `VIEWPORT_DEBUG_DRAW_VOXEL_GI_ALBEDO` |  |
| `7` | `VIEWPORT_DEBUG_DRAW_VOXEL_GI_LIGHTING` |  |
| `8` | `VIEWPORT_DEBUG_DRAW_VOXEL_GI_EMISSION` |  |
| `9` | `VIEWPORT_DEBUG_DRAW_SHADOW_ATLAS` |  |
| `10` | `VIEWPORT_DEBUG_DRAW_DIRECTIONAL_SHADOW_ATLAS` |  |
| `11` | `VIEWPORT_DEBUG_DRAW_SCENE_LUMINANCE` |  |
| `12` | `VIEWPORT_DEBUG_DRAW_SSAO` |  |
| `13` | `VIEWPORT_DEBUG_DRAW_SSIL` |  |
| `14` | `VIEWPORT_DEBUG_DRAW_PSSM_SPLITS` |  |
| `15` | `VIEWPORT_DEBUG_DRAW_DECAL_ATLAS` |  |
| `16` | `VIEWPORT_DEBUG_DRAW_SDFGI` |  |
| `17` | `VIEWPORT_DEBUG_DRAW_SDFGI_PROBES` |  |
| `18` | `VIEWPORT_DEBUG_DRAW_GI_BUFFER` |  |
| `19` | `VIEWPORT_DEBUG_DRAW_DISABLE_LOD` |  |
| `20` | `VIEWPORT_DEBUG_DRAW_CLUSTER_OMNI_LIGHTS` |  |
| `21` | `VIEWPORT_DEBUG_DRAW_CLUSTER_SPOT_LIGHTS` |  |
| `22` | `VIEWPORT_DEBUG_DRAW_CLUSTER_DECALS` |  |
| `23` | `VIEWPORT_DEBUG_DRAW_CLUSTER_REFLECTION_PROBES` |  |
| `24` | `VIEWPORT_DEBUG_DRAW_OCCLUDERS` |  |
| `25` | `VIEWPORT_DEBUG_DRAW_MOTION_VECTORS` |  |
| `26` | `VIEWPORT_DEBUG_DRAW_INTERNAL_BUFFER` |  |

### `ViewportVRSMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `VIEWPORT_VRS_DISABLED` |  |
| `1` | `VIEWPORT_VRS_TEXTURE` |  |
| `2` | `VIEWPORT_VRS_XR` |  |
| `3` | `VIEWPORT_VRS_MAX` |  |

### `ViewportVRSUpdateMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `VIEWPORT_VRS_UPDATE_DISABLED` |  |
| `1` | `VIEWPORT_VRS_UPDATE_ONCE` |  |
| `2` | `VIEWPORT_VRS_UPDATE_ALWAYS` |  |
| `3` | `VIEWPORT_VRS_UPDATE_MAX` |  |

### `SkyMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SKY_MODE_AUTOMATIC` |  |
| `1` | `SKY_MODE_QUALITY` |  |
| `2` | `SKY_MODE_INCREMENTAL` |  |
| `3` | `SKY_MODE_REALTIME` |  |

### `CompositorEffectFlags`

| 值 | 名称 | 说明 |
|---|---|---|
| `1` | `COMPOSITOR_EFFECT_FLAG_ACCESS_RESOLVED_COLOR` |  |
| `2` | `COMPOSITOR_EFFECT_FLAG_ACCESS_RESOLVED_DEPTH` |  |
| `4` | `COMPOSITOR_EFFECT_FLAG_NEEDS_MOTION_VECTORS` |  |
| `8` | `COMPOSITOR_EFFECT_FLAG_NEEDS_ROUGHNESS` |  |
| `16` | `COMPOSITOR_EFFECT_FLAG_NEEDS_SEPARATE_SPECULAR` |  |

### `CompositorEffectCallbackType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `COMPOSITOR_EFFECT_CALLBACK_TYPE_PRE_OPAQUE` |  |
| `1` | `COMPOSITOR_EFFECT_CALLBACK_TYPE_POST_OPAQUE` |  |
| `2` | `COMPOSITOR_EFFECT_CALLBACK_TYPE_POST_SKY` |  |
| `3` | `COMPOSITOR_EFFECT_CALLBACK_TYPE_PRE_TRANSPARENT` |  |
| `4` | `COMPOSITOR_EFFECT_CALLBACK_TYPE_POST_TRANSPARENT` |  |
| `-1` | `COMPOSITOR_EFFECT_CALLBACK_TYPE_ANY` |  |

### `EnvironmentBG`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ENV_BG_CLEAR_COLOR` |  |
| `1` | `ENV_BG_COLOR` |  |
| `2` | `ENV_BG_SKY` |  |
| `3` | `ENV_BG_CANVAS` |  |
| `4` | `ENV_BG_KEEP` |  |
| `5` | `ENV_BG_CAMERA_FEED` |  |
| `6` | `ENV_BG_MAX` |  |

### `EnvironmentAmbientSource`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ENV_AMBIENT_SOURCE_BG` |  |
| `1` | `ENV_AMBIENT_SOURCE_DISABLED` |  |
| `2` | `ENV_AMBIENT_SOURCE_COLOR` |  |
| `3` | `ENV_AMBIENT_SOURCE_SKY` |  |

### `EnvironmentReflectionSource`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ENV_REFLECTION_SOURCE_BG` |  |
| `1` | `ENV_REFLECTION_SOURCE_DISABLED` |  |
| `2` | `ENV_REFLECTION_SOURCE_SKY` |  |

### `EnvironmentGlowBlendMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ENV_GLOW_BLEND_MODE_ADDITIVE` |  |
| `1` | `ENV_GLOW_BLEND_MODE_SCREEN` |  |
| `2` | `ENV_GLOW_BLEND_MODE_SOFTLIGHT` |  |
| `3` | `ENV_GLOW_BLEND_MODE_REPLACE` |  |
| `4` | `ENV_GLOW_BLEND_MODE_MIX` |  |

### `EnvironmentFogMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ENV_FOG_MODE_EXPONENTIAL` |  |
| `1` | `ENV_FOG_MODE_DEPTH` |  |

### `EnvironmentToneMapper`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ENV_TONE_MAPPER_LINEAR` |  |
| `1` | `ENV_TONE_MAPPER_REINHARD` |  |
| `2` | `ENV_TONE_MAPPER_FILMIC` |  |
| `3` | `ENV_TONE_MAPPER_ACES` |  |
| `4` | `ENV_TONE_MAPPER_AGX` |  |

### `EnvironmentSSRRoughnessQuality`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ENV_SSR_ROUGHNESS_QUALITY_DISABLED` |  |
| `1` | `ENV_SSR_ROUGHNESS_QUALITY_LOW` |  |
| `2` | `ENV_SSR_ROUGHNESS_QUALITY_MEDIUM` |  |
| `3` | `ENV_SSR_ROUGHNESS_QUALITY_HIGH` |  |

### `EnvironmentSSAOQuality`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ENV_SSAO_QUALITY_VERY_LOW` |  |
| `1` | `ENV_SSAO_QUALITY_LOW` |  |
| `2` | `ENV_SSAO_QUALITY_MEDIUM` |  |
| `3` | `ENV_SSAO_QUALITY_HIGH` |  |
| `4` | `ENV_SSAO_QUALITY_ULTRA` |  |

### `EnvironmentSSILQuality`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ENV_SSIL_QUALITY_VERY_LOW` |  |
| `1` | `ENV_SSIL_QUALITY_LOW` |  |
| `2` | `ENV_SSIL_QUALITY_MEDIUM` |  |
| `3` | `ENV_SSIL_QUALITY_HIGH` |  |
| `4` | `ENV_SSIL_QUALITY_ULTRA` |  |

### `EnvironmentSDFGIYScale`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ENV_SDFGI_Y_SCALE_50_PERCENT` |  |
| `1` | `ENV_SDFGI_Y_SCALE_75_PERCENT` |  |
| `2` | `ENV_SDFGI_Y_SCALE_100_PERCENT` |  |

### `EnvironmentSDFGIRayCount`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ENV_SDFGI_RAY_COUNT_4` |  |
| `1` | `ENV_SDFGI_RAY_COUNT_8` |  |
| `2` | `ENV_SDFGI_RAY_COUNT_16` |  |
| `3` | `ENV_SDFGI_RAY_COUNT_32` |  |
| `4` | `ENV_SDFGI_RAY_COUNT_64` |  |
| `5` | `ENV_SDFGI_RAY_COUNT_96` |  |
| `6` | `ENV_SDFGI_RAY_COUNT_128` |  |
| `7` | `ENV_SDFGI_RAY_COUNT_MAX` |  |

### `EnvironmentSDFGIFramesToConverge`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ENV_SDFGI_CONVERGE_IN_5_FRAMES` |  |
| `1` | `ENV_SDFGI_CONVERGE_IN_10_FRAMES` |  |
| `2` | `ENV_SDFGI_CONVERGE_IN_15_FRAMES` |  |
| `3` | `ENV_SDFGI_CONVERGE_IN_20_FRAMES` |  |
| `4` | `ENV_SDFGI_CONVERGE_IN_25_FRAMES` |  |
| `5` | `ENV_SDFGI_CONVERGE_IN_30_FRAMES` |  |
| `6` | `ENV_SDFGI_CONVERGE_MAX` |  |

### `EnvironmentSDFGIFramesToUpdateLight`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ENV_SDFGI_UPDATE_LIGHT_IN_1_FRAME` |  |
| `1` | `ENV_SDFGI_UPDATE_LIGHT_IN_2_FRAMES` |  |
| `2` | `ENV_SDFGI_UPDATE_LIGHT_IN_4_FRAMES` |  |
| `3` | `ENV_SDFGI_UPDATE_LIGHT_IN_8_FRAMES` |  |
| `4` | `ENV_SDFGI_UPDATE_LIGHT_IN_16_FRAMES` |  |
| `5` | `ENV_SDFGI_UPDATE_LIGHT_MAX` |  |

### `SubSurfaceScatteringQuality`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SUB_SURFACE_SCATTERING_QUALITY_DISABLED` |  |
| `1` | `SUB_SURFACE_SCATTERING_QUALITY_LOW` |  |
| `2` | `SUB_SURFACE_SCATTERING_QUALITY_MEDIUM` |  |
| `3` | `SUB_SURFACE_SCATTERING_QUALITY_HIGH` |  |

### `DOFBokehShape`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `DOF_BOKEH_BOX` |  |
| `1` | `DOF_BOKEH_HEXAGON` |  |
| `2` | `DOF_BOKEH_CIRCLE` |  |

### `DOFBlurQuality`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `DOF_BLUR_QUALITY_VERY_LOW` |  |
| `1` | `DOF_BLUR_QUALITY_LOW` |  |
| `2` | `DOF_BLUR_QUALITY_MEDIUM` |  |
| `3` | `DOF_BLUR_QUALITY_HIGH` |  |

### `InstanceType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `INSTANCE_NONE` |  |
| `1` | `INSTANCE_MESH` |  |
| `2` | `INSTANCE_MULTIMESH` |  |
| `3` | `INSTANCE_PARTICLES` |  |
| `4` | `INSTANCE_PARTICLES_COLLISION` |  |
| `5` | `INSTANCE_LIGHT` |  |
| `6` | `INSTANCE_REFLECTION_PROBE` |  |
| `7` | `INSTANCE_DECAL` |  |
| `8` | `INSTANCE_VOXEL_GI` |  |
| `9` | `INSTANCE_LIGHTMAP` |  |
| `10` | `INSTANCE_OCCLUDER` |  |
| `11` | `INSTANCE_VISIBLITY_NOTIFIER` |  |
| `12` | `INSTANCE_FOG_VOLUME` |  |
| `13` | `INSTANCE_MAX` |  |
| `14` | `INSTANCE_GEOMETRY_MASK` |  |

### `InstanceFlags`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `INSTANCE_FLAG_USE_BAKED_LIGHT` |  |
| `1` | `INSTANCE_FLAG_USE_DYNAMIC_GI` |  |
| `2` | `INSTANCE_FLAG_DRAW_NEXT_FRAME_IF_VISIBLE` |  |
| `3` | `INSTANCE_FLAG_IGNORE_OCCLUSION_CULLING` |  |
| `4` | `INSTANCE_FLAG_MAX` |  |

### `ShadowCastingSetting`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SHADOW_CASTING_SETTING_OFF` |  |
| `1` | `SHADOW_CASTING_SETTING_ON` |  |
| `2` | `SHADOW_CASTING_SETTING_DOUBLE_SIDED` |  |
| `3` | `SHADOW_CASTING_SETTING_SHADOWS_ONLY` |  |

### `VisibilityRangeFadeMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `VISIBILITY_RANGE_FADE_DISABLED` |  |
| `1` | `VISIBILITY_RANGE_FADE_SELF` |  |
| `2` | `VISIBILITY_RANGE_FADE_DEPENDENCIES` |  |

### `BakeChannels`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `BAKE_CHANNEL_ALBEDO_ALPHA` |  |
| `1` | `BAKE_CHANNEL_NORMAL` |  |
| `2` | `BAKE_CHANNEL_ORM` |  |
| `3` | `BAKE_CHANNEL_EMISSION` |  |

### `CanvasTextureChannel`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `CANVAS_TEXTURE_CHANNEL_DIFFUSE` |  |
| `1` | `CANVAS_TEXTURE_CHANNEL_NORMAL` |  |
| `2` | `CANVAS_TEXTURE_CHANNEL_SPECULAR` |  |

### `NinePatchAxisMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `NINE_PATCH_STRETCH` |  |
| `1` | `NINE_PATCH_TILE` |  |
| `2` | `NINE_PATCH_TILE_FIT` |  |

### `CanvasItemTextureFilter`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `CANVAS_ITEM_TEXTURE_FILTER_DEFAULT` |  |
| `1` | `CANVAS_ITEM_TEXTURE_FILTER_NEAREST` |  |
| `2` | `CANVAS_ITEM_TEXTURE_FILTER_LINEAR` |  |
| `3` | `CANVAS_ITEM_TEXTURE_FILTER_NEAREST_WITH_MIPMAPS` |  |
| `4` | `CANVAS_ITEM_TEXTURE_FILTER_LINEAR_WITH_MIPMAPS` |  |
| `5` | `CANVAS_ITEM_TEXTURE_FILTER_NEAREST_WITH_MIPMAPS_ANISOTROPIC` |  |
| `6` | `CANVAS_ITEM_TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC` |  |
| `7` | `CANVAS_ITEM_TEXTURE_FILTER_MAX` |  |

### `CanvasItemTextureRepeat`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `CANVAS_ITEM_TEXTURE_REPEAT_DEFAULT` |  |
| `1` | `CANVAS_ITEM_TEXTURE_REPEAT_DISABLED` |  |
| `2` | `CANVAS_ITEM_TEXTURE_REPEAT_ENABLED` |  |
| `3` | `CANVAS_ITEM_TEXTURE_REPEAT_MIRROR` |  |
| `4` | `CANVAS_ITEM_TEXTURE_REPEAT_MAX` |  |

### `CanvasGroupMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `CANVAS_GROUP_MODE_DISABLED` |  |
| `1` | `CANVAS_GROUP_MODE_CLIP_ONLY` |  |
| `2` | `CANVAS_GROUP_MODE_CLIP_AND_DRAW` |  |
| `3` | `CANVAS_GROUP_MODE_TRANSPARENT` |  |

### `CanvasLightMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `CANVAS_LIGHT_MODE_POINT` |  |
| `1` | `CANVAS_LIGHT_MODE_DIRECTIONAL` |  |

### `CanvasLightBlendMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `CANVAS_LIGHT_BLEND_MODE_ADD` |  |
| `1` | `CANVAS_LIGHT_BLEND_MODE_SUB` |  |
| `2` | `CANVAS_LIGHT_BLEND_MODE_MIX` |  |

### `CanvasLightShadowFilter`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `CANVAS_LIGHT_FILTER_NONE` |  |
| `1` | `CANVAS_LIGHT_FILTER_PCF5` |  |
| `2` | `CANVAS_LIGHT_FILTER_PCF13` |  |
| `3` | `CANVAS_LIGHT_FILTER_MAX` |  |

### `CanvasOccluderPolygonCullMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `CANVAS_OCCLUDER_POLYGON_CULL_DISABLED` |  |
| `1` | `CANVAS_OCCLUDER_POLYGON_CULL_CLOCKWISE` |  |
| `2` | `CANVAS_OCCLUDER_POLYGON_CULL_COUNTER_CLOCKWISE` |  |

### `GlobalShaderParameterType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `GLOBAL_VAR_TYPE_BOOL` |  |
| `1` | `GLOBAL_VAR_TYPE_BVEC2` |  |
| `2` | `GLOBAL_VAR_TYPE_BVEC3` |  |
| `3` | `GLOBAL_VAR_TYPE_BVEC4` |  |
| `4` | `GLOBAL_VAR_TYPE_INT` |  |
| `5` | `GLOBAL_VAR_TYPE_IVEC2` |  |
| `6` | `GLOBAL_VAR_TYPE_IVEC3` |  |
| `7` | `GLOBAL_VAR_TYPE_IVEC4` |  |
| `8` | `GLOBAL_VAR_TYPE_RECT2I` |  |
| `9` | `GLOBAL_VAR_TYPE_UINT` |  |
| `10` | `GLOBAL_VAR_TYPE_UVEC2` |  |
| `11` | `GLOBAL_VAR_TYPE_UVEC3` |  |
| `12` | `GLOBAL_VAR_TYPE_UVEC4` |  |
| `13` | `GLOBAL_VAR_TYPE_FLOAT` |  |
| `14` | `GLOBAL_VAR_TYPE_VEC2` |  |
| `15` | `GLOBAL_VAR_TYPE_VEC3` |  |
| `16` | `GLOBAL_VAR_TYPE_VEC4` |  |
| `17` | `GLOBAL_VAR_TYPE_COLOR` |  |
| `18` | `GLOBAL_VAR_TYPE_RECT2` |  |
| `19` | `GLOBAL_VAR_TYPE_MAT2` |  |
| `20` | `GLOBAL_VAR_TYPE_MAT3` |  |
| `21` | `GLOBAL_VAR_TYPE_MAT4` |  |
| `22` | `GLOBAL_VAR_TYPE_TRANSFORM_2D` |  |
| `23` | `GLOBAL_VAR_TYPE_TRANSFORM` |  |
| `24` | `GLOBAL_VAR_TYPE_SAMPLER2D` |  |
| `25` | `GLOBAL_VAR_TYPE_SAMPLER2DARRAY` |  |
| `26` | `GLOBAL_VAR_TYPE_SAMPLER3D` |  |
| `27` | `GLOBAL_VAR_TYPE_SAMPLERCUBE` |  |
| `28` | `GLOBAL_VAR_TYPE_SAMPLEREXT` |  |
| `29` | `GLOBAL_VAR_TYPE_MAX` |  |

### `RenderingInfo`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `RENDERING_INFO_TOTAL_OBJECTS_IN_FRAME` |  |
| `1` | `RENDERING_INFO_TOTAL_PRIMITIVES_IN_FRAME` |  |
| `2` | `RENDERING_INFO_TOTAL_DRAW_CALLS_IN_FRAME` |  |
| `3` | `RENDERING_INFO_TEXTURE_MEM_USED` |  |
| `4` | `RENDERING_INFO_BUFFER_MEM_USED` |  |
| `5` | `RENDERING_INFO_VIDEO_MEM_USED` |  |
| `6` | `RENDERING_INFO_PIPELINE_COMPILATIONS_CANVAS` |  |
| `7` | `RENDERING_INFO_PIPELINE_COMPILATIONS_MESH` |  |
| `8` | `RENDERING_INFO_PIPELINE_COMPILATIONS_SURFACE` |  |
| `9` | `RENDERING_INFO_PIPELINE_COMPILATIONS_DRAW` |  |
| `10` | `RENDERING_INFO_PIPELINE_COMPILATIONS_SPECIALIZATION` |  |

### `PipelineSource`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `PIPELINE_SOURCE_CANVAS` |  |
| `1` | `PIPELINE_SOURCE_MESH` |  |
| `2` | `PIPELINE_SOURCE_SURFACE` |  |
| `3` | `PIPELINE_SOURCE_DRAW` |  |
| `4` | `PIPELINE_SOURCE_SPECIALIZATION` |  |
| `5` | `PIPELINE_SOURCE_MAX` |  |

### `SplashStretchMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SPLASH_STRETCH_MODE_DISABLED` |  |
| `1` | `SPLASH_STRETCH_MODE_KEEP` |  |
| `2` | `SPLASH_STRETCH_MODE_KEEP_WIDTH` |  |
| `3` | `SPLASH_STRETCH_MODE_KEEP_HEIGHT` |  |
| `4` | `SPLASH_STRETCH_MODE_COVER` |  |
| `5` | `SPLASH_STRETCH_MODE_IGNORE` |  |

### `Features`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `FEATURE_SHADERS` |  |
| `1` | `FEATURE_MULTITHREADED` |  |

## 常量

- **`NO_INDEX_ARRAY`** = `-1`
- **`ARRAY_WEIGHTS_SIZE`** = `4`
- **`CANVAS_ITEM_Z_MIN`** = `-4096`
- **`CANVAS_ITEM_Z_MAX`** = `4096`
- **`CANVAS_LAYER_MIN`** = `-2147483648`
- **`CANVAS_LAYER_MAX`** = `2147483647`
- **`MAX_GLOW_LEVELS`** = `7`
- **`MAX_CURSORS`** = `8`
- **`MAX_2D_DIRECTIONAL_LIGHTS`** = `8`
- **`MAX_MESH_SURFACES`** = `256`
- **`MATERIAL_RENDER_PRIORITY_MIN`** = `-128`
- **`MATERIAL_RENDER_PRIORITY_MAX`** = `127`
- **`ARRAY_CUSTOM_COUNT`** = `4`
- **`PARTICLES_EMIT_FLAG_POSITION`** = `1`
- **`PARTICLES_EMIT_FLAG_ROTATION_SCALE`** = `2`
- **`PARTICLES_EMIT_FLAG_VELOCITY`** = `4`
- **`PARTICLES_EMIT_FLAG_COLOR`** = `8`
- **`PARTICLES_EMIT_FLAG_CUSTOM`** = `16`
## 教程链接

- [Optimization using Servers](None)

