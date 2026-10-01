# ConvexPolygonShape3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ConvexPolygonShape3D` → `Shape3D` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/ConvexPolygonShape3D.md`

**摘要**：A 3D convex polyhedron shape used for physics collision.

## 描述

A 3D convex polyhedron shape, intended for use in physics. Usually used to provide a shape for a `CollisionShape3D`.
		`ConvexPolygonShape3D` is *solid*, which means it detects collisions from objects that are fully inside it, unlike `ConcavePolygonShape3D` which is hollow. This makes it more suitable for both detection and physics.
		**Convex decomposition:** A concave polyhedron can be split up into several convex polyhedra. This allows dynamic physics bodies to have complex concave collisions (at a performance cost) and can be achieved by using several `ConvexPolygonShape3D` nodes. To generate a convex decomposition from a mesh, select the `MeshInstance3D` node, go to the **Mesh** menu that appears above the viewport, and choose **Create Multiple Convex Collision Siblings**. Alternatively, `MeshInstance3D.create_multiple_convex_collisions` can be called in a script to perform this decomposition at run-time.
		**Performance:** `ConvexPolygonShape3D` is faster to check collisions against compared to `ConcavePolygonShape3D`, but it is slower than primitive collision shapes such as `SphereShape3D` and `BoxShape3D`. Its use should generally be limited to medium-sized objects that cannot have their collision accurately represented by primitive shapes.

## 属性

- **`points`** `PackedVector3Array` = `PackedVector3Array()`
  - 其它属性：getter=get_points · setter=set_points

## 教程链接

- [3D Physics Tests Demo](None)

