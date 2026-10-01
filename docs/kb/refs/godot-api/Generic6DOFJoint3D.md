# Generic6DOFJoint3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Generic6DOFJoint3D` → `Joint3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Generic6DOFJoint3D.md`

**摘要**：A physics joint that allows for complex movement and rotation between two 3D physics bodies.

## 描述

The `Generic6DOFJoint3D` (6 Degrees Of Freedom) joint allows for implementing custom types of joints by locking the rotation and translation of certain axes.
		The first 3 DOF represent the linear motion of the physics bodies and the last 3 DOF represent the angular motion of the physics bodies. Each axis can be either locked, or limited.

## 属性

- **`angular_limit_x/damping`** `float` = `1.0`
  - 其它属性：getter=get_param_x · setter=set_param_x
- **`angular_limit_x/enabled`** `bool` = `true`
  - 其它属性：getter=get_flag_x · setter=set_flag_x
- **`angular_limit_x/erp`** `float` = `0.5`
  - 其它属性：getter=get_param_x · setter=set_param_x
- **`angular_limit_x/force_limit`** `float` = `0.0`
  - 其它属性：getter=get_param_x · setter=set_param_x
- **`angular_limit_x/lower_angle`** `float` = `0.0`
  - 其它属性：getter=get_param_x · setter=set_param_x
- **`angular_limit_x/restitution`** `float` = `0.0`
  - 其它属性：getter=get_param_x · setter=set_param_x
- **`angular_limit_x/softness`** `float` = `0.5`
  - 其它属性：getter=get_param_x · setter=set_param_x
- **`angular_limit_x/upper_angle`** `float` = `0.0`
  - 其它属性：getter=get_param_x · setter=set_param_x
- **`angular_limit_y/damping`** `float` = `1.0`
  - 其它属性：getter=get_param_y · setter=set_param_y
- **`angular_limit_y/enabled`** `bool` = `true`
  - 其它属性：getter=get_flag_y · setter=set_flag_y
- **`angular_limit_y/erp`** `float` = `0.5`
  - 其它属性：getter=get_param_y · setter=set_param_y
- **`angular_limit_y/force_limit`** `float` = `0.0`
  - 其它属性：getter=get_param_y · setter=set_param_y
- **`angular_limit_y/lower_angle`** `float` = `0.0`
  - 其它属性：getter=get_param_y · setter=set_param_y
- **`angular_limit_y/restitution`** `float` = `0.0`
  - 其它属性：getter=get_param_y · setter=set_param_y
- **`angular_limit_y/softness`** `float` = `0.5`
  - 其它属性：getter=get_param_y · setter=set_param_y
- **`angular_limit_y/upper_angle`** `float` = `0.0`
  - 其它属性：getter=get_param_y · setter=set_param_y
- **`angular_limit_z/damping`** `float` = `1.0`
  - 其它属性：getter=get_param_z · setter=set_param_z
- **`angular_limit_z/enabled`** `bool` = `true`
  - 其它属性：getter=get_flag_z · setter=set_flag_z
- **`angular_limit_z/erp`** `float` = `0.5`
  - 其它属性：getter=get_param_z · setter=set_param_z
- **`angular_limit_z/force_limit`** `float` = `0.0`
  - 其它属性：getter=get_param_z · setter=set_param_z
- **`angular_limit_z/lower_angle`** `float` = `0.0`
  - 其它属性：getter=get_param_z · setter=set_param_z
- **`angular_limit_z/restitution`** `float` = `0.0`
  - 其它属性：getter=get_param_z · setter=set_param_z
- **`angular_limit_z/softness`** `float` = `0.5`
  - 其它属性：getter=get_param_z · setter=set_param_z
- **`angular_limit_z/upper_angle`** `float` = `0.0`
  - 其它属性：getter=get_param_z · setter=set_param_z
- **`angular_motor_x/enabled`** `bool` = `false`
  - 其它属性：getter=get_flag_x · setter=set_flag_x
- **`angular_motor_x/force_limit`** `float` = `300.0`
  - 其它属性：getter=get_param_x · setter=set_param_x
- **`angular_motor_x/target_velocity`** `float` = `0.0`
  - 其它属性：getter=get_param_x · setter=set_param_x
- **`angular_motor_y/enabled`** `bool` = `false`
  - 其它属性：getter=get_flag_y · setter=set_flag_y
- **`angular_motor_y/force_limit`** `float` = `300.0`
  - 其它属性：getter=get_param_y · setter=set_param_y
- **`angular_motor_y/target_velocity`** `float` = `0.0`
  - 其它属性：getter=get_param_y · setter=set_param_y
- **`angular_motor_z/enabled`** `bool` = `false`
  - 其它属性：getter=get_flag_z · setter=set_flag_z
- **`angular_motor_z/force_limit`** `float` = `300.0`
  - 其它属性：getter=get_param_z · setter=set_param_z
- **`angular_motor_z/target_velocity`** `float` = `0.0`
  - 其它属性：getter=get_param_z · setter=set_param_z
