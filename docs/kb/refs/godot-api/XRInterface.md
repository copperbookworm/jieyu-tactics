# XRInterface

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`XRInterface` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/XRInterface.md`

**摘要**：Base class for an XR interface implementation.

## 描述

This class needs to be implemented to make an AR or VR platform available to Godot and these should be implemented as C++ modules or GDExtension modules. Part of the interface is exposed to GDScript so you can detect, enable and configure an AR or VR platform.
		Interfaces should be written in such a way that simply enabling them will give us a working setup. You can query the available interfaces through `XRServer`.

## 属性

- **`ar_is_anchor_detection_enabled`** `bool` = `false`
  - 其它属性：getter=get_anchor_detection_is_enabled · setter=set_anchor_detection_is_enabled
- **`environment_blend_mode`** `int` = `0` · 枚举 `XRInterface.EnvironmentBlendMode`
  - 其它属性：getter=get_environment_blend_mode · setter=set_environment_blend_mode
- **`interface_is_primary`** `bool` = `false`
  - 其它属性：getter=is_primary · setter=set_primary
- **`xr_play_area_mode`** `int` = `0` · 枚举 `XRInterface.PlayAreaMode`
  - 其它属性：getter=get_play_area_mode · setter=set_play_area_mode

## 方法

### `get_camera_feed_id() -> int`

If this is an AR interface that requires displaying a camera feed as the background, this method returns the feed ID in the `CameraServer` for this interface.

### `get_capabilities() -> int`
- 限定：qualifiers=const

Returns a combination of `Capabilities` flags providing information about the capabilities of this interface.

### `get_name() -> StringName`
- 限定：qualifiers=const

Returns the name of this interface (`"OpenXR"`, `"OpenVR"`, `"OpenHMD"`, `"ARKit"`, etc.).

### `get_play_area() -> PackedVector3Array`
- 限定：qualifiers=const

Returns an array of vectors that represent the physical play area mapped to the virtual space around the `XROrigin3D` point. The points form a convex polygon that can be used to react to or visualize the play area. This returns an empty array if this feature is not supported or if the information is not yet available.

### `get_projection_for_view(view: int, aspect: float, near: float, far: float) -> Projection`

Returns the projection matrix for a view/eye.

### `get_render_target_size() -> Vector2`

Returns the resolution at which we should render our intermediate results before things like lens distortion are applied by the VR platform.

### `get_supported_environment_blend_modes() -> Array`

Returns the an array of supported environment blend modes, see `XRInterface.EnvironmentBlendMode`.

### `get_system_info() -> Dictionary`

Returns a `Dictionary` with extra system info. Interfaces are expected to return `XRRuntimeName` and `XRRuntimeVersion` providing info about the used XR runtime. Additional entries may be provided specific to an interface.
				**Note:**This information may only be available after `initialize` was successfully called.

### `get_tracking_status() -> int`
- 限定：qualifiers=const

If supported, returns the status of our tracking. This will allow you to provide feedback to the user whether there are issues with positional tracking.

### `get_transform_for_view(view: int, cam_transform: Transform3D) -> Transform3D`

Returns the transform for a view/eye.
				`view` is the view/eye index.
				`cam_transform` is the transform that maps device coordinates to scene coordinates, typically the `Node3D.global_transform` of the current XROrigin3D.

### `get_view_count() -> int`

Returns the number of views that need to be rendered for this device. 1 for Monoscopic, 2 for Stereoscopic.

### `initialize() -> bool`

Call this to initialize this interface. The first interface that is initialized is identified as the primary interface and it will be used for rendering output.
				After initializing the interface you want to use you then need to enable the AR/VR mode of a viewport and rendering should commence.
				**Note:** You must enable the XR mode on the main viewport for any device that uses the main output of Godot, such as for mobile VR.
				If you do this for a platform that handles its own output (such as OpenVR) Godot will show just one eye without distortion on screen. Alternatively, you can add a separate viewport node to your scene and enable AR/VR on that viewport. It will be used to output to the HMD, leaving you free to do anything you like in the main window, such as using a separate camera as a spectator camera or rendering something completely different.
				While currently not used, you can activate additional interfaces. You may wish to do this if you want to track controllers from other platforms. However, at this point in time only one interface can render to an HMD.

### `is_initialized() -> bool`
- 限定：qualifiers=const

Returns `true` if this interface has been initialized.

### `is_passthrough_enabled() -> bool`
- 限定：deprecated=Check if [member environment_blend_mode] is [constant XRInterface.XR_ENV_BLEND_MODE_ALPHA_BLEND], instead.

Returns `true` if passthrough is enabled.

### `is_passthrough_supported() -> bool`
- 限定：deprecated=Check that [constant XRInterface.XR_ENV_BLEND_MODE_ALPHA_BLEND] is supported using [method get_supported_environment_blend_modes], instead.

Returns `true` if this interface supports passthrough.

### `set_environment_blend_mode(mode: int) -> bool`

Sets the active environment blend mode.
				`mode` is the environment blend mode starting with the next frame.
				**Note:** Not all runtimes support all environment blend modes, so it is important to check this at startup. For example:
				
```gdscript
				func _ready():
					var xr_interface = XRServer.find_interface("OpenXR")
					if xr_interface and xr_interface.is_initialized():
						var vp = get_viewport()
						vp.use_xr = true
						var acceptable_modes = [XRInterface.XR_ENV_BLEND_MODE_OPAQUE, XRInterface.XR_ENV_BLEND_MODE_ADDITIVE]
						var modes = xr_interface.get_supported_environment_blend_modes()
						for mode in acceptable_modes:
							if mode in modes:
								xr_interface.set_environment_blend_mode(mode)
								break
				
