# Input

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Input` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Input.md`

**摘要**：A singleton for handling inputs.

## 描述

The `Input` singleton handles key presses, mouse buttons and movement, gamepads, and input actions. Actions and their events can be set in the **Input Map** tab in **Project > Project Settings**, or with the `InputMap` class.
		**Note:** `Input`'s methods reflect the global input state and are not affected by `Control.accept_event` or `Viewport.set_input_as_handled`, as those methods only deal with the way input is propagated in the `SceneTree`.

## 属性

- **`emulate_mouse_from_touch`** `bool`
  - 其它属性：getter=is_emulating_mouse_from_touch · setter=set_emulate_mouse_from_touch
- **`emulate_touch_from_mouse`** `bool`
  - 其它属性：getter=is_emulating_touch_from_mouse · setter=set_emulate_touch_from_mouse
- **`ignore_joypad_on_unfocused_application`** `bool`
  - 其它属性：getter=is_ignoring_joypad_on_unfocused_application · setter=set_ignore_joypad_on_unfocused_application
- **`mouse_mode`** `int` · 枚举 `Input.MouseMode`
  - 其它属性：getter=get_mouse_mode · setter=set_mouse_mode
- **`use_accumulated_input`** `bool`
  - 其它属性：getter=is_using_accumulated_input · setter=set_use_accumulated_input

## 方法

### `action_press(action: StringName, strength: float = 1.0) -> void`

This will simulate pressing the specified action.
				The strength can be used for non-boolean actions, it's ranged between 0 and 1 representing the intensity of the given action.
				**Note:** This method will not cause any `Node._input` calls. It is intended to be used with `is_action_pressed` and `is_action_just_pressed`. If you want to simulate `_input`, use `parse_input_event` instead.

### `action_release(action: StringName) -> void`

If the specified action is already pressed, this will release it.

### `add_joy_mapping(mapping: String, update_existing: bool = false) -> void`

Adds a new mapping entry (in SDL2 format) to the mapping database. Optionally update already connected devices.

### `clear_joy_motion_sensors_calibration(device: int) -> void`
- 限定：experimental=

Clears the calibration information for the specified joypad's motion sensors, if it has any and if they were calibrated.
				See `start_joy_motion_sensors_calibration` for an example on how to use joypad motion sensors and calibration in your games.
				**Note:** This feature is only supported on Windows, Linux, macOS, and iOS.

### `flush_buffered_events() -> void`

Sends all input events which are in the current buffer to the game loop. These events may have been buffered as a result of accumulated input (`use_accumulated_input`) or agile input flushing (`ProjectSettings.input_devices/buffering/agile_event_flushing`).
				The engine will already do this itself at key execution points (at least once per frame). However, this can be useful in advanced cases where you want precise control over the timing of event handling.

### `get_accelerometer() -> Vector3`
- 限定：qualifiers=const

Returns the acceleration in m/s² of the device's accelerometer sensor, if the device has one. Otherwise, the method returns `Vector3.ZERO`.
				Note this method returns an empty `Vector3` when running from the editor even when your device has an accelerometer. You must export your project to a supported device to read values from the accelerometer.
				**Note:** This method only works on Android and iOS. On other platforms, it always returns `Vector3.ZERO`.
				**Note:** For Android, `ProjectSettings.input_devices/sensors/enable_accelerometer` must be enabled.

### `get_action_raw_strength(action: StringName, exact_match: bool = false) -> float`
- 限定：qualifiers=const

Returns a value between 0 and 1 representing the raw intensity of the given action, ignoring the action's deadzone. In most cases, you should use `get_action_strength` instead.
				If `exact_match` is `false`, it ignores additional input modifiers for `InputEventKey` and `InputEventMouseButton` events, and the direction for `InputEventJoypadMotion` events.

### `get_action_strength(action: StringName, exact_match: bool = false) -> float`
- 限定：qualifiers=const

Returns a value between 0 and 1 representing the intensity of the given action. In a joypad, for example, the further away the axis (analog sticks or L2, R2 triggers) is from the dead zone, the closer the value will be to 1. If the action is mapped to a control that has no axis such as the keyboard, the value returned will be 0 or 1.
				If `exact_match` is `false`, it ignores additional input modifiers for `InputEventKey` and `InputEventMouseButton` events, and the direction for `InputEventJoypadMotion` events.

### `get_axis(negative_action: StringName, positive_action: StringName) -> float`
- 限定：qualifiers=const

Get axis input by specifying two actions, one negative and one positive.
				This is a shorthand for writing `Input.get_action_strength("positive_action") - Input.get_action_strength("negative_action")`.

### `get_connected_joypads() -> int[]`

Returns an `Array` containing the device IDs of all currently connected joypads.
				**Note:** The order of connected joypads can not be guaranteed to be the same after a project and/or the editor is restarted, because Godot doesn't save the order of joypad connections. Joypads are registered in the order they are discovered by Godot.

