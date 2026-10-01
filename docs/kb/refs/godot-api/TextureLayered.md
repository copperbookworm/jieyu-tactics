# TextureLayered

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`TextureLayered` → `Texture` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/TextureLayered.md`

**摘要**：Base class for texture types which contain the data of multiple `Image`s. Each image is of the same size and format.

## 描述

Base class for `ImageTextureLayered` and `CompressedTextureLayered`. Cannot be used directly, but contains all the functions necessary for accessing the derived resource types. See also `Texture3D`.
		Data is set on a per-layer basis. For `Texture2DArray`s, the layer specifies the array layer.
		All images need to have the same width, height and number of mipmap levels.
		A `TextureLayered` can be loaded with `ResourceLoader.load`.
		Internally, Godot maps these files to their respective counterparts in the target rendering driver (Vulkan, OpenGL3).

## 方法

### `_get_format() -> int`
- 限定：qualifiers=virtual required const

Called when the `TextureLayered`'s format is queried.

### `_get_height() -> int`
- 限定：qualifiers=virtual required const

Called when the `TextureLayered`'s height is queried.

### `_get_layer_data(layer_index: int) -> Image`
- 限定：qualifiers=virtual required const

Called when the data for a layer in the `TextureLayered` is queried.

### `_get_layered_type() -> int`
- 限定：qualifiers=virtual required const

Called when the layers' type in the `TextureLayered` is queried.

### `_get_layers() -> int`
- 限定：qualifiers=virtual required const

Called when the number of layers in the `TextureLayered` is queried.

### `_get_width() -> int`
- 限定：qualifiers=virtual required const

Called when the `TextureLayered`'s width queried.

### `_has_mipmaps() -> bool`
- 限定：qualifiers=virtual required const

Called when the presence of mipmaps in the `TextureLayered` is queried.

### `get_format() -> int`
- 限定：qualifiers=const

Returns the current format being used by this texture.

### `get_height() -> int`
- 限定：qualifiers=const

Returns the height of the texture in pixels. Height is typically represented by the Y axis.

### `get_layer_data(layer: int) -> Image`
- 限定：qualifiers=const

Returns an `Image` resource with the data from specified `layer`.

### `get_layered_type() -> int`
- 限定：qualifiers=const

Returns the `TextureLayered`'s type. The type determines how the data is accessed, with cubemaps having special types.

### `get_layers() -> int`
- 限定：qualifiers=const

Returns the number of referenced `Image`s.

### `get_width() -> int`
- 限定：qualifiers=const

Returns the width of the texture in pixels. Width is typically represented by the X axis.

### `has_mipmaps() -> bool`
- 限定：qualifiers=const

Returns `true` if the layers have generated mipmaps.

## 枚举

### `LayeredType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `LAYERED_TYPE_2D_ARRAY` |  |
| `1` | `LAYERED_TYPE_CUBEMAP` |  |
| `2` | `LAYERED_TYPE_CUBEMAP_ARRAY` |  |

