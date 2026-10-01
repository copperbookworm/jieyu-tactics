# CurveXYZTexture

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`CurveXYZTexture` → `Texture2D` → `Texture` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/CurveXYZTexture.md`

**摘要**：A 1D texture where the red, green, and blue color channels correspond to points on 3 curves.

## 描述

A 1D texture where the red, green, and blue color channels correspond to points on 3 unit `Curve` resources. Compared to using separate `CurveTexture`s, this further simplifies the task of saving curves as image files.
		If you only need to store one curve within a single texture, use `CurveTexture` instead. See also `GradientTexture1D` and `GradientTexture2D`.

## 属性

- **`curve_x`** `Curve`
  - 其它属性：getter=get_curve_x · setter=set_curve_x
- **`curve_y`** `Curve`
  - 其它属性：getter=get_curve_y · setter=set_curve_y
- **`curve_z`** `Curve`
  - 其它属性：getter=get_curve_z · setter=set_curve_z
- **`resource_local_to_scene`** `bool` = `false`
  - 其它属性：getter=is_local_to_scene · overrides=Resource · setter=set_local_to_scene
- **`width`** `int` = `256`
  - 其它属性：getter=get_width · setter=set_width

