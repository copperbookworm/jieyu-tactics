# PolygonOccluder3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`PolygonOccluder3D` → `Occluder3D` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/PolygonOccluder3D.md`

**摘要**：Flat 2D polygon shape for use with occlusion culling in `OccluderInstance3D`.

## 描述

`PolygonOccluder3D` stores a polygon shape that can be used by the engine's occlusion culling system. When an `OccluderInstance3D` with a `PolygonOccluder3D` is selected in the editor, an editor will appear at the top of the 3D viewport so you can add/remove points. All points must be placed on the same 2D plane, which means it is not possible to create arbitrary 3D shapes with a single `PolygonOccluder3D`. To use arbitrary 3D shapes as occluders, use `ArrayOccluder3D` or `OccluderInstance3D`'s baking feature instead.
		See `OccluderInstance3D`'s documentation for instructions on setting up occlusion culling.

## 属性

- **`polygon`** `PackedVector2Array` = `PackedVector2Array()`
  - 其它属性：getter=get_polygon · setter=set_polygon

## 教程链接

- [Occlusion culling](None)

