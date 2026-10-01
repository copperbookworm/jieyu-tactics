# Performance

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Performance` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Performance.md`

**摘要**：Exposes performance-related data.

## 描述

This class provides access to a number of different monitors related to performance, such as memory usage, draw calls, and FPS. These are the same as the values displayed in the **Monitor** tab in the editor's **Debugger** panel. By using the `get_monitor` method of this class, you can access this data from your code.
		You can add custom monitors using the `add_custom_monitor` method. Custom monitors are available in **Monitor** tab in the editor's **Debugger** panel together with built-in monitors.
		**Note:** Some of the built-in monitors are only available in debug mode and will always return `0` when used in a project exported in release mode.
		**Note:** Some of the built-in monitors are not updated in real-time for performance reasons, so there may be a delay of up to 1 second between changes.
		**Note:** Custom monitors do not support negative values. Negative values are clamped to 0.

## 方法

### `add_custom_monitor(id: StringName, callable: Callable, arguments: Array = [], type: int = 0) -> void`

Adds a custom monitor with the name `id`. You can specify the category of the monitor using slash delimiters in `id` (for example: `"Game/NumberOfNPCs"`). If there is more than one slash delimiter, then the default category is used. The default category is `"Custom"`. Prints an error if given `id` is already present.
				`codeblocks`
				`gdscript`
				func _ready():
					var monitor_value = Callable(self, "get_monitor_value")

					# Adds monitor with name "MyName" to category "MyCategory".
					Performance.add_custom_monitor("MyCategory/MyMonitor", monitor_value)

					# Adds monitor with name "MyName" to category "Custom".
					# Note: "MyCategory/MyMonitor" and "MyMonitor" have same name but different IDs, so the code is valid.
					Performance.add_custom_monitor("MyMonitor", monitor_value)

					# Adds monitor with name "MyName" to category "Custom".
					# Note: "MyMonitor" and "Custom/MyMonitor" have same name and same category but different IDs, so the code is valid.
					Performance.add_custom_monitor("Custom/MyMonitor", monitor_value)

					# Adds monitor with name "MyCategoryOne/MyCategoryTwo/MyMonitor" to category "Custom".
					Performance.add_custom_monitor("MyCategoryOne/MyCategoryTwo/MyMonitor", monitor_value)

				func get_monitor_value():
					return randi() % 25
				
				`csharp`
				public override void _Ready()
				{
					var monitorValue = new Callable(this, MethodName.GetMonitorValue);

					// Adds monitor with name "MyName" to category "MyCategory".
					Performance.AddCustomMonitor("MyCategory/MyMonitor", monitorValue);
					// Adds monitor with name "MyName" to category "Custom".
					// Note: "MyCategory/MyMonitor" and "MyMonitor" have same name but different ids so the code is valid.
					Performance.AddCustomMonitor("MyMonitor", monitorValue);

					// Adds monitor with name "MyName" to category "Custom".
					// Note: "MyMonitor" and "Custom/MyMonitor" have same name and same category but different ids so the code is valid.
					Performance.AddCustomMonitor("Custom/MyMonitor", monitorValue);

					// Adds monitor with name "MyCategoryOne/MyCategoryTwo/MyMonitor" to category "Custom".
					Performance.AddCustomMonitor("MyCategoryOne/MyCategoryTwo/MyMonitor", monitorValue);
				}

				public int GetMonitorValue()
				{
					return GD.Randi() % 25;
				}
				
				
				The debugger calls the callable to get the value of custom monitor. The callable must return a zero or positive integer or floating-point number.
				Callables are called with arguments supplied in argument array.

### `get_custom_monitor(id: StringName) -> Variant`

Returns the value of custom monitor with given `id`. The callable is called to get the value of custom monitor. See also `has_custom_monitor`. Prints an error if the given `id` is absent.

### `get_custom_monitor_names() -> StringName[]`

Returns the names of active custom monitors in an `Array`.

### `get_custom_monitor_types() -> PackedInt32Array`

Returns the `MonitorType` values of active custom monitors in an `Array`.

### `get_monitor(monitor: int) -> float`
- 限定：qualifiers=const

Returns the value of one of the available built-in monitors. You should provide one of the `Monitor` constants as the argument, like this:
				`codeblocks`
				`gdscript`
				print(Performance.get_monitor(Performance.TIME_FPS)) # Prints the FPS to the console.
				
				`csharp`
				GD.Print(Performance.GetMonitor(Performance.Monitor.TimeFps)); // Prints the FPS to the console.
				
				
				See `get_custom_monitor` to query custom performance monitors' values.

### `get_monitor_modification_time() -> int`

Returns the last tick in which custom monitor was added/removed (in microseconds since the engine started). This is set to `Time.get_ticks_usec` when the monitor is updated.

### `has_custom_monitor(id: StringName) -> bool`

Returns `true` if custom monitor with the given `id` is present, `false` otherwise.

### `remove_custom_monitor(id: StringName) -> void`

