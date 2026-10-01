# SkeletonModification2DStackHolder

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`SkeletonModification2DStackHolder` → `SkeletonModification2D` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/SkeletonModification2DStackHolder.md`

**摘要**：A modification that holds and executes a `SkeletonModificationStack2D`.

## 描述

This `SkeletonModification2D` holds a reference to a `SkeletonModificationStack2D`, allowing you to use multiple modification stacks on a single `Skeleton2D`.
		**Note:** The modifications in the held `SkeletonModificationStack2D` will only be executed if their execution mode matches the execution mode of the SkeletonModification2DStackHolder.

## 方法

### `get_held_modification_stack() -> SkeletonModificationStack2D`
- 限定：qualifiers=const

Returns the `SkeletonModificationStack2D` that this modification is holding.

### `set_held_modification_stack(held_modification_stack: SkeletonModificationStack2D) -> void`

Sets the `SkeletonModificationStack2D` that this modification is holding. This modification stack will then be executed when this modification is executed.

