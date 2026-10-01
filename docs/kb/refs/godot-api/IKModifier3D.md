# IKModifier3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`IKModifier3D` → `SkeletonModifier3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/IKModifier3D.md`

**摘要**：A node for inverse kinematics which may modify more than one bone.

## 描述

Base class of `SkeletonModifier3D`s that has some joint lists and applies inverse kinematics. This class has some structs, enums, and helper methods which are useful to solve inverse kinematics.

## 属性

- **`mutable_bone_axes`** `bool` = `true`
  - 其它属性：getter=are_bone_axes_mutable · setter=set_mutable_bone_axes

## 方法

### `clear_settings() -> void`

Clears all settings.

### `get_setting_count() -> int`
- 限定：qualifiers=const

Returns the number of settings.

### `reset() -> void`

Resets a state with respect to the current bone pose.

### `set_setting_count(count: int) -> void`

Sets the number of settings.

## 教程链接

- [Inverse Kinematics Returns to Godot 4.6 - IKModifier3D](None)

