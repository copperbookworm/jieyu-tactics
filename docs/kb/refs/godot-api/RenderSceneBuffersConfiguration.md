# RenderSceneBuffersConfiguration

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`RenderSceneBuffersConfiguration` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/RenderSceneBuffersConfiguration.md`

**摘要**：Configuration object used to setup a `RenderSceneBuffers` object.

## 描述

This configuration object is created and populated by the render engine on a viewport change and used to (re)configure a `RenderSceneBuffers` object.

## 属性

- **`anisotropic_filtering_level`** `int` = `2` · 枚举 `RenderingServer.ViewportAnisotropicFiltering`
  - 其它属性：getter=get_anisotropic_filtering_level · setter=set_anisotropic_filtering_level
- **`fsr_sharpness`** `float` = `0.0`
  - 其它属性：getter=get_fsr_sharpness · setter=set_fsr_sharpness
- **`internal_size`** `Vector2i` = `Vector2i(0, 0)`
  - 其它属性：getter=get_internal_size · setter=set_internal_size
- **`msaa_3d`** `int` = `0` · 枚举 `RenderingServer.ViewportMSAA`
  - 其它属性：getter=get_msaa_3d · setter=set_msaa_3d
- **`render_target`** `RID` = `RID()`
  - 其它属性：getter=get_render_target · setter=set_render_target
- **`scaling_3d_mode`** `int` = `255` · 枚举 `RenderingServer.ViewportScaling3DMode`
  - 其它属性：getter=get_scaling_3d_mode · setter=set_scaling_3d_mode
- **`screen_space_aa`** `int` = `0` · 枚举 `RenderingServer.ViewportScreenSpaceAA`
  - 其它属性：getter=get_screen_space_aa · setter=set_screen_space_aa
- **`target_size`** `Vector2i` = `Vector2i(0, 0)`
  - 其它属性：getter=get_target_size · setter=set_target_size
- **`texture_mipmap_bias`** `float` = `0.0`
  - 其它属性：getter=get_texture_mipmap_bias · setter=set_texture_mipmap_bias
- **`view_count`** `int` = `1`
  - 其它属性：getter=get_view_count · setter=set_view_count

