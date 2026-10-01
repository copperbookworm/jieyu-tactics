# AnimationNodeAdd2

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AnimationNodeAdd2` → `AnimationNodeSync` → `AnimationNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AnimationNodeAdd2.md`

**摘要**：Blends two animations additively inside of an `AnimationNodeBlendTree`.

## 描述

A resource to add to an `AnimationNodeBlendTree`. Blends two animations additively based on the amount value.
		If the amount is greater than `1.0`, the animation connected to "in" port is blended with the amplified animation connected to "add" port.
		If the amount is less than `0.0`, the animation connected to "in" port is blended with the inverted animation connected to "add" port.

## 教程链接

- [Using AnimationTree](None)

