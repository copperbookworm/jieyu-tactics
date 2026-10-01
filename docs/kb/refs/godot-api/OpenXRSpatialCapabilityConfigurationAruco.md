# OpenXRSpatialCapabilityConfigurationAruco

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OpenXRSpatialCapabilityConfigurationAruco` → `OpenXRSpatialCapabilityConfigurationBaseHeader` → `RefCounted` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/OpenXRSpatialCapabilityConfigurationAruco.md`

**摘要**：Configuration header for Aruco markers.

## 描述

Configuration header for Aruco markers. Pass this to `OpenXRSpatialEntityExtension.create_spatial_context` to create a spatial context that can detect Aruco markers.

## 属性

- **`aruco_dict`** `int` = `16` · 枚举 `OpenXRSpatialCapabilityConfigurationAruco.ArucoDict`
  - 其它属性：getter=get_aruco_dict · setter=set_aruco_dict

## 方法

### `get_enabled_components() -> PackedInt64Array`
- 限定：qualifiers=const

Returns the components enabled by this configuration.
				**Note:** Only valid after this configuration was used to create a spatial context.

## 枚举

### `ArucoDict`

| 值 | 名称 | 说明 |
|---|---|---|
| `1` | `ARUCO_DICT_4X4_50` |  |
| `2` | `ARUCO_DICT_4X4_100` |  |
| `3` | `ARUCO_DICT_4X4_250` |  |
| `4` | `ARUCO_DICT_4X4_1000` |  |
| `5` | `ARUCO_DICT_5X5_50` |  |
| `6` | `ARUCO_DICT_5X5_100` |  |
| `7` | `ARUCO_DICT_5X5_250` |  |
| `8` | `ARUCO_DICT_5X5_1000` |  |
| `9` | `ARUCO_DICT_6X6_50` |  |
| `10` | `ARUCO_DICT_6X6_100` |  |
| `11` | `ARUCO_DICT_6X6_250` |  |
| `12` | `ARUCO_DICT_6X6_1000` |  |
| `13` | `ARUCO_DICT_7X7_50` |  |
| `14` | `ARUCO_DICT_7X7_100` |  |
| `15` | `ARUCO_DICT_7X7_250` |  |
| `16` | `ARUCO_DICT_7X7_1000` |  |

