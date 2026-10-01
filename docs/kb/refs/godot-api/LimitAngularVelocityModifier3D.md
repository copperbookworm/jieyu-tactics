# LimitAngularVelocityModifier3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`LimitAngularVelocityModifier3D` → `SkeletonModifier3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/LimitAngularVelocityModifier3D.md`

**摘要**：Limit bone rotation angular velocity.

## 描述

This modifier limits bone rotation angular velocity by comparing poses between previous and current frame.
		You can add bone chains by specifying their root and end bones, then add the bones between them to a list. Modifier processes either that list or the bones excluding those in the list depending on the option `exclude`.
		**Note:** Most methods in this class take an `index` parameter. This parameter specifies which setting list entry to return if the IK has multiple entries (e.g. `settings/<index>/root_bone_name`).

## 属性

- **`chain_count`** `int` = `0`
  - 其它属性：getter=get_chain_count · setter=set_chain_count
- **`exclude`** `bool` = `false`
  - 其它属性：getter=is_exclude · setter=set_exclude
- **`joint_count`** `int` = `0`
  - 其它属性：getter=_get_joint_count · setter=
- **`max_angular_velocity`** `float` = `6.2831855`
  - 其它属性：getter=get_max_angular_velocity · setter=set_max_angular_velocity

## 方法

### `clear_chains() -> void`

Clear all chains.

### `get_end_bone(index: int) -> int`
- 限定：qualifiers=const

Returns the end bone index of the bone chain.

### `get_end_bone_name(index: int) -> String`
- 限定：qualifiers=const

Returns the end bone name of the bone chain.

### `get_root_bone(index: int) -> int`
- 限定：qualifiers=const

Returns the root bone index of the bone chain.

### `get_root_bone_name(index: int) -> String`
- 限定：qualifiers=const

Returns the root bone name of the bone chain.

### `reset() -> void`

Sets the reference pose for angle comparison to the current pose with the influence of constraints removed. This function is automatically triggered when joints change or upon activation.

### `set_end_bone(index: int, bone: int) -> void`

Sets the end bone index of the bone chain.

### `set_end_bone_name(index: int, bone_name: String) -> void`

Sets the end bone name of the bone chain.
				**Note:** End bone must be the root bone or a child of the root bone.

### `set_root_bone(index: int, bone: int) -> void`

Sets the root bone index of the bone chain.

### `set_root_bone_name(index: int, bone_name: String) -> void`

Sets the root bone name of the bone chain.

