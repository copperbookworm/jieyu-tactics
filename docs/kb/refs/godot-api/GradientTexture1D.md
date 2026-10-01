# GradientTexture1D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`GradientTexture1D` → `Texture2D` → `Texture` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/GradientTexture1D.md`

**摘要**：A 1D texture that uses colors obtained from a `Gradient`.

## 描述

A 1D texture that obtains colors from a `Gradient` to fill the texture data. The texture is filled by sampling the gradient for each pixel. Therefore, the texture does not necessarily represent an exact copy of the gradient, as it may miss some colors if there are not enough pixels. See also `GradientTexture2D`, `CurveTexture` and `CurveXYZTexture`.

## 属性

- **`gradient`** `Gradient`
  - 其它属性：getter=get_gradient · setter=set_gradient
- **`resource_local_to_scene`** `bool` = `false`
  - 其它属性：getter=is_local_to_scene · overrides=Resource · setter=set_local_to_scene
- **`use_hdr`** `bool` = `false`
  - 其它属性：getter=is_using_hdr · setter=set_use_hdr
- **`width`** `int` = `256`
  - 其它属性：getter=get_width · setter=set_width

