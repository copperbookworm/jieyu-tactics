# MeshInstance2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`MeshInstance2D` → `Node2D` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/MeshInstance2D.md`

**摘要**：Node used for displaying a `Mesh` in 2D.

## 描述

Node used for displaying a `Mesh` in 2D. This can be faster to render compared to displaying a `Sprite2D` node with large transparent areas, especially if the node takes up a lot of space on screen at high viewport resolutions. This is because using a mesh designed to fit the sprite's opaque areas will reduce GPU fill rate utilization (at the cost of increased vertex processing utilization).
		When a `Mesh` has to be instantiated more than thousands of times close to each other, consider using a `MultiMesh` in a `MultiMeshInstance2D` instead.
		A `MeshInstance2D` can be created from an existing `Sprite2D` via a tool in the editor toolbar. Select the `Sprite2D` node, then choose **Sprite2D > Convert to MeshInstance2D** at the top of the 2D editor viewport.

## 属性

- **`mesh`** `Mesh`
  - 其它属性：getter=get_mesh · setter=set_mesh
- **`texture`** `Texture2D`
  - 其它属性：getter=get_texture · setter=set_texture

## 信号

### `texture_changed()`

Emitted when the `texture` is changed.

## 教程链接

- [2D meshes](None)

