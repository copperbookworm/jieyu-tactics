# Shape3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Shape3D` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Shape3D.md`

**摘要**：Abstract base class for 3D shapes used for physics collision.

## 描述

Abstract base class for all 3D shapes, intended for use in physics.
		**Performance:** Primitive shapes, especially `SphereShape3D`, are fast to check collisions against. `ConvexPolygonShape3D` and `HeightMapShape3D` are slower, and `ConcavePolygonShape3D` is the slowest.

## 属性

- **`custom_solver_bias`** `float` = `0.0`
  - 其它属性：getter=get_custom_solver_bias · setter=set_custom_solver_bias
- **`margin`** `float` = `0.04`
  - 其它属性：getter=get_margin · setter=set_margin

## 方法

### `get_debug_mesh() -> ArrayMesh`

Returns the `ArrayMesh` used to draw the debug collision for this `Shape3D`.

## 教程链接

- [Physics introduction](None)

