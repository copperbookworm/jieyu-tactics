# EngineDebugger

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`EngineDebugger` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/EngineDebugger.md`

**摘要**：Exposes the internal debugger.

## 描述

`EngineDebugger` handles the communication between the editor and the running game. It is active in the running game. Messages can be sent/received through it. It also manages the profilers.

## 方法

### `clear_breakpoints() -> void`

Clears all breakpoints.

### `debug(can_continue: bool = true, is_error_breakpoint: bool = false) -> void`

Starts a debug break in script execution, optionally specifying whether the program can continue based on `can_continue` and whether the break was due to a breakpoint.

### `get_depth() -> int`
- 限定：experimental= · qualifiers=const

Returns the current debug depth.

### `get_lines_left() -> int`
- 限定：experimental= · qualifiers=const

Returns the number of lines that remain.

### `has_capture(name: StringName) -> bool`

Returns `true` if a capture with the given name is present otherwise `false`.

### `has_profiler(name: StringName) -> bool`

Returns `true` if a profiler with the given name is present otherwise `false`.

### `insert_breakpoint(line: int, source: StringName) -> void`

Inserts a new breakpoint with the given `source` and `line`.

### `is_active() -> bool`

Returns `true` if the debugger is active otherwise `false`.

### `is_breakpoint(line: int, source: StringName) -> bool`
- 限定：qualifiers=const

Returns `true` if the given `source` and `line` represent an existing breakpoint.

### `is_profiling(name: StringName) -> bool`

Returns `true` if a profiler with the given name is present and active otherwise `false`.

### `is_skipping_breakpoints() -> bool`
- 限定：qualifiers=const

Returns `true` if the debugger is skipping breakpoints otherwise `false`.

### `line_poll() -> void`

Forces a processing loop of debugger events. The purpose of this method is just processing events every now and then when the script might get too busy, so that bugs like infinite loops can be caught.

### `profiler_add_frame_data(name: StringName, data: Array) -> void`

Calls the `add` callable of the profiler with given `name` and `data`.

### `profiler_enable(name: StringName, enable: bool, arguments: Array = []) -> void`

Calls the `toggle` callable of the profiler with given `name` and `arguments`. Enables/Disables the same profiler depending on `enable` argument.

### `register_message_capture(name: StringName, callable: Callable) -> void`

Registers a message capture with given `name`. If `name` is "my_message" then messages starting with "my_message:" will be called with the given callable.
				The callable must accept a message string and a data array as argument. The callable should return `true` if the message is recognized.
				**Note:** The callable will receive the message with the prefix stripped, unlike `EditorDebuggerPlugin._capture`. See the `EditorDebuggerPlugin` description for an example.

### `register_profiler(name: StringName, profiler: EngineProfiler) -> void`

Registers a profiler with the given `name`. See `EngineProfiler` for more information.

### `remove_breakpoint(line: int, source: StringName) -> void`

Removes a breakpoint with the given `source` and `line`.

### `script_debug(language: ScriptLanguage, can_continue: bool = true, is_error_breakpoint: bool = false) -> void`

Starts a debug break in script execution, optionally specifying whether the program can continue based on `can_continue` and whether the break was due to a breakpoint.

### `send_message(message: String, data: Array) -> void`

Sends a message with given `message` and `data` array.

### `set_depth(depth: int) -> void`
- 限定：experimental=

Sets the current debugging depth.

### `set_lines_left(lines: int) -> void`
- 限定：experimental=

Sets the current debugging lines that remain.

### `unregister_message_capture(name: StringName) -> void`

Unregisters the message capture with given `name`.

### `unregister_profiler(name: StringName) -> void`

Unregisters a profiler with given `name`.

