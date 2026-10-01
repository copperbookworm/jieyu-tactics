# RenderSceneData

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`RenderSceneData` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/RenderSceneData.md`

**摘要**：Abstract render data object, holds scene data related to rendering a single frame of a viewport.

## 描述

Abstract scene data object, exists for the duration of rendering a single viewport. See also `RenderSceneDataRD`, `RenderData`, and `RenderDataRD`.
		**Note:** This is an internal rendering server object. Do not instantiate this class from a script.

## 方法

### `get_cam_projection() -> Projection`
- 限定：qualifiers=const

Returns the camera projection used to render this frame.
				**Note:** If more than one view is rendered, this will return a combined projection.

### `get_cam_transform() -> Transform3D`
- 限定：qualifiers=const

Returns the camera transform used to render this frame.
				**Note:** If more than one view is rendered, this will return a centered transform.

### `get_uniform_buffer() -> RID`
- 限定：qualifiers=const

Return the `RID` of the uniform buffer containing the scene data as a UBO.

### `get_view_count() -> int`
- 限定：qualifiers=const

Returns the number of views being rendered.

### `get_view_eye_offset(view: int) -> Vector3`
- 限定：qualifiers=const

Returns the eye offset per view used to render this frame. This is the offset between our camera transform and the eye transform.

### `get_view_projection(view: int) -> Projection`
- 限定：qualifiers=const

Returns the view projection per view used to render this frame.
				**Note:** If a single view is rendered, this returns the camera projection. If more than one view is rendered, this will return a projection for the given view including the eye offset.

