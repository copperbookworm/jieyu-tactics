# CSGShape3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`CSGShape3D` → `GeometryInstance3D` → `VisualInstance3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/CSGShape3D.md`

**摘要**：The CSG base class.

## 描述

This is the CSG base class that provides CSG operation support to the various CSG nodes in Godot.
		**Performance:** CSG nodes are only intended for prototyping as they have a significant CPU performance cost. Consider baking final CSG operation results into static geometry that replaces the CSG nodes.
		Individual CSG root node results can be baked to nodes with static resources with the editor menu that appears when a CSG root node is selected.
		Individual CSG root nodes can also be baked to static resources with scripts by calling `bake_static_mesh` for the visual mesh or `bake_collision_shape` for the physics collision.
		Entire scenes of CSG nodes can be baked to static geometry and exported with the editor glTF scene exporter: **Scene > Export As... > glTF 2.0 Scene...**

## 属性

- **`autosmooth`** `bool` = `false`
  - 其它属性：getter=is_autosmooth · setter=set_autosmooth
- **`calculate_tangents`** `bool` = `true`
  - 其它属性：getter=is_calculating_tangents · setter=set_calculate_tangents
- **`collision_layer`** `int` = `1`
  - 其它属性：getter=get_collision_layer · setter=set_collision_layer
- **`collision_mask`** `int` = `1`
  - 其它属性：getter=get_collision_mask · setter=set_collision_mask
- **`collision_priority`** `float` = `1.0`
  - 其它属性：getter=get_collision_priority · setter=set_collision_priority
- **`operation`** `int` = `0` · 枚举 `CSGShape3D.Operation`
  - 其它属性：getter=get_operation · setter=set_operation
- **`smoothing_angle`** `float` = `50.0`
  - 其它属性：getter=get_smoothing_angle · setter=set_smoothing_angle
- **`snap`** `float`
  - 其它属性：deprecated=The CSG library no longer uses snapping. · getter=get_snap · setter=set_snap
- **`use_collision`** `bool` = `false`
  - 其它属性：getter=is_using_collision · setter=set_use_collision

## 方法

### `bake_collision_shape() -> ConcavePolygonShape3D`

Returns a baked physics `ConcavePolygonShape3D` of this node's CSG operation result. Returns an empty shape if the node is not a CSG root node or has no valid geometry.
				**Performance:** If the CSG operation results in a very detailed geometry with many faces physics performance will be very slow. Concave shapes should in general only be used for static level geometry and not with dynamic objects that are moving.
				**Note:** CSG mesh data updates are deferred, which means they are updated with a delay of one rendered frame. To avoid getting an empty shape or outdated mesh data, make sure to call `await get_tree().process_frame` before using `bake_collision_shape` in `Node._ready` or after changing properties on the `CSGShape3D`.

### `bake_static_mesh() -> ArrayMesh`

Returns a baked static `ArrayMesh` of this node's CSG operation result. Materials from involved CSG nodes are added as extra mesh surfaces. Returns an empty mesh if the node is not a CSG root node or has no valid geometry.
				**Note:** CSG mesh data updates are deferred, which means they are updated with a delay of one rendered frame. To avoid getting an empty mesh or outdated mesh data, make sure to call `await get_tree().process_frame` before using `bake_static_mesh` in `Node._ready` or after changing properties on the `CSGShape3D`.

### `get_collision_layer_value(layer_number: int) -> bool`
- 限定：qualifiers=const

Returns whether or not the specified layer of the `collision_layer` is enabled, given a `layer_number` between 1 and 32.

### `get_collision_mask_value(layer_number: int) -> bool`
- 限定：qualifiers=const

Returns whether or not the specified layer of the `collision_mask` is enabled, given a `layer_number` between 1 and 32.

### `get_meshes() -> Array`
- 限定：qualifiers=const

Returns an `Array` with two elements, the first is the `Transform3D` of this node and the second is the root `Mesh` of this node. Only works when this node is the root shape.
				**Note:** CSG mesh data updates are deferred, which means they are updated with a delay of one rendered frame. To avoid getting an empty shape or outdated mesh data, make sure to call `await get_tree().process_frame` before using `get_meshes` in `Node._ready` or after changing properties on the `CSGShape3D`.

### `is_root_shape() -> bool`
- 限定：qualifiers=const

Returns `true` if this is a root shape and is thus the object that is rendered.

### `set_collision_layer_value(layer_number: int, value: bool) -> void`

Based on `value`, enables or disables the specified layer in the `collision_layer`, given a `layer_number` between 1 and 32.

### `set_collision_mask_value(layer_number: int, value: bool) -> void`

Based on `value`, enables or disables the specified layer in the `collision_mask`, given a `layer_number` between 1 and 32.

## 枚举

### `Operation`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `OPERATION_UNION` |  |
| `1` | `OPERATION_INTERSECTION` |  |
| `2` | `OPERATION_SUBTRACTION` |  |

## 教程链接

- [Prototyping levels with CSG](None)

