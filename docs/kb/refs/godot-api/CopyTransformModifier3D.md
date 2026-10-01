# CopyTransformModifier3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`CopyTransformModifier3D` → `BoneConstraint3D` → `SkeletonModifier3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/CopyTransformModifier3D.md`

**摘要**：A `SkeletonModifier3D` that apply transform to the bone which copied from reference.

## 描述

Apply the copied transform of the bone set by `BoneConstraint3D.set_reference_bone` to the bone set by `BoneConstraint3D.set_apply_bone` with processing it with some masks and options.
		There are 4 ways to apply the transform, depending on the combination of `set_relative` and `set_additive`.
		**Relative + Additive:**
		- Extract reference pose relative to the rest and add it to the apply bone's pose.
		**Relative + Not Additive:**
		- Extract reference pose relative to the rest and add it to the apply bone's rest.
		**Not Relative + Additive:**
		- Extract reference pose absolutely and add it to the apply bone's pose.
		**Not Relative + Not Additive:**
		- Extract reference pose absolutely and the apply bone's pose is replaced with it.
		**Note:** Relative option is available only in the case `BoneConstraint3D.get_reference_type` is `BoneConstraint3D.REFERENCE_TYPE_BONE`. See also `BoneConstraint3D.ReferenceType`.

## 属性

- **`setting_count`** `int` = `0`
  - 其它属性：getter=get_setting_count · setter=set_setting_count

## 方法

### `get_axis_flags(index: int) -> int`
- 限定：qualifiers=const

Returns the axis flags of the setting at `index`.

### `get_copy_flags(index: int) -> int`
- 限定：qualifiers=const

Returns the copy flags of the setting at `index`.

### `get_invert_flags(index: int) -> int`
- 限定：qualifiers=const

Returns the invert flags of the setting at `index`.

### `is_additive(index: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the additive option is enabled in the setting at `index`.

### `is_axis_x_enabled(index: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the enable flags has the flag for the X-axis in the setting at `index`. See also `set_axis_flags`.

### `is_axis_x_inverted(index: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the invert flags has the flag for the X-axis in the setting at `index`. See also `set_invert_flags`.

### `is_axis_y_enabled(index: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the enable flags has the flag for the Y-axis in the setting at `index`. See also `set_axis_flags`.

### `is_axis_y_inverted(index: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the invert flags has the flag for the Y-axis in the setting at `index`. See also `set_invert_flags`.

### `is_axis_z_enabled(index: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the enable flags has the flag for the Z-axis in the setting at `index`. See also `set_axis_flags`.

### `is_axis_z_inverted(index: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the invert flags has the flag for the Z-axis in the setting at `index`. See also `set_invert_flags`.

### `is_position_copying(index: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the copy flags has the flag for the position in the setting at `index`. See also `set_copy_flags`.

### `is_relative(index: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the relative option is enabled in the setting at `index`.

### `is_rotation_copying(index: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the copy flags has the flag for the rotation in the setting at `index`. See also `set_copy_flags`.

### `is_scale_copying(index: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the copy flags has the flag for the scale in the setting at `index`. See also `set_copy_flags`.

### `set_additive(index: int, enabled: bool) -> void`

Sets additive option in the setting at `index` to `enabled`. This mainly affects the process of applying transform to the `BoneConstraint3D.set_apply_bone`.
				If sets `enabled` to `true`, the processed transform is added to the pose of the current apply bone.
				If sets `enabled` to `false`, the pose of the current apply bone is replaced with the processed transform. However, if set `set_relative` to `true`, the transform is relative to rest.

### `set_axis_flags(index: int, axis_flags: int) -> void`

Sets the flags to copy axes. If the flag is valid, the axis is copied.

### `set_axis_x_enabled(index: int, enabled: bool) -> void`

If sets `enabled` to `true`, the X-axis will be copied.

### `set_axis_x_inverted(index: int, enabled: bool) -> void`

If sets `enabled` to `true`, the X-axis will be inverted.

### `set_axis_y_enabled(index: int, enabled: bool) -> void`

If sets `enabled` to `true`, the Y-axis will be copied.

### `set_axis_y_inverted(index: int, enabled: bool) -> void`

If sets `enabled` to `true`, the Y-axis will be inverted.

### `set_axis_z_enabled(index: int, enabled: bool) -> void`

If sets `enabled` to `true`, the Z-axis will be copied.

### `set_axis_z_inverted(index: int, enabled: bool) -> void`

If sets `enabled` to `true`, the Z-axis will be inverted.

### `set_copy_flags(index: int, copy_flags: int) -> void`

Sets the flags to process the transform operations. If the flag is valid, the transform operation is processed.
				**Note:** If the rotation is valid for only one axis, it respects the roll of the valid axis. If the rotation is valid for two axes, it discards the roll of the invalid axis.

### `set_copy_position(index: int, enabled: bool) -> void`

If sets `enabled` to `true`, the position will be copied.

### `set_copy_rotation(index: int, enabled: bool) -> void`

If sets `enabled` to `true`, the rotation will be copied.

### `set_copy_scale(index: int, enabled: bool) -> void`

If sets `enabled` to `true`, the scale will be copied.

### `set_invert_flags(index: int, axis_flags: int) -> void`

Sets the flags to inverte axes. If the flag is valid, the axis is copied.
				**Note:** An inverted scale means an inverse number, not a negative scale. For example, inverting `2.0` means `0.5`.
				**Note:** An inverted rotation flips the elements of the quaternion. For example, a two-axis inversion will flip the roll of each axis, and a three-axis inversion will flip the final orientation. However, be aware that flipping only one axis may cause unintended rotation by the unflipped axes, due to the characteristics of the quaternion.

### `set_relative(index: int, enabled: bool) -> void`

Sets relative option in the setting at `index` to `enabled`.
				If sets `enabled` to `true`, the extracted and applying transform is relative to the rest.
				If sets `enabled` to `false`, the extracted transform is absolute.

## 枚举

### `TransformFlag`

| 值 | 名称 | 说明 |
|---|---|---|
| `1` | `TRANSFORM_FLAG_POSITION` | （位标志） |
| `2` | `TRANSFORM_FLAG_ROTATION` | （位标志） |
| `4` | `TRANSFORM_FLAG_SCALE` | （位标志） |
| `7` | `TRANSFORM_FLAG_ALL` | （位标志） |

### `AxisFlag`

| 值 | 名称 | 说明 |
|---|---|---|
| `1` | `AXIS_FLAG_X` | （位标志） |
| `2` | `AXIS_FLAG_Y` | （位标志） |
| `4` | `AXIS_FLAG_Z` | （位标志） |
| `7` | `AXIS_FLAG_ALL` | （位标志） |

