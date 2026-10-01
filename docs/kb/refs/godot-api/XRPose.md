# XRPose

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`XRPose` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/XRPose.md`

**摘要**：This object contains all data related to a pose on a tracked object.

## 描述

XR runtimes often identify multiple locations on devices such as controllers that are spatially tracked.
		Orientation, location, linear velocity and angular velocity are all provided for each pose by the XR runtime. This object contains this state of a pose.

## 属性

- **`angular_velocity`** `Vector3` = `Vector3(0, 0, 0)`
  - 其它属性：getter=get_angular_velocity · setter=set_angular_velocity
- **`has_tracking_data`** `bool` = `false`
  - 其它属性：getter=get_has_tracking_data · setter=set_has_tracking_data
- **`linear_velocity`** `Vector3` = `Vector3(0, 0, 0)`
  - 其它属性：getter=get_linear_velocity · setter=set_linear_velocity
- **`name`** `StringName` = `&""`
  - 其它属性：getter=get_name · setter=set_name
- **`tracking_confidence`** `int` = `0` · 枚举 `XRPose.TrackingConfidence`
  - 其它属性：getter=get_tracking_confidence · setter=set_tracking_confidence
- **`transform`** `Transform3D` = `Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0)`
  - 其它属性：getter=get_transform · setter=set_transform

## 方法

### `get_adjusted_transform() -> Transform3D`
- 限定：qualifiers=const

Returns the `transform` with world scale and our reference frame applied. This is the transform used to position `XRNode3D` objects.

## 枚举

### `TrackingConfidence`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `XR_TRACKING_CONFIDENCE_NONE` |  |
| `1` | `XR_TRACKING_CONFIDENCE_LOW` |  |
| `2` | `XR_TRACKING_CONFIDENCE_HIGH` |  |

## 教程链接

- [XR documentation index](None)

