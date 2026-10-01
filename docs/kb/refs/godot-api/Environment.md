# Environment

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Environment` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Environment.md`

**摘要**：Resource for environment nodes (like `WorldEnvironment`) that define multiple rendering options.

## 描述

Resource for environment nodes (like `WorldEnvironment`) that define multiple environment operations (such as background `Sky` or `Color`, ambient light, fog, depth-of-field...). These parameters affect the final render of the scene. The order of these operations is:
		- Depth of Field Blur
		- Auto Exposure
		- Glow
		- Tonemap
		- Adjustments

## 属性

- **`adjustment_brightness`** `float` = `1.0`
  - 其它属性：getter=get_adjustment_brightness · setter=set_adjustment_brightness
- **`adjustment_color_correction`** `Texture`
  - 其它属性：getter=get_adjustment_color_correction · setter=set_adjustment_color_correction
- **`adjustment_contrast`** `float` = `1.0`
  - 其它属性：getter=get_adjustment_contrast · setter=set_adjustment_contrast
- **`adjustment_enabled`** `bool` = `false`
  - 其它属性：getter=is_adjustment_enabled · setter=set_adjustment_enabled
- **`adjustment_saturation`** `float` = `1.0`
  - 其它属性：getter=get_adjustment_saturation · setter=set_adjustment_saturation
- **`ambient_light_color`** `Color` = `Color(0, 0, 0, 1)`
  - 其它属性：getter=get_ambient_light_color · setter=set_ambient_light_color
- **`ambient_light_energy`** `float` = `1.0`
  - 其它属性：getter=get_ambient_light_energy · setter=set_ambient_light_energy
- **`ambient_light_sky_contribution`** `float` = `1.0`
  - 其它属性：getter=get_ambient_light_sky_contribution · setter=set_ambient_light_sky_contribution
- **`ambient_light_source`** `int` = `0` · 枚举 `Environment.AmbientSource`
  - 其它属性：getter=get_ambient_source · setter=set_ambient_source
- **`background_camera_feed_id`** `int` = `1`
  - 其它属性：getter=get_camera_feed_id · setter=set_camera_feed_id
- **`background_canvas_max_layer`** `int` = `0`
  - 其它属性：getter=get_canvas_max_layer · setter=set_canvas_max_layer
- **`background_color`** `Color` = `Color(0, 0, 0, 1)`
  - 其它属性：getter=get_bg_color · setter=set_bg_color
- **`background_energy_multiplier`** `float` = `1.0`
  - 其它属性：getter=get_bg_energy_multiplier · setter=set_bg_energy_multiplier
- **`background_intensity`** `float` = `30000.0`
  - 其它属性：getter=get_bg_intensity · setter=set_bg_intensity
- **`background_mode`** `int` = `0` · 枚举 `Environment.BGMode`
  - 其它属性：getter=get_background · setter=set_background
- **`fog_aerial_perspective`** `float` = `0.0`
  - 其它属性：getter=get_fog_aerial_perspective · setter=set_fog_aerial_perspective
- **`fog_density`** `float` = `0.01`
  - 其它属性：getter=get_fog_density · setter=set_fog_density
- **`fog_depth_begin`** `float` = `10.0`
  - 其它属性：getter=get_fog_depth_begin · setter=set_fog_depth_begin
- **`fog_depth_curve`** `float` = `1.0`
  - 其它属性：getter=get_fog_depth_curve · setter=set_fog_depth_curve
- **`fog_depth_end`** `float` = `100.0`
  - 其它属性：getter=get_fog_depth_end · setter=set_fog_depth_end
- **`fog_enabled`** `bool` = `false`
  - 其它属性：getter=is_fog_enabled · setter=set_fog_enabled
- **`fog_height`** `float` = `0.0`
  - 其它属性：getter=get_fog_height · setter=set_fog_height
- **`fog_height_density`** `float` = `0.0`
  - 其它属性：getter=get_fog_height_density · setter=set_fog_height_density
- **`fog_light_color`** `Color` = `Color(0.518, 0.553, 0.608, 1)`
  - 其它属性：getter=get_fog_light_color · setter=set_fog_light_color
- **`fog_light_energy`** `float` = `1.0`
  - 其它属性：getter=get_fog_light_energy · setter=set_fog_light_energy
- **`fog_mode`** `int` = `0` · 枚举 `Environment.FogMode`
  - 其它属性：getter=get_fog_mode · setter=set_fog_mode
- **`fog_sky_affect`** `float` = `1.0`
  - 其它属性：getter=get_fog_sky_affect · setter=set_fog_sky_affect
- **`fog_sun_scatter`** `float` = `0.0`
  - 其它属性：getter=get_fog_sun_scatter · setter=set_fog_sun_scatter
