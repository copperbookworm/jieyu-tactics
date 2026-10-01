# Node3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Node3D` → `Node` → `Object`
> 附加属性：api_type=core · keywords=spatial
> 自动生成，勿手改。文件：`refs/godot-api/Node3D.md`

**摘要**：Base object in 3D space, inherited by all 3D nodes.

## 描述

The `Node3D` node is the base representation of a node in 3D space. All other 3D nodes inherit from this class.
		Affine operations (translation, rotation, scale) are calculated in the coordinate system relative to the parent, unless the `Node3D`'s `top_level` is `true`. In this coordinate system, affine operations correspond to direct affine operations on the `Node3D`'s `transform`. The term *parent space* refers to this coordinate system. The coordinate system that is attached to the `Node3D` itself is referred to as object-local coordinate system, or *local space*.
		**Note:** Unless otherwise specified, all methods that need angle parameters must receive angles in *radians*. To convert degrees to radians, use `@GlobalScope.deg_to_rad`.
		**Note:** In Godot 3 and older, `Node3D` was named *Spatial*.

## 属性

- **`basis`** `Basis`
  - 其它属性：getter=get_basis · setter=set_basis
- **`global_basis`** `Basis`
  - 其它属性：getter=get_global_basis · setter=set_global_basis
- **`global_position`** `Vector3`
  - 其它属性：getter=get_global_position · keywords=global_translation · setter=set_global_position
- **`global_rotation`** `Vector3`
  - 其它属性：getter=get_global_rotation · setter=set_global_rotation
- **`global_rotation_degrees`** `Vector3`
  - 其它属性：getter=get_global_rotation_degrees · setter=set_global_rotation_degrees
- **`global_transform`** `Transform3D`
  - 其它属性：getter=get_global_transform · setter=set_global_transform
- **`position`** `Vector3` = `Vector3(0, 0, 0)`
  - 其它属性：getter=get_position · keywords=translation · setter=set_position
- **`quaternion`** `Quaternion`
  - 其它属性：getter=get_quaternion · setter=set_quaternion
- **`rotation`** `Vector3` = `Vector3(0, 0, 0)`
  - 其它属性：getter=get_rotation · setter=set_rotation
- **`rotation_degrees`** `Vector3`
  - 其它属性：getter=get_rotation_degrees · setter=set_rotation_degrees
- **`rotation_edit_mode`** `int` = `0` · 枚举 `Node3D.RotationEditMode`
  - 其它属性：getter=get_rotation_edit_mode · setter=set_rotation_edit_mode
- **`rotation_order`** `int` = `2` · 枚举 `EulerOrder`
  - 其它属性：getter=get_rotation_order · setter=set_rotation_order
- **`scale`** `Vector3` = `Vector3(1, 1, 1)`
  - 其它属性：getter=get_scale · setter=set_scale
- **`top_level`** `bool` = `false`
  - 其它属性：getter=is_set_as_top_level · setter=set_as_top_level
- **`transform`** `Transform3D` = `Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0)`
  - 其它属性：getter=get_transform · setter=set_transform
- **`visibility_parent`** `NodePath` = `NodePath("")`
  - 其它属性：getter=get_visibility_parent · setter=set_visibility_parent
- **`visible`** `bool` = `true`
  - 其它属性：getter=is_visible · setter=set_visible

## 方法

### `add_gizmo(gizmo: Node3DGizmo) -> void`

Attaches the given `gizmo` to this node. Only works in the editor.
				**Note:** `gizmo` should be an `EditorNode3DGizmo`. The argument type is `Node3DGizmo` to avoid depending on editor classes in `Node3D`.

### `clear_gizmos() -> void`

Clears all `EditorNode3DGizmo` objects attached to this node. Only works in the editor.

### `clear_subgizmo_selection() -> void`

Deselects all subgizmos for this node. Useful to call when the selected subgizmo may no longer exist after a property change. Only works in the editor.

### `force_update_transform() -> void`

Forces the node's `global_transform` to update, by sending `NOTIFICATION_TRANSFORM_CHANGED`. Fails if the node is not inside the tree.
				**Note:** For performance reasons, transform changes are usually accumulated and applied *once* at the end of the frame. The update propagates through `Node3D` children, as well. Therefore, use this method only when you need an up-to-date transform (such as during physics operations).

### `get_gizmos() -> Node3DGizmo[]`
- 限定：qualifiers=const

Returns all the `EditorNode3DGizmo` objects attached to this node. Only works in the editor.

### `get_global_transform_interpolated() -> Transform3D`

When using physics interpolation, there will be circumstances in which you want to know the interpolated (displayed) transform of a node rather than the standard transform (which may only be accurate to the most recent physics tick).
				This is particularly important for frame-based operations that take place in `Node._process`, rather than `Node._physics_process`. Examples include `Camera3D`s focusing on a node, or finding where to fire lasers from on a frame rather than physics tick.
				**Note:** This function creates an interpolation pump on the `Node3D` the first time it is called, which can respond to physics interpolation resets. If you get problems with "streaking" when initially following a `Node3D`, be sure to call `get_global_transform_interpolated` at least once *before* resetting the `Node3D` physics interpolation.

