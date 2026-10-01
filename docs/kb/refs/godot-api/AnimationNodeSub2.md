# AnimationNodeSub2

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AnimationNodeSub2` → `AnimationNodeSync` → `AnimationNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AnimationNodeSub2.md`

**摘要**：Blends two animations subtractively inside of an `AnimationNodeBlendTree`.

## 描述

A resource to add to an `AnimationNodeBlendTree`. Blends two animations subtractively based on the amount value.
		This animation node is usually used for pre-calculation to cancel out any extra poses from the animation for the "add" animation source in `AnimationNodeAdd2` or `AnimationNodeAdd3`.
		In general, the blend value should be in the `[0.0, 1.0]` range, but values outside of this range can be used for amplified or inverted animations.
		**Note:** This calculation is different from using a negative value in `AnimationNodeAdd2`, since the transformation matrices do not satisfy the commutative law. `AnimationNodeSub2` multiplies the transformation matrix of the inverted animation from the left side, while negative `AnimationNodeAdd2` multiplies it from the right side.

## 教程链接

- [AnimationTree](None)

