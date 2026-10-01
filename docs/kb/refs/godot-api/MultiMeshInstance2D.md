# MultiMeshInstance2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`MultiMeshInstance2D` → `Node2D` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core · keywords=batch
> 自动生成，勿手改。文件：`refs/godot-api/MultiMeshInstance2D.md`

**摘要**：Node that instances a `MultiMesh` in 2D.

## 描述

`MultiMeshInstance2D` is a specialized node to instance a `MultiMesh` resource in 2D. This can be faster to render compared to displaying many `Sprite2D` nodes with large transparent areas, especially if the nodes take up a lot of space on screen at high viewport resolutions. This is because using a mesh designed to fit the sprites' opaque areas will reduce GPU fill rate utilization (at the cost of increased vertex processing utilization).
		Usage is the same as `MultiMeshInstance3D`.

## 属性

- **`multimesh`** `MultiMesh`
  - 其它属性：getter=get_multimesh · setter=set_multimesh
- **`texture`** `Texture2D`
  - 其它属性：getter=get_texture · setter=set_texture

## 信号

### `texture_changed()`

Emitted when the `texture` is changed.

