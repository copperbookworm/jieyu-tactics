# NavigationRegion2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`NavigationRegion2D` → `Node2D` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/NavigationRegion2D.md`

**摘要**：A traversable 2D region that `NavigationAgent2D`s can use for pathfinding.

## 描述

A traversable 2D region based on a `NavigationPolygon` that `NavigationAgent2D`s can use for pathfinding.
		Two regions can be connected to each other if they share a similar edge. You can set the minimum distance between two vertices required to connect two edges by using `NavigationServer2D.map_set_edge_connection_margin`.
		**Note:** Overlapping two regions' navigation polygons is not enough for connecting two regions. They must share a similar edge.
		The pathfinding cost of entering a region from another region can be controlled with the `enter_cost` value.
		**Note:** This value is not added to the path cost when the start position is already inside this region.
		The pathfinding cost of traveling distances inside this region can be controlled with the `travel_cost` multiplier.
		**Note:** This node caches changes to its properties, so if you make changes to the underlying region `RID` in `NavigationServer2D`, they will not be reflected in this node's properties.

## 属性

- **`enabled`** `bool` = `true`
  - 其它属性：getter=is_enabled · setter=set_enabled
- **`enter_cost`** `float` = `0.0`
  - 其它属性：getter=get_enter_cost · setter=set_enter_cost
- **`navigation_layers`** `int` = `1`
  - 其它属性：getter=get_navigation_layers · setter=set_navigation_layers
- **`navigation_polygon`** `NavigationPolygon`
  - 其它属性：getter=get_navigation_polygon · setter=set_navigation_polygon
- **`travel_cost`** `float` = `1.0`
  - 其它属性：getter=get_travel_cost · setter=set_travel_cost
- **`use_edge_connections`** `bool` = `true`
  - 其它属性：getter=get_use_edge_connections · setter=set_use_edge_connections

## 方法

### `bake_navigation_polygon(on_thread: bool = true) -> void`

Bakes the `NavigationPolygon`. If `on_thread` is set to `true` (default), the baking is done on a separate thread.

### `get_bounds() -> Rect2`
- 限定：qualifiers=const

Returns the axis-aligned rectangle for the region's transformed navigation mesh.

### `get_navigation_layer_value(layer_number: int) -> bool`
- 限定：qualifiers=const

Returns whether or not the specified layer of the `navigation_layers` bitmask is enabled, given a `layer_number` between 1 and 32.

### `get_navigation_map() -> RID`
- 限定：qualifiers=const

Returns the current navigation map `RID` used by this region.

### `get_region_rid() -> RID`
- 限定：deprecated=Use [method get_rid] instead. · qualifiers=const

Returns the `RID` of this region on the `NavigationServer2D`.

### `get_rid() -> RID`
- 限定：qualifiers=const

Returns the `RID` of this region on the `NavigationServer2D`. Combined with `NavigationServer2D.map_get_closest_point_owner` can be used to identify the `NavigationRegion2D` closest to a point on the merged navigation map.

### `is_baking() -> bool`
- 限定：qualifiers=const

Returns `true` when the `NavigationPolygon` is being baked on a background thread.

### `set_navigation_layer_value(layer_number: int, value: bool) -> void`

Based on `value`, enables or disables the specified layer in the `navigation_layers` bitmask, given a `layer_number` between 1 and 32.

### `set_navigation_map(navigation_map: RID) -> void`

Sets the `RID` of the navigation map this region should use. By default the region will automatically join the `World2D` default navigation map so this function is only required to override the default map.

## 信号

### `bake_finished()`

Emitted when a navigation polygon bake operation is completed.

### `navigation_polygon_changed()`

Emitted when the used navigation polygon is replaced or changes to the internals of the current navigation polygon are committed.

## 教程链接

- [Using NavigationRegions](None)

