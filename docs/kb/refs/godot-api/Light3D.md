# Light3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Light3D` → `VisualInstance3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Light3D.md`

**摘要**：Provides a base class for different kinds of light nodes.

## 描述

Light3D is the *abstract* base class for light nodes. As it can't be instantiated, it shouldn't be used directly. Other types of light nodes inherit from it. Light3D contains the common variables and parameters used for lighting.

## 属性

- **`distance_fade_begin`** `float` = `40.0`
  - 其它属性：getter=get_distance_fade_begin · keywords=lod_begin · setter=set_distance_fade_begin
- **`distance_fade_enabled`** `bool` = `false`
  - 其它属性：getter=is_distance_fade_enabled · keywords=lod_enabled · setter=set_enable_distance_fade
- **`distance_fade_length`** `float` = `10.0`
  - 其它属性：getter=get_distance_fade_length · keywords=lod_length · setter=set_distance_fade_length
- **`distance_fade_shadow`** `float` = `50.0`
  - 其它属性：getter=get_distance_fade_shadow · keywords=lod_shadow · setter=set_distance_fade_shadow
- **`editor_only`** `bool` = `false`
  - 其它属性：getter=is_editor_only · setter=set_editor_only
- **`light_angular_distance`** `float` = `0.0`
  - 其它属性：getter=get_param · keywords=pcss · setter=set_param
- **`light_bake_mode`** `int` = `2` · 枚举 `Light3D.BakeMode`
  - 其它属性：getter=get_bake_mode · keywords=global_illumination_mode, gi_mode · setter=set_bake_mode
- **`light_color`** `Color` = `Color(1, 1, 1, 1)`
  - 其它属性：getter=get_color · setter=set_color
- **`light_cull_mask`** `int` = `4294967295`
  - 其它属性：getter=get_cull_mask · setter=set_cull_mask
- **`light_energy`** `float` = `1.0`
  - 其它属性：getter=get_param · setter=set_param
- **`light_indirect_energy`** `float` = `1.0`
  - 其它属性：getter=get_param · setter=set_param
- **`light_intensity_lumens`** `float`
  - 其它属性：getter=get_param · setter=set_param
- **`light_intensity_lux`** `float`
  - 其它属性：getter=get_param · setter=set_param
- **`light_negative`** `bool` = `false`
  - 其它属性：getter=is_negative · setter=set_negative
- **`light_projector`** `Texture2D`
  - 其它属性：getter=get_projector · keywords=cookie, gobo · setter=set_projector
- **`light_size`** `float` = `0.0`
  - 其它属性：getter=get_param · keywords=pcss · setter=set_param
- **`light_specular`** `float` = `1.0`
  - 其它属性：getter=get_param · setter=set_param
- **`light_temperature`** `float`
  - 其它属性：getter=get_temperature · setter=set_temperature
- **`light_volumetric_fog_energy`** `float` = `1.0`
  - 其它属性：getter=get_param · setter=set_param
- **`shadow_bias`** `float` = `0.1`
  - 其它属性：getter=get_param · setter=set_param
- **`shadow_blur`** `float` = `1.0`
  - 其它属性：getter=get_param · setter=set_param
- **`shadow_caster_mask`** `int` = `4294967295`
  - 其它属性：getter=get_shadow_caster_mask · setter=set_shadow_caster_mask
- **`shadow_enabled`** `bool` = `false`
  - 其它属性：getter=has_shadow · setter=set_shadow
- **`shadow_normal_bias`** `float` = `2.0`
  - 其它属性：getter=get_param · setter=set_param
- **`shadow_opacity`** `float` = `1.0`
  - 其它属性：getter=get_param · setter=set_param
- **`shadow_reverse_cull_face`** `bool` = `false`
  - 其它属性：getter=get_shadow_reverse_cull_face · setter=set_shadow_reverse_cull_face
- **`shadow_transmittance_bias`** `float` = `0.05`
  - 其它属性：getter=get_param · setter=set_param

## 方法

### `get_correlated_color() -> Color`
- 限定：qualifiers=const

Returns the `Color` of an idealized blackbody at the given `light_temperature`. This value is calculated internally based on the `light_temperature`. This `Color` is multiplied by `light_color` before being sent to the `RenderingServer`.

### `get_param(param: int) -> float`
- 限定：qualifiers=const

Returns the value of the specified `Light3D.Param` parameter.

### `set_param(param: int, value: float) -> void`

Sets the value of the specified `Light3D.Param` parameter.

## 枚举

### `Param`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `PARAM_ENERGY` |  |
| `1` | `PARAM_INDIRECT_ENERGY` |  |
| `2` | `PARAM_VOLUMETRIC_FOG_ENERGY` |  |
| `3` | `PARAM_SPECULAR` |  |
| `4` | `PARAM_RANGE` |  |
| `5` | `PARAM_SIZE` |  |
| `6` | `PARAM_ATTENUATION` |  |
| `7` | `PARAM_SPOT_ANGLE` |  |
| `8` | `PARAM_SPOT_ATTENUATION` |  |
| `9` | `PARAM_SHADOW_MAX_DISTANCE` |  |
| `10` | `PARAM_SHADOW_SPLIT_1_OFFSET` |  |
| `11` | `PARAM_SHADOW_SPLIT_2_OFFSET` |  |
| `12` | `PARAM_SHADOW_SPLIT_3_OFFSET` |  |
| `13` | `PARAM_SHADOW_FADE_START` |  |
| `14` | `PARAM_SHADOW_NORMAL_BIAS` |  |
| `15` | `PARAM_SHADOW_BIAS` |  |
| `16` | `PARAM_SHADOW_PANCAKE_SIZE` |  |
| `17` | `PARAM_SHADOW_OPACITY` |  |
| `18` | `PARAM_SHADOW_BLUR` |  |
| `19` | `PARAM_TRANSMITTANCE_BIAS` |  |
| `20` | `PARAM_INTENSITY` |  |
| `21` | `PARAM_MAX` |  |

### `BakeMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `BAKE_DISABLED` |  |
| `1` | `BAKE_STATIC` |  |
| `2` | `BAKE_DYNAMIC` |  |

## 教程链接

- [3D lights and shadows](None)
- [Faking global illumination](None)
- [Third Person Shooter (TPS) Demo](None)