- **`glow_blend_mode`** `int` = `1` · 枚举 `Environment.GlowBlendMode`
  - 其它属性：getter=get_glow_blend_mode · setter=set_glow_blend_mode
- **`glow_bloom`** `float` = `0.0`
  - 其它属性：getter=get_glow_bloom · setter=set_glow_bloom
- **`glow_enabled`** `bool` = `false`
  - 其它属性：getter=is_glow_enabled · setter=set_glow_enabled
- **`glow_hdr_luminance_cap`** `float` = `12.0`
  - 其它属性：getter=get_glow_hdr_luminance_cap · setter=set_glow_hdr_luminance_cap
- **`glow_hdr_scale`** `float` = `2.0`
  - 其它属性：getter=get_glow_hdr_bleed_scale · setter=set_glow_hdr_bleed_scale
- **`glow_hdr_threshold`** `float` = `1.0`
  - 其它属性：getter=get_glow_hdr_bleed_threshold · setter=set_glow_hdr_bleed_threshold
- **`glow_intensity`** `float` = `0.3`
  - 其它属性：getter=get_glow_intensity · setter=set_glow_intensity
- **`glow_levels/1`** `float` = `0.0`
  - 其它属性：getter=get_glow_level · setter=set_glow_level
- **`glow_levels/2`** `float` = `0.8`
  - 其它属性：getter=get_glow_level · setter=set_glow_level
- **`glow_levels/3`** `float` = `0.4`
  - 其它属性：getter=get_glow_level · setter=set_glow_level
- **`glow_levels/4`** `float` = `0.1`
  - 其它属性：getter=get_glow_level · setter=set_glow_level
- **`glow_levels/5`** `float` = `0.0`
  - 其它属性：getter=get_glow_level · setter=set_glow_level
- **`glow_levels/6`** `float` = `0.0`
  - 其它属性：getter=get_glow_level · setter=set_glow_level
- **`glow_levels/7`** `float` = `0.0`
  - 其它属性：getter=get_glow_level · setter=set_glow_level
- **`glow_map`** `Texture`
  - 其它属性：getter=get_glow_map · setter=set_glow_map
- **`glow_map_strength`** `float` = `0.8`
  - 其它属性：getter=get_glow_map_strength · setter=set_glow_map_strength
- **`glow_mix`** `float` = `0.05`
  - 其它属性：getter=get_glow_mix · setter=set_glow_mix
- **`glow_normalized`** `bool` = `false`
  - 其它属性：getter=is_glow_normalized · setter=set_glow_normalized
- **`glow_strength`** `float` = `1.0`
  - 其它属性：getter=get_glow_strength · setter=set_glow_strength
- **`reflected_light_source`** `int` = `0` · 枚举 `Environment.ReflectionSource`
  - 其它属性：getter=get_reflection_source · setter=set_reflection_source
- **`sdfgi_bounce_feedback`** `float` = `0.5`
  - 其它属性：getter=get_sdfgi_bounce_feedback · setter=set_sdfgi_bounce_feedback
- **`sdfgi_cascade0_distance`** `float` = `12.8`
  - 其它属性：getter=get_sdfgi_cascade0_distance · setter=set_sdfgi_cascade0_distance
- **`sdfgi_cascades`** `int` = `4`
  - 其它属性：getter=get_sdfgi_cascades · setter=set_sdfgi_cascades
- **`sdfgi_enabled`** `bool` = `false`
  - 其它属性：getter=is_sdfgi_enabled · setter=set_sdfgi_enabled
- **`sdfgi_energy`** `float` = `1.0`
  - 其它属性：getter=get_sdfgi_energy · setter=set_sdfgi_energy
- **`sdfgi_max_distance`** `float` = `204.8`
  - 其它属性：getter=get_sdfgi_max_distance · setter=set_sdfgi_max_distance
- **`sdfgi_min_cell_size`** `float` = `0.2`
  - 其它属性：getter=get_sdfgi_min_cell_size · setter=set_sdfgi_min_cell_size
- **`sdfgi_normal_bias`** `float` = `1.1`
  - 其它属性：getter=get_sdfgi_normal_bias · setter=set_sdfgi_normal_bias
- **`sdfgi_probe_bias`** `float` = `1.1`
  - 其它属性：getter=get_sdfgi_probe_bias · setter=set_sdfgi_probe_bias
- **`sdfgi_read_sky_light`** `bool` = `true`
  - 其它属性：getter=is_sdfgi_reading_sky_light · setter=set_sdfgi_read_sky_light
