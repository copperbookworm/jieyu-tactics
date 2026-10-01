# BoneTwistDisperser3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`BoneTwistDisperser3D` → `SkeletonModifier3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/BoneTwistDisperser3D.md`

**摘要**：A node that propagates and disperses the child bone's twist to the parent bones.

## 描述

This `BoneTwistDisperser3D` allows for smooth twist interpolation between multiple bones by dispersing the end bone's twist to the parents. This only changes the twist without changing the global position of each joint.
		This is useful for smoothly twisting bones in combination with `CopyTransformModifier3D` and IK.
		**Note:** If an extracted twist is greater than 180 degrees, flipping occurs. This is similar to `ConvertTransformModifier3D`.
		**Note:** Most methods in this class take an `index` parameter. This parameter specifies which setting list entry to return if the IK has multiple entries (e.g. `settings/<index>/root_bone_name`).

## 属性

- **`mutable_bone_axes`** `bool` = `true`
  - 其它属性：getter=are_bone_axes_mutable · setter=set_mutable_bone_axes
- **`setting_count`** `int` = `0`
  - 其它属性：getter=get_setting_count · setter=set_setting_count

## 方法

### `clear_settings() -> void`

Clears all settings.

### `get_damping_curve(index: int) -> Curve`
- 限定：qualifiers=const

Returns the damping curve when `get_disperse_mode` is `DISPERSE_MODE_CUSTOM`.

### `get_disperse_mode(index: int) -> int`
- 限定：qualifiers=const

Returns whether to use automatic amount assignment or to allow manual assignment.

### `get_end_bone(index: int) -> int`
- 限定：qualifiers=const

Returns the end bone index of the bone chain.

### `get_end_bone_direction(index: int) -> int`
- 限定：qualifiers=const

Returns the tail direction of the end bone of the bone chain when `is_end_bone_extended` is `true`.

### `get_end_bone_name(index: int) -> String`
- 限定：qualifiers=const

Returns the end bone name of the bone chain.

### `get_joint_bone(index: int, joint: int) -> int`
- 限定：qualifiers=const

Returns the bone index at `joint` in the bone chain's joint list.

### `get_joint_bone_name(index: int, joint: int) -> String`
- 限定：qualifiers=const

Returns the bone name at `joint` in the bone chain's joint list.

### `get_joint_count(index: int) -> int`
- 限定：qualifiers=const

Returns the joint count of the bone chain's joint list.

### `get_joint_twist_amount(index: int, joint: int) -> float`
- 限定：qualifiers=const

Returns the twist amount at `joint` in the bone chain's joint list when `get_disperse_mode` is `DISPERSE_MODE_CUSTOM`.

### `get_reference_bone(index: int) -> int`
- 限定：qualifiers=const

Returns the reference bone to extract twist of the setting at `index`.
				This bone is either the end of the chain or its parent, depending on `is_end_bone_extended`.

### `get_reference_bone_name(index: int) -> String`
- 限定：qualifiers=const

Returns the reference bone name to extract twist of the setting at `index`.
				This bone is either the end of the chain or its parent, depending on `is_end_bone_extended`.

### `get_root_bone(index: int) -> int`
- 限定：qualifiers=const

Returns the root bone index of the bone chain.

### `get_root_bone_name(index: int) -> String`
- 限定：qualifiers=const

Returns the root bone name of the bone chain.

### `get_twist_from(index: int) -> Quaternion`
- 限定：qualifiers=const

Returns the rotation to an arbitrary state before twisting for the current bone pose to extract the twist when `is_twist_from_rest` is `false`.

### `get_weight_position(index: int) -> float`
- 限定：qualifiers=const

Returns the position at which to divide the segment between joints for weight assignment when `get_disperse_mode` is `DISPERSE_MODE_WEIGHTED`.

### `is_end_bone_extended(index: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the end bone is extended to have a tail.

### `is_twist_from_rest(index: int) -> bool`
- 限定：qualifiers=const

Returns `true` if extracting the twist amount from the difference between the bone rest and the current bone pose.

### `set_damping_curve(index: int, curve: Curve) -> void`

Sets the damping curve when `get_disperse_mode` is `DISPERSE_MODE_CUSTOM`.

### `set_disperse_mode(index: int, disperse_mode: int) -> void`

Sets whether to use automatic amount assignment or to allow manual assignment.

### `set_end_bone(index: int, bone: int) -> void`

Sets the end bone index of the bone chain.

### `set_end_bone_direction(index: int, bone_direction: int) -> void`

Sets the end bone tail direction of the bone chain when `is_end_bone_extended` is `true`.

### `set_end_bone_name(index: int, bone_name: String) -> void`

Sets the end bone name of the bone chain.
				**Note:** The end bone must be a child of the root bone.

### `set_extend_end_bone(index: int, enabled: bool) -> void`

If `enabled` is `true`, the end bone is extended to have a tail.
				If `enabled` is `false`, `get_reference_bone` becomes a parent of the end bone and it uses the vector to the end bone as a twist axis.

### `set_joint_twist_amount(index: int, joint: int, twist_amount: float) -> void`

Sets the twist amount at `joint` in the bone chain's joint list when `get_disperse_mode` is `DISPERSE_MODE_CUSTOM`.

### `set_root_bone(index: int, bone: int) -> void`

Sets the root bone index of the bone chain.

### `set_root_bone_name(index: int, bone_name: String) -> void`

Sets the root bone name of the bone chain.

### `set_twist_from(index: int, from: Quaternion) -> void`

Sets the rotation to an arbitrary state before twisting for the current bone pose to extract the twist when `is_twist_from_rest` is `false`.
				In other words, by calling `set_twist_from` by `SkeletonModifier3D.modification_processed` of a specific `SkeletonModifier3D`, you can extract only the twists generated by modifiers processed after that but before this `BoneTwistDisperser3D`.

### `set_twist_from_rest(index: int, enabled: bool) -> void`

If `enabled` is `true`, it extracts the twist amount from the difference between the bone rest and the current bone pose.
				If `enabled` is `false`, it extracts the twist amount from the difference between `get_twist_from` and the current bone pose. See also `set_twist_from`.

### `set_weight_position(index: int, weight_position: float) -> void`

Sets the position at which to divide the segment between joints for weight assignment when `get_disperse_mode` is `DISPERSE_MODE_WEIGHTED`.
				For example, when `weight_position` is `0.5`, if two bone segments with a length of `1.0` exist between three joints, weights are assigned to each joint from root to end at ratios of `0.5`, `1.0`, and `0.5`. Then amounts become `0.25`, `0.75`, and `1.0` respectively.

## 枚举

### `DisperseMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `DISPERSE_MODE_EVEN` |  |
| `1` | `DISPERSE_MODE_WEIGHTED` |  |
| `2` | `DISPERSE_MODE_CUSTOM` |  |

