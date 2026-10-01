# CameraAttributesPractical

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`CameraAttributesPractical` → `CameraAttributes` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/CameraAttributesPractical.md`

**摘要**：Camera settings in an easy to use format.

## 描述

Controls camera-specific attributes such as auto-exposure, depth of field, and exposure override.
		When used in a `WorldEnvironment` it provides default settings for exposure, auto-exposure, and depth of field that will be used by all cameras without their own `CameraAttributes`, including the editor camera. When used in a `Camera3D` it will override any `CameraAttributes` set in the `WorldEnvironment`. When used in `VoxelGI` or `LightmapGI`, only the exposure settings will be used.
		**Note:** Depth of field blur is only supported in the Forward+ and Mobile rendering methods, not Compatibility.
		**Note:** Auto-exposure is only supported in the Forward+ rendering method, not Mobile or Compatibility.

## 属性

- **`auto_exposure_max_sensitivity`** `float` = `800.0`
  - 其它属性：getter=get_auto_exposure_max_sensitivity · setter=set_auto_exposure_max_sensitivity
- **`auto_exposure_min_sensitivity`** `float` = `0.0`
  - 其它属性：getter=get_auto_exposure_min_sensitivity · setter=set_auto_exposure_min_sensitivity
- **`dof_blur_amount`** `float` = `0.1`
  - 其它属性：getter=get_dof_blur_amount · setter=set_dof_blur_amount
- **`dof_blur_far_distance`** `float` = `10.0`
  - 其它属性：getter=get_dof_blur_far_distance · setter=set_dof_blur_far_distance
- **`dof_blur_far_enabled`** `bool` = `false`
  - 其它属性：getter=is_dof_blur_far_enabled · setter=set_dof_blur_far_enabled
- **`dof_blur_far_transition`** `float` = `5.0`
  - 其它属性：getter=get_dof_blur_far_transition · setter=set_dof_blur_far_transition
- **`dof_blur_near_distance`** `float` = `2.0`
  - 其它属性：getter=get_dof_blur_near_distance · setter=set_dof_blur_near_distance
- **`dof_blur_near_enabled`** `bool` = `false`
  - 其它属性：getter=is_dof_blur_near_enabled · setter=set_dof_blur_near_enabled
- **`dof_blur_near_transition`** `float` = `1.0`
  - 其它属性：getter=get_dof_blur_near_transition · setter=set_dof_blur_near_transition

