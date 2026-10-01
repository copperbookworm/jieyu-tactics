# GeometryInstance3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`GeometryInstance3D` → `VisualInstance3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/GeometryInstance3D.md`

**摘要**：Base node for geometry-based visual instances.

## 描述

Base node for geometry-based visual instances. Shares some common functionality like visibility and custom materials.

## 属性

- **`cast_shadow`** `int` = `1` · 枚举 `GeometryInstance3D.ShadowCastingSetting`
  - 其它属性：getter=get_cast_shadows_setting · setter=set_cast_shadows_setting
- **`custom_aabb`** `AABB` = `AABB(0, 0, 0, 0, 0, 0)`
  - 其它属性：getter=get_custom_aabb · setter=set_custom_aabb
- **`extra_cull_margin`** `float` = `0.0`
  - 其它属性：getter=get_extra_cull_margin · setter=set_extra_cull_margin
- **`gi_lightmap_scale`** `int` = `0` · 枚举 `GeometryInstance3D.LightmapScale`
  - 其它属性：deprecated=Use [member gi_lightmap_texel_scale] instead. · getter=get_lightmap_scale · setter=set_lightmap_scale
- **`gi_lightmap_texel_scale`** `float` = `1.0`
  - 其它属性：getter=get_lightmap_texel_scale · setter=set_lightmap_texel_scale
- **`gi_mode`** `int` = `1` · 枚举 `GeometryInstance3D.GIMode`
  - 其它属性：getter=get_gi_mode · keywords=global_illumination_mode, light_bake_mode · setter=set_gi_mode
- **`ignore_occlusion_culling`** `bool` = `false`
  - 其它属性：getter=is_ignoring_occlusion_culling · setter=set_ignore_occlusion_culling
- **`lod_bias`** `float` = `1.0`
  - 其它属性：getter=get_lod_bias · setter=set_lod_bias
- **`material_overlay`** `Material`
  - 其它属性：getter=get_material_overlay · setter=set_material_overlay
- **`material_override`** `Material`
  - 其它属性：getter=get_material_override · setter=set_material_override
- **`transparency`** `float` = `0.0`
  - 其它属性：getter=get_transparency · keywords=opacity · setter=set_transparency
- **`visibility_range_begin`** `float` = `0.0`
  - 其它属性：getter=get_visibility_range_begin · keywords=lod_begin, hlod_begin · setter=set_visibility_range_begin
- **`visibility_range_begin_margin`** `float` = `0.0`
  - 其它属性：getter=get_visibility_range_begin_margin · keywords=lod_begin_margin, hlod_begin_margin · setter=set_visibility_range_begin_margin
- **`visibility_range_end`** `float` = `0.0`
  - 其它属性：getter=get_visibility_range_end · keywords=lod_end, hlod_end · setter=set_visibility_range_end
- **`visibility_range_end_margin`** `float` = `0.0`
  - 其它属性：getter=get_visibility_range_end_margin · keywords=lod_end_margin, hlod_end_margin · setter=set_visibility_range_end_margin
- **`visibility_range_fade_mode`** `int` = `0` · 枚举 `GeometryInstance3D.VisibilityRangeFadeMode`
  - 其它属性：getter=get_visibility_range_fade_mode · keywords=lod_fade_mode, hlod_fade_mode · setter=set_visibility_range_fade_mode

## 方法

### `get_instance_shader_parameter(name: StringName) -> Variant`
- 限定：qualifiers=const

Get the value of a shader parameter as set on this instance.

### `set_instance_shader_parameter(name: StringName, value: Variant) -> void`

Set the value of a shader uniform for this instance only (per-instance uniform ($DOCS_URL/tutorials/shaders/shader_reference/shading_language.html#per-instance-uniforms)). See also `ShaderMaterial.set_shader_parameter` to assign a uniform on all instances using the same `ShaderMaterial`.
				**Note:** For a shader uniform to be assignable on a per-instance basis, it *must* be defined with `instance uniform ...` rather than `uniform ...` in the shader code.
				**Note:** `name` is case-sensitive and must match the name of the uniform in the code exactly (not the capitalized name in the inspector).
				**Note:** Per-instance shader uniforms are only available in Spatial and CanvasItem shaders, but not for Fog, Sky, or Particles shaders.

## 枚举

### `ShadowCastingSetting`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SHADOW_CASTING_SETTING_OFF` |  |
| `1` | `SHADOW_CASTING_SETTING_ON` |  |
| `2` | `SHADOW_CASTING_SETTING_DOUBLE_SIDED` |  |
| `3` | `SHADOW_CASTING_SETTING_SHADOWS_ONLY` |  |

### `GIMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `GI_MODE_DISABLED` |  |
| `1` | `GI_MODE_STATIC` |  |
| `2` | `GI_MODE_DYNAMIC` |  |

### `LightmapScale`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `LIGHTMAP_SCALE_1X` |  |
| `1` | `LIGHTMAP_SCALE_2X` |  |
| `2` | `LIGHTMAP_SCALE_4X` |  |
| `3` | `LIGHTMAP_SCALE_8X` |  |
| `4` | `LIGHTMAP_SCALE_MAX` |  |

### `VisibilityRangeFadeMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `VISIBILITY_RANGE_FADE_DISABLED` |  |
| `1` | `VISIBILITY_RANGE_FADE_SELF` |  |
| `2` | `VISIBILITY_RANGE_FADE_DEPENDENCIES` |  |

## 教程链接

- [Visibility ranges (HLOD)](None)

