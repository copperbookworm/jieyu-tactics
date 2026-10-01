# OpenXRMarkerTracker

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OpenXRMarkerTracker` → `OpenXRSpatialEntityTracker` → `XRPositionalTracker` → `XRTracker` → `RefCounted` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/OpenXRMarkerTracker.md`

**摘要**：Spatial entity tracker for our spatial entity marker tracking extension.

## 描述

Spatial entity tracker for our OpenXR spatial entity marker tracking extension. These trackers identify entities in our real space detected by a visual marker such as a QRCode or Aruco code, and map their location to our virtual space.

## 属性

- **`bounds_size`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_bounds_size · setter=set_bounds_size
- **`marker_id`** `int` = `0`
  - 其它属性：getter=get_marker_id · setter=set_marker_id
- **`marker_type`** `int` = `0` · 枚举 `OpenXRSpatialComponentMarkerList.MarkerType`
  - 其它属性：getter=get_marker_type · setter=set_marker_type

## 方法

### `get_marker_data() -> Variant`
- 限定：qualifiers=const

Returns the marker data for this marker. This can return a `String` or `PackedByteArray`. Only applicable to QR Code based markers.

### `set_marker_data(marker_data: Variant) -> void`

Sets the marker data for this marker.
				**Note:** This should only be set by marker discovery logic.

