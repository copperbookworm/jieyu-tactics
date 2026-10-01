# ColorPickerButton

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ColorPickerButton` → `Button` → `BaseButton` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/ColorPickerButton.md`

**摘要**：A button that brings up a `ColorPicker` when pressed.

## 描述

Encapsulates a `ColorPicker`, making it accessible by pressing a button. Pressing the button will toggle the `ColorPicker`'s visibility.
		See also `BaseButton` which contains common properties and methods associated with this node.
		**Note:** By default, the button may not be wide enough for the color preview swatch to be visible. Make sure to set `Control.custom_minimum_size` to a big enough value to give the button enough space.

## 属性

- **`color`** `Color` = `Color(0, 0, 0, 1)`
  - 其它属性：getter=get_pick_color · keywords=colour · setter=set_pick_color
- **`edit_alpha`** `bool` = `true`
  - 其它属性：getter=is_editing_alpha · setter=set_edit_alpha
- **`edit_intensity`** `bool` = `true`
  - 其它属性：getter=is_editing_intensity · setter=set_edit_intensity
- **`toggle_mode`** `bool` = `true`
  - 其它属性：getter=is_toggle_mode · overrides=BaseButton · setter=set_toggle_mode

## 方法

### `get_picker() -> ColorPicker`

Returns the `ColorPicker` that this node toggles.
				**Warning:** This is a required internal node, removing and freeing it may cause a crash. If you wish to hide it or any of its children, use their `CanvasItem.visible` property.

### `get_popup() -> PopupPanel`

Returns the control's `PopupPanel` which allows you to connect to popup signals. This allows you to handle events when the ColorPicker is shown or hidden.
				**Warning:** This is a required internal node, removing and freeing it may cause a crash. If you wish to hide it or any of its children, use their `Window.visible` property.

## 信号

### `color_changed(color: Color)`

Emitted when the color changes.

### `picker_created()`

Emitted when the `ColorPicker` is created (the button is pressed for the first time).

### `popup_closed()`

Emitted when the `ColorPicker` is closed.

## 主题属性

### `bg`
- data_type=icon · type=Texture2D

## 教程链接

- [2D GD Paint Demo](None)
- [GUI Drag And Drop Demo](None)

