# AnimationNodeAdd3

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AnimationNodeAdd3` → `AnimationNodeSync` → `AnimationNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AnimationNodeAdd3.md`

**摘要**：Blends two of three animations additively inside of an `AnimationNodeBlendTree`.

## 描述

A resource to add to an `AnimationNodeBlendTree`. Blends two animations out of three additively out of three based on the amount value.
		This animation node has three inputs:
		- The base animation to add to
		- A "-add" animation to blend with when the blend amount is negative
		- A "+add" animation to blend with when the blend amount is positive
		If the absolute value of the amount is greater than `1.0`, the animation connected to "in" port is blended with the amplified animation connected to "-add"/"+add" port.
		**Note:** The signs are only used to distinguish ports, and additive blending occurs based on absolute values always, meaning the animation of a "-add" port does not subtract from the animation of an "in" port.

## 教程链接

- [Using AnimationTree](None)
- [Third Person Shooter (TPS) Demo](None)

