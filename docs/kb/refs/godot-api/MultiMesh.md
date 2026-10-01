# MultiMesh

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`MultiMesh` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core · keywords=batch
> 自动生成，勿手改。文件：`refs/godot-api/MultiMesh.md`

**摘要**：Provides high-performance drawing of a mesh multiple times using GPU instancing.

## 描述

MultiMesh provides low-level mesh instancing. Drawing thousands of `MeshInstance3D` nodes can be slow, since each object is submitted to the GPU then drawn individually.
		MultiMesh is much faster as it can draw thousands of instances with a single draw call, resulting in less API overhead.
		As a drawback, if the instances are too far away from each other, performance may be reduced as every single instance will always render (they are spatially indexed as one, for the whole object).
		Since instances may have any behavior, the AABB used for visibility must be provided by the user.
		**Note:** A MultiMesh is a single object, therefore the same maximum lights per object restriction applies. This means, that once the maximum lights are consumed by one or more instances, the rest of the MultiMesh instances will **not** receive any lighting.
		**Note:** Blend Shapes will be ignored if used in a MultiMesh.

## 属性

- **`buffer`** `PackedFloat32Array` = `PackedFloat32Array()`
  - 其它属性：getter=get_buffer · setter=set_buffer
- **`color_array`** `PackedColorArray`
  - 其它属性：deprecated=Accessing this property is very slow. Use [method set_instance_color] and [method get_instance_color] instead. · getter=_get_color_array · setter=_set_color_array
- **`custom_aabb`** `AABB` = `AABB(0, 0, 0, 0, 0, 0)`
  - 其它属性：getter=get_custom_aabb · setter=set_custom_aabb
- **`custom_data_array`** `PackedColorArray`
  - 其它属性：deprecated=Accessing this property is very slow. Use [method set_instance_custom_data] and [method get_instance_custom_data] instead. · getter=_get_custom_data_array · setter=_set_custom_data_array
- **`instance_count`** `int` = `0`
  - 其它属性：getter=get_instance_count · setter=set_instance_count
- **`mesh`** `Mesh`
  - 其它属性：getter=get_mesh · setter=set_mesh
- **`physics_interpolation_quality`** `int` = `0` · 枚举 `MultiMesh.PhysicsInterpolationQuality`
  - 其它属性：getter=get_physics_interpolation_quality · setter=set_physics_interpolation_quality
- **`transform_2d_array`** `PackedVector2Array`
  - 其它属性：deprecated=Accessing this property is very slow. Use [method set_instance_transform_2d] and [method get_instance_transform_2d] instead. · getter=_get_transform_2d_array · setter=_set_transform_2d_array
- **`transform_array`** `PackedVector3Array`
  - 其它属性：deprecated=Accessing this property is very slow. Use [method set_instance_transform] and [method get_instance_transform] instead. · getter=_get_transform_array · setter=_set_transform_array
- **`transform_format`** `int` = `0` · 枚举 `MultiMesh.TransformFormat`
  - 其它属性：getter=get_transform_format · setter=set_transform_format
- **`use_colors`** `bool` = `false`
  - 其它属性：getter=is_using_colors · setter=set_use_colors
- **`use_custom_data`** `bool` = `false`
  - 其它属性：getter=is_using_custom_data · setter=set_use_custom_data
- **`visible_instance_count`** `int` = `-1`
  - 其它属性：getter=get_visible_instance_count · setter=set_visible_instance_count

## 方法

### `get_aabb() -> AABB`
- 限定：qualifiers=const

Returns the visibility axis-aligned bounding box in local space.

### `get_instance_color(instance: int) -> Color`
- 限定：qualifiers=const

Gets a specific instance's color multiplier.

### `get_instance_custom_data(instance: int) -> Color`
- 限定：qualifiers=const

Returns the custom data that has been set for a specific instance.

### `get_instance_transform(instance: int) -> Transform3D`
- 限定：qualifiers=const

Returns the `Transform3D` of a specific instance.

### `get_instance_transform_2d(instance: int) -> Transform2D`
- 限定：qualifiers=const

Returns the `Transform2D` of a specific instance.

### `reset_instance_physics_interpolation(instance: int) -> void`

When using *physics interpolation*, this function allows you to prevent interpolation on an instance in the current physics tick.
				This allows you to move instances instantaneously, and should usually be used when initially placing an instance such as a bullet to prevent graphical glitches.

### `reset_instances_physics_interpolation() -> void`

When using *physics interpolation*, this function allows you to prevent interpolation for all instances in the current physics tick.
				This allows you to move all instances instantaneously, and should usually be used when initially placing instances to prevent graphical glitches.

### `set_buffer_interpolated(buffer_curr: PackedFloat32Array, buffer_prev: PackedFloat32Array) -> void`

An alternative to setting the `buffer` property, which can be used with *physics interpolation*. This method takes two arrays, and can set the data for the current and previous tick in one go. The renderer will automatically interpolate the data at each frame.
				This is useful for situations where the order of instances may change from physics tick to tick, such as particle systems.
				When the order of instances is coherent, the simpler alternative of setting `buffer` can still be used with interpolation.

### `set_instance_color(instance: int, color: Color) -> void`

Sets the color of a specific instance by *multiplying* the mesh's existing vertex colors. This allows for different color tinting per instance.
				**Note:** Each component is stored in 32 bits in the Forward+ and Mobile rendering methods, but is packed into 16 bits in the Compatibility rendering method.
				For the color to take effect, ensure that `use_colors` is `true` on the `MultiMesh` and `BaseMaterial3D.vertex_color_use_as_albedo` is `true` on the material. If you intend to set an absolute color instead of tinting, make sure the material's albedo color is set to pure white (`Color(1, 1, 1)`).

### `set_instance_custom_data(instance: int, custom_data: Color) -> void`

Sets custom data for a specific instance. `custom_data` is a `Color` type only to contain 4 floating-point numbers.
				**Note:** Each number is stored in 32 bits in the Forward+ and Mobile rendering methods, but is packed into 16 bits in the Compatibility rendering method.
				For the custom data to be used, ensure that `use_custom_data` is `true`.
				This custom instance data has to be manually accessed in your custom shader using `INSTANCE_CUSTOM`.

### `set_instance_transform(instance: int, transform: Transform3D) -> void`

Sets the `Transform3D` for a specific instance.

### `set_instance_transform_2d(instance: int, transform: Transform2D) -> void`

Sets the `Transform2D` for a specific instance.

## 枚举

### `TransformFormat`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `TRANSFORM_2D` |  |
| `1` | `TRANSFORM_3D` |  |

### `PhysicsInterpolationQuality`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `INTERP_QUALITY_FAST` |  |
| `1` | `INTERP_QUALITY_HIGH` |  |

## 教程链接

- [Using MultiMeshInstance](None)
- [Optimization using MultiMeshes](None)
- [Animating thousands of fish with MultiMeshInstance](None)

