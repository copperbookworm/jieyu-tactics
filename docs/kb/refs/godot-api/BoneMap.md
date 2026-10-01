# BoneMap

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`BoneMap` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/BoneMap.md`

**摘要**：Describes a mapping of bone names for retargeting `Skeleton3D` into common names defined by a `SkeletonProfile`.

## 描述

This class contains a dictionary that uses a list of bone names in `SkeletonProfile` as key names.
		By assigning the actual `Skeleton3D` bone name as the key value, it maps the `Skeleton3D` to the `SkeletonProfile`.

## 属性

- **`profile`** `SkeletonProfile`
  - 其它属性：getter=get_profile · setter=set_profile

## 方法

### `find_profile_bone_name(skeleton_bone_name: StringName) -> StringName`
- 限定：qualifiers=const

Returns a profile bone name having `skeleton_bone_name`. If not found, an empty `StringName` will be returned.
				In the retargeting process, the returned bone name is the bone name of the target skeleton.

### `get_skeleton_bone_name(profile_bone_name: StringName) -> StringName`
- 限定：qualifiers=const

Returns a skeleton bone name is mapped to `profile_bone_name`.
				In the retargeting process, the returned bone name is the bone name of the source skeleton.

### `set_skeleton_bone_name(profile_bone_name: StringName, skeleton_bone_name: StringName) -> void`

Maps a skeleton bone name to `profile_bone_name`.
				In the retargeting process, the setting bone name is the bone name of the source skeleton.

## 信号

### `bone_map_updated()`

This signal is emitted when change the key value in the `BoneMap`. This is used to validate mapping and to update `BoneMap` editor.

### `profile_updated()`

This signal is emitted when change the value in profile or change the reference of profile. This is used to update key names in the `BoneMap` and to redraw the `BoneMap` editor.

## 教程链接

- [Retargeting 3D Skeletons](None)

