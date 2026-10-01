# CompressedTextureLayered

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`CompressedTextureLayered` → `TextureLayered` → `Texture` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/CompressedTextureLayered.md`

**摘要**：Base class for texture arrays that can optionally be compressed.

## 描述

Base class for `CompressedTexture2DArray` and `CompressedTexture3D`. Cannot be used directly, but contains all the functions necessary for accessing the derived resource types. See also `TextureLayered`.

## 属性

- **`load_path`** `String` = `""`
  - 其它属性：getter=get_load_path · setter=load

## 方法

### `load(path: String) -> int`

Loads the texture at `path`.

