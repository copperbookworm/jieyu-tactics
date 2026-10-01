# Container

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Container` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Container.md`

**摘要**：Base class for all GUI containers.

## 描述

Base class for all GUI containers. A `Container` automatically arranges its child controls in a certain way. This class can be inherited to make custom container types.

## 属性

- **`accessibility_region`** `bool` = `false`
  - 其它属性：getter=is_accessibility_region · setter=set_accessibility_region
- **`mouse_filter`** `int` = `1` · 枚举 `Control.MouseFilter`
  - 其它属性：getter=get_mouse_filter · overrides=Control · setter=set_mouse_filter
- **`propagate_maximum_size`** `bool` = `true`
  - 其它属性：getter=is_propagating_maximum_size · overrides=Control · setter=set_propagate_maximum_size

## 方法

### `_get_allowed_size_flags_horizontal() -> PackedInt32Array`
- 限定：qualifiers=virtual const

Implement to return a list of allowed horizontal `Control.SizeFlags` for child nodes. This doesn't technically prevent the usages of any other size flags, if your implementation requires that. This only limits the options available to the user in the Inspector dock.
				**Note:** Having no size flags is equal to having `Control.SIZE_SHRINK_BEGIN`. As such, this value is always implicitly allowed.

### `_get_allowed_size_flags_vertical() -> PackedInt32Array`
- 限定：qualifiers=virtual const

Implement to return a list of allowed vertical `Control.SizeFlags` for child nodes. This doesn't technically prevent the usages of any other size flags, if your implementation requires that. This only limits the options available to the user in the Inspector dock.
				**Note:** Having no size flags is equal to having `Control.SIZE_SHRINK_BEGIN`. As such, this value is always implicitly allowed.

### `fit_child_in_rect(child: Control, rect: Rect2) -> void`

Fit a child control in a given rect. This is mainly a helper for creating custom container classes.

### `queue_sort() -> void`

Queue resort of the contained children. This is called automatically anyway, but can be called upon request.

## 信号

### `pre_sort_children()`

Emitted when children are going to be sorted.

### `sort_children()`

Emitted when sorting the children is needed.

## 常量

- **`NOTIFICATION_PRE_SORT_CHILDREN`** = `50`
- **`NOTIFICATION_SORT_CHILDREN`** = `51`
## 教程链接

- [Using Containers](None)