- **`angular_spring_x/damping`** `float` = `0.0`
  - 其它属性：getter=get_param_x · setter=set_param_x
- **`angular_spring_x/enabled`** `bool` = `false`
  - 其它属性：getter=get_flag_x · setter=set_flag_x
- **`angular_spring_x/equilibrium_point`** `float` = `0.0`
  - 其它属性：getter=get_param_x · setter=set_param_x
- **`angular_spring_x/stiffness`** `float` = `0.0`
  - 其它属性：getter=get_param_x · setter=set_param_x
- **`angular_spring_y/damping`** `float` = `0.0`
  - 其它属性：getter=get_param_y · setter=set_param_y
- **`angular_spring_y/enabled`** `bool` = `false`
  - 其它属性：getter=get_flag_y · setter=set_flag_y
- **`angular_spring_y/equilibrium_point`** `float` = `0.0`
  - 其它属性：getter=get_param_y · setter=set_param_y
- **`angular_spring_y/stiffness`** `float` = `0.0`
  - 其它属性：getter=get_param_y · setter=set_param_y
- **`angular_spring_z/damping`** `float` = `0.0`
  - 其它属性：getter=get_param_z · setter=set_param_z
- **`angular_spring_z/enabled`** `bool` = `false`
  - 其它属性：getter=get_flag_z · setter=set_flag_z
- **`angular_spring_z/equilibrium_point`** `float` = `0.0`
  - 其它属性：getter=get_param_z · setter=set_param_z
- **`angular_spring_z/stiffness`** `float` = `0.0`
  - 其它属性：getter=get_param_z · setter=set_param_z
- **`linear_limit_x/damping`** `float` = `1.0`
  - 其它属性：getter=get_param_x · setter=set_param_x
- **`linear_limit_x/enabled`** `bool` = `true`
  - 其它属性：getter=get_flag_x · setter=set_flag_x
- **`linear_limit_x/lower_distance`** `float` = `0.0`
  - 其它属性：getter=get_param_x · setter=set_param_x
- **`linear_limit_x/restitution`** `float` = `0.5`
  - 其它属性：getter=get_param_x · setter=set_param_x
- **`linear_limit_x/softness`** `float` = `0.7`
  - 其它属性：getter=get_param_x · setter=set_param_x
- **`linear_limit_x/upper_distance`** `float` = `0.0`
  - 其它属性：getter=get_param_x · setter=set_param_x
- **`linear_limit_y/damping`** `float` = `1.0`
  - 其它属性：getter=get_param_y · setter=set_param_y
- **`linear_limit_y/enabled`** `bool` = `true`
  - 其它属性：getter=get_flag_y · setter=set_flag_y
- **`linear_limit_y/lower_distance`** `float` = `0.0`
  - 其它属性：getter=get_param_y · setter=set_param_y
- **`linear_limit_y/restitution`** `float` = `0.5`
  - 其它属性：getter=get_param_y · setter=set_param_y
- **`linear_limit_y/softness`** `float` = `0.7`
  - 其它属性：getter=get_param_y · setter=set_param_y
- **`linear_limit_y/upper_distance`** `float` = `0.0`
  - 其它属性：getter=get_param_y · setter=set_param_y
- **`linear_limit_z/damping`** `float` = `1.0`
  - 其它属性：getter=get_param_z · setter=set_param_z
- **`linear_limit_z/enabled`** `bool` = `true`
  - 其它属性：getter=get_flag_z · setter=set_flag_z
- **`linear_limit_z/lower_distance`** `float` = `0.0`
  - 其它属性：getter=get_param_z · setter=set_param_z
- **`linear_limit_z/restitution`** `float` = `0.5`
  - 其它属性：getter=get_param_z · setter=set_param_z
- **`linear_limit_z/softness`** `float` = `0.7`
  - 其它属性：getter=get_param_z · setter=set_param_z
- **`linear_limit_z/upper_distance`** `float` = `0.0`
  - 其它属性：getter=get_param_z · setter=set_param_z
- **`linear_motor_x/enabled`** `bool` = `false`
  - 其它属性：getter=get_flag_x · setter=set_flag_x
- **`linear_motor_x/force_limit`** `float` = `0.0`
  - 其它属性：getter=get_param_x · setter=set_param_x
- **`linear_motor_x/target_velocity`** `float` = `0.0`
  - 其它属性：getter=get_param_x · setter=set_param_x
- **`linear_motor_y/enabled`** `bool` = `false`
  - 其它属性：getter=get_flag_y · setter=set_flag_y
- **`linear_motor_y/force_limit`** `float` = `0.0`
  - 其它属性：getter=get_param_y · setter=set_param_y
- **`linear_motor_y/target_velocity`** `float` = `0.0`
  - 其它属性：getter=get_param_y · setter=set_param_y
- **`linear_motor_z/enabled`** `bool` = `false`
  - 其它属性：getter=get_flag_z · setter=set_flag_z
- **`linear_motor_z/force_limit`** `float` = `0.0`
  - 其它属性：getter=get_param_z · setter=set_param_z
