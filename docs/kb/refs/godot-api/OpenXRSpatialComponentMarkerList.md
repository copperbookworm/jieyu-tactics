# OpenXRSpatialComponentMarkerList

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OpenXRSpatialComponentMarkerList` → `OpenXRSpatialComponentData` → `RefCounted` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/OpenXRSpatialComponentMarkerList.md`

**摘要**：Object for storing the queries marker result data.

## 描述

Object for storing the queries marker result data when calling `OpenXRSpatialEntityExtension.query_snapshot`.

## 方法

### `get_marker_data(snapshot: RID, index: int) -> Variant`
- 限定：qualifiers=const

Returns either a `String` or a `PackedByteArray` buffer with data for the marker at this `index`. Only applicable for QR code markers.

### `get_marker_id(index: int) -> int`
- 限定：qualifiers=const

Returns the marker ID for the marker at this `index`. Only applicable for Aruco or April Tag markers.

### `get_marker_type(index: int) -> int`
- 限定：qualifiers=const

Returns the marker type for the marker at this `index`.

## 枚举

### `MarkerType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `MARKER_TYPE_UNKNOWN` |  |
| `1` | `MARKER_TYPE_QRCODE` |  |
| `2` | `MARKER_TYPE_MICRO_QRCODE` |  |
| `3` | `MARKER_TYPE_ARUCO` |  |
| `4` | `MARKER_TYPE_APRIL_TAG` |  |
| `5` | `MARKER_TYPE_MAX` |  |

