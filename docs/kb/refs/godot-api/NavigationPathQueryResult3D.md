# NavigationPathQueryResult3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`NavigationPathQueryResult3D` → `RefCounted` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/NavigationPathQueryResult3D.md`

**摘要**：Represents the result of a 3D pathfinding query.

## 描述

This class stores the result of a 3D navigation path query from the `NavigationServer3D`.

## 属性

- **`path`** `PackedVector3Array` = `PackedVector3Array()`
  - 其它属性：getter=get_path · setter=set_path
- **`path_length`** `float` = `0.0`
  - 其它属性：getter=get_path_length · setter=set_path_length
- **`path_owner_ids`** `PackedInt64Array` = `PackedInt64Array()`
  - 其它属性：getter=get_path_owner_ids · setter=set_path_owner_ids
- **`path_rids`** `RID[]` = `[]`
  - 其它属性：getter=get_path_rids · setter=set_path_rids
- **`path_types`** `PackedInt32Array` = `PackedInt32Array()`
  - 其它属性：getter=get_path_types · setter=set_path_types

## 方法

### `reset() -> void`

Reset the result object to its initial state. This is useful to reuse the object across multiple queries.

## 枚举

### `PathSegmentType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `PATH_SEGMENT_TYPE_REGION` |  |
| `1` | `PATH_SEGMENT_TYPE_LINK` |  |

## 教程链接

- [Using NavigationPathQueryObjects](None)

