# Lightmapper

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Lightmapper` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Lightmapper.md`

**摘要**：Abstract class extended by lightmappers, for use in `LightmapGI`.

## 描述

This class should be extended by custom lightmapper classes. Lightmappers can then be used with `LightmapGI` to provide fast baked global illumination in 3D.
		Godot contains a built-in GPU-based lightmapper `LightmapperRD` that uses compute shaders, but custom lightmappers can be implemented by C++ modules.

