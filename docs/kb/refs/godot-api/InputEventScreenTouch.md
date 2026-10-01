# InputEventScreenTouch

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`InputEventScreenTouch` → `InputEventFromWindow` → `InputEvent` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/InputEventScreenTouch.md`

**摘要**：Represents a screen touch event.

## 描述

Stores information about multi-touch press/release input events. Supports touch press, touch release and `index` for multi-touch count and order.

## 属性

- **`canceled`** `bool` = `false`
  - 其它属性：getter=is_canceled · setter=set_canceled
- **`double_tap`** `bool` = `false`
  - 其它属性：getter=is_double_tap · setter=set_double_tap
- **`index`** `int` = `0`
  - 其它属性：getter=get_index · setter=set_index
- **`position`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_position · setter=set_position
- **`pressed`** `bool` = `false`
  - 其它属性：getter=is_pressed · setter=set_pressed

## 教程链接

- [Using InputEvent](None)