### `get_parent_node_3d() -> Node3D`
- 限定：qualifiers=const

Returns the parent `Node3D` that directly affects this node's `global_transform`. Returns `null` if no parent exists, the parent is not a `Node3D`, or `top_level` is `true`.
				**Note:** This method is not always equivalent to `Node.get_parent`, which does not take `top_level` into account.

### `get_world_3d() -> World3D`
- 限定：qualifiers=const

Returns the `World3D` this node is registered to.
				Usually, this is the same as the world used by this node's viewport (see `Node.get_viewport` and `Viewport.find_world_3d`).

### `global_rotate(axis: Vector3, angle: float) -> void`

Rotates this node's `global_basis` around the global `axis` by the given `angle`, in radians. This operation is calculated in global space (relative to the world) and preserves the `global_position`.

### `global_scale(scale: Vector3) -> void`

Scales this node's `global_basis` by the given `scale` factor. This operation is calculated in global space (relative to the world) and preserves the `global_position`.
				**Note:** This method is not to be confused with the `scale` property.

### `global_translate(offset: Vector3) -> void`

Adds the given translation `offset` to the node's `global_position` in global space (relative to the world).

### `hide() -> void`

Prevents this node from being rendered. Equivalent to setting `visible` to `false`. This is the opposite of `show`.

### `is_local_transform_notification_enabled() -> bool`
- 限定：qualifiers=const

Returns `true` if the node receives `NOTIFICATION_LOCAL_TRANSFORM_CHANGED` whenever `transform` changes. This is enabled with `set_notify_local_transform`.

### `is_scale_disabled() -> bool`
- 限定：qualifiers=const

Returns `true` if this node's `global_transform` is automatically orthonormalized. This results in this node not appearing distorted, as if its global scale were set to `Vector3.ONE` (or its negative counterpart). See also `set_disable_scale` and `orthonormalize`.
				**Note:** `transform` is not affected by this setting.

### `is_transform_notification_enabled() -> bool`
- 限定：qualifiers=const

Returns `true` if the node receives `NOTIFICATION_TRANSFORM_CHANGED` whenever `global_transform` changes. This is enabled with `set_notify_transform`.

### `is_visible_in_tree() -> bool`
- 限定：qualifiers=const

Returns `true` if this node is inside the scene tree and the `visible` property is `true` for this node and all of its `Node3D` ancestors *in sequence*. An ancestor of any other type (such as `Node` or `Node2D`) breaks the sequence. See also `Node.get_parent`.
				**Note:** This method cannot take `VisualInstance3D.layers` into account, so even if this method returns `true`, the node may not be rendered.

### `look_at(target: Vector3, up: Vector3 = Vector3(0, 1, 0), use_model_front: bool = false) -> void`

Rotates the node so that the local forward axis (-Z, `Vector3.FORWARD`) points toward the `target` position. This operation is calculated in global space (relative to the world).
				The local up axis (+Y) points as close to the `up` vector as possible while staying perpendicular to the local forward axis. The resulting transform is orthogonal, and the scale is preserved. Non-uniform scaling may not work correctly.
				The `target` position cannot be the same as the node's position, the `up` vector cannot be `Vector3.ZERO`. Furthermore, the direction from the node's position to the `target` position cannot be parallel to the `up` vector, to avoid an unintended rotation around the local Z axis.
				If `use_model_front` is `true`, the +Z axis (asset front) is treated as forward (implies +X is left) and points toward the `target` position. By default, the -Z axis (camera forward) is treated as forward (implies +X is right).
				**Note:** This method fails if the node is not in the scene tree. If necessary, use `look_at_from_position` instead.

### `look_at_from_position(position: Vector3, target: Vector3, up: Vector3 = Vector3(0, 1, 0), use_model_front: bool = false) -> void`

Moves the node to the specified `position`, then rotates the node to point toward the `target` position, similar to `look_at`. This operation is calculated in global space (relative to the world).

### `orthonormalize() -> void`

Orthonormalizes this node's `basis`. This method sets this node's `scale` to `Vector3.ONE` (or its negative counterpart), but preserves the `position` and `rotation`. See also `Transform3D.orthonormalized`.

### `rotate(axis: Vector3, angle: float) -> void`

Rotates this node's `basis` around the `axis` by the given `angle`, in radians. This operation is calculated in parent space (relative to the parent) and preserves the `position`.

### `rotate_object_local(axis: Vector3, angle: float) -> void`

Rotates this node's `basis` around the `axis` by the given `angle`, in radians. This operation is calculated in local space (relative to this node) and preserves the `position`.

