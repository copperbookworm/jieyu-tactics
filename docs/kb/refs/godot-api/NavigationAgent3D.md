# NavigationAgent3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`NavigationAgent3D` → `Node` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/NavigationAgent3D.md`

**摘要**：A 3D agent used to pathfind to a position while avoiding obstacles.

## 描述

A 3D agent used to pathfind to a position while avoiding static and dynamic obstacles. The calculation can be used by the parent node to dynamically move it along the path. Requires navigation data to work correctly.
		Dynamic obstacles are avoided using RVO collision avoidance. Avoidance is computed before physics, so the pathfinding information can be used safely in the physics step.
		**Note:** After setting the `target_position` property, the `get_next_path_position` method must be used once every physics frame to update the internal path logic of the navigation agent. The vector position it returns should be used as the next movement position for the agent's parent node.
		**Note:** Several methods of this class, such as `get_next_path_position`, can trigger a new path calculation. Calling these in your callback to an agent's signal, such as `waypoint_reached`, can cause infinite recursion. It is recommended to call these methods in the physics step or, alternatively, delay their call until the end of the frame (see `Object.call_deferred` or `Object.CONNECT_DEFERRED`).

## 属性

- **`avoidance_enabled`** `bool` = `false`
  - 其它属性：getter=get_avoidance_enabled · setter=set_avoidance_enabled
- **`avoidance_layers`** `int` = `1`
  - 其它属性：getter=get_avoidance_layers · setter=set_avoidance_layers
- **`avoidance_mask`** `int` = `1`
  - 其它属性：getter=get_avoidance_mask · setter=set_avoidance_mask
- **`avoidance_priority`** `float` = `1.0`
  - 其它属性：getter=get_avoidance_priority · setter=set_avoidance_priority
- **`debug_enabled`** `bool` = `false`
  - 其它属性：getter=get_debug_enabled · setter=set_debug_enabled
- **`debug_path_custom_color`** `Color` = `Color(1, 1, 1, 1)`
  - 其它属性：getter=get_debug_path_custom_color · setter=set_debug_path_custom_color
- **`debug_path_custom_point_size`** `float` = `4.0`
  - 其它属性：getter=get_debug_path_custom_point_size · setter=set_debug_path_custom_point_size
- **`debug_use_custom`** `bool` = `false`
  - 其它属性：getter=get_debug_use_custom · setter=set_debug_use_custom
- **`height`** `float` = `1.0`
  - 其它属性：getter=get_height · setter=set_height
- **`keep_y_velocity`** `bool` = `true`
  - 其它属性：getter=get_keep_y_velocity · setter=set_keep_y_velocity
- **`max_neighbors`** `int` = `10`
  - 其它属性：getter=get_max_neighbors · setter=set_max_neighbors
- **`max_speed`** `float` = `10.0`
  - 其它属性：getter=get_max_speed · setter=set_max_speed
- **`navigation_layers`** `int` = `1`
  - 其它属性：getter=get_navigation_layers · setter=set_navigation_layers
- **`neighbor_distance`** `float` = `50.0`
  - 其它属性：getter=get_neighbor_distance · setter=set_neighbor_distance
- **`path_desired_distance`** `float` = `1.0`
  - 其它属性：getter=get_path_desired_distance · setter=set_path_desired_distance
- **`path_height_offset`** `float` = `0.0`
  - 其它属性：getter=get_path_height_offset · setter=set_path_height_offset
- **`path_max_distance`** `float` = `5.0`
  - 其它属性：getter=get_path_max_distance · setter=set_path_max_distance
- **`path_metadata_flags`** `int` = `7` · 枚举 `NavigationPathQueryParameters3D.PathMetadataFlags` · 位标志
  - 其它属性：getter=get_path_metadata_flags · is_bitfield=true · setter=set_path_metadata_flags
- **`path_postprocessing`** `int` = `0` · 枚举 `NavigationPathQueryParameters3D.PathPostProcessing`
  - 其它属性：getter=get_path_postprocessing · setter=set_path_postprocessing
- **`path_return_max_length`** `float` = `0.0`
  - 其它属性：getter=get_path_return_max_length · setter=set_path_return_max_length
- **`path_return_max_radius`** `float` = `0.0`
  - 其它属性：getter=get_path_return_max_radius · setter=set_path_return_max_radius