- **`sdfgi_use_occlusion`** `bool` = `false`
  - 其它属性：getter=is_sdfgi_using_occlusion · setter=set_sdfgi_use_occlusion
- **`sdfgi_y_scale`** `int` = `1` · 枚举 `Environment.SDFGIYScale`
  - 其它属性：getter=get_sdfgi_y_scale · setter=set_sdfgi_y_scale
- **`sky`** `Sky`
  - 其它属性：getter=get_sky · setter=set_sky
- **`sky_custom_fov`** `float` = `0.0`
  - 其它属性：getter=get_sky_custom_fov · setter=set_sky_custom_fov
- **`sky_rotation`** `Vector3` = `Vector3(0, 0, 0)`
  - 其它属性：getter=get_sky_rotation · setter=set_sky_rotation
- **`ssao_ao_channel_affect`** `float` = `0.0`
  - 其它属性：getter=get_ssao_ao_channel_affect · setter=set_ssao_ao_channel_affect
- **`ssao_detail`** `float` = `0.5`
  - 其它属性：getter=get_ssao_detail · setter=set_ssao_detail
- **`ssao_enabled`** `bool` = `false`
  - 其它属性：getter=is_ssao_enabled · setter=set_ssao_enabled
- **`ssao_horizon`** `float` = `0.06`
  - 其它属性：getter=get_ssao_horizon · setter=set_ssao_horizon
- **`ssao_intensity`** `float` = `2.0`
  - 其它属性：getter=get_ssao_intensity · setter=set_ssao_intensity
- **`ssao_light_affect`** `float` = `0.0`
  - 其它属性：getter=get_ssao_direct_light_affect · setter=set_ssao_direct_light_affect
- **`ssao_power`** `float` = `1.5`
  - 其它属性：getter=get_ssao_power · setter=set_ssao_power
- **`ssao_radius`** `float` = `1.0`
  - 其它属性：getter=get_ssao_radius · setter=set_ssao_radius
- **`ssao_sharpness`** `float` = `0.98`
  - 其它属性：getter=get_ssao_sharpness · setter=set_ssao_sharpness
- **`ssil_enabled`** `bool` = `false`
  - 其它属性：getter=is_ssil_enabled · setter=set_ssil_enabled
- **`ssil_intensity`** `float` = `1.0`
  - 其它属性：getter=get_ssil_intensity · setter=set_ssil_intensity
- **`ssil_normal_rejection`** `float` = `1.0`
  - 其它属性：getter=get_ssil_normal_rejection · setter=set_ssil_normal_rejection
- **`ssil_radius`** `float` = `5.0`
  - 其它属性：getter=get_ssil_radius · setter=set_ssil_radius
- **`ssil_sharpness`** `float` = `0.98`
  - 其它属性：getter=get_ssil_sharpness · setter=set_ssil_sharpness
- **`ssr_depth_tolerance`** `float` = `0.5`
  - 其它属性：getter=get_ssr_depth_tolerance · setter=set_ssr_depth_tolerance
- **`ssr_enabled`** `bool` = `false`
  - 其它属性：getter=is_ssr_enabled · setter=set_ssr_enabled
- **`ssr_fade_in`** `float` = `0.15`
  - 其它属性：getter=get_ssr_fade_in · setter=set_ssr_fade_in
- **`ssr_fade_out`** `float` = `2.0`
  - 其它属性：getter=get_ssr_fade_out · setter=set_ssr_fade_out
- **`ssr_max_steps`** `int` = `64`
  - 其它属性：getter=get_ssr_max_steps · setter=set_ssr_max_steps
- **`tonemap_agx_contrast`** `float` = `1.25`
  - 其它属性：getter=get_tonemap_agx_contrast · setter=set_tonemap_agx_contrast
- **`tonemap_agx_white`** `float` = `16.29`
  - 其它属性：getter=get_tonemap_agx_white · setter=set_tonemap_agx_white
- **`tonemap_exposure`** `float` = `1.0`
  - 其它属性：getter=get_tonemap_exposure · setter=set_tonemap_exposure
- **`tonemap_mode`** `int` = `0` · 枚举 `Environment.ToneMapper`
  - 其它属性：getter=get_tonemapper · setter=set_tonemapper
- **`tonemap_white`** `float` = `1.0`
  - 其它属性：getter=get_tonemap_white · setter=set_tonemap_white
- **`volumetric_fog_albedo`** `Color` = `Color(1, 1, 1, 1)`
  - 其它属性：getter=get_volumetric_fog_albedo · setter=set_volumetric_fog_albedo
- **`volumetric_fog_ambient_inject`** `float` = `0.0`
  - 其它属性：getter=get_volumetric_fog_ambient_inject · setter=set_volumetric_fog_ambient_inject
