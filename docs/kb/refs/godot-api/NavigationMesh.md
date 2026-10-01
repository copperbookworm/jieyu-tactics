# NavigationMesh

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`NavigationMesh` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/NavigationMesh.md`

**摘要**：A navigation mesh that defines traversable areas and obstacles.

## 描述

A navigation mesh is a collection of polygons that define which areas of an environment are traversable to aid agents in pathfinding through complicated spaces.

## 属性

- **`agent_height`** `float` = `1.5`
  - 其它属性：getter=get_agent_height · setter=set_agent_height
- **`agent_max_climb`** `float` = `0.25`
  - 其它属性：getter=get_agent_max_climb · setter=set_agent_max_climb
- **`agent_max_slope`** `float` = `45.0`
  - 其它属性：getter=get_agent_max_slope · setter=set_agent_max_slope
- **`agent_radius`** `float` = `0.5`
  - 其它属性：getter=get_agent_radius · setter=set_agent_radius
- **`border_size`** `float` = `0.0`
  - 其它属性：getter=get_border_size · setter=set_border_size
- **`cell_height`** `float` = `0.25`
  - 其它属性：getter=get_cell_height · setter=set_cell_height
- **`cell_size`** `float` = `0.25`
  - 其它属性：getter=get_cell_size · setter=set_cell_size
- **`detail_sample_distance`** `float` = `6.0`
  - 其它属性：getter=get_detail_sample_distance · setter=set_detail_sample_distance
- **`detail_sample_max_error`** `float` = `1.0`
  - 其它属性：getter=get_detail_sample_max_error · setter=set_detail_sample_max_error
- **`edge_max_error`** `float` = `1.3`
  - 其它属性：getter=get_edge_max_error · setter=set_edge_max_error
- **`edge_max_length`** `float` = `0.0`
  - 其它属性：getter=get_edge_max_length · setter=set_edge_max_length
- **`filter_baking_aabb`** `AABB` = `AABB(0, 0, 0, 0, 0, 0)`
  - 其它属性：getter=get_filter_baking_aabb · setter=set_filter_baking_aabb
- **`filter_baking_aabb_offset`** `Vector3` = `Vector3(0, 0, 0)`
  - 其它属性：getter=get_filter_baking_aabb_offset · setter=set_filter_baking_aabb_offset
- **`filter_ledge_spans`** `bool` = `false`
  - 其它属性：getter=get_filter_ledge_spans · setter=set_filter_ledge_spans
- **`filter_low_hanging_obstacles`** `bool` = `false`
  - 其它属性：getter=get_filter_low_hanging_obstacles · setter=set_filter_low_hanging_obstacles
- **`filter_walkable_low_height_spans`** `bool` = `false`
  - 其它属性：getter=get_filter_walkable_low_height_spans · setter=set_filter_walkable_low_height_spans
- **`geometry_collision_mask`** `int` = `4294967295`
  - 其它属性：getter=get_collision_mask · setter=set_collision_mask
- **`geometry_parsed_geometry_type`** `int` = `2` · 枚举 `NavigationMesh.ParsedGeometryType`
  - 其它属性：getter=get_parsed_geometry_type · setter=set_parsed_geometry_type
- **`geometry_source_geometry_mode`** `int` = `0` · 枚举 `NavigationMesh.SourceGeometryMode`
  - 其它属性：getter=get_source_geometry_mode · setter=set_source_geometry_mode
- **`geometry_source_group_name`** `StringName` = `&"navigation_mesh_source_group"`
  - 其它属性：getter=get_source_group_name · setter=set_source_group_name
- **`region_merge_size`** `float` = `20.0`
  - 其它属性：getter=get_region_merge_size · setter=set_region_merge_size
- **`region_min_size`** `float` = `2.0`
  - 其它属性：getter=get_region_min_size · setter=set_region_min_size
- **`sample_partition_type`** `int` = `0` · 枚举 `NavigationMesh.SamplePartitionType`
  - 其它属性：getter=get_sample_partition_type · setter=set_sample_partition_type
- **`vertices_per_polygon`** `float` = `6.0`
  - 其它属性：getter=get_vertices_per_polygon · setter=set_vertices_per_polygon

## 方法

### `add_polygon(polygon: PackedInt32Array) -> void`

Adds a polygon using the indices of the vertices you get when calling `get_vertices`.

### `clear() -> void`

Clears the internal arrays for vertices and polygon indices.

### `clear_polygons() -> void`

Clears the array of polygons, but it doesn't clear the array of vertices.

### `create_from_mesh(mesh: Mesh) -> void`

Initializes the navigation mesh by setting the vertices and indices according to a `Mesh`.
				**Note:** The given `mesh` must be of type `Mesh.PRIMITIVE_TRIANGLES` and have an index array.

### `get_collision_mask_value(layer_number: int) -> bool`
- 限定：qualifiers=const

Returns whether or not the specified layer of the `geometry_collision_mask` is enabled, given a `layer_number` between 1 and 32.

### `get_polygon(idx: int) -> PackedInt32Array`

Returns a `PackedInt32Array` containing the indices of the vertices of a created polygon.

### `get_polygon_count() -> int`
- 限定：qualifiers=const

Returns the number of polygons in the navigation mesh.

### `get_vertices() -> PackedVector3Array`
- 限定：qualifiers=const

Returns a `PackedVector3Array` containing all the vertices being used to create the polygons.

### `set_collision_mask_value(layer_number: int, value: bool) -> void`

Based on `value`, enables or disables the specified layer in the `geometry_collision_mask`, given a `layer_number` between 1 and 32.

### `set_vertices(vertices: PackedVector3Array) -> void`

Sets the vertices that can be then indexed to create polygons with the `add_polygon` method.

## 枚举

### `SamplePartitionType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SAMPLE_PARTITION_WATERSHED` |  |
| `1` | `SAMPLE_PARTITION_MONOTONE` |  |
| `2` | `SAMPLE_PARTITION_LAYERS` |  |
| `3` | `SAMPLE_PARTITION_MAX` |  |

### `ParsedGeometryType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `PARSED_GEOMETRY_MESH_INSTANCES` |  |
| `1` | `PARSED_GEOMETRY_STATIC_COLLIDERS` |  |
| `2` | `PARSED_GEOMETRY_BOTH` |  |
| `3` | `PARSED_GEOMETRY_MAX` |  |

### `SourceGeometryMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SOURCE_GEOMETRY_ROOT_NODE_CHILDREN` |  |
| `1` | `SOURCE_GEOMETRY_GROUPS_WITH_CHILDREN` |  |
| `2` | `SOURCE_GEOMETRY_GROUPS_EXPLICIT` |  |
| `3` | `SOURCE_GEOMETRY_MAX` |  |

## 教程链接

- [Using NavigationMeshes](None)
- [3D Navigation Demo](None)

