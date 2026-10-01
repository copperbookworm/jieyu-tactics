# CollisionPolygon3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`CollisionPolygon3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/CollisionPolygon3D.md`

**摘要**：A node that provides a thickened polygon shape (a prism) to a `CollisionObject3D` parent.

## 描述

A node that provides a thickened polygon shape (a prism) to a `CollisionObject3D` parent and allows it to be edited. The polygon can be concave or convex. This can give a detection shape to an `Area3D` or turn a `PhysicsBody3D` into a solid object.
		**Warning:** A non-uniformly scaled `CollisionShape3D` will likely not behave as expected. Make sure to keep its scale the same on all axes and adjust its shape resource instead.

## 属性

- **`debug_color`** `Color` = `Color(0, 0, 0, 0)`
  - 其它属性：getter=get_debug_color · setter=set_debug_color
- **`debug_fill`** `bool` = `true`
  - 其它属性：getter=get_enable_debug_fill · setter=set_enable_debug_fill
- **`depth`** `float` = `1.0`
  - 其它属性：getter=get_depth · setter=set_depth
- **`disabled`** `bool` = `false`
  - 其它属性：getter=is_disabled · keywords=enabled · setter=set_disabled
- **`margin`** `float` = `0.04`
  - 其它属性：getter=get_margin · setter=set_margin
- **`polygon`** `PackedVector2Array` = `PackedVector2Array()`
  - 其它属性：getter=get_polygon · setter=set_polygon

