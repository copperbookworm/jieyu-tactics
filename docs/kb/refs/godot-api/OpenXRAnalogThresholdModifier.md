# OpenXRAnalogThresholdModifier

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OpenXRAnalogThresholdModifier` → `OpenXRActionBindingModifier` → `OpenXRBindingModifier` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/OpenXRAnalogThresholdModifier.md`

**摘要**：The analog threshold binding modifier can modify a float input to a boolean input with specified thresholds.

## 描述

The analog threshold binding modifier can modify a float input to a boolean input with specified thresholds.
		See XR_VALVE_analog_threshold (https://registry.khronos.org/OpenXR/specs/1.1/html/xrspec.html#XR_VALVE_analog_threshold) for in-depth details.

## 属性

- **`off_haptic`** `OpenXRHapticBase`
  - 其它属性：getter=get_off_haptic · setter=set_off_haptic
- **`off_threshold`** `float` = `0.4`
  - 其它属性：getter=get_off_threshold · setter=set_off_threshold
- **`on_haptic`** `OpenXRHapticBase`
  - 其它属性：getter=get_on_haptic · setter=set_on_haptic
- **`on_threshold`** `float` = `0.6`
  - 其它属性：getter=get_on_threshold · setter=set_on_threshold

