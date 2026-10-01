# BaseMaterial3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`BaseMaterial3D` → `Material` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/BaseMaterial3D.md`

**摘要**：Abstract base class for defining the 3D rendering properties of meshes.

## 描述

This class serves as a default material with a wide variety of rendering features and properties without the need to write shader code. See the tutorial below for details.

## 属性

- **`albedo_color`** `Color` = `Color(1, 1, 1, 1)`
  - 其它属性：getter=get_albedo · keywords=albedo_colour, diffuse_color, diffuse_colour · setter=set_albedo
- **`albedo_texture`** `Texture2D`
  - 其它属性：getter=get_texture · keywords=diffuse_texture · setter=set_texture
- **`albedo_texture_force_srgb`** `bool` = `false`
  - 其它属性：getter=get_flag · keywords=diffuse_texture_force_srgb · setter=set_flag
- **`albedo_texture_msdf`** `bool` = `false`
  - 其它属性：getter=get_flag · keywords=diffuse_texture_force_srgb · setter=set_flag
- **`alpha_antialiasing_edge`** `float`
  - 其它属性：getter=get_alpha_antialiasing_edge · setter=set_alpha_antialiasing_edge
- **`alpha_antialiasing_mode`** `int` · 枚举 `BaseMaterial3D.AlphaAntiAliasing`
  - 其它属性：getter=get_alpha_antialiasing · setter=set_alpha_antialiasing
- **`alpha_hash_scale`** `float`
  - 其它属性：getter=get_alpha_hash_scale · setter=set_alpha_hash_scale
- **`alpha_scissor_threshold`** `float`
  - 其它属性：getter=get_alpha_scissor_threshold · keywords=alpha_test_threshold · setter=set_alpha_scissor_threshold
- **`anisotropy`** `float` = `0.0`
  - 其它属性：getter=get_anisotropy · setter=set_anisotropy
- **`anisotropy_enabled`** `bool` = `false`
  - 其它属性：getter=get_feature · setter=set_feature
- **`anisotropy_flowmap`** `Texture2D`
  - 其它属性：getter=get_texture · setter=set_texture
- **`ao_enabled`** `bool` = `false`
  - 其它属性：getter=get_feature · setter=set_feature
- **`ao_light_affect`** `float` = `0.0`
  - 其它属性：getter=get_ao_light_affect · setter=set_ao_light_affect
- **`ao_on_uv2`** `bool` = `false`
  - 其它属性：getter=get_flag · setter=set_flag
- **`ao_texture`** `Texture2D`
  - 其它属性：getter=get_texture · setter=set_texture
- **`ao_texture_channel`** `int` = `0` · 枚举 `BaseMaterial3D.TextureChannel`
  - 其它属性：getter=get_ao_texture_channel · setter=set_ao_texture_channel
- **`backlight`** `Color` = `Color(0, 0, 0, 1)`
  - 其它属性：getter=get_backlight · setter=set_backlight
- **`backlight_enabled`** `bool` = `false`
  - 其它属性：getter=get_feature · setter=set_feature
- **`backlight_texture`** `Texture2D`
  - 其它属性：getter=get_texture · setter=set_texture
- **`bent_normal_enabled`** `bool` = `false`
  - 其它属性：getter=get_feature · setter=set_feature
- **`bent_normal_texture`** `Texture2D`
  - 其它属性：getter=get_texture · setter=set_texture
- **`billboard_keep_scale`** `bool` = `false`
  - 其它属性：getter=get_flag · setter=set_flag
- **`billboard_mode`** `int` = `0` · 枚举 `BaseMaterial3D.BillboardMode`
  - 其它属性：getter=get_billboard_mode · setter=set_billboard_mode
- **`blend_mode`** `int` = `0` · 枚举 `BaseMaterial3D.BlendMode`
  - 其它属性：getter=get_blend_mode · setter=set_blend_mode
- **`clearcoat`** `float` = `1.0`
  - 其它属性：getter=get_clearcoat · setter=set_clearcoat
- **`clearcoat_enabled`** `bool` = `false`
  - 其它属性：getter=get_feature · setter=set_feature
- **`clearcoat_roughness`** `float` = `0.5`
  - 其它属性：getter=get_clearcoat_roughness · setter=set_clearcoat_roughness
