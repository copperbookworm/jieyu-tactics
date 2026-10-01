# OpenXRFutureExtension

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OpenXRFutureExtension` → `OpenXRExtensionWrapper` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/OpenXRFutureExtension.md`

**摘要**：The OpenXR Future extension allows for asynchronous APIs to be used.

## 描述

This is a support extension in OpenXR that allows other OpenXR extensions to start asynchronous functions and get a callback after this function finishes. It is not intended for consumption within GDScript but can be accessed from GDExtension.

## 方法

### `cancel_future(future: int) -> void`

Cancels an in-progress future. `future` must be an `XrFutureEXT` value previously returned by an API that started an asynchronous function.

### `is_active() -> bool`
- 限定：qualifiers=const

Returns `true` if futures are available in the OpenXR runtime used. This function will only return a usable result after OpenXR has been initialized.

### `register_future(future: int, on_success: Callable = Callable()) -> OpenXRFutureResult`

Register an OpenXR Future object so we monitor for completion. `future` must be an `XrFutureEXT` value previously returned by an API that started an asynchronous function.
				You can optionally specify `on_success`, it will be invoked on successful completion of the future.
				Or you can use the returned `OpenXRFutureResult` object to `await` its `OpenXRFutureResult.completed` signal.
				
```gdscript
				var future_result = OpenXRFutureExtension.register_future(future)
				await future_result.completed
				if future_result.get_status() == OpenXRFutureResult.RESULT_FINISHED:
					# Handle your success
					pass
				
```

