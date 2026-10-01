# VehicleWheel3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VehicleWheel3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VehicleWheel3D.md`

**摘要**：A 3D physics body for a `VehicleBody3D` that simulates the behavior of a wheel.

## 描述

A node used as a child of a `VehicleBody3D` parent to simulate the behavior of one of its wheels. This node also acts as a collider to detect if the wheel is touching a surface.
		**Note:** This class has known issues and isn't designed to provide realistic 3D vehicle physics. If you want advanced vehicle physics, you may need to write your own physics integration using another `PhysicsBody3D` class.

## 属性

- **`brake`** `float` = `0.0`
  - 其它属性：getter=get_brake · setter=set_brake
- **`damping_compression`** `float` = `0.83`
  - 其它属性：getter=get_damping_compression · setter=set_damping_compression
- **`damping_relaxation`** `float` = `0.88`
  - 其它属性：getter=get_damping_relaxation · setter=set_damping_relaxation
- **`engine_force`** `float` = `0.0`
  - 其它属性：getter=get_engine_force · setter=set_engine_force
- **`physics_interpolation_mode`** `int` = `2` · 枚举 `Node.PhysicsInterpolationMode`
  - 其它属性：getter=get_physics_interpolation_mode · overrides=Node · setter=set_physics_interpolation_mode
- **`steering`** `float` = `0.0`
  - 其它属性：getter=get_steering · setter=set_steering
- **`suspension_max_force`** `float` = `6000.0`
  - 其它属性：getter=get_suspension_max_force · setter=set_suspension_max_force
- **`suspension_stiffness`** `float` = `5.88`
  - 其它属性：getter=get_suspension_stiffness · setter=set_suspension_stiffness
- **`suspension_travel`** `float` = `0.2`
  - 其它属性：getter=get_suspension_travel · setter=set_suspension_travel
- **`use_as_steering`** `bool` = `false`
  - 其它属性：getter=is_used_as_steering · setter=set_use_as_steering
- **`use_as_traction`** `bool` = `false`
  - 其它属性：getter=is_used_as_traction · setter=set_use_as_traction
- **`wheel_friction_slip`** `float` = `10.5`
  - 其它属性：getter=get_friction_slip · setter=set_friction_slip
- **`wheel_radius`** `float` = `0.5`
  - 其它属性：getter=get_radius · setter=set_radius
- **`wheel_rest_length`** `float` = `0.15`
  - 其它属性：getter=get_suspension_rest_length · setter=set_suspension_rest_length
- **`wheel_roll_influence`** `float` = `0.1`
  - 其它属性：getter=get_roll_influence · setter=set_roll_influence

## 方法

### `get_contact_body() -> Node3D`
- 限定：qualifiers=const

Returns the contacting body node if valid in the tree, as `Node3D`. At the moment, `GridMap` is not supported so the node will be always of type `PhysicsBody3D`.
				Returns `null` if the wheel is not in contact with a surface, or the contact body is not a `PhysicsBody3D`.

### `get_contact_normal() -> Vector3`
- 限定：qualifiers=const

Returns the normal of the suspension's collision in world space if the wheel is in contact. If the wheel isn't in contact with anything, returns a vector pointing directly along the suspension axis toward the vehicle in world space.

### `get_contact_point() -> Vector3`
- 限定：qualifiers=const

Returns the point of the suspension's collision in world space if the wheel is in contact. If the wheel isn't in contact with anything, returns the maximum point of the wheel's ray cast in world space, which is defined by `wheel_rest_length + wheel_radius`.

### `get_rpm() -> float`
- 限定：qualifiers=const

Returns the rotational speed of the wheel in revolutions per minute.

### `get_skidinfo() -> float`
- 限定：qualifiers=const

Returns a value between 0.0 and 1.0 that indicates whether this wheel is skidding. 0.0 is skidding (the wheel has lost grip, e.g. icy terrain), 1.0 means not skidding (the wheel has full grip, e.g. dry asphalt road).

### `is_in_contact() -> bool`
- 限定：qualifiers=const

Returns `true` if this wheel is in contact with a surface.

## 教程链接

- [3D Truck Town Demo](None)

