# OpenXRSpatialEntityExtension

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OpenXRSpatialEntityExtension` → `OpenXRExtensionWrapper` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/OpenXRSpatialEntityExtension.md`

**摘要**：OpenXR extension that handles spatial entities.

## 描述

OpenXR extension that handles spatial entities and, when enabled, allows querying those spatial entities. This extension will also automatically manage `XRTracker` objects for static entities.

## 方法

### `add_spatial_entity(spatial_context: RID, entity_id: int, entity: int) -> RID`

Registers an entity that was created directly on the OpenXR runtime.

### `create_spatial_context(capability_configurations: OpenXRSpatialCapabilityConfigurationBaseHeader[], next: OpenXRStructureBase = null, user_callback: Callable = Callable()) -> OpenXRFutureResult`

Creates a new spatial context that handles entities for the provided capability configurations. `capability_configurations` is an array of `OpenXRSpatialCapabilityConfigurationBaseHeader` with the needed capability configuration data.
				`next` is an optional parameter that can contain additional information for creating our spatial context.
				**Note:** This is an asynchronous method and returns an `OpenXRFutureResult` object with which to track the status, discarding this object will not cancel the creation process. On success `user_callback` will be called if specified. The result data for this function is the `RID` for our spatial context.

### `discover_spatial_entities(spatial_context: RID, component_types: PackedInt64Array, next: OpenXRStructureBase = null, user_callback: Callable = Callable()) -> OpenXRFutureResult`

Starts a new discovery query, this will gather all objects tracked by the `spatial_context` that have at least one of the component types specified in `component_types`.
				`next` is an optional parameter that can contain additional information for executing the discovery query.
				**Note:** This is an asynchronous method and returns an `OpenXRFutureResult` object with which to track the status, discarding this object will not cancel the discovery process. On success `user_callback` will be called if specified. The result data for this function is the `RID` for our snapshot.

### `discover_spatial_entities_with_component_data(spatial_context: RID, component_data: OpenXRSpatialComponentData[], next: OpenXRStructureBase = null, user_callback: Callable = Callable()) -> OpenXRFutureResult`

Convenience method when the caller only has an `Array` of `OpenXRSpatialComponentData` and needs to discover spatial entities.

### `find_spatial_entity(entity_id: int) -> RID`

Returns the `RID` for the specified spatial entity ID.

### `free_spatial_context(spatial_context: RID) -> void`

Frees a spatial context previously created when calling `create_spatial_context`. If the spatial context creation is still ongoing, the asynchronous process is cancelled.

### `free_spatial_entity(entity: RID) -> void`

Frees an entity previously created when calling `add_spatial_entity` or `make_spatial_entity`.

### `free_spatial_snapshot(spatial_snapshot: RID) -> void`

Frees a spatial snapshot previously created when calling `discover_spatial_entities`. If the spatial snapshot creation is still ongoing, the asynchronous process is cancelled.

### `get_float_buffer(spatial_snapshot: RID, buffer_id: int) -> PackedFloat32Array`
- 限定：qualifiers=const

Returns a buffer with floats from a buffer that was retrieved when taking a snapshot.

### `get_spatial_context_handle(spatial_context: RID) -> int`
- 限定：qualifiers=const

Returns the OpenXR spatial context handle for this snapshot.
				**Note:** This method is intended to be used from GDExtensions that implement spatial entity capability handlers.

### `get_spatial_context_ready(spatial_context: RID) -> bool`
- 限定：qualifiers=const

Returns `true` if the spatial context finished its creation and is ready to be used.

### `get_spatial_entity_context(entity: RID) -> RID`
- 限定：qualifiers=const

Returns the spatial context for this entity.

### `get_spatial_entity_id(entity: RID) -> int`
- 限定：qualifiers=const

Returns the internal `XrSpatialEntityIdEXT` associated with the entity.

### `get_spatial_snapshot_context(spatial_snapshot: RID) -> RID`
- 限定：qualifiers=const

Returns the spatial context related to this spatial snapshot.

### `get_spatial_snapshot_handle(spatial_snapshot: RID) -> int`
- 限定：qualifiers=const

Returns the OpenXR spatial snapshot handle for this snapshot.
				**Note:** This method is intended to be used from GDExtensions that implement spatial entity capability handlers.

