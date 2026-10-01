# XRServer

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`XRServer` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/XRServer.md`

**摘要**：Server for AR and VR features.

## 描述

The AR/VR server is the heart of our Advanced and Virtual Reality solution and handles all the processing.

## 属性

- **`camera_locked_to_origin`** `bool` = `false`
  - 其它属性：getter=is_camera_locked_to_origin · setter=set_camera_locked_to_origin
- **`primary_interface`** `XRInterface`
  - 其它属性：getter=get_primary_interface · setter=set_primary_interface
- **`world_origin`** `Transform3D` = `Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0)`
  - 其它属性：getter=get_world_origin · setter=set_world_origin
- **`world_scale`** `float` = `1.0`
  - 其它属性：getter=get_world_scale · setter=set_world_scale

## 方法

### `add_interface(interface: XRInterface) -> void`

Registers an `XRInterface` object.

### `add_tracker(tracker: XRTracker) -> void`

Registers a new `XRTracker` that tracks a physical object.

### `center_on_hmd(rotation_mode: int, keep_height: bool) -> void`

This is an important function to understand correctly. AR and VR platforms all handle positioning slightly differently.
				For platforms that do not offer spatial tracking, our origin point `(0, 0, 0)` is the location of our HMD, but you have little control over the direction the player is facing in the real world.
				For platforms that do offer spatial tracking, our origin point depends very much on the system. For OpenVR, our origin point is usually the center of the tracking space, on the ground. For other platforms, it's often the location of the tracking camera.
				This method allows you to center your tracker on the location of the HMD. It will take the current location of the HMD and use that to adjust all your tracking data; in essence, realigning the real world to your player's current position in the game world.
				For this method to produce usable results, tracking information must be available. This often takes a few frames after starting your game.
				You should call this method after a few seconds have passed. For example, when the user requests a realignment of the display holding a designated button on a controller for a short period of time, or when implementing a teleport mechanism.

### `clear_reference_frame() -> void`

Clears the reference frame that was set by previous calls to `center_on_hmd`.

### `find_interface(name: String) -> XRInterface`
- 限定：qualifiers=const

Finds an interface by its `name`. For example, if your project uses capabilities of an AR/VR platform, you can find the interface for that platform by name and initialize it.

### `get_hmd_transform() -> Transform3D`

Returns the primary interface's transformation.

### `get_interface(idx: int) -> XRInterface`
- 限定：qualifiers=const

Returns the interface registered at the given `idx` index in the list of interfaces.

### `get_interface_count() -> int`
- 限定：qualifiers=const

Returns the number of interfaces currently registered with the AR/VR server. If your project supports multiple AR/VR platforms, you can look through the available interface, and either present the user with a selection or simply try to initialize each interface and use the first one that returns `true`.

### `get_interfaces() -> Dictionary[]`
- 限定：qualifiers=const

Returns a list of available interfaces the ID and name of each interface.

### `get_reference_frame() -> Transform3D`
- 限定：qualifiers=const

Returns the reference frame transform. Mostly used internally and exposed for GDExtension build interfaces.

### `get_tracker(tracker_name: StringName) -> XRTracker`
- 限定：qualifiers=const

Returns the positional tracker with the given `tracker_name`.

### `get_trackers(tracker_types: int) -> Dictionary`

Returns a dictionary of trackers for `tracker_types`.

### `remove_interface(interface: XRInterface) -> void`

Removes this `interface`.

### `remove_tracker(tracker: XRTracker) -> void`

Removes this `tracker`.

## 信号

### `interface_added(interface_name: StringName)`

Emitted when a new interface has been added.

### `interface_removed(interface_name: StringName)`

Emitted when an interface is removed.

### `reference_frame_changed()`

Emitted when the reference frame transform changes.

### `tracker_added(tracker_name: StringName, type: int)`

Emitted when a new tracker has been added. If you don't use a fixed number of controllers or if you're using `XRAnchor3D`s for an AR solution, it is important to react to this signal to add the appropriate `XRController3D` or `XRAnchor3D` nodes related to this new tracker.

### `tracker_removed(tracker_name: StringName, type: int)`

Emitted when a tracker is removed. You should remove any `XRController3D` or `XRAnchor3D` points if applicable. This is not mandatory, the nodes simply become inactive and will be made active again when a new tracker becomes available (i.e. a new controller is switched on that takes the place of the previous one).

### `tracker_updated(tracker_name: StringName, type: int)`

Emitted when an existing tracker has been updated. This can happen if the user switches controllers.

### `world_origin_changed()`

Emitted when the world origin transform changes.

## 枚举

### `TrackerType`

| 值 | 名称 | 说明 |
|---|---|---|
| `1` | `TRACKER_HEAD` |  |
| `2` | `TRACKER_CONTROLLER` |  |
| `4` | `TRACKER_BASESTATION` |  |
| `8` | `TRACKER_ANCHOR` |  |
| `16` | `TRACKER_HAND` |  |
| `32` | `TRACKER_BODY` |  |
| `64` | `TRACKER_FACE` |  |
| `127` | `TRACKER_ANY_KNOWN` |  |
| `128` | `TRACKER_UNKNOWN` |  |
| `255` | `TRACKER_ANY` |  |

### `RotationMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `RESET_FULL_ROTATION` |  |
| `1` | `RESET_BUT_KEEP_TILT` |  |
| `2` | `DONT_RESET_ROTATION` |  |

## 教程链接

- [XR documentation index](None)

