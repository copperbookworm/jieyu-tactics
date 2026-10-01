# KinematicCollision2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`KinematicCollision2D` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/KinematicCollision2D.md`

**摘要**：Holds collision data from the movement of a `PhysicsBody2D`.

## 描述

Holds collision data from the movement of a `PhysicsBody2D`, usually from `PhysicsBody2D.move_and_collide`. When a `PhysicsBody2D` is moved, it stops if it detects a collision with another body. If a collision is detected, a `KinematicCollision2D` object is returned.
		The collision data includes the colliding object, the remaining motion, and the collision position. This data can be used to determine a custom response to the collision.

## 方法

### `get_angle(up_direction: Vector2 = Vector2(0, -1)) -> float`
- 限定：qualifiers=const

Returns the collision angle according to `up_direction`, which is `Vector2.UP` by default. This value is always positive.

### `get_collider() -> Object`
- 限定：qualifiers=const

Returns the colliding body's attached `Object`.

### `get_collider_id() -> int`
- 限定：qualifiers=const

Returns the unique instance ID of the colliding body's attached `Object`. See `Object.get_instance_id`.

### `get_collider_rid() -> RID`
- 限定：qualifiers=const

Returns the colliding body's `RID` used by the `PhysicsServer2D`.

### `get_collider_shape() -> Object`
- 限定：qualifiers=const

Returns the colliding body's shape.

### `get_collider_shape_index() -> int`
- 限定：qualifiers=const

Returns the colliding body's shape index. See `CollisionObject2D`.

### `get_collider_velocity() -> Vector2`
- 限定：qualifiers=const

Returns the colliding body's velocity.

### `get_depth() -> float`
- 限定：qualifiers=const

Returns the colliding body's length of overlap along the collision normal.

### `get_local_shape() -> Object`
- 限定：qualifiers=const

Returns the moving object's colliding shape.

### `get_normal() -> Vector2`
- 限定：qualifiers=const

Returns the colliding body's shape's normal at the point of collision.

### `get_position() -> Vector2`
- 限定：qualifiers=const

Returns the point of collision in global coordinates.

### `get_remainder() -> Vector2`
- 限定：qualifiers=const

Returns the moving object's remaining movement vector.

### `get_travel() -> Vector2`
- 限定：qualifiers=const

Returns the moving object's travel before collision.

