# OpenXRSpatialComponentPersistenceList

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OpenXRSpatialComponentPersistenceList` → `OpenXRSpatialComponentData` → `RefCounted` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/OpenXRSpatialComponentPersistenceList.md`

**摘要**：Object for storing the query persistence result data.

## 描述

Object for storing the query persistence result data when calling `OpenXRSpatialEntityExtension.query_snapshot`.

## 方法

### `get_persistent_state(index: int) -> int`
- 限定：qualifiers=const

Returns the persistent state (`XrSpatialPersistenceStateEXT`) for the entity at this `index`.

### `get_persistent_uuid(index: int) -> String`
- 限定：qualifiers=const

Returns the persistent uuid for the entity at this `index`.

