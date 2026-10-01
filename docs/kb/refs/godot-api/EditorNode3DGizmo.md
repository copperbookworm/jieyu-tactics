# EditorNode3DGizmo

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`EditorNode3DGizmo` → `Node3DGizmo` → `RefCounted` → `Object`
> 附加属性：api_type=editor
> 自动生成，勿手改。文件：`refs/godot-api/EditorNode3DGizmo.md`

**摘要**：Gizmo for editing `Node3D` objects.

## 描述

Gizmo that is used for providing custom visualization and editing (handles and subgizmos) for `Node3D` objects. Can be overridden to create custom gizmos, but for simple gizmos creating an `EditorNode3DGizmoPlugin` is usually recommended.

## 方法

### `_begin_handle_action(id: int, secondary: bool) -> void`
- 限定：qualifiers=virtual

### `_commit_handle(id: int, secondary: bool, restore: Variant, cancel: bool) -> void`
- 限定：qualifiers=virtual

Override this method to commit a handle being edited (handles must have been previously added by `add_handles`). This usually means creating an `UndoRedo` action for the change, using the current handle value as "do" and the `restore` argument as "undo".
				If the `cancel` argument is `true`, the `restore` value should be directly set, without any `UndoRedo` action.
				The `secondary` argument is `true` when the committed handle is secondary (see `add_handles` for more information).

### `_commit_subgizmos(ids: PackedInt32Array, restores: Transform3D[], cancel: bool) -> void`
- 限定：qualifiers=virtual

Override this method to commit a group of subgizmos being edited (see `_subgizmos_intersect_ray` and `_subgizmos_intersect_frustum`). This usually means creating an `UndoRedo` action for the change, using the current transforms as "do" and the `restores` transforms as "undo".
				If the `cancel` argument is `true`, the `restores` transforms should be directly set, without any `UndoRedo` action.

### `_get_handle_name(id: int, secondary: bool) -> String`
- 限定：qualifiers=virtual const

Override this method to return the name of an edited handle (handles must have been previously added by `add_handles`). Handles can be named for reference to the user when editing.
				The `secondary` argument is `true` when the requested handle is secondary (see `add_handles` for more information).

### `_get_handle_value(id: int, secondary: bool) -> Variant`
- 限定：qualifiers=virtual const

Override this method to return the current value of a handle. This value will be requested at the start of an edit and used as the `restore` argument in `_commit_handle`.
				The `secondary` argument is `true` when the requested handle is secondary (see `add_handles` for more information).

### `_get_subgizmo_transform(id: int) -> Transform3D`
- 限定：qualifiers=virtual const

Override this method to return the current transform of a subgizmo. This transform will be requested at the start of an edit and used as the `restore` argument in `_commit_subgizmos`.

### `_is_handle_highlighted(id: int, secondary: bool) -> bool`
- 限定：qualifiers=virtual const

Override this method to return `true` whenever the given handle should be highlighted in the editor.
				The `secondary` argument is `true` when the requested handle is secondary (see `add_handles` for more information).

### `_redraw() -> void`
- 限定：qualifiers=virtual

Override this method to add all the gizmo elements whenever a gizmo update is requested. It's common to call `clear` at the beginning of this method and then add visual elements depending on the node's properties.

### `_set_handle(id: int, secondary: bool, camera: Camera3D, point: Vector2) -> void`
- 限定：qualifiers=virtual

Override this method to update the node properties when the user drags a gizmo handle (previously added with `add_handles`). The provided `point` is the mouse position in screen coordinates and the `camera` can be used to convert it to raycasts.
				The `secondary` argument is `true` when the edited handle is secondary (see `add_handles` for more information).

### `_set_subgizmo_transform(id: int, transform: Transform3D) -> void`
- 限定：qualifiers=virtual

Override this method to update the node properties during subgizmo editing (see `_subgizmos_intersect_ray` and `_subgizmos_intersect_frustum`). The `transform` is given in the `Node3D`'s local coordinate system.

