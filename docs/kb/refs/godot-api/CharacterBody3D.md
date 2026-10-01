# CharacterBody3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`CharacterBody3D` → `PhysicsBody3D` → `CollisionObject3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/CharacterBody3D.md`

**摘要**：A 3D physics body specialized for characters moved by script.

## 描述

`CharacterBody3D` is a specialized class for physics bodies that are meant to be user-controlled. They are not affected by physics at all, but they affect other physics bodies in their path. They are mainly used to provide high-level API to move objects with wall and slope detection (`move_and_slide` method) in addition to the general collision detection provided by `PhysicsBody3D.move_and_collide`. This makes it useful for highly configurable physics bodies that must move in specific ways and collide with the world, as is often the case with user-controlled characters.
		For game objects that don't require complex movement or collision detection, such as moving platforms, `AnimatableBody3D` is simpler to configure.

## 属性

- **`floor_block_on_wall`** `bool` = `true`
  - 其它属性：getter=is_floor_block_on_wall_enabled · setter=set_floor_block_on_wall_enabled
- **`floor_constant_speed`** `bool` = `false`
  - 其它属性：getter=is_floor_constant_speed_enabled · setter=set_floor_constant_speed_enabled
- **`floor_max_angle`** `float` = `0.7853982`
  - 其它属性：getter=get_floor_max_angle · setter=set_floor_max_angle
- **`floor_snap_length`** `float` = `0.1`
  - 其它属性：getter=get_floor_snap_length · setter=set_floor_snap_length
- **`floor_stop_on_slope`** `bool` = `true`
  - 其它属性：getter=is_floor_stop_on_slope_enabled · setter=set_floor_stop_on_slope_enabled
- **`max_slides`** `int` = `6`
  - 其它属性：getter=get_max_slides · setter=set_max_slides
- **`motion_mode`** `int` = `0` · 枚举 `CharacterBody3D.MotionMode`
  - 其它属性：getter=get_motion_mode · setter=set_motion_mode
- **`platform_floor_layers`** `int` = `4294967295`
  - 其它属性：getter=get_platform_floor_layers · setter=set_platform_floor_layers
- **`platform_on_leave`** `int` = `0` · 枚举 `CharacterBody3D.PlatformOnLeave`
  - 其它属性：getter=get_platform_on_leave · setter=set_platform_on_leave
- **`platform_wall_layers`** `int` = `0`
  - 其它属性：getter=get_platform_wall_layers · setter=set_platform_wall_layers
- **`safe_margin`** `float` = `0.001`
  - 其它属性：getter=get_safe_margin · setter=set_safe_margin
- **`slide_on_ceiling`** `bool` = `true`
  - 其它属性：getter=is_slide_on_ceiling_enabled · setter=set_slide_on_ceiling_enabled
- **`up_direction`** `Vector3` = `Vector3(0, 1, 0)`
  - 其它属性：getter=get_up_direction · setter=set_up_direction
- **`velocity`** `Vector3` = `Vector3(0, 0, 0)`
  - 其它属性：getter=get_velocity · setter=set_velocity
- **`wall_min_slide_angle`** `float` = `0.2617994`
  - 其它属性：getter=get_wall_min_slide_angle · setter=set_wall_min_slide_angle

## 方法

### `apply_floor_snap() -> void`

Allows to manually apply a snap to the floor regardless of the body's velocity. This function does nothing when `is_on_floor` returns `true`.

### `get_floor_angle(up_direction: Vector3 = Vector3(0, 1, 0)) -> float`
- 限定：qualifiers=const

Returns the floor's collision angle at the last collision point according to `up_direction`, which is `Vector3.UP` by default. This value is always positive and only valid after calling `move_and_slide` and when `is_on_floor` returns `true`.

### `get_floor_normal() -> Vector3`
- 限定：qualifiers=const

Returns the collision normal of the floor at the last collision point. Only valid after calling `move_and_slide` and when `is_on_floor` returns `true`.
				**Warning:** The collision normal is not always the same as the surface normal.

### `get_last_motion() -> Vector3`
- 限定：qualifiers=const

Returns the last motion applied to the `CharacterBody3D` during the last call to `move_and_slide`. The movement can be split into multiple motions when sliding occurs, and this method return the last one, which is useful to retrieve the current direction of the movement.

### `get_last_slide_collision() -> KinematicCollision3D`

Returns a `KinematicCollision3D` if a collision occurred. The returned value contains information about the latest collision that occurred during the last call to `move_and_slide`. Returns `null` if no collision occurred. See also `get_slide_collision`.

### `get_platform_angular_velocity() -> Vector3`
- 限定：qualifiers=const

Returns the angular velocity of the platform at the last collision point. Only valid after calling `move_and_slide`.

