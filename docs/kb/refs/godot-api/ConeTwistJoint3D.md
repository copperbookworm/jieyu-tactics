# ConeTwistJoint3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ConeTwistJoint3D` → `Joint3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/ConeTwistJoint3D.md`

**摘要**：A physics joint that connects two 3D physics bodies in a way that simulates a ball-and-socket joint.

## 描述

A physics joint that connects two 3D physics bodies in a way that simulates a ball-and-socket joint. The twist axis is initiated as the X axis of the `ConeTwistJoint3D`. Once the physics bodies swing, the twist axis is calculated as the middle of the X axes of the joint in the local space of the two physics bodies. Useful for limbs like shoulders and hips, lamps hanging off a ceiling, etc.

## 属性

- **`bias`** `float` = `0.3`
  - 其它属性：getter=get_param · setter=set_param
- **`relaxation`** `float` = `1.0`
  - 其它属性：getter=get_param · setter=set_param
- **`softness`** `float` = `0.8`
  - 其它属性：getter=get_param · setter=set_param
- **`swing_span`** `float` = `0.7853982`
  - 其它属性：getter=get_param · setter=set_param
- **`twist_span`** `float` = `3.1415927`
  - 其它属性：getter=get_param · setter=set_param

## 方法

### `get_param(param: int) -> float`
- 限定：qualifiers=const

Returns the value of the specified parameter.

### `set_param(param: int, value: float) -> void`

Sets the value of the specified parameter.

## 枚举

### `Param`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `PARAM_SWING_SPAN` |  |
| `1` | `PARAM_TWIST_SPAN` |  |
| `2` | `PARAM_BIAS` |  |
| `3` | `PARAM_SOFTNESS` |  |
| `4` | `PARAM_RELAXATION` |  |
| `5` | `PARAM_MAX` |  |

