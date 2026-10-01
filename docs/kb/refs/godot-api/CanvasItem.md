# CanvasItem

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/CanvasItem.md`

**摘要**：Abstract base class for everything in 2D space.

## 描述

Abstract base class for everything in 2D space. Canvas items are laid out in a tree; children inherit and extend their parent's transform. `CanvasItem` is extended by `Control` for GUI-related nodes, and by `Node2D` for 2D game objects.
		Any `CanvasItem` can draw. For this, `queue_redraw` is called by the engine, then `NOTIFICATION_DRAW` will be received on idle time to request a redraw. Because of this, canvas items don't need to be redrawn on every frame, improving the performance significantly. Several functions for drawing on the `CanvasItem` are provided (see `draw_*` functions). However, they can only be used inside `_draw`, its corresponding `Object._notification` or methods connected to the `draw` signal.
		Canvas items are drawn in tree order on their canvas layer. By default, children are on top of their parents, so a root `CanvasItem` will be drawn behind everything. This behavior can be changed on a per-item basis.
		A `CanvasItem` can be hidden, which will also hide its children. By adjusting various other properties of a `CanvasItem`, you can also modulate its color (via `modulate` or `self_modulate`), change its Z-index, blend mode, and more.
		Note that properties like transform, modulation, and visibility are only propagated to *direct* `CanvasItem` child nodes. If there is a non-`CanvasItem` node in between, like `Node` or `AnimationPlayer`, the `CanvasItem` nodes below will have an independent position and `modulate` chain. See also `top_level`.

## 属性

- **`clip_children`** `int` = `0` · 枚举 `CanvasItem.ClipChildrenMode`
  - 其它属性：getter=get_clip_children_mode · setter=set_clip_children_mode
- **`light_mask`** `int` = `1`
  - 其它属性：getter=get_light_mask · setter=set_light_mask
- **`material`** `Material`
  - 其它属性：getter=get_material · setter=set_material
- **`modulate`** `Color` = `Color(1, 1, 1, 1)`
  - 其它属性：getter=get_modulate · keywords=color, colour · setter=set_modulate
- **`oversampling_with_scale`** `int` = `0` · 枚举 `CanvasItem.OversamplingWithScale`
  - 其它属性：getter=get_oversampling_with_scale · setter=set_oversampling_with_scale
- **`self_modulate`** `Color` = `Color(1, 1, 1, 1)`
  - 其它属性：getter=get_self_modulate · setter=set_self_modulate
- **`show_behind_parent`** `bool` = `false`
  - 其它属性：getter=is_draw_behind_parent_enabled · setter=set_draw_behind_parent
- **`texture_filter`** `int` = `0` · 枚举 `CanvasItem.TextureFilter`
  - 其它属性：getter=get_texture_filter · setter=set_texture_filter
- **`texture_repeat`** `int` = `0` · 枚举 `CanvasItem.TextureRepeat`
  - 其它属性：getter=get_texture_repeat · setter=set_texture_repeat
- **`top_level`** `bool` = `false`
  - 其它属性：getter=is_set_as_top_level · setter=set_as_top_level
- **`use_parent_material`** `bool` = `false`
  - 其它属性：getter=get_use_parent_material · setter=set_use_parent_material
- **`visibility_layer`** `int` = `1`
  - 其它属性：getter=get_visibility_layer · setter=set_visibility_layer
- **`visible`** `bool` = `true`
  - 其它属性：getter=is_visible · setter=set_visible
- **`y_sort_enabled`** `bool` = `false`
  - 其它属性：getter=is_y_sort_enabled · setter=set_y_sort_enabled
- **`z_as_relative`** `bool` = `true`
  - 其它属性：getter=is_z_relative · setter=set_z_as_relative
- **`z_index`** `int` = `0`
  - 其它属性：getter=get_z_index · setter=set_z_index

## 方法

### `_draw() -> void`
- 限定：qualifiers=virtual

Called when `CanvasItem` has been requested to redraw (after `queue_redraw` is called, either manually or by the engine).
				Corresponds to the `NOTIFICATION_DRAW` notification in `Object._notification`.

### `draw_animation_slice(animation_length: float, slice_begin: float, slice_end: float, offset: float = 0.0) -> void`

Subsequent drawing commands will be ignored unless they fall within the specified animation slice. This is a faster way to implement animations that loop on background rather than redrawing constantly.

### `draw_arc(center: Vector2, radius: float, start_angle: float, end_angle: float, point_count: int, color: Color, width: float = -1.0, antialiased: bool = false) -> void`

Draws an unfilled arc between the given angles with a uniform `color` and `width` and optional antialiasing (supported only for positive `width`). The larger the value of `point_count`, the smoother the curve. `center` is defined in local space. For elliptical arcs, see `draw_ellipse_arc`. See also `draw_circle`.
				If `width` is negative, it will be ignored and the arc will be drawn using `RenderingServer.PRIMITIVE_LINE_STRIP`. This means that when the CanvasItem is scaled, the arc will remain thin. If this behavior is not desired, then pass a positive `width` like `1.0`.
				The arc is drawn from `start_angle` towards the value of `end_angle` so in clockwise direction if `start_angle < end_angle` and counter-clockwise otherwise. Passing the same angles but in reversed order will produce the same arc. If absolute difference of `start_angle` and `end_angle` is greater than `@GDScript.TAU` radians, then a full circle arc is drawn (i.e. arc will not overlap itself).

### `draw_char(font: Font, pos: Vector2, char: String, font_size: int = 16, modulate: Color = Color(1, 1, 1, 1), oversampling: float = 0.0) -> void`
- 限定：qualifiers=const

Draws a string first character using a custom font. If `oversampling` is greater than zero, it is used as font oversampling factor, otherwise viewport oversampling settings are used. `pos` is defined in local space.

### `draw_char_outline(font: Font, pos: Vector2, char: String, font_size: int = 16, size: int = -1, modulate: Color = Color(1, 1, 1, 1), oversampling: float = 0.0) -> void`
- 限定：qualifiers=const

Draws a string first character outline using a custom font. If `oversampling` is greater than zero, it is used as font oversampling factor, otherwise viewport oversampling settings are used. `pos` is defined in local space.

### `draw_circle(position: Vector2, radius: float, color: Color, filled: bool = true, width: float = -1.0, antialiased: bool = false) -> void`

Draws a circle, with `position` defined in local space. See also `draw_ellipse`, `draw_arc`, `draw_polyline`, and `draw_polygon`.
				If `filled` is `true`, the circle will be filled with the `color` specified. If `filled` is `false`, the circle will be drawn as a stroke with the `color` and `width` specified.
				If `width` is negative, then two-point primitives will be drawn instead of a four-point ones. This means that when the CanvasItem is scaled, the lines will remain thin. If this behavior is not desired, then pass a positive `width` like `1.0`.
				If `antialiased` is `true`, half transparent "feathers" will be attached to the boundary, making outlines smooth.
				**Note:** `width` is only effective if `filled` is `false`.

### `draw_colored_polygon(points: PackedVector2Array, color: Color, uvs: PackedVector2Array = PackedVector2Array(), texture: Texture2D = null) -> void`

Draws a colored polygon of any number of points, convex or concave. The points in the `points` array are defined in local space. Unlike `draw_polygon`, a single color must be specified for the whole polygon.
				**Note:** If you frequently redraw the same polygon with a large number of vertices, consider pre-calculating the triangulation with `Geometry2D.triangulate_polygon` and using `draw_mesh`, `draw_multimesh`, or `RenderingServer.canvas_item_add_triangle_array`.
				**Note:** Styleboxes, textures, and meshes stored only inside local variables should **not** be used with this method in GDScript, because the drawing operation doesn't begin immediately once this method is called. In GDScript, when the function with the local variables ends, the local variables get destroyed before the rendering takes place.

### `draw_dashed_line(from: Vector2, to: Vector2, color: Color, width: float = -1.0, dash: float = 2.0, aligned: bool = true, antialiased: bool = false) -> void`

Draws a dashed line from a 2D point to another, with a given color and width. The `from` and `to` positions are defined in local space. See also `draw_line`, `draw_multiline`, and `draw_polyline`.
				If `width` is negative, then a two-point primitives will be drawn instead of a four-point ones. This means that when the CanvasItem is scaled, the line parts will remain thin. If this behavior is not desired, then pass a positive `width` like `1.0`.
				`dash` is the length of each dash in pixels, with the gap between each dash being the same length. If `aligned` is `true`, the length of the first and last dashes may be shortened or lengthened to allow the line to begin and end at the precise points defined by `from` and `to`. Both ends are always symmetrical when `aligned` is `true`. If `aligned` is `false`, all dashes will have the same length, but the line may appear incomplete at the end due to the dash length not dividing evenly into the line length. Only full dashes are drawn when `aligned` is `false`.
				If `antialiased` is `true`, half transparent "feathers" will be attached to the boundary, making outlines smooth.
				**Note:** `antialiased` is only effective if `width` is greater than `0.0`.

### `draw_ellipse(position: Vector2, major: float, minor: float, color: Color, filled: bool = true, width: float = -1.0, antialiased: bool = false) -> void`

Draws an ellipse with semi-major axis `major` and semi-minor axis `minor`. See also `draw_circle`, `draw_ellipse_arc`, `draw_polyline`, and `draw_polygon`.
				If `filled` is `true`, the ellipse will be filled with the `color` specified. If `filled` is `false`, the ellipse will be drawn as a stroke with the `color` and `width` specified.
				If `width` is negative, then two-point primitives will be drawn instead of four-point ones. This means that when the CanvasItem is scaled, the lines will remain thin. If this behavior is not desired, then pass a positive `width` like `1.0`.
				If `antialiased` is `true`, half transparent "feathers" will be attached to the boundary, making outlines smooth.
				**Note:** `width` is only effective if `filled` is `false`.

### `draw_ellipse_arc(center: Vector2, major: float, minor: float, start_angle: float, end_angle: float, point_count: int, color: Color, width: float = -1.0, antialiased: bool = false) -> void`

Draws an unfilled elliptical arc between the given angles with a uniform `color` and `width` and optional antialiasing (supported only for positive `width`). The larger the value of `point_count`, the smoother the curve. For circular arcs, see `draw_arc`. See also `draw_ellipse`.
				If `width` is negative, it will be ignored and the arc will be drawn using `RenderingServer.PRIMITIVE_LINE_STRIP`. This means that when the CanvasItem is scaled, the arc will remain thin. If this behavior is not desired, then pass a positive `width` like `1.0`.
				The arc is drawn from `start_angle` towards the value of `end_angle` so in clockwise direction if `start_angle < end_angle` and counter-clockwise otherwise. Passing the same angles but in reversed order will produce the same arc. If absolute difference of `start_angle` and `end_angle` is greater than `@GDScript.TAU` radians, then a full ellipse is drawn (i.e. arc will not overlap itself).

### `draw_end_animation() -> void`

After submitting all animations slices via `draw_animation_slice`, this function can be used to revert drawing to its default state (all subsequent drawing commands will be visible). If you don't care about this particular use case, usage of this function after submitting the slices is not required.

### `draw_lcd_texture_rect_region(texture: Texture2D, rect: Rect2, src_rect: Rect2, modulate: Color = Color(1, 1, 1, 1)) -> void`

Draws a textured rectangle region of the font texture with LCD subpixel anti-aliasing at a given position, optionally modulated by a color. The `rect` is defined in local space.
				Texture is drawn using the following blend operation, blend mode of the `CanvasItemMaterial` is ignored:
				
```gdscript
				dst.r = texture.r * modulate.r * modulate.a + dst.r * (1.0 - texture.r * modulate.a);
				dst.g = texture.g * modulate.g * modulate.a + dst.g * (1.0 - texture.g * modulate.a);
				dst.b = texture.b * modulate.b * modulate.a + dst.b * (1.0 - texture.b * modulate.a);
				dst.a = modulate.a + dst.a * (1.0 - modulate.a);
				
