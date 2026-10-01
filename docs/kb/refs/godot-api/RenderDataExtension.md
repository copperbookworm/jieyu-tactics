# RenderDataExtension

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`RenderDataExtension` → `RenderData` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/RenderDataExtension.md`

**摘要**：This class allows for a RenderData implementation to be made in GDExtension.

## 描述

This class allows for a RenderData implementation to be made in GDExtension.

## 方法

### `_get_camera_attributes() -> RID`
- 限定：qualifiers=virtual const

Implement this in GDExtension to return the `RID` for the implementation's camera attributes object.

### `_get_environment() -> RID`
- 限定：qualifiers=virtual const

Implement this in GDExtension to return the `RID` of the implementation's environment object.

### `_get_render_scene_buffers() -> RenderSceneBuffers`
- 限定：qualifiers=virtual const

Implement this in GDExtension to return the implementation's `RenderSceneBuffers` object.

### `_get_render_scene_data() -> RenderSceneData`
- 限定：qualifiers=virtual const

Implement this in GDExtension to return the implementation's `RenderSceneDataExtension` object.

