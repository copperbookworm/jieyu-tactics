# AnimationNodeBlend3

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AnimationNodeBlend3` → `AnimationNodeSync` → `AnimationNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AnimationNodeBlend3.md`

**摘要**：Blends two of three animations linearly inside of an `AnimationNodeBlendTree`.

## 描述

A resource to add to an `AnimationNodeBlendTree`. Blends two animations out of three linearly out of three based on the amount value.
		This animation node has three inputs:
		- The base animation to blend with
		- A "-blend" animation to blend with when the blend amount is negative value
		- A "+blend" animation to blend with when the blend amount is positive value
		In general, the blend value should be in the `[-1.0, 1.0]` range. Values outside of this range can blend amplified animations, however, `AnimationNodeAdd3` works better for this purpose.

## 教程链接

- [Using AnimationTree](None)

