# WebXRInterface

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`WebXRInterface` → `XRInterface` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/WebXRInterface.md`

**摘要**：XR interface using WebXR.

## 描述

WebXR is an open standard that allows creating VR and AR applications that run in the web browser.
		As such, this interface is only available when running in Web exports.
		WebXR supports a wide range of devices, from the very capable (like Valve Index, HTC Vive, Oculus Rift and Quest) down to the much less capable (like Google Cardboard, Oculus Go, GearVR, or plain smartphones).
		Since WebXR is based on JavaScript, it makes extensive use of callbacks, which means that `WebXRInterface` is forced to use signals, where other XR interfaces would instead use functions that return a result immediately. This makes `WebXRInterface` quite a bit more complicated to initialize than other XR interfaces.
		Here's the minimum code required to start an immersive VR session:
		
```gdscript
		extends Node3D

		var webxr_interface
		var vr_supported = false

		func _ready():
			# We assume this node has a button as a child.
			# This button is for the user to consent to entering immersive VR mode.
			$Button.pressed.connect(self._on_button_pressed)

			webxr_interface = XRServer.find_interface("WebXR")
			if webxr_interface:
				# WebXR uses a lot of asynchronous callbacks, so we connect to various
				# signals in order to receive them.
				webxr_interface.session_supported.connect(self._webxr_session_supported)
				webxr_interface.session_started.connect(self._webxr_session_started)
				webxr_interface.session_ended.connect(self._webxr_session_ended)
				webxr_interface.session_failed.connect(self._webxr_session_failed)

				# This returns immediately - our _webxr_session_supported() method
				# (which we connected to the "session_supported" signal above) will
				# be called sometime later to let us know if it's supported or not.
				webxr_interface.is_session_supported("immersive-vr")

		func _webxr_session_supported(session_mode, supported):
			if session_mode == 'immersive-vr':
				vr_supported = supported

		func _on_button_pressed():
			if not vr_supported:
				OS.alert("Your browser doesn't support VR")
				return

			# We want an immersive VR session, as opposed to AR ('immersive-ar') or a
			# simple 3DoF viewer ('viewer').
			webxr_interface.session_mode = 'immersive-vr'
			# 'bounded-floor' is room scale, 'local-floor' is a standing or sitting
			# experience (it puts you 1.6m above the ground if you have 3DoF headset),
			# whereas as 'local' puts you down at the XROrigin.
			# This list means it'll first try to request 'bounded-floor', then
			# fallback on 'local-floor' and ultimately 'local', if nothing else is
			# supported.
			webxr_interface.requested_reference_space_types = 'bounded-floor, local-floor, local'
			# In order to use 'local-floor' or 'bounded-floor' we must also
			# mark the features as required or optional. By including 'hand-tracking'
			# as an optional feature, it will be enabled if supported.
			webxr_interface.required_features = 'local-floor'
			webxr_interface.optional_features = 'bounded-floor, hand-tracking'

			# This will return false if we're unable to even request the session,
			# however, it can still fail asynchronously later in the process, so we
			# only know if it's really succeeded or failed when our
			# _webxr_session_started() or _webxr_session_failed() methods are called.
			if not webxr_interface.initialize():
				OS.alert("Failed to initialize")
				return

		func _webxr_session_started():
			$Button.visible = false
			# This tells Godot to start rendering to the headset.
			get_viewport().use_xr = true
			# This will be the reference space type you ultimately got, out of the
			# types that you requested above. This is useful if you want the game to
			# work a little differently in 'bounded-floor' versus 'local-floor'.
			print("Reference space type: ", webxr_interface.reference_space_type)
			# This will be the list of features that were successfully enabled
			# (except on browsers that don't support this property).
			print("Enabled features: ", webxr_interface.enabled_features)

		func _webxr_session_ended():
			$Button.visible = true
			# If the user exits immersive mode, then we tell Godot to render to the web
			# page again.
			get_viewport().use_xr = false

		func _webxr_session_failed(message):
			OS.alert("Failed to initialize: " + message)
		
