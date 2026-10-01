# QuadMesh

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`QuadMesh` → `PlaneMesh` → `PrimitiveMesh` → `Mesh` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/QuadMesh.md`

**摘要**：Class representing a square mesh facing the camera.

## 描述

Class representing a square `PrimitiveMesh`. This flat mesh does not have a thickness. By default, this mesh is aligned on the X and Y axes; this rotation is more suited for use with billboarded materials. A `QuadMesh` is equivalent to a `PlaneMesh` except its default `PlaneMesh.orientation` is `PlaneMesh.FACE_Z`.

## 属性

- **`orientation`** `int` = `2` · 枚举 `PlaneMesh.Orientation`
  - 其它属性：getter=get_orientation · overrides=PlaneMesh · setter=set_orientation
- **`size`** `Vector2` = `Vector2(1, 1)`
  - 其它属性：getter=get_size · overrides=PlaneMesh · setter=set_size

## 教程链接

- [GUI in 3D Viewport Demo](None)
- [2D in 3D Viewport Demo](None)

