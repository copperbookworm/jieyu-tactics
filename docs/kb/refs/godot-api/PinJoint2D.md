# PinJoint2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`PinJoint2D` → `Joint2D` → `Node2D` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/PinJoint2D.md`

**摘要**：A physics joint that attaches two 2D physics bodies at a single point, allowing them to freely rotate.

## 描述

A physics joint that attaches two 2D physics bodies at a single point, allowing them to freely rotate. For example, a `RigidBody2D` can be attached to a `StaticBody2D` to create a pendulum or a seesaw.

## 属性

- **`angular_limit_enabled`** `bool` = `false`
  - 其它属性：getter=is_angular_limit_enabled · setter=set_angular_limit_enabled
- **`angular_limit_lower`** `float` = `0.0`
  - 其它属性：getter=get_angular_limit_lower · setter=set_angular_limit_lower
- **`angular_limit_upper`** `float` = `0.0`
  - 其它属性：getter=get_angular_limit_upper · setter=set_angular_limit_upper
- **`motor_enabled`** `bool` = `false`
  - 其它属性：getter=is_motor_enabled · setter=set_motor_enabled
- **`motor_target_velocity`** `float` = `0.0`
  - 其它属性：getter=get_motor_target_velocity · setter=set_motor_target_velocity
- **`softness`** `float` = `0.0`
  - 其它属性：getter=get_softness · setter=set_softness

