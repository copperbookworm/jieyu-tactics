# OpenXRSpatialAnchorCapability

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OpenXRSpatialAnchorCapability` → `OpenXRExtensionWrapper` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/OpenXRSpatialAnchorCapability.md`

**摘要**：Implementation for handling spatial entity anchor logic.

## 描述

This is an internal class that handles the OpenXR anchor spatial entity extension.

## 方法

### `create_default_persistence_context(user_callback: Callable = Callable()) -> OpenXRFutureResult`

Calls `create_persistence_context` with a configuration that likely works with the XR runtime.
				`user_callback` is called when the context is created.

### `create_new_anchor(transform: Transform3D, spatial_context: RID = RID(), next: OpenXRStructureBase = null) -> OpenXRAnchorTracker`

Creates a new anchor that will be tracked by the XR runtime. The `transform` should be a transform in the local space of your `XROrigin3D` node. If `spatial_context` is not specified the default will be used, this requires `ProjectSettings.xr/openxr/extensions/spatial_entity/enable_builtin_anchor_detection` to be set. The returned tracker will track the location in case our reference space changes.
				`next` must be a valid next object for the `XrSpatialAnchorCreateInfoEXT` chain.

### `create_persistence_context(scope: int, user_callback: Callable = Callable()) -> OpenXRFutureResult`

Creates a new persistence context for storing persistent data.
				**Note:** This is an asynchronous method and returns an `OpenXRFutureResult` object with which to track the status, discarding this object will not cancel the creation process. On success `user_callback` will be called if specified. The result value for this function is the `RID` for our persistence context.

### `do_entity_update(spatial_context: RID, component_data: OpenXRSpatialComponentData[], next_snapshot_create: OpenXRStructureBase = null, next_snapshot_query: OpenXRStructureBase = null) -> void`

Calls `OpenXRSpatialEntityExtension.update_spatial_entities` and `OpenXRSpatialEntityExtension.query_snapshot` with the anchor entities associated with `spatial_context`.
				`component_data` are the `OpenXRSpatialComponentData`s to update for this anchor capability.
				If `next_snapshot_create` is non-null, then pass this to the `next` parameter in `OpenXRSpatialEntityExtension.update_spatial_entities`.
				If `next_snapshot_query` is non-null, then pass this to the `next` parameter in `OpenXRSpatialEntityExtension.query_snapshot`.

### `free_persistence_context(persistence_context: RID) -> void`

Frees a persistence context previously created with `create_persistence_context`.

### `get_persistence_context_handle(persistence_context: RID) -> int`
- 限定：qualifiers=const

Returns the internal handle for this persistence context.
				**Note:** For GDExtension implementations.

### `is_persistence_scope_supported(scope: int) -> bool`

Returns `true` if this persistence scope is supported by our spatial anchor capability.
				**Note:** Only valid after an OpenXR instance has been created.

### `is_spatial_anchor_supported() -> bool`

Returns `true` if spatial anchors are supported by the hardware. Only returns a valid value after OpenXR has been initialized.

### `is_spatial_persistence_supported() -> bool`

Returns `true` if persistent spatial anchors are supported by the hardware. Only returns a valid value after OpenXR has been initialized.

### `persist_anchor(anchor_tracker: OpenXRAnchorTracker, persistence_context: RID = RID(), user_callback: Callable = Callable()) -> OpenXRFutureResult`

Changes this anchor into a persistent anchor. This means its location will be stored on the device and the anchor will be restored the next time your application starts. If `persistence_context` is not specified the default will be used, this requires `ProjectSettings.xr/openxr/extensions/spatial_entity/enable_builtin_anchor_detection` to be set.
				**Note:** This is an asynchronous method and returns an `OpenXRFutureResult` object with which to track the status, discarding this object will not cancel the creation process. On success `user_callback` will be called if specified. The result value for this function is a boolean which will be set to `true` on successful completion.

### `remove_anchor(anchor_tracker: OpenXRAnchorTracker) -> void`

Remove an anchor previously created with `create_new_anchor`. If this anchor was persistent you must first call `unpersist_anchor` and await its callback.

### `start_entity_discovery(spatial_context: RID, component_data: OpenXRSpatialComponentData[], next_snapshot_create: OpenXRStructureBase = null, next_snapshot_query: OpenXRStructureBase = null, user_callback: Callable = Callable()) -> OpenXRFutureResult`

Calls `OpenXRSpatialEntityExtension.discover_spatial_entities` and `OpenXRSpatialEntityExtension.query_snapshot` with the anchor entities associated with `spatial_context`.
				`component_data` are the `OpenXRSpatialComponentData`s to discover for this anchor capability.
				If `next_snapshot_create` is non-null, then pass this to the `next` parameter in `OpenXRSpatialEntityExtension.discover_spatial_entities`.
				If `next_snapshot_query` is non-null, then pass this to the `next` parameter in `OpenXRSpatialEntityExtension.query_snapshot`.
				`user_callback`, when non-null, is called with two parameters usually twice. The first parameter is the `RID` of the discovery snapshot and the second parameter is a boolean where `false` indicates the discovery snapshot is about to be processed, and `true` indicates the discovery snapshot has been processed and `component_data` has valid data. The second call is skipped if an error was encountered.
				The returned `OpenXRFutureResult` is identical to the return from `OpenXRSpatialEntityExtension.discover_spatial_entities`.

### `unpersist_anchor(anchor_tracker: OpenXRAnchorTracker, persistence_context: RID = RID(), user_callback: Callable = Callable()) -> OpenXRFutureResult`

Removes the persistent data from this anchor. The runtime will not recreate the anchor when your application restarts. If `persistence_context` is not specified the default will be used, this requires `ProjectSettings.xr/openxr/extensions/spatial_entity/enabled` to be set.
				**Note:** This is an asynchronous method and returns an `OpenXRFutureResult` object with which to track the status, discarding this object will not cancel the creation process. On success `user_callback` will be called if specified. The result value for this function is a boolean which will be set to `true` on successful completion.

## 枚举

### `PersistenceScope`

| 值 | 名称 | 说明 |
|---|---|---|
| `1` | `PERSISTENCE_SCOPE_SYSTEM_MANAGED` |  |
| `1000781000` | `PERSISTENCE_SCOPE_LOCAL_ANCHORS` |  |