- **`clearcoat_texture`** `Texture2D`
  - 其它属性：getter=get_texture · setter=set_texture
- **`cull_mode`** `int` = `0` · 枚举 `BaseMaterial3D.CullMode`
  - 其它属性：getter=get_cull_mode · setter=set_cull_mode
- **`depth_draw_mode`** `int` = `0` · 枚举 `BaseMaterial3D.DepthDrawMode`
  - 其它属性：getter=get_depth_draw_mode · setter=set_depth_draw_mode
- **`depth_test`** `int` = `0` · 枚举 `BaseMaterial3D.DepthTest`
  - 其它属性：experimental=May be affected by future rendering pipeline changes. · getter=get_depth_test · setter=set_depth_test
- **`detail_albedo`** `Texture2D`
  - 其它属性：getter=get_texture · setter=set_texture
- **`detail_blend_mode`** `int` = `0` · 枚举 `BaseMaterial3D.BlendMode`
  - 其它属性：getter=get_detail_blend_mode · setter=set_detail_blend_mode
- **`detail_enabled`** `bool` = `false`
  - 其它属性：getter=get_feature · setter=set_feature
- **`detail_mask`** `Texture2D`
  - 其它属性：getter=get_texture · setter=set_texture
- **`detail_normal`** `Texture2D`
  - 其它属性：getter=get_texture · setter=set_texture
- **`detail_uv_layer`** `int` = `0` · 枚举 `BaseMaterial3D.DetailUV`
  - 其它属性：getter=get_detail_uv · setter=set_detail_uv
- **`diffuse_mode`** `int` = `0` · 枚举 `BaseMaterial3D.DiffuseMode`
  - 其它属性：getter=get_diffuse_mode · setter=set_diffuse_mode
- **`disable_ambient_light`** `bool` = `false`
  - 其它属性：getter=get_flag · setter=set_flag
- **`disable_fog`** `bool` = `false`
  - 其它属性：getter=get_flag · setter=set_flag
- **`disable_receive_shadows`** `bool` = `false`
  - 其它属性：getter=get_flag · setter=set_flag
- **`disable_specular_occlusion`** `bool` = `false`
  - 其它属性：getter=get_flag · setter=set_flag
- **`distance_fade_max_distance`** `float` = `10.0`
  - 其它属性：getter=get_distance_fade_max_distance · setter=set_distance_fade_max_distance
- **`distance_fade_min_distance`** `float` = `0.0`
  - 其它属性：getter=get_distance_fade_min_distance · setter=set_distance_fade_min_distance
- **`distance_fade_mode`** `int` = `0` · 枚举 `BaseMaterial3D.DistanceFadeMode`
  - 其它属性：getter=get_distance_fade · setter=set_distance_fade
- **`emission`** `Color` = `Color(0, 0, 0, 1)`
  - 其它属性：getter=get_emission · setter=set_emission
- **`emission_enabled`** `bool` = `false`
  - 其它属性：getter=get_feature · setter=set_feature
- **`emission_energy_multiplier`** `float` = `1.0`
  - 其它属性：getter=get_emission_energy_multiplier · setter=set_emission_energy_multiplier
- **`emission_intensity`** `float`
  - 其它属性：getter=get_emission_intensity · setter=set_emission_intensity
- **`emission_on_uv2`** `bool` = `false`
  - 其它属性：getter=get_flag · setter=set_flag
- **`emission_operator`** `int` = `0` · 枚举 `BaseMaterial3D.EmissionOperator`
  - 其它属性：getter=get_emission_operator · setter=set_emission_operator
- **`emission_texture`** `Texture2D`
  - 其它属性：getter=get_texture · setter=set_texture
- **`fixed_size`** `bool` = `false`
  - 其它属性：getter=get_flag · setter=set_flag
- **`fov_override`** `float` = `75.0`
  - 其它属性：getter=get_fov_override · setter=set_fov_override
- **`grow`** `bool` = `false`
  - 其它属性：getter=is_grow_enabled · setter=set_grow_enabled
- **`grow_amount`** `float` = `0.0`
  - 其它属性：getter=get_grow · setter=set_grow
- **`heightmap_deep_parallax`** `bool` = `false`
  - 其它属性：getter=is_heightmap_deep_parallax_enabled · setter=set_heightmap_deep_parallax