### `rotate_x(angle: float) -> void`

Rotates this node's `basis` around the X axis by the given `angle`, in radians. This operation is calculated in parent space (relative to the parent) and preserves the `position`.

### `rotate_y(angle: float) -> void`

Rotates this node's `basis` around the Y axis by the given `angle`, in radians. This operation is calculated in parent space (relative to the parent) and preserves the `position`.

### `rotate_z(angle: float) -> void`

Rotates this node's `basis` around the Z axis by the given `angle`, in radians. This operation is calculated in parent space (relative to the parent) and preserves the `position`.

### `scale_object_local(scale: Vector3) -> void`

Scales this node's `basis` by the given `scale` factor. This operation is calculated in local space (relative to this node) and preserves the `position`.

### `set_disable_scale(disable: bool) -> void`

If `true`, this node's `global_transform` is automatically orthonormalized. This results in this node not appearing distorted, as if its global scale were set to `Vector3.ONE` (or its negative counterpart). See also `is_scale_disabled` and `orthonormalize`.
				**Note:** `transform` is not affected by this setting.

### `set_identity() -> void`

Sets this node's `transform` to `Transform3D.IDENTITY`, which resets all transformations in parent space (`position`, `rotation`, and `scale`).

### `set_ignore_transform_notification(enabled: bool) -> void`

If `true`, the node will not receive `NOTIFICATION_TRANSFORM_CHANGED` or `NOTIFICATION_LOCAL_TRANSFORM_CHANGED`.
				It may useful to call this method when handling these notifications to prevent infinite recursion.

### `set_notify_local_transform(enable: bool) -> void`

If `true`, the node will receive `NOTIFICATION_LOCAL_TRANSFORM_CHANGED` whenever `transform` changes.
				**Note:** Some 3D nodes such as `CSGShape3D` or `CollisionShape3D` automatically enable this to function correctly.

### `set_notify_transform(enable: bool) -> void`
- 限定：keywords=set_notify_global_transform

If `true`, the node will receive `NOTIFICATION_TRANSFORM_CHANGED` whenever `global_transform` changes.
				**Note:** Most 3D nodes such as `VisualInstance3D` or `CollisionObject3D` automatically enable this to function correctly.
				**Note:** In the editor, nodes will propagate this notification to their children if a gizmo is attached (see `add_gizmo`).

### `set_subgizmo_selection(gizmo: Node3DGizmo, id: int, transform: Transform3D) -> void`

Selects the `gizmo`'s subgizmo with the given `id` and sets its transform. Only works in the editor.
				**Note:** The gizmo object would typically be an instance of `EditorNode3DGizmo`, but the argument type is kept generic to avoid creating a dependency on editor classes in `Node3D`.

### `show() -> void`

Allows this node to be rendered. Equivalent to setting `visible` to `true`. This is the opposite of `hide`.

### `to_global(local_point: Vector3) -> Vector3`
- 限定：qualifiers=const

Returns the `local_point` converted from this node's local space to global space. This is the opposite of `to_local`.

### `to_local(global_point: Vector3) -> Vector3`
- 限定：qualifiers=const

Returns the `global_point` converted from global space to this node's local space. This is the opposite of `to_global`.

### `translate(offset: Vector3) -> void`

Adds the given translation `offset` to the node's position, in local space (relative to this node).
				**Note:** Prefer using `translate_object_local`, instead, as this method may be changed in a future release.
				**Note:** Despite the naming convention, this operation is **not** calculated in parent space for compatibility reasons. To translate in parent space, add `offset` to the `position` (`node_3d.position += offset`).

### `translate_object_local(offset: Vector3) -> void`
- 限定：keywords=move_local

Adds the given translation `offset` to the node's position, in local space (relative to this node).

### `update_gizmos() -> void`

Updates all the `EditorNode3DGizmo` objects attached to this node. Only works in the editor.

## 信号

### `visibility_changed()`

Emitted when this node's visibility changes (see `visible` and `is_visible_in_tree`).
				This signal is emitted *after* the related `NOTIFICATION_VISIBILITY_CHANGED` notification.

## 枚举

### `RotationEditMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ROTATION_EDIT_MODE_EULER` |  |
| `1` | `ROTATION_EDIT_MODE_QUATERNION` |  |
| `2` | `ROTATION_EDIT_MODE_BASIS` |  |

## 常量

- **`NOTIFICATION_TRANSFORM_CHANGED`** = `2000`
- **`NOTIFICATION_ENTER_WORLD`** = `41`
- **`NOTIFICATION_EXIT_WORLD`** = `42`
- **`NOTIFICATION_VISIBILITY_CHANGED`** = `43`
- **`NOTIFICATION_LOCAL_TRANSFORM_CHANGED`** = `44`
## 教程链接

- [Introduction to 3D](None)
- [All 3D Demos](None)

