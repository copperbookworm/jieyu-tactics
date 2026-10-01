# RenderData

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`RenderData` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/RenderData.md`

**摘要**：Abstract render data object, holds frame data related to rendering a single frame of a viewport.

## 描述

Abstract render data object, exists for the duration of rendering a single viewport. See also `RenderDataRD`, `RenderSceneData`, and `RenderSceneDataRD`.
		**Note:** This is an internal rendering server object. Do not instantiate this class from a script.

## 方法

### `get_camera_attributes() -> RID`
- 限定：qualifiers=const

Returns the `RID` of the camera attributes object in the `RenderingServer` being used to render this viewport.

### `get_environment() -> RID`
- 限定：qualifiers=const

Returns the `RID` of the environment object in the `RenderingServer` being used to render this viewport.

### `get_render_scene_buffers() -> RenderSceneBuffers`
- 限定：qualifiers=const

Returns the `RenderSceneBuffers` object managing the scene buffers for rendering this viewport.

### `get_render_scene_data() -> RenderSceneData`
- 限定：qualifiers=const

Returns the `RenderSceneData` object managing this frames scene data.

