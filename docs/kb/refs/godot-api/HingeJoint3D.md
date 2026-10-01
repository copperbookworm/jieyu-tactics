# HingeJoint3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`HingeJoint3D` → `Joint3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/HingeJoint3D.md`

**摘要**：A physics joint that restricts the rotation of a 3D physics body around an axis relative to another physics body.

## 描述

A physics joint that restricts the rotation of a 3D physics body around an axis relative to another physics body. For example, Body A can be a `StaticBody3D` representing a door hinge that a `RigidBody3D` rotates around.

## 属性

- **`angular_limit/bias`** `float` = `0.3`
  - 其它属性：getter=get_param · setter=set_param
- **`angular_limit/enable`** `bool` = `false`
  - 其它属性：getter=get_flag · setter=set_flag
- **`angular_limit/lower`** `float` = `-1.5707964`
  - 其它属性：getter=get_param · setter=set_param
- **`angular_limit/relaxation`** `float` = `1.0`
  - 其它属性：getter=get_param · setter=set_param
- **`angular_limit/softness`** `float` = `0.9`
  - 其它属性：deprecated=This property is never set by the engine and is kept for compatibility purposes. · getter=get_param · setter=set_param
- **`angular_limit/upper`** `float` = `1.5707964`
  - 其它属性：getter=get_param · setter=set_param
- **`motor/enable`** `bool` = `false`
  - 其它属性：getter=get_flag · setter=set_flag
- **`motor/max_impulse`** `float` = `1.0`
  - 其它属性：getter=get_param · setter=set_param
- **`motor/target_velocity`** `float` = `1.0`
  - 其它属性：getter=get_param · setter=set_param
- **`params/bias`** `float` = `0.3`
  - 其它属性：getter=get_param · setter=set_param

## 方法

### `get_flag(flag: int) -> bool`
- 限定：qualifiers=const

Returns the value of the specified flag.

### `get_param(param: int) -> float`
- 限定：qualifiers=const

Returns the value of the specified parameter.

### `set_flag(flag: int, enabled: bool) -> void`

If `true`, enables the specified flag.

### `set_param(param: int, value: float) -> void`

Sets the value of the specified parameter.

## 枚举

### `Param`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `PARAM_BIAS` |  |
| `1` | `PARAM_LIMIT_UPPER` |  |
| `2` | `PARAM_LIMIT_LOWER` |  |
| `3` | `PARAM_LIMIT_BIAS` |  |
| `4` | `PARAM_LIMIT_SOFTNESS` |  |
| `5` | `PARAM_LIMIT_RELAXATION` |  |
| `6` | `PARAM_MOTOR_TARGET_VELOCITY` |  |
| `7` | `PARAM_MOTOR_MAX_IMPULSE` |  |
| `8` | `PARAM_MAX` |  |

### `Flag`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `FLAG_USE_LIMIT` |  |
| `1` | `FLAG_ENABLE_MOTOR` |  |
| `2` | `FLAG_MAX` |  |

