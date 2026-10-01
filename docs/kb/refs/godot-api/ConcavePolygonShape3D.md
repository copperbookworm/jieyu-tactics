# ConcavePolygonShape3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ConcavePolygonShape3D` → `Shape3D` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/ConcavePolygonShape3D.md`

**摘要**：A 3D trimesh shape used for physics collision.

## 描述

A 3D trimesh shape, intended for use in physics. Usually used to provide a shape for a `CollisionShape3D`.
		Being just a collection of interconnected triangles, `ConcavePolygonShape3D` is the most freely configurable single 3D shape. It can be used to form polyhedra of any nature, or even shapes that don't enclose a volume. However, `ConcavePolygonShape3D` is *hollow* even if the interconnected triangles do enclose a volume, which often makes it unsuitable for physics or detection.
		**Note:** When used for collision, `ConcavePolygonShape3D` is intended to work with static `CollisionShape3D` nodes like `StaticBody3D` and will likely not behave well for `CharacterBody3D`s or `RigidBody3D`s in a mode other than Static.
		**Warning:** Physics bodies that are small have a chance to clip through this shape when moving fast. This happens because on one frame, the physics body may be on the "outside" of the shape, and on the next frame it may be "inside" it. `ConcavePolygonShape3D` is hollow, so it won't detect a collision.
		**Performance:** Due to its complexity, `ConcavePolygonShape3D` is the slowest 3D collision shape to check collisions against. Its use should generally be limited to level geometry. For convex geometry, `ConvexPolygonShape3D` should be used. For dynamic physics bodies that need concave collision, several `ConvexPolygonShape3D`s can be used to represent its collision by using convex decomposition; see `ConvexPolygonShape3D`'s documentation for instructions.

## 属性

- **`backface_collision`** `bool` = `false`
  - 其它属性：getter=is_backface_collision_enabled · setter=set_backface_collision_enabled

## 方法

### `get_faces() -> PackedVector3Array`
- 限定：qualifiers=const

Returns the faces of the trimesh shape as an array of vertices. The array (of length divisible by three) is naturally divided into triples; each triple of vertices defines a triangle.

### `set_faces(faces: PackedVector3Array) -> void`

Sets the faces of the trimesh shape from an array of vertices. The `faces` array should be composed of triples such that each triple of vertices defines a triangle.

## 教程链接

- [3D Physics Tests Demo](None)

