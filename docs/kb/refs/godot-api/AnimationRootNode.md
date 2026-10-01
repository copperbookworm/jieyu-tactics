# AnimationRootNode

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AnimationRootNode` → `AnimationNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AnimationRootNode.md`

**摘要**：Base class for `AnimationNode`s that hold one or multiple composite animations. Usually used for `AnimationTree.tree_root`.

## 描述

`AnimationRootNode` is a base class for `AnimationNode`s that hold a complete animation. A complete animation refers to the output of an `AnimationNodeOutput` in an `AnimationNodeBlendTree` or the output of another `AnimationRootNode`. Used for `AnimationTree.tree_root` or in other `AnimationRootNode`s.
		Examples of built-in root nodes include `AnimationNodeBlendTree` (allows blending nodes between each other using various modes), `AnimationNodeStateMachine` (allows to configure blending and transitions between nodes using a state machine pattern), `AnimationNodeBlendSpace2D` (allows linear blending between **three** `AnimationNode`s), `AnimationNodeBlendSpace1D` (allows linear blending only between **two** `AnimationNode`s).

## 教程链接

- [Using AnimationTree](None)

