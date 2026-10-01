# Mesh

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Mesh` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Mesh.md`

**摘要**：A `Resource` that contains vertex array-based geometry.

## 描述

Mesh is a type of `Resource` that contains vertex array-based geometry, divided in *surfaces*. Each surface contains a completely separate array and a material used to draw it. Design wise, a mesh with multiple surfaces is preferred to a single surface, because objects created in 3D editing software commonly contain multiple materials. The maximum number of surfaces per mesh is `RenderingServer.MAX_MESH_SURFACES`.

## 属性

- **`lightmap_size_hint`** `Vector2i` = `Vector2i(0, 0)`
  - 其它属性：getter=get_lightmap_size_hint · setter=set_lightmap_size_hint

## 方法

### `_get_aabb() -> AABB`
- 限定：qualifiers=virtual required const

Virtual method to override the `AABB` for a custom class extending `Mesh`.

### `_get_blend_shape_count() -> int`
- 限定：qualifiers=virtual required const

Virtual method to override the number of blend shapes for a custom class extending `Mesh`.

### `_get_blend_shape_name(index: int) -> StringName`
- 限定：qualifiers=virtual required const

Virtual method to override the retrieval of blend shape names for a custom class extending `Mesh`.

### `_get_surface_count() -> int`
- 限定：qualifiers=virtual required const

Virtual method to override the surface count for a custom class extending `Mesh`.

### `_set_blend_shape_name(index: int, name: StringName) -> void`
- 限定：qualifiers=virtual required

Virtual method to override the names of blend shapes for a custom class extending `Mesh`.

### `_surface_get_array_index_len(index: int) -> int`
- 限定：qualifiers=virtual required const

Virtual method to override the surface array index length for a custom class extending `Mesh`.

### `_surface_get_array_len(index: int) -> int`
- 限定：qualifiers=virtual required const

Virtual method to override the surface array length for a custom class extending `Mesh`.

### `_surface_get_arrays(index: int) -> Array`
- 限定：qualifiers=virtual required const

Virtual method to override the surface arrays for a custom class extending `Mesh`.

### `_surface_get_blend_shape_arrays(index: int) -> Array[]`
- 限定：qualifiers=virtual required const

Virtual method to override the blend shape arrays for a custom class extending `Mesh`.

### `_surface_get_format(index: int) -> int`
- 限定：qualifiers=virtual required const

Virtual method to override the surface format for a custom class extending `Mesh`.

### `_surface_get_lods(index: int) -> Dictionary`
- 限定：qualifiers=virtual required const

Virtual method to override the surface LODs for a custom class extending `Mesh`.

### `_surface_get_material(index: int) -> Material`
- 限定：qualifiers=virtual required const

Virtual method to override the surface material for a custom class extending `Mesh`.

### `_surface_get_primitive_type(index: int) -> int`
- 限定：qualifiers=virtual required const

Virtual method to override the surface primitive type for a custom class extending `Mesh`.

### `_surface_set_material(index: int, material: Material) -> void`
- 限定：qualifiers=virtual required

Virtual method to override the setting of a `material` at the given `index` for a custom class extending `Mesh`.

### `create_convex_shape(clean: bool = true, simplify: bool = false) -> ConvexPolygonShape3D`
- 限定：qualifiers=const

Calculate a `ConvexPolygonShape3D` from the mesh.
				If `clean` is `true` (default), duplicate and interior vertices are removed automatically. You can set it to `false` to make the process faster if not needed.
				If `simplify` is `true`, the geometry can be further simplified to reduce the number of vertices. Disabled by default.

### `create_outline(margin: float) -> Mesh`
- 限定：qualifiers=const

Calculate an outline mesh at a defined offset (margin) from the original mesh.
				**Note:** This method typically returns the vertices in reverse order (e.g. clockwise to counterclockwise).

### `create_placeholder() -> Resource`
- 限定：qualifiers=const

Creates a placeholder version of this resource (`PlaceholderMesh`).

### `create_trimesh_shape() -> ConcavePolygonShape3D`
- 限定：qualifiers=const

Calculate a `ConcavePolygonShape3D` from the mesh.

### `generate_triangle_mesh() -> TriangleMesh`
- 限定：qualifiers=const

Generate a `TriangleMesh` from the mesh. Considers only surfaces using one of these primitive types: `PRIMITIVE_TRIANGLES`, `PRIMITIVE_TRIANGLE_STRIP`.

### `get_aabb() -> AABB`
- 限定：qualifiers=const

Returns the smallest `AABB` enclosing this mesh in local space. Not affected by `custom_aabb`.
				**Note:** This is only implemented for `ArrayMesh` and `PrimitiveMesh`.

### `get_faces() -> PackedVector3Array`
- 限定：qualifiers=const

Returns all the vertices that make up the faces of the mesh. Each three vertices represent one triangle.

### `get_surface_count() -> int`
- 限定：qualifiers=const

Returns the number of surfaces that the `Mesh` holds. This is equivalent to `MeshInstance3D.get_surface_override_material_count`.

### `surface_get_arrays(surf_idx: int) -> Array`
- 限定：qualifiers=const

Returns the arrays for the vertices, normals, UVs, etc. that make up the requested surface (see `ArrayMesh.add_surface_from_arrays`).

### `surface_get_blend_shape_arrays(surf_idx: int) -> Array[]`
- 限定：qualifiers=const

Returns the blend shape arrays for the requested surface.

### `surface_get_material(surf_idx: int) -> Material`
- 限定：qualifiers=const

