# AnimationLibrary

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AnimationLibrary` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AnimationLibrary.md`

**摘要**：Container for `Animation` resources.

## 描述

An animation library stores a set of animations accessible through `StringName` keys, for use with `AnimationPlayer` nodes.

## 方法

### `add_animation(name: StringName, animation: Animation) -> int`

Adds the `animation` to the library, accessible by the key `name`.

### `get_animation(name: StringName) -> Animation`
- 限定：qualifiers=const

Returns the `Animation` with the key `name`. If the animation does not exist, `null` is returned and an error is logged.

### `get_animation_list() -> StringName[]`
- 限定：qualifiers=const

Returns the keys for the `Animation`s stored in the library.

### `get_animation_list_size() -> int`
- 限定：qualifiers=const

Returns the key count for the `Animation`s stored in the library.

### `has_animation(name: StringName) -> bool`
- 限定：qualifiers=const

Returns `true` if the library stores an `Animation` with `name` as the key.

### `remove_animation(name: StringName) -> void`

Removes the `Animation` with the key `name`.

### `rename_animation(name: StringName, newname: StringName) -> void`

Changes the key of the `Animation` associated with the key `name` to `newname`.

## 信号

### `animation_added(anim_name: StringName)`

Emitted when an `Animation` is added, under the key `anim_name`.

### `animation_changed(anim_name: StringName)`

Emitted when there's a change in one of the animations, e.g. tracks are added, moved or have changed paths. `anim_name` is the key of the animation that was changed.
				See also `Resource.changed`, which this acts as a relay for.

### `animation_removed(anim_name: StringName)`

Emitted when an `Animation` stored with the key `anim_name` is removed.

### `animation_renamed(old_name: StringName, new_name: StringName)`

Emitted when the key for an `Animation` is changed, from `old_name` to `new_name`.

## 教程链接

- [Animation tutorial index](None)