- **`linear_motor_z/target_velocity`** `float` = `0.0`
  - 其它属性：getter=get_param_z · setter=set_param_z
- **`linear_spring_x/damping`** `float` = `0.01`
  - 其它属性：getter=get_param_x · setter=set_param_x
- **`linear_spring_x/enabled`** `bool` = `false`
  - 其它属性：getter=get_flag_x · setter=set_flag_x
- **`linear_spring_x/equilibrium_point`** `float` = `0.0`
  - 其它属性：getter=get_param_x · setter=set_param_x
- **`linear_spring_x/stiffness`** `float` = `0.01`
  - 其它属性：getter=get_param_x · setter=set_param_x
- **`linear_spring_y/damping`** `float` = `0.01`
  - 其它属性：getter=get_param_y · setter=set_param_y
- **`linear_spring_y/enabled`** `bool` = `false`
  - 其它属性：getter=get_flag_y · setter=set_flag_y
- **`linear_spring_y/equilibrium_point`** `float` = `0.0`
  - 其它属性：getter=get_param_y · setter=set_param_y
- **`linear_spring_y/stiffness`** `float` = `0.01`
  - 其它属性：getter=get_param_y · setter=set_param_y
- **`linear_spring_z/damping`** `float` = `0.01`
  - 其它属性：getter=get_param_z · setter=set_param_z
- **`linear_spring_z/enabled`** `bool` = `false`
  - 其它属性：getter=get_flag_z · setter=set_flag_z
- **`linear_spring_z/equilibrium_point`** `float` = `0.0`
  - 其它属性：getter=get_param_z · setter=set_param_z
- **`linear_spring_z/stiffness`** `float` = `0.01`
  - 其它属性：getter=get_param_z · setter=set_param_z

## 方法

### `get_flag_x(flag: int) -> bool`
- 限定：qualifiers=const

### `get_flag_y(flag: int) -> bool`
- 限定：qualifiers=const

### `get_flag_z(flag: int) -> bool`
- 限定：qualifiers=const

### `get_param_x(param: int) -> float`
- 限定：qualifiers=const

### `get_param_y(param: int) -> float`
- 限定：qualifiers=const

### `get_param_z(param: int) -> float`
- 限定：qualifiers=const

### `set_flag_x(flag: int, value: bool) -> void`

### `set_flag_y(flag: int, value: bool) -> void`

### `set_flag_z(flag: int, value: bool) -> void`

### `set_param_x(param: int, value: float) -> void`

### `set_param_y(param: int, value: float) -> void`

### `set_param_z(param: int, value: float) -> void`

## 枚举

### `Param`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `PARAM_LINEAR_LOWER_LIMIT` |  |
| `1` | `PARAM_LINEAR_UPPER_LIMIT` |  |
| `2` | `PARAM_LINEAR_LIMIT_SOFTNESS` |  |
| `3` | `PARAM_LINEAR_RESTITUTION` |  |
| `4` | `PARAM_LINEAR_DAMPING` |  |
| `5` | `PARAM_LINEAR_MOTOR_TARGET_VELOCITY` |  |
| `6` | `PARAM_LINEAR_MOTOR_FORCE_LIMIT` |  |
| `7` | `PARAM_LINEAR_SPRING_STIFFNESS` |  |
| `8` | `PARAM_LINEAR_SPRING_DAMPING` |  |
| `9` | `PARAM_LINEAR_SPRING_EQUILIBRIUM_POINT` |  |
| `10` | `PARAM_ANGULAR_LOWER_LIMIT` |  |
| `11` | `PARAM_ANGULAR_UPPER_LIMIT` |  |
| `12` | `PARAM_ANGULAR_LIMIT_SOFTNESS` |  |
| `13` | `PARAM_ANGULAR_DAMPING` |  |
| `14` | `PARAM_ANGULAR_RESTITUTION` |  |
| `15` | `PARAM_ANGULAR_FORCE_LIMIT` |  |
| `16` | `PARAM_ANGULAR_ERP` |  |
| `17` | `PARAM_ANGULAR_MOTOR_TARGET_VELOCITY` |  |
| `18` | `PARAM_ANGULAR_MOTOR_FORCE_LIMIT` |  |
| `19` | `PARAM_ANGULAR_SPRING_STIFFNESS` |  |
| `20` | `PARAM_ANGULAR_SPRING_DAMPING` |  |
| `21` | `PARAM_ANGULAR_SPRING_EQUILIBRIUM_POINT` |  |
| `22` | `PARAM_MAX` |  |

### `Flag`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `FLAG_ENABLE_LINEAR_LIMIT` |  |
| `1` | `FLAG_ENABLE_ANGULAR_LIMIT` |  |
| `3` | `FLAG_ENABLE_LINEAR_SPRING` |  |
| `2` | `FLAG_ENABLE_ANGULAR_SPRING` |  |
| `4` | `FLAG_ENABLE_MOTOR` |  |
| `5` | `FLAG_ENABLE_LINEAR_MOTOR` |  |
| `6` | `FLAG_MAX` |  |