- **`heightmap_enabled`** `bool` = `false`
  - 其它属性：getter=get_feature · setter=set_feature
- **`heightmap_flip_binormal`** `bool` = `false`
  - 其它属性：getter=get_heightmap_deep_parallax_flip_binormal · setter=set_heightmap_deep_parallax_flip_binormal
- **`heightmap_flip_tangent`** `bool` = `false`
  - 其它属性：getter=get_heightmap_deep_parallax_flip_tangent · setter=set_heightmap_deep_parallax_flip_tangent
- **`heightmap_flip_texture`** `bool` = `false`
  - 其它属性：getter=get_flag · setter=set_flag
- **`heightmap_max_layers`** `int`
  - 其它属性：getter=get_heightmap_deep_parallax_max_layers · setter=set_heightmap_deep_parallax_max_layers
- **`heightmap_min_layers`** `int`
  - 其它属性：getter=get_heightmap_deep_parallax_min_layers · setter=set_heightmap_deep_parallax_min_layers
- **`heightmap_scale`** `float` = `5.0`
  - 其它属性：getter=get_heightmap_scale · setter=set_heightmap_scale
- **`heightmap_texture`** `Texture2D`
  - 其它属性：getter=get_texture · setter=set_texture
- **`metallic`** `float` = `0.0`
  - 其它属性：getter=get_metallic · setter=set_metallic
- **`metallic_specular`** `float` = `0.5`
  - 其它属性：getter=get_specular · setter=set_specular
- **`metallic_texture`** `Texture2D`
  - 其它属性：getter=get_texture · setter=set_texture
- **`metallic_texture_channel`** `int` = `0` · 枚举 `BaseMaterial3D.TextureChannel`
  - 其它属性：getter=get_metallic_texture_channel · setter=set_metallic_texture_channel
- **`msdf_outline_size`** `float` = `0.0`
  - 其它属性：getter=get_msdf_outline_size · setter=set_msdf_outline_size
- **`msdf_pixel_range`** `float` = `4.0`
  - 其它属性：getter=get_msdf_pixel_range · setter=set_msdf_pixel_range
- **`no_depth_test`** `bool` = `false`
  - 其它属性：getter=get_flag · setter=set_flag
- **`normal_enabled`** `bool` = `false`
  - 其它属性：getter=get_feature · setter=set_feature
- **`normal_scale`** `float` = `1.0`
  - 其它属性：getter=get_normal_scale · setter=set_normal_scale
- **`normal_texture`** `Texture2D`
  - 其它属性：getter=get_texture · setter=set_texture
- **`orm_texture`** `Texture2D`
  - 其它属性：getter=get_texture · setter=set_texture
- **`particles_anim_h_frames`** `int`
  - 其它属性：getter=get_particles_anim_h_frames · setter=set_particles_anim_h_frames
- **`particles_anim_loop`** `bool`
  - 其它属性：getter=get_particles_anim_loop · setter=set_particles_anim_loop
- **`particles_anim_v_frames`** `int`
  - 其它属性：getter=get_particles_anim_v_frames · setter=set_particles_anim_v_frames
- **`point_size`** `float` = `1.0`
  - 其它属性：getter=get_point_size · setter=set_point_size
- **`proximity_fade_distance`** `float` = `1.0`
  - 其它属性：getter=get_proximity_fade_distance · setter=set_proximity_fade_distance
- **`proximity_fade_enabled`** `bool` = `false`
  - 其它属性：getter=is_proximity_fade_enabled · setter=set_proximity_fade_enabled
- **`refraction_enabled`** `bool` = `false`
  - 其它属性：getter=get_feature · setter=set_feature
- **`refraction_scale`** `float` = `0.05`
  - 其它属性：getter=get_refraction · setter=set_refraction
- **`refraction_texture`** `Texture2D`
  - 其它属性：getter=get_texture · setter=set_texture
- **`refraction_texture_channel`** `int` = `0` · 枚举 `BaseMaterial3D.TextureChannel`
  - 其它属性：getter=get_refraction_texture_channel · setter=set_refraction_texture_channel
- **`rim`** `float` = `1.0`
  - 其它属性：getter=get_rim · setter=set_rim
- **`rim_enabled`** `bool` = `false`
  - 其它属性：getter=get_feature · setter=set_feature
- **`rim_texture`** `Texture2D`
  - 其它属性：getter=get_texture · setter=set_texture
