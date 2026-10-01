# NavigationPathQueryParameters2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`NavigationPathQueryParameters2D` → `RefCounted` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/NavigationPathQueryParameters2D.md`

**摘要**：Provides parameters for 2D navigation path queries.

## 描述

By changing various properties of this object, such as the start and target position, you can configure path queries to the `NavigationServer2D`.

## 属性

- **`excluded_regions`** `RID[]` = `[]`
  - 其它属性：getter=get_excluded_regions · setter=set_excluded_regions
- **`included_regions`** `RID[]` = `[]`
  - 其它属性：getter=get_included_regions · setter=set_included_regions
- **`map`** `RID` = `RID()`
  - 其它属性：getter=get_map · setter=set_map
- **`metadata_flags`** `int` = `7` · 枚举 `NavigationPathQueryParameters2D.PathMetadataFlags` · 位标志
  - 其它属性：getter=get_metadata_flags · is_bitfield=true · setter=set_metadata_flags
- **`navigation_layers`** `int` = `1`
  - 其它属性：getter=get_navigation_layers · setter=set_navigation_layers
- **`path_postprocessing`** `int` = `0` · 枚举 `NavigationPathQueryParameters2D.PathPostProcessing`
  - 其它属性：getter=get_path_postprocessing · setter=set_path_postprocessing
- **`path_return_max_length`** `float` = `0.0`
  - 其它属性：getter=get_path_return_max_length · setter=set_path_return_max_length
- **`path_return_max_radius`** `float` = `0.0`
  - 其它属性：getter=get_path_return_max_radius · setter=set_path_return_max_radius
- **`path_search_max_distance`** `float` = `0.0`
  - 其它属性：getter=get_path_search_max_distance · setter=set_path_search_max_distance
- **`path_search_max_polygons`** `int` = `4096`
  - 其它属性：getter=get_path_search_max_polygons · setter=set_path_search_max_polygons
- **`pathfinding_algorithm`** `int` = `0` · 枚举 `NavigationPathQueryParameters2D.PathfindingAlgorithm`
  - 其它属性：getter=get_pathfinding_algorithm · setter=set_pathfinding_algorithm
- **`simplify_epsilon`** `float` = `0.0`
  - 其它属性：getter=get_simplify_epsilon · setter=set_simplify_epsilon
- **`simplify_path`** `bool` = `false`
  - 其它属性：getter=get_simplify_path · setter=set_simplify_path
- **`start_position`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_start_position · setter=set_start_position
- **`target_position`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_target_position · setter=set_target_position

## 枚举

### `PathfindingAlgorithm`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `PATHFINDING_ALGORITHM_ASTAR` |  |

### `PathPostProcessing`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `PATH_POSTPROCESSING_CORRIDORFUNNEL` |  |
| `1` | `PATH_POSTPROCESSING_EDGECENTERED` |  |
| `2` | `PATH_POSTPROCESSING_NONE` |  |

### `PathMetadataFlags`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `PATH_METADATA_INCLUDE_NONE` | （位标志） |
| `1` | `PATH_METADATA_INCLUDE_TYPES` | （位标志） |
| `2` | `PATH_METADATA_INCLUDE_RIDS` | （位标志） |
| `4` | `PATH_METADATA_INCLUDE_OWNERS` | （位标志） |
| `7` | `PATH_METADATA_INCLUDE_ALL` | （位标志） |

## 教程链接

- [Using NavigationPathQueryObjects](None)

