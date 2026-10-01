# PanoramaSkyMaterial

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`PanoramaSkyMaterial` → `Material` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/PanoramaSkyMaterial.md`

**摘要**：A material that provides a special texture to a `Sky`, usually an HDR panorama.

## 描述

A resource referenced in a `Sky` that is used to draw a background. `PanoramaSkyMaterial` functions similar to skyboxes in other engines, except it uses an equirectangular sky map instead of a `Cubemap`.
		Using an HDR panorama is strongly recommended for accurate, high-quality reflections. Godot supports the Radiance HDR (`.hdr`) and OpenEXR (`.exr`) image formats for this purpose.
		You can use this tool (https://danilw.github.io/GLSL-howto/cubemap_to_panorama_js/cubemap_to_panorama.html) to convert a cubemap to an equirectangular sky map.

## 属性

- **`energy_multiplier`** `float` = `1.0`
  - 其它属性：getter=get_energy_multiplier · setter=set_energy_multiplier
- **`filter`** `bool` = `true`
  - 其它属性：getter=is_filtering_enabled · setter=set_filtering_enabled
- **`panorama`** `Texture2D`
  - 其它属性：getter=get_panorama · setter=set_panorama

