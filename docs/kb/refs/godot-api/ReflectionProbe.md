# ReflectionProbe

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ReflectionProbe` → `VisualInstance3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core · keywords=environment, envmap
> 自动生成，勿手改。文件：`refs/godot-api/ReflectionProbe.md`

**摘要**：Captures its surroundings to create fast, accurate reflections from a given point.

## 描述

Captures its surroundings as a cubemap, and stores versions of it with increasing levels of blur to simulate different material roughnesses.
		The `ReflectionProbe` is used to create high-quality reflections at a low performance cost (when `update_mode` is `UPDATE_ONCE`). `ReflectionProbe`s can be blended together and with the rest of the scene smoothly. `ReflectionProbe`s can also be combined with `VoxelGI`, SDFGI (`Environment.sdfgi_enabled`) and screen-space reflections (`Environment.ssr_enabled`) to get more accurate reflections in specific areas. `ReflectionProbe`s render all objects within their `cull_mask`, so updating them can be quite expensive. It is best to update them once with the important static objects and then leave them as-is.
		**Note:** Unlike `VoxelGI` and SDFGI, `ReflectionProbe`s only source their environment from a `WorldEnvironment` node. If you specify an `Environment` resource within a `Camera3D` node, it will be ignored by the `ReflectionProbe`. This can lead to incorrect lighting within the `ReflectionProbe`.
		**Note:** When using the Mobile rendering method, only `8` reflection probes can be displayed on each mesh resource, while the Compatibility rendering method only supports up to `2` reflection probes on each mesh. Attempting to display more than `8` reflection probes on a single mesh resource using the Mobile renderer will result in reflection probes flickering in and out as the camera moves, while the Compatibility renderer will not render any additional probes if more than `2` reflection probes are being used.
		**Note:** When using the Mobile rendering method, reflection probes will only correctly affect meshes whose visibility AABB intersects with the reflection probe's AABB. If using a shader to deform the mesh in a way that makes it go outside its AABB, `GeometryInstance3D.extra_cull_margin` must be increased on the mesh. Otherwise, the reflection probe may not be visible on the mesh.

## 属性

- **`ambient_color`** `Color` = `Color(0, 0, 0, 1)`
  - 其它属性：getter=get_ambient_color · setter=set_ambient_color
- **`ambient_color_energy`** `float` = `1.0`
  - 其它属性：getter=get_ambient_color_energy · setter=set_ambient_color_energy
- **`ambient_mode`** `int` = `1` · 枚举 `ReflectionProbe.AmbientMode`
  - 其它属性：getter=get_ambient_mode · setter=set_ambient_mode
- **`blend_distance`** `float` = `1.0`
  - 其它属性：getter=get_blend_distance · setter=set_blend_distance
- **`box_projection`** `bool` = `false`
  - 其它属性：getter=is_box_projection_enabled · setter=set_enable_box_projection
- **`cull_mask`** `int` = `1048575`
  - 其它属性：getter=get_cull_mask · setter=set_cull_mask
- **`enable_shadows`** `bool` = `false`
  - 其它属性：getter=are_shadows_enabled · setter=set_enable_shadows
- **`intensity`** `float` = `1.0`
  - 其它属性：getter=get_intensity · setter=set_intensity
- **`interior`** `bool` = `false`
  - 其它属性：getter=is_set_as_interior · setter=set_as_interior
- **`max_distance`** `float` = `0.0`
  - 其它属性：getter=get_max_distance · setter=set_max_distance
- **`mesh_lod_threshold`** `float` = `1.0`
  - 其它属性：getter=get_mesh_lod_threshold · setter=set_mesh_lod_threshold
- **`origin_offset`** `Vector3` = `Vector3(0, 0, 0)`
  - 其它属性：getter=get_origin_offset · setter=set_origin_offset
- **`reflection_mask`** `int` = `1048575`
  - 其它属性：getter=get_reflection_mask · setter=set_reflection_mask
- **`size`** `Vector3` = `Vector3(20, 20, 20)`
  - 其它属性：getter=get_size · setter=set_size
- **`update_mode`** `int` = `0` · 枚举 `ReflectionProbe.UpdateMode`
  - 其它属性：getter=get_update_mode · setter=set_update_mode

## 枚举

### `UpdateMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `UPDATE_ONCE` |  |
| `1` | `UPDATE_ALWAYS` |  |

### `AmbientMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `AMBIENT_DISABLED` |  |
| `1` | `AMBIENT_ENVIRONMENT` |  |
| `2` | `AMBIENT_COLOR` |  |

## 教程链接

- [Reflection probes](None)

