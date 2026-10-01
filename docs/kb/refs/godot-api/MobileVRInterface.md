# MobileVRInterface

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`MobileVRInterface` → `XRInterface` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/MobileVRInterface.md`

**摘要**：Generic mobile VR implementation.

## 描述

This is a generic mobile VR implementation where you need to provide details about the phone and HMD used. It does not rely on any existing framework. This is the most basic interface we have. For the best effect, you need a mobile phone with a gyroscope and accelerometer.
		Note that even though there is no positional tracking, the camera will assume the headset is at a height of 1.85 meters. You can change this by setting `eye_height`.
		You can initialize this interface as follows:
		
```gdscript
		var interface = XRServer.find_interface("Native mobile")
		if interface and interface.initialize():
			get_viewport().use_xr = true
		
```

		**Note:** For Android, `ProjectSettings.input_devices/sensors/enable_accelerometer`, `ProjectSettings.input_devices/sensors/enable_gravity`, `ProjectSettings.input_devices/sensors/enable_gyroscope` and `ProjectSettings.input_devices/sensors/enable_magnetometer` must be enabled.

## 属性

- **`display_to_lens`** `float` = `4.0`
  - 其它属性：getter=get_display_to_lens · setter=set_display_to_lens
- **`display_width`** `float` = `14.5`
  - 其它属性：getter=get_display_width · setter=set_display_width
- **`eye_height`** `float` = `1.85`
  - 其它属性：getter=get_eye_height · setter=set_eye_height
- **`iod`** `float` = `6.0`
  - 其它属性：getter=get_iod · setter=set_iod
- **`k1`** `float` = `0.215`
  - 其它属性：getter=get_k1 · setter=set_k1
- **`k2`** `float` = `0.215`
  - 其它属性：getter=get_k2 · setter=set_k2
- **`offset_rect`** `Rect2` = `Rect2(0, 0, 1, 1)`
  - 其它属性：getter=get_offset_rect · setter=set_offset_rect
- **`oversample`** `float` = `1.5`
  - 其它属性：getter=get_oversample · setter=set_oversample
- **`vrs_min_radius`** `float` = `20.0`
  - 其它属性：getter=get_vrs_min_radius · setter=set_vrs_min_radius
- **`vrs_strength`** `float` = `1.0`
  - 其它属性：getter=get_vrs_strength · setter=set_vrs_strength
- **`xr_play_area_mode`** `int` = `1` · 枚举 `XRInterface.PlayAreaMode`
  - 其它属性：getter=get_play_area_mode · overrides=XRInterface · setter=set_play_area_mode

