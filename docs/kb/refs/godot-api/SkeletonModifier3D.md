# SkeletonModifier3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`SkeletonModifier3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/SkeletonModifier3D.md`

**摘要**：A node that may modify a Skeleton3D's bones.

## 描述

`SkeletonModifier3D` retrieves a target `Skeleton3D` by having a `Skeleton3D` parent.
		If there is an `AnimationMixer`, a modification always performs after playback process of the `AnimationMixer`.
		This node should be used to implement custom IK solvers, constraints, or skeleton physics.

## 属性

- **`active`** `bool` = `true`
  - 其它属性：getter=is_active · setter=set_active
- **`influence`** `float` = `1.0`
  - 其它属性：getter=get_influence · setter=set_influence

## 方法

### `_process_modification() -> void`
- 限定：deprecated=Use [method _process_modification_with_delta] instead. · qualifiers=virtual

Override this virtual method to implement a custom skeleton modifier. You should do things like get the `Skeleton3D`'s current pose and apply the pose here.
				`_process_modification` must not apply `influence` to bone poses because the `Skeleton3D` automatically applies influence to all bone poses set by the modifier.

### `_process_modification_with_delta(delta: float) -> void`
- 限定：qualifiers=virtual

Override this virtual method to implement a custom skeleton modifier. You should do things like get the `Skeleton3D`'s current pose and apply the pose here.
				`_process_modification_with_delta` must not apply `influence` to bone poses because the `Skeleton3D` automatically applies influence to all bone poses set by the modifier.
				`delta` is passed from parent `Skeleton3D`. See also `Skeleton3D.advance`.
				**Note:** This method may be called outside `Node._process` and `Node._physics_process` with `delta` is `0.0`, since the modification should be processed immediately after initialization of the `Skeleton3D`.

### `_skeleton_changed(old_skeleton: Skeleton3D, new_skeleton: Skeleton3D) -> void`
- 限定：qualifiers=virtual

Called when the skeleton is changed.

### `_validate_bone_names() -> void`
- 限定：qualifiers=virtual

Called when bone names and indices need to be validated, such as when entering the scene tree or changing skeleton.

### `get_skeleton() -> Skeleton3D`
- 限定：qualifiers=const

Returns the parent `Skeleton3D` node if it exists. Otherwise, returns `null`.

## 信号

### `modification_processed()`

Notifies when the modification have been finished.
				**Note:** If you want to get the modified bone pose by the modifier, you must use `Skeleton3D.get_bone_pose` or `Skeleton3D.get_bone_global_pose` at the moment this signal is fired.

## 枚举

### `BoneAxis`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `BONE_AXIS_PLUS_X` |  |
| `1` | `BONE_AXIS_MINUS_X` |  |
| `2` | `BONE_AXIS_PLUS_Y` |  |
| `3` | `BONE_AXIS_MINUS_Y` |  |
| `4` | `BONE_AXIS_PLUS_Z` |  |
| `5` | `BONE_AXIS_MINUS_Z` |  |

### `BoneDirection`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `BONE_DIRECTION_PLUS_X` |  |
| `1` | `BONE_DIRECTION_MINUS_X` |  |
| `2` | `BONE_DIRECTION_PLUS_Y` |  |
| `3` | `BONE_DIRECTION_MINUS_Y` |  |
| `4` | `BONE_DIRECTION_PLUS_Z` |  |
| `5` | `BONE_DIRECTION_MINUS_Z` |  |
| `6` | `BONE_DIRECTION_FROM_PARENT` |  |

### `SecondaryDirection`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SECONDARY_DIRECTION_NONE` |  |
| `1` | `SECONDARY_DIRECTION_PLUS_X` |  |
| `2` | `SECONDARY_DIRECTION_MINUS_X` |  |
| `3` | `SECONDARY_DIRECTION_PLUS_Y` |  |
| `4` | `SECONDARY_DIRECTION_MINUS_Y` |  |
| `5` | `SECONDARY_DIRECTION_PLUS_Z` |  |
| `6` | `SECONDARY_DIRECTION_MINUS_Z` |  |
| `7` | `SECONDARY_DIRECTION_CUSTOM` |  |

### `RotationAxis`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ROTATION_AXIS_X` |  |
| `1` | `ROTATION_AXIS_Y` |  |
| `2` | `ROTATION_AXIS_Z` |  |
| `3` | `ROTATION_AXIS_ALL` |  |
| `4` | `ROTATION_AXIS_CUSTOM` |  |

## 教程链接

- [Design of the Skeleton Modifier 3D](None)

