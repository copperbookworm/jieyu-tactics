# CheckBox

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`CheckBox` → `Button` → `BaseButton` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/CheckBox.md`

**摘要**：A button that represents a binary choice.

## 描述

`CheckBox` allows the user to choose one of only two possible options. It's similar to `CheckButton` in functionality, but it has a different appearance. To follow established UX patterns, it's recommended to use `CheckBox` when toggling it has **no** immediate effect on something. For example, it could be used when toggling it will only do something once a confirmation button is pressed.
		See also `BaseButton` which contains common properties and methods associated with this node.
		When `BaseButton.button_group` specifies a `ButtonGroup`, `CheckBox` changes its appearance to that of a radio button and uses the various `radio_*` theme properties.

## 属性

- **`alignment`** `int` = `0` · 枚举 `HorizontalAlignment`
  - 其它属性：getter=get_text_alignment · overrides=Button · setter=set_text_alignment
- **`toggle_mode`** `bool` = `true`
  - 其它属性：getter=is_toggle_mode · overrides=BaseButton · setter=set_toggle_mode

## 主题属性

### `checkbox_checked_color`
- data_type=color · default=Color(1, 1, 1, 1) · type=Color

### `checkbox_unchecked_color`
- data_type=color · default=Color(1, 1, 1, 1) · type=Color

### `check_v_offset`
- data_type=constant · default=0 · type=int

### `checked`
- data_type=icon · type=Texture2D

### `checked_disabled`
- data_type=icon · type=Texture2D

### `radio_checked`
- data_type=icon · type=Texture2D

### `radio_checked_disabled`
- data_type=icon · type=Texture2D

### `radio_unchecked`
- data_type=icon · type=Texture2D

### `radio_unchecked_disabled`
- data_type=icon · type=Texture2D

### `unchecked`
- data_type=icon · type=Texture2D

### `unchecked_disabled`
- data_type=icon · type=Texture2D

