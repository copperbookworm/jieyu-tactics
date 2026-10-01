# EngineProfiler

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`EngineProfiler` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/EngineProfiler.md`

**摘要**：Base class for creating custom profilers.

## 描述

This class can be used to implement custom profilers that are able to interact with the engine and editor debugger.
		See `EngineDebugger` and `EditorDebuggerPlugin` for more information.

## 方法

### `_add_frame(data: Array) -> void`
- 限定：qualifiers=virtual

Called when data is added to profiler using `EngineDebugger.profiler_add_frame_data`.

### `_tick(frame_time: float, process_time: float, physics_time: float, physics_frame_time: float) -> void`
- 限定：qualifiers=virtual

Called once every engine iteration when the profiler is active with information about the current frame. All time values are in seconds. Lower values represent faster processing times and are therefore considered better.

### `_toggle(enable: bool, options: Array) -> void`
- 限定：qualifiers=virtual

Called when the profiler is enabled/disabled, along with a set of `options`.

