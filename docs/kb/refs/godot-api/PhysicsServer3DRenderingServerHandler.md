# PhysicsServer3DRenderingServerHandler

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`PhysicsServer3DRenderingServerHandler` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/PhysicsServer3DRenderingServerHandler.md`

**摘要**：A class used to provide `PhysicsServer3DExtension._soft_body_update_rendering_server` with a rendering handler for soft bodies.

## 方法

### `_set_aabb(aabb: AABB) -> void`
- 限定：qualifiers=virtual required

Called by the `PhysicsServer3D` to set the bounding box for the `SoftBody3D`.

### `_set_normal(vertex_id: int, normal: Vector3) -> void`
- 限定：qualifiers=virtual required

Called by the `PhysicsServer3D` to set the normal for the `SoftBody3D` vertex at the index specified by `vertex_id`.
				**Note:** The `normal` parameter used to be of type `const void*` prior to Godot 4.2.

### `_set_vertex(vertex_id: int, vertex: Vector3) -> void`
- 限定：qualifiers=virtual required

Called by the `PhysicsServer3D` to set the position for the `SoftBody3D` vertex at the index specified by `vertex_id`.
				**Note:** The `vertex` parameter used to be of type `const void*` prior to Godot 4.2.

### `set_aabb(aabb: AABB) -> void`

Sets the bounding box for the `SoftBody3D`.

### `set_normal(vertex_id: int, normal: Vector3) -> void`

Sets the normal for the `SoftBody3D` vertex at the index specified by `vertex_id`.

### `set_vertex(vertex_id: int, vertex: Vector3) -> void`

Sets the position for the `SoftBody3D` vertex at the index specified by `vertex_id`.

