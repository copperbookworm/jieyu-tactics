# OpenXRInterface

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OpenXRInterface` → `XRInterface` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/OpenXRInterface.md`

**摘要**：Our OpenXR interface.

## 描述

The OpenXR interface allows Godot to interact with OpenXR runtimes and make it possible to create XR experiences and games.
		Due to the needs of OpenXR this interface works slightly different than other plugin based XR interfaces. It needs to be initialized when Godot starts. You need to enable OpenXR, settings for this can be found in your games project settings under the XR heading. You do need to mark a viewport for use with XR in order for Godot to know which render result should be output to the headset.

## 属性

- **`display_refresh_rate`** `float` = `0.0`
  - 其它属性：getter=get_display_refresh_rate · setter=set_display_refresh_rate
- **`foveation_dynamic`** `bool` = `false`
  - 其它属性：getter=get_foveation_dynamic · setter=set_foveation_dynamic
- **`foveation_level`** `int` = `0`
  - 其它属性：getter=get_foveation_level · setter=set_foveation_level
- **`foveation_with_subsampled_images`** `bool` = `false`
  - 其它属性：getter=get_foveation_with_subsampled_images · setter=set_foveation_with_subsampled_images
- **`render_target_size_multiplier`** `float` = `1.0`
  - 其它属性：getter=get_render_target_size_multiplier · setter=set_render_target_size_multiplier
- **`vrs_min_radius`** `float` = `20.0`
  - 其它属性：getter=get_vrs_min_radius · setter=set_vrs_min_radius
- **`vrs_strength`** `float` = `1.0`
  - 其它属性：getter=get_vrs_strength · setter=set_vrs_strength

## 方法

### `get_action_sets() -> Array`
- 限定：qualifiers=const

Returns a list of action sets registered with Godot (loaded from the action map at runtime).

### `get_available_display_refresh_rates() -> Array`
- 限定：qualifiers=const

Returns a list of display refresh rates supported by the current HMD. Only returned if this feature is supported by the OpenXR runtime and after the interface has been initialized.

### `get_hand_joint_angular_velocity(hand: int, joint: int) -> Vector3`
- 限定：deprecated=Use [method XRHandTracker.get_hand_joint_angular_velocity] obtained from [method XRServer.get_tracker] instead. · qualifiers=const

If handtracking is enabled, returns the angular velocity of a joint (`joint`) of a hand (`hand`) as provided by OpenXR. This is relative to `XROrigin3D`!

### `get_hand_joint_flags(hand: int, joint: int) -> int`
- 限定：deprecated=Use [method XRHandTracker.get_hand_joint_flags] obtained from [method XRServer.get_tracker] instead. · qualifiers=const

If handtracking is enabled, returns flags that inform us of the validity of the tracking data.

### `get_hand_joint_linear_velocity(hand: int, joint: int) -> Vector3`
- 限定：deprecated=Use [method XRHandTracker.get_hand_joint_linear_velocity] obtained from [method XRServer.get_tracker] instead. · qualifiers=const

If handtracking is enabled, returns the linear velocity of a joint (`joint`) of a hand (`hand`) as provided by OpenXR. This is relative to `XROrigin3D` without worldscale applied!

### `get_hand_joint_position(hand: int, joint: int) -> Vector3`
- 限定：deprecated=Use [method XRHandTracker.get_hand_joint_transform] obtained from [method XRServer.get_tracker] instead. · qualifiers=const

If handtracking is enabled, returns the position of a joint (`joint`) of a hand (`hand`) as provided by OpenXR. This is relative to `XROrigin3D` without worldscale applied!

### `get_hand_joint_radius(hand: int, joint: int) -> float`
- 限定：deprecated=Use [method XRHandTracker.get_hand_joint_radius] obtained from [method XRServer.get_tracker] instead. · qualifiers=const

If handtracking is enabled, returns the radius of a joint (`joint`) of a hand (`hand`) as provided by OpenXR. This is without worldscale applied!

### `get_hand_joint_rotation(hand: int, joint: int) -> Quaternion`
- 限定：deprecated=Use [method XRHandTracker.get_hand_joint_transform] obtained from [method XRServer.get_tracker] instead. · qualifiers=const

If handtracking is enabled, returns the rotation of a joint (`joint`) of a hand (`hand`) as provided by OpenXR.

### `get_hand_tracking_source(hand: int) -> int`
- 限定：deprecated=Use [member XRHandTracker.hand_tracking_source] obtained from [method XRServer.get_tracker] instead. · qualifiers=const

