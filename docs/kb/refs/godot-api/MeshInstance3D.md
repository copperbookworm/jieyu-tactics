# MeshInstance3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`MeshInstance3D` → `GeometryInstance3D` → `VisualInstance3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/MeshInstance3D.md`

**摘要**：Node that instances meshes into a scenario.

## 描述

MeshInstance3D is a node that takes a `Mesh` resource and adds it to the current scenario by creating an instance of it. This is the class most often used to render 3D geometry and can be used to instance a single `Mesh` in many places. This allows reusing geometry, which can save on resources. When a `Mesh` has to be instantiated more than thousands of times at close proximity, consider using a `MultiMesh` in a `MultiMeshInstance3D` instead.

## 属性

- **`mesh`** `Mesh`
  - 其它属性：getter=get_mesh · setter=set_mesh
- **`skeleton`** `NodePath` = `NodePath("")`
  - 其它属性：getter=get_skeleton_path · setter=set_skeleton_path
- **`skin`** `Skin`
  - 其它属性：getter=get_skin · setter=set_skin

## 方法

### `bake_mesh_from_current_blend_shape_mix(existing: ArrayMesh = null) -> ArrayMesh`

Takes a snapshot from the current `ArrayMesh` with all blend shapes applied according to their current weights and bakes it to the provided `existing` mesh. If no `existing` mesh is provided a new `ArrayMesh` is created, baked and returned. Mesh surface materials are not copied.
				**Performance:** `Mesh` data needs to be received from the GPU, stalling the `RenderingServer` in the process.

### `bake_mesh_from_current_skeleton_pose(existing: ArrayMesh = null) -> ArrayMesh`

Takes a snapshot of the current animated skeleton pose of the skinned mesh and bakes it to the provided `existing` mesh. If no `existing` mesh is provided a new `ArrayMesh` is created, baked, and returned. Requires a skeleton with a registered skin to work. Blendshapes are ignored. Mesh surface materials are not copied.
				**Performance:** `Mesh` data needs to be retrieved from the GPU, stalling the `RenderingServer` in the process.

### `create_convex_collision(clean: bool = true, simplify: bool = false) -> void`

This helper creates a `StaticBody3D` child node with a `ConvexPolygonShape3D` collision shape calculated from the mesh geometry. It's mainly used for testing.
				If `clean` is `true` (default), duplicate and interior vertices are removed automatically. You can set it to `false` to make the process faster if not needed.
				If `simplify` is `true`, the geometry can be further simplified to reduce the number of vertices. Disabled by default.

### `create_debug_tangents() -> void`

This helper creates a `MeshInstance3D` child node with gizmos at every vertex calculated from the mesh geometry. It's mainly used for testing.

### `create_multiple_convex_collisions(settings: MeshConvexDecompositionSettings = null) -> void`

This helper creates a `StaticBody3D` child node with multiple `ConvexPolygonShape3D` collision shapes calculated from the mesh geometry via convex decomposition. The convex decomposition operation can be controlled with parameters from the optional `settings`.

### `create_trimesh_collision() -> void`

This helper creates a `StaticBody3D` child node with a `ConcavePolygonShape3D` collision shape calculated from the mesh geometry. It's mainly used for testing.

### `find_blend_shape_by_name(name: StringName) -> int`

Returns the index of the blend shape with the given `name`. Returns `-1` if no blend shape with this name exists, including when `mesh` is `null`.

### `get_active_material(surface: int) -> Material`
- 限定：qualifiers=const

Returns the `Material` that will be used by the `Mesh` when drawing. This can return the `GeometryInstance3D.material_override`, the surface override `Material` defined in this `MeshInstance3D`, or the surface `Material` defined in the `mesh`. For example, if `GeometryInstance3D.material_override` is used, all surfaces will return the override material.
				Returns `null` if no material is active, including when `mesh` is `null`.

### `get_blend_shape_count() -> int`
- 限定：qualifiers=const

Returns the number of blend shapes available. Produces an error if `mesh` is `null`.

### `get_blend_shape_value(blend_shape_idx: int) -> float`
- 限定：qualifiers=const

Returns the value of the blend shape at the given `blend_shape_idx`. Returns `0.0` and produces an error if `mesh` is `null` or doesn't have a blend shape at that index.

### `get_skin_reference() -> SkinReference`
- 限定：qualifiers=const

Returns the internal `SkinReference` containing the skeleton's `RID` attached to this RID. See also `Resource.get_rid`, `SkinReference.get_skeleton`, and `RenderingServer.instance_attach_skeleton`.

### `get_surface_override_material(surface: int) -> Material`
- 限定：qualifiers=const

Returns the override `Material` for the specified `surface` of the `Mesh` resource. See also `get_surface_override_material_count`.
				**Note:** This returns the `Material` associated to the `MeshInstance3D`'s Surface Material Override properties, not the material within the `Mesh` resource. To get the material within the `Mesh` resource, use `Mesh.surface_get_material` instead.

### `get_surface_override_material_count() -> int`
- 限定：qualifiers=const

Returns the number of surface override materials. This is equivalent to `Mesh.get_surface_count`. See also `get_surface_override_material`.

### `set_blend_shape_value(blend_shape_idx: int, value: float) -> void`

Sets the value of the blend shape at `blend_shape_idx` to `value`. Produces an error if `mesh` is `null` or doesn't have a blend shape at that index.

### `set_surface_override_material(surface: int, material: Material) -> void`

Sets the override `material` for the specified `surface` of the `Mesh` resource. This material is associated with this `MeshInstance3D` rather than with `mesh`.
				**Note:** This assigns the `Material` associated to the `MeshInstance3D`'s Surface Material Override properties, not the material within the `Mesh` resource. To set the material within the `Mesh` resource, use `Mesh.surface_set_material` instead.

## 教程链接

- [3D Material Testers Demo](None)
- [3D Kinematic Character Demo](None)
- [3D Platformer Demo](None)
- [Third Person Shooter (TPS) Demo](None)