```

				**Note:** Styleboxes, textures, and meshes stored only inside local variables should **not** be used with this method in GDScript, because the drawing operation doesn't begin immediately once this method is called. In GDScript, when the function with the local variables ends, the local variables get destroyed before the rendering takes place.

### `draw_line(from: Vector2, to: Vector2, color: Color, width: float = -1.0, antialiased: bool = false) -> void`

Draws a line from a 2D point to another, with a given color and width. It can be optionally antialiased. The `from` and `to` positions are defined in local space. See also `draw_dashed_line`, `draw_multiline`, and `draw_polyline`.
				If `width` is negative, then a two-point primitive will be drawn instead of a four-point one. This means that when the CanvasItem is scaled, the line will remain thin. If this behavior is not desired, then pass a positive `width` like `1.0`.

### `draw_mesh(mesh: Mesh, texture: Texture2D, transform: Transform2D = Transform2D(1, 0, 0, 1, 0, 0), modulate: Color = Color(1, 1, 1, 1)) -> void`

Draws a `Mesh` in 2D, using the provided texture. See `MeshInstance2D` for related documentation. The `transform` is defined in local space.
				**Note:** Styleboxes, textures, and meshes stored only inside local variables should **not** be used with this method in GDScript, because the drawing operation doesn't begin immediately once this method is called. In GDScript, when the function with the local variables ends, the local variables get destroyed before the rendering takes place.

### `draw_msdf_texture_rect_region(texture: Texture2D, rect: Rect2, src_rect: Rect2, modulate: Color = Color(1, 1, 1, 1), outline: float = 0.0, pixel_range: float = 4.0, scale: float = 1.0) -> void`

Draws a textured rectangle region of the multichannel signed distance field texture at a given position, optionally modulated by a color. The `rect` is defined in local space. See `FontFile.multichannel_signed_distance_field` for more information and caveats about MSDF font rendering.
				If `outline` is positive, each alpha channel value of pixel in region is set to maximum value of true distance in the `outline` radius.
				Value of the `pixel_range` should the same that was used during distance field texture generation.
				**Note:** Styleboxes, textures, and meshes stored only inside local variables should **not** be used with this method in GDScript, because the drawing operation doesn't begin immediately once this method is called. In GDScript, when the function with the local variables ends, the local variables get destroyed before the rendering takes place.

### `draw_multiline(points: PackedVector2Array, color: Color, width: float = -1.0, antialiased: bool = false) -> void`

Draws multiple disconnected lines with a uniform `width` and `color`. Each line is defined by two consecutive points from `points` array in local space, i.e. i-th segment consists of `points[2 * i]`, `points[2 * i + 1]` endpoints. When drawing large amounts of lines, this is faster than using individual `draw_line` calls. To draw interconnected lines, use `draw_polyline` instead.
				If `width` is negative, then two-point primitives will be drawn instead of a four-point ones. This means that when the CanvasItem is scaled, the lines will remain thin. If this behavior is not desired, then pass a positive `width` like `1.0`.
				**Note:** `antialiased` is only effective if `width` is greater than `0.0`.

### `draw_multiline_colors(points: PackedVector2Array, colors: PackedColorArray, width: float = -1.0, antialiased: bool = false) -> void`

Draws multiple disconnected lines with a uniform `width` and segment-by-segment coloring. Each segment is defined by two consecutive points from `points` array in local space and a corresponding color from `colors` array, i.e. i-th segment consists of `points[2 * i]`, `points[2 * i + 1]` endpoints and has `colors`i`` color. When drawing large amounts of lines, this is faster than using individual `draw_line` calls. To draw interconnected lines, use `draw_polyline_colors` instead.
				If `width` is negative, then two-point primitives will be drawn instead of a four-point ones. This means that when the CanvasItem is scaled, the lines will remain thin. If this behavior is not desired, then pass a positive `width` like `1.0`.
				**Note:** `antialiased` is only effective if `width` is greater than `0.0`.

### `draw_multiline_string(font: Font, pos: Vector2, text: String, alignment: int = 0, width: float = -1, font_size: int = 16, max_lines: int = -1, modulate: Color = Color(1, 1, 1, 1), brk_flags: int = 3, justification_flags: int = 3, direction: int = 0, orientation: int = 0, oversampling: float = 0.0) -> void`
- 限定：qualifiers=const

Breaks `text` into lines and draws it using the specified `font` at the `pos` in local space (top-left corner). The text will have its color multiplied by `modulate`. If `width` is greater than or equal to 0, the text will be clipped if it exceeds the specified width. If `oversampling` is greater than zero, it is used as font oversampling factor, otherwise viewport oversampling settings are used.

### `draw_multiline_string_outline(font: Font, pos: Vector2, text: String, alignment: int = 0, width: float = -1, font_size: int = 16, max_lines: int = -1, size: int = 1, modulate: Color = Color(1, 1, 1, 1), brk_flags: int = 3, justification_flags: int = 3, direction: int = 0, orientation: int = 0, oversampling: float = 0.0) -> void`
- 限定：qualifiers=const

Breaks `text` to the lines and draws text outline using the specified `font` at the `pos` in local space (top-left corner). The text will have its color multiplied by `modulate`. If `width` is greater than or equal to 0, the text will be clipped if it exceeds the specified width. If `oversampling` is greater than zero, it is used as font oversampling factor, otherwise viewport oversampling settings are used.

### `draw_multimesh(multimesh: MultiMesh, texture: Texture2D) -> void`

Draws a `MultiMesh` in 2D with the provided texture. See `MultiMeshInstance2D` for related documentation.
				**Note:** Styleboxes, textures, and meshes stored only inside local variables should **not** be used with this method in GDScript, because the drawing operation doesn't begin immediately once this method is called. In GDScript, when the function with the local variables ends, the local variables get destroyed before the rendering takes place.

### `draw_polygon(points: PackedVector2Array, colors: PackedColorArray, uvs: PackedVector2Array = PackedVector2Array(), texture: Texture2D = null) -> void`

Draws a solid polygon of any number of points, convex or concave. Unlike `draw_colored_polygon`, each point's color can be changed individually. The `points` array is defined in local space. See also `draw_polyline` and `draw_polyline_colors`. If you need more flexibility (such as being able to use bones), use `RenderingServer.canvas_item_add_triangle_array` instead.
				**Note:** If you frequently redraw the same polygon with a large number of vertices, consider pre-calculating the triangulation with `Geometry2D.triangulate_polygon` and using `draw_mesh`, `draw_multimesh`, or `RenderingServer.canvas_item_add_triangle_array`.
				**Note:** Styleboxes, textures, and meshes stored only inside local variables should **not** be used with this method in GDScript, because the drawing operation doesn't begin immediately once this method is called. In GDScript, when the function with the local variables ends, the local variables get destroyed before the rendering takes place.

### `draw_polyline(points: PackedVector2Array, color: Color, width: float = -1.0, antialiased: bool = false) -> void`

Draws interconnected line segments with a uniform `color` and `width` and optional antialiasing (supported only for positive `width`). The `points` array is defined in local space. When drawing large amounts of lines, this is faster than using individual `draw_line` calls. To draw disconnected lines, use `draw_multiline` instead. See also `draw_polygon`.
				If `width` is negative, it will be ignored and the polyline will be drawn using `RenderingServer.PRIMITIVE_LINE_STRIP`. This means that when the CanvasItem is scaled, the polyline will remain thin. If this behavior is not desired, then pass a positive `width` like `1.0`.

### `draw_polyline_colors(points: PackedVector2Array, colors: PackedColorArray, width: float = -1.0, antialiased: bool = false) -> void`

Draws interconnected line segments with a uniform `width`, point-by-point coloring, and optional antialiasing (supported only for positive `width`). Colors assigned to line points match by index between `points` and `colors`, i.e. each line segment is filled with a gradient between the colors of the endpoints. The `points` array is defined in local space. When drawing large amounts of lines, this is faster than using individual `draw_line` calls. To draw disconnected lines, use `draw_multiline_colors` instead. See also `draw_polygon`.
				If `width` is negative, it will be ignored and the polyline will be drawn using `RenderingServer.PRIMITIVE_LINE_STRIP`. This means that when the CanvasItem is scaled, the polyline will remain thin. If this behavior is not desired, then pass a positive `width` like `1.0`.

### `draw_primitive(points: PackedVector2Array, colors: PackedColorArray, uvs: PackedVector2Array, texture: Texture2D = null) -> void`

Draws a custom primitive. 1 point for a point, 2 points for a line, 3 points for a triangle, and 4 points for a quad. If 0 points or more than 4 points are specified, nothing will be drawn and an error message will be printed. The `points` array is defined in local space. See also `draw_line`, `draw_polyline`, `draw_polygon`, and `draw_rect`.
				**Note:** Styleboxes, textures, and meshes stored only inside local variables should **not** be used with this method in GDScript, because the drawing operation doesn't begin immediately once this method is called. In GDScript, when the function with the local variables ends, the local variables get destroyed before the rendering takes place.

### `draw_rect(rect: Rect2, color: Color, filled: bool = true, width: float = -1.0, antialiased: bool = false) -> void`

Draws a rectangle. If `filled` is `true`, the rectangle will be filled with the `color` specified. If `filled` is `false`, the rectangle will be drawn as a stroke with the `color` and `width` specified. The `rect` is specified in local space. See also `draw_texture_rect`.
				If `width` is negative, then two-point primitives will be drawn instead of a four-point ones. This means that when the CanvasItem is scaled, the lines will remain thin. If this behavior is not desired, then pass a positive `width` like `1.0`.
				If `antialiased` is `true`, half transparent "feathers" will be attached to the boundary, making outlines smooth.
				**Note:** `width` is only effective if `filled` is `false`.
				**Note:** Unfilled rectangles drawn with a negative `width` may not display perfectly. For example, corners may be missing or brighter due to overlapping lines (for a translucent `color`).

### `draw_set_transform(position: Vector2, rotation: float = 0.0, scale: Vector2 = Vector2(1, 1)) -> void`

Sets a custom local transform for drawing via components. Anything drawn afterwards will be transformed by this.
				**Note:** `FontFile.oversampling` does *not* take `scale` into account. This means that scaling up/down will cause bitmap fonts and rasterized (non-MSDF) dynamic fonts to appear blurry or pixelated. To ensure text remains crisp regardless of scale, you can enable MSDF font rendering by enabling `ProjectSettings.gui/theme/default_font_multichannel_signed_distance_field` (applies to the default project font only), or enabling **Multichannel Signed Distance Field** in the import options of a DynamicFont for custom fonts. On system fonts, `SystemFont.multichannel_signed_distance_field` can be enabled in the inspector.

### `draw_set_transform_matrix(xform: Transform2D) -> void`

Sets a custom local transform for drawing via matrix. Anything drawn afterwards will be transformed by this.

### `draw_string(font: Font, pos: Vector2, text: String, alignment: int = 0, width: float = -1, font_size: int = 16, modulate: Color = Color(1, 1, 1, 1), justification_flags: int = 3, direction: int = 0, orientation: int = 0, oversampling: float = 0.0) -> void`
- 限定：qualifiers=const

Draws `text` using the specified `font` at the `pos` in local space (bottom-left corner using the baseline of the font). The text will have its color multiplied by `modulate`. If `width` is greater than or equal to 0, the text will be clipped if it exceeds the specified width. If `oversampling` is greater than zero, it is used as font oversampling factor, otherwise viewport oversampling settings are used.
				**Example:** Draw "Hello world", using the project's default font:
				`codeblocks`
				`gdscript`
				draw_string(ThemeDB.fallback_font, Vector2(64, 64), "Hello world", HORIZONTAL_ALIGNMENT_LEFT, -1, ThemeDB.fallback_font_size)
				
				`csharp`
				DrawString(ThemeDB.FallbackFont, new Vector2(64, 64), "Hello world", HorizontalAlignment.Left, -1, ThemeDB.FallbackFontSize);
				
				
				See also `Font.draw_string`.

### `draw_string_outline(font: Font, pos: Vector2, text: String, alignment: int = 0, width: float = -1, font_size: int = 16, size: int = 1, modulate: Color = Color(1, 1, 1, 1), justification_flags: int = 3, direction: int = 0, orientation: int = 0, oversampling: float = 0.0) -> void`
- 限定：qualifiers=const

Draws `text` outline using the specified `font` at the `pos` in local space (bottom-left corner using the baseline of the font). The text will have its color multiplied by `modulate`. If `width` is greater than or equal to 0, the text will be clipped if it exceeds the specified width. If `oversampling` is greater than zero, it is used as font oversampling factor, otherwise viewport oversampling settings are used.

### `draw_style_box(style_box: StyleBox, rect: Rect2) -> void`

Draws a styled rectangle. The `rect` is defined in local space.
				**Note:** Styleboxes, textures, and meshes stored only inside local variables should **not** be used with this method in GDScript, because the drawing operation doesn't begin immediately once this method is called. In GDScript, when the function with the local variables ends, the local variables get destroyed before the rendering takes place.

### `draw_texture(texture: Texture2D, position: Vector2, modulate: Color = Color(1, 1, 1, 1)) -> void`

Draws a texture at a given position. The `position` is defined in local space.
				**Note:** Styleboxes, textures, and meshes stored only inside local variables should **not** be used with this method in GDScript, because the drawing operation doesn't begin immediately once this method is called. In GDScript, when the function with the local variables ends, the local variables get destroyed before the rendering takes place.

### `draw_texture_rect(texture: Texture2D, rect: Rect2, tile: bool, modulate: Color = Color(1, 1, 1, 1), transpose: bool = false) -> void`

Draws a textured rectangle at a given position, optionally modulated by a color. The `rect` is defined in local space. If `transpose` is `true`, the texture will have its X and Y coordinates swapped. See also `draw_rect` and `draw_texture_rect_region`.
				**Note:** Styleboxes, textures, and meshes stored only inside local variables should **not** be used with this method in GDScript, because the drawing operation doesn't begin immediately once this method is called. In GDScript, when the function with the local variables ends, the local variables get destroyed before the rendering takes place.

### `draw_texture_rect_region(texture: Texture2D, rect: Rect2, src_rect: Rect2, modulate: Color = Color(1, 1, 1, 1), transpose: bool = false, clip_uv: bool = true) -> void`

Draws a textured rectangle from a texture's region (specified by `src_rect`) at a given position in local space, optionally modulated by a color. If `transpose` is `true`, the texture will have its X and Y coordinates swapped. See also `draw_texture_rect`.
				**Note:** Styleboxes, textures, and meshes stored only inside local variables should **not** be used with this method in GDScript, because the drawing operation doesn't begin immediately once this method is called. In GDScript, when the function with the local variables ends, the local variables get destroyed before the rendering takes place.

### `force_update_transform() -> void`

Forces the node's transform to update. Fails if the node is not inside the tree. See also `get_transform`.
				**Note:** For performance reasons, transform changes are usually accumulated and applied *once* at the end of the frame. The update propagates through `CanvasItem` children, as well. Therefore, use this method only when you need an up-to-date transform (such as during physics operations).

### `get_canvas() -> RID`
- 限定：qualifiers=const

Returns the `RID` of the `World2D` canvas where this node is registered to, used by the `RenderingServer`.

### `get_canvas_item() -> RID`
- 限定：qualifiers=const

Returns the internal canvas item `RID` used by the `RenderingServer` for this node.

### `get_canvas_layer_node() -> CanvasLayer`
- 限定：qualifiers=const

Returns the `CanvasLayer` that contains this node, or `null` if the node is not in any `CanvasLayer`.

### `get_canvas_transform() -> Transform2D`
- 限定：qualifiers=const

Returns the transform of this node, converted from its registered canvas's coordinate system to its viewport's coordinate system. See also `Node.get_viewport`.

### `get_global_mouse_position() -> Vector2`
- 限定：qualifiers=const

Returns mouse cursor's global position relative to the `CanvasLayer` that contains this node.
				**Note:** For screen-space coordinates (e.g. when using a non-embedded `Popup`), you can use `DisplayServer.mouse_get_position`.

### `get_global_transform() -> Transform2D`
- 限定：qualifiers=const

Returns the global transform matrix of this item, i.e. the combined transform up to the topmost `CanvasItem` node. The topmost item is a `CanvasItem` that either has no parent, has non-`CanvasItem` parent or it has `top_level` enabled.

### `get_global_transform_with_canvas() -> Transform2D`
- 限定：qualifiers=const

Returns the transform from the local coordinate system of this `CanvasItem` to the `Viewport`s coordinate system.

### `get_instance_shader_parameter(name: StringName) -> Variant`
- 限定：qualifiers=const

Get the value of a shader parameter as set on this instance.

### `get_local_mouse_position() -> Vector2`
- 限定：qualifiers=const

Returns the mouse's position in this `CanvasItem` using the local coordinate system of this `CanvasItem`.

### `get_screen_transform() -> Transform2D`
- 限定：qualifiers=const

Returns the transform of this `CanvasItem` in global screen coordinates (i.e. taking window position into account). Mostly useful for editor plugins.
				Equivalent to `get_global_transform_with_canvas` if the window is embedded (see `Viewport.gui_embed_subwindows`).

### `get_transform() -> Transform2D`
- 限定：qualifiers=const

Returns the transform matrix of this `CanvasItem`.

### `get_viewport_rect() -> Rect2`
- 限定：qualifiers=const

Returns this node's viewport boundaries as a `Rect2`. See also `Node.get_viewport`.

### `get_viewport_transform() -> Transform2D`
- 限定：qualifiers=const

Returns the transform of this node, converted from its registered canvas's coordinate system to its viewport embedder's coordinate system. See also `Viewport.get_final_transform` and `Node.get_viewport`.

### `get_visibility_layer_bit(layer: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the layer at the given index is set in `visibility_layer`.

### `get_world_2d() -> World2D`
- 限定：qualifiers=const

Returns the `World2D` this node is registered to.
				Usually, this is the same as this node's viewport (see `Node.get_viewport` and `Viewport.find_world_2d`).

### `hide() -> void`

Hide the `CanvasItem` if it's currently visible. This is equivalent to setting `visible` to `false`.

### `is_local_transform_notification_enabled() -> bool`
- 限定：qualifiers=const

Returns `true` if the node receives `NOTIFICATION_LOCAL_TRANSFORM_CHANGED` whenever its local transform changes. This is enabled with `set_notify_local_transform`.

### `is_transform_notification_enabled() -> bool`
- 限定：qualifiers=const

Returns `true` if the node receives `NOTIFICATION_TRANSFORM_CHANGED` whenever its global transform changes. This is enabled with `set_notify_transform`.

### `is_visible_in_tree() -> bool`
- 限定：qualifiers=const

Returns `true` if the node is present in the `SceneTree`, its `visible` property is `true` and all its ancestors are also visible. If any ancestor is hidden, this node will not be visible in the scene tree, and is therefore not drawn (see `_draw`).
				Visibility is checked only in parent nodes that inherit from `CanvasItem`, `CanvasLayer`, and `Window`. If the parent is of any other type (such as `Node`, `AnimationPlayer`, or `Node3D`), it is assumed to be visible.
				**Note:** This method does not take `visibility_layer` into account, so even if this method returns `true`, the node might end up not being rendered.

### `make_canvas_position_local(viewport_point: Vector2) -> Vector2`
- 限定：qualifiers=const

Transforms `viewport_point` from the viewport's coordinates to this node's local coordinates.
				For the opposite operation, use `get_global_transform_with_canvas`.
				
```gdscript
				var viewport_point = get_global_transform_with_canvas() * local_point
				
```

### `make_input_local(event: InputEvent) -> InputEvent`
- 限定：qualifiers=const

Returns a copy of the given `event` with its coordinates converted from global space to this `CanvasItem`'s local space. If not possible, returns the same `InputEvent` unchanged.

### `move_to_front() -> void`

Moves this node below its siblings, usually causing the node to draw on top of its siblings. Does nothing if this node does not have a parent. See also `Node.move_child`.

### `queue_redraw() -> void`

Queues the `CanvasItem` to redraw. During idle time, if `CanvasItem` is visible, `NOTIFICATION_DRAW` is sent and `_draw` is called. This only occurs **once** per frame, even if this method has been called multiple times.

### `set_instance_shader_parameter(name: StringName, value: Variant) -> void`

Set the value of a shader uniform for this instance only (per-instance uniform ($DOCS_URL/tutorials/shaders/shader_reference/shading_language.html#per-instance-uniforms)). See also `ShaderMaterial.set_shader_parameter` to assign a uniform on all instances using the same `ShaderMaterial`.
				**Note:** For a shader uniform to be assignable on a per-instance basis, it *must* be defined with `instance uniform ...` rather than `uniform ...` in the shader code.
				**Note:** `name` is case-sensitive and must match the name of the uniform in the code exactly (not the capitalized name in the inspector).

### `set_notify_local_transform(enable: bool) -> void`

If `true`, the node will receive `NOTIFICATION_LOCAL_TRANSFORM_CHANGED` whenever its local transform changes.
				**Note:** Many canvas items such as `Bone2D` or `CollisionShape2D` automatically enable this in order to function correctly.

### `set_notify_transform(enable: bool) -> void`

If `true`, the node will receive `NOTIFICATION_TRANSFORM_CHANGED` whenever its global transform changes.
				**Note:** Many canvas items such as `Camera2D` or `Light2D` automatically enable this in order to function correctly.

### `set_visibility_layer_bit(layer: int, enabled: bool) -> void`

Set/clear individual bits on the rendering visibility layer. This simplifies editing this `CanvasItem`'s visibility layer.

### `show() -> void`

Show the `CanvasItem` if it's currently hidden. This is equivalent to setting `visible` to `true`.
				**Note:** For controls that inherit `Popup`, the correct way to make them visible is to call one of the multiple `popup*()` functions instead.

## 信号

### `draw()`

Emitted when the `CanvasItem` must redraw, *after* the related `NOTIFICATION_DRAW` notification, and *before* `_draw` is called.
				**Note:** Deferred connections do not allow drawing through the `draw_*` methods.

### `hidden()`

Emitted when this node becomes hidden, i.e. it's no longer visible in the tree (see `is_visible_in_tree`).

### `item_rect_changed()`

Emitted when the `CanvasItem`'s boundaries (position or size) change, or when an action took place that may have affected these boundaries (e.g. changing `Sprite2D.texture`).

### `visibility_changed()`

Emitted when the `CanvasItem`'s visibility changes, either because its own `visible` property changed or because its visibility in the tree changed (see `is_visible_in_tree`).
				This signal is emitted *after* the related `NOTIFICATION_VISIBILITY_CHANGED` notification.

## 枚举

### `TextureFilter`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `TEXTURE_FILTER_PARENT_NODE` |  |
| `1` | `TEXTURE_FILTER_NEAREST` |  |
| `2` | `TEXTURE_FILTER_LINEAR` |  |
| `3` | `TEXTURE_FILTER_NEAREST_WITH_MIPMAPS` |  |
| `4` | `TEXTURE_FILTER_LINEAR_WITH_MIPMAPS` |  |
| `5` | `TEXTURE_FILTER_NEAREST_WITH_MIPMAPS_ANISOTROPIC` |  |
| `6` | `TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC` |  |
| `7` | `TEXTURE_FILTER_MAX` |  |

### `TextureRepeat`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `TEXTURE_REPEAT_PARENT_NODE` |  |
| `1` | `TEXTURE_REPEAT_DISABLED` |  |
| `2` | `TEXTURE_REPEAT_ENABLED` |  |
| `3` | `TEXTURE_REPEAT_MIRROR` |  |
| `4` | `TEXTURE_REPEAT_MAX` |  |

### `ClipChildrenMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `CLIP_CHILDREN_DISABLED` |  |
| `1` | `CLIP_CHILDREN_ONLY` |  |
| `2` | `CLIP_CHILDREN_AND_DRAW` |  |
| `3` | `CLIP_CHILDREN_MAX` |  |

### `OversamplingWithScale`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `OVERSAMPLING_WITH_SCALE_PARENT_NODE` |  |
| `1` | `OVERSAMPLING_WITH_SCALE_DISABLED` |  |
| `2` | `OVERSAMPLING_WITH_SCALE_ENABLED` |  |
| `3` | `OVERSAMPLING_WITH_SCALE_MAX` |  |

## 常量

- **`NOTIFICATION_TRANSFORM_CHANGED`** = `2000`
- **`NOTIFICATION_LOCAL_TRANSFORM_CHANGED`** = `35`
- **`NOTIFICATION_DRAW`** = `30`
- **`NOTIFICATION_VISIBILITY_CHANGED`** = `31`
- **`NOTIFICATION_ENTER_CANVAS`** = `32`
- **`NOTIFICATION_EXIT_CANVAS`** = `33`
- **`NOTIFICATION_WORLD_2D_CHANGED`** = `36`
## 教程链接

- [Viewport and canvas transforms](None)
- [Custom drawing in 2D](None)
- [Audio Spectrum Visualizer Demo](None)

