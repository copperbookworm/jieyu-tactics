# CollisionShape3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`CollisionShape3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/CollisionShape3D.md`

**摘要**：A node that provides a `Shape3D` to a `CollisionObject3D` parent.

## 描述

A node that provides a `Shape3D` to a `CollisionObject3D` parent and allows it to be edited. This can give a detection shape to an `Area3D` or turn a `PhysicsBody3D` into a solid object.
		**Warning:** A non-uniformly scaled `CollisionShape3D` will likely not behave as expected. Make sure to keep its scale the same on all axes and adjust its `shape` resource instead.

## 属性

- **`debug_color`** `Color` = `Color(0, 0, 0, 0)`
  - 其它属性：getter=get_debug_color · setter=set_debug_color
- **`debug_fill`** `bool` = `true`
  - 其它属性：getter=get_enable_debug_fill · setter=set_enable_debug_fill
- **`disabled`** `bool` = `false`
  - 其它属性：getter=is_disabled · keywords=enabled · setter=set_disabled
- **`shape`** `Shape3D`
  - 其它属性：getter=get_shape · setter=set_shape

## 方法

### `make_convex_from_siblings() -> void`

Sets the collision shape's shape to the addition of all its convexed `MeshInstance3D` siblings geometry.

### `resource_changed(resource: Resource) -> void`
- 限定：deprecated=Use [signal Resource.changed] instead.

This method does nothing.

## 教程链接

- [Physics introduction](None)
- [3D Kinematic Character Demo](None)
- [3D Platformer Demo](None)
- [Third Person Shooter (TPS) Demo](None)

