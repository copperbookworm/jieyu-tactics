# VisualInstance3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VisualInstance3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VisualInstance3D.md`

**摘要**：Parent of all visual 3D nodes.

## 描述

The `VisualInstance3D` is used to connect a resource to a visual representation. All visual 3D nodes inherit from the `VisualInstance3D`. In general, you should not access the `VisualInstance3D` properties directly as they are accessed and managed by the nodes that inherit from `VisualInstance3D`. `VisualInstance3D` is the node representation of the `RenderingServer` instance.

## 属性

- **`layers`** `int` = `1`
  - 其它属性：getter=get_layer_mask · setter=set_layer_mask
- **`sorting_offset`** `float` = `0.0`
  - 其它属性：getter=get_sorting_offset · setter=set_sorting_offset
- **`sorting_use_aabb_center`** `bool`
  - 其它属性：getter=is_sorting_use_aabb_center · setter=set_sorting_use_aabb_center

## 方法

### `_get_aabb() -> AABB`
- 限定：qualifiers=virtual const

### `get_aabb() -> AABB`
- 限定：qualifiers=const

Returns the `AABB` (also known as the bounding box) for this `VisualInstance3D`.

### `get_base() -> RID`
- 限定：qualifiers=const

Returns the RID of the resource associated with this `VisualInstance3D`. For example, if the Node is a `MeshInstance3D`, this will return the RID of the associated `Mesh`.

### `get_instance() -> RID`
- 限定：qualifiers=const

Returns the RID of this instance. This RID is the same as the RID returned by `RenderingServer.instance_create`. This RID is needed if you want to call `RenderingServer` functions directly on this `VisualInstance3D`.

### `get_layer_mask_value(layer_number: int) -> bool`
- 限定：qualifiers=const

Returns whether or not the specified layer of the `layers` is enabled, given a `layer_number` between 1 and 20.

### `set_base(base: RID) -> void`

Sets the resource that is instantiated by this `VisualInstance3D`, which changes how the engine handles the `VisualInstance3D` under the hood. Equivalent to `RenderingServer.instance_set_base`.

### `set_layer_mask_value(layer_number: int, value: bool) -> void`

Based on `value`, enables or disables the specified layer in the `layers`, given a `layer_number` between 1 and 20.

