# PlaceholderCubemapArray

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`PlaceholderCubemapArray` → `PlaceholderTextureLayered` → `TextureLayered` → `Texture` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/PlaceholderCubemapArray.md`

**摘要**：A `CubemapArray` without image data.

## 描述

This class replaces a `CubemapArray` or a `CubemapArray`-derived class in 2 conditions:
		- In dedicated server mode, where the image data shouldn't affect game logic. This allows reducing the exported PCK's size significantly.
		- When the `CubemapArray`-derived class is missing, for example when using a different engine version.
		**Note:** This class is not intended for rendering or for use in shaders. Operations like calculating UV are not guaranteed to work.

