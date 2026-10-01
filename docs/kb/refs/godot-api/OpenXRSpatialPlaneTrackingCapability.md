# OpenXRSpatialPlaneTrackingCapability

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OpenXRSpatialPlaneTrackingCapability` → `OpenXRExtensionWrapper` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/OpenXRSpatialPlaneTrackingCapability.md`

**摘要**：Implementation for handling spatial entity plane tracking logic.

## 描述

This class handles the OpenXR plane tracking spatial entity extension.

## 方法

### `is_supported() -> bool`

Returns `true` if plane tracking is supported by the current device.

### `start_entity_discovery(spatial_context: RID, component_data: OpenXRSpatialComponentData[], next_snapshot_create: OpenXRStructureBase = null, next_snapshot_query: OpenXRStructureBase = null, user_callback: Callable = Callable()) -> OpenXRFutureResult`

Calls `OpenXRSpatialEntityExtension.discover_spatial_entities` and `OpenXRSpatialEntityExtension.query_snapshot` with the plane entities associated with `spatial_context`.
				`component_data` are the `OpenXRSpatialComponentData`s to discover for this plane capability.
				If `next_snapshot_create` is non-null, then pass this to the `next` parameter in `OpenXRSpatialEntityExtension.discover_spatial_entities`.
				If `next_snapshot_query` is non-null, then pass this to the `next` parameter in `OpenXRSpatialEntityExtension.query_snapshot`.
				`user_callback`, when non-null, is called with two parameters usually twice. The first parameter is the `RID` of the discovery snapshot and the second parameter is a boolean where `false` indicates the discovery snapshot is about to be processed, and `true` indicates the discovery snapshot has been processed and `component_data` has valid data. The second call is skipped if an error was encountered.
				The returned `OpenXRFutureResult` is identical to the return from `OpenXRSpatialEntityExtension.discover_spatial_entities`.

