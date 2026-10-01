# Occluder3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Occluder3D` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Occluder3D.md`

**摘要**：Occluder shape resource for use with occlusion culling in `OccluderInstance3D`.

## 描述

`Occluder3D` stores an occluder shape that can be used by the engine's occlusion culling system.
		See `OccluderInstance3D`'s documentation for instructions on setting up occlusion culling.

## 方法

### `get_indices() -> PackedInt32Array`
- 限定：qualifiers=const

Returns the occluder shape's vertex indices.

### `get_vertices() -> PackedVector3Array`
- 限定：qualifiers=const

Returns the occluder shape's vertex positions.

## 教程链接

- [Occlusion culling](None)

