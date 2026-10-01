# OpenXRFrameSynthesisExtension

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OpenXRFrameSynthesisExtension` → `OpenXRExtensionWrapper` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/OpenXRFrameSynthesisExtension.md`

**摘要**：The OpenXR Frame synthesis extension allows for advanced reprojection at low(er) framerates.

## 描述

This class implements the OpenXR Frame synthesis extension (https://registry.khronos.org/OpenXR/specs/1.1/html/xrspec.html#XR_EXT_frame_synthesis). When enabled in the project settings and supported by the XR runtime in use, frame synthesis uses advanced reprojection techniques to inject additional frames so that your XR experience hits the full frame rate of the device.

## 属性

- **`enabled`** `bool` = `false`
  - 其它属性：getter=is_enabled · setter=set_enabled
- **`relax_frame_interval`** `bool` = `false`
  - 其它属性：getter=get_relax_frame_interval · setter=set_relax_frame_interval

## 方法

### `is_available() -> bool`
- 限定：qualifiers=const

Returns `true` if frame synthesis is enabled in the project settings and the current XR runtime supports frame synthesis. The value returned will only be valid once OpenXR has been initialized.

### `skip_next_frame() -> void`

Queues the next frame to be skipped when supplying motion vector and depth data. Call this after teleporting your player or a similar action has moved the player to prevent incorrect reprojection results due to this movement.

