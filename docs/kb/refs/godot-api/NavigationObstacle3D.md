# NavigationObstacle3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`NavigationObstacle3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/NavigationObstacle3D.md`

**摘要**：3D obstacle used to affect navigation mesh baking or constrain velocities of avoidance controlled agents.

## 描述

An obstacle needs a navigation map and outline `vertices` defined to work correctly. The outlines can not cross or overlap and are restricted to a plane projection. This means the y-axis of the vertices is ignored, instead the obstacle's global y-axis position is used for placement. The projected shape is extruded by the obstacles height along the y-axis.
		Obstacles can be included in the navigation mesh baking process when `affect_navigation_mesh` is enabled. They do not add walkable geometry, instead their role is to discard other source geometry inside the shape. This can be used to prevent navigation mesh from appearing in unwanted places, e.g. inside "solid" geometry or on top of it. If `carve_navigation_mesh` is enabled the baked shape will not be affected by offsets of the navigation mesh baking, e.g. the agent radius.
		With `avoidance_enabled` the obstacle can constrain the avoidance velocities of avoidance using agents. If the obstacle's vertices are wound in clockwise order, avoidance agents will be pushed in by the obstacle, otherwise, avoidance agents will be pushed out. Obstacles using vertices and avoidance can warp to a new position but should not be moved every single frame as each change requires a rebuild of the avoidance map.

## 属性

- **`affect_navigation_mesh`** `bool` = `false`
  - 其它属性：getter=get_affect_navigation_mesh · setter=set_affect_navigation_mesh
- **`avoidance_enabled`** `bool` = `true`
  - 其它属性：getter=get_avoidance_enabled · setter=set_avoidance_enabled
- **`avoidance_layers`** `int` = `1`
  - 其它属性：getter=get_avoidance_layers · setter=set_avoidance_layers
- **`carve_navigation_mesh`** `bool` = `false`
  - 其它属性：getter=get_carve_navigation_mesh · setter=set_carve_navigation_mesh
- **`height`** `float` = `1.0`
  - 其它属性：getter=get_height · setter=set_height
- **`radius`** `float` = `0.0`
  - 其它属性：getter=get_radius · setter=set_radius
- **`use_3d_avoidance`** `bool` = `false`
  - 其它属性：getter=get_use_3d_avoidance · setter=set_use_3d_avoidance
- **`velocity`** `Vector3` = `Vector3(0, 0, 0)`
  - 其它属性：getter=get_velocity · setter=set_velocity
- **`vertices`** `PackedVector3Array` = `PackedVector3Array()`
  - 其它属性：getter=get_vertices · setter=set_vertices

## 方法

### `get_avoidance_layer_value(layer_number: int) -> bool`
- 限定：qualifiers=const

Returns whether or not the specified layer of the `avoidance_layers` bitmask is enabled, given a `layer_number` between 1 and 32.

### `get_navigation_map() -> RID`
- 限定：qualifiers=const

Returns the `RID` of the navigation map for this NavigationObstacle node. This function returns always the map set on the NavigationObstacle node and not the map of the abstract obstacle on the NavigationServer. If the obstacle map is changed directly with the NavigationServer API the NavigationObstacle node will not be aware of the map change. Use `set_navigation_map` to change the navigation map for the NavigationObstacle and also update the obstacle on the NavigationServer.

### `get_rid() -> RID`
- 限定：qualifiers=const

Returns the `RID` of this obstacle on the `NavigationServer3D`.

### `set_avoidance_layer_value(layer_number: int, value: bool) -> void`

Based on `value`, enables or disables the specified layer in the `avoidance_layers` bitmask, given a `layer_number` between 1 and 32.

### `set_navigation_map(navigation_map: RID) -> void`

Sets the `RID` of the navigation map this NavigationObstacle node should use and also updates the `obstacle` on the NavigationServer.

## 教程链接

- [Using NavigationObstacles](None)

