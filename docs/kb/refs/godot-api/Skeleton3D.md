# Skeleton3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Skeleton3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Skeleton3D.md`

**摘要**：A node containing a bone hierarchy, used to create a 3D skeletal animation.

## 描述

`Skeleton3D` provides an interface for managing a hierarchy of bones, including pose, rest and animation (see `Animation`). It can also use ragdoll physics.
		The overall transform of a bone with respect to the skeleton is determined by bone pose. Bone rest defines the initial transform of the bone pose.
		Note that "global pose" below refers to the overall transform of the bone with respect to skeleton, so it is not the actual global/world transform of the bone.

## 属性

- **`animate_physical_bones`** `bool` = `true`
  - 其它属性：deprecated= · getter=get_animate_physical_bones · setter=set_animate_physical_bones
- **`modifier_callback_mode_process`** `int` = `1` · 枚举 `Skeleton3D.ModifierCallbackModeProcess`
  - 其它属性：getter=get_modifier_callback_mode_process · setter=set_modifier_callback_mode_process
- **`motion_scale`** `float` = `1.0`
  - 其它属性：getter=get_motion_scale · setter=set_motion_scale
- **`show_rest_only`** `bool` = `false`
  - 其它属性：getter=is_show_rest_only · setter=set_show_rest_only

## 方法

### `add_bone(name: String) -> int`

Adds a new bone with the given name. Returns the new bone's index, or `-1` if this method fails.
				**Note:** Bone names should be unique, non empty, and cannot include the `:` and `/` characters.

### `advance(delta: float) -> void`

Manually advance the child `SkeletonModifier3D`s by the specified time (in seconds).
				**Note:** The `delta` is temporarily accumulated in the `Skeleton3D`, and the deferred process uses the accumulated value to process the modification.

### `clear_bones() -> void`

Clear all the bones in this skeleton.

### `clear_bones_global_pose_override() -> void`
- 限定：deprecated=

Removes the global pose override on all bones in the skeleton.

### `create_skin_from_rest_transforms() -> Skin`

### `find_bone(name: String) -> int`
- 限定：qualifiers=const

Returns the bone index that matches `name` as its name. Returns `-1` if no bone with this name exists.

### `force_update_all_bone_transforms() -> void`
- 限定：deprecated=This method should only be called internally.

Force updates the bone transforms/poses for all bones in the skeleton.

### `force_update_bone_child_transform(bone_idx: int) -> void`

Force updates the bone transform for the bone at `bone_idx` and all of its children.

### `get_bone_children(bone_idx: int) -> PackedInt32Array`
- 限定：qualifiers=const

Returns an array containing the bone indexes of all the child node of the passed in bone, `bone_idx`.

### `get_bone_count() -> int`
- 限定：qualifiers=const

Returns the number of bones in the skeleton.

### `get_bone_global_pose(bone_idx: int) -> Transform3D`
- 限定：qualifiers=const

Returns the overall transform of the specified bone, with respect to the skeleton. Being relative to the skeleton frame, this is not the actual "global" transform of the bone.
				**Note:** This is the global pose you set to the skeleton in the process, the final global pose can get overridden by modifiers in the deferred process, if you want to access the final global pose, use `SkeletonModifier3D.modification_processed`.

### `get_bone_global_pose_no_override(bone_idx: int) -> Transform3D`
- 限定：deprecated= · qualifiers=const

Returns the overall transform of the specified bone, with respect to the skeleton, but without any global pose overrides. Being relative to the skeleton frame, this is not the actual "global" transform of the bone.

### `get_bone_global_pose_override(bone_idx: int) -> Transform3D`
- 限定：deprecated= · qualifiers=const

Returns the global pose override transform for `bone_idx`.

### `get_bone_global_rest(bone_idx: int) -> Transform3D`
- 限定：qualifiers=const

Returns the global rest transform for `bone_idx`.

### `get_bone_meta(bone_idx: int, key: StringName) -> Variant`
- 限定：qualifiers=const

Returns the metadata with the given `key` for the bone at index `bone_idx`.

