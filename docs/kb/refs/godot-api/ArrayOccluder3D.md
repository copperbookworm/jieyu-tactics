# ArrayOccluder3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ArrayOccluder3D` → `Occluder3D` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/ArrayOccluder3D.md`

**摘要**：3D polygon shape for use with occlusion culling in `OccluderInstance3D`.

## 描述

`ArrayOccluder3D` stores an arbitrary 3D polygon shape that can be used by the engine's occlusion culling system. This is analogous to `ArrayMesh`, but for occluders.
		See `OccluderInstance3D`'s documentation for instructions on setting up occlusion culling.

## 属性

- **`indices`** `PackedInt32Array` = `PackedInt32Array()`
  - 其它属性：getter=get_indices · setter=set_indices
- **`vertices`** `PackedVector3Array` = `PackedVector3Array()`
  - 其它属性：getter=get_vertices · setter=set_vertices

## 方法

### `set_arrays(vertices: PackedVector3Array, indices: PackedInt32Array) -> void`

Sets `indices` and `vertices`, while updating the final occluder only once after both values are set.

## 教程链接

- [Occlusion culling](None)

