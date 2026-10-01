# DrawableTexture2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`DrawableTexture2D` → `Texture2D` → `Texture` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/DrawableTexture2D.md`

**摘要**：A 2D texture that supports drawing to itself via Blit calls.

## 描述

A 2D texture that can be modified via blit calls, copying from a target texture to itself. Primarily intended to be managed in code, a user must call `setup` to initialize the state before drawing. Each `blit_rect` call takes at least a rectangle, the area to draw to, and another texture, what to be drawn. The draw calls use a Texture_Blit Shader to process and calculate the result, pixel by pixel. Users can supply their own ShaderMaterial with custom Texture_Blit shaders for more complex behaviors.

## 属性

- **`resource_local_to_scene`** `bool` = `false`
  - 其它属性：getter=is_local_to_scene · overrides=Resource · setter=set_local_to_scene

## 方法

### `blit_rect(rect: Rect2i, source: Texture2D, modulate: Color = Color(1, 1, 1, 1), mipmap: int = 0, material: Material = null) -> void`
- 限定：experimental=

Draws to given `rect` on this texture by copying from the given `source`. A `modulate` color can be passed in for the shader to use, but defaults to White. The `mipmap` value can specify a draw to a lower mipmap level. The `material` parameter can take a ShaderMaterial with a TextureBlit Shader for custom drawing behavior.

### `blit_rect_multi(rect: Rect2i, sources: Texture2D[], extra_targets: DrawableTexture2D[], modulate: Color = Color(1, 1, 1, 1), mipmap: int = 0, material: Material = null) -> void`
- 限定：experimental=

Draws to the given `rect` on this texture, as well as on up to 3 DrawableTexture `extra_targets`. All `extra_targets` must be the same size and DrawableFormat as the original target, otherwise the Shader may fail. Expects up to 4 Texture `sources`, but will replace missing `sources` with default Black Textures.

### `generate_mipmaps() -> void`

Re-calculates the mipmaps for this texture on demand.

### `get_use_mipmaps() -> bool`
- 限定：qualifiers=const

Returns `true` if mipmaps are set to be used on this DrawableTexture.

### `set_format(format: int) -> void`

Sets the format of this DrawableTexture.

### `set_use_mipmaps(mipmaps: bool) -> void`

Sets if mipmaps should be used on this DrawableTexture.

### `setup(width: int, height: int, format: int, color: Color = Color(1, 1, 1, 1), use_mipmaps: bool = false) -> void`
- 限定：experimental=

Initializes the DrawableTexture to a White texture of the given `width`, `height`, and `format`.

## 枚举

### `DrawableFormat`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `DRAWABLE_FORMAT_RGBA8` |  |
| `1` | `DRAWABLE_FORMAT_RGBA8_SRGB` |  |
| `2` | `DRAWABLE_FORMAT_RGBAH` |  |
| `3` | `DRAWABLE_FORMAT_RGBAF` |  |

