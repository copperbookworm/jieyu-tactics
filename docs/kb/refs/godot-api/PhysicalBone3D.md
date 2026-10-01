# PhysicalBone3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`PhysicalBone3D` → `PhysicsBody3D` → `CollisionObject3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core · keywords=ragdoll
> 自动生成，勿手改。文件：`refs/godot-api/PhysicalBone3D.md`

**摘要**：A physics body used to make bones in a `Skeleton3D` react to physics.

## 描述

The `PhysicalBone3D` node is a physics body that can be used to make bones in a `Skeleton3D` react to physics.
		**Note:** In order to detect physical bones with raycasts, the `SkeletonModifier3D.active` property of the parent `PhysicalBoneSimulator3D` must be `true` and the `Skeleton3D`'s bone must be assigned to `PhysicalBone3D` correctly; it means that `get_bone_id` should return a valid id (`>= 0`).

## 属性

- **`angular_damp`** `float` = `0.0`
  - 其它属性：getter=get_angular_damp · setter=set_angular_damp
- **`angular_damp_mode`** `int` = `0` · 枚举 `PhysicalBone3D.DampMode`
  - 其它属性：getter=get_angular_damp_mode · setter=set_angular_damp_mode
- **`angular_velocity`** `Vector3` = `Vector3(0, 0, 0)`
  - 其它属性：getter=get_angular_velocity · setter=set_angular_velocity
- **`body_offset`** `Transform3D` = `Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0)`
  - 其它属性：getter=get_body_offset · setter=set_body_offset
- **`bounce`** `float` = `0.0`
  - 其它属性：getter=get_bounce · setter=set_bounce
- **`can_sleep`** `bool` = `true`
  - 其它属性：getter=is_able_to_sleep · setter=set_can_sleep
- **`custom_integrator`** `bool` = `false`
  - 其它属性：getter=is_using_custom_integrator · setter=set_use_custom_integrator
- **`friction`** `float` = `1.0`
  - 其它属性：getter=get_friction · setter=set_friction
- **`gravity_scale`** `float` = `1.0`
  - 其它属性：getter=get_gravity_scale · setter=set_gravity_scale
- **`joint_offset`** `Transform3D` = `Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0)`
  - 其它属性：getter=get_joint_offset · setter=set_joint_offset
- **`joint_rotation`** `Vector3` = `Vector3(0, 0, 0)`
  - 其它属性：getter=get_joint_rotation · setter=set_joint_rotation
- **`joint_type`** `int` = `0` · 枚举 `PhysicalBone3D.JointType`
  - 其它属性：getter=get_joint_type · setter=set_joint_type
- **`linear_damp`** `float` = `0.0`
  - 其它属性：getter=get_linear_damp · setter=set_linear_damp
- **`linear_damp_mode`** `int` = `0` · 枚举 `PhysicalBone3D.DampMode`
  - 其它属性：getter=get_linear_damp_mode · setter=set_linear_damp_mode
- **`linear_velocity`** `Vector3` = `Vector3(0, 0, 0)`
  - 其它属性：getter=get_linear_velocity · setter=set_linear_velocity
- **`mass`** `float` = `1.0`
  - 其它属性：getter=get_mass · setter=set_mass

## 方法

### `_integrate_forces(state: PhysicsDirectBodyState3D) -> void`
- 限定：qualifiers=virtual

Called during physics processing, allowing you to read and safely modify the simulation state for the object. By default, it is called before the standard force integration, but the `custom_integrator` property allows you to disable the standard force integration and do fully custom force integration for a body.

### `apply_central_impulse(impulse: Vector3) -> void`

Applies a directional impulse without affecting rotation.
				An impulse is time-independent! Applying an impulse every frame would result in a framerate-dependent force. For this reason, it should only be used when simulating one-time impacts (use the "_integrate_forces" functions otherwise).
				This is equivalent to using `apply_impulse` at the body's center of mass.

### `apply_impulse(impulse: Vector3, position: Vector3 = Vector3(0, 0, 0)) -> void`

Applies a positioned impulse to the PhysicsBone3D.
				An impulse is time-independent! Applying an impulse every frame would result in a framerate-dependent force. For this reason, it should only be used when simulating one-time impacts (use the "_integrate_forces" functions otherwise).
				`position` is the offset from the PhysicsBone3D origin in global coordinates.

### `get_bone_id() -> int`
- 限定：qualifiers=const

Returns the unique identifier of the PhysicsBone3D.

### `get_simulate_physics() -> bool`

Returns `true` if the PhysicsBone3D is allowed to simulate physics.

### `is_simulating_physics() -> bool`

Returns `true` if the PhysicsBone3D is currently simulating physics.

## 枚举

### `DampMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `DAMP_MODE_COMBINE` |  |
| `1` | `DAMP_MODE_REPLACE` |  |

### `JointType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `JOINT_TYPE_NONE` |  |
| `1` | `JOINT_TYPE_PIN` |  |
| `2` | `JOINT_TYPE_CONE` |  |
| `3` | `JOINT_TYPE_HINGE` |  |
| `4` | `JOINT_TYPE_SLIDER` |  |
| `5` | `JOINT_TYPE_6DOF` |  |

## 教程链接

- [Ragdoll System](None)

