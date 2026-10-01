# OpenXRSpatialComponentData

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OpenXRSpatialComponentData` → `RefCounted` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/OpenXRSpatialComponentData.md`

**摘要**：Object for storing OpenXR spatial entity component data.

## 描述

Object for storing OpenXR spatial entity component data.

## 方法

### `_get_component_type() -> int`
- 限定：qualifiers=virtual const

Return the component type for the component we store data for.

### `_get_structure_data(next: int) -> int`
- 限定：qualifiers=virtual

Return a pointer to the structure data that will be submitted along with the snapshot query. This pointer must remain valid as long as this object is instantiated.

### `_set_capacity(capacity: int) -> void`
- 限定：qualifiers=virtual

Sets the expected capacity as provided by the spatial entities query system. Buffers should be initialized with the correct storage.

### `get_component_type() -> int`
- 限定：qualifiers=const

Gets this `OpenXRSpatialComponentData`'s `XrSpatialComponentTypeEXT`.

### `set_capacity(capacity: int) -> void`

Sets the expected capacity as provided by the spatial entities query system. Buffers should be initialized with the correct storage.