### `get_platform_velocity() -> Vector3`
- 限定：qualifiers=const

Returns the linear velocity of the platform at the last collision point. Only valid after calling `move_and_slide`.

### `get_position_delta() -> Vector3`
- 限定：qualifiers=const

Returns the travel (position delta) that occurred during the last call to `move_and_slide`.

### `get_real_velocity() -> Vector3`
- 限定：qualifiers=const

Returns the current real velocity since the last call to `move_and_slide`. For example, when you climb a slope, you will move diagonally even though the velocity is horizontal. This method returns the diagonal movement, as opposed to `velocity` which returns the requested velocity.

### `get_slide_collision(slide_idx: int) -> KinematicCollision3D`

Returns a `KinematicCollision3D`, which contains information about a collision that occurred during the last call to `move_and_slide`. Since the body can collide several times in a single call to `move_and_slide`, you must specify the index of the collision in the range 0 to (`get_slide_collision_count` - 1). See also `get_last_slide_collision`.

### `get_slide_collision_count() -> int`
- 限定：qualifiers=const

Returns the number of times the body collided and changed direction during the last call to `move_and_slide`.

### `get_wall_normal() -> Vector3`
- 限定：qualifiers=const

Returns the collision normal of the wall at the last collision point. Only valid after calling `move_and_slide` and when `is_on_wall` returns `true`.
				**Warning:** The collision normal is not always the same as the surface normal.

### `is_on_ceiling() -> bool`
- 限定：qualifiers=const

Returns `true` if the body collided with the ceiling on the last call of `move_and_slide`. Otherwise, returns `false`. The `up_direction` and `floor_max_angle` are used to determine whether a surface is "ceiling" or not.

### `is_on_ceiling_only() -> bool`
- 限定：qualifiers=const

Returns `true` if the body collided only with the ceiling on the last call of `move_and_slide`. Otherwise, returns `false`. The `up_direction` and `floor_max_angle` are used to determine whether a surface is "ceiling" or not.

### `is_on_floor() -> bool`
- 限定：qualifiers=const

Returns `true` if the body collided with the floor on the last call of `move_and_slide`. Otherwise, returns `false`. The `up_direction` and `floor_max_angle` are used to determine whether a surface is "floor" or not.

### `is_on_floor_only() -> bool`
- 限定：qualifiers=const

Returns `true` if the body collided only with the floor on the last call of `move_and_slide`. Otherwise, returns `false`. The `up_direction` and `floor_max_angle` are used to determine whether a surface is "floor" or not.

### `is_on_wall() -> bool`
- 限定：qualifiers=const

Returns `true` if the body collided with a wall on the last call of `move_and_slide`. Otherwise, returns `false`. The `up_direction` and `floor_max_angle` are used to determine whether a surface is "wall" or not.

### `is_on_wall_only() -> bool`
- 限定：qualifiers=const

Returns `true` if the body collided only with a wall on the last call of `move_and_slide`. Otherwise, returns `false`. The `up_direction` and `floor_max_angle` are used to determine whether a surface is "wall" or not.

### `move_and_slide() -> bool`

Moves the body based on `velocity`. If the body collides with another, it will slide along the other body rather than stop immediately. If the other body is a `CharacterBody3D` or `RigidBody3D`, it will also be affected by the motion of the other body. You can use this to make moving and rotating platforms, or to make nodes push other nodes.
				This method should be used in `Node._physics_process` (or in a method called by `Node._physics_process`), as it uses the physics step's `delta` value automatically in calculations. Otherwise, the simulation will run at an incorrect speed.
				Modifies `velocity` if a slide collision occurred. To get the latest collision call `get_last_slide_collision`, for more detailed information about collisions that occurred, use `get_slide_collision`.
				When the body touches a moving platform, the platform's velocity is automatically added to the body motion. If a collision occurs due to the platform's motion, it will always be first in the slide collisions.
				Returns `true` if the body collided, otherwise, returns `false`.

## 枚举

### `MotionMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `MOTION_MODE_GROUNDED` |  |
| `1` | `MOTION_MODE_FLOATING` |  |

### `PlatformOnLeave`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `PLATFORM_ON_LEAVE_ADD_VELOCITY` |  |
| `1` | `PLATFORM_ON_LEAVE_ADD_UPWARD_VELOCITY` |  |
| `2` | `PLATFORM_ON_LEAVE_DO_NOTHING` |  |

## 教程链接

- [Physics introduction](None)
- [Troubleshooting physics issues](None)
- [Kinematic character (2D)](None)
- [3D Kinematic Character Demo](None)
- [3D Platformer Demo](None)
- [3D Voxel Demo](None)
- [Third Person Shooter (TPS) Demo](None)

