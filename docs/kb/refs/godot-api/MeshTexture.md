# MeshTexture

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`MeshTexture` → `Texture2D` → `Texture` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/MeshTexture.md`

**摘要**：Simple texture that uses a mesh to draw itself.

## 描述

Simple texture that uses a mesh to draw itself. It's limited because flags can't be changed and region drawing is not supported.

## 属性

- **`base_texture`** `Texture2D`
  - 其它属性：getter=get_base_texture · setter=set_base_texture
- **`image_size`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_image_size · setter=set_image_size
- **`mesh`** `Mesh`
  - 其它属性：getter=get_mesh · setter=set_mesh
- **`resource_local_to_scene`** `bool` = `false`
  - 其它属性：getter=is_local_to_scene · overrides=Resource · setter=set_local_to_scene

