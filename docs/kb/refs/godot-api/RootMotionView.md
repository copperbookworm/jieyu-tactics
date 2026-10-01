# RootMotionView

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`RootMotionView` → `VisualInstance3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/RootMotionView.md`

**摘要**：Editor-only helper for setting up root motion in `AnimationMixer`.

## 描述

*Root motion* refers to an animation technique where a mesh's skeleton is used to give impulse to a character. When working with 3D animations, a popular technique is for animators to use the root skeleton bone to give motion to the rest of the skeleton. This allows animating characters in a way where steps actually match the floor below. It also allows precise interaction with objects during cinematics. See also `AnimationMixer`.
		**Note:** `RootMotionView` is only visible in the editor. It will be hidden automatically in the running project.

## 属性

- **`animation_path`** `NodePath` = `NodePath("")`
  - 其它属性：getter=get_animation_path · setter=set_animation_path
- **`cell_size`** `float` = `1.0`
  - 其它属性：getter=get_cell_size · setter=set_cell_size
- **`color`** `Color` = `Color(0.5, 0.5, 1, 1)`
  - 其它属性：getter=get_color · keywords=colour · setter=set_color
- **`radius`** `float` = `10.0`
  - 其它属性：getter=get_radius · setter=set_radius
- **`zero_y`** `bool` = `true`
  - 其它属性：getter=get_zero_y · setter=set_zero_y

## 教程链接

- [Using AnimationTree - Root motion](None)