If handtracking is enabled and hand tracking source is supported, gets the source of the hand tracking data for `hand`.

### `get_motion_range(hand: int) -> int`
- 限定：qualifiers=const

If handtracking is enabled and motion range is supported, gets the currently configured motion range for `hand`.

### `get_session_state() -> int`

Returns the current state of our OpenXR session.

### `is_action_set_active(name: String) -> bool`
- 限定：qualifiers=const

Returns `true` if the given action set is active.

### `is_eye_gaze_interaction_supported() -> bool`

Returns the capabilities of the eye gaze interaction extension.
				**Note:** This only returns a valid value after OpenXR has been initialized.

### `is_foveation_supported() -> bool`
- 限定：qualifiers=const

Returns `true` if OpenXR's foveation extension is supported. The interface must be initialized before this returns a valid value.
				**Note:** When using the Vulkan rendering driver, `Viewport.vrs_mode` must be set to `Viewport.VRS_XR` to support foveation.

### `is_hand_interaction_supported() -> bool`
- 限定：qualifiers=const

Returns `true` if OpenXR's hand interaction profile is supported and enabled.
				**Note:** This only returns a valid value after OpenXR has been initialized.

### `is_hand_tracking_supported() -> bool`

Returns `true` if OpenXR's hand tracking is supported and enabled.
				**Note:** This only returns a valid value after OpenXR has been initialized.

### `is_user_presence_supported() -> bool`
- 限定：qualifiers=const

Returns `true` if OpenXR's user presence extension is supported and enabled.
				**Note:** This only returns a valid value after OpenXR has been initialized.

### `is_user_present() -> bool`
- 限定：qualifiers=const

Returns `true` if system has detected the presence of a user in the XR experience.

### `set_action_set_active(name: String, active: bool) -> void`

Sets the given action set as active or inactive.

### `set_cpu_level(level: int) -> void`

Sets the CPU performance level of the OpenXR device.

### `set_gpu_level(level: int) -> void`

Sets the GPU performance level of the OpenXR device.

### `set_motion_range(hand: int, motion_range: int) -> void`

If handtracking is enabled and motion range is supported, sets the currently configured motion range for `hand` to `motion_range`.

## 信号

### `cpu_level_changed(sub_domain: int, from_level: int, to_level: int)`

Informs the device CPU performance level has changed in the specified subdomain.

### `gpu_level_changed(sub_domain: int, from_level: int, to_level: int)`

Informs the device GPU performance level has changed in the specified subdomain.

### `instance_exiting()`

Informs our OpenXR instance is exiting.

### `pose_recentered()`

Informs the user queued a recenter of the player position.

### `refresh_rate_changed(refresh_rate: float)`

Informs the user the HMD refresh rate has changed.
				**Note:** Only emitted if XR runtime supports the refresh rate extension.

### `session_begun()`

Informs our OpenXR session has been started.

### `session_focussed()`

Informs our OpenXR session now has focus, for example output is sent to the HMD and we're receiving XR input.

### `session_loss_pending()`

Informs our OpenXR session is in the process of being lost.

### `session_stopping()`

Informs our OpenXR session is stopping.

### `session_synchronized()`

Informs our OpenXR session has been synchronized.

### `session_visible()`

Informs our OpenXR session is now visible, for example output is sent to the HMD but we don't receive XR input.

### `user_presence_changed(is_user_present: bool)`

Signal emitted when the user presence value changes.
				**Note:** This signal will not be emitted during application startup and application shutdown. Developers should assume user presence is gained on startup and lost on shutdown.

## 枚举

### `SessionState`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SESSION_STATE_UNKNOWN` |  |
| `1` | `SESSION_STATE_IDLE` |  |
| `2` | `SESSION_STATE_READY` |  |
| `3` | `SESSION_STATE_SYNCHRONIZED` |  |
| `4` | `SESSION_STATE_VISIBLE` |  |
| `5` | `SESSION_STATE_FOCUSED` |  |
| `6` | `SESSION_STATE_STOPPING` |  |
| `7` | `SESSION_STATE_LOSS_PENDING` |  |
| `8` | `SESSION_STATE_EXITING` |  |

### `Hand`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `HAND_LEFT` |  |
| `1` | `HAND_RIGHT` |  |
| `2` | `HAND_MAX` |  |

