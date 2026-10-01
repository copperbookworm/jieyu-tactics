# MeshDataTool

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`MeshDataTool` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/MeshDataTool.md`

**摘要**：Helper tool to access and edit `Mesh` data.

## 描述

MeshDataTool provides access to individual vertices in a `Mesh`. It allows users to read and edit vertex data of meshes. It also creates an array of faces and edges.
		To use MeshDataTool, load a mesh with `create_from_surface`. When you are finished editing the data commit the data to a mesh with `commit_to_surface`.
		Below is an example of how MeshDataTool may be used.
		`codeblocks`
		`gdscript`
		var mesh = ArrayMesh.new()
		mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, BoxMesh.new().get_mesh_arrays())
		var mdt = MeshDataTool.new()
		mdt.create_from_surface(mesh, 0)
		for i in range(mdt.get_vertex_count()):
			var vertex = mdt.get_vertex(i)
			# In this example we extend the mesh by one unit, which results in separated faces as it is flat shaded.
			vertex += mdt.get_vertex_normal(i)
			# Save your change.
			mdt.set_vertex(i, vertex)
		mesh.clear_surfaces()
		mdt.commit_to_surface(mesh)
		var mi = MeshInstance.new()
		mi.mesh = mesh
		add_child(mi)
		
		`csharp`
		var mesh = new ArrayMesh();
		mesh.AddSurfaceFromArrays(Mesh.PrimitiveType.Triangles, new BoxMesh().GetMeshArrays());
		var mdt = new MeshDataTool();
		mdt.CreateFromSurface(mesh, 0);
		for (var i = 0; i < mdt.GetVertexCount(); i++)
		{
			Vector3 vertex = mdt.GetVertex(i);
			// In this example we extend the mesh by one unit, which results in separated faces as it is flat shaded.
			vertex += mdt.GetVertexNormal(i);
			// Save your change.
			mdt.SetVertex(i, vertex);
		}
		mesh.ClearSurfaces();
		mdt.CommitToSurface(mesh);
		var mi = new MeshInstance();
		mi.Mesh = mesh;
		AddChild(mi);
		
		
		See also `ArrayMesh`, `ImmediateMesh` and `SurfaceTool` for procedural geometry generation.
		**Note:** Godot uses clockwise winding order (https://learnopengl.com/Advanced-OpenGL/Face-culling) for front faces of triangle primitive modes.

## 方法

### `clear() -> void`

Clears all data currently in MeshDataTool.

### `commit_to_surface(mesh: ArrayMesh, compression_flags: int = 0) -> int`

Adds a new surface to specified `Mesh` with edited data.

### `create_from_surface(mesh: ArrayMesh, surface: int) -> int`

Uses specified surface of given `Mesh` to populate data for MeshDataTool.
				Requires `Mesh` with primitive type `Mesh.PRIMITIVE_TRIANGLES`.

### `get_edge_count() -> int`
- 限定：qualifiers=const

Returns the number of edges in this `Mesh`.

### `get_edge_faces(idx: int) -> PackedInt32Array`
- 限定：qualifiers=const

Returns array of faces that touch given edge.

### `get_edge_meta(idx: int) -> Variant`
- 限定：qualifiers=const

Returns meta information assigned to given edge.

### `get_edge_vertex(idx: int, vertex: int) -> int`
- 限定：qualifiers=const

Returns the index of the specified `vertex` connected to the edge at index `idx`.
				`vertex` can only be `0` or `1`, as edges are composed of two vertices.

### `get_face_count() -> int`
- 限定：qualifiers=const

Returns the number of faces in this `Mesh`.

### `get_face_edge(idx: int, edge: int) -> int`
- 限定：qualifiers=const

Returns the edge associated with the face at index `idx`.
				`edge` argument must be either `0`, `1`, or `2` because a face only has three edges.

### `get_face_meta(idx: int) -> Variant`
- 限定：qualifiers=const

Returns the metadata associated with the given face.

### `get_face_normal(idx: int) -> Vector3`
- 限定：qualifiers=const

Calculates and returns the face normal of the given face.

### `get_face_vertex(idx: int, vertex: int) -> int`
- 限定：qualifiers=const

Returns the specified vertex index of the given face.
				`vertex` must be either `0`, `1`, or `2` because faces contain three vertices.
				`codeblocks`
				`gdscript`
				var index = mesh_data_tool.get_face_vertex(0, 1) # Gets the index of the second vertex of the first face.
				var position = mesh_data_tool.get_vertex(index)
				var normal = mesh_data_tool.get_vertex_normal(index)
				
				`csharp`
				int index = meshDataTool.GetFaceVertex(0, 1); // Gets the index of the second vertex of the first face.
				Vector3 position = meshDataTool.GetVertex(index);
				Vector3 normal = meshDataTool.GetVertexNormal(index);

### `get_format() -> int`
- 限定：qualifiers=const

Returns the `Mesh`'s format as a combination of the `Mesh.ArrayFormat` flags. For example, a mesh containing both vertices and normals would return a format of `3` because `Mesh.ARRAY_FORMAT_VERTEX` is `1` and `Mesh.ARRAY_FORMAT_NORMAL` is `2`.

### `get_material() -> Material`
- 限定：qualifiers=const

Returns the material assigned to the `Mesh`.

### `get_vertex(idx: int) -> Vector3`
- 限定：qualifiers=const

Returns the position of the given vertex.

### `get_vertex_bones(idx: int) -> PackedInt32Array`
- 限定：qualifiers=const

Returns the bones of the given vertex.

### `get_vertex_color(idx: int) -> Color`
- 限定：qualifiers=const

Returns the color of the given vertex.

### `get_vertex_count() -> int`
- 限定：qualifiers=const

Returns the total number of vertices in `Mesh`.

### `get_vertex_edges(idx: int) -> PackedInt32Array`
- 限定：qualifiers=const

Returns an array of edges that share the given vertex.

### `get_vertex_faces(idx: int) -> PackedInt32Array`
- 限定：qualifiers=const

Returns an array of faces that share the given vertex.

### `get_vertex_meta(idx: int) -> Variant`
- 限定：qualifiers=const

Returns the metadata associated with the given vertex.

### `get_vertex_normal(idx: int) -> Vector3`
- 限定：qualifiers=const

Returns the normal of the given vertex.

### `get_vertex_tangent(idx: int) -> Plane`
- 限定：qualifiers=const

Returns the tangent of the given vertex.

### `get_vertex_uv(idx: int) -> Vector2`
- 限定：qualifiers=const

Returns the UV of the given vertex.

### `get_vertex_uv2(idx: int) -> Vector2`
- 限定：qualifiers=const

Returns the UV2 of the given vertex.

### `get_vertex_weights(idx: int) -> PackedFloat32Array`
- 限定：qualifiers=const

Returns bone weights of the given vertex.

### `set_edge_meta(idx: int, meta: Variant) -> void`

Sets the metadata of the given edge.

### `set_face_meta(idx: int, meta: Variant) -> void`

Sets the metadata of the given face.

### `set_material(material: Material) -> void`

Sets the material to be used by newly-constructed `Mesh`.

### `set_vertex(idx: int, vertex: Vector3) -> void`

Sets the position of the given vertex.

### `set_vertex_bones(idx: int, bones: PackedInt32Array) -> void`

Sets the bones of the given vertex.

### `set_vertex_color(idx: int, color: Color) -> void`

Sets the color of the given vertex.

### `set_vertex_meta(idx: int, meta: Variant) -> void`

Sets the metadata associated with the given vertex.

### `set_vertex_normal(idx: int, normal: Vector3) -> void`

Sets the normal of the given vertex.

### `set_vertex_tangent(idx: int, tangent: Plane) -> void`

Sets the tangent of the given vertex.
				**Note:** Even though `tangent` is a `Plane`, it does not directly represent the tangent plane. Its `Plane.x`, `Plane.y`, and `Plane.z` represent the tangent vector and `Plane.d` should be either `-1` or `1`. See also `Mesh.ARRAY_TANGENT`.

### `set_vertex_uv(idx: int, uv: Vector2) -> void`

Sets the UV of the given vertex.

### `set_vertex_uv2(idx: int, uv2: Vector2) -> void`

Sets the UV2 of the given vertex.

### `set_vertex_weights(idx: int, weights: PackedFloat32Array) -> void`

Sets the bone weights of the given vertex.

## 教程链接

- [Using the MeshDataTool](None)