### `_subgizmos_intersect_frustum(camera: Camera3D, frustum: Plane[]) -> PackedInt32Array`
- 限定：qualifiers=virtual const

Override this method to allow selecting subgizmos using mouse drag box selection. Given a `camera` and a `frustum`, this method should return which subgizmos are contained within the frustum. The `frustum` argument consists of an array with all the `Plane`s that make up the selection frustum. The returned value should contain a list of unique subgizmo identifiers, which can have any non-negative value and will be used in other virtual methods like `_get_subgizmo_transform` or `_commit_subgizmos`.

### `_subgizmos_intersect_ray(camera: Camera3D, point: Vector2) -> int`
- 限定：qualifiers=virtual const

Override this method to allow selecting subgizmos using mouse clicks. Given a `camera` and a `point` in screen coordinates, this method should return which subgizmo should be selected. The returned value should be a unique subgizmo identifier, which can have any non-negative value and will be used in other virtual methods like `_get_subgizmo_transform` or `_commit_subgizmos`.

### `add_collision_segments(segments: PackedVector3Array) -> void`

Adds the specified `segments` to the gizmo's collision shape for picking. Call this method during `_redraw`.

### `add_collision_triangles(triangles: TriangleMesh) -> void`

Adds collision triangles to the gizmo for picking. A `TriangleMesh` can be generated from a regular `Mesh` too. Call this method during `_redraw`.

### `add_handles(handles: PackedVector3Array, material: Material, ids: PackedInt32Array, billboard: bool = false, secondary: bool = false) -> void`

Adds a list of handles (points) which can be used to edit the properties of the gizmo's `Node3D`. The `ids` argument can be used to specify a custom identifier for each handle, if an empty array is passed, the ids will be assigned automatically from the `handles` argument order.
				The `secondary` argument marks the added handles as secondary, meaning they will normally have lower selection priority than regular handles. When the user is holding the shift key secondary handles will switch to have higher priority than regular handles. This change in priority can be used to place multiple handles at the same point while still giving the user control on their selection.
				There are virtual methods which will be called upon editing of these handles. Call this method during `_redraw`.

### `add_lines(lines: PackedVector3Array, material: Material, billboard: bool = false, modulate: Color = Color(1, 1, 1, 1)) -> void`

Adds lines to the gizmo (as sets of 2 points), with a given material. The lines are used for visualizing the gizmo. Call this method during `_redraw`.

### `add_mesh(mesh: Mesh, material: Material = null, transform: Transform3D = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0), skeleton: SkinReference = null) -> void`

Adds a mesh to the gizmo with the specified `material`, local `transform` and `skeleton`. Call this method during `_redraw`.

### `add_unscaled_billboard(material: Material, default_scale: float = 1, modulate: Color = Color(1, 1, 1, 1)) -> void`

Adds an unscaled billboard for visualization and selection. Call this method during `_redraw`.

### `clear() -> void`

Removes everything in the gizmo including meshes, collisions and handles.

### `get_node_3d() -> Node3D`
- 限定：qualifiers=const

Returns the `Node3D` node associated with this gizmo.

### `get_plugin() -> EditorNode3DGizmoPlugin`
- 限定：qualifiers=const

Returns the `EditorNode3DGizmoPlugin` that owns this gizmo. It's useful to retrieve materials using `EditorNode3DGizmoPlugin.get_material`.

### `get_subgizmo_selection() -> PackedInt32Array`
- 限定：qualifiers=const

Returns a list of the currently selected subgizmos. Can be used to highlight selected elements during `_redraw`.

### `is_subgizmo_selected(id: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the given subgizmo is currently selected. Can be used to highlight selected elements during `_redraw`.

### `set_hidden(hidden: bool) -> void`

Sets the gizmo's hidden state. If `true`, the gizmo will be hidden. If `false`, it will be shown.

### `set_node_3d(node: Node) -> void`

Sets the reference `Node3D` node for the gizmo. `node` must inherit from `Node3D`.

