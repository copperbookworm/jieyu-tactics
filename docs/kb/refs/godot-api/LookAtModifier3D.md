# LookAtModifier3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`LookAtModifier3D` → `SkeletonModifier3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/LookAtModifier3D.md`

**摘要**：The `LookAtModifier3D` rotates a bone to look at a target.

## 描述

This `SkeletonModifier3D` rotates a bone to look at a target. This is helpful for moving a character's head to look at the player, rotating a turret to look at a target, or any other case where you want to make a bone rotate towards something quickly and easily.
		When applying multiple `LookAtModifier3D`s, the `LookAtModifier3D` assigned to the parent bone must be put above the `LookAtModifier3D` assigned to the child bone in the list in order for the child bone results to be correct.

## 属性

- **`bone`** `int` = `-1`
  - 其它属性：getter=get_bone · setter=set_bone
- **`bone_name`** `String` = `""`
  - 其它属性：getter=get_bone_name · setter=set_bone_name
- **`duration`** `float` = `0.0`
  - 其它属性：getter=get_duration · setter=set_duration
- **`ease_type`** `int` = `0` · 枚举 `Tween.EaseType`
  - 其它属性：getter=get_ease_type · setter=set_ease_type
- **`forward_axis`** `int` = `4` · 枚举 `SkeletonModifier3D.BoneAxis`
  - 其它属性：getter=get_forward_axis · setter=set_forward_axis
- **`origin_bone`** `int`
  - 其它属性：getter=get_origin_bone · setter=set_origin_bone
- **`origin_bone_name`** `String`
  - 其它属性：getter=get_origin_bone_name · setter=set_origin_bone_name
- **`origin_external_node`** `NodePath`
  - 其它属性：getter=get_origin_external_node · setter=set_origin_external_node
- **`origin_from`** `int` = `0` · 枚举 `LookAtModifier3D.OriginFrom`
  - 其它属性：getter=get_origin_from · setter=set_origin_from
- **`origin_offset`** `Vector3` = `Vector3(0, 0, 0)`
  - 其它属性：getter=get_origin_offset · setter=set_origin_offset
- **`origin_safe_margin`** `float` = `0.1`
  - 其它属性：getter=get_origin_safe_margin · setter=set_origin_safe_margin
- **`primary_damp_threshold`** `float`
  - 其它属性：getter=get_primary_damp_threshold · setter=set_primary_damp_threshold
- **`primary_limit_angle`** `float`
  - 其它属性：getter=get_primary_limit_angle · setter=set_primary_limit_angle
- **`primary_negative_damp_threshold`** `float`
  - 其它属性：getter=get_primary_negative_damp_threshold · setter=set_primary_negative_damp_threshold
- **`primary_negative_limit_angle`** `float`
  - 其它属性：getter=get_primary_negative_limit_angle · setter=set_primary_negative_limit_angle
- **`primary_positive_damp_threshold`** `float`
  - 其它属性：getter=get_primary_positive_damp_threshold · setter=set_primary_positive_damp_threshold
- **`primary_positive_limit_angle`** `float`
  - 其它属性：getter=get_primary_positive_limit_angle · setter=set_primary_positive_limit_angle
- **`primary_rotation_axis`** `int` = `1` · 枚举 `Vector3.Axis`
  - 其它属性：getter=get_primary_rotation_axis · setter=set_primary_rotation_axis
- **`relative`** `bool` = `false`
  - 其它属性：getter=is_relative · setter=set_relative
- **`secondary_damp_threshold`** `float`
  - 其它属性：getter=get_secondary_damp_threshold · setter=set_secondary_damp_threshold
- **`secondary_limit_angle`** `float`
  - 其它属性：getter=get_secondary_limit_angle · setter=set_secondary_limit_angle
- **`secondary_negative_damp_threshold`** `float`
  - 其它属性：getter=get_secondary_negative_damp_threshold · setter=set_secondary_negative_damp_threshold
- **`secondary_negative_limit_angle`** `float`
  - 其它属性：getter=get_secondary_negative_limit_angle · setter=set_secondary_negative_limit_angle
- **`secondary_positive_damp_threshold`** `float`
  - 其它属性：getter=get_secondary_positive_damp_threshold · setter=set_secondary_positive_damp_threshold
- **`secondary_positive_limit_angle`** `float`
  - 其它属性：getter=get_secondary_positive_limit_angle · setter=set_secondary_positive_limit_angle
- **`symmetry_limitation`** `bool`
  - 其它属性：getter=is_limitation_symmetry · setter=set_symmetry_limitation
- **`target_node`** `NodePath` = `NodePath("")`
  - 其它属性：getter=get_target_node · setter=set_target_node
- **`transition_type`** `int` = `0` · 枚举 `Tween.TransitionType`
  - 其它属性：getter=get_transition_type · setter=set_transition_type
- **`use_angle_limitation`** `bool` = `false`
  - 其它属性：getter=is_using_angle_limitation · setter=set_use_angle_limitation
- **`use_secondary_rotation`** `bool` = `true`
  - 其它属性：getter=is_using_secondary_rotation · setter=set_use_secondary_rotation

## 方法

### `get_interpolation_remaining() -> float`
- 限定：qualifiers=const

Returns the remaining seconds of the time-based interpolation.

### `is_interpolating() -> bool`
- 限定：qualifiers=const

Returns `true` if time-based interpolation is running. If `true`, it is equivalent to `get_interpolation_remaining` returning `0.0`.
				This is useful to determine whether a `LookAtModifier3D` can be removed safely.

### `is_target_within_limitation() -> bool`
- 限定：qualifiers=const

Returns whether the target is within the angle limitations. It is useful for unsetting the `target_node` when the target is outside of the angle limitations.
				**Note:** The value is updated after `SkeletonModifier3D._process_modification`. To retrieve this value correctly, we recommend using the signal `SkeletonModifier3D.modification_processed`.

## 枚举

### `OriginFrom`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ORIGIN_FROM_SELF` |  |
| `1` | `ORIGIN_FROM_SPECIFIC_BONE` |  |
| `2` | `ORIGIN_FROM_EXTERNAL_NODE` |  |

