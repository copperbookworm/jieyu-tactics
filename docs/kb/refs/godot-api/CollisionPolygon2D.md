# CollisionPolygon2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`CollisionPolygon2D` → `Node2D` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/CollisionPolygon2D.md`

**摘要**：A node that provides a polygon shape to a `CollisionObject2D` parent.

## 描述

A node that provides a polygon shape to a `CollisionObject2D` parent and allows it to be edited. The polygon can be concave or convex. This can give a detection shape to an `Area2D`, turn a `PhysicsBody2D` into a solid object, or give a hollow shape to a `StaticBody2D`.
		**Warning:** A non-uniformly scaled `CollisionPolygon2D` will likely not behave as expected. Make sure to keep its scale the same on all axes and adjust its polygon instead.

## 属性

- **`build_mode`** `int` = `0` · 枚举 `CollisionPolygon2D.BuildMode`
  - 其它属性：getter=get_build_mode · setter=set_build_mode
- **`disabled`** `bool` = `false`
  - 其它属性：getter=is_disabled · keywords=enabled · setter=set_disabled
- **`one_way_collision`** `bool` = `false`
  - 其它属性：getter=is_one_way_collision_enabled · setter=set_one_way_collision
- **`one_way_collision_direction`** `Vector2` = `Vector2(0, 1)`
  - 其它属性：getter=get_one_way_collision_direction · setter=set_one_way_collision_direction
- **`one_way_collision_margin`** `float` = `1.0`
  - 其它属性：getter=get_one_way_collision_margin · setter=set_one_way_collision_margin
- **`polygon`** `PackedVector2Array` = `PackedVector2Array()`
  - 其它属性：getter=get_polygon · setter=set_polygon

## 枚举

### `BuildMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `BUILD_SOLIDS` |  |
| `1` | `BUILD_SEGMENTS` |  |

