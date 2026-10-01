# PinJoint3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`PinJoint3D` → `Joint3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/PinJoint3D.md`

**摘要**：A physics joint that attaches two 3D physics bodies at a single point, allowing them to freely rotate.

## 描述

A physics joint that attaches two 3D physics bodies at a single point, allowing them to freely rotate. For example, a `RigidBody3D` can be attached to a `StaticBody3D` to create a pendulum or a seesaw.

## 属性

- **`params/bias`** `float` = `0.3`
  - 其它属性：getter=get_param · setter=set_param
- **`params/damping`** `float` = `1.0`
  - 其它属性：getter=get_param · setter=set_param
- **`params/impulse_clamp`** `float` = `0.0`
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
| `0` | `PARAM_BIAS` |  |
| `1` | `PARAM_DAMPING` |  |
| `2` | `PARAM_IMPULSE_CLAMP` |  |

