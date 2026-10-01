# KinematicCollision3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`KinematicCollision3D` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/KinematicCollision3D.md`

**摘要**：Holds collision data from the movement of a `PhysicsBody3D`.

## 描述

Holds collision data from the movement of a `PhysicsBody3D`, usually from `PhysicsBody3D.move_and_collide`. When a `PhysicsBody3D` is moved, it stops if it detects a collision with another body. If a collision is detected, a `KinematicCollision3D` object is returned.
		The collision data includes the colliding object, the remaining motion, and the collision position. This data can be used to determine a custom response to the collision.

## 方法

### `get_angle(collision_index: int = 0, up_direction: Vector3 = Vector3(0, 1, 0)) -> float`
- 限定：qualifiers=const

Returns the collision angle according to `up_direction`, which is `Vector3.UP` by default. This value is always positive.

### `get_collider(collision_index: int = 0) -> Object`
- 限定：qualifiers=const

Returns the colliding body's attached `Object` given a collision index (the deepest collision by default).

### `get_collider_id(collision_index: int = 0) -> int`
- 限定：qualifiers=const

Returns the unique instance ID of the colliding body's attached `Object` given a collision index (the deepest collision by default). See `Object.get_instance_id`.

### `get_collider_rid(collision_index: int = 0) -> RID`
- 限定：qualifiers=const

Returns the colliding body's `RID` used by the `PhysicsServer3D` given a collision index (the deepest collision by default).

### `get_collider_shape(collision_index: int = 0) -> Object`
- 限定：qualifiers=const

Returns the colliding body's shape given a collision index (the deepest collision by default).

### `get_collider_shape_index(collision_index: int = 0) -> int`
- 限定：qualifiers=const

Returns the colliding body's shape index given a collision index (the deepest collision by default). See `CollisionObject3D`.

### `get_collider_velocity(collision_index: int = 0) -> Vector3`
- 限定：qualifiers=const

Returns the colliding body's velocity given a collision index (the deepest collision by default).

### `get_collision_count() -> int`
- 限定：qualifiers=const

Returns the number of detected collisions.

### `get_depth() -> float`
- 限定：qualifiers=const

Returns the colliding body's length of overlap along the collision normal.

### `get_local_shape(collision_index: int = 0) -> Object`
- 限定：qualifiers=const

Returns the moving object's colliding shape given a collision index (the deepest collision by default).

### `get_normal(collision_index: int = 0) -> Vector3`
- 限定：qualifiers=const

Returns the colliding body's shape's normal at the point of collision given a collision index (the deepest collision by default).

### `get_position(collision_index: int = 0) -> Vector3`
- 限定：qualifiers=const

Returns the point of collision in global coordinates given a collision index (the deepest collision by default).

### `get_remainder() -> Vector3`
- 限定：qualifiers=const

Returns the moving object's remaining movement vector.

### `get_travel() -> Vector3`
- 限定：qualifiers=const

Returns the moving object's travel before collision.

