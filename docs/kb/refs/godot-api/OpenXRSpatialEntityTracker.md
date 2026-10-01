# OpenXRSpatialEntityTracker

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OpenXRSpatialEntityTracker` → `XRPositionalTracker` → `XRTracker` → `RefCounted` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/OpenXRSpatialEntityTracker.md`

**摘要**：Base class for Positional trackers managed by OpenXR's spatial entity extensions.

## 描述

These are trackers created and managed by OpenXR's spatial entity extensions that give access to specific data related to OpenXR's spatial entities. They will always be of type `TRACKER_ANCHOR`.

## 属性

- **`entity`** `RID` = `RID()`
  - 其它属性：getter=get_entity · setter=set_entity
- **`spatial_tracking_state`** `int` = `2` · 枚举 `OpenXRSpatialEntityTracker.EntityTrackingState`
  - 其它属性：getter=get_spatial_tracking_state · setter=set_spatial_tracking_state
- **`type`** `int` = `8` · 枚举 `XRServer.TrackerType`
  - 其它属性：getter=get_tracker_type · overrides=XRTracker · setter=set_tracker_type

## 方法

### `add_next(next: OpenXRStructureBase) -> void`

Adds a new `OpenXRStructureBase` to the next-chain.
				`get_next` will return this `next` until either `add_next` is called again or it's removed in `remove_next`.

### `get_next() -> OpenXRStructureBase`
- 限定：qualifiers=const

Gets the head `OpenXRStructureBase` in the next-chain.
				See also `add_next` and `remove_next`.

### `get_spatial_context() -> RID`
- 限定：qualifiers=const

Gets the spatial context used to create this `OpenXRSpatialEntityTracker`.

### `remove_next(next: OpenXRStructureBase) -> void`

Removes a `next` object previously added in `add_next` from the next-chain.

### `set_spatial_context(spatial_context: RID) -> void`

Sets the spatial context used to create this tracker.

## 信号

### `next_changed()`

Emitted when the next-chain changes, from either `add_next` or `remove_next`.

### `spatial_tracking_state_changed(spatial_tracking_state: int)`

## 枚举

### `EntityTrackingState`

| 值 | 名称 | 说明 |
|---|---|---|
| `1` | `ENTITY_TRACKING_STATE_STOPPED` |  |
| `2` | `ENTITY_TRACKING_STATE_PAUSED` |  |
| `3` | `ENTITY_TRACKING_STATE_TRACKING` |  |

