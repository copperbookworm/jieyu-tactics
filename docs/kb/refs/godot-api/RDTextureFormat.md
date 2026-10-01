# RDTextureFormat

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`RDTextureFormat` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/RDTextureFormat.md`

**摘要**：Texture format (used by `RenderingDevice`).

## 描述

This object is used by `RenderingDevice`.

## 属性

- **`array_layers`** `int` = `1`
  - 其它属性：getter=get_array_layers · setter=set_array_layers
- **`depth`** `int` = `1`
  - 其它属性：getter=get_depth · setter=set_depth
- **`format`** `int` = `8` · 枚举 `RenderingDevice.DataFormat`
  - 其它属性：getter=get_format · setter=set_format
- **`height`** `int` = `1`
  - 其它属性：getter=get_height · setter=set_height
- **`is_discardable`** `bool` = `false`
  - 其它属性：getter=get_is_discardable · setter=set_is_discardable
- **`is_resolve_buffer`** `bool` = `false`
  - 其它属性：getter=get_is_resolve_buffer · setter=set_is_resolve_buffer
- **`mipmaps`** `int` = `1`
  - 其它属性：getter=get_mipmaps · setter=set_mipmaps
- **`samples`** `int` = `0` · 枚举 `RenderingDevice.TextureSamples`
  - 其它属性：getter=get_samples · setter=set_samples
- **`texture_type`** `int` = `1` · 枚举 `RenderingDevice.TextureType`
  - 其它属性：getter=get_texture_type · setter=set_texture_type
- **`usage_bits`** `int` = `0` · 枚举 `RenderingDevice.TextureUsageBits` · 位标志
  - 其它属性：getter=get_usage_bits · is_bitfield=true · setter=set_usage_bits
- **`width`** `int` = `1`
  - 其它属性：getter=get_width · setter=set_width

## 方法

### `add_shareable_format(format: int) -> void`

Adds `format` as a valid format for the corresponding `RDTextureView`'s `RDTextureView.format_override` property. If any format is added as shareable, then the main `format` must also be added.

### `remove_shareable_format(format: int) -> void`

Removes `format` from the list of valid formats that the corresponding `RDTextureView`'s `RDTextureView.format_override` property can be set to.

