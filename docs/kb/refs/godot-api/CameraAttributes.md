# CameraAttributes

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`CameraAttributes` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/CameraAttributes.md`

**摘要**：Parent class for camera settings.

## 描述

Controls camera-specific attributes such as depth of field and exposure override.
		When used in a `WorldEnvironment` it provides default settings for exposure, auto-exposure, and depth of field that will be used by all cameras without their own `CameraAttributes`, including the editor camera. When used in a `Camera3D` it will override any `CameraAttributes` set in the `WorldEnvironment`. When used in `VoxelGI` or `LightmapGI`, only the exposure settings will be used.
		See also `Environment` for general 3D environment settings.
		This is a pure virtual class that is inherited by `CameraAttributesPhysical` and `CameraAttributesPractical`.

## 属性

- **`auto_exposure_enabled`** `bool` = `false`
  - 其它属性：getter=is_auto_exposure_enabled · setter=set_auto_exposure_enabled
- **`auto_exposure_scale`** `float` = `0.4`
  - 其它属性：getter=get_auto_exposure_scale · setter=set_auto_exposure_scale
- **`auto_exposure_speed`** `float` = `0.5`
  - 其它属性：getter=get_auto_exposure_speed · setter=set_auto_exposure_speed
- **`exposure_multiplier`** `float` = `1.0`
  - 其它属性：getter=get_exposure_multiplier · setter=set_exposure_multiplier
- **`exposure_sensitivity`** `float` = `100.0`
  - 其它属性：getter=get_exposure_sensitivity · setter=set_exposure_sensitivity