### `get_bone_meta_list(bone_idx: int) -> StringName[]`
- 限定：qualifiers=const

Returns the list of all metadata keys for the bone at index `bone_idx`.

### `get_bone_name(bone_idx: int) -> String`
- 限定：qualifiers=const

Returns the name of the bone at index `bone_idx`.

### `get_bone_parent(bone_idx: int) -> int`
- 限定：qualifiers=const

Returns the bone index which is the parent of the bone at `bone_idx`. If -1, then bone has no parent.
				**Note:** The parent bone returned will always be less than `bone_idx`.

### `get_bone_pose(bone_idx: int) -> Transform3D`
- 限定：qualifiers=const

Returns the pose transform of the specified bone.
				**Note:** This is the pose you set to the skeleton in the process, the final pose can get overridden by modifiers in the deferred process, if you want to access the final pose, use `SkeletonModifier3D.modification_processed`.

### `get_bone_pose_position(bone_idx: int) -> Vector3`
- 限定：qualifiers=const

Returns the pose position of the bone at `bone_idx`. The returned `Vector3` is in the local coordinate space of the `Skeleton3D` node.

### `get_bone_pose_rotation(bone_idx: int) -> Quaternion`
- 限定：qualifiers=const

Returns the pose rotation of the bone at `bone_idx`. The returned `Quaternion` is local to the bone with respect to the rotation of any parent bones.

### `get_bone_pose_scale(bone_idx: int) -> Vector3`
- 限定：qualifiers=const

Returns the pose scale of the bone at `bone_idx`.

### `get_bone_rest(bone_idx: int) -> Transform3D`
- 限定：qualifiers=const

Returns the rest transform for a bone `bone_idx`.

### `get_concatenated_bone_names() -> StringName`
- 限定：qualifiers=const

Returns all bone names concatenated with commas (`,`) as a single `StringName`.
				It is useful to set it as a hint for the enum property.

### `get_parentless_bones() -> PackedInt32Array`
- 限定：qualifiers=const

Returns an array with all of the bones that are parentless. Another way to look at this is that it returns the indexes of all the bones that are not dependent or modified by other bones in the Skeleton.

### `get_version() -> int`
- 限定：qualifiers=const

Returns the number of times the bone hierarchy has changed within this skeleton, including renames.
				The Skeleton version is not serialized: only use within a single instance of Skeleton3D.
				Use for invalidating caches in IK solvers and other nodes which process bones.

### `has_bone_meta(bone_idx: int, key: StringName) -> bool`
- 限定：qualifiers=const

Returns `true` if the bone at index `bone_idx` has metadata with the given `key`.

### `is_bone_enabled(bone_idx: int) -> bool`
- 限定：qualifiers=const

Returns whether the bone pose for the bone at `bone_idx` is enabled.

### `localize_rests() -> void`

Returns all bones in the skeleton to their rest poses.

### `physical_bones_add_collision_exception(exception: RID) -> void`
- 限定：deprecated=

Adds a collision exception to the physical bone.
				Works just like the `RigidBody3D` node.

### `physical_bones_remove_collision_exception(exception: RID) -> void`
- 限定：deprecated=

Removes a collision exception to the physical bone.
				Works just like the `RigidBody3D` node.

### `physical_bones_start_simulation(bones: StringName[] = []) -> void`
- 限定：deprecated=

Tells the `PhysicalBone3D` nodes in the Skeleton to start simulating and reacting to the physics world.
				Optionally, a list of bone names can be passed-in, allowing only the passed-in bones to be simulated.

### `physical_bones_stop_simulation() -> void`
- 限定：deprecated=

Tells the `PhysicalBone3D` nodes in the Skeleton to stop simulating.

### `register_skin(skin: Skin) -> SkinReference`

Binds the given Skin to the Skeleton.

### `reset_bone_pose(bone_idx: int) -> void`

Sets the bone pose to rest for `bone_idx`.

### `reset_bone_poses() -> void`

Sets all bone poses to rests.

### `set_bone_enabled(bone_idx: int, enabled: bool = true) -> void`

