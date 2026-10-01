# OpenXRSpatialQueryResultData

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OpenXRSpatialQueryResultData` → `OpenXRSpatialComponentData` → `RefCounted` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/OpenXRSpatialQueryResultData.md`

**摘要**：Object for storing the main query result data.

## 描述

Object for storing the main query result data when calling `OpenXRSpatialEntityExtension.query_snapshot`. This must always be the first component requested.

## 方法

### `get_capacity() -> int`
- 限定：qualifiers=const

Returns the number of entities that were retrieved.

### `get_entity_id(index: int) -> int`
- 限定：qualifiers=const

Returns the entity id (`XrSpatialEntityIdEXT`) for the entity at this `index`.

### `get_entity_state(index: int) -> int`
- 限定：qualifiers=const

Returns the entity state for the entity at this `index`.

