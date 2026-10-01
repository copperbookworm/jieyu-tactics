# Texture3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Texture3D` → `Texture` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Texture3D.md`

**摘要**：Base class for 3-dimensional textures.

## 描述

Base class for `ImageTexture3D` and `CompressedTexture3D`. Cannot be used directly, but contains all the functions necessary for accessing the derived resource types. `Texture3D` is the base class for all 3-dimensional texture types. See also `TextureLayered`.
		All images need to have the same width, height and number of mipmap levels.
		To create such a texture file yourself, reimport your image files using the Godot Editor import presets.

## 方法

### `_get_data() -> Image[]`
- 限定：qualifiers=virtual required const

Called when the `Texture3D`'s data is queried.

### `_get_depth() -> int`
- 限定：qualifiers=virtual required const

Called when the `Texture3D`'s depth is queried.

### `_get_format() -> int`
- 限定：qualifiers=virtual required const

Called when the `Texture3D`'s format is queried.

### `_get_height() -> int`
- 限定：qualifiers=virtual required const

Called when the `Texture3D`'s height is queried.

### `_get_width() -> int`
- 限定：qualifiers=virtual required const

Called when the `Texture3D`'s width is queried.

### `_has_mipmaps() -> bool`
- 限定：qualifiers=virtual required const

Called when the presence of mipmaps in the `Texture3D` is queried.

### `create_placeholder() -> Resource`
- 限定：qualifiers=const

Creates a placeholder version of this resource (`PlaceholderTexture3D`).

### `get_data() -> Image[]`
- 限定：qualifiers=const

Returns the `Texture3D`'s data as an array of `Image`s. Each `Image` represents a *slice* of the `Texture3D`, with different slices mapping to different depth (Z axis) levels.

### `get_depth() -> int`
- 限定：qualifiers=const

Returns the `Texture3D`'s depth in pixels. Depth is typically represented by the Z axis (a dimension not present in `Texture2D`).

### `get_format() -> int`
- 限定：qualifiers=const

Returns the current format being used by this texture.

### `get_height() -> int`
- 限定：qualifiers=const

Returns the `Texture3D`'s height in pixels. Width is typically represented by the Y axis.

### `get_width() -> int`
- 限定：qualifiers=const

Returns the `Texture3D`'s width in pixels. Width is typically represented by the X axis.

### `has_mipmaps() -> bool`
- 限定：qualifiers=const

Returns `true` if the `Texture3D` has generated mipmaps.