- **`volumetric_fog_anisotropy`** `float` = `0.2`
  - 其它属性：getter=get_volumetric_fog_anisotropy · setter=set_volumetric_fog_anisotropy
- **`volumetric_fog_density`** `float` = `0.05`
  - 其它属性：getter=get_volumetric_fog_density · setter=set_volumetric_fog_density
- **`volumetric_fog_detail_spread`** `float` = `2.0`
  - 其它属性：getter=get_volumetric_fog_detail_spread · setter=set_volumetric_fog_detail_spread
- **`volumetric_fog_emission`** `Color` = `Color(0, 0, 0, 1)`
  - 其它属性：getter=get_volumetric_fog_emission · setter=set_volumetric_fog_emission
- **`volumetric_fog_emission_energy`** `float` = `1.0`
  - 其它属性：getter=get_volumetric_fog_emission_energy · setter=set_volumetric_fog_emission_energy
- **`volumetric_fog_enabled`** `bool` = `false`
  - 其它属性：getter=is_volumetric_fog_enabled · setter=set_volumetric_fog_enabled
- **`volumetric_fog_gi_inject`** `float` = `1.0`
  - 其它属性：getter=get_volumetric_fog_gi_inject · setter=set_volumetric_fog_gi_inject
- **`volumetric_fog_length`** `float` = `64.0`
  - 其它属性：getter=get_volumetric_fog_length · setter=set_volumetric_fog_length
- **`volumetric_fog_sky_affect`** `float` = `1.0`
  - 其它属性：getter=get_volumetric_fog_sky_affect · setter=set_volumetric_fog_sky_affect
- **`volumetric_fog_temporal_reprojection_amount`** `float` = `0.9`
  - 其它属性：getter=get_volumetric_fog_temporal_reprojection_amount · setter=set_volumetric_fog_temporal_reprojection_amount
- **`volumetric_fog_temporal_reprojection_enabled`** `bool` = `true`
  - 其它属性：getter=is_volumetric_fog_temporal_reprojection_enabled · setter=set_volumetric_fog_temporal_reprojection_enabled

## 方法

### `get_glow_level(idx: int) -> float`
- 限定：qualifiers=const

Returns the intensity of the glow level `idx`.

### `set_glow_level(idx: int, intensity: float) -> void`

Sets the intensity of the glow level `idx`. A value above `0.0` enables the level. Each level relies on the previous level. This means that enabling higher glow levels will slow down the glow effect rendering, even if previous levels aren't enabled.

## 枚举

### `BGMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `BG_CLEAR_COLOR` |  |
| `1` | `BG_COLOR` |  |
| `2` | `BG_SKY` |  |
| `3` | `BG_CANVAS` |  |
| `4` | `BG_KEEP` |  |
| `5` | `BG_CAMERA_FEED` |  |
| `6` | `BG_MAX` |  |

### `AmbientSource`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `AMBIENT_SOURCE_BG` |  |
| `1` | `AMBIENT_SOURCE_DISABLED` |  |
| `2` | `AMBIENT_SOURCE_COLOR` |  |
| `3` | `AMBIENT_SOURCE_SKY` |  |

### `ReflectionSource`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `REFLECTION_SOURCE_BG` |  |
| `1` | `REFLECTION_SOURCE_DISABLED` |  |
| `2` | `REFLECTION_SOURCE_SKY` |  |

### `ToneMapper`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `TONE_MAPPER_LINEAR` |  |
| `1` | `TONE_MAPPER_REINHARDT` |  |
| `2` | `TONE_MAPPER_FILMIC` |  |
| `3` | `TONE_MAPPER_ACES` |  |
| `4` | `TONE_MAPPER_AGX` |  |

### `GlowBlendMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `GLOW_BLEND_MODE_ADDITIVE` |  |
| `1` | `GLOW_BLEND_MODE_SCREEN` |  |
| `2` | `GLOW_BLEND_MODE_SOFTLIGHT` |  |
| `3` | `GLOW_BLEND_MODE_REPLACE` |  |
| `4` | `GLOW_BLEND_MODE_MIX` |  |

### `FogMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `FOG_MODE_EXPONENTIAL` |  |
| `1` | `FOG_MODE_DEPTH` |  |

### `SDFGIYScale`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SDFGI_Y_SCALE_50_PERCENT` |  |
| `1` | `SDFGI_Y_SCALE_75_PERCENT` |  |
| `2` | `SDFGI_Y_SCALE_100_PERCENT` |  |

## 教程链接

- [Environment and post-processing](None)
- [High dynamic range lighting](None)
- [3D Material Testers Demo](None)
- [Third Person Shooter (TPS) Demo](None)