- **`rim_tint`** `float` = `0.5`
  - 其它属性：getter=get_rim_tint · setter=set_rim_tint
- **`roughness`** `float` = `1.0`
  - 其它属性：getter=get_roughness · setter=set_roughness
- **`roughness_texture`** `Texture2D`
  - 其它属性：getter=get_texture · setter=set_texture
- **`roughness_texture_channel`** `int` = `0` · 枚举 `BaseMaterial3D.TextureChannel`
  - 其它属性：getter=get_roughness_texture_channel · setter=set_roughness_texture_channel
- **`shading_mode`** `int` = `1` · 枚举 `BaseMaterial3D.ShadingMode`
  - 其它属性：getter=get_shading_mode · setter=set_shading_mode
- **`shadow_to_opacity`** `bool` = `false`
  - 其它属性：getter=get_flag · setter=set_flag
- **`specular_mode`** `int` = `0` · 枚举 `BaseMaterial3D.SpecularMode`
  - 其它属性：getter=get_specular_mode · setter=set_specular_mode
- **`stencil_color`** `Color` = `Color(0, 0, 0, 1)`
  - 其它属性：experimental=May be affected by future rendering pipeline changes. · getter=get_stencil_effect_color · setter=set_stencil_effect_color
- **`stencil_compare`** `int` = `0` · 枚举 `BaseMaterial3D.StencilCompare`
  - 其它属性：experimental=May be affected by future rendering pipeline changes. · getter=get_stencil_compare · setter=set_stencil_compare
- **`stencil_flags`** `int` = `0`
  - 其它属性：experimental=May be affected by future rendering pipeline changes. · getter=get_stencil_flags · setter=set_stencil_flags
- **`stencil_mode`** `int` = `0` · 枚举 `BaseMaterial3D.StencilMode`
  - 其它属性：experimental=May be affected by future rendering pipeline changes. · getter=get_stencil_mode · setter=set_stencil_mode
- **`stencil_outline_thickness`** `float` = `0.01`
  - 其它属性：experimental=May be affected by future rendering pipeline changes. · getter=get_stencil_effect_outline_thickness · setter=set_stencil_effect_outline_thickness
- **`stencil_reference`** `int` = `1`
  - 其它属性：experimental=May be affected by future rendering pipeline changes. · getter=get_stencil_reference · setter=set_stencil_reference
- **`subsurf_scatter_enabled`** `bool` = `false`
  - 其它属性：getter=get_feature · setter=set_feature
- **`subsurf_scatter_skin_mode`** `bool` = `false`
  - 其它属性：getter=get_flag · setter=set_flag
- **`subsurf_scatter_strength`** `float` = `0.0`
  - 其它属性：getter=get_subsurface_scattering_strength · setter=set_subsurface_scattering_strength
- **`subsurf_scatter_texture`** `Texture2D`
  - 其它属性：getter=get_texture · setter=set_texture
- **`subsurf_scatter_transmittance_boost`** `float` = `0.0`
  - 其它属性：getter=get_transmittance_boost · setter=set_transmittance_boost
- **`subsurf_scatter_transmittance_color`** `Color` = `Color(1, 1, 1, 1)`
  - 其它属性：getter=get_transmittance_color · setter=set_transmittance_color
- **`subsurf_scatter_transmittance_depth`** `float` = `0.1`
  - 其它属性：getter=get_transmittance_depth · setter=set_transmittance_depth
- **`subsurf_scatter_transmittance_enabled`** `bool` = `false`
  - 其它属性：getter=get_feature · setter=set_feature
- **`subsurf_scatter_transmittance_texture`** `Texture2D`
  - 其它属性：getter=get_texture · setter=set_texture
- **`texture_filter`** `int` = `3` · 枚举 `BaseMaterial3D.TextureFilter`
  - 其它属性：getter=get_texture_filter · setter=set_texture_filter
- **`texture_repeat`** `bool` = `true`
  - 其它属性：getter=get_flag · setter=set_flag
- **`transparency`** `int` = `0` · 枚举 `BaseMaterial3D.Transparency`
  - 其它属性：getter=get_transparency · setter=set_transparency
- **`use_fov_override`** `bool` = `false`
  - 其它属性：getter=get_flag · setter=set_flag
