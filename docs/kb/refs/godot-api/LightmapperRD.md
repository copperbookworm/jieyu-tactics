# LightmapperRD

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`LightmapperRD` → `Lightmapper` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/LightmapperRD.md`

**摘要**：The built-in GPU-based lightmapper for use with `LightmapGI`.

## 描述

LightmapperRD ("RD" stands for `RenderingDevice`) is the built-in GPU-based lightmapper for use with `LightmapGI`. On most dedicated GPUs, it can bake lightmaps much faster than most CPU-based lightmappers. LightmapperRD uses compute shaders to bake lightmaps, so it does not require CUDA or OpenCL libraries to be installed to be usable.
		**Note:** This lightmapper requires the GPU to support the `RenderingDevice` backend (Forward+ and Mobile renderers). When using the Compatibility renderer, baking will use a temporary `RenderingDevice`. Support for `RenderingDevice` is not required to *render* lightmaps that were already baked beforehand.

