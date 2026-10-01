# FoldableGroup

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`FoldableGroup` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core · keywords=expandable, collapsible, collapse
> 自动生成，勿手改。文件：`refs/godot-api/FoldableGroup.md`

**摘要**：A group of foldable containers that doesn't allow more than one container to be expanded at a time.

## 描述

A group of `FoldableContainer`-derived nodes. Only one container can be expanded at a time.

## 属性

- **`allow_folding_all`** `bool` = `false`
  - 其它属性：getter=is_allow_folding_all · setter=set_allow_folding_all
- **`resource_local_to_scene`** `bool` = `true`
  - 其它属性：getter=is_local_to_scene · overrides=Resource · setter=set_local_to_scene

## 方法

### `get_containers() -> FoldableContainer[]`
- 限定：qualifiers=const

Returns an `Array` of `FoldableContainer`s that have this as their FoldableGroup (see `FoldableContainer.foldable_group`). This is equivalent to `ButtonGroup` but for FoldableContainers.

### `get_expanded_container() -> FoldableContainer`
- 限定：qualifiers=const

Returns the current expanded container.

## 信号

### `expanded(container: FoldableContainer)`

Emitted when one of the containers of the group is expanded.