Disables the pose for the bone at `bone_idx` if `false`, enables the bone pose if `true`.

### `set_bone_global_pose(bone_idx: int, pose: Transform3D) -> void`

Sets the global pose transform, `pose`, for the bone at `bone_idx`.
				**Note:** If other bone poses have been changed, this method executes a dirty poses recalculation and will cause performance to deteriorate. If you know that multiple global poses will be applied, consider using `set_bone_pose` with precalculation.

### `set_bone_global_pose_override(bone_idx: int, pose: Transform3D, amount: float, persistent: bool = false) -> void`
- 限定：deprecated=

Sets the global pose transform, `pose`, for the bone at `bone_idx`.
				`amount` is the interpolation strength that will be used when applying the pose, and `persistent` determines if the applied pose will remain.
				**Note:** The pose transform needs to be a global pose! To convert a world transform from a `Node3D` to a global bone pose, multiply the `Transform3D.affine_inverse` of the node's `Node3D.global_transform` by the desired world transform.

### `set_bone_meta(bone_idx: int, key: StringName, value: Variant) -> void`

Sets the metadata with the given `key` to `value` for the bone at index `bone_idx`.

### `set_bone_name(bone_idx: int, name: String) -> void`

Sets the bone name, `name`, for the bone at `bone_idx`.

### `set_bone_parent(bone_idx: int, parent_idx: int) -> void`

Sets the bone index `parent_idx` as the parent of the bone at `bone_idx`. If -1, then bone has no parent.
				**Note:** `parent_idx` must be less than `bone_idx`.

### `set_bone_pose(bone_idx: int, pose: Transform3D) -> void`

Sets the pose transform, `pose`, for the bone at `bone_idx`.

### `set_bone_pose_position(bone_idx: int, position: Vector3) -> void`

Sets the pose position of the bone at `bone_idx` to `position`. `position` is a `Vector3` describing a position local to the `Skeleton3D` node.

### `set_bone_pose_rotation(bone_idx: int, rotation: Quaternion) -> void`

Sets the pose rotation of the bone at `bone_idx` to `rotation`. `rotation` is a `Quaternion` describing a rotation in the bone's local coordinate space with respect to the rotation of any parent bones.

### `set_bone_pose_scale(bone_idx: int, scale: Vector3) -> void`

Sets the pose scale of the bone at `bone_idx` to `scale`.

### `set_bone_rest(bone_idx: int, rest: Transform3D) -> void`

Sets the rest transform for bone `bone_idx`.

### `unparent_bone_and_rest(bone_idx: int) -> void`

Unparents the bone at `bone_idx` and sets its rest position to that of its parent prior to being reset.

## 信号

### `bone_enabled_changed(bone_idx: int)`

Emitted when the bone at `bone_idx` is toggled with `set_bone_enabled`. Use `is_bone_enabled` to check the new value.

### `bone_list_changed()`

Emitted when the list of bones changes, such as when calling `add_bone`, `set_bone_parent`, `unparent_bone_and_rest`, or `clear_bones`.

### `pose_updated()`

Emitted when the pose is updated.
				**Note:** During the update process, this signal is not fired, so modification by `SkeletonModifier3D` is not detected.

### `rest_updated()`

Emitted when the rest is updated.

### `show_rest_only_changed()`

Emitted when the value of `show_rest_only` changes.

### `skeleton_updated()`

Emitted when the final pose has been calculated will be applied to the skin in the update process.
				This means that all `SkeletonModifier3D` processing is complete. In order to detect the completion of the processing of each `SkeletonModifier3D`, use `SkeletonModifier3D.modification_processed`.

## 枚举

### `ModifierCallbackModeProcess`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `MODIFIER_CALLBACK_MODE_PROCESS_PHYSICS` |  |
| `1` | `MODIFIER_CALLBACK_MODE_PROCESS_IDLE` |  |
| `2` | `MODIFIER_CALLBACK_MODE_PROCESS_MANUAL` |  |

## 常量

- **`NOTIFICATION_UPDATE_SKELETON`** = `50`
## 教程链接

- [Third Person Shooter (TPS) Demo](None)