### `HandMotionRange`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `HAND_MOTION_RANGE_UNOBSTRUCTED` |  |
| `1` | `HAND_MOTION_RANGE_CONFORM_TO_CONTROLLER` |  |
| `2` | `HAND_MOTION_RANGE_MAX` |  |

### `HandTrackedSource`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `HAND_TRACKED_SOURCE_UNKNOWN` |  |
| `1` | `HAND_TRACKED_SOURCE_UNOBSTRUCTED` |  |
| `2` | `HAND_TRACKED_SOURCE_CONTROLLER` |  |
| `3` | `HAND_TRACKED_SOURCE_MAX` |  |

### `HandJoints`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `HAND_JOINT_PALM` |  |
| `1` | `HAND_JOINT_WRIST` |  |
| `2` | `HAND_JOINT_THUMB_METACARPAL` |  |
| `3` | `HAND_JOINT_THUMB_PROXIMAL` |  |
| `4` | `HAND_JOINT_THUMB_DISTAL` |  |
| `5` | `HAND_JOINT_THUMB_TIP` |  |
| `6` | `HAND_JOINT_INDEX_METACARPAL` |  |
| `7` | `HAND_JOINT_INDEX_PROXIMAL` |  |
| `8` | `HAND_JOINT_INDEX_INTERMEDIATE` |  |
| `9` | `HAND_JOINT_INDEX_DISTAL` |  |
| `10` | `HAND_JOINT_INDEX_TIP` |  |
| `11` | `HAND_JOINT_MIDDLE_METACARPAL` |  |
| `12` | `HAND_JOINT_MIDDLE_PROXIMAL` |  |
| `13` | `HAND_JOINT_MIDDLE_INTERMEDIATE` |  |
| `14` | `HAND_JOINT_MIDDLE_DISTAL` |  |
| `15` | `HAND_JOINT_MIDDLE_TIP` |  |
| `16` | `HAND_JOINT_RING_METACARPAL` |  |
| `17` | `HAND_JOINT_RING_PROXIMAL` |  |
| `18` | `HAND_JOINT_RING_INTERMEDIATE` |  |
| `19` | `HAND_JOINT_RING_DISTAL` |  |
| `20` | `HAND_JOINT_RING_TIP` |  |
| `21` | `HAND_JOINT_LITTLE_METACARPAL` |  |
| `22` | `HAND_JOINT_LITTLE_PROXIMAL` |  |
| `23` | `HAND_JOINT_LITTLE_INTERMEDIATE` |  |
| `24` | `HAND_JOINT_LITTLE_DISTAL` |  |
| `25` | `HAND_JOINT_LITTLE_TIP` |  |
| `26` | `HAND_JOINT_MAX` |  |

### `PerfSettingsLevel`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `PERF_SETTINGS_LEVEL_POWER_SAVINGS` |  |
| `1` | `PERF_SETTINGS_LEVEL_SUSTAINED_LOW` |  |
| `2` | `PERF_SETTINGS_LEVEL_SUSTAINED_HIGH` |  |
| `3` | `PERF_SETTINGS_LEVEL_BOOST` |  |

### `PerfSettingsSubDomain`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `PERF_SETTINGS_SUB_DOMAIN_COMPOSITING` |  |
| `1` | `PERF_SETTINGS_SUB_DOMAIN_RENDERING` |  |
| `2` | `PERF_SETTINGS_SUB_DOMAIN_THERMAL` |  |

### `PerfSettingsNotificationLevel`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `PERF_SETTINGS_NOTIF_LEVEL_NORMAL` |  |
| `1` | `PERF_SETTINGS_NOTIF_LEVEL_WARNING` |  |
| `2` | `PERF_SETTINGS_NOTIF_LEVEL_IMPAIRED` |  |

### `HandJointFlags`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `HAND_JOINT_NONE` | （位标志） |
| `1` | `HAND_JOINT_ORIENTATION_VALID` | （位标志） |
| `2` | `HAND_JOINT_ORIENTATION_TRACKED` | （位标志） |
| `4` | `HAND_JOINT_POSITION_VALID` | （位标志） |
| `8` | `HAND_JOINT_POSITION_TRACKED` | （位标志） |
| `16` | `HAND_JOINT_LINEAR_VELOCITY_VALID` | （位标志） |
| `32` | `HAND_JOINT_ANGULAR_VELOCITY_VALID` | （位标志） |

## 教程链接

- [Setting up XR](None)