### `get_string(spatial_snapshot: RID, buffer_id: int) -> String`
- 限定：qualifiers=const

Returns a string from a buffer that was retrieved when taking a snapshot.

### `get_uint8_buffer(spatial_snapshot: RID, buffer_id: int) -> PackedByteArray`
- 限定：qualifiers=const

Returns a buffer with 8 bit ints from a buffer that was retrieved when taking a snapshot.

### `get_uint16_buffer(spatial_snapshot: RID, buffer_id: int) -> PackedInt32Array`
- 限定：qualifiers=const

Returns a buffer with 16 bit ints from a buffer that was retrieved when taking a snapshot.

### `get_uint32_buffer(spatial_snapshot: RID, buffer_id: int) -> PackedInt32Array`
- 限定：qualifiers=const

Returns a buffer with 32 bit ints from a buffer that was retrieved when taking a snapshot.

### `get_vector2_buffer(spatial_snapshot: RID, buffer_id: int) -> PackedVector2Array`
- 限定：qualifiers=const

Returns a buffer with `Vector2` entries from a buffer that was retrieved when taking a snapshot.

### `get_vector3_buffer(spatial_snapshot: RID, buffer_id: int) -> PackedVector3Array`
- 限定：qualifiers=const

Returns a buffer with `Vector3` entries from a buffer that was retrieved when taking a snapshot.

### `make_spatial_entity(spatial_context: RID, entity_id: int) -> RID`

Creates a new entity for this `entity_id`. The `spatial_context` should match the context that discovered the entity.

### `query_snapshot(spatial_snapshot: RID, component_data: OpenXRSpatialComponentData[], next: OpenXRStructureBase = null) -> bool`

Queries the snapshot data. This will find all entities in the snapshot that contain all requested components in `component_data`. The objects held within `component_data` will then be populated with the queried data. `component_data` must always have an object of `OpenXRSpatialQueryResultData` as the first entry.
				`next` is an optional parameter that can contain additional information passed when setting our query conditions.

### `supports_capability(capability: int) -> bool`

Returns `true` if this spatial entity `capability` is supported by the hardware used.

### `supports_component_type(capability: int, component_type: int) -> bool`

Returns `true` if this `capability` supports the `component_type`.

### `update_spatial_entities(spatial_context: RID, entities: RID[], component_types: PackedInt64Array, next: OpenXRStructureBase = null) -> RID`

Performs a snapshot for a limited number of entities. This is NOT an asynchronous method and will return the snapshot immediately.

## 信号

### `spatial_discovery_recommended(spatial_context: RID)`

Emitted when OpenXR recommends running a discovery query because entities managed by this spatial context have (likely) changed.

## 枚举

### `Capability`

| 值 | 名称 | 说明 |
|---|---|---|
| `1000741000` | `CAPABILITY_PLANE_TRACKING` |  |
| `1000743000` | `CAPABILITY_MARKER_TRACKING_QR_CODE` |  |
| `1000743001` | `CAPABILITY_MARKER_TRACKING_MICRO_QR_CODE` |  |
| `1000743002` | `CAPABILITY_MARKER_TRACKING_ARUCO_MARKER` |  |
| `1000743003` | `CAPABILITY_MARKER_TRACKING_APRIL_TAG` |  |
| `1000762000` | `CAPABILITY_ANCHOR` |  |

### `ComponentType`

| 值 | 名称 | 说明 |
|---|---|---|
| `1` | `COMPONENT_TYPE_BOUNDED_2D` |  |
| `2` | `COMPONENT_TYPE_BOUNDED_3D` |  |
| `3` | `COMPONENT_TYPE_PARENT` |  |
| `4` | `COMPONENT_TYPE_MESH_3D` |  |
| `1000741000` | `COMPONENT_TYPE_PLANE_ALIGNMENT` |  |
| `1000741001` | `COMPONENT_TYPE_MESH_2D` |  |
| `1000741002` | `COMPONENT_TYPE_POLYGON_2D` |  |
| `1000741003` | `COMPONENT_TYPE_PLANE_SEMANTIC_LABEL` |  |
| `1000743000` | `COMPONENT_TYPE_MARKER` |  |
| `1000762000` | `COMPONENT_TYPE_ANCHOR` |  |
| `1000763000` | `COMPONENT_TYPE_PERSISTENCE` |  |