```

		There are a couple ways to handle "controller" input:
		- Using `XRController3D` nodes and their `XRController3D.button_pressed` and `XRController3D.button_released` signals. This is how controllers are typically handled in XR apps in Godot, however, this will only work with advanced VR controllers like the Oculus Touch or Index controllers, for example.
		- Using the `select`, `squeeze` and related signals. This method will work for both advanced VR controllers, and non-traditional input sources like a tap on the screen, a spoken voice command or a button press on the device itself.
		You can use both methods to allow your game or app to support a wider or narrower set of devices and input methods, or to allow more advanced interactions with more advanced devices.

## 属性

- **`enabled_features`** `String`
  - 其它属性：getter=get_enabled_features · setter=
- **`optional_features`** `String`
  - 其它属性：getter=get_optional_features · setter=set_optional_features
- **`reference_space_type`** `String`
  - 其它属性：getter=get_reference_space_type · setter=
- **`requested_reference_space_types`** `String`
  - 其它属性：getter=get_requested_reference_space_types · setter=set_requested_reference_space_types
- **`required_features`** `String`
  - 其它属性：getter=get_required_features · setter=set_required_features
- **`session_mode`** `String`
  - 其它属性：getter=get_session_mode · setter=set_session_mode
- **`visibility_state`** `String`
  - 其它属性：getter=get_visibility_state · setter=

## 方法

### `get_available_display_refresh_rates() -> Array`
- 限定：qualifiers=const

Returns display refresh rates supported by the current HMD. Only returned if this feature is supported by the web browser and after the interface has been initialized.

### `get_display_refresh_rate() -> float`
- 限定：qualifiers=const

Returns the display refresh rate for the current HMD. Not supported on all HMDs and browsers. It may not report an accurate value until after using `set_display_refresh_rate`.

### `get_input_source_target_ray_mode(input_source_id: int) -> int`
- 限定：qualifiers=const

Returns the target ray mode for the given `input_source_id`.
				This can help interpret the input coming from that input source. See XRInputSource.targetRayMode (https://developer.mozilla.org/en-US/docs/Web/API/XRInputSource/targetRayMode) for more information.

### `get_input_source_tracker(input_source_id: int) -> XRControllerTracker`
- 限定：qualifiers=const

Gets an `XRControllerTracker` for the given `input_source_id`.
				In the context of WebXR, an input source can be an advanced VR controller like the Oculus Touch or Index controllers, or even a tap on the screen, a spoken voice command or a button press on the device itself. When a non-traditional input source is used, interpret the position and orientation of the `XRPositionalTracker` as a ray pointing at the object the user wishes to interact with.
				Use this method to get information about the input source that triggered one of these signals:
				- `selectstart`
				- `select`
				- `selectend`
				- `squeezestart`
				- `squeeze`
				- `squeezestart`

### `is_input_source_active(input_source_id: int) -> bool`
- 限定：qualifiers=const

Returns `true` if there is an active input source with the given `input_source_id`.

### `is_session_supported(session_mode: String) -> void`

Checks if the given `session_mode` is supported by the user's browser.
				Possible values come from WebXR's XRSessionMode (https://developer.mozilla.org/en-US/docs/Web/API/XRSessionMode), including: `"immersive-vr"`, `"immersive-ar"`, and `"inline"`.
				This method returns nothing, instead it emits the `session_supported` signal with the result.

### `set_display_refresh_rate(refresh_rate: float) -> void`

Sets the display refresh rate for the current HMD. Not supported on all HMDs and browsers. It won't take effect right away until after `display_refresh_rate_changed` is emitted.

## 信号

### `display_refresh_rate_changed()`

Emitted after the display's refresh rate has changed.

### `reference_space_reset()`

Emitted to indicate that the reference space has been reset or reconfigured.
				When (or whether) this is emitted depends on the user's browser or device, but may include when the user has changed the dimensions of their play space (which you may be able to access via `XRInterface.get_play_area`) or pressed/held a button to recenter their position.
				See WebXR's XRReferenceSpace reset event (https://developer.mozilla.org/en-US/docs/Web/API/XRReferenceSpace/reset_event) for more information.

### `select(input_source_id: int)`

Emitted after one of the input sources has finished its "primary action".
				Use `get_input_source_tracker` and `get_input_source_target_ray_mode` to get more information about the input source.

### `selectend(input_source_id: int)`

Emitted when one of the input sources has finished its "primary action".
				Use `get_input_source_tracker` and `get_input_source_target_ray_mode` to get more information about the input source.

### `selectstart(input_source_id: int)`

Emitted when one of the input source has started its "primary action".
				Use `get_input_source_tracker` and `get_input_source_target_ray_mode` to get more information about the input source.

### `session_ended()`

Emitted when the user ends the WebXR session (which can be done using UI from the browser or device).
				At this point, you should do `get_viewport().use_xr = false` to instruct Godot to resume rendering to the screen.

### `session_failed(message: String)`

Emitted by `XRInterface.initialize` if the session fails to start.
				`message` may optionally contain an error message from WebXR, or an empty string if no message is available.

### `session_started()`

Emitted by `XRInterface.initialize` if the session is successfully started.
				At this point, it's safe to do `get_viewport().use_xr = true` to instruct Godot to start rendering to the XR device.

### `session_supported(session_mode: String, supported: bool)`

Emitted by `is_session_supported` to indicate if the given `session_mode` is supported or not.

### `squeeze(input_source_id: int)`

Emitted after one of the input sources has finished its "primary squeeze action".
				Use `get_input_source_tracker` and `get_input_source_target_ray_mode` to get more information about the input source.

### `squeezeend(input_source_id: int)`

Emitted when one of the input sources has finished its "primary squeeze action".
				Use `get_input_source_tracker` and `get_input_source_target_ray_mode` to get more information about the input source.

### `squeezestart(input_source_id: int)`

Emitted when one of the input sources has started its "primary squeeze action".
				Use `get_input_source_tracker` and `get_input_source_target_ray_mode` to get more information about the input source.

### `visibility_state_changed()`

Emitted when `visibility_state` has changed.

## 枚举

### `TargetRayMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `TARGET_RAY_MODE_UNKNOWN` |  |
| `1` | `TARGET_RAY_MODE_GAZE` |  |
| `2` | `TARGET_RAY_MODE_TRACKED_POINTER` |  |
| `3` | `TARGET_RAY_MODE_SCREEN` |  |

## 教程链接

- [How to make a VR game for WebXR with Godot 4](None)

