# FogMaterial

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`FogMaterial` → `Material` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/FogMaterial.md`

**摘要**：A material that controls how volumetric fog is rendered, to be assigned to a `FogVolume`.

## 描述

A `Material` resource that can be used by `FogVolume`s to draw volumetric effects.
		If you need more advanced effects, use a custom fog shader ($DOCS_URL/tutorials/shaders/shader_reference/fog_shader.html).

## 属性

- **`albedo`** `Color` = `Color(1, 1, 1, 1)`
  - 其它属性：getter=get_albedo · keywords=color, colour · setter=set_albedo
- **`density`** `float` = `1.0`
  - 其它属性：getter=get_density · setter=set_density
- **`density_texture`** `Texture3D`
  - 其它属性：getter=get_density_texture · setter=set_density_texture
- **`edge_fade`** `float` = `0.1`
  - 其它属性：getter=get_edge_fade · setter=set_edge_fade
- **`emission`** `Color` = `Color(0, 0, 0, 1)`
  - 其它属性：getter=get_emission · setter=set_emission
- **`height_falloff`** `float` = `0.0`
  - 其它属性：getter=get_height_falloff · setter=set_height_falloff

