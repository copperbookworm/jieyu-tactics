# OpenXRSpatialContextPersistenceConfig

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OpenXRSpatialContextPersistenceConfig` → `OpenXRStructureBase` → `RefCounted` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/OpenXRSpatialContextPersistenceConfig.md`

**摘要**：Configuration header for spatial persistence.

## 描述

Configuration header for spatial persistence. Pass this to `OpenXRSpatialEntityExtension.create_spatial_context` as the next parameter to create a spatial context with spatial persistence capabilities.

## 方法

### `add_persistence_context(persistence_context: RID) -> void`

Adds a persistence context to this configuration. You must add at least one persistence context to create a valid configuration. You can create a persistence context by calling `OpenXRSpatialAnchorCapability.create_persistence_context`.

### `get_persistence_contexts() -> Array`
- 限定：qualifiers=const

Gets the persistence context(s) (as `RID`s) received by `add_persistence_context`.

### `remove_persistence_context(persistence_context: RID) -> void`

Removes a persistence context.

