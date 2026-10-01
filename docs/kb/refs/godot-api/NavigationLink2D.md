# NavigationLink2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`NavigationLink2D` → `Node2D` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/NavigationLink2D.md`

**摘要**：A link between two positions on `NavigationRegion2D`s that agents can be routed through.

## 描述

A link between two positions on `NavigationRegion2D`s that agents can be routed through. These positions can be on the same `NavigationRegion2D` or on two different ones. Links are useful to express navigation methods other than traveling along the surface of the navigation polygon, such as ziplines, teleporters, or gaps that can be jumped across.

## 属性

- **`bidirectional`** `bool` = `true`
  - 其它属性：getter=is_bidirectional · setter=set_bidirectional
- **`enabled`** `bool` = `true`
  - 其它属性：getter=is_enabled · setter=set_enabled
- **`end_position`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_end_position · setter=set_end_position
- **`enter_cost`** `float` = `0.0`
  - 其它属性：getter=get_enter_cost · setter=set_enter_cost
- **`navigation_layers`** `int` = `1`
  - 其它属性：getter=get_navigation_layers · setter=set_navigation_layers
- **`start_position`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_start_position · setter=set_start_position
- **`travel_cost`** `float` = `1.0`
  - 其它属性：getter=get_travel_cost · setter=set_travel_cost

## 方法

### `get_global_end_position() -> Vector2`
- 限定：qualifiers=const

Returns the `end_position` that is relative to the link as a global position.

### `get_global_start_position() -> Vector2`
- 限定：qualifiers=const

Returns the `start_position` that is relative to the link as a global position.

### `get_navigation_layer_value(layer_number: int) -> bool`
- 限定：qualifiers=const

Returns whether or not the specified layer of the `navigation_layers` bitmask is enabled, given a `layer_number` between 1 and 32.

### `get_navigation_map() -> RID`
- 限定：qualifiers=const

Returns the current navigation map `RID` used by this link.

### `get_rid() -> RID`
- 限定：qualifiers=const

Returns the `RID` of this link on the `NavigationServer2D`.

### `set_global_end_position(position: Vector2) -> void`

Sets the `end_position` that is relative to the link from a global `position`.

### `set_global_start_position(position: Vector2) -> void`

Sets the `start_position` that is relative to the link from a global `position`.

### `set_navigation_layer_value(layer_number: int, value: bool) -> void`

Based on `value`, enables or disables the specified layer in the `navigation_layers` bitmask, given a `layer_number` between 1 and 32.

### `set_navigation_map(navigation_map: RID) -> void`

Sets the `RID` of the navigation map this link should use. By default the link will automatically join the `World2D` default navigation map so this function is only required to override the default map.

## 教程链接

- [Using NavigationLinks](None)