### `get_current_cursor_shape() -> int`
- 限定：qualifiers=const

Returns the currently assigned cursor shape.

### `get_gravity() -> Vector3`
- 限定：qualifiers=const

Returns the gravity in m/s² of the device's accelerometer sensor, if the device has one. Otherwise, the method returns `Vector3.ZERO`.
				**Note:** This method only works on Android and iOS. On other platforms, it always returns `Vector3.ZERO`.
				**Note:** For Android, `ProjectSettings.input_devices/sensors/enable_gravity` must be enabled.

### `get_gyroscope() -> Vector3`
- 限定：qualifiers=const

Returns the rotation rate in rad/s around a device's X, Y, and Z axes of the gyroscope sensor, if the device has one. Otherwise, the method returns `Vector3.ZERO`.
				**Note:** This method only works on Android and iOS. On other platforms, it always returns `Vector3.ZERO`.
				**Note:** For Android, `ProjectSettings.input_devices/sensors/enable_gyroscope` must be enabled.

### `get_joy_accelerometer(device: int) -> Vector3`
- 限定：experimental= · qualifiers=const

Returns the acceleration, including the force of gravity, in m/s² of the joypad's accelerometer sensor, if the joypad has one and it's currently enabled. Otherwise, the method returns `Vector3.ZERO`. See also `get_joy_gravity` and `set_joy_motion_sensors_enabled`.
				For a joypad held in front of you, the returned axes are defined as follows:
				+X ... -X: left ... right;
				+Y ... -Y: bottom ... top;
				+Z ... -Z: farther ... closer.
				The gravity part value is measured as a vector with length of `9.8` away from the center of the Earth, which is a negative Y value.
				**Note:** This feature is only supported on Windows, Linux, and macOS. On iOS, joypad accelerometer sensor reading is not supported due to OS limitations.

### `get_joy_axis(device: int, axis: int) -> float`
- 限定：qualifiers=const

Returns the current value of the joypad axis at index `axis`.

### `get_joy_gravity(device: int) -> Vector3`
- 限定：experimental= · qualifiers=const

Returns the gravity in m/s² of the joypad's accelerometer sensor, if the joypad has one and it's currently enabled. Otherwise, the method returns `Vector3.ZERO`. See also `get_joy_accelerometer` and `set_joy_motion_sensors_enabled`.
				For a joypad held in front of you, the returned axes are defined as follows:
				+X ... -X: left ... right;
				+Y ... -Y: bottom ... top;
				+Z ... -Z: farther ... closer.
				The gravity part value is measured as a vector with length of `9.8` away from the center of the Earth, which is a negative Y value.
				**Note:** This feature is only supported on Windows, Linux, and macOS. On iOS, joypad accelerometer sensor reading is not supported due to OS limitations.

### `get_joy_guid(device: int) -> String`
- 限定：qualifiers=const

Returns an SDL-compatible device GUID on platforms that use gamepad remapping, e.g. `030000004c050000c405000000010000`. Returns an empty string if it cannot be found. Godot uses SDL's internal mappings, supplemented by community-contributed mappings, to determine gamepad names and mappings based on this GUID.
				On Windows, all XInput joypad GUIDs will be overridden by Godot to `__XINPUT_DEVICE__`, because their mappings are the same.

### `get_joy_gyroscope(device: int) -> Vector3`
- 限定：experimental= · qualifiers=const

Returns the rotation rate in rad/s around a joypad's X, Y, and Z axes of the gyroscope sensor, if the joypad has one and it's currently enabled. Otherwise, the method returns `Vector3.ZERO`. See also `set_joy_motion_sensors_enabled`.
				The rotation is positive in the counter-clockwise direction.
				For a joypad held in front of you, the returned axes are defined as follows:
				X: Angular speed around the X axis (pitch);
				Y: Angular speed around the Y axis (yaw);
				Z: Angular speed around the Z axis (roll).
				See `start_joy_motion_sensors_calibration` for an example on how to use joypad gyroscope and gyroscope calibration in your games.
				**Note:** This feature is only supported on Windows, Linux, macOS, and iOS.

### `get_joy_info(device: int) -> Dictionary`
- 限定：qualifiers=const

Returns a dictionary with extra platform-specific information about the device, e.g. the raw gamepad name from the OS or the Steam Input index.
				On Windows, Linux, macOS, and iOS, the dictionary contains the following fields:
				`raw_name`: The name of the controller as it came from the OS, before getting renamed by the controller database.
				`vendor_id`: The USB vendor ID of the device.
				`product_id`: The USB product ID of the device.
				`serial_number`: The serial number of the device. This key won't be present if the serial number is unavailable.
				The dictionary can also include the following fields under selected platforms:
				`steam_input_index`: The Steam Input gamepad index (Windows, Linux, and macOS only). If the device is not a Steam Input device this key won't be present.
				`xinput_index`: The index of the controller in the XInput system (Windows only). This key won't be present for devices not handled by XInput.
				**Note:** The returned dictionary is always empty on Android and Web.

