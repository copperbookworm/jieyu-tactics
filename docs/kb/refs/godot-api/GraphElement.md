# GraphElement

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`GraphElement` → `Container` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/GraphElement.md`

**摘要**：A container that represents a basic element that can be placed inside a `GraphEdit` control.

## 描述

`GraphElement` allows to create custom elements for a `GraphEdit` graph. By default such elements can be selected, resized, and repositioned, but they cannot be connected. For a graph element that allows for connections see `GraphNode`.

## 属性

- **`draggable`** `bool` = `true`
  - 其它属性：getter=is_draggable · setter=set_draggable
- **`position_offset`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_position_offset · setter=set_position_offset
- **`resizable`** `bool` = `false`
  - 其它属性：getter=is_resizable · setter=set_resizable
- **`scaling_menus`** `bool` = `false`
  - 其它属性：getter=is_scaling_menus · setter=set_scaling_menus
- **`selectable`** `bool` = `true`
  - 其它属性：getter=is_selectable · setter=set_selectable
- **`selected`** `bool` = `false`
  - 其它属性：getter=is_selected · setter=set_selected

## 信号

### `delete_request()`

Emitted when removing the GraphElement is requested.

### `dragged(from: Vector2, to: Vector2)`

Emitted when the GraphElement is dragged.

### `node_deselected()`

Emitted when the GraphElement is deselected.

### `node_selected()`

Emitted when the GraphElement is selected.

### `position_offset_changed()`

Emitted when the GraphElement is moved.

### `raise_request()`

Emitted when displaying the GraphElement over other ones is requested. Happens on focusing (clicking into) the GraphElement.

### `resize_end(new_size: Vector2)`

Emitted when releasing the mouse button after dragging the resizer handle (see `resizable`).

### `resize_request(new_size: Vector2)`

Emitted when resizing the GraphElement is requested. Happens on dragging the resizer handle (see `resizable`).

## 主题属性

### `resizer`
- data_type=icon · type=Texture2D

