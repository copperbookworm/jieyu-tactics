# SpinBox

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`SpinBox` → `Range` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core · keywords=number, numeric, input
> 自动生成，勿手改。文件：`refs/godot-api/SpinBox.md`

**摘要**：An input field for numbers.

## 描述

`SpinBox` is a numerical input text field. It allows entering integers and floating-point numbers. The `SpinBox` also has up and down buttons that can be clicked to increase or decrease the value. The value can also be changed by dragging the mouse up or down over the `SpinBox`'s arrows.
		Additionally, mathematical expressions can be entered. These are evaluated when the user presses Enter while editing the `SpinBox`'s text field. This uses the `Expression` class to parse and evaluate the expression. The result of the expression is then set as the value of the `SpinBox`. Some examples of valid expressions are `5 + 2 * 3`, `pow(2, 4)`, and `PI + sin(0.5)`. Expressions are case-sensitive.
		**Example:** Create a `SpinBox`, disable its context menu and set its text alignment to right.
		`codeblocks`
		`gdscript`
		var spin_box = SpinBox.new()
		add_child(spin_box)
		var line_edit = spin_box.get_line_edit()
		line_edit.context_menu_enabled = false
		spin_box.horizontal_alignment = LineEdit.HORIZONTAL_ALIGNMENT_RIGHT
		
		`csharp`
		var spinBox = new SpinBox();
		AddChild(spinBox);
		var lineEdit = spinBox.GetLineEdit();
		lineEdit.ContextMenuEnabled = false;
		spinBox.AlignHorizontal = LineEdit.HorizontalAlignEnum.Right;
		
		
		See `Range` class for more options over the `SpinBox`.
		**Note:** With the `SpinBox`'s context menu disabled, you can right-click the bottom half of the spinbox to set the value to its minimum, while right-clicking the top half sets the value to its maximum.
		**Note:** `SpinBox` relies on an underlying `LineEdit` node. To theme a `SpinBox`'s background, add theme items for `LineEdit` and customize them. The `LineEdit` has the `SpinBoxInnerLineEdit` theme variation, so that you can give it a distinct appearance from regular `LineEdit`s.
		**Note:** If you want to implement drag and drop for the underlying `LineEdit`, you can use `Control.set_drag_forwarding` on the node returned by `get_line_edit`.

## 属性

- **`alignment`** `int` = `0` · 枚举 `HorizontalAlignment`
  - 其它属性：getter=get_horizontal_alignment · setter=set_horizontal_alignment
- **`custom_arrow_round`** `bool` = `false`
  - 其它属性：getter=is_custom_arrow_rounding · setter=set_custom_arrow_round
- **`custom_arrow_step`** `float` = `0.0`
  - 其它属性：getter=get_custom_arrow_step · setter=set_custom_arrow_step
- **`editable`** `bool` = `true`
  - 其它属性：getter=is_editable · keywords=readonly, disabled, enabled · setter=set_editable
- **`prefix`** `String` = `""`
  - 其它属性：getter=get_prefix · setter=set_prefix
- **`select_all_on_focus`** `bool` = `false`
  - 其它属性：getter=is_select_all_on_focus · setter=set_select_all_on_focus
- **`size_flags_vertical`** `int` = `1` · 枚举 `Control.SizeFlags` · 位标志
  - 其它属性：getter=get_v_size_flags · is_bitfield=true · overrides=Control · setter=set_v_size_flags
- **`step`** `float` = `1.0`
  - 其它属性：getter=get_step · overrides=Range · setter=set_step
- **`suffix`** `String` = `""`
  - 其它属性：getter=get_suffix · setter=set_suffix
- **`update_on_text_changed`** `bool` = `false`
  - 其它属性：getter=get_update_on_text_changed · setter=set_update_on_text_changed

## 方法

### `apply() -> void`

Applies the current value of this `SpinBox`. This is equivalent to pressing Enter while editing the `LineEdit` used by the `SpinBox`. This will cause `LineEdit.text_submitted` to be emitted and its currently contained expression to be evaluated.

### `get_line_edit() -> LineEdit`

Returns the `LineEdit` instance from this `SpinBox`. You can use it to access properties and methods of `LineEdit`.
				**Warning:** This is a required internal node, removing and freeing it may cause a crash. If you wish to hide it or any of its children, use their `CanvasItem.visible` property.

## 主题属性

### `down_disabled_icon_modulate`
- data_type=color · default=Color(0.875, 0.875, 0.875, 0.5) · type=Color

### `down_hover_icon_modulate`
- data_type=color · default=Color(0.95, 0.95, 0.95, 1) · type=Color

### `down_icon_modulate`
- data_type=color · default=Color(0.875, 0.875, 0.875, 1) · type=Color

### `down_pressed_icon_modulate`
- data_type=color · default=Color(0.95, 0.95, 0.95, 1) · type=Color

### `up_disabled_icon_modulate`
- data_type=color · default=Color(0.875, 0.875, 0.875, 0.5) · type=Color

### `up_hover_icon_modulate`
- data_type=color · default=Color(0.95, 0.95, 0.95, 1) · type=Color

### `up_icon_modulate`
- data_type=color · default=Color(0.875, 0.875, 0.875, 1) · type=Color

### `up_pressed_icon_modulate`
- data_type=color · default=Color(0.95, 0.95, 0.95, 1) · type=Color

### `buttons_vertical_separation`
- data_type=constant · default=0 · type=int

### `buttons_width`
- data_type=constant · default=16 · type=int

### `field_and_buttons_separation`
- data_type=constant · default=2 · type=int

### `set_min_buttons_width_from_icons`
- data_type=constant · default=1 · deprecated=This property exists only for compatibility with older themes. Setting [theme_item buttons_width] to a negative value has the same effect. · type=int

### `down`
- data_type=icon · type=Texture2D

### `down_disabled`
- data_type=icon · type=Texture2D

### `down_hover`
- data_type=icon · type=Texture2D

### `down_pressed`
- data_type=icon · type=Texture2D

### `up`
- data_type=icon · type=Texture2D

### `up_disabled`
- data_type=icon · type=Texture2D

### `up_hover`
- data_type=icon · type=Texture2D

### `up_pressed`
- data_type=icon · type=Texture2D

### `updown`
- data_type=icon · deprecated=Use [theme_item up] and [theme_item down] instead. · type=Texture2D

### `down_background`
- data_type=style · type=StyleBox

### `down_background_disabled`
- data_type=style · type=StyleBox

### `down_background_hovered`
- data_type=style · type=StyleBox

### `down_background_pressed`
- data_type=style · type=StyleBox

### `field_and_buttons_separator`
- data_type=style · type=StyleBox

### `up_background`
- data_type=style · type=StyleBox

### `up_background_disabled`
- data_type=style · type=StyleBox

### `up_background_hovered`
- data_type=style · type=StyleBox

### `up_background_pressed`
- data_type=style · type=StyleBox

### `up_down_buttons_separator`
- data_type=style · type=StyleBox

