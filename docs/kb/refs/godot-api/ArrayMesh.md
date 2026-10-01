# ArrayMesh

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ArrayMesh` → `Mesh` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/ArrayMesh.md`

**摘要**：`Mesh` type that provides utility for constructing a surface from arrays.

## 描述

The `ArrayMesh` is used to construct a `Mesh` by specifying the attributes as arrays.
		The most basic example is the creation of a single triangle:
		`codeblocks`
		`gdscript`
		var vertices = PackedVector3Array()
		vertices.push_back(Vector3(0, 1, 0))
		vertices.push_back(Vector3(1, 0, 0))
		vertices.push_back(Vector3(0, 0, 1))

		# Initialize the ArrayMesh.
		var arr_mesh = ArrayMesh.new()
		var arrays = []
		arrays.resize(Mesh.ARRAY_MAX)
		arrays`Mesh.ARRAY_VERTEX` = vertices

		# Create the Mesh.
		arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
		var m = MeshInstance3D.new()
		m.mesh = arr_mesh
		
		`csharp`
		Vector3[] vertices =
		[
			new Vector3(0, 1, 0),
			new Vector3(1, 0, 0),
			new Vector3(0, 0, 1),
		];

		// Initialize the ArrayMesh.
		var arrMesh = new ArrayMesh();
		Godot.Collections.Array arrays = [];
		arrays.Resize((int)Mesh.ArrayType.Max);
		arrays[(int)Mesh.ArrayType.Vertex] = vertices;

		// Create the Mesh.
		arrMesh.AddSurfaceFromArrays(Mesh.PrimitiveType.Triangles, arrays);
		var m = new MeshInstance3D();
		m.Mesh = arrMesh;
		
		
		The `MeshInstance3D` is ready to be added to the `SceneTree` to be shown.
		See also `ImmediateMesh`, `MeshDataTool` and `SurfaceTool` for procedural geometry generation.
		**Note:** Godot uses clockwise winding order (https://learnopengl.com/Advanced-OpenGL/Face-culling) for front faces of triangle primitive modes.

## 属性

- **`blend_shape_mode`** `int` = `1` · 枚举 `Mesh.BlendShapeMode`
  - 其它属性：getter=get_blend_shape_mode · setter=set_blend_shape_mode
- **`custom_aabb`** `AABB` = `AABB(0, 0, 0, 0, 0, 0)`
  - 其它属性：getter=get_custom_aabb · setter=set_custom_aabb
- **`shadow_mesh`** `ArrayMesh`
  - 其它属性：getter=get_shadow_mesh · setter=set_shadow_mesh

## 方法

### `add_blend_shape(name: StringName) -> void`

Adds name for a blend shape that will be added with `add_surface_from_arrays`. Must be called before surface is added.

### `add_surface_from_arrays(primitive: int, arrays: Array, blend_shapes: Array[] = [], lods: Dictionary = {}, flags: int = 0) -> void`

Creates a new surface. `Mesh.get_surface_count` will become the `surf_idx` for this new surface.
				Surfaces are created to be rendered using a `primitive`, which may be any of the values defined in `Mesh.PrimitiveType`.
				The `arrays` argument is an array of arrays. Each of the `Mesh.ARRAY_MAX` elements contains an array with some of the mesh data for this surface as described by the corresponding member of `Mesh.ArrayType` or `null` if it is not used by the surface. For example, `arrays[0]` is the array of vertices. That first vertex sub-array is always required; the others are optional. Adding an index array puts this surface into "index mode" where the vertex and other arrays become the sources of data and the index array defines the vertex order. All sub-arrays must have the same length as the vertex array (or be an exact multiple of the vertex array's length, when multiple elements of a sub-array correspond to a single vertex) or be empty, except for `Mesh.ARRAY_INDEX` if it is used.
				The `blend_shapes` argument is an array of vertex data for each blend shape. Each element is an array of the same structure as `arrays`, but `Mesh.ARRAY_VERTEX`, `Mesh.ARRAY_NORMAL`, and `Mesh.ARRAY_TANGENT` are set if and only if they are set in `arrays` and all other entries are `null`.
				The `lods` argument is a dictionary with `float` keys and `PackedInt32Array` values. Each entry in the dictionary represents an LOD level of the surface, where the value is the `Mesh.ARRAY_INDEX` array to use for the LOD level and the key is roughly proportional to the distance at which the LOD stats being used. I.e., increasing the key of an LOD also increases the distance that the objects has to be from the camera before the LOD is used.
				The `flags` argument is the bitwise OR of, as required: One value of `Mesh.ArrayCustomFormat` left shifted by `ARRAY_FORMAT_CUSTOMn_SHIFT` for each custom channel in use, `Mesh.ARRAY_FLAG_USE_DYNAMIC_UPDATE`, `Mesh.ARRAY_FLAG_USE_8_BONE_WEIGHTS`, or `Mesh.ARRAY_FLAG_USES_EMPTY_VERTEX_ARRAY`.
				**Note:** When using indices, it is recommended to only use points, lines, or triangles.

### `clear_blend_shapes() -> void`

Removes all blend shapes from this `ArrayMesh`.

### `clear_surfaces() -> void`

Removes all surfaces from this `ArrayMesh`.

### `get_blend_shape_count() -> int`
- 限定：qualifiers=const

Returns the number of blend shapes that the `ArrayMesh` holds.

### `get_blend_shape_name(index: int) -> StringName`
- 限定：qualifiers=const

Returns the name of the blend shape at this index.

### `lightmap_unwrap(transform: Transform3D, texel_size: float) -> int`

Performs a UV unwrap on the `ArrayMesh` to prepare the mesh for lightmapping.

### `regen_normal_maps() -> void`

Regenerates tangents for each of the `ArrayMesh`'s surfaces.

### `set_blend_shape_name(index: int, name: StringName) -> void`

Sets the name of the blend shape at this index.

### `surface_find_by_name(name: String) -> int`
- 限定：qualifiers=const

Returns the index of the first surface with this name held within this `ArrayMesh`. If none are found, -1 is returned.

### `surface_get_array_index_len(surf_idx: int) -> int`
- 限定：qualifiers=const

Returns the length in indices of the index array in the requested surface (see `add_surface_from_arrays`).

### `surface_get_array_len(surf_idx: int) -> int`
- 限定：qualifiers=const

Returns the length in vertices of the vertex array in the requested surface (see `add_surface_from_arrays`).

### `surface_get_format(surf_idx: int) -> int`
- 限定：qualifiers=const

Returns the format mask of the requested surface (see `add_surface_from_arrays`).

### `surface_get_name(surf_idx: int) -> String`
- 限定：qualifiers=const

Gets the name assigned to this surface.

### `surface_get_primitive_type(surf_idx: int) -> int`
- 限定：qualifiers=const

Returns the primitive type of the requested surface (see `add_surface_from_arrays`).

### `surface_remove(surf_idx: int) -> void`

Removes the surface at the given index from the Mesh, shifting surfaces with higher index down by one.

### `surface_set_name(surf_idx: int, name: String) -> void`

Sets a name for a given surface.

### `surface_update_attribute_region(surf_idx: int, offset: int, data: PackedByteArray) -> void`

Updates the attribute buffer of this mesh's surface with the given `data`. The expected data per attribute is 12 or 8 bytes (4 bytes per float, 2 floats per `Vector2`, and 3 floats per `Vector3`) depending on if the mesh is using `Vector3` or `Vector2` vertices. This value can be determined with `RenderingServer.mesh_surface_get_format_attribute_stride`.
				The starting point of the updates can be changed with `offset`. The value of `offset` should be a multiple of 12 bytes in most cases to align to each attribute.
				A `PackedVector3Array` of attribute locations can be converted into a `PackedByteArray` using `PackedVector3Array.to_byte_array` for use in `data`.

### `surface_update_skin_region(surf_idx: int, offset: int, data: PackedByteArray) -> void`

Updates the skin buffer of this mesh's surface with the given `data`. The expected data per skin is 12 or 8 bytes (4 bytes per float, 2 floats per `Vector2`, and 3 floats per `Vector3`) depending on if the mesh is using `Vector3` or `Vector2` vertices. This value can be determined with `RenderingServer.mesh_surface_get_format_skin_stride`.
				The starting point of the updates can be changed with `offset`. The value of `offset` should be a multiple of 12 bytes in most cases to align to each skin.
				A `PackedVector3Array` of skin locations can be converted into a `PackedByteArray` using `PackedVector3Array.to_byte_array` for use in `data`.

### `surface_update_vertex_region(surf_idx: int, offset: int, data: PackedByteArray) -> void`

Updates the vertex buffer of this mesh's surface with the given `data`. The expected data per vertex is 12 or 8 bytes (4 bytes per float, 2 floats per `Vector2`, and 3 floats per `Vector3`) depending on if the mesh is using `Vector3` or `Vector2` vertices. This value can be determined with `RenderingServer.mesh_surface_get_format_vertex_stride`.
				The starting point of the updates can be changed with `offset`. The value of `offset` should be a multiple of 12 bytes in most cases to align to each vertex.
				A `PackedVector3Array` of vertex locations can be converted into a `PackedByteArray` using `PackedVector3Array.to_byte_array` for use in `data`.

## 教程链接

- [Procedural geometry using the ArrayMesh](None)

