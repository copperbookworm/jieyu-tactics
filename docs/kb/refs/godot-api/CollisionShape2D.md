# CollisionShape2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`CollisionShape2D` → `Node2D` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/CollisionShape2D.md`

**摘要**：A node that provides a `Shape2D` to a `CollisionObject2D` parent.

## 描述

A node that provides a `Shape2D` to a `CollisionObject2D` parent and allows it to be edited. This can give a detection shape to an `Area2D` or turn a `PhysicsBody2D` into a solid object.

## 属性

- **`debug_color`** `Color` = `Color(0, 0, 0, 0)`
  - 其它属性：getter=get_debug_color · setter=set_debug_color
- **`disabled`** `bool` = `false`
  - 其它属性：getter=is_disabled · keywords=enabled · setter=set_disabled
- **`one_way_collision`** `bool` = `false`
  - 其它属性：getter=is_one_way_collision_enabled · setter=set_one_way_collision
- **`one_way_collision_direction`** `Vector2` = `Vector2(0, 1)`
  - 其它属性：getter=get_one_way_collision_direction · setter=set_one_way_collision_direction
- **`one_way_collision_margin`** `float` = `1.0`
  - 其它属性：getter=get_one_way_collision_margin · setter=set_one_way_collision_margin
- **`shape`** `Shape2D`
  - 其它属性：getter=get_shape · setter=set_shape

## 教程链接

- [Physics introduction](None)
- [2D Dodge The Creeps Demo](None)
- [2D Pong Demo](None)
- [2D Kinematic Character Demo](None)

