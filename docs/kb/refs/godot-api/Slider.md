# Slider

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Slider` → `Range` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Slider.md`

**摘要**：Abstract base class for sliders.

## 描述

Abstract base class for sliders, used to adjust a value by moving a grabber along a horizontal or vertical axis. Sliders are `Range`-based controls.

## 属性

- **`editable`** `bool` = `true`
  - 其它属性：getter=is_editable · keywords=readonly, disabled, enabled · setter=set_editable
- **`focus_mode`** `int` = `2` · 枚举 `Control.FocusMode`
  - 其它属性：getter=get_focus_mode · overrides=Control · setter=set_focus_mode
- **`scrollable`** `bool` = `true`
  - 其它属性：getter=is_scrollable · setter=set_scrollable
- **`step`** `float` = `1.0`
  - 其它属性：getter=get_step · overrides=Range · setter=set_step
- **`tick_count`** `int` = `0`
  - 其它属性：getter=get_ticks · setter=set_ticks
- **`ticks_on_borders`** `bool` = `false`
  - 其它属性：getter=get_ticks_on_borders · setter=set_ticks_on_borders
- **`ticks_position`** `int` = `0` · 枚举 `Slider.TickPosition`
  - 其它属性：getter=get_ticks_position · setter=set_ticks_position

## 信号

### `drag_ended(value_changed: bool)`

Emitted when the grabber stops being dragged. If `value_changed` is `true`, `Range.value` is different from the value when the dragging was started.

### `drag_started()`

Emitted when the grabber starts being dragged. This is emitted before the corresponding `Range.value_changed` signal.

## 枚举

### `TickPosition`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `TICK_POSITION_BOTTOM_RIGHT` |  |
| `1` | `TICK_POSITION_TOP_LEFT` |  |
| `2` | `TICK_POSITION_BOTH` |  |
| `3` | `TICK_POSITION_CENTER` |  |

## 主题属性

### `center_grabber`
- data_type=constant · default=0 · type=int

### `grabber_offset`
- data_type=constant · default=0 · type=int

### `tick_offset`
- data_type=constant · default=0 · type=int

### `grabber`
- data_type=icon · type=Texture2D

### `grabber_disabled`
- data_type=icon · type=Texture2D

### `grabber_highlight`
- data_type=icon · type=Texture2D

### `tick`
- data_type=icon · type=Texture2D

### `grabber_area`
- data_type=style · type=StyleBox

### `grabber_area_highlight`
- data_type=style · type=StyleBox

### `slider`
- data_type=style · type=StyleBox

