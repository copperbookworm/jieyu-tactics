# SliderJoint3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`SliderJoint3D` → `Joint3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/SliderJoint3D.md`

**摘要**：A physics joint that restricts the movement of a 3D physics body along an axis relative to another physics body.

## 描述

A physics joint that restricts the movement of a 3D physics body along an axis relative to another physics body. For example, Body A could be a `StaticBody3D` representing a piston base, while Body B could be a `RigidBody3D` representing the piston head, moving up and down.

## 属性

- **`angular_limit/damping`** `float` = `0.0`
  - 其它属性：getter=get_param · setter=set_param
- **`angular_limit/lower_angle`** `float` = `0.0`
  - 其它属性：getter=get_param · setter=set_param
- **`angular_limit/restitution`** `float` = `0.7`
  - 其它属性：getter=get_param · setter=set_param
- **`angular_limit/softness`** `float` = `1.0`
  - 其它属性：getter=get_param · setter=set_param
- **`angular_limit/upper_angle`** `float` = `0.0`
  - 其它属性：getter=get_param · setter=set_param
- **`angular_motion/damping`** `float` = `1.0`
  - 其它属性：getter=get_param · setter=set_param
- **`angular_motion/restitution`** `float` = `0.7`
  - 其它属性：getter=get_param · setter=set_param
- **`angular_motion/softness`** `float` = `1.0`
  - 其它属性：getter=get_param · setter=set_param
- **`angular_ortho/damping`** `float` = `1.0`
  - 其它属性：getter=get_param · setter=set_param
- **`angular_ortho/restitution`** `float` = `0.7`
  - 其它属性：getter=get_param · setter=set_param
- **`angular_ortho/softness`** `float` = `1.0`
  - 其它属性：getter=get_param · setter=set_param
- **`linear_limit/damping`** `float` = `1.0`
  - 其它属性：getter=get_param · setter=set_param
- **`linear_limit/lower_distance`** `float` = `-1.0`
  - 其它属性：getter=get_param · setter=set_param
- **`linear_limit/restitution`** `float` = `0.7`
  - 其它属性：getter=get_param · setter=set_param
- **`linear_limit/softness`** `float` = `1.0`
  - 其它属性：getter=get_param · setter=set_param
- **`linear_limit/upper_distance`** `float` = `1.0`
  - 其它属性：getter=get_param · setter=set_param
- **`linear_motion/damping`** `float` = `0.0`
  - 其它属性：getter=get_param · setter=set_param
- **`linear_motion/restitution`** `float` = `0.7`
  - 其它属性：getter=get_param · setter=set_param
- **`linear_motion/softness`** `float` = `1.0`
  - 其它属性：getter=get_param · setter=set_param
- **`linear_ortho/damping`** `float` = `1.0`
  - 其它属性：getter=get_param · setter=set_param
- **`linear_ortho/restitution`** `float` = `0.7`
  - 其它属性：getter=get_param · setter=set_param
- **`linear_ortho/softness`** `float` = `1.0`
  - 其它属性：getter=get_param · setter=set_param

## 方法

### `get_param(param: int) -> float`
- 限定：qualifiers=const

Returns the value of the given parameter.

### `set_param(param: int, value: float) -> void`

Assigns `value` to the given parameter.

## 枚举

### `Param`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `PARAM_LINEAR_LIMIT_UPPER` |  |
| `1` | `PARAM_LINEAR_LIMIT_LOWER` |  |
| `2` | `PARAM_LINEAR_LIMIT_SOFTNESS` |  |
| `3` | `PARAM_LINEAR_LIMIT_RESTITUTION` |  |
| `4` | `PARAM_LINEAR_LIMIT_DAMPING` |  |
| `5` | `PARAM_LINEAR_MOTION_SOFTNESS` |  |
| `6` | `PARAM_LINEAR_MOTION_RESTITUTION` |  |
| `7` | `PARAM_LINEAR_MOTION_DAMPING` |  |
| `8` | `PARAM_LINEAR_ORTHOGONAL_SOFTNESS` |  |
| `9` | `PARAM_LINEAR_ORTHOGONAL_RESTITUTION` |  |
| `10` | `PARAM_LINEAR_ORTHOGONAL_DAMPING` |  |
| `11` | `PARAM_ANGULAR_LIMIT_UPPER` |  |
| `12` | `PARAM_ANGULAR_LIMIT_LOWER` |  |
| `13` | `PARAM_ANGULAR_LIMIT_SOFTNESS` |  |
| `14` | `PARAM_ANGULAR_LIMIT_RESTITUTION` |  |
| `15` | `PARAM_ANGULAR_LIMIT_DAMPING` |  |
| `16` | `PARAM_ANGULAR_MOTION_SOFTNESS` |  |
| `17` | `PARAM_ANGULAR_MOTION_RESTITUTION` |  |
| `18` | `PARAM_ANGULAR_MOTION_DAMPING` |  |
| `19` | `PARAM_ANGULAR_ORTHOGONAL_SOFTNESS` |  |
| `20` | `PARAM_ANGULAR_ORTHOGONAL_RESTITUTION` |  |
| `21` | `PARAM_ANGULAR_ORTHOGONAL_DAMPING` |  |
| `22` | `PARAM_MAX` |  |

