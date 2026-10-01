# CSGSphere3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`CSGSphere3D` → `CSGPrimitive3D` → `CSGShape3D` → `GeometryInstance3D` → `VisualInstance3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/CSGSphere3D.md`

**摘要**：A CSG Sphere shape.

## 描述

This node allows you to create a sphere for use with the CSG system.
		**Note:** CSG nodes are intended to be used for level prototyping. Creating CSG nodes has a significant CPU cost compared to creating a `MeshInstance3D` with a `PrimitiveMesh`. Moving a CSG node within another CSG node also has a significant CPU cost, so it should be avoided during gameplay.

## 属性

- **`material`** `Material`
  - 其它属性：getter=get_material · setter=set_material
- **`radial_segments`** `int` = `12`
  - 其它属性：getter=get_radial_segments · setter=set_radial_segments
- **`radius`** `float` = `0.5`
  - 其它属性：getter=get_radius · setter=set_radius
- **`rings`** `int` = `6`
  - 其它属性：getter=get_rings · setter=set_rings
- **`smooth_faces`** `bool` = `true`
  - 其它属性：getter=get_smooth_faces · setter=set_smooth_faces

## 教程链接

- [Prototyping levels with CSG](None)

