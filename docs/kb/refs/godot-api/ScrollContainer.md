# ScrollContainer

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ScrollContainer` → `Container` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/ScrollContainer.md`

**摘要**：A container used to provide scrollbars to a child control when needed.

## 描述

A container used to provide a child control with scrollbars when needed. Scrollbars will automatically be drawn at the right (for vertical) or bottom (for horizontal) and will enable dragging to move the viewable Control (and its children) within the ScrollContainer. Scrollbars will also automatically resize the grabber based on the `Control.custom_minimum_size` of the Control relative to the ScrollContainer.

## 属性

- **`clip_contents`** `bool` = `true`
  - 其它属性：getter=is_clipping_contents · overrides=Control · setter=set_clip_contents
- **`draw_focus_border`** `bool` = `false`
  - 其它属性：getter=get_draw_focus_border · setter=set_draw_focus_border
- **`follow_focus`** `bool` = `false`
  - 其它属性：getter=is_following_focus · setter=set_follow_focus
- **`horizontal_scroll_mode`** `int` = `1` · 枚举 `ScrollContainer.ScrollMode`
  - 其它属性：getter=get_horizontal_scroll_mode · setter=set_horizontal_scroll_mode
- **`propagate_maximum_size`** `bool` = `false`
  - 其它属性：getter=is_propagating_maximum_size · overrides=Control · setter=set_propagate_maximum_size
- **`scroll_deadzone`** `int` = `0`
  - 其它属性：getter=get_deadzone · setter=set_deadzone
- **`scroll_hint_mode`** `int` = `0` · 枚举 `ScrollContainer.ScrollHintMode`
  - 其它属性：getter=get_scroll_hint_mode · setter=set_scroll_hint_mode
- **`scroll_horizontal`** `int` = `0`
  - 其它属性：getter=get_h_scroll · setter=set_h_scroll
- **`scroll_horizontal_by_default`** `bool` = `false`
  - 其它属性：getter=is_scroll_horizontal_by_default · setter=set_scroll_horizontal_by_default
- **`scroll_horizontal_custom_step`** `float` = `-1.0`
  - 其它属性：getter=get_horizontal_custom_step · setter=set_horizontal_custom_step
- **`scroll_vertical`** `int` = `0`
  - 其它属性：getter=get_v_scroll · setter=set_v_scroll
- **`scroll_vertical_custom_step`** `float` = `-1.0`
  - 其它属性：getter=get_vertical_custom_step · setter=set_vertical_custom_step
- **`tile_scroll_hint`** `bool` = `false`
  - 其它属性：getter=is_scroll_hint_tiled · setter=set_tile_scroll_hint
- **`vertical_scroll_mode`** `int` = `1` · 枚举 `ScrollContainer.ScrollMode`
  - 其它属性：getter=get_vertical_scroll_mode · setter=set_vertical_scroll_mode

## 方法

### `ensure_control_visible(control: Control) -> void`

Ensures the given `control` is visible (must be a direct or indirect child of the ScrollContainer). Used by `follow_focus`.
				**Note:** This will not work on a node that was just added during the same frame. If you want to scroll to a newly added child, you must wait until the next frame using `SceneTree.process_frame`:
				
```gdscript
				add_child(child_node)
				await get_tree().process_frame
				ensure_control_visible(child_node)
				
```

### `get_h_scroll_bar() -> HScrollBar`

Returns the horizontal scrollbar `HScrollBar` of this `ScrollContainer`.
				**Warning:** This is a required internal node, removing and freeing it may cause a crash. If you wish to disable or hide a scrollbar, you can use `horizontal_scroll_mode`.

### `get_v_scroll_bar() -> VScrollBar`

Returns the vertical scrollbar `VScrollBar` of this `ScrollContainer`.
				**Warning:** This is a required internal node, removing and freeing it may cause a crash. If you wish to disable or hide a scrollbar, you can use `vertical_scroll_mode`.

## 信号

### `scroll_ended()`

Emitted when scrolling stops when dragging the scrollable area *with a touch event*. This signal is *not* emitted when scrolling by dragging the scrollbar, scrolling with the mouse wheel or scrolling with keyboard/gamepad events.
				**Note:** This signal is only emitted on Android or iOS, or on desktop/web platforms when `ProjectSettings.input_devices/pointing/emulate_touch_from_mouse` is enabled.

### `scroll_started()`

Emitted when scrolling starts when dragging the scrollable area *with a touch event*. This signal is *not* emitted when scrolling by dragging the scrollbar, scrolling with the mouse wheel or scrolling with keyboard/gamepad events.
				**Note:** This signal is only emitted on Android or iOS, or on desktop/web platforms when `ProjectSettings.input_devices/pointing/emulate_touch_from_mouse` is enabled.

## 枚举

### `ScrollMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SCROLL_MODE_DISABLED` |  |
| `1` | `SCROLL_MODE_AUTO` |  |
| `2` | `SCROLL_MODE_SHOW_ALWAYS` |  |
| `3` | `SCROLL_MODE_SHOW_NEVER` |  |
| `4` | `SCROLL_MODE_RESERVE` |  |
| `5` | `SCROLL_MODE_MAXIMIZE_FIRST` |  |

### `ScrollHintMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SCROLL_HINT_MODE_DISABLED` |  |
| `1` | `SCROLL_HINT_MODE_ALL` |  |
| `2` | `SCROLL_HINT_MODE_TOP_AND_LEFT` |  |
| `3` | `SCROLL_HINT_MODE_BOTTOM_AND_RIGHT` |  |

## 主题属性

### `scroll_hint_horizontal_color`
- data_type=color · default=Color(0, 0, 0, 1) · type=Color

### `scroll_hint_vertical_color`
- data_type=color · default=Color(0, 0, 0, 1) · type=Color

### `scrollbar_h_separation`
- data_type=constant · default=0 · type=int

### `scrollbar_v_separation`
- data_type=constant · default=0 · type=int

### `scroll_hint_horizontal`
- data_type=icon · type=Texture2D

### `scroll_hint_vertical`
- data_type=icon · type=Texture2D

### `focus`
- data_type=style · type=StyleBox

### `panel`
- data_type=style · type=StyleBox

## 教程链接

- [Using Containers](None)

