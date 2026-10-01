# RenderSceneBuffers

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`RenderSceneBuffers` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/RenderSceneBuffers.md`

**摘要**：Abstract scene buffers object, created for each viewport for which 3D rendering is done.

## 描述

Abstract scene buffers object, created for each viewport for which 3D rendering is done. It manages any additional buffers used during rendering and will discard buffers when the viewport is resized. See also `RenderSceneBuffersRD`.
		**Note:** This is an internal rendering server object. Do not instantiate this class from a script.

## 方法

### `configure(config: RenderSceneBuffersConfiguration) -> void`

This method is called by the rendering server when the associated viewport's configuration is changed. It will discard the old buffers and recreate the internal buffers used.

