# PointMesh

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`PointMesh` → `PrimitiveMesh` → `Mesh` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/PointMesh.md`

**摘要**：Mesh with a single point primitive.

## 描述

A `PointMesh` is a primitive mesh composed of a single point. Instead of relying on triangles, points are rendered as a single rectangle on the screen with a constant size. They are intended to be used with particle systems, but can also be used as a cheap way to render billboarded sprites (for example in a point cloud).
		In order to be displayed, point meshes must be used with a material that has a point size. The point size can be accessed in a shader with the `POINT_SIZE` built-in, or in a `BaseMaterial3D` by setting the `BaseMaterial3D.use_point_size` and `BaseMaterial3D.point_size` properties.
		**Note:** When using point meshes, properties that normally affect vertices will be ignored, including `BaseMaterial3D.billboard_mode`, `BaseMaterial3D.grow`, and `BaseMaterial3D.cull_mode`.

