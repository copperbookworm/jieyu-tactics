# OpenXRFutureResult

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OpenXRFutureResult` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/OpenXRFutureResult.md`

**摘要**：Result object tracking the asynchronous result of an OpenXR Future object.

## 描述

Result object tracking the asynchronous result of an OpenXR Future object, you can use this object to track the result status.

## 方法

### `cancel_future() -> void`

Cancel this future, this will interrupt and stop the asynchronous function.

### `get_future() -> int`
- 限定：qualifiers=const

Return the `XrFutureEXT` value this result relates to.

### `get_result_value() -> Variant`
- 限定：qualifiers=const

Returns the result value of our asynchronous function (if set by the extension). The type of this result value depends on the function being called. Consult the documentation of the relevant function.

### `get_status() -> int`
- 限定：qualifiers=const

Returns the status of this result.

### `set_result_value(result_value: Variant) -> void`

Stores the result value we expose to the user.
				**Note:** This method should only be called by an OpenXR extension that implements an asynchronous function.

## 信号

### `completed(result: OpenXRFutureResult)`

Emitted when the asynchronous function is finished or has been cancelled.

## 枚举

### `ResultStatus`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `RESULT_RUNNING` |  |
| `1` | `RESULT_FINISHED` |  |
| `2` | `RESULT_CANCELLED` |  |

