# RetargetModifier3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`RetargetModifier3D` → `SkeletonModifier3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/RetargetModifier3D.md`

**摘要**：A modifier to transfer parent skeleton poses (or global poses) to child skeletons in model space with different rests.

## 描述

Retrieves the pose (or global pose) relative to the parent Skeleton's rest in model space and transfers it to the child Skeleton.
		This modifier rewrites the pose of the child skeleton directly in the parent skeleton's update process. This means that it overwrites the mapped bone pose set in the normal process on the target skeleton. If you want to set the target skeleton bone pose after retargeting, you will need to add a `SkeletonModifier3D` child to the target skeleton and thereby modify the pose.
		**Note:** When the `use_global_pose` is enabled, even if it is an unmapped bone, it can cause visual problems because the global pose is applied ignoring the parent bone's pose **if it has mapped bone children**. See also `use_global_pose`.

## 属性

- **`enable`** `int` = `7` · 枚举 `RetargetModifier3D.TransformFlag` · 位标志
  - 其它属性：getter=get_enable_flags · is_bitfield=true · setter=set_enable_flags
- **`profile`** `SkeletonProfile`
  - 其它属性：getter=get_profile · setter=set_profile
- **`use_global_pose`** `bool` = `false`
  - 其它属性：getter=is_using_global_pose · setter=set_use_global_pose

## 方法

### `is_position_enabled() -> bool`
- 限定：qualifiers=const

Returns `true` if `enable` has `TRANSFORM_FLAG_POSITION`.

### `is_rotation_enabled() -> bool`
- 限定：qualifiers=const

Returns `true` if `enable` has `TRANSFORM_FLAG_ROTATION`.

### `is_scale_enabled() -> bool`
- 限定：qualifiers=const

Returns `true` if `enable` has `TRANSFORM_FLAG_SCALE`.

### `set_position_enabled(enabled: bool) -> void`

Sets `TRANSFORM_FLAG_POSITION` into `enable`.

### `set_rotation_enabled(enabled: bool) -> void`

Sets `TRANSFORM_FLAG_ROTATION` into `enable`.

### `set_scale_enabled(enabled: bool) -> void`

Sets `TRANSFORM_FLAG_SCALE` into `enable`.

## 枚举

### `TransformFlag`

| 值 | 名称 | 说明 |
|---|---|---|
| `1` | `TRANSFORM_FLAG_POSITION` | （位标志） |
| `2` | `TRANSFORM_FLAG_ROTATION` | （位标志） |
| `4` | `TRANSFORM_FLAG_SCALE` | （位标志） |
| `7` | `TRANSFORM_FLAG_ALL` | （位标志） |

