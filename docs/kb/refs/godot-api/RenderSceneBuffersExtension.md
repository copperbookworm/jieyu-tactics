# RenderSceneBuffersExtension

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`RenderSceneBuffersExtension` → `RenderSceneBuffers` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/RenderSceneBuffersExtension.md`

**摘要**：This class allows for a RenderSceneBuffer implementation to be made in GDExtension.

## 描述

This class allows for a RenderSceneBuffer implementation to be made in GDExtension.

## 方法

### `_configure(config: RenderSceneBuffersConfiguration) -> void`
- 限定：qualifiers=virtual

Implement this in GDExtension to handle the (re)sizing of a viewport.

### `_set_anisotropic_filtering_level(anisotropic_filtering_level: int) -> void`
- 限定：qualifiers=virtual

Implement this in GDExtension to change the anisotropic filtering level.

### `_set_fsr_sharpness(fsr_sharpness: float) -> void`
- 限定：qualifiers=virtual

Implement this in GDExtension to record a new FSR sharpness value.

### `_set_texture_mipmap_bias(texture_mipmap_bias: float) -> void`
- 限定：qualifiers=virtual

Implement this in GDExtension to change the texture mipmap bias.

### `_set_use_debanding(use_debanding: bool) -> void`
- 限定：qualifiers=virtual

Implement this in GDExtension to react to the debanding flag changing.

