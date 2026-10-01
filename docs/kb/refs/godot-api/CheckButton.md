# CheckButton

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`CheckButton` → `Button` → `BaseButton` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core · keywords=switch, toggle
> 自动生成，勿手改。文件：`refs/godot-api/CheckButton.md`

**摘要**：A button that represents a binary choice.

## 描述

`CheckButton` is a toggle button displayed as a check field. It's similar to `CheckBox` in functionality, but it has a different appearance. To follow established UX patterns, it's recommended to use `CheckButton` when toggling it has an **immediate** effect on something. For example, it can be used when pressing it shows or hides advanced settings, without asking the user to confirm this action.
		See also `BaseButton` which contains common properties and methods associated with this node.

## 属性

- **`alignment`** `int` = `0` · 枚举 `HorizontalAlignment`
  - 其它属性：getter=get_text_alignment · overrides=Button · setter=set_text_alignment
- **`toggle_mode`** `bool` = `true`
  - 其它属性：getter=is_toggle_mode · overrides=BaseButton · setter=set_toggle_mode

## 主题属性

### `button_checked_color`
- data_type=color · default=Color(1, 1, 1, 1) · type=Color

### `button_unchecked_color`
- data_type=color · default=Color(1, 1, 1, 1) · type=Color

### `check_v_offset`
- data_type=constant · default=0 · type=int

### `checked`
- data_type=icon · type=Texture2D

### `checked_disabled`
- data_type=icon · type=Texture2D

### `checked_disabled_mirrored`
- data_type=icon · type=Texture2D

### `checked_mirrored`
- data_type=icon · type=Texture2D

### `unchecked`
- data_type=icon · type=Texture2D

### `unchecked_disabled`
- data_type=icon · type=Texture2D

### `unchecked_disabled_mirrored`
- data_type=icon · type=Texture2D

### `unchecked_mirrored`
- data_type=icon · type=Texture2D

