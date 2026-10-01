# XRVRS

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`XRVRS` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/XRVRS.md`

**摘要**：Helper class for XR interfaces that generates VRS images.

## 描述

This class is used by various XR interfaces to generate VRS textures that can be used to speed up rendering.

## 属性

- **`vrs_min_radius`** `float` = `20.0`
  - 其它属性：getter=get_vrs_min_radius · setter=set_vrs_min_radius
- **`vrs_render_region`** `Rect2i` = `Rect2i(0, 0, 0, 0)`
  - 其它属性：getter=get_vrs_render_region · setter=set_vrs_render_region
- **`vrs_strength`** `float` = `1.0`
  - 其它属性：getter=get_vrs_strength · setter=set_vrs_strength

## 方法

### `make_vrs_texture(target_size: Vector2, eye_foci: PackedVector2Array) -> RID`

Generates the VRS texture based on a render `target_size` adjusted by our VRS tile size. For each eyes focal point passed in `eye_foci` a layer is created. Focal point should be in NDC.
				The result will be cached, requesting a VRS texture with unchanged parameters and settings will return the cached RID.

