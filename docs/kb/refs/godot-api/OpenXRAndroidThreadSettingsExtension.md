# OpenXRAndroidThreadSettingsExtension

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OpenXRAndroidThreadSettingsExtension` → `OpenXRExtensionWrapper` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/OpenXRAndroidThreadSettingsExtension.md`

**摘要**：Wraps the XR_KHR_android_thread_settings (https://registry.khronos.org/OpenXR/specs/1.1/html/xrspec.html#XR_KHR_android_thread_settings) extension.

## 描述

For XR to be comfortable, it is important for applications to deliver frames quickly and consistently. In order to make sure the important application threads get their full share of time, these threads must be identified to the system, which will adjust their scheduling priority accordingly.

## 方法

### `set_application_thread_type(thread_type: int, thread_id: int = 0) -> bool`

Sets the thread type of the given thread, so that the XR runtime can adjust its scheduling priority accordingly.
				`thread_id` refers to the OS thread id (ie from `gettid()`). When `thread_id` is `0`, it will set the thread type of the current thread.
				**NOTE:** The id returned by `Thread.get_id` is incompatible with `thread_id`.

## 枚举

### `ThreadType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `THREAD_TYPE_APPLICATION_MAIN` |  |
| `1` | `THREAD_TYPE_APPLICATION_WORKER` |  |
| `2` | `THREAD_TYPE_RENDERER_MAIN` |  |
| `3` | `THREAD_TYPE_RENDERER_WORKER` |  |

