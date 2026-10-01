# NavigationRegion3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`NavigationRegion3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/NavigationRegion3D.md`

**摘要**：A traversable 3D region that `NavigationAgent3D`s can use for pathfinding.

## 描述

A traversable 3D region based on a `NavigationMesh` that `NavigationAgent3D`s can use for pathfinding.
		Two regions can be connected to each other if they share a similar edge. You can set the minimum distance between two vertices required to connect two edges by using `NavigationServer3D.map_set_edge_connection_margin`.
		**Note:** Overlapping two regions' navigation meshes is not enough for connecting two regions. They must share a similar edge.
		The cost of entering this region from another region can be controlled with the `enter_cost` value.
		**Note:** This value is not added to the path cost when the start position is already inside this region.
		The cost of traveling distances inside this region can be controlled with the `travel_cost` multiplier.
		**Note:** This node caches changes to its properties, so if you make changes to the underlying region `RID` in `NavigationServer3D`, they will not be reflected in this node's properties.

## 属性

- **`enabled`** `bool` = `true`
  - 其它属性：getter=is_enabled · setter=set_enabled
- **`enter_cost`** `float` = `0.0`
  - 其它属性：getter=get_enter_cost · setter=set_enter_cost
- **`navigation_layers`** `int` = `1`
  - 其它属性：getter=get_navigation_layers · setter=set_navigation_layers
- **`navigation_mesh`** `NavigationMesh`
  - 其它属性：getter=get_navigation_mesh · setter=set_navigation_mesh
- **`travel_cost`** `float` = `1.0`
  - 其它属性：getter=get_travel_cost · setter=set_travel_cost
- **`use_edge_connections`** `bool` = `true`
  - 其它属性：getter=get_use_edge_connections · setter=set_use_edge_connections

## 方法

### `bake_navigation_mesh(on_thread: bool = true) -> void`

Bakes the `NavigationMesh`. If `on_thread` is set to `true` (default), the baking is done on a separate thread. Baking on separate thread is useful because navigation baking is not a cheap operation. When it is completed, it automatically sets the new `NavigationMesh`. Please note that baking on separate thread may be very slow if geometry is parsed from meshes as async access to each mesh involves heavy synchronization. Also, please note that baking on a separate thread is automatically disabled on operating systems that cannot use threads (such as Web with threads disabled).

### `get_bounds() -> AABB`
- 限定：qualifiers=const

Returns the axis-aligned bounding box for the region's transformed navigation mesh.

### `get_navigation_layer_value(layer_number: int) -> bool`
- 限定：qualifiers=const

Returns whether or not the specified layer of the `navigation_layers` bitmask is enabled, given a `layer_number` between 1 and 32.

### `get_navigation_map() -> RID`
- 限定：qualifiers=const

Returns the current navigation map `RID` used by this region.

### `get_region_rid() -> RID`
- 限定：deprecated=Use [method get_rid] instead. · qualifiers=const

Returns the `RID` of this region on the `NavigationServer3D`.

### `get_rid() -> RID`
- 限定：qualifiers=const

Returns the `RID` of this region on the `NavigationServer3D`. Combined with `NavigationServer3D.map_get_closest_point_owner` can be used to identify the `NavigationRegion3D` closest to a point on the merged navigation map.

### `is_baking() -> bool`
- 限定：qualifiers=const

Returns `true` when the `NavigationMesh` is being baked on a background thread.

### `set_navigation_layer_value(layer_number: int, value: bool) -> void`

Based on `value`, enables or disables the specified layer in the `navigation_layers` bitmask, given a `layer_number` between 1 and 32.

### `set_navigation_map(navigation_map: RID) -> void`

Sets the `RID` of the navigation map this region should use. By default the region will automatically join the `World3D` default navigation map so this function is only required to override the default map.

## 信号

### `bake_finished()`

Notifies when the navigation mesh bake operation is completed.

### `navigation_mesh_changed()`

Notifies when the `NavigationMesh` has changed.

## 教程链接

- [Using NavigationRegions](None)

