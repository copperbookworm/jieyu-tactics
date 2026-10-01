# RenderSceneDataExtension

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`RenderSceneDataExtension` → `RenderSceneData` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/RenderSceneDataExtension.md`

**摘要**：This class allows for a RenderSceneData implementation to be made in GDExtension.

## 描述

This class allows for a RenderSceneData implementation to be made in GDExtension.

## 方法

### `_get_cam_projection() -> Projection`
- 限定：qualifiers=virtual const

Implement this in GDExtension to return the camera `Projection`.

### `_get_cam_transform() -> Transform3D`
- 限定：qualifiers=virtual const

Implement this in GDExtension to return the camera `Transform3D`.

### `_get_uniform_buffer() -> RID`
- 限定：qualifiers=virtual const

Implement this in GDExtension to return the `RID` of the uniform buffer containing the scene data as a UBO.

### `_get_view_count() -> int`
- 限定：qualifiers=virtual const

Implement this in GDExtension to return the view count.

### `_get_view_eye_offset(view: int) -> Vector3`
- 限定：qualifiers=virtual const

Implement this in GDExtension to return the eye offset for the given `view`.

### `_get_view_projection(view: int) -> Projection`
- 限定：qualifiers=virtual const

Implement this in GDExtension to return the view `Projection` for the given `view`.

