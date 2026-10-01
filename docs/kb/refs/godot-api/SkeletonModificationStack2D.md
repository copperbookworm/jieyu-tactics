# SkeletonModificationStack2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`SkeletonModificationStack2D` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/SkeletonModificationStack2D.md`

**摘要**：A resource that holds a stack of `SkeletonModification2D`s.

## 描述

This resource is used by the Skeleton and holds a stack of `SkeletonModification2D`s.
		This controls the order of the modifications and how they are applied. Modification order is especially important for full-body IK setups, as you need to execute the modifications in the correct order to get the desired results. For example, you want to execute a modification on the spine *before* the arms on a humanoid skeleton.
		This resource also controls how strongly all of the modifications are applied to the `Skeleton2D`.

## 属性

- **`enabled`** `bool` = `false`
  - 其它属性：getter=get_enabled · setter=set_enabled
- **`modification_count`** `int` = `0`
  - 其它属性：getter=get_modification_count · setter=set_modification_count
- **`strength`** `float` = `1.0`
  - 其它属性：getter=get_strength · setter=set_strength

## 方法

### `add_modification(modification: SkeletonModification2D) -> void`

Adds the passed-in `SkeletonModification2D` to the stack.

### `delete_modification(mod_idx: int) -> void`

Deletes the `SkeletonModification2D` at the index position `mod_idx`, if it exists.

### `enable_all_modifications(enabled: bool) -> void`

Enables all `SkeletonModification2D`s in the stack.

### `execute(delta: float, execution_mode: int) -> void`

Executes all of the `SkeletonModification2D`s in the stack that use the same execution mode as the passed-in `execution_mode`, starting from index `0` to `modification_count`.
				**Note:** The order of the modifications can matter depending on the modifications. For example, modifications on a spine should operate before modifications on the arms in order to get proper results.

### `get_is_setup() -> bool`
- 限定：qualifiers=const

Returns a boolean that indicates whether the modification stack is setup and can execute.

### `get_modification(mod_idx: int) -> SkeletonModification2D`
- 限定：qualifiers=const

Returns the `SkeletonModification2D` at the passed-in index, `mod_idx`.

### `get_skeleton() -> Skeleton2D`
- 限定：qualifiers=const

Returns the `Skeleton2D` node that the SkeletonModificationStack2D is bound to.

### `set_modification(mod_idx: int, modification: SkeletonModification2D) -> void`

Sets the modification at `mod_idx` to the passed-in modification, `modification`.

### `setup() -> void`

Sets up the modification stack so it can execute. This function should be called by `Skeleton2D` and shouldn't be manually called unless you know what you are doing.

