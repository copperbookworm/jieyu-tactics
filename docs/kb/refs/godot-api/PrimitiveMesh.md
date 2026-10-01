# PrimitiveMesh

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`PrimitiveMesh` → `Mesh` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/PrimitiveMesh.md`

**摘要**：Base class for all primitive meshes. Handles applying a `Material` to a primitive mesh.

## 描述

Base class for all primitive meshes. Handles applying a `Material` to a primitive mesh. Examples include `BoxMesh`, `CapsuleMesh`, `CylinderMesh`, `PlaneMesh`, `PrismMesh`, and `SphereMesh`.

## 属性

- **`add_uv2`** `bool` = `false`
  - 其它属性：getter=get_add_uv2 · setter=set_add_uv2
- **`custom_aabb`** `AABB` = `AABB(0, 0, 0, 0, 0, 0)`
  - 其它属性：getter=get_custom_aabb · setter=set_custom_aabb
- **`flip_faces`** `bool` = `false`
  - 其它属性：getter=get_flip_faces · setter=set_flip_faces
- **`material`** `Material`
  - 其它属性：getter=get_material · setter=set_material
- **`uv2_padding`** `float` = `2.0`
  - 其它属性：getter=get_uv2_padding · setter=set_uv2_padding

## 方法

### `_create_mesh_array() -> Array`
- 限定：qualifiers=virtual const

Override this method to customize how this primitive mesh should be generated. Should return an `Array` where each element is another Array of values required for the mesh (see the `Mesh.ArrayType` constants).

### `get_mesh_arrays() -> Array`
- 限定：qualifiers=const

Returns the mesh arrays used to make up the surface of this primitive mesh.
				**Example:** Pass the result to `ArrayMesh.add_surface_from_arrays` to create a new surface:
				`codeblocks`
				`gdscript`
				var c = CylinderMesh.new()
				var arr_mesh = ArrayMesh.new()
				arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, c.get_mesh_arrays())
				
				`csharp`
				var c = new CylinderMesh();
				var arrMesh = new ArrayMesh();
				arrMesh.AddSurfaceFromArrays(Mesh.PrimitiveType.Triangles, c.GetMeshArrays());

### `request_update() -> void`

Request an update of this primitive mesh based on its properties.

