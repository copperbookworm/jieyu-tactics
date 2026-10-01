# XRController3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`XRController3D` → `XRNode3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/XRController3D.md`

**摘要**：A 3D node representing a spatially-tracked controller.

## 描述

This is a helper 3D node that is linked to the tracking of controllers. It also offers several handy passthroughs to the state of buttons and such on the controllers.
		Controllers are linked by their ID. You can create controller nodes before the controllers are available. If your game always uses two controllers (one for each hand), you can predefine the controllers with ID 1 and 2; they will become active as soon as the controllers are identified. If you expect additional controllers to be used, you should react to the signals and add XRController3D nodes to your scene.
		The position of the controller node is automatically updated by the `XRServer`. This makes this node ideal to add child nodes to visualize the controller.
		The current `XRInterface` defines the names of inputs. In the case of OpenXR, these are the names of actions in the current action set from the OpenXR action map.

## 方法

### `get_float(name: StringName) -> float`
- 限定：qualifiers=const

Returns a numeric value for the input with the given `name`. This is used for triggers and grip sensors.
				**Note:** The current `XRInterface` defines the `name` for each input. In the case of OpenXR, these are the names of actions in the current action set.

### `get_input(name: StringName) -> Variant`
- 限定：qualifiers=const

Returns a `Variant` for the input with the given `name`. This works for any input type, the variant will be typed according to the actions configuration.
				**Note:** The current `XRInterface` defines the `name` for each input. In the case of OpenXR, these are the names of actions in the current action set.

### `get_tracker_hand() -> int`
- 限定：qualifiers=const

Returns the hand holding this controller, if known.

### `get_vector2(name: StringName) -> Vector2`
- 限定：qualifiers=const

Returns a `Vector2` for the input with the given `name`. This is used for thumbsticks and thumbpads found on many controllers.
				**Note:** The current `XRInterface` defines the `name` for each input. In the case of OpenXR, these are the names of actions in the current action set.

### `is_button_pressed(name: StringName) -> bool`
- 限定：qualifiers=const

Returns `true` if the button with the given `name` is pressed.
				**Note:** The current `XRInterface` defines the `name` for each input. In the case of OpenXR, these are the names of actions in the current action set.

## 信号

### `button_pressed(action_name: String)`

Emitted when a button on this controller is pressed.

### `button_released(action_name: String)`

Emitted when a button on this controller is released.

### `input_float_changed(action_name: String, value: float)`

Emitted when a trigger or similar input on this controller changes value.

### `input_vector2_changed(action_name: String, value: Vector2)`

Emitted when a thumbstick or thumbpad on this controller is moved.

### `profile_changed(role: String)`

Emitted when the interaction profile on this controller is changed.

## 教程链接

- [XR documentation index](None)

