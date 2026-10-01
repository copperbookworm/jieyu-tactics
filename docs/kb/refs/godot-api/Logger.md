# Logger

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Logger` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Logger.md`

**摘要**：Custom logger to receive messages from the internal error/warning stream.

## 描述

Custom logger to receive messages from the internal error/warning stream. Loggers are registered via `OS.add_logger`.

## 方法

### `_log_error(function: String, file: String, line: int, code: String, rationale: String, editor_notify: bool, error_type: int, script_backtraces: ScriptBacktrace[]) -> void`
- 限定：qualifiers=virtual

Called when an error is logged. The error provides the `function`, `file`, and `line` that it originated from, as well as either the `code` that generated the error or a `rationale`.
				The type of error provided by `error_type` is described in the `ErrorType` enumeration.
				Additionally, `script_backtraces` provides backtraces for each of the script languages. These will only contain stack frames in editor builds and debug builds by default. To enable them for release builds as well, you need to enable `ProjectSettings.debug/settings/gdscript/always_track_call_stacks`.
				**Warning:** This method will be called from threads other than the main thread, possibly at the same time, so you will need to have some kind of thread-safety in your implementation of it, like a `Mutex`.
				**Note:** `script_backtraces` will not contain any captured variables, due to its prohibitively high cost. To get those, you will need to capture the backtraces yourself, from within the `Logger` virtual methods, using `Engine.capture_script_backtraces`.
				**Note:** Logging errors from this method using functions like `@GlobalScope.push_error` or `@GlobalScope.push_warning` is not supported, as it could cause infinite recursion. These errors will only show up in the console output.

### `_log_message(message: String, error: bool) -> void`
- 限定：qualifiers=virtual

Called when a message is logged. If `error` is `true`, then this message was meant to be sent to `stderr`.
				**Warning:** This method will be called from threads other than the main thread, possibly at the same time, so you will need to have some kind of thread-safety in your implementation of it, like a `Mutex`.
				**Note:** Logging another message from this method using functions like `@GlobalScope.print` is not supported, as it could cause infinite recursion. These messages will only show up in the console output.

## 枚举

### `ErrorType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ERROR_TYPE_ERROR` |  |
| `1` | `ERROR_TYPE_WARNING` |  |
| `2` | `ERROR_TYPE_SCRIPT` |  |
| `3` | `ERROR_TYPE_SHADER` |  |

## 教程链接

- [Logging](None)

