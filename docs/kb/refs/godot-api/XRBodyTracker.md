# XRBodyTracker

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`XRBodyTracker` → `XRPositionalTracker` → `XRTracker` → `RefCounted` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/XRBodyTracker.md`

**摘要**：A tracked body in XR.

## 描述

A body tracking system will create an instance of this object and add it to the `XRServer`. This tracking system will then obtain skeleton data, convert it to the Godot Humanoid skeleton and store this data on the `XRBodyTracker` object.
		Use `XRBodyModifier3D` to animate a body mesh using body tracking data.

## 属性

- **`body_flags`** `int` = `0` · 枚举 `XRBodyTracker.BodyFlags` · 位标志
  - 其它属性：getter=get_body_flags · is_bitfield=true · setter=set_body_flags
- **`has_tracking_data`** `bool` = `false`
  - 其它属性：getter=get_has_tracking_data · setter=set_has_tracking_data
- **`type`** `int` = `32` · 枚举 `XRServer.TrackerType`
  - 其它属性：getter=get_tracker_type · overrides=XRTracker · setter=set_tracker_type

## 方法

### `get_joint_flags(joint: int) -> int`
- 限定：qualifiers=const

Returns flags about the validity of the tracking data for the given body joint.

### `get_joint_transform(joint: int) -> Transform3D`
- 限定：qualifiers=const

Returns the transform for the given body joint.

### `set_joint_flags(joint: int, flags: int) -> void`

Sets flags about the validity of the tracking data for the given body joint.

### `set_joint_transform(joint: int, transform: Transform3D) -> void`

Sets the transform for the given body joint.

## 枚举

### `BodyFlags`

| 值 | 名称 | 说明 |
|---|---|---|
| `1` | `BODY_FLAG_UPPER_BODY_SUPPORTED` | （位标志） |
| `2` | `BODY_FLAG_LOWER_BODY_SUPPORTED` | （位标志） |
| `4` | `BODY_FLAG_HANDS_SUPPORTED` | （位标志） |

### `Joint`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `JOINT_ROOT` |  |
| `1` | `JOINT_HIPS` |  |
| `2` | `JOINT_SPINE` |  |
| `3` | `JOINT_CHEST` |  |
| `4` | `JOINT_UPPER_CHEST` |  |
| `5` | `JOINT_NECK` |  |
| `6` | `JOINT_HEAD` |  |
| `7` | `JOINT_HEAD_TIP` |  |
| `8` | `JOINT_LEFT_SHOULDER` |  |
| `9` | `JOINT_LEFT_UPPER_ARM` |  |
| `10` | `JOINT_LEFT_LOWER_ARM` |  |
| `11` | `JOINT_RIGHT_SHOULDER` |  |
| `12` | `JOINT_RIGHT_UPPER_ARM` |  |
| `13` | `JOINT_RIGHT_LOWER_ARM` |  |
| `14` | `JOINT_LEFT_UPPER_LEG` |  |
| `15` | `JOINT_LEFT_LOWER_LEG` |  |
| `16` | `JOINT_LEFT_FOOT` |  |
| `17` | `JOINT_LEFT_TOES` |  |
| `18` | `JOINT_RIGHT_UPPER_LEG` |  |
| `19` | `JOINT_RIGHT_LOWER_LEG` |  |
| `20` | `JOINT_RIGHT_FOOT` |  |
| `21` | `JOINT_RIGHT_TOES` |  |
| `22` | `JOINT_LEFT_HAND` |  |
| `23` | `JOINT_LEFT_PALM` |  |
| `24` | `JOINT_LEFT_WRIST` |  |
| `25` | `JOINT_LEFT_THUMB_METACARPAL` |  |
| `26` | `JOINT_LEFT_THUMB_PHALANX_PROXIMAL` |  |
| `27` | `JOINT_LEFT_THUMB_PHALANX_DISTAL` |  |
| `28` | `JOINT_LEFT_THUMB_TIP` |  |
| `29` | `JOINT_LEFT_INDEX_FINGER_METACARPAL` |  |
| `30` | `JOINT_LEFT_INDEX_FINGER_PHALANX_PROXIMAL` |  |
| `31` | `JOINT_LEFT_INDEX_FINGER_PHALANX_INTERMEDIATE` |  |
| `32` | `JOINT_LEFT_INDEX_FINGER_PHALANX_DISTAL` |  |
| `33` | `JOINT_LEFT_INDEX_FINGER_TIP` |  |
| `34` | `JOINT_LEFT_MIDDLE_FINGER_METACARPAL` |  |
| `35` | `JOINT_LEFT_MIDDLE_FINGER_PHALANX_PROXIMAL` |  |
| `36` | `JOINT_LEFT_MIDDLE_FINGER_PHALANX_INTERMEDIATE` |  |
| `37` | `JOINT_LEFT_MIDDLE_FINGER_PHALANX_DISTAL` |  |
| `38` | `JOINT_LEFT_MIDDLE_FINGER_TIP` |  |
| `39` | `JOINT_LEFT_RING_FINGER_METACARPAL` |  |
| `40` | `JOINT_LEFT_RING_FINGER_PHALANX_PROXIMAL` |  |
| `41` | `JOINT_LEFT_RING_FINGER_PHALANX_INTERMEDIATE` |  |
| `42` | `JOINT_LEFT_RING_FINGER_PHALANX_DISTAL` |  |
| `43` | `JOINT_LEFT_RING_FINGER_TIP` |  |
| `44` | `JOINT_LEFT_PINKY_FINGER_METACARPAL` |  |
| `45` | `JOINT_LEFT_PINKY_FINGER_PHALANX_PROXIMAL` |  |
| `46` | `JOINT_LEFT_PINKY_FINGER_PHALANX_INTERMEDIATE` |  |
| `47` | `JOINT_LEFT_PINKY_FINGER_PHALANX_DISTAL` |  |
| `48` | `JOINT_LEFT_PINKY_FINGER_TIP` |  |
| `49` | `JOINT_RIGHT_HAND` |  |
| `50` | `JOINT_RIGHT_PALM` |  |
| `51` | `JOINT_RIGHT_WRIST` |  |
| `52` | `JOINT_RIGHT_THUMB_METACARPAL` |  |
| `53` | `JOINT_RIGHT_THUMB_PHALANX_PROXIMAL` |  |
| `54` | `JOINT_RIGHT_THUMB_PHALANX_DISTAL` |  |
| `55` | `JOINT_RIGHT_THUMB_TIP` |  |
| `56` | `JOINT_RIGHT_INDEX_FINGER_METACARPAL` |  |
| `57` | `JOINT_RIGHT_INDEX_FINGER_PHALANX_PROXIMAL` |  |
| `58` | `JOINT_RIGHT_INDEX_FINGER_PHALANX_INTERMEDIATE` |  |
| `59` | `JOINT_RIGHT_INDEX_FINGER_PHALANX_DISTAL` |  |
| `60` | `JOINT_RIGHT_INDEX_FINGER_TIP` |  |
| `61` | `JOINT_RIGHT_MIDDLE_FINGER_METACARPAL` |  |
| `62` | `JOINT_RIGHT_MIDDLE_FINGER_PHALANX_PROXIMAL` |  |
| `63` | `JOINT_RIGHT_MIDDLE_FINGER_PHALANX_INTERMEDIATE` |  |
| `64` | `JOINT_RIGHT_MIDDLE_FINGER_PHALANX_DISTAL` |  |
| `65` | `JOINT_RIGHT_MIDDLE_FINGER_TIP` |  |
| `66` | `JOINT_RIGHT_RING_FINGER_METACARPAL` |  |
| `67` | `JOINT_RIGHT_RING_FINGER_PHALANX_PROXIMAL` |  |
| `68` | `JOINT_RIGHT_RING_FINGER_PHALANX_INTERMEDIATE` |  |
| `69` | `JOINT_RIGHT_RING_FINGER_PHALANX_DISTAL` |  |
| `70` | `JOINT_RIGHT_RING_FINGER_TIP` |  |
| `71` | `JOINT_RIGHT_PINKY_FINGER_METACARPAL` |  |
| `72` | `JOINT_RIGHT_PINKY_FINGER_PHALANX_PROXIMAL` |  |
| `73` | `JOINT_RIGHT_PINKY_FINGER_PHALANX_INTERMEDIATE` |  |
| `74` | `JOINT_RIGHT_PINKY_FINGER_PHALANX_DISTAL` |  |
| `75` | `JOINT_RIGHT_PINKY_FINGER_TIP` |  |
| `76` | `JOINT_LOWER_CHEST` |  |
| `77` | `JOINT_LEFT_SCAPULA` |  |
| `78` | `JOINT_LEFT_WRIST_TWIST` |  |
| `79` | `JOINT_RIGHT_SCAPULA` |  |
| `80` | `JOINT_RIGHT_WRIST_TWIST` |  |
| `81` | `JOINT_LEFT_FOOT_TWIST` |  |
| `82` | `JOINT_LEFT_HEEL` |  |
| `83` | `JOINT_LEFT_MIDDLE_FOOT` |  |
| `84` | `JOINT_RIGHT_FOOT_TWIST` |  |
| `85` | `JOINT_RIGHT_HEEL` |  |
| `86` | `JOINT_RIGHT_MIDDLE_FOOT` |  |
| `87` | `JOINT_MAX` |  |

### `JointFlags`

| 值 | 名称 | 说明 |
|---|---|---|
| `1` | `JOINT_FLAG_ORIENTATION_VALID` | （位标志） |
| `2` | `JOINT_FLAG_ORIENTATION_TRACKED` | （位标志） |
| `4` | `JOINT_FLAG_POSITION_VALID` | （位标志） |
| `8` | `JOINT_FLAG_POSITION_TRACKED` | （位标志） |

## 教程链接

- [XR documentation index](None)

