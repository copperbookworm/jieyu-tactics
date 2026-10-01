# AimModifier3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AimModifier3D` → `BoneConstraint3D` → `SkeletonModifier3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AimModifier3D.md`

**摘要**：The `AimModifier3D` rotates a bone to look at a reference bone.

## 描述

This is a simple version of `LookAtModifier3D` that only allows bone to the reference without advanced options such as angle limitation or time-based interpolation.
		The feature is simplified, but instead it is implemented with smooth tracking without euler, see `set_use_euler`.

## 属性

- **`setting_count`** `int` = `0`
  - 其它属性：getter=get_setting_count · setter=set_setting_count

## 方法

### `get_forward_axis(index: int) -> int`
- 限定：qualifiers=const

Returns the forward axis of the bone.

### `get_primary_rotation_axis(index: int) -> int`
- 限定：qualifiers=const

Returns the axis of the first rotation. It is enabled only if `is_using_euler` is `true`.

### `is_relative(index: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the relative option is enabled in the setting at `index`.

### `is_using_euler(index: int) -> bool`
- 限定：qualifiers=const

Returns `true` if it provides rotation with using euler.

### `is_using_secondary_rotation(index: int) -> bool`
- 限定：qualifiers=const

Returns `true` if it provides rotation by two axes. It is enabled only if `is_using_euler` is `true`.

### `set_forward_axis(index: int, axis: int) -> void`

Sets the forward axis of the bone.

### `set_primary_rotation_axis(index: int, axis: int) -> void`

Sets the axis of the first rotation. It is enabled only if `is_using_euler` is `true`.

### `set_relative(index: int, enabled: bool) -> void`

Sets relative option in the setting at `index` to `enabled`.
				If sets `enabled` to `true`, the rotation is applied relative to the pose.
				If sets `enabled` to `false`, the rotation is applied relative to the rest. It means to replace the current pose with the `AimModifier3D`'s result.

### `set_use_euler(index: int, enabled: bool) -> void`

If sets `enabled` to `true`, it provides rotation with using euler.
				If sets `enabled` to `false`, it provides rotation with using rotation by arc generated from the forward axis vector and the vector toward the reference.

### `set_use_secondary_rotation(index: int, enabled: bool) -> void`

If sets `enabled` to `true`, it provides rotation by two axes. It is enabled only if `is_using_euler` is `true`.

