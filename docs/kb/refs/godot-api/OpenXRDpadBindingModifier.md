# OpenXRDpadBindingModifier

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OpenXRDpadBindingModifier` → `OpenXRIPBindingModifier` → `OpenXRBindingModifier` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/OpenXRDpadBindingModifier.md`

**摘要**：The DPad binding modifier converts an axis input to a dpad output.

## 描述

The DPad binding modifier converts an axis input to a dpad output, emulating a DPad. New input paths for each dpad direction will be added to the interaction profile. When bound to actions the DPad emulation will be activated. You should **not** combine dpad inputs with normal inputs in the same action set for the same control, this will result in an error being returned when suggested bindings are submitted to OpenXR.
		See XR_EXT_dpad_binding (https://registry.khronos.org/OpenXR/specs/1.1/html/xrspec.html#XR_EXT_dpad_binding) for in-depth details.
		**Note:** If the DPad binding modifier extension is enabled, all dpad binding paths will be available in the action map. Adding the modifier to an interaction profile allows you to further customize the behavior.

## 属性

- **`action_set`** `OpenXRActionSet`
  - 其它属性：getter=get_action_set · setter=set_action_set
- **`center_region`** `float` = `0.1`
  - 其它属性：getter=get_center_region · setter=set_center_region
- **`input_path`** `String` = `""`
  - 其它属性：getter=get_input_path · setter=set_input_path
- **`is_sticky`** `bool` = `false`
  - 其它属性：getter=get_is_sticky · setter=set_is_sticky
- **`off_haptic`** `OpenXRHapticBase`
  - 其它属性：getter=get_off_haptic · setter=set_off_haptic
- **`on_haptic`** `OpenXRHapticBase`
  - 其它属性：getter=get_on_haptic · setter=set_on_haptic
- **`threshold`** `float` = `0.6`
  - 其它属性：getter=get_threshold · setter=set_threshold
- **`threshold_released`** `float` = `0.4`
  - 其它属性：getter=get_threshold_released · setter=set_threshold_released
- **`wedge_angle`** `float` = `1.5707964`
  - 其它属性：getter=get_wedge_angle · setter=set_wedge_angle