### `get_joy_motion_sensors_calibration(device: int) -> Dictionary`
- 限定：experimental= · qualifiers=const

Returns the calibration information about the specified joypad's motion sensors in the form of a `Dictionary`, if it has any and if they have been calibrated, otherwise returns an empty `Dictionary`.
				The dictionary contains the following fields:
				`gyroscope_offset`: average offset in gyroscope values from `Vector2.ZERO` in rad/s.
				See `start_joy_motion_sensors_calibration` for an example on how to use joypad motion sensors and calibration in your games.
				**Note:** This feature is only supported on Windows, Linux, macOS, and iOS.

### `get_joy_motion_sensors_rate(device: int) -> float`
- 限定：experimental= · qualifiers=const

Returns the joypad's motion sensor rate in Hz, if the joypad has motion sensors and they're currently enabled. See also `set_joy_motion_sensors_enabled`.
				**Note:** This feature is only supported on Windows, Linux, macOS, and iOS.

### `get_joy_name(device: int) -> String`

Returns the name of the joypad at the specified device index, e.g. `PS4 Controller`. Godot uses the SDL2 game controller database (https://github.com/gabomdq/SDL_GameControllerDB) to determine gamepad names.

### `get_joy_vibration_duration(device: int) -> float`

Returns the duration of the current vibration effect in seconds.
				**Note:** This method returns the same value that was passed to `start_joy_vibration`, and this value does **not** change when the joypad's vibration runs out, it only gets reset after a call to `stop_joy_vibration`.
				If you want to check if a joypad is still vibrating, use `is_joy_vibrating` instead.

### `get_joy_vibration_remaining_duration(device: int) -> float`
- 限定：experimental=

Returns the remaining duration of the current vibration effect in seconds.

### `get_joy_vibration_strength(device: int) -> Vector2`

Returns the strength of the joypad vibration: x is the strength of the weak motor, and y is the strength of the strong motor.
				**Note:** This method returns the same values that were passed to `start_joy_vibration`, and these values do **not** change when the joypad's vibration runs out, they only get reset after a call to `stop_joy_vibration`.
				If you want to check if a joypad is still vibrating, use `is_joy_vibrating` instead.

### `get_last_mouse_screen_velocity() -> Vector2`

Returns the last mouse velocity in screen coordinates. To provide a precise and jitter-free velocity, mouse velocity is only calculated every 0.1s. Therefore, mouse velocity will lag mouse movements.

### `get_last_mouse_velocity() -> Vector2`

Returns the last mouse velocity. To provide a precise and jitter-free velocity, mouse velocity is only calculated every 0.1s. Therefore, mouse velocity will lag mouse movements.

### `get_magnetometer() -> Vector3`
- 限定：qualifiers=const

Returns the magnetic field strength in micro-Tesla for all axes of the device's magnetometer sensor, if the device has one. Otherwise, the method returns `Vector3.ZERO`.
				**Note:** This method only works on Android and iOS. On other platforms, it always returns `Vector3.ZERO`.
				**Note:** For Android, `ProjectSettings.input_devices/sensors/enable_magnetometer` must be enabled.

### `get_mouse_button_mask() -> int`
- 限定：qualifiers=const

Returns mouse buttons as a bitmask. If multiple mouse buttons are pressed at the same time, the bits are added together. Equivalent to `DisplayServer.mouse_get_button_state`.

### `get_vector(negative_x: StringName, positive_x: StringName, negative_y: StringName, positive_y: StringName, deadzone: float = -1.0) -> Vector2`
- 限定：qualifiers=const

Gets an input vector by specifying four actions for the positive and negative X and Y axes.
				This method is useful when getting vector input, such as from a joystick, directional pad, arrows, or WASD. The vector has its length limited to 1 and has a circular deadzone, which is useful for using vector input as movement.
				By default, the deadzone is automatically calculated from the average of the action deadzones. However, you can override the deadzone to be whatever you want (on the range of 0 to 1).

### `has_joy_light(device: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the joypad has an LED light that can change colors and/or brightness. See also `set_joy_light`.
				**Note:** This feature is only supported on Windows, Linux, macOS, and iOS.

### `has_joy_motion_sensors(device: int) -> bool`
- 限定：experimental= · qualifiers=const

Returns `true` if the joypad has motion sensors (accelerometer and gyroscope).
				**Note:** On iOS, joypad accelerometer sensor reading is not supported due to OS limitations.
				**Note:** This feature is only supported on Windows, Linux, macOS, and iOS.

### `has_joy_vibration(device: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the joypad supports vibration. See also `start_joy_vibration`.
				**Note:** For macOS, vibration is only supported in macOS 11 and later. When connected via USB, vibration is only supported for major brand controllers (except Xbox One and Xbox Series X/S controllers) due to macOS limitations.

### `is_action_just_pressed(action: StringName, exact_match: bool = false) -> bool`
- 限定：qualifiers=const

Returns `true` when the user has *started* pressing the action event in the current frame or physics tick. It will only return `true` on the frame or tick that the user pressed down the button.
				This is useful for code that needs to run only once when an action is pressed, instead of every frame while it's pressed.
				If `exact_match` is `false`, it ignores additional input modifiers for `InputEventKey` and `InputEventMouseButton` events, and the direction for `InputEventJoypadMotion` events.
				**Note:** Returning `true` does not imply that the action is *still* pressed. An action can be pressed and released again rapidly, and `true` will still be returned so as not to miss input.
				**Note:** Due to keyboard ghosting, `is_action_just_pressed` may return `false` even if one of the action's keys is pressed. See Input examples ($DOCS_URL/tutorials/inputs/input_examples.html#keyboard-events) in the documentation for more information.
				**Note:** During input handling (e.g. `Node._input`), use `InputEvent.is_action_pressed` instead to query the action state of the current event. See also `is_action_just_pressed_by_event`.

### `is_action_just_pressed_by_event(action: StringName, event: InputEvent, exact_match: bool = false) -> bool`
- 限定：qualifiers=const

Returns `true` when the user has *started* pressing the action event in the current frame or physics tick, and the first event that triggered action press in the current frame/physics tick was `event`. It will only return `true` on the frame or tick that the user pressed down the button.
				This is useful for code that needs to run only once when an action is pressed, and the action is processed during input handling (e.g. `Node._input`).
				If `exact_match` is `false`, it ignores additional input modifiers for `InputEventKey` and `InputEventMouseButton` events, and the direction for `InputEventJoypadMotion` events.
				**Note:** Returning `true` does not imply that the action is *still* pressed. An action can be pressed and released again rapidly, and `true` will still be returned so as not to miss input.
				**Note:** Due to keyboard ghosting, `is_action_just_pressed` may return `false` even if one of the action's keys is pressed. See Input examples ($DOCS_URL/tutorials/inputs/input_examples.html#keyboard-events) in the documentation for more information.

### `is_action_just_released(action: StringName, exact_match: bool = false) -> bool`
- 限定：qualifiers=const

Returns `true` when the user *stops* pressing the action event in the current frame or physics tick. It will only return `true` on the frame or tick that the user releases the button.
				**Note:** Returning `true` does not imply that the action is *still* not pressed. An action can be released and pressed again rapidly, and `true` will still be returned so as not to miss input.
				If `exact_match` is `false`, it ignores additional input modifiers for `InputEventKey` and `InputEventMouseButton` events, and the direction for `InputEventJoypadMotion` events.
				**Note:** During input handling (e.g. `Node._input`), use `InputEvent.is_action_released` instead to query the action state of the current event. See also `is_action_just_released_by_event`.

### `is_action_just_released_by_event(action: StringName, event: InputEvent, exact_match: bool = false) -> bool`
- 限定：qualifiers=const

Returns `true` when the user *stops* pressing the action event in the current frame or physics tick, and the first event that triggered action release in the current frame/physics tick was `event`. It will only return `true` on the frame or tick that the user releases the button.
				This is useful when an action is processed during input handling (e.g. `Node._input`).
				**Note:** Returning `true` does not imply that the action is *still* not pressed. An action can be released and pressed again rapidly, and `true` will still be returned so as not to miss input.
				If `exact_match` is `false`, it ignores additional input modifiers for `InputEventKey` and `InputEventMouseButton` events, and the direction for `InputEventJoypadMotion` events.

### `is_action_pressed(action: StringName, exact_match: bool = false) -> bool`
- 限定：qualifiers=const

Returns `true` if you are pressing the action event.
				If `exact_match` is `false`, it ignores additional input modifiers for `InputEventKey` and `InputEventMouseButton` events, and the direction for `InputEventJoypadMotion` events.
				**Note:** Due to keyboard ghosting, `is_action_pressed` may return `false` even if one of the action's keys is pressed. See Input examples ($DOCS_URL/tutorials/inputs/input_examples.html#keyboard-events) in the documentation for more information.

### `is_anything_pressed() -> bool`
- 限定：qualifiers=const

Returns `true` if any action, key, joypad button, or mouse button is being pressed. This will also return `true` if any action is simulated via code by calling `action_press`.

### `is_joy_button_pressed(device: int, button: int) -> bool`
- 限定：keywords=is_gamepad_button_pressed, is_controller_button_pressed · qualifiers=const

Returns `true` if you are pressing the joypad button at index `button`.
				**Note:** If you want to check if a joypad button was just pressed, use Godot's input action system with `is_action_just_pressed` or use the `Node._input` method like this instead:
				`codeblocks`
				`gdscript`
				func _input(event):
					if event is InputEventJoypadButton and event.is_pressed() and event.button_index == JOY_BUTTON_A:
						pass # Your code here.
				
				`csharp`
				public override void _Input(InputEvent @event)
				{
					if (@event is InputEventJoypadButton eventButton && eventButton.Pressed && eventButton.ButtonIndex == JoyButton.A)
					{
						// Your code here.
					}
				}

### `is_joy_known(device: int) -> bool`
- 限定：keywords=is_gamepad_known, is_controller_known

Returns `true` if the system knows the specified device. This means that it sets all button and axis indices. Unknown joypads are not expected to match these constants, but you can still retrieve events from them.

### `is_joy_motion_sensors_calibrated(device: int) -> bool`
- 限定：experimental= · qualifiers=const

Returns `true` if the joypad's motion sensors have been calibrated.
				See `start_joy_motion_sensors_calibration` for an example on how to use joypad motion sensors and calibration in your games.
				**Note:** This feature is only supported on Windows, Linux, macOS, and iOS.

### `is_joy_motion_sensors_calibrating(device: int) -> bool`
- 限定：experimental= · qualifiers=const

Returns `true` if the joypad's motion sensors are currently being calibrated.
				See `start_joy_motion_sensors_calibration` for an example on how to use joypad motion sensors and calibration in your games.
				**Note:** This feature is only supported on Windows, Linux, macOS, and iOS.

### `is_joy_motion_sensors_enabled(device: int) -> bool`
- 限定：experimental= · qualifiers=const

Returns `true` if the requested joypad has motion sensors (accelerometer and gyroscope) and they are currently enabled. See also `set_joy_motion_sensors_enabled` and `has_joy_motion_sensors`.
				See `start_joy_motion_sensors_calibration` for an example on how to use joypad motion sensors and calibration in your games.
				**Note:** This feature is only supported on Windows, Linux, macOS, and iOS.

### `is_joy_vibrating(device: int) -> bool`
- 限定：experimental=

Returns `true` if the joypad is still vibrating after a call to `start_joy_vibration`.
				Unlike `get_joy_vibration_strength` and `get_joy_vibration_duration`, this method returns `false` after the joypad's vibration runs out.

### `is_key_label_pressed(keycode: int) -> bool`
- 限定：qualifiers=const

Returns `true` if you are pressing the key with the `keycode` printed on it. You can pass a `Key` constant or any Unicode character code.
				**Note:** If you want to check if a key was just pressed by using its label, use Godot's input action system with `is_action_just_pressed` or use the `Node._input` method like this instead:
				`codeblocks`
				`gdscript`
				func _input(event):
					if event is InputEventKey and not event.is_echo() and event.is_pressed() and event.key_label == KEY_SPACE:
						pass # Your code here.
				
				`csharp`
				public override void _Input(InputEvent @event)
				{
					if (@event is InputEventKey eventKey && !eventKey.IsEcho() && eventKey.Pressed && eventKey.KeyLabel == Key.Space)
					{
						// Your code here.
					}
				}

### `is_key_pressed(keycode: int) -> bool`
- 限定：qualifiers=const

Returns `true` if you are pressing the Latin key in the current keyboard layout. You can pass a `Key` constant.
				`is_key_pressed` is only recommended over `is_physical_key_pressed` in non-game applications. This ensures that shortcut keys behave as expected depending on the user's keyboard layout, as keyboard shortcuts are generally dependent on the keyboard layout in non-game applications. If in doubt, use `is_physical_key_pressed`.
				**Note:** Due to keyboard ghosting, `is_key_pressed` may return `false` even if one of the action's keys is pressed. See Input examples ($DOCS_URL/tutorials/inputs/input_examples.html#keyboard-events) in the documentation for more information.
				**Note:** If you want to check if a key was just pressed by using its keycode, use Godot's input action system with `is_action_just_pressed` or use the `Node._input` method like this instead:
				`codeblocks`
				`gdscript`
				func _input(event):
					if event is InputEventKey and not event.is_echo() and event.is_pressed() and event.keycode == KEY_SPACE:
						pass # Your code here.
				
				`csharp`
				public override void _Input(InputEvent @event)
				{
					if (@event is InputEventKey eventKey && !eventKey.IsEcho() && eventKey.Pressed && eventKey.Keycode == Key.Space)
					{
						// Your code here.
					}
				}

### `is_mouse_button_pressed(button: int) -> bool`
- 限定：qualifiers=const

Returns `true` if you are pressing the mouse button specified with `MouseButton`.
				**Note:** If you want to check if a mouse button was just pressed, use Godot's input action system with `is_action_just_pressed` or use the `Node._input` method like this instead:
				`codeblocks`
				`gdscript`
				func _input(event):
					if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
						pass # Your code here.
				
				`csharp`
				public override void _Input(InputEvent @event)
				{
					if (@event is InputEventMouseButton eventMouseButton && eventMouseButton.Pressed && eventMouseButton.ButtonIndex == MouseButton.Left)
					{
						// Your code here.
					}
				}

### `is_physical_key_pressed(keycode: int) -> bool`
- 限定：qualifiers=const

Returns `true` if you are pressing the key in the physical location on the 101/102-key US QWERTY keyboard. You can pass a `Key` constant.
				`is_physical_key_pressed` is recommended over `is_key_pressed` for in-game actions, as it will make W/A/S/D layouts work regardless of the user's keyboard layout. `is_physical_key_pressed` will also ensure that the top row number keys work on any keyboard layout. If in doubt, use `is_physical_key_pressed`.
				**Note:** Due to keyboard ghosting, `is_physical_key_pressed` may return `false` even if one of the action's keys is pressed. See Input examples ($DOCS_URL/tutorials/inputs/input_examples.html#keyboard-events) in the documentation for more information.
				**Note:** If you want to check if a key was just pressed by using its physical keycode, use Godot's input action system with `is_action_just_pressed` or use the `Node._input` method like this instead:
				`codeblocks`
				`gdscript`
				func _input(event):
					if event is InputEventKey and not event.is_echo() and event.is_pressed() and event.physical_keycode == KEY_SPACE:
						pass # Your code here.
				
				`csharp`
				public override void _Input(InputEvent @event)
				{
					if (@event is InputEventKey eventKey && !eventKey.IsEcho() && eventKey.Pressed && eventKey.PhysicalKeycode == Key.Space)
					{
						// Your code here.
					}
				}

### `parse_input_event(event: InputEvent) -> void`

Feeds an `InputEvent` to the game. Can be used to artificially trigger input events from code. Also generates `Node._input` calls.
				`codeblocks`
				`gdscript`
				var cancel_event = InputEventAction.new()
				cancel_event.action = "ui_cancel"
				cancel_event.pressed = true
				Input.parse_input_event(cancel_event)
				
				`csharp`
				var cancelEvent = new InputEventAction();
				cancelEvent.Action = "ui_cancel";
				cancelEvent.Pressed = true;
				Input.ParseInputEvent(cancelEvent);
				
				
				**Note:** Calling this function has no influence on the operating system. So for example sending an `InputEventMouseMotion` will not move the OS mouse cursor to the specified position (use `warp_mouse` instead) and sending Alt/Cmd + Tab as `InputEventKey` won't toggle between active windows.

### `remove_joy_mapping(guid: String) -> void`

Removes all mappings from the internal database that match the given GUID. All currently connected joypads that use this GUID will become unmapped.
				On Android, Godot will map to an internal fallback mapping.

### `set_accelerometer(value: Vector3) -> void`

Sets the acceleration value of the accelerometer sensor. Can be used for debugging on devices without a hardware sensor, for example in an editor on a PC.
				**Note:** This value can be immediately overwritten by the hardware sensor value on Android and iOS.

### `set_custom_mouse_cursor(image: Resource, shape: int = 0, hotspot: Vector2 = Vector2(0, 0)) -> void`

Sets a custom mouse cursor image, which is only visible inside the game window, for the given mouse `shape`. The hotspot can also be specified. Passing `null` to the image parameter resets to the system cursor.
				`image` can be either `Texture2D` or `Image` and its size must be lower than or equal to 256×256. To avoid rendering issues, sizes lower than or equal to 128×128 are recommended.
				`hotspot` must be within `image`'s size.
				**Note:** `AnimatedTexture`s aren't supported as custom mouse cursors. If using an `AnimatedTexture`, only the first frame will be displayed.
				**Note:** The **Lossless**, **Lossy** or **Uncompressed** compression modes are recommended. The **Video RAM** compression mode can be used, but it will be decompressed on the CPU, which means loading times are slowed down and no memory is saved compared to lossless modes.
				**Note:** On the web platform, the maximum allowed cursor image size is 128×128. Cursor images larger than 32×32 will also only be displayed if the mouse cursor image is entirely located within the page for security reasons (https://chromestatus.com/feature/5825971391299584).

### `set_default_cursor_shape(shape: int = 0) -> void`

Sets the default cursor shape to be used in the viewport instead of `CURSOR_ARROW`.
				**Note:** If you want to change the default cursor shape for `Control`'s nodes, use `Control.mouse_default_cursor_shape` instead.
				**Note:** This method generates an `InputEventMouseMotion` to update cursor immediately.

### `set_gravity(value: Vector3) -> void`

Sets the gravity value of the accelerometer sensor. Can be used for debugging on devices without a hardware sensor, for example in an editor on a PC.
				**Note:** This value can be immediately overwritten by the hardware sensor value on Android and iOS.

### `set_gyroscope(value: Vector3) -> void`

Sets the value of the rotation rate of the gyroscope sensor. Can be used for debugging on devices without a hardware sensor, for example in an editor on a PC.
				**Note:** This value can be immediately overwritten by the hardware sensor value on Android and iOS.

### `set_joy_light(device: int, color: Color) -> void`

Sets the joypad's LED light, if available, to the specified color. See also `has_joy_light`.
				**Note:** There is no way to get the color of the light from a joypad. If you need to know the assigned color, store it separately.
				**Note:** This feature is only supported on Windows, Linux, macOS, and iOS.

### `set_joy_motion_sensors_calibration(device: int, calibration_info: Dictionary) -> void`
- 限定：experimental=

Sets the specified joypad's calibration information. See also `get_joy_motion_sensors_calibration`.
				See `start_joy_motion_sensors_calibration` for an example on how to use joypad motion sensors and calibration in your games.
				**Note:** This feature is only supported on Windows, Linux, macOS, and iOS.

### `set_joy_motion_sensors_enabled(device: int, enable: bool) -> void`
- 限定：experimental=

Enables or disables the motion sensors (accelerometer and gyroscope), if available, on the specified joypad.
				See `start_joy_motion_sensors_calibration` for an example on how to use joypad motion sensors and calibration in your games.
				It's recommended to disable the motion sensors when they're no longer being used, because otherwise it might drain the controller battery faster.
				**Note:** This feature is only supported on Windows, Linux, macOS, and iOS.

### `set_magnetometer(value: Vector3) -> void`

Sets the value of the magnetic field of the magnetometer sensor. Can be used for debugging on devices without a hardware sensor, for example in an editor on a PC.
				**Note:** This value can be immediately overwritten by the hardware sensor value on Android and iOS.

### `should_ignore_device(vendor_id: int, product_id: int) -> bool`
- 限定：qualifiers=const

Queries whether an input device should be ignored or not. Devices can be ignored by setting the environment variable `SDL_GAMECONTROLLER_IGNORE_DEVICES`. Read the SDL documentation (https://wiki.libsdl.org/SDL2) for more information.
				**Note:** Some 3rd party tools can contribute to the list of ignored devices. For example, *SteamInput* creates virtual devices from physical devices for remapping purposes. To avoid handling the same input device twice, the original device is added to the ignore list.

### `start_joy_motion_sensors_calibration(device: int) -> void`
- 限定：experimental=

Starts the process of calibrating the specified joypad's gyroscope, if it has one.
				Once a joypad's gyroscope has been calibrated correctly (e.g. laying still on a table without being rotated), `get_joy_gyroscope` will return values close or equal to `Vector3.ZERO` when the joypad is not being rotated.
				Here's an example of how to use joypad gyroscope and gyroscope calibration in your games:
				`codeblocks`
				`gdscript`
				const GYRO_SENSITIVITY = 10.0

				func _ready():
					# In this example we only use the first connected joypad (id 0).
					if 0 not in Input.get_connected_joypads():
						return

					if not Input.has_joy_motion_sensors(0):
						return

					# We must enable the motion sensors before using them.
					Input.set_joy_motion_sensors_enabled(0, true)

					# (Tell the users here that they need to put their joypads on a flat surface and wait for confirmation.)

					# Start the calibration process.
					calibrate_motion()

				func _process(delta):
					# Only move the object if the joypad motion sensors are calibrated.
					if Input.is_joy_motion_sensors_calibrated(0):
						move_object(delta)

				func calibrate_motion():
					Input.start_joy_motion_sensors_calibration(0)

					# Wait for some time.
					await get_tree().create_timer(1.0).timeout

					Input.stop_joy_motion_sensors_calibration(0)
					# The joypad is now calibrated.

				func move_object(delta):
					var node: Node3D = ... # Put your node here.

					var gyro := Input.get_joy_gyroscope(0)
					node.rotation.x -= -gyro.y * GYRO_SENSITIVITY * delta # Use rotation around the Y axis (yaw) here.
					node.rotation.y += -gyro.x * GYRO_SENSITIVITY * delta # Use rotation around the X axis (pitch) here.
				
				`csharp`
				private const float GyroSensitivity = 10.0;

				public override void _Ready()
				{
					// In this example we only use the first connected joypad (id 0).
					if (!Input.GetConnectedJoypads().Contains(0))
					{
						return;
					}

					if (!Input.HasJoyMotionSensors(0))
					{
						return;
					}

					// We must enable the accelerometer and the gyroscope before using them.
					Input.SetJoyMotionSensorsEnabled(0, true);

					// (Tell the users here that they need to put their joypads on a flat surface and wait for confirmation.)

					// Start the calibration process.
					CalibrateMotion();
				}

				public override void _Process(double delta)
				{
					// Only move the object if the joypad motion sensors are calibrated.
					if (Input.IsJoyMotionSensorsCalibrated(0))
					{
						MoveObject(delta);
					}
				}

				private async Task CalibrateMotion()
				{
					Input.StartJoyMotionSensorsCalibration(0);

					// Wait for some time.
					await ToSignal(GetTree().CreateTimer(1.0), SceneTreeTimer.SignalName.Timeout);

					Input.StopJoyMotionSensorsCalibration(0);
					// The joypad is now calibrated.
				}

				private void MoveObject(double delta)
				{
					Node3D node = ... ; // Put your object here.
					Vector3 gyro = Input.GetJoyGyroscope(0);
					Vector3 rotation = node.Rotation;
					rotation.X -= -gyro.Y * GyroSensitivity * (float)delta; // Use rotation around the Y axis (yaw) here.
					rotation.Y += -gyro.X * GyroSensitivity * (float)delta; // Use rotation around the X axis (pitch) here.
					node.Rotation = rotation;
				}
				
				
				**Note:** Accelerometer sensor doesn't usually require calibration.
				**Note:** This feature is only supported on Windows, Linux, macOS, and iOS.

### `start_joy_vibration(device: int, weak_magnitude: float, strong_magnitude: float, duration: float = 0) -> void`

Starts to vibrate the joypad. See also `has_joy_vibration` and `is_joy_vibrating`.
				Joypads usually come with two rumble motors, a strong and a weak one.
				`weak_magnitude` is the strength of the weak motor (between `0.0` and `1.0`).
				`strong_magnitude` is the strength of the strong motor (between `0.0` and `1.0`).
				`duration` is the duration of the effect in seconds (a duration of `0.0` will try to play the vibration as long as possible, which is about 65 seconds).
				The vibration can be stopped early by calling `stop_joy_vibration`.
				See also `get_joy_vibration_strength` and `get_joy_vibration_duration`.
				**Note:** For macOS, vibration is only supported in macOS 11 and later. When connected via USB, vibration is only supported for major brand controllers (except Xbox One and Xbox Series X/S controllers) due to macOS limitations.

### `stop_joy_motion_sensors_calibration(device: int) -> void`
- 限定：experimental=

Stops the calibration process of the specified joypad's motion sensors.
				See `start_joy_motion_sensors_calibration` for an example on how to use joypad motion sensors and calibration in your games.
				**Note:** This feature is only supported on Windows, Linux, macOS, and iOS.

### `stop_joy_vibration(device: int) -> void`

Stops the vibration of the joypad started with `start_joy_vibration`.

### `vibrate_handheld(duration_ms: int = 500, amplitude: float = -1.0) -> void`

Vibrate the handheld device for the specified duration in milliseconds.
				`amplitude` is the strength of the vibration, as a value between `0.0` and `1.0`. If set to `-1.0`, the default vibration strength of the device is used.
				**Note:** This method is implemented on Android, iOS, and Web. It has no effect on other platforms.
				**Note:** For Android, `vibrate_handheld` requires enabling the `VIBRATE` permission in the export preset. Otherwise, `vibrate_handheld` will have no effect.
				**Note:** For iOS, specifying the duration is only supported in iOS 13 and later.
				**Note:** For Web, the amplitude cannot be changed.
				**Note:** Some web browsers such as Safari and Firefox for Android do not support `vibrate_handheld`.
				**Note:** Device settings such as vibration on/off, "do not disturb" mode or specific haptic feedback on/off may prevent `vibrate_handheld` effects.

### `warp_mouse(position: Vector2) -> void`

Sets the mouse position to the specified vector, provided in pixels and relative to an origin at the upper left corner of the currently focused Window Manager game window.
				Mouse position is clipped to the limits of the screen resolution, or to the limits of the game window if `MouseMode` is set to `MOUSE_MODE_CONFINED` or `MOUSE_MODE_CONFINED_HIDDEN`.
				**Note:** `warp_mouse` is only supported on Windows, macOS and Linux. It has no effect on Android, iOS and Web.

## 信号

### `joy_connection_changed(device: int, connected: bool)`

Emitted when a joypad device has been connected or disconnected.

## 枚举

### `MouseMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `MOUSE_MODE_VISIBLE` |  |
| `1` | `MOUSE_MODE_HIDDEN` |  |
| `2` | `MOUSE_MODE_CAPTURED` |  |
| `3` | `MOUSE_MODE_CONFINED` |  |
| `4` | `MOUSE_MODE_CONFINED_HIDDEN` |  |
| `5` | `MOUSE_MODE_MAX` |  |

### `CursorShape`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `CURSOR_ARROW` |  |
| `1` | `CURSOR_IBEAM` |  |
| `2` | `CURSOR_POINTING_HAND` |  |
| `3` | `CURSOR_CROSS` |  |
| `4` | `CURSOR_WAIT` |  |
| `5` | `CURSOR_BUSY` |  |
| `6` | `CURSOR_DRAG` |  |
| `7` | `CURSOR_CAN_DROP` |  |
| `8` | `CURSOR_FORBIDDEN` |  |
| `9` | `CURSOR_VSIZE` |  |
| `10` | `CURSOR_HSIZE` |  |
| `11` | `CURSOR_BDIAGSIZE` |  |
| `12` | `CURSOR_FDIAGSIZE` |  |
| `13` | `CURSOR_MOVE` |  |
| `14` | `CURSOR_VSPLIT` |  |
| `15` | `CURSOR_HSPLIT` |  |
| `16` | `CURSOR_HELP` |  |

## 教程链接

- [Inputs documentation index](None)
- [2D Dodge The Creeps Demo](None)
- [3D Voxel Demo](None)

