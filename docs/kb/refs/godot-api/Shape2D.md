# Shape2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Shape2D` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Shape2D.md`

**摘要**：Abstract base class for 2D shapes used for physics collision.

## 描述

Abstract base class for all 2D shapes, intended for use in physics.
		**Performance:** Primitive shapes, especially `CircleShape2D`, are fast to check collisions against. `ConvexPolygonShape2D` is slower, and `ConcavePolygonShape2D` is the slowest.

## 属性

- **`custom_solver_bias`** `float` = `0.0`
  - 其它属性：getter=get_custom_solver_bias · setter=set_custom_solver_bias

## 方法

### `collide(local_xform: Transform2D, with_shape: Shape2D, shape_xform: Transform2D) -> bool`

Returns `true` if this shape is colliding with another.
				This method needs the transformation matrix for this shape (`local_xform`), the shape to check collisions with (`with_shape`), and the transformation matrix of that shape (`shape_xform`).

### `collide_and_get_contacts(local_xform: Transform2D, with_shape: Shape2D, shape_xform: Transform2D) -> PackedVector2Array`

Returns a list of contact point pairs where this shape touches another.
				If there are no collisions, the returned list is empty. Otherwise, the returned list contains contact points arranged in pairs, with entries alternating between points on the boundary of this shape and points on the boundary of `with_shape`.
				A collision pair A, B can be used to calculate the collision normal with `(B - A).normalized()`, and the collision depth with `(B - A).length()`. This information is typically used to separate shapes, particularly in collision solvers.
				This method needs the transformation matrix for this shape (`local_xform`), the shape to check collisions with (`with_shape`), and the transformation matrix of that shape (`shape_xform`).

### `collide_with_motion(local_xform: Transform2D, local_motion: Vector2, with_shape: Shape2D, shape_xform: Transform2D, shape_motion: Vector2) -> bool`

Returns whether this shape would collide with another, if a given movement was applied.
				This method needs the transformation matrix for this shape (`local_xform`), the movement to test on this shape (`local_motion`), the shape to check collisions with (`with_shape`), the transformation matrix of that shape (`shape_xform`), and the movement to test onto the other object (`shape_motion`).

### `collide_with_motion_and_get_contacts(local_xform: Transform2D, local_motion: Vector2, with_shape: Shape2D, shape_xform: Transform2D, shape_motion: Vector2) -> PackedVector2Array`

Returns a list of contact point pairs where this shape would touch another, if a given movement was applied.
				If there would be no collisions, the returned list is empty. Otherwise, the returned list contains contact points arranged in pairs, with entries alternating between points on the boundary of this shape and points on the boundary of `with_shape`.
				A collision pair A, B can be used to calculate the collision normal with `(B - A).normalized()`, and the collision depth with `(B - A).length()`. This information is typically used to separate shapes, particularly in collision solvers.
				This method needs the transformation matrix for this shape (`local_xform`), the movement to test on this shape (`local_motion`), the shape to check collisions with (`with_shape`), the transformation matrix of that shape (`shape_xform`), and the movement to test onto the other object (`shape_motion`).

### `draw(canvas_item: RID, color: Color) -> void`

Draws a solid shape onto a `CanvasItem` with the `RenderingServer` API filled with the specified `color`. The exact drawing method is specific for each shape and cannot be configured.

### `get_rect() -> Rect2`
- 限定：qualifiers=const

Returns a `Rect2` representing the shapes boundary.

## 教程链接

- [Physics introduction](None)