```

### `set_play_area_mode(mode: int) -> bool`

Sets the active play area mode, will return `false` if the mode can't be used with this interface.
				**Note:** Changing this after the interface has already been initialized can be jarring for the player, so it's recommended to recenter on the HMD with `XRServer.center_on_hmd` (if switching to `XRInterface.XR_PLAY_AREA_STAGE`) or make the switch during a scene change.

### `start_passthrough() -> bool`
- 限定：deprecated=Set the [member environment_blend_mode] to [constant XRInterface.XR_ENV_BLEND_MODE_ALPHA_BLEND], instead.

Starts passthrough, will return `false` if passthrough couldn't be started.
				**Note:** The viewport used for XR must have a transparent background, otherwise passthrough may not properly render.

### `stop_passthrough() -> void`
- 限定：deprecated=Set the [member environment_blend_mode] to [constant XRInterface.XR_ENV_BLEND_MODE_OPAQUE], instead.

Stops passthrough.

### `supports_play_area_mode(mode: int) -> bool`

Call this to find out if a given play area mode is supported by this interface.

### `trigger_haptic_pulse(action_name: String, tracker_name: StringName, frequency: float, amplitude: float, duration_sec: float, delay_sec: float) -> void`

Triggers a haptic pulse on a device associated with this interface.
				`action_name` is the name of the action for this pulse.
				`tracker_name` is optional and can be used to direct the pulse to a specific device provided that device is bound to this haptic.
				`frequency` is the frequency of the pulse, set to `0.0` to have the system use a default frequency.
				`amplitude` is the amplitude of the pulse between `0.0` and `1.0`.
				`duration_sec` is the duration of the pulse in seconds.
				`delay_sec` is a delay in seconds before the pulse is given.

### `uninitialize() -> void`

Turns the interface off.

## 信号

### `play_area_changed(mode: int)`

Emitted when the play area is changed. This can be a result of the player resetting the boundary or entering a new play area, the player changing the play area mode, the world scale changing or the player resetting their headset orientation.

## 枚举

### `Capabilities`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `XR_NONE` |  |
| `1` | `XR_MONO` |  |
| `2` | `XR_STEREO` |  |
| `4` | `XR_QUAD` |  |
| `8` | `XR_VR` |  |
| `16` | `XR_AR` |  |
| `32` | `XR_EXTERNAL` |  |

### `TrackingStatus`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `XR_NORMAL_TRACKING` |  |
| `1` | `XR_EXCESSIVE_MOTION` |  |
| `2` | `XR_INSUFFICIENT_FEATURES` |  |
| `3` | `XR_UNKNOWN_TRACKING` |  |
| `4` | `XR_NOT_TRACKING` |  |

### `PlayAreaMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `XR_PLAY_AREA_UNKNOWN` |  |
| `1` | `XR_PLAY_AREA_3DOF` |  |
| `2` | `XR_PLAY_AREA_SITTING` |  |
| `3` | `XR_PLAY_AREA_ROOMSCALE` |  |
| `4` | `XR_PLAY_AREA_STAGE` |  |
| `2147483647` | `XR_PLAY_AREA_CUSTOM` |  |

### `EnvironmentBlendMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `XR_ENV_BLEND_MODE_OPAQUE` |  |
| `1` | `XR_ENV_BLEND_MODE_ADDITIVE` |  |
| `2` | `XR_ENV_BLEND_MODE_ALPHA_BLEND` |  |

### `VRSTextureFormat`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `XR_VRS_TEXTURE_FORMAT_UNIFIED` |  |
| `1` | `XR_VRS_TEXTURE_FORMAT_FRAGMENT_SHADING_RATE` |  |
| `2` | `XR_VRS_TEXTURE_FORMAT_FRAGMENT_DENSITY_MAP` |  |

## 教程链接

- [XR documentation index](None)