- **`path_search_max_distance`** `float` = `0.0`
  - 其它属性：getter=get_path_search_max_distance · setter=set_path_search_max_distance
- **`path_search_max_polygons`** `int` = `4096`
  - 其它属性：getter=get_path_search_max_polygons · setter=set_path_search_max_polygons
- **`pathfinding_algorithm`** `int` = `0` · 枚举 `NavigationPathQueryParameters3D.PathfindingAlgorithm`
  - 其它属性：getter=get_pathfinding_algorithm · setter=set_pathfinding_algorithm
- **`radius`** `float` = `0.5`
  - 其它属性：getter=get_radius · setter=set_radius
- **`simplify_epsilon`** `float` = `0.0`
  - 其它属性：getter=get_simplify_epsilon · setter=set_simplify_epsilon
- **`simplify_path`** `bool` = `false`
  - 其它属性：getter=get_simplify_path · setter=set_simplify_path
- **`target_desired_distance`** `float` = `1.0`
  - 其它属性：getter=get_target_desired_distance · setter=set_target_desired_distance
- **`target_position`** `Vector3` = `Vector3(0, 0, 0)`
  - 其它属性：getter=get_target_position · setter=set_target_position
- **`time_horizon_agents`** `float` = `1.0`
  - 其它属性：getter=get_time_horizon_agents · setter=set_time_horizon_agents
- **`time_horizon_obstacles`** `float` = `0.0`
  - 其它属性：getter=get_time_horizon_obstacles · setter=set_time_horizon_obstacles
- **`use_3d_avoidance`** `bool` = `false`
  - 其它属性：getter=get_use_3d_avoidance · setter=set_use_3d_avoidance
- **`velocity`** `Vector3` = `Vector3(0, 0, 0)`
  - 其它属性：getter=get_velocity · setter=set_velocity

## 方法

### `distance_to_target() -> float`
- 限定：qualifiers=const

Returns the distance to the target position, using the agent's global position. The user must set `target_position` in order for this to be accurate.

### `get_avoidance_layer_value(layer_number: int) -> bool`
- 限定：qualifiers=const

Returns whether or not the specified layer of the `avoidance_layers` bitmask is enabled, given a `layer_number` between 1 and 32.

### `get_avoidance_mask_value(mask_number: int) -> bool`
- 限定：qualifiers=const

Returns whether or not the specified mask of the `avoidance_mask` bitmask is enabled, given a `mask_number` between 1 and 32.

### `get_current_navigation_path() -> PackedVector3Array`
- 限定：qualifiers=const

Returns this agent's current path from start to finish in global coordinates. The path only updates when the target position is changed or the agent requires a repath. The path array is not intended to be used in direct path movement as the agent has its own internal path logic that would get corrupted by changing the path array manually. Use the intended `get_next_path_position` once every physics frame to receive the next path point for the agents movement as this function also updates the internal path logic.

### `get_current_navigation_path_index() -> int`
- 限定：qualifiers=const

Returns which index the agent is currently on in the navigation path's `PackedVector3Array`.

### `get_current_navigation_result() -> NavigationPathQueryResult3D`
- 限定：qualifiers=const

Returns the path query result for the path the agent is currently following.

### `get_final_position() -> Vector3`

Returns the reachable final position of the current navigation path in global coordinates. This position can change if the agent needs to update the navigation path which makes the agent emit the `path_changed` signal.

### `get_navigation_layer_value(layer_number: int) -> bool`
- 限定：qualifiers=const

Returns whether or not the specified layer of the `navigation_layers` bitmask is enabled, given a `layer_number` between 1 and 32.

### `get_navigation_map() -> RID`
- 限定：qualifiers=const

Returns the `RID` of the navigation map for this NavigationAgent node. This function returns always the map set on the NavigationAgent node and not the map of the abstract agent on the NavigationServer. If the agent map is changed directly with the NavigationServer API the NavigationAgent node will not be aware of the map change. Use `set_navigation_map` to change the navigation map for the NavigationAgent and also update the agent on the NavigationServer.

### `get_next_path_position() -> Vector3`

Returns the next position in global coordinates that can be moved to, making sure that there are no static objects in the way. If the agent does not have a navigation path, it will return the position of the agent's parent. The use of this function once every physics frame is required to update the internal path logic of the NavigationAgent.

### `get_path_length() -> float`
- 限定：qualifiers=const

