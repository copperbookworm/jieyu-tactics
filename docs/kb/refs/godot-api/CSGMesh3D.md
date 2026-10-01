# CSGMesh3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`CSGMesh3D` → `CSGPrimitive3D` → `CSGShape3D` → `GeometryInstance3D` → `VisualInstance3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/CSGMesh3D.md`

**摘要**：A CSG Mesh shape that uses a mesh resource.

## 描述

This CSG node allows you to use any mesh resource as a CSG shape, provided it is *manifold*. A manifold shape is closed, does not self-intersect, does not contain internal faces and has no edges that connect to more than two faces. See also `CSGPolygon3D` for drawing 2D extruded polygons to be used as CSG nodes.
		**Note:** CSG nodes are intended to be used for level prototyping. Creating CSG nodes has a significant CPU cost compared to creating a `MeshInstance3D` with a `PrimitiveMesh`. Moving a CSG node within another CSG node also has a significant CPU cost, so it should be avoided during gameplay.

## 属性

- **`material`** `Material`
  - 其它属性：getter=get_material · setter=set_material
- **`mesh`** `Mesh`
  - 其它属性：getter=get_mesh · setter=set_mesh

## 教程链接

- [Prototyping levels with CSG](None)

