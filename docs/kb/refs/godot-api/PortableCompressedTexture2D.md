# PortableCompressedTexture2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`PortableCompressedTexture2D` → `Texture2D` → `Texture` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/PortableCompressedTexture2D.md`

**摘要**：Provides a compressed texture for disk and/or VRAM in a way that is portable.

## 描述

This class allows storing compressed textures as self contained (not imported) resources.
		For 2D usage (compressed on disk, uncompressed on VRAM), the lossy and lossless modes are recommended. For 3D usage (compressed on VRAM) it depends on the target platform.
		If you intend to only use desktop, S3TC or BPTC are recommended. For only mobile, ETC2 is recommended.
		For portable, self contained 3D textures that work on both desktop and mobile, Basis Universal is recommended (although it has a small quality cost and longer compression time as a tradeoff).
		This resource is intended to be created from code.

## 属性

- **`keep_compressed_buffer`** `bool` = `false`
  - 其它属性：getter=is_keeping_compressed_buffer · setter=set_keep_compressed_buffer
- **`resource_local_to_scene`** `bool` = `false`
  - 其它属性：getter=is_local_to_scene · overrides=Resource · setter=set_local_to_scene
- **`size_override`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_size_override · setter=set_size_override

## 方法

### `create_from_image(image: Image, compression_mode: int, normal_map: bool = false, lossy_quality: float = 0.8) -> void`

Initializes the compressed texture from a base image. The compression mode must be provided.
				`normal_map` is recommended to ensure optimum quality if this image will be used as a normal map.
				If lossy compression is requested, the quality setting can optionally be provided. This maps to Lossy WebP compression quality.

### `get_compression_mode() -> int`
- 限定：qualifiers=const

Return the compression mode used (valid after initialized).

### `is_keeping_all_compressed_buffers() -> bool`
- 限定：qualifiers=static

Returns `true` if the flag is overridden for all textures of this type.

### `set_basisu_compressor_params(uastc_level: int, rdo_quality_loss: float) -> void`

Sets the compressor parameters for Basis Universal compression. See also the settings in `ResourceImporterTexture`.
				**Note:** This method must be called before `create_from_image` for this to work.

### `set_keep_all_compressed_buffers(keep: bool) -> void`
- 限定：qualifiers=static

If `keep` is `true`, overrides the flag globally for all textures of this type. This is used primarily by the editor.

## 枚举

### `CompressionMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `COMPRESSION_MODE_LOSSLESS` |  |
| `1` | `COMPRESSION_MODE_LOSSY` |  |
| `2` | `COMPRESSION_MODE_BASIS_UNIVERSAL` |  |
| `3` | `COMPRESSION_MODE_S3TC` |  |
| `4` | `COMPRESSION_MODE_ETC2` |  |
| `5` | `COMPRESSION_MODE_BPTC` |  |
| `6` | `COMPRESSION_MODE_ASTC` |  |

