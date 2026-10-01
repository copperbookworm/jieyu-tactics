# Texture2DRD

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Texture2DRD` → `Texture2D` → `Texture` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Texture2DRD.md`

**摘要**：Texture for 2D that is bound to a texture created on the `RenderingDevice`.

## 描述

This texture class allows you to use a 2D texture created directly on the `RenderingDevice` as a texture for materials, meshes, etc.
		**Note:** `Texture2DRD` is intended for low-level usage with `RenderingDevice`. For most use cases, use `Texture2D` instead.

## 属性

- **`resource_local_to_scene`** `bool` = `false`
  - 其它属性：getter=is_local_to_scene · overrides=Resource · setter=set_local_to_scene
- **`texture_rd_rid`** `RID`
  - 其它属性：getter=get_texture_rd_rid · setter=set_texture_rd_rid

## 教程链接

- [Compute Texture demo](None)