- **`use_particle_trails`** `bool` = `false`
  - 其它属性：getter=get_flag · setter=set_flag
- **`use_point_size`** `bool` = `false`
  - 其它属性：getter=get_flag · setter=set_flag
- **`use_z_clip_scale`** `bool` = `false`
  - 其它属性：getter=get_flag · setter=set_flag
- **`uv1_offset`** `Vector3` = `Vector3(0, 0, 0)`
  - 其它属性：getter=get_uv1_offset · setter=set_uv1_offset
- **`uv1_scale`** `Vector3` = `Vector3(1, 1, 1)`
  - 其它属性：getter=get_uv1_scale · setter=set_uv1_scale
- **`uv1_triplanar`** `bool` = `false`
  - 其它属性：getter=get_flag · setter=set_flag
- **`uv1_triplanar_sharpness`** `float` = `1.0`
  - 其它属性：getter=get_uv1_triplanar_blend_sharpness · setter=set_uv1_triplanar_blend_sharpness
- **`uv1_world_triplanar`** `bool` = `false`
  - 其它属性：getter=get_flag · setter=set_flag
- **`uv2_offset`** `Vector3` = `Vector3(0, 0, 0)`
  - 其它属性：getter=get_uv2_offset · setter=set_uv2_offset
- **`uv2_scale`** `Vector3` = `Vector3(1, 1, 1)`
  - 其它属性：getter=get_uv2_scale · setter=set_uv2_scale
- **`uv2_triplanar`** `bool` = `false`
  - 其它属性：getter=get_flag · setter=set_flag
- **`uv2_triplanar_sharpness`** `float` = `1.0`
  - 其它属性：getter=get_uv2_triplanar_blend_sharpness · setter=set_uv2_triplanar_blend_sharpness
- **`uv2_world_triplanar`** `bool` = `false`
  - 其它属性：getter=get_flag · setter=set_flag
- **`vertex_color_is_srgb`** `bool` = `false`
  - 其它属性：getter=get_flag · setter=set_flag
- **`vertex_color_use_as_albedo`** `bool` = `false`
  - 其它属性：getter=get_flag · setter=set_flag
- **`z_clip_scale`** `float` = `1.0`
  - 其它属性：getter=get_z_clip_scale · setter=set_z_clip_scale

## 方法

### `get_feature(feature: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the specified `feature` is enabled.

### `get_flag(flag: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the specified `flag` is enabled.

### `get_texture(param: int) -> Texture2D`
- 限定：qualifiers=const

Returns the `Texture2D` associated with the specified texture `param`.

### `set_feature(feature: int, enable: bool) -> void`

If `enable` is `true`, enables the specified `feature`. Many features that are available in `BaseMaterial3D` need to be enabled before use. This way, the cost for using the feature is only incurred when specified. Features can also be enabled by setting their corresponding property to `true`.

### `set_flag(flag: int, enable: bool) -> void`

If `enable` is `true`, enables the specified `flag`. Flags are optional behavior that can be turned on and off. Only one flag can be enabled at a time with this function, the flag enumerators cannot be bit-masked together to enable or disable multiple flags at once. Flags can also be enabled by setting their corresponding property to `true`.

### `set_texture(param: int, texture: Texture2D) -> void`

Sets the texture for the slot specified by `param`.

## 枚举

### `TextureParam`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `TEXTURE_ALBEDO` |  |
| `1` | `TEXTURE_METALLIC` |  |
| `2` | `TEXTURE_ROUGHNESS` |  |
| `3` | `TEXTURE_EMISSION` |  |
| `4` | `TEXTURE_NORMAL` |  |
| `18` | `TEXTURE_BENT_NORMAL` |  |
| `5` | `TEXTURE_RIM` |  |
| `6` | `TEXTURE_CLEARCOAT` |  |
| `7` | `TEXTURE_FLOWMAP` |  |
| `8` | `TEXTURE_AMBIENT_OCCLUSION` |  |
| `9` | `TEXTURE_HEIGHTMAP` |  |
| `10` | `TEXTURE_SUBSURFACE_SCATTERING` |  |
| `11` | `TEXTURE_SUBSURFACE_TRANSMITTANCE` |  |
| `12` | `TEXTURE_BACKLIGHT` |  |
| `13` | `TEXTURE_REFRACTION` |  |
| `14` | `TEXTURE_DETAIL_MASK` |  |
| `15` | `TEXTURE_DETAIL_ALBEDO` |  |
| `16` | `TEXTURE_DETAIL_NORMAL` |  |
| `17` | `TEXTURE_ORM` |  |
| `19` | `TEXTURE_MAX` |  |

