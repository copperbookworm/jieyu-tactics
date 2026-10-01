# NavigationPolygon

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`NavigationPolygon` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/NavigationPolygon.md`

**摘要**：A 2D navigation mesh that describes a traversable surface for pathfinding.

## 描述

A navigation mesh can be created either by baking it with the help of the `NavigationServer2D`, or by adding vertices and convex polygon indices arrays manually.
		To bake a navigation mesh at least one outline needs to be added that defines the outer bounds of the baked area.
		`codeblocks`
		`gdscript`
		var new_navigation_mesh = NavigationPolygon.new()
		var bounding_outline = PackedVector2Array([Vector2(0, 0), Vector2(0, 50), Vector2(50, 50), Vector2(50, 0)])
		new_navigation_mesh.add_outline(bounding_outline)
		NavigationServer2D.bake_from_source_geometry_data(new_navigation_mesh, NavigationMeshSourceGeometryData2D.new());
		$NavigationRegion2D.navigation_polygon = new_navigation_mesh
		
		`csharp`
		var newNavigationMesh = new NavigationPolygon();
		Vector2[] boundingOutline = `Vector2(0, 0), new Vector2(0, 50), new Vector2(50, 50), new Vector2(50, 0)`;
		newNavigationMesh.AddOutline(boundingOutline);
		NavigationServer2D.BakeFromSourceGeometryData(newNavigationMesh, new NavigationMeshSourceGeometryData2D());
		GetNode<NavigationRegion2D>("NavigationRegion2D").NavigationPolygon = newNavigationMesh;
		
		
		Adding vertices and polygon indices manually.
		`codeblocks`
		`gdscript`
		var new_navigation_mesh = NavigationPolygon.new()
		var new_vertices = PackedVector2Array([Vector2(0, 0), Vector2(0, 50), Vector2(50, 50), Vector2(50, 0)])
		new_navigation_mesh.vertices = new_vertices
		var new_polygon_indices = PackedInt32Array([0, 1, 2, 3])
		new_navigation_mesh.add_polygon(new_polygon_indices)
		$NavigationRegion2D.navigation_polygon = new_navigation_mesh
		
		`csharp`
		var newNavigationMesh = new NavigationPolygon();
		Vector2[] newVertices = `Vector2(0, 0), new Vector2(0, 50), new Vector2(50, 50), new Vector2(50, 0)`;
		newNavigationMesh.Vertices = newVertices;
		int[] newPolygonIndices = [0, 1, 2, 3];
		newNavigationMesh.AddPolygon(newPolygonIndices);
		GetNode<NavigationRegion2D>("NavigationRegion2D").NavigationPolygon = newNavigationMesh;

## 属性

- **`agent_radius`** `float` = `10.0`
  - 其它属性：getter=get_agent_radius · setter=set_agent_radius
- **`baking_rect`** `Rect2` = `Rect2(0, 0, 0, 0)`
  - 其它属性：getter=get_baking_rect · setter=set_baking_rect
- **`baking_rect_offset`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_baking_rect_offset · setter=set_baking_rect_offset
- **`border_size`** `float` = `0.0`
  - 其它属性：getter=get_border_size · setter=set_border_size
- **`cell_size`** `float` = `1.0`
  - 其它属性：getter=get_cell_size · setter=set_cell_size
- **`parsed_collision_mask`** `int` = `4294967295`
  - 其它属性：getter=get_parsed_collision_mask · setter=set_parsed_collision_mask
- **`parsed_geometry_type`** `int` = `2` · 枚举 `NavigationPolygon.ParsedGeometryType`
  - 其它属性：getter=get_parsed_geometry_type · setter=set_parsed_geometry_type
- **`sample_partition_type`** `int` = `0` · 枚举 `NavigationPolygon.SamplePartitionType`
  - 其它属性：getter=get_sample_partition_type · setter=set_sample_partition_type
- **`source_geometry_group_name`** `StringName` = `&"navigation_polygon_source_geometry_group"`
  - 其它属性：getter=get_source_geometry_group_name · setter=set_source_geometry_group_name
- **`source_geometry_mode`** `int` = `0` · 枚举 `NavigationPolygon.SourceGeometryMode`
  - 其它属性：getter=get_source_geometry_mode · setter=set_source_geometry_mode

## 方法

### `add_outline(outline: PackedVector2Array) -> void`

Appends a `PackedVector2Array` that contains the vertices of an outline to the internal array that contains all the outlines.

### `add_outline_at_index(outline: PackedVector2Array, index: int) -> void`

Adds a `PackedVector2Array` that contains the vertices of an outline to the internal array that contains all the outlines at a fixed position.

### `add_polygon(polygon: PackedInt32Array) -> void`

Adds a polygon using the indices of the vertices you get when calling `get_vertices`.

### `clear() -> void`

Clears the internal arrays for vertices and polygon indices.

### `clear_outlines() -> void`

Clears the array of the outlines, but it doesn't clear the vertices and the polygons that were created by them.

### `clear_polygons() -> void`

Clears the array of polygons, but it doesn't clear the array of outlines and vertices.

### `get_navigation_mesh() -> NavigationMesh`

Returns the `NavigationMesh` resulting from this navigation polygon. This navigation mesh can be used to update the navigation mesh of a region with the `NavigationServer3D.region_set_navigation_mesh` API directly.

### `get_outline(idx: int) -> PackedVector2Array`
- 限定：qualifiers=const

Returns a `PackedVector2Array` containing the vertices of an outline that was created in the editor or by script.

### `get_outline_count() -> int`
- 限定：qualifiers=const

Returns the number of outlines that were created in the editor or by script.

### `get_parsed_collision_mask_value(layer_number: int) -> bool`
- 限定：qualifiers=const

Returns whether or not the specified layer of the `parsed_collision_mask` is enabled, given a `layer_number` between 1 and 32.

### `get_polygon(idx: int) -> PackedInt32Array`

Returns a `PackedInt32Array` containing the indices of the vertices of a created polygon.

### `get_polygon_count() -> int`
- 限定：qualifiers=const

Returns the count of all polygons.

### `get_vertices() -> PackedVector2Array`
- 限定：qualifiers=const

Returns a `PackedVector2Array` containing all the vertices being used to create the polygons.

### `make_polygons_from_outlines() -> void`
- 限定：deprecated=Use [method NavigationServer2D.parse_source_geometry_data] and [method NavigationServer2D.bake_from_source_geometry_data] instead.

Creates polygons from the outlines added in the editor or by script.

### `remove_outline(idx: int) -> void`

Removes an outline created in the editor or by script. You have to call `make_polygons_from_outlines` for the polygons to update.

### `set_outline(idx: int, outline: PackedVector2Array) -> void`

Changes an outline created in the editor or by script. You have to call `make_polygons_from_outlines` for the polygons to update.

### `set_parsed_collision_mask_value(layer_number: int, value: bool) -> void`

Based on `value`, enables or disables the specified layer in the `parsed_collision_mask`, given a `layer_number` between 1 and 32.

### `set_vertices(vertices: PackedVector2Array) -> void`

Sets the vertices that can be then indexed to create polygons with the `add_polygon` method.

## 枚举

### `SamplePartitionType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SAMPLE_PARTITION_CONVEX_PARTITION` |  |
| `1` | `SAMPLE_PARTITION_TRIANGULATE` |  |
| `2` | `SAMPLE_PARTITION_MAX` |  |

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
- [Navigation Polygon 2D Demo](None)

