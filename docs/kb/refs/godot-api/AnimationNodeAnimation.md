# AnimationNodeAnimation

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AnimationNodeAnimation` → `AnimationRootNode` → `AnimationNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AnimationNodeAnimation.md`

**摘要**：An input animation for an `AnimationNodeBlendTree`.

## 描述

A resource to add to an `AnimationNodeBlendTree`. Only has one output port using the `animation` property. Used as an input for `AnimationNode`s that blend animations together.

## 属性

- **`advance_on_start`** `bool` = `false`
  - 其它属性：getter=is_advance_on_start · setter=set_advance_on_start
- **`animation`** `StringName` = `&""`
  - 其它属性：getter=get_animation · setter=set_animation
- **`loop_mode`** `int` · 枚举 `Animation.LoopMode`
  - 其它属性：getter=get_loop_mode · setter=set_loop_mode
- **`play_mode`** `int` = `0` · 枚举 `AnimationNodeAnimation.PlayMode`
  - 其它属性：getter=get_play_mode · setter=set_play_mode
- **`start_offset`** `float`
  - 其它属性：getter=get_start_offset · setter=set_start_offset
- **`stretch_time_scale`** `bool`
  - 其它属性：getter=is_stretching_time_scale · setter=set_stretch_time_scale
- **`timeline_length`** `float`
  - 其它属性：getter=get_timeline_length · setter=set_timeline_length
- **`use_custom_timeline`** `bool` = `false`
  - 其它属性：getter=is_using_custom_timeline · setter=set_use_custom_timeline

## 枚举

### `PlayMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `PLAY_MODE_FORWARD` |  |
| `1` | `PLAY_MODE_BACKWARD` |  |

## 教程链接

- [Using AnimationTree](None)
- [3D Platformer Demo](None)
- [Third Person Shooter (TPS) Demo](None)