Returns the length of the currently calculated path. The returned value is `0.0`, if the path is still calculating or no calculation has been requested yet.

### `get_rid() -> RID`
- 限定：qualifiers=const

Returns the `RID` of this agent on the `NavigationServer3D`.

### `is_navigation_finished() -> bool`

Returns `true` if the agent's navigation has finished. If the target is reachable, navigation ends when the target is reached. If the target is unreachable, navigation ends when the last waypoint of the path is reached.
				**Note:** While `true` prefer to stop calling update functions like `get_next_path_position`. This avoids jittering the standing agent due to calling repeated path updates.

### `is_target_reachable() -> bool`

Returns `true` if `get_final_position` is within `target_desired_distance` of the `target_position`.

### `is_target_reached() -> bool`
- 限定：qualifiers=const

Returns `true` if the agent reached the target, i.e. the agent moved within `target_desired_distance` of the `target_position`. It may not always be possible to reach the target but it should always be possible to reach the final position. See `get_final_position`.

### `set_avoidance_layer_value(layer_number: int, value: bool) -> void`

Based on `value`, enables or disables the specified layer in the `avoidance_layers` bitmask, given a `layer_number` between 1 and 32.

### `set_avoidance_mask_value(mask_number: int, value: bool) -> void`

Based on `value`, enables or disables the specified mask in the `avoidance_mask` bitmask, given a `mask_number` between 1 and 32.

### `set_navigation_layer_value(layer_number: int, value: bool) -> void`

Based on `value`, enables or disables the specified layer in the `navigation_layers` bitmask, given a `layer_number` between 1 and 32.

### `set_navigation_map(navigation_map: RID) -> void`

Sets the `RID` of the navigation map this NavigationAgent node should use and also updates the `agent` on the NavigationServer.

### `set_velocity_forced(velocity: Vector3) -> void`

Replaces the internal velocity in the collision avoidance simulation with `velocity`. When an agent is teleported to a new position this function should be used in the same frame. If called frequently this function can get agents stuck.

## 信号

### `link_reached(details: Dictionary)`

Signals that the agent reached a navigation link. Emitted when the agent moves within `path_desired_distance` of the next position of the path when that position is a navigation link.
				The details dictionary may contain the following keys depending on the value of `path_metadata_flags`:
				- `position`: The start position of the link that was reached.
				- `type`: Always `NavigationPathQueryResult3D.PATH_SEGMENT_TYPE_LINK`.
				- `rid`: The `RID` of the link.
				- `owner`: The object which manages the link (usually `NavigationLink3D`).
				- `link_entry_position`: If `owner` is available and the owner is a `NavigationLink3D`, it will contain the global position of the link's point the agent is entering.
				- `link_exit_position`: If `owner` is available and the owner is a `NavigationLink3D`, it will contain the global position of the link's point which the agent is exiting.

### `navigation_finished()`

Signals that the agent's navigation has finished. If the target is reachable, navigation ends when the target is reached. If the target is unreachable, navigation ends when the last waypoint of the path is reached. This signal is emitted only once per loaded path.
				This signal will be emitted just after `target_reached` when the target is reachable.

### `path_changed()`

Emitted when the agent had to update the loaded path:
				- because path was previously empty.
				- because navigation map has changed.
				- because agent pushed further away from the current path segment than the `path_max_distance`.

### `target_reached()`

Signals that the agent reached the target, i.e. the agent moved within `target_desired_distance` of the `target_position`. This signal is emitted only once per loaded path.
				This signal will be emitted just before `navigation_finished` when the target is reachable.
				It may not always be possible to reach the target but it should always be possible to reach the final position. See `get_final_position`.

### `velocity_computed(safe_velocity: Vector3)`

Notifies when the collision avoidance velocity is calculated. Emitted every update as long as `avoidance_enabled` is `true` and the agent has a navigation map.

### `waypoint_reached(details: Dictionary)`

Signals that the agent reached a waypoint. Emitted when the agent moves within `path_desired_distance` of the next position of the path.
				The details dictionary may contain the following keys depending on the value of `path_metadata_flags`:
				- `position`: The position of the waypoint that was reached.
				- `type`: The type of navigation primitive (region or link) that contains this waypoint.
				- `rid`: The `RID` of the containing navigation primitive (region or link).
				- `owner`: The object which manages the containing navigation primitive (region or link).

## 教程链接

- [Using NavigationAgents](None)

