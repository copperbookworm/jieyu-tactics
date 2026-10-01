# CurveTexture

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`CurveTexture` → `Texture2D` → `Texture` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/CurveTexture.md`

**摘要**：A 1D texture where pixel brightness corresponds to points on a curve.

## 描述

A 1D texture where pixel brightness corresponds to points on a unit `Curve` resource, either in grayscale or in red. This visual representation simplifies the task of saving curves as image files.
		If you need to store up to 3 curves within a single texture, use `CurveXYZTexture` instead. See also `GradientTexture1D` and `GradientTexture2D`.

## 属性

- **`curve`** `Curve`
  - 其它属性：getter=get_curve · setter=set_curve
- **`resource_local_to_scene`** `bool` = `false`
  - 其它属性：getter=is_local_to_scene · overrides=Resource · setter=set_local_to_scene
- **`texture_mode`** `int` = `0` · 枚举 `CurveTexture.TextureMode`
  - 其它属性：getter=get_texture_mode · setter=set_texture_mode
- **`width`** `int` = `256`
  - 其它属性：getter=get_width · setter=set_width

## 枚举

### `TextureMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `TEXTURE_MODE_RGB` |  |
| `1` | `TEXTURE_MODE_RED` |  |

