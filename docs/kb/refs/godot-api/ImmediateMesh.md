# ImmediateMesh

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ImmediateMesh` → `Mesh` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/ImmediateMesh.md`

**摘要**：Mesh optimized for creating geometry manually.

## 描述

A mesh type optimized for creating geometry manually, similar to OpenGL 1.x immediate mode.
		Here's a sample on how to generate a triangular face:
		`codeblocks`
		`gdscript`
		var mesh = ImmediateMesh.new()
		mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLES)
		mesh.surface_add_vertex(Vector3.LEFT)
		mesh.surface_add_vertex(Vector3.FORWARD)
		mesh.surface_add_vertex(Vector3.ZERO)
		mesh.surface_end()
		
		`csharp`
		var mesh = new ImmediateMesh();
		mesh.SurfaceBegin(Mesh.PrimitiveType.Triangles);
		mesh.SurfaceAddVertex(Vector3.Left);
		mesh.SurfaceAddVertex(Vector3.Forward);
		mesh.SurfaceAddVertex(Vector3.Zero);
		mesh.SurfaceEnd();
		
		
		**Note:** Generating complex geometries with `ImmediateMesh` is highly inefficient. Instead, it is designed to generate simple geometry that changes often.

## 方法

### `clear_surfaces() -> void`

Clear all surfaces.

### `surface_add_vertex(vertex: Vector3) -> void`

Add a 3D vertex using the current attributes previously set.

### `surface_add_vertex_2d(vertex: Vector2) -> void`

Add a 2D vertex using the current attributes previously set.

### `surface_begin(primitive: int, material: Material = null) -> void`

Begin a new surface.

### `surface_end() -> void`

End and commit current surface. Note that surface being created will not be visible until this function is called.

### `surface_set_color(color: Color) -> void`

Set the color attribute that will be pushed with the next vertex.

### `surface_set_normal(normal: Vector3) -> void`

Set the normal attribute that will be pushed with the next vertex.

### `surface_set_tangent(tangent: Plane) -> void`

Set the tangent attribute that will be pushed with the next vertex.
				**Note:** Even though `tangent` is a `Plane`, it does not directly represent the tangent plane. Its `Plane.x`, `Plane.y`, and `Plane.z` represent the tangent vector and `Plane.d` should be either `-1` or `1`. See also `Mesh.ARRAY_TANGENT`.

### `surface_set_uv(uv: Vector2) -> void`

Set the UV attribute that will be pushed with the next vertex.

### `surface_set_uv2(uv2: Vector2) -> void`

Set the UV2 attribute that will be pushed with the next vertex.

## 教程链接

- [Using ImmediateMesh](None)

