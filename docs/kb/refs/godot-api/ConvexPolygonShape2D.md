# ConvexPolygonShape2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ConvexPolygonShape2D` → `Shape2D` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/ConvexPolygonShape2D.md`

**摘要**：A 2D convex polygon shape used for physics collision.

## 描述

A 2D convex polygon shape, intended for use in physics. Used internally in `CollisionPolygon2D` when it's in `CollisionPolygon2D.BUILD_SOLIDS` mode.
		`ConvexPolygonShape2D` is *solid*, which means it detects collisions from objects that are fully inside it, unlike `ConcavePolygonShape2D` which is hollow. This makes it more suitable for both detection and physics.
		**Convex decomposition:** A concave polygon can be split up into several convex polygons. This allows dynamic physics bodies to have complex concave collisions (at a performance cost) and can be achieved by using several `ConvexPolygonShape2D` nodes or by using the `CollisionPolygon2D` node in `CollisionPolygon2D.BUILD_SOLIDS` mode. To generate a collision polygon from a sprite, select the `Sprite2D` node, go to the **Sprite2D** menu that appears above the viewport, and choose **Create Polygon2D Sibling**.
		**Performance:** `ConvexPolygonShape2D` is faster to check collisions against compared to `ConcavePolygonShape2D`, but it is slower than primitive collision shapes such as `CircleShape2D` and `RectangleShape2D`. Its use should generally be limited to medium-sized objects that cannot have their collision accurately represented by primitive shapes.

## 属性

- **`points`** `PackedVector2Array` = `PackedVector2Array()`
  - 其它属性：getter=get_points · setter=set_points

## 方法

### `set_point_cloud(point_cloud: PackedVector2Array) -> void`

Based on the set of points provided, this assigns the `points` property using the convex hull algorithm, removing all unneeded points. See `Geometry2D.convex_hull` for details.

