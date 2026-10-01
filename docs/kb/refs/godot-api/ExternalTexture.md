# ExternalTexture

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ExternalTexture` → `Texture2D` → `Texture` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/ExternalTexture.md`

**摘要**：Texture which displays the content of an external buffer.

## 描述

Displays the content of an external buffer provided by the platform.
		Requires the OES_EGL_image_external (https://registry.khronos.org/OpenGL/extensions/OES/OES_EGL_image_external.txt) extension (OpenGL) or VK_ANDROID_external_memory_android_hardware_buffer (https://registry.khronos.org/vulkan/specs/1.1-extensions/html/vkspec.html#VK_ANDROID_external_memory_android_hardware_buffer) extension (Vulkan).
		**Note:** This is currently only supported in Android builds.

## 属性

- **`resource_local_to_scene`** `bool` = `false`
  - 其它属性：getter=is_local_to_scene · overrides=Resource · setter=set_local_to_scene
- **`size`** `Vector2` = `Vector2(256, 256)`
  - 其它属性：getter=get_size · setter=set_size

## 方法

### `get_external_texture_id() -> int`
- 限定：qualifiers=const

Returns the external texture ID.
				Depending on your use case, you may need to pass this to platform APIs, for example, when creating an `android.graphics.SurfaceTexture` on Android.

### `set_external_buffer_id(external_buffer_id: int) -> void`

Sets the external buffer ID.
				Depending on your use case, you may need to call this with data received from a platform API, for example, `SurfaceTexture.getHardwareBuffer()` on Android.

