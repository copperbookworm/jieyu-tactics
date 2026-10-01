# ConcavePolygonShape2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ConcavePolygonShape2D` → `Shape2D` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/ConcavePolygonShape2D.md`

**摘要**：A 2D polyline shape used for physics collision.

## 描述

A 2D polyline shape, intended for use in physics. Used internally in `CollisionPolygon2D` when it's in `CollisionPolygon2D.BUILD_SEGMENTS` mode.
		Being just a collection of interconnected line segments, `ConcavePolygonShape2D` is the most freely configurable single 2D shape. It can be used to form polygons of any nature, or even shapes that don't enclose an area. However, `ConcavePolygonShape2D` is *hollow* even if the interconnected line segments do enclose an area, which often makes it unsuitable for physics or detection.
		**Note:** When used for collision, `ConcavePolygonShape2D` is intended to work with static `CollisionShape2D` nodes like `StaticBody2D` and will likely not behave well for `CharacterBody2D`s or `RigidBody2D`s in a mode other than Static.
		**Warning:** Physics bodies that are small have a chance to clip through this shape when moving fast. This happens because on one frame, the physics body may be on the "outside" of the shape, and on the next frame it may be "inside" it. `ConcavePolygonShape2D` is hollow, so it won't detect a collision.
		**Performance:** Due to its complexity, `ConcavePolygonShape2D` is the slowest 2D collision shape to check collisions against. Its use should generally be limited to level geometry. If the polyline is closed, `CollisionPolygon2D`'s `CollisionPolygon2D.BUILD_SOLIDS` mode can be used, which decomposes the polygon into convex ones; see `ConvexPolygonShape2D`'s documentation for instructions.

## 属性

- **`segments`** `PackedVector2Array` = `PackedVector2Array()`
  - 其它属性：getter=get_segments · setter=set_segments

