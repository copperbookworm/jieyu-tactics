# OpenXRStructureBase

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OpenXRStructureBase` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/OpenXRStructureBase.md`

**摘要**：Object for storing OpenXR structure data.

## 描述

Object for storing OpenXR structure data that is passed when calling into OpenXR APIs.

## 属性

- **`next`** `OpenXRStructureBase`
  - 其它属性：getter=get_next · setter=set_next

## 方法

### `_get_header(next: int) -> int`
- 限定：qualifiers=virtual

### `get_structure_type() -> int`

Returns the structure type (OpenXR `XrStructureType`) used for this structure.