Removes the custom monitor with given `id`. Prints an error if the given `id` is already absent.

## 枚举

### `Monitor`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `TIME_FPS` |  |
| `1` | `TIME_PROCESS` |  |
| `2` | `TIME_PHYSICS_PROCESS` |  |
| `3` | `TIME_NAVIGATION_PROCESS` |  |
| `4` | `MEMORY_STATIC` |  |
| `5` | `MEMORY_STATIC_MAX` |  |
| `6` | `MEMORY_MESSAGE_BUFFER_MAX` |  |
| `7` | `OBJECT_COUNT` |  |
| `8` | `OBJECT_RESOURCE_COUNT` |  |
| `9` | `OBJECT_NODE_COUNT` |  |
| `10` | `OBJECT_ORPHAN_NODE_COUNT` |  |
| `11` | `RENDER_TOTAL_OBJECTS_IN_FRAME` |  |
| `12` | `RENDER_TOTAL_PRIMITIVES_IN_FRAME` |  |
| `13` | `RENDER_TOTAL_DRAW_CALLS_IN_FRAME` |  |
| `14` | `RENDER_VIDEO_MEM_USED` |  |
| `15` | `RENDER_TEXTURE_MEM_USED` |  |
| `16` | `RENDER_BUFFER_MEM_USED` |  |
| `17` | `PHYSICS_2D_ACTIVE_OBJECTS` |  |
| `18` | `PHYSICS_2D_COLLISION_PAIRS` |  |
| `19` | `PHYSICS_2D_ISLAND_COUNT` |  |
| `20` | `PHYSICS_3D_ACTIVE_OBJECTS` |  |
| `21` | `PHYSICS_3D_COLLISION_PAIRS` |  |
| `22` | `PHYSICS_3D_ISLAND_COUNT` |  |
| `23` | `AUDIO_OUTPUT_LATENCY` |  |
| `24` | `NAVIGATION_ACTIVE_MAPS` |  |
| `25` | `NAVIGATION_REGION_COUNT` |  |
| `26` | `NAVIGATION_AGENT_COUNT` |  |
| `27` | `NAVIGATION_LINK_COUNT` |  |
| `28` | `NAVIGATION_POLYGON_COUNT` |  |
| `29` | `NAVIGATION_EDGE_COUNT` |  |
| `30` | `NAVIGATION_EDGE_MERGE_COUNT` |  |
| `31` | `NAVIGATION_EDGE_CONNECTION_COUNT` |  |
| `32` | `NAVIGATION_EDGE_FREE_COUNT` |  |
| `33` | `NAVIGATION_OBSTACLE_COUNT` |  |
| `34` | `PIPELINE_COMPILATIONS_CANVAS` |  |
| `35` | `PIPELINE_COMPILATIONS_MESH` |  |
| `36` | `PIPELINE_COMPILATIONS_SURFACE` |  |
| `37` | `PIPELINE_COMPILATIONS_DRAW` |  |
| `38` | `PIPELINE_COMPILATIONS_SPECIALIZATION` |  |
| `39` | `NAVIGATION_2D_ACTIVE_MAPS` |  |
| `40` | `NAVIGATION_2D_REGION_COUNT` |  |
| `41` | `NAVIGATION_2D_AGENT_COUNT` |  |
| `42` | `NAVIGATION_2D_LINK_COUNT` |  |
| `43` | `NAVIGATION_2D_POLYGON_COUNT` |  |
| `44` | `NAVIGATION_2D_EDGE_COUNT` |  |
| `45` | `NAVIGATION_2D_EDGE_MERGE_COUNT` |  |
| `46` | `NAVIGATION_2D_EDGE_CONNECTION_COUNT` |  |
| `47` | `NAVIGATION_2D_EDGE_FREE_COUNT` |  |
| `48` | `NAVIGATION_2D_OBSTACLE_COUNT` |  |
| `49` | `NAVIGATION_3D_ACTIVE_MAPS` |  |
| `50` | `NAVIGATION_3D_REGION_COUNT` |  |
| `51` | `NAVIGATION_3D_AGENT_COUNT` |  |
| `52` | `NAVIGATION_3D_LINK_COUNT` |  |
| `53` | `NAVIGATION_3D_POLYGON_COUNT` |  |
| `54` | `NAVIGATION_3D_EDGE_COUNT` |  |
| `55` | `NAVIGATION_3D_EDGE_MERGE_COUNT` |  |
| `56` | `NAVIGATION_3D_EDGE_CONNECTION_COUNT` |  |
| `57` | `NAVIGATION_3D_EDGE_FREE_COUNT` |  |
| `58` | `NAVIGATION_3D_OBSTACLE_COUNT` |  |
| `59` | `MONITOR_MAX` |  |

### `MonitorType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `MONITOR_TYPE_QUANTITY` |  |
| `1` | `MONITOR_TYPE_MEMORY` |  |
| `2` | `MONITOR_TYPE_TIME` |  |
| `3` | `MONITOR_TYPE_PERCENTAGE` |  |

