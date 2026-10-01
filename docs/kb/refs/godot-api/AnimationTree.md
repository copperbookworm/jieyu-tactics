# AnimationTree

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AnimationTree` → `AnimationMixer` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AnimationTree.md`

**摘要**：A node used for advanced animation transitions in an `AnimationPlayer`.

## 描述

A node used for advanced animation transitions in an `AnimationPlayer`.
		**Note:** When linked with an `AnimationPlayer`, several properties and methods of the corresponding `AnimationPlayer` will not function as expected. Playback and transitions should be handled using only the `AnimationTree` and its constituent `AnimationNode`(s). The `AnimationPlayer` node should be used solely for adding, deleting, and editing animations.

## 属性

- **`advance_expression_base_node`** `NodePath` = `NodePath(".")`
  - 其它属性：getter=get_advance_expression_base_node · setter=set_advance_expression_base_node
- **`anim_player`** `NodePath` = `NodePath("")`
  - 其它属性：getter=get_animation_player · setter=set_animation_player
- **`callback_mode_discrete`** `int` = `2` · 枚举 `AnimationMixer.AnimationCallbackModeDiscrete`
  - 其它属性：getter=get_callback_mode_discrete · overrides=AnimationMixer · setter=set_callback_mode_discrete
- **`deterministic`** `bool` = `true`
  - 其它属性：getter=is_deterministic · overrides=AnimationMixer · setter=set_deterministic
- **`tree_root`** `AnimationRootNode`
  - 其它属性：getter=get_tree_root · setter=set_tree_root

## 方法

### `get_process_callback() -> int`
- 限定：deprecated=Use [member AnimationMixer.callback_mode_process] instead. · qualifiers=const

Returns the process notification in which to update animations.

### `set_process_callback(mode: int) -> void`
- 限定：deprecated=Use [member AnimationMixer.callback_mode_process] instead.

Sets the process notification in which to update animations.

## 信号

### `animation_player_changed()`

Emitted when the `anim_player` is changed.

## 枚举

### `AnimationProcessCallback`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ANIMATION_PROCESS_PHYSICS` |  |
| `1` | `ANIMATION_PROCESS_IDLE` |  |
| `2` | `ANIMATION_PROCESS_MANUAL` |  |

## 教程链接

- [Using AnimationTree](None)
- [Third Person Shooter (TPS) Demo](None)

