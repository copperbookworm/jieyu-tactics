# CSGPrimitive3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`CSGPrimitive3D` → `CSGShape3D` → `GeometryInstance3D` → `VisualInstance3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/CSGPrimitive3D.md`

**摘要**：Base class for CSG primitives.

## 描述

Parent class for various CSG primitives. It contains code and functionality that is common between them. It cannot be used directly. Instead use one of the various classes that inherit from it.
		**Note:** CSG nodes are intended to be used for level prototyping. Creating CSG nodes has a significant CPU cost compared to creating a `MeshInstance3D` with a `PrimitiveMesh`. Moving a CSG node within another CSG node also has a significant CPU cost, so it should be avoided during gameplay.

## 属性

- **`flip_faces`** `bool` = `false`
  - 其它属性：getter=get_flip_faces · setter=set_flip_faces

## 教程链接

- [Prototyping levels with CSG](None)

