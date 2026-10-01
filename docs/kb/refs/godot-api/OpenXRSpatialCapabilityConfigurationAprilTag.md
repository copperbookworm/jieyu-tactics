# OpenXRSpatialCapabilityConfigurationAprilTag

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OpenXRSpatialCapabilityConfigurationAprilTag` → `OpenXRSpatialCapabilityConfigurationBaseHeader` → `RefCounted` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/OpenXRSpatialCapabilityConfigurationAprilTag.md`

**摘要**：Configuration header for April tag markers.

## 描述

Configuration header for April tag markers. Pass this to `OpenXRSpatialEntityExtension.create_spatial_context` to create a spatial context that can detect April tags.

## 属性

- **`april_dict`** `int` = `4` · 枚举 `OpenXRSpatialCapabilityConfigurationAprilTag.AprilTagDict`
  - 其它属性：getter=get_april_dict · setter=set_april_dict

## 方法

### `get_enabled_components() -> PackedInt64Array`
- 限定：qualifiers=const

Returns the components enabled by this configuration.
				**Note:** Only valid after this configuration was used to create a spatial context.

## 枚举

### `AprilTagDict`

| 值 | 名称 | 说明 |
|---|---|---|
| `1` | `APRIL_TAG_DICT_16H5` |  |
| `2` | `APRIL_TAG_DICT_25H9` |  |
| `3` | `APRIL_TAG_DICT_36H10` |  |
| `4` | `APRIL_TAG_DICT_36H11` |  |

