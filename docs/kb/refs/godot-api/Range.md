# Range

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Range` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Range.md`

**摘要**：Abstract base class for controls that represent a number within a range.

## 描述

Range is an abstract base class for controls that represent a number within a range, using a configured `step` and `page` size. See e.g. `ScrollBar` and `Slider` for examples of higher-level nodes using Range.

## 属性

- **`allow_greater`** `bool` = `false`
  - 其它属性：getter=is_greater_allowed · setter=set_allow_greater
- **`allow_lesser`** `bool` = `false`
  - 其它属性：getter=is_lesser_allowed · setter=set_allow_lesser
- **`exp_edit`** `bool` = `false`
  - 其它属性：getter=is_ratio_exp · setter=set_exp_ratio
- **`max_value`** `float` = `100.0`
  - 其它属性：getter=get_max · setter=set_max
- **`min_value`** `float` = `0.0`
  - 其它属性：getter=get_min · setter=set_min
- **`page`** `float` = `0.0`
  - 其它属性：getter=get_page · setter=set_page
- **`ratio`** `float`
  - 其它属性：getter=get_as_ratio · setter=set_as_ratio
- **`rounded`** `bool` = `false`
  - 其它属性：getter=is_using_rounded_values · setter=set_use_rounded_values
- **`size_flags_vertical`** `int` = `0` · 枚举 `Control.SizeFlags` · 位标志
  - 其它属性：getter=get_v_size_flags · is_bitfield=true · overrides=Control · setter=set_v_size_flags
- **`step`** `float` = `0.01`
  - 其它属性：getter=get_step · setter=set_step
- **`value`** `float` = `0.0`
  - 其它属性：getter=get_value · setter=set_value

## 方法

### `_value_changed(new_value: float) -> void`
- 限定：qualifiers=virtual

Called when the `Range`'s value is changed (following the same conditions as `value_changed`).

### `set_value_no_signal(value: float) -> void`

Sets the `Range`'s current value to the specified `value`, without emitting the `value_changed` signal.

### `share(with: Node) -> void`

Binds two `Range`s together along with any ranges previously grouped with either of them. When any of range's member variables change, it will share the new value with all other ranges in its group.

### `unshare() -> void`

Stops the `Range` from sharing its member variables with any other.

## 信号

### `changed()`

Emitted when `min_value`, `max_value`, `page`, or `step` change.

### `value_changed(value: float)`

Emitted when `value` changes. When used on a `Slider`, this is called continuously while dragging (potentially every frame). If you are performing an expensive operation in a function connected to `value_changed`, consider using a *debouncing* `Timer` to call the function less often.
				**Note:** Unlike signals such as `LineEdit.text_changed`, `value_changed` is also emitted when `value` is set directly via code.

