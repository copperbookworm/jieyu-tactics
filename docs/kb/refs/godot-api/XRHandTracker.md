# XRHandTracker

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`XRHandTracker` → `XRPositionalTracker` → `XRTracker` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/XRHandTracker.md`

**摘要**：A tracked hand in XR.

## 描述

A hand tracking system will create an instance of this object and add it to the `XRServer`. This tracking system will then obtain skeleton data, convert it to the Godot Humanoid hand skeleton and store this data on the `XRHandTracker` object.
		Use `XRHandModifier3D` to animate a hand mesh using hand tracking data.

## 属性

- **`hand`** `int` = `1` · 枚举 `XRPositionalTracker.TrackerHand`
  - 其它属性：getter=get_tracker_hand · overrides=XRPositionalTracker · setter=set_tracker_hand
- **`hand_tracking_source`** `int` = `0` · 枚举 `XRHandTracker.HandTrackingSource`
  - 其它属性：getter=get_hand_tracking_source · setter=set_hand_tracking_source
- **`has_tracking_data`** `bool` = `false`
  - 其它属性：getter=get_has_tracking_data · setter=set_has_tracking_data
- **`type`** `int` = `16` · 枚举 `XRServer.TrackerType`
  - 其它属性：getter=get_tracker_type · overrides=XRTracker · setter=set_tracker_type

## 方法

### `get_hand_joint_angular_velocity(joint: int) -> Vector3`
- 限定：qualifiers=const

Returns the angular velocity for the given hand joint.

### `get_hand_joint_flags(joint: int) -> int`
- 限定：qualifiers=const

Returns flags about the validity of the tracking data for the given hand joint.

### `get_hand_joint_linear_velocity(joint: int) -> Vector3`
- 限定：qualifiers=const

Returns the linear velocity for the given hand joint.

### `get_hand_joint_radius(joint: int) -> float`
- 限定：qualifiers=const

Returns the radius of the given hand joint.

### `get_hand_joint_transform(joint: int) -> Transform3D`
- 限定：qualifiers=const

Returns the transform for the given hand joint.

### `set_hand_joint_angular_velocity(joint: int, angular_velocity: Vector3) -> void`

Sets the angular velocity for the given hand joint.

### `set_hand_joint_flags(joint: int, flags: int) -> void`

Sets flags about the validity of the tracking data for the given hand joint.

### `set_hand_joint_linear_velocity(joint: int, linear_velocity: Vector3) -> void`

Sets the linear velocity for the given hand joint.

### `set_hand_joint_radius(joint: int, radius: float) -> void`

Sets the radius of the given hand joint.

### `set_hand_joint_transform(joint: int, transform: Transform3D) -> void`

Sets the transform for the given hand joint.

## 枚举

### `HandTrackingSource`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `HAND_TRACKING_SOURCE_UNKNOWN` |  |
| `1` | `HAND_TRACKING_SOURCE_UNOBSTRUCTED` |  |
| `2` | `HAND_TRACKING_SOURCE_CONTROLLER` |  |
| `3` | `HAND_TRACKING_SOURCE_NOT_TRACKED` |  |
| `4` | `HAND_TRACKING_SOURCE_MAX` |  |

### `HandJoint`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `HAND_JOINT_PALM` |  |
| `1` | `HAND_JOINT_WRIST` |  |
| `2` | `HAND_JOINT_THUMB_METACARPAL` |  |
| `3` | `HAND_JOINT_THUMB_PHALANX_PROXIMAL` |  |
| `4` | `HAND_JOINT_THUMB_PHALANX_DISTAL` |  |
| `5` | `HAND_JOINT_THUMB_TIP` |  |
| `6` | `HAND_JOINT_INDEX_FINGER_METACARPAL` |  |
| `7` | `HAND_JOINT_INDEX_FINGER_PHALANX_PROXIMAL` |  |
| `8` | `HAND_JOINT_INDEX_FINGER_PHALANX_INTERMEDIATE` |  |
| `9` | `HAND_JOINT_INDEX_FINGER_PHALANX_DISTAL` |  |
| `10` | `HAND_JOINT_INDEX_FINGER_TIP` |  |
| `11` | `HAND_JOINT_MIDDLE_FINGER_METACARPAL` |  |
| `12` | `HAND_JOINT_MIDDLE_FINGER_PHALANX_PROXIMAL` |  |
| `13` | `HAND_JOINT_MIDDLE_FINGER_PHALANX_INTERMEDIATE` |  |
| `14` | `HAND_JOINT_MIDDLE_FINGER_PHALANX_DISTAL` |  |
| `15` | `HAND_JOINT_MIDDLE_FINGER_TIP` |  |
| `16` | `HAND_JOINT_RING_FINGER_METACARPAL` |  |
| `17` | `HAND_JOINT_RING_FINGER_PHALANX_PROXIMAL` |  |
| `18` | `HAND_JOINT_RING_FINGER_PHALANX_INTERMEDIATE` |  |
| `19` | `HAND_JOINT_RING_FINGER_PHALANX_DISTAL` |  |
| `20` | `HAND_JOINT_RING_FINGER_TIP` |  |
| `21` | `HAND_JOINT_PINKY_FINGER_METACARPAL` |  |
| `22` | `HAND_JOINT_PINKY_FINGER_PHALANX_PROXIMAL` |  |
| `23` | `HAND_JOINT_PINKY_FINGER_PHALANX_INTERMEDIATE` |  |
| `24` | `HAND_JOINT_PINKY_FINGER_PHALANX_DISTAL` |  |
| `25` | `HAND_JOINT_PINKY_FINGER_TIP` |  |
| `26` | `HAND_JOINT_MAX` |  |

### `HandJointFlags`

| 值 | 名称 | 说明 |
|---|---|---|
| `1` | `HAND_JOINT_FLAG_ORIENTATION_VALID` | （位标志） |
| `2` | `HAND_JOINT_FLAG_ORIENTATION_TRACKED` | （位标志） |
| `4` | `HAND_JOINT_FLAG_POSITION_VALID` | （位标志） |
| `8` | `HAND_JOINT_FLAG_POSITION_TRACKED` | （位标志） |
| `16` | `HAND_JOINT_FLAG_LINEAR_VELOCITY_VALID` | （位标志） |
| `32` | `HAND_JOINT_FLAG_ANGULAR_VELOCITY_VALID` | （位标志） |

## 教程链接

- [XR documentation index](None)