### `TextureFilter`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `TEXTURE_FILTER_NEAREST` |  |
| `1` | `TEXTURE_FILTER_LINEAR` |  |
| `2` | `TEXTURE_FILTER_NEAREST_WITH_MIPMAPS` |  |
| `3` | `TEXTURE_FILTER_LINEAR_WITH_MIPMAPS` |  |
| `4` | `TEXTURE_FILTER_NEAREST_WITH_MIPMAPS_ANISOTROPIC` |  |
| `5` | `TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC` |  |
| `6` | `TEXTURE_FILTER_MAX` |  |

### `DetailUV`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `DETAIL_UV_1` |  |
| `1` | `DETAIL_UV_2` |  |

### `Transparency`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `TRANSPARENCY_DISABLED` |  |
| `1` | `TRANSPARENCY_ALPHA` |  |
| `2` | `TRANSPARENCY_ALPHA_SCISSOR` |  |
| `3` | `TRANSPARENCY_ALPHA_HASH` |  |
| `4` | `TRANSPARENCY_ALPHA_DEPTH_PRE_PASS` |  |
| `5` | `TRANSPARENCY_MAX` |  |

### `ShadingMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SHADING_MODE_UNSHADED` |  |
| `1` | `SHADING_MODE_PER_PIXEL` |  |
| `2` | `SHADING_MODE_PER_VERTEX` |  |
| `3` | `SHADING_MODE_MAX` |  |

### `Feature`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `FEATURE_EMISSION` |  |
| `1` | `FEATURE_NORMAL_MAPPING` |  |
| `2` | `FEATURE_RIM` |  |
| `3` | `FEATURE_CLEARCOAT` |  |
| `4` | `FEATURE_ANISOTROPY` |  |
| `5` | `FEATURE_AMBIENT_OCCLUSION` |  |
| `6` | `FEATURE_HEIGHT_MAPPING` |  |
| `7` | `FEATURE_SUBSURFACE_SCATTERING` |  |
| `8` | `FEATURE_SUBSURFACE_TRANSMITTANCE` |  |
| `9` | `FEATURE_BACKLIGHT` |  |
| `10` | `FEATURE_REFRACTION` |  |
| `11` | `FEATURE_DETAIL` |  |
| `12` | `FEATURE_BENT_NORMAL_MAPPING` |  |
| `13` | `FEATURE_MAX` |  |

### `BlendMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `BLEND_MODE_MIX` |  |
| `1` | `BLEND_MODE_ADD` |  |
| `2` | `BLEND_MODE_SUB` |  |
| `3` | `BLEND_MODE_MUL` |  |
| `4` | `BLEND_MODE_PREMULT_ALPHA` |  |

### `AlphaAntiAliasing`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ALPHA_ANTIALIASING_OFF` |  |
| `1` | `ALPHA_ANTIALIASING_ALPHA_TO_COVERAGE` |  |
| `2` | `ALPHA_ANTIALIASING_ALPHA_TO_COVERAGE_AND_TO_ONE` |  |

### `DepthDrawMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `DEPTH_DRAW_OPAQUE_ONLY` |  |
| `1` | `DEPTH_DRAW_ALWAYS` |  |
| `2` | `DEPTH_DRAW_DISABLED` |  |

### `DepthTest`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `DEPTH_TEST_DEFAULT` |  |
| `1` | `DEPTH_TEST_INVERTED` |  |

### `CullMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `CULL_BACK` |  |
| `1` | `CULL_FRONT` |  |
| `2` | `CULL_DISABLED` |  |

