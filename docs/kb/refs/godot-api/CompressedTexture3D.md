# CompressedTexture3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`CompressedTexture3D` → `Texture3D` → `Texture` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/CompressedTexture3D.md`

**摘要**：Texture with 3 dimensions, optionally compressed.

## 描述

`CompressedTexture3D` is the VRAM-compressed counterpart of `ImageTexture3D`. The file extension for `CompressedTexture3D` files is `.ctex3d`. This file format is internal to Godot; it is created by importing other image formats with the import system.
		`CompressedTexture3D` uses VRAM compression, which allows to reduce memory usage on the GPU when rendering the texture. This also improves loading times, as VRAM-compressed textures are faster to load compared to textures using lossless compression. VRAM compression can exhibit noticeable artifacts and is intended to be used for 3D rendering, not 2D.
		See `Texture3D` for a general description of 3D textures.

## 属性

- **`load_path`** `String` = `""`
  - 其它属性：getter=get_load_path · setter=load

## 方法

### `load(path: String) -> int`

Loads the texture from the specified `path`.

