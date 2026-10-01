# XRPositionalTracker

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`XRPositionalTracker` → `XRTracker` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/XRPositionalTracker.md`

**摘要**：A tracked object.

## 描述

An instance of this object represents a device that is tracked, such as a controller or anchor point. HMDs aren't represented here as they are handled internally.
		As controllers are turned on and the `XRInterface` detects them, instances of this object are automatically added to this list of active tracking objects accessible through the `XRServer`.
		The `XRNode3D` and `XRAnchor3D` both consume objects of this type and should be used in your project. The positional trackers are just under-the-hood objects that make this all work. These are mostly exposed so that GDExtension-based interfaces can interact with them.

## 属性

- **`hand`** `int` = `0` · 枚举 `XRPositionalTracker.TrackerHand`
  - 其它属性：getter=get_tracker_hand · setter=set_tracker_hand
- **`profile`** `String` = `""`
  - 其它属性：getter=get_tracker_profile · setter=set_tracker_profile

## 方法

### `get_input(name: StringName) -> Variant`
- 限定：deprecated=Use through [XRControllerTracker]. · qualifiers=const

Returns an input for this tracker. It can return a boolean, float or `Vector2` value depending on whether the input is a button, trigger or thumbstick/thumbpad.

### `get_pose(name: StringName) -> XRPose`
- 限定：qualifiers=const

Returns the current `XRPose` state object for the bound `name` pose.

### `has_pose(name: StringName) -> bool`
- 限定：qualifiers=const

Returns `true` if the tracker is available and is currently tracking the bound `name` pose.

### `invalidate_pose(name: StringName) -> void`

Marks this pose as invalid, we don't clear the last reported state but it allows users to decide if trackers need to be hidden if we lose tracking or just remain at their last known position.

### `set_input(name: StringName, value: Variant) -> void`
- 限定：deprecated=Use through [XRControllerTracker].

Changes the value for the given input. This method is called by an `XRInterface` implementation and should not be used directly.

### `set_pose(name: StringName, transform: Transform3D, linear_velocity: Vector3, angular_velocity: Vector3, tracking_confidence: int) -> void`

Sets the transform, linear velocity, angular velocity and tracking confidence for the given pose. This method is called by an `XRInterface` implementation and should not be used directly.

## 信号

### `button_pressed(action_name: String)`

Emitted when a button on this tracker is pressed. Note that many XR runtimes allow other inputs to be mapped to buttons.

### `button_released(action_name: String)`

Emitted when a button on this tracker is released.

### `input_float_changed(action_name: String, value: float)`

Emitted when a trigger or similar input on this tracker changes value.

### `input_vector2_changed(action_name: String, vector: Vector2)`

Emitted when a thumbstick or thumbpad on this tracker moves.

### `pose_changed(pose: XRPose)`

Emitted when the state of a pose tracked by this tracker changes.

### `pose_lost_tracking(pose: XRPose)`

Emitted when a pose tracked by this tracker stops getting updated tracking data.

### `profile_changed(role: String)`

Emitted when the profile of our tracker changes.

## 枚举

### `TrackerHand`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `TRACKER_HAND_UNKNOWN` |  |
| `1` | `TRACKER_HAND_LEFT` |  |
| `2` | `TRACKER_HAND_RIGHT` |  |
| `3` | `TRACKER_HAND_MAX` |  |

## 教程链接

- [XR documentation index](None)

