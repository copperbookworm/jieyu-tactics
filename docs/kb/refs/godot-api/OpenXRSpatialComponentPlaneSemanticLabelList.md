# OpenXRSpatialComponentPlaneSemanticLabelList

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OpenXRSpatialComponentPlaneSemanticLabelList` → `OpenXRSpatialComponentData` → `RefCounted` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/OpenXRSpatialComponentPlaneSemanticLabelList.md`

**摘要**：Object for storing the queries plane semantic label result data.

## 描述

Object for storing the queries plane semantic label result data when calling `OpenXRSpatialEntityExtension.query_snapshot`.

## 方法

### `get_plane_semantic_label(index: int) -> int`
- 限定：qualifiers=const

Returns the plane semantic label for the parent entity at this `index`.

## 枚举

### `PlaneSemanticLabel`

| 值 | 名称 | 说明 |
|---|---|---|
| `1` | `PLANE_SEMANTIC_LABEL_UNCATEGORIZED` |  |
| `2` | `PLANE_SEMANTIC_LABEL_FLOOR` |  |
| `3` | `PLANE_SEMANTIC_LABEL_WALL` |  |
| `4` | `PLANE_SEMANTIC_LABEL_CEILING` |  |
| `5` | `PLANE_SEMANTIC_LABEL_TABLE` |  |