Returns a `Material` in a given surface. Surface is rendered using this material.
				**Note:** This returns the material within the `Mesh` resource, not the `Material` associated to the `MeshInstance3D`'s Surface Material Override properties. To get the `Material` associated to the `MeshInstance3D`'s Surface Material Override properties, use `MeshInstance3D.get_surface_override_material` instead.

### `surface_set_material(surf_idx: int, material: Material) -> void`

Sets a `Material` for a given surface. Surface will be rendered using this material.
				**Note:** This assigns the material within the `Mesh` resource, not the `Material` associated to the `MeshInstance3D`'s Surface Material Override properties. To set the `Material` associated to the `MeshInstance3D`'s Surface Material Override properties, use `MeshInstance3D.set_surface_override_material` instead.

## 枚举

### `PrimitiveType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `PRIMITIVE_POINTS` |  |
| `1` | `PRIMITIVE_LINES` |  |
| `2` | `PRIMITIVE_LINE_STRIP` |  |
| `3` | `PRIMITIVE_TRIANGLES` |  |
| `4` | `PRIMITIVE_TRIANGLE_STRIP` |  |

### `ArrayType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ARRAY_VERTEX` |  |
| `1` | `ARRAY_NORMAL` |  |
| `2` | `ARRAY_TANGENT` |  |
| `3` | `ARRAY_COLOR` |  |
| `4` | `ARRAY_TEX_UV` |  |
| `5` | `ARRAY_TEX_UV2` |  |
| `6` | `ARRAY_CUSTOM0` |  |
| `7` | `ARRAY_CUSTOM1` |  |
| `8` | `ARRAY_CUSTOM2` |  |
| `9` | `ARRAY_CUSTOM3` |  |
| `10` | `ARRAY_BONES` |  |
| `11` | `ARRAY_WEIGHTS` |  |
| `12` | `ARRAY_INDEX` |  |
| `13` | `ARRAY_MAX` |  |

### `ArrayCustomFormat`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ARRAY_CUSTOM_RGBA8_UNORM` |  |
| `1` | `ARRAY_CUSTOM_RGBA8_SNORM` |  |
| `2` | `ARRAY_CUSTOM_RG_HALF` |  |
| `3` | `ARRAY_CUSTOM_RGBA_HALF` |  |
| `4` | `ARRAY_CUSTOM_R_FLOAT` |  |
| `5` | `ARRAY_CUSTOM_RG_FLOAT` |  |
| `6` | `ARRAY_CUSTOM_RGB_FLOAT` |  |
| `7` | `ARRAY_CUSTOM_RGBA_FLOAT` |  |
| `8` | `ARRAY_CUSTOM_MAX` |  |

### `ArrayFormat`

| 值 | 名称 | 说明 |
|---|---|---|
| `1` | `ARRAY_FORMAT_VERTEX` | （位标志） |
| `2` | `ARRAY_FORMAT_NORMAL` | （位标志） |
| `4` | `ARRAY_FORMAT_TANGENT` | （位标志） |
| `8` | `ARRAY_FORMAT_COLOR` | （位标志） |
| `16` | `ARRAY_FORMAT_TEX_UV` | （位标志） |
| `32` | `ARRAY_FORMAT_TEX_UV2` | （位标志） |
| `64` | `ARRAY_FORMAT_CUSTOM0` | （位标志） |
| `128` | `ARRAY_FORMAT_CUSTOM1` | （位标志） |
| `256` | `ARRAY_FORMAT_CUSTOM2` | （位标志） |
| `512` | `ARRAY_FORMAT_CUSTOM3` | （位标志） |
| `1024` | `ARRAY_FORMAT_BONES` | （位标志） |
| `2048` | `ARRAY_FORMAT_WEIGHTS` | （位标志） |
| `4096` | `ARRAY_FORMAT_INDEX` | （位标志） |
| `7` | `ARRAY_FORMAT_BLEND_SHAPE_MASK` | （位标志） |
| `13` | `ARRAY_FORMAT_CUSTOM_BASE` | （位标志） |
| `3` | `ARRAY_FORMAT_CUSTOM_BITS` | （位标志） |
| `13` | `ARRAY_FORMAT_CUSTOM0_SHIFT` | （位标志） |
| `16` | `ARRAY_FORMAT_CUSTOM1_SHIFT` | （位标志） |
| `19` | `ARRAY_FORMAT_CUSTOM2_SHIFT` | （位标志） |
| `22` | `ARRAY_FORMAT_CUSTOM3_SHIFT` | （位标志） |
| `7` | `ARRAY_FORMAT_CUSTOM_MASK` | （位标志） |
| `25` | `ARRAY_COMPRESS_FLAGS_BASE` | （位标志） |
| `33554432` | `ARRAY_FLAG_USE_2D_VERTICES` | （位标志） |
| `67108864` | `ARRAY_FLAG_USE_DYNAMIC_UPDATE` | （位标志） |
| `134217728` | `ARRAY_FLAG_USE_8_BONE_WEIGHTS` | （位标志） |
| `268435456` | `ARRAY_FLAG_USES_EMPTY_VERTEX_ARRAY` | （位标志） |
| `536870912` | `ARRAY_FLAG_COMPRESS_ATTRIBUTES` | （位标志） |

### `BlendShapeMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `BLEND_SHAPE_MODE_NORMALIZED` |  |
| `1` | `BLEND_SHAPE_MODE_RELATIVE` |  |

## 教程链接

- [3D Material Testers Demo](None)
- [3D Kinematic Character Demo](None)
- [3D Platformer Demo](None)
- [Third Person Shooter (TPS) Demo](None)

