# SplitContainer

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`SplitContainer` → `Container` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/SplitContainer.md`

**摘要**：A container that arranges child controls horizontally or vertically and provides grabbers for adjusting the split ratios between them.

## 描述

A container that arranges child controls horizontally or vertically and creates grabbers between them. The grabbers can be dragged around to change the size relations between the child controls.

## 属性

- **`collapsed`** `bool` = `false`
  - 其它属性：getter=is_collapsed · setter=set_collapsed
- **`drag_area_highlight_in_editor`** `bool` = `false`
  - 其它属性：getter=is_drag_area_highlight_in_editor_enabled · setter=set_drag_area_highlight_in_editor
- **`drag_area_margin_begin`** `int` = `0`
  - 其它属性：getter=get_drag_area_margin_begin · setter=set_drag_area_margin_begin
- **`drag_area_margin_end`** `int` = `0`
  - 其它属性：getter=get_drag_area_margin_end · setter=set_drag_area_margin_end
- **`drag_area_offset`** `int` = `0`
  - 其它属性：getter=get_drag_area_offset · setter=set_drag_area_offset
- **`drag_nested_intersections`** `bool` = `false`
  - 其它属性：getter=is_dragging_nested_intersections · setter=set_drag_nested_intersections
- **`dragger_visibility`** `int` = `0` · 枚举 `SplitContainer.DraggerVisibility`
  - 其它属性：getter=get_dragger_visibility · setter=set_dragger_visibility
- **`dragging_enabled`** `bool` = `true`
  - 其它属性：getter=is_dragging_enabled · setter=set_dragging_enabled
- **`split_offset`** `int` = `0`
  - 其它属性：deprecated=Use [member split_offsets] instead. The first element of the array is the split offset between the first two children. · getter=get_split_offset · setter=set_split_offset
- **`split_offsets`** `PackedInt32Array` = `PackedInt32Array(0)`
  - 其它属性：getter=get_split_offsets · setter=set_split_offsets
- **`touch_dragger_enabled`** `bool` = `false`
  - 其它属性：getter=is_touch_dragger_enabled · setter=set_touch_dragger_enabled
- **`vertical`** `bool` = `false`
  - 其它属性：getter=is_vertical · setter=set_vertical

## 方法

### `clamp_split_offset(priority_index: int = 0) -> void`

Clamps the `split_offsets` values to ensure they are within valid ranges and do not overlap with each other. When overlaps occur, this method prioritizes one split offset (at index `priority_index`) by clamping any overlapping split offsets to it.

### `get_drag_area_control() -> Control`
- 限定：deprecated=Use the first element of [method get_drag_area_controls] instead.

Returns the drag area `Control`. For example, you can move a pre-configured button into the drag area `Control` so that it rides along with the split bar. Try setting the `Button` anchors to `center` prior to the `reparent()` call.
				
```gdscript
				$BarnacleButton.reparent($SplitContainer.get_drag_area_control())
				
```

				**Note:** The drag area `Control` is drawn over the `SplitContainer`'s children, so `CanvasItem` draw objects called from the `Control` and children added to the `Control` will also appear over the `SplitContainer`'s children. Try setting `Control.mouse_filter` of custom children to `Control.MOUSE_FILTER_IGNORE` to prevent blocking the mouse from dragging if desired.
				**Warning:** This is a required internal node, removing and freeing it may cause a crash.

### `get_drag_area_controls() -> Control[]`

Returns an `Array` of the drag area `Control`s. These are the interactable `Control` nodes between each child. For example, this can be used to add a pre-configured button to a drag area `Control` so that it rides along with the split bar. Try setting the `Button` anchors to `center` prior to the `Node.reparent` call.
				
```gdscript
				$BarnacleButton.reparent($SplitContainer.get_drag_area_controls()[0])
				
```

				**Note:** The drag area `Control`s are drawn over the `SplitContainer`'s children, so `CanvasItem` draw objects called from a drag area and children added to it will also appear over the `SplitContainer`'s children. Try setting `Control.mouse_filter` of custom children to `Control.MOUSE_FILTER_IGNORE` to prevent blocking the mouse from dragging if desired.
				**Warning:** These are required internal nodes, removing or freeing them may cause a crash.

## 信号

### `drag_ended()`

Emitted when the user ends dragging.

### `drag_started()`

Emitted when the user starts dragging.

### `dragged(offset: int)`

Emitted when any dragger is dragged by user.

## 枚举

### `DraggerVisibility`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `DRAGGER_VISIBLE` |  |
| `1` | `DRAGGER_HIDDEN` |  |
| `2` | `DRAGGER_HIDDEN_COLLAPSED` |  |

## 主题属性

### `touch_dragger_color`
- data_type=color · default=Color(1, 1, 1, 0.3) · type=Color

### `touch_dragger_hover_color`
- data_type=color · default=Color(1, 1, 1, 0.6) · type=Color

### `touch_dragger_pressed_color`
- data_type=color · default=Color(1, 1, 1, 1) · type=Color

### `autohide`
- data_type=constant · default=1 · type=int

### `minimum_grab_thickness`
- data_type=constant · default=6 · type=int

### `separation`
- data_type=constant · default=12 · type=int

### `grabber`
- data_type=icon · type=Texture2D

### `h_grabber`
- data_type=icon · type=Texture2D

### `h_touch_dragger`
- data_type=icon · type=Texture2D

### `touch_dragger`
- data_type=icon · type=Texture2D

### `v_grabber`
- data_type=icon · type=Texture2D

### `v_touch_dragger`
- data_type=icon · type=Texture2D

### `split_bar_background`
- data_type=style · type=StyleBox

## 教程链接

- [Using Containers](None)

