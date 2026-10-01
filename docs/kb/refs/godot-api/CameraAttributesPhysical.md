# CameraAttributesPhysical

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`CameraAttributesPhysical` → `CameraAttributes` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/CameraAttributesPhysical.md`

**摘要**：Physically-based camera settings.

## 描述

`CameraAttributesPhysical` is used to set rendering settings based on a physically-based camera's settings. It is responsible for exposure, auto-exposure, and depth of field.
		When used in a `WorldEnvironment` it provides default settings for exposure, auto-exposure, and depth of field that will be used by all cameras without their own `CameraAttributes`, including the editor camera. When used in a `Camera3D` it will override any `CameraAttributes` set in the `WorldEnvironment` and will override the `Camera3D`s `Camera3D.far`, `Camera3D.near`, `Camera3D.fov`, and `Camera3D.keep_aspect` properties. When used in `VoxelGI` or `LightmapGI`, only the exposure settings will be used.
		The default settings are intended for use in an outdoor environment, tips for settings for use in an indoor environment can be found in each setting's documentation.
		**Note:** Depth of field blur is only supported in the Forward+ and Mobile rendering methods, not Compatibility.
		**Note:** Auto-exposure is only supported in the Forward+ rendering method, not Mobile or Compatibility.

## 属性

- **`auto_exposure_max_exposure_value`** `float` = `10.0`
  - 其它属性：getter=get_auto_exposure_max_exposure_value · setter=set_auto_exposure_max_exposure_value
- **`auto_exposure_min_exposure_value`** `float` = `-8.0`
  - 其它属性：getter=get_auto_exposure_min_exposure_value · setter=set_auto_exposure_min_exposure_value
- **`exposure_aperture`** `float` = `16.0`
  - 其它属性：getter=get_aperture · setter=set_aperture
- **`exposure_shutter_speed`** `float` = `100.0`
  - 其它属性：getter=get_shutter_speed · setter=set_shutter_speed
- **`frustum_far`** `float` = `4000.0`
  - 其它属性：getter=get_far · setter=set_far
- **`frustum_focal_length`** `float` = `35.0`
  - 其它属性：getter=get_focal_length · setter=set_focal_length
- **`frustum_focus_distance`** `float` = `10.0`
  - 其它属性：getter=get_focus_distance · setter=set_focus_distance
- **`frustum_near`** `float` = `0.05`
  - 其它属性：getter=get_near · setter=set_near

## 方法

### `get_fov() -> float`
- 限定：qualifiers=const

Returns the vertical field of view that corresponds to the `frustum_focal_length`. This value is calculated internally whenever `frustum_focal_length` is changed.

## 教程链接

- [Physical light and camera units](None)