### `Flags`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `FLAG_DISABLE_DEPTH_TEST` |  |
| `1` | `FLAG_ALBEDO_FROM_VERTEX_COLOR` |  |
| `2` | `FLAG_SRGB_VERTEX_COLOR` |  |
| `3` | `FLAG_USE_POINT_SIZE` |  |
| `4` | `FLAG_FIXED_SIZE` |  |
| `5` | `FLAG_BILLBOARD_KEEP_SCALE` |  |
| `6` | `FLAG_UV1_USE_TRIPLANAR` |  |
| `7` | `FLAG_UV2_USE_TRIPLANAR` |  |
| `8` | `FLAG_UV1_USE_WORLD_TRIPLANAR` |  |
| `9` | `FLAG_UV2_USE_WORLD_TRIPLANAR` |  |
| `10` | `FLAG_AO_ON_UV2` |  |
| `11` | `FLAG_EMISSION_ON_UV2` |  |
| `12` | `FLAG_ALBEDO_TEXTURE_FORCE_SRGB` |  |
| `13` | `FLAG_DONT_RECEIVE_SHADOWS` |  |
| `14` | `FLAG_DISABLE_AMBIENT_LIGHT` |  |
| `15` | `FLAG_USE_SHADOW_TO_OPACITY` |  |
| `16` | `FLAG_USE_TEXTURE_REPEAT` |  |
| `17` | `FLAG_INVERT_HEIGHTMAP` |  |
| `18` | `FLAG_SUBSURFACE_MODE_SKIN` |  |
| `19` | `FLAG_PARTICLE_TRAILS_MODE` |  |
| `20` | `FLAG_ALBEDO_TEXTURE_MSDF` |  |
| `21` | `FLAG_DISABLE_FOG` |  |
| `22` | `FLAG_DISABLE_SPECULAR_OCCLUSION` |  |
| `23` | `FLAG_USE_Z_CLIP_SCALE` |  |
| `24` | `FLAG_USE_FOV_OVERRIDE` |  |
| `25` | `FLAG_MAX` |  |

### `DiffuseMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `DIFFUSE_BURLEY` |  |
| `1` | `DIFFUSE_LAMBERT` |  |
| `2` | `DIFFUSE_LAMBERT_WRAP` |  |
| `3` | `DIFFUSE_TOON` |  |

### `SpecularMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SPECULAR_SCHLICK_GGX` |  |
| `1` | `SPECULAR_TOON` |  |
| `2` | `SPECULAR_DISABLED` |  |

### `BillboardMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `BILLBOARD_DISABLED` |  |
| `1` | `BILLBOARD_ENABLED` |  |
| `2` | `BILLBOARD_FIXED_Y` |  |
| `3` | `BILLBOARD_PARTICLES` |  |

### `TextureChannel`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `TEXTURE_CHANNEL_RED` |  |
| `1` | `TEXTURE_CHANNEL_GREEN` |  |
| `2` | `TEXTURE_CHANNEL_BLUE` |  |
| `3` | `TEXTURE_CHANNEL_ALPHA` |  |
| `4` | `TEXTURE_CHANNEL_GRAYSCALE` |  |

### `EmissionOperator`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `EMISSION_OP_ADD` |  |
| `1` | `EMISSION_OP_MULTIPLY` |  |

### `DistanceFadeMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `DISTANCE_FADE_DISABLED` |  |
| `1` | `DISTANCE_FADE_PIXEL_ALPHA` |  |
| `2` | `DISTANCE_FADE_PIXEL_DITHER` |  |
| `3` | `DISTANCE_FADE_OBJECT_DITHER` |  |

### `StencilMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `STENCIL_MODE_DISABLED` |  |
| `1` | `STENCIL_MODE_OUTLINE` |  |
| `2` | `STENCIL_MODE_XRAY` |  |
| `3` | `STENCIL_MODE_CUSTOM` |  |

### `StencilFlags`

| 值 | 名称 | 说明 |
|---|---|---|
| `1` | `STENCIL_FLAG_READ` |  |
| `2` | `STENCIL_FLAG_WRITE` |  |
| `4` | `STENCIL_FLAG_WRITE_DEPTH_FAIL` |  |

### `StencilCompare`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `STENCIL_COMPARE_ALWAYS` |  |
| `1` | `STENCIL_COMPARE_LESS` |  |
| `2` | `STENCIL_COMPARE_EQUAL` |  |
| `3` | `STENCIL_COMPARE_LESS_OR_EQUAL` |  |
| `4` | `STENCIL_COMPARE_GREATER` |  |
| `5` | `STENCIL_COMPARE_NOT_EQUAL` |  |
| `6` | `STENCIL_COMPARE_GREATER_OR_EQUAL` |  |

## 教程链接

- [Standard Material 3D and ORM Material 3D](None)

