# ImageTexture3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ImageTexture3D` → `Texture3D` → `Texture` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/ImageTexture3D.md`

**摘要**：Texture with 3 dimensions.

## 描述

`ImageTexture3D` is a 3-dimensional `ImageTexture` that has a width, height, and depth. See also `ImageTextureLayered`.
		3D textures are typically used to store density maps for `FogMaterial`, color correction LUTs for `Environment`, vector fields for `GPUParticlesAttractorVectorField3D` and collision maps for `GPUParticlesCollisionSDF3D`. 3D textures can also be used in custom shaders.

## 方法

### `create(format: int, width: int, height: int, depth: int, use_mipmaps: bool, data: Image[]) -> int`

Creates the `ImageTexture3D` with specified `format`, `width`, `height`, and `depth`. If `use_mipmaps` is `true`, generates mipmaps for the `ImageTexture3D`.

### `update(data: Image[]) -> void`

Replaces the texture's existing data with the layers specified in `data`. The size of `data` must match the parameters that were used for `create`. In other words, the texture cannot be resized or have its format changed by calling `update`.

