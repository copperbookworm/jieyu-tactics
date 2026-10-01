# CompressedTexture2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`CompressedTexture2D` → `Texture2D` → `Texture` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/CompressedTexture2D.md`

**摘要**：Texture with 2 dimensions, optionally compressed.

## 描述

A texture that is loaded from a `.ctex` file. This file format is internal to Godot; it is created by importing other image formats with the import system. `CompressedTexture2D` can use one of 4 compression methods (including a lack of any compression):
		- Lossless (WebP or PNG, uncompressed on the GPU)
		- Lossy (WebP, uncompressed on the GPU)
		- VRAM Compressed (compressed on the GPU)
		- VRAM Uncompressed (uncompressed on the GPU)
		- Basis Universal (compressed on the GPU. Lower file sizes than VRAM Compressed, but slower to compress and lower quality than VRAM Compressed)
		Only **VRAM Compressed** actually reduces the memory usage on the GPU. The **Lossless** and **Lossy** compression methods will reduce the required storage on disk, but they will not reduce memory usage on the GPU as the texture is sent to the GPU uncompressed.
		Using **VRAM Compressed** also improves loading times, as VRAM-compressed textures are faster to load compared to textures using lossless or lossy compression. VRAM compression can exhibit noticeable artifacts and is intended to be used for 3D rendering, not 2D.

## 属性

- **`load_path`** `String` = `""`
  - 其它属性：getter=get_load_path · setter=load
- **`resource_local_to_scene`** `bool` = `false`
  - 其它属性：getter=is_local_to_scene · overrides=Resource · setter=set_local_to_scene

## 方法

### `load(path: String) -> int`

Loads the texture from the specified `path`.

