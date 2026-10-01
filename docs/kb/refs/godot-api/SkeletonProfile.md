# SkeletonProfile

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`SkeletonProfile` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/SkeletonProfile.md`

**摘要**：Base class for a profile of a virtual skeleton used as a target for retargeting.

## 描述

This resource is used in `EditorScenePostImport`. Some parameters are referring to bones in `Skeleton3D`, `Skin`, `Animation`, and some other nodes are rewritten based on the parameters of `SkeletonProfile`.
		**Note:** These parameters need to be set only when creating a custom profile. In `SkeletonProfileHumanoid`, they are defined internally as read-only values.

## 属性

- **`bone_size`** `int` = `0`
  - 其它属性：getter=get_bone_size · setter=set_bone_size
- **`group_size`** `int` = `0`
  - 其它属性：getter=get_group_size · setter=set_group_size
- **`root_bone`** `StringName` = `&""`
  - 其它属性：getter=get_root_bone · setter=set_root_bone
- **`scale_base_bone`** `StringName` = `&""`
  - 其它属性：getter=get_scale_base_bone · setter=set_scale_base_bone

## 方法

### `find_bone(bone_name: StringName) -> int`
- 限定：qualifiers=const

Returns the bone index that matches `bone_name` as its name.

### `get_bone_name(bone_idx: int) -> StringName`
- 限定：qualifiers=const

Returns the name of the bone at `bone_idx` that will be the key name in the `BoneMap`.
				In the retargeting process, the returned bone name is the bone name of the target skeleton.

### `get_bone_parent(bone_idx: int) -> StringName`
- 限定：qualifiers=const

Returns the name of the bone which is the parent to the bone at `bone_idx`. The result is empty if the bone has no parent.

### `get_bone_tail(bone_idx: int) -> StringName`
- 限定：qualifiers=const

Returns the name of the bone which is the tail of the bone at `bone_idx`.

### `get_group(bone_idx: int) -> StringName`
- 限定：qualifiers=const

Returns the group of the bone at `bone_idx`.

### `get_group_name(group_idx: int) -> StringName`
- 限定：qualifiers=const

Returns the name of the group at `group_idx` that will be the drawing group in the `BoneMap` editor.

### `get_handle_offset(bone_idx: int) -> Vector2`
- 限定：qualifiers=const

Returns the offset of the bone at `bone_idx` that will be the button position in the `BoneMap` editor.
				This is the offset with origin at the top left corner of the square.

### `get_reference_pose(bone_idx: int) -> Transform3D`
- 限定：qualifiers=const

Returns the reference pose transform for bone `bone_idx`.

### `get_tail_direction(bone_idx: int) -> int`
- 限定：qualifiers=const

Returns the tail direction of the bone at `bone_idx`.

### `get_texture(group_idx: int) -> Texture2D`
- 限定：qualifiers=const

Returns the texture of the group at `group_idx` that will be the drawing group background image in the `BoneMap` editor.

### `is_required(bone_idx: int) -> bool`
- 限定：qualifiers=const

Returns whether the bone at `bone_idx` is required for retargeting.
				This value is used by the bone map editor. If this method returns `true`, and no bone is assigned, the handle color will be red on the bone map editor.

### `set_bone_name(bone_idx: int, bone_name: StringName) -> void`

Sets the name of the bone at `bone_idx` that will be the key name in the `BoneMap`.
				In the retargeting process, the setting bone name is the bone name of the target skeleton.

### `set_bone_parent(bone_idx: int, bone_parent: StringName) -> void`

Sets the bone with name `bone_parent` as the parent of the bone at `bone_idx`. If an empty string is passed, then the bone has no parent.

### `set_bone_tail(bone_idx: int, bone_tail: StringName) -> void`

Sets the bone with name `bone_tail` as the tail of the bone at `bone_idx`.

### `set_group(bone_idx: int, group: StringName) -> void`

Sets the group of the bone at `bone_idx`.

### `set_group_name(group_idx: int, group_name: StringName) -> void`

Sets the name of the group at `group_idx` that will be the drawing group in the `BoneMap` editor.

### `set_handle_offset(bone_idx: int, handle_offset: Vector2) -> void`

Sets the offset of the bone at `bone_idx` that will be the button position in the `BoneMap` editor.
				This is the offset with origin at the top left corner of the square.

### `set_reference_pose(bone_idx: int, bone_name: Transform3D) -> void`

Sets the reference pose transform for bone `bone_idx`.

### `set_required(bone_idx: int, required: bool) -> void`

Sets the required status for bone `bone_idx` to `required`.

### `set_tail_direction(bone_idx: int, tail_direction: int) -> void`

Sets the tail direction of the bone at `bone_idx`.
				**Note:** This only specifies the method of calculation. The actual coordinates required should be stored in an external skeleton, so the calculation itself needs to be done externally.

### `set_texture(group_idx: int, texture: Texture2D) -> void`

Sets the texture of the group at `group_idx` that will be the drawing group background image in the `BoneMap` editor.

## 信号

### `profile_updated()`

This signal is emitted when change the value in profile. This is used to update key name in the `BoneMap` and to redraw the `BoneMap` editor.
				**Note:** This signal is not connected directly to editor to simplify the reference, instead it is passed on to editor through the `BoneMap`.

## 枚举

### `TailDirection`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `TAIL_DIRECTION_AVERAGE_CHILDREN` |  |
| `1` | `TAIL_DIRECTION_SPECIFIC_CHILD` |  |
| `2` | `TAIL_DIRECTION_END` |  |

## 教程链接

- [Retargeting 3D Skeletons](None)

