# XRNode3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`XRNode3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/XRNode3D.md`

**摘要**：A 3D node that has its position automatically updated by the `XRServer`.

## 描述

This node can be bound to a specific pose of an `XRPositionalTracker` and will automatically have its `Node3D.transform` updated by the `XRServer`. Nodes of this type must be added as children of the `XROrigin3D` node.

## 属性

- **`physics_interpolation_mode`** `int` = `2` · 枚举 `Node.PhysicsInterpolationMode`
  - 其它属性：getter=get_physics_interpolation_mode · overrides=Node · setter=set_physics_interpolation_mode
- **`pose`** `StringName` = `&"default"`
  - 其它属性：getter=get_pose_name · setter=set_pose_name
- **`show_when_tracked`** `bool` = `false`
  - 其它属性：getter=get_show_when_tracked · setter=set_show_when_tracked
- **`tracker`** `StringName` = `&""`
  - 其它属性：getter=get_tracker · setter=set_tracker

## 方法

### `get_has_tracking_data() -> bool`
- 限定：qualifiers=const

Returns `true` if the `tracker` has current tracking data for the `pose` being tracked.

### `get_is_active() -> bool`
- 限定：qualifiers=const

Returns `true` if the `tracker` has been registered and the `pose` is being tracked.

### `get_pose() -> XRPose`

Returns the `XRPose` containing the current state of the pose being tracked. This gives access to additional properties of this pose.

### `trigger_haptic_pulse(action_name: String, frequency: float, amplitude: float, duration_sec: float, delay_sec: float) -> void`

Triggers a haptic pulse on a device associated with this interface.
				`action_name` is the name of the action for this pulse.
				`frequency` is the frequency of the pulse, set to `0.0` to have the system use a default frequency.
				`amplitude` is the amplitude of the pulse between `0.0` and `1.0`.
				`duration_sec` is the duration of the pulse in seconds.
				`delay_sec` is a delay in seconds before the pulse is given.

## 信号

### `tracking_changed(tracking: bool)`

Emitted when the `tracker` starts or stops receiving updated tracking data for the `pose` being tracked. The `tracking` argument indicates whether the tracker is getting updated tracking data.

## 教程链接

- [XR documentation index](None)

