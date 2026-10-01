# LightmapGI

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`LightmapGI` → `VisualInstance3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/LightmapGI.md`

**摘要**：Computes and stores baked lightmaps for fast global illumination.

## 描述

The `LightmapGI` node is used to compute and store baked lightmaps. Lightmaps are used to provide high-quality indirect lighting with very little light leaking. `LightmapGI` can also provide rough reflections using spherical harmonics if `directional` is enabled. Dynamic objects can receive indirect lighting thanks to *light probes*, which can be automatically placed by setting `generate_probes_subdiv` to a value other than `GENERATE_PROBES_DISABLED`. Additional lightmap probes can also be added by creating `LightmapProbe` nodes. The downside is that lightmaps are fully static and cannot be baked in an exported project. Baking a `LightmapGI` node is also slower compared to `VoxelGI`.
		**Procedural generation:** Lightmap baking functionality is only available in the editor. This means `LightmapGI` is not suited to procedurally generated or user-built levels. For procedurally generated or user-built levels, use `VoxelGI` or SDFGI instead (see `Environment.sdfgi_enabled`).
		**Performance:** `LightmapGI` provides the best possible run-time performance for global illumination. It is suitable for low-end hardware including integrated graphics and mobile devices.
		**Note:** Due to how lightmaps work, most properties only have a visible effect once lightmaps are baked again.
		**Note:** Lightmap baking on `CSGShape3D`s and `PrimitiveMesh`es is not supported, as these cannot store UV2 data required for baking.
		**Note:** If no custom lightmappers are installed, `LightmapGI` can only be baked from devices that support the Forward+ or Mobile renderers.
		**Note:** The `LightmapGI` node only bakes light data for child nodes of its parent. Nodes further up the hierarchy of the scene will not be baked.

## 属性

- **`bias`** `float` = `0.0005`
  - 其它属性：getter=get_bias · setter=set_bias
- **`bounce_indirect_energy`** `float` = `1.0`
  - 其它属性：getter=get_bounce_indirect_energy · setter=set_bounce_indirect_energy
- **`bounces`** `int` = `3`
  - 其它属性：getter=get_bounces · setter=set_bounces
- **`camera_attributes`** `CameraAttributes`
  - 其它属性：getter=get_camera_attributes · setter=set_camera_attributes
- **`denoiser_range`** `int` = `10`
  - 其它属性：getter=get_denoiser_range · setter=set_denoiser_range
- **`denoiser_strength`** `float` = `0.1`
  - 其它属性：getter=get_denoiser_strength · setter=set_denoiser_strength
- **`directional`** `bool` = `false`
  - 其它属性：getter=is_directional · setter=set_directional
- **`environment_custom_color`** `Color` = `Color(1, 1, 1, 1)`
  - 其它属性：getter=get_environment_custom_color · setter=set_environment_custom_color
- **`environment_custom_energy`** `float` = `1.0`
  - 其它属性：getter=get_environment_custom_energy · setter=set_environment_custom_energy
- **`environment_custom_sky`** `Sky`
  - 其它属性：getter=get_environment_custom_sky · setter=set_environment_custom_sky
- **`environment_mode`** `int` = `1` · 枚举 `LightmapGI.EnvironmentMode`
  - 其它属性：getter=get_environment_mode · setter=set_environment_mode
- **`generate_probes_subdiv`** `int` = `2` · 枚举 `LightmapGI.GenerateProbes`
  - 其它属性：getter=get_generate_probes · setter=set_generate_probes
- **`interior`** `bool` = `false`
  - 其它属性：getter=is_interior · setter=set_interior
- **`light_data`** `LightmapGIData`
  - 其它属性：getter=get_light_data · setter=set_light_data
- **`max_texture_size`** `int` = `16384`
  - 其它属性：getter=get_max_texture_size · setter=set_max_texture_size
- **`quality`** `int` = `1` · 枚举 `LightmapGI.BakeQuality`
  - 其它属性：getter=get_bake_quality · setter=set_bake_quality
- **`shadowmask_mode`** `int` = `0` · 枚举 `LightmapGIData.ShadowmaskMode`
  - 其它属性：experimental= · getter=get_shadowmask_mode · setter=set_shadowmask_mode
- **`supersampling`** `bool` = `false`
  - 其它属性：getter=is_supersampling_enabled · setter=set_supersampling_enabled
- **`supersampling_factor`** `float` = `2.0`
  - 其它属性：getter=get_supersampling_factor · setter=set_supersampling_factor
- **`texel_scale`** `float` = `1.0`
  - 其它属性：getter=get_texel_scale · setter=set_texel_scale
- **`use_denoiser`** `bool` = `true`
  - 其它属性：getter=is_using_denoiser · setter=set_use_denoiser
- **`use_texture_for_bounces`** `bool` = `true`
  - 其它属性：getter=is_using_texture_for_bounces · setter=set_use_texture_for_bounces

## 枚举

### `BakeQuality`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `BAKE_QUALITY_LOW` |  |
| `1` | `BAKE_QUALITY_MEDIUM` |  |
| `2` | `BAKE_QUALITY_HIGH` |  |
| `3` | `BAKE_QUALITY_ULTRA` |  |

### `GenerateProbes`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `GENERATE_PROBES_DISABLED` |  |
| `1` | `GENERATE_PROBES_SUBDIV_4` |  |
| `2` | `GENERATE_PROBES_SUBDIV_8` |  |
| `3` | `GENERATE_PROBES_SUBDIV_16` |  |
| `4` | `GENERATE_PROBES_SUBDIV_32` |  |

### `BakeError`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `BAKE_ERROR_OK` |  |
| `1` | `BAKE_ERROR_NO_SCENE_ROOT` |  |
| `2` | `BAKE_ERROR_FOREIGN_DATA` |  |
| `3` | `BAKE_ERROR_NO_LIGHTMAPPER` |  |
| `4` | `BAKE_ERROR_NO_SAVE_PATH` |  |
| `5` | `BAKE_ERROR_NO_MESHES` |  |
| `6` | `BAKE_ERROR_MESHES_INVALID` |  |
| `7` | `BAKE_ERROR_CANT_CREATE_IMAGE` |  |
| `8` | `BAKE_ERROR_USER_ABORTED` |  |
| `9` | `BAKE_ERROR_TEXTURE_SIZE_TOO_SMALL` |  |
| `10` | `BAKE_ERROR_LIGHTMAP_TOO_SMALL` |  |
| `11` | `BAKE_ERROR_ATLAS_TOO_SMALL` |  |

### `EnvironmentMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ENVIRONMENT_MODE_DISABLED` |  |
| `1` | `ENVIRONMENT_MODE_SCENE` |  |
| `2` | `ENVIRONMENT_MODE_CUSTOM_SKY` |  |
| `3` | `ENVIRONMENT_MODE_CUSTOM_COLOR` |  |

## 教程链接

- [Using Lightmap global illumination](None)

