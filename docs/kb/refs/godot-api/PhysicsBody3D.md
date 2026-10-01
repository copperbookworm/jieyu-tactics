# PhysicsBody3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`PhysicsBody3D` → `CollisionObject3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/PhysicsBody3D.md`

**摘要**：Abstract base class for 3D game objects affected by physics.

## 描述

`PhysicsBody3D` is an abstract base class for 3D game objects affected by physics. All 3D physics bodies inherit from it.
		**Warning:** With a non-uniform scale, this node will likely not behave as expected. It is advised to keep its scale the same on all axes and adjust its collision shape(s) instead.

## 属性

- **`axis_lock_angular_x`** `bool` = `false`
  - 其它属性：getter=get_axis_lock · setter=set_axis_lock
- **`axis_lock_angular_y`** `bool` = `false`
  - 其它属性：getter=get_axis_lock · setter=set_axis_lock
- **`axis_lock_angular_z`** `bool` = `false`
  - 其它属性：getter=get_axis_lock · setter=set_axis_lock
- **`axis_lock_linear_x`** `bool` = `false`
  - 其它属性：getter=get_axis_lock · setter=set_axis_lock
- **`axis_lock_linear_y`** `bool` = `false`
  - 其它属性：getter=get_axis_lock · setter=set_axis_lock
- **`axis_lock_linear_z`** `bool` = `false`
  - 其它属性：getter=get_axis_lock · setter=set_axis_lock

## 方法

### `add_collision_exception_with(body: Node) -> void`

Adds a body to the list of bodies that this body can't collide with.

### `get_axis_lock(axis: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the specified linear or rotational `axis` is locked.

### `get_collision_exceptions() -> PhysicsBody3D[]`

Returns an array of nodes that were added as collision exceptions for this body.

### `get_gravity() -> Vector3`
- 限定：qualifiers=const

Returns the gravity vector computed from all sources that can affect the body, including all gravity overrides from `Area3D` nodes and the global world gravity.

### `move_and_collide(motion: Vector3, test_only: bool = false, safe_margin: float = 0.001, recovery_as_collision: bool = false, max_collisions: int = 1) -> KinematicCollision3D`

Moves the body along the vector `motion`. In order to be frame rate independent in `Node._physics_process` or `Node._process`, `motion` should be computed using `delta`.
				The body will stop if it collides. Returns a `KinematicCollision3D`, which contains information about the collision when stopped, or when touching another body along the motion.
				If `test_only` is `true`, the body does not move but the would-be collision information is given.
				`safe_margin` is the extra margin used for collision recovery (see `CharacterBody3D.safe_margin` for more details).
				If `recovery_as_collision` is `true`, any depenetration from the recovery phase is also reported as a collision; this is used e.g. by `CharacterBody3D` for improving floor detection during floor snapping.
				`max_collisions` allows to retrieve more than one collision result.

### `remove_collision_exception_with(body: Node) -> void`

Removes a body from the list of bodies that this body can't collide with.

### `set_axis_lock(axis: int, lock: bool) -> void`

Locks or unlocks the specified linear or rotational `axis` depending on the value of `lock`.

### `test_move(from: Transform3D, motion: Vector3, collision: KinematicCollision3D = null, safe_margin: float = 0.001, recovery_as_collision: bool = false, max_collisions: int = 1) -> bool`
- 限定：keywords=check, collision, sweep

Checks for collisions without moving the body. In order to be frame rate independent in `Node._physics_process` or `Node._process`, `motion` should be computed using `delta`.
				Virtually sets the node's position, scale and rotation to that of the given `Transform3D`, then tries to move the body along the vector `motion`. Returns `true` if a collision would stop the body from moving along the whole path.
				`collision` is an optional object of type `KinematicCollision3D`, which contains additional information about the collision when stopped, or when touching another body along the motion.
				`safe_margin` is the extra margin used for collision recovery (see `CharacterBody3D.safe_margin` for more details).
				If `recovery_as_collision` is `true`, any depenetration from the recovery phase is also reported as a collision; this is useful for checking whether the body would *touch* any other bodies.
				`max_collisions` allows to retrieve more than one collision result.

## 教程链接

- [Physics introduction](None)
- [Troubleshooting physics issues](None)

