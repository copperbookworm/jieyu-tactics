# Button

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Button` → `BaseButton` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Button.md`

**摘要**：A themed button that can contain text and an icon.

## 描述

`Button` is the standard themed button. It can contain text and an icon, and it will display them according to the current `Theme`.
		**Example:** Create a button and connect a method that will be called when the button is pressed:
		`codeblocks`
		`gdscript`
		func _ready():
			var button = Button.new()
			button.text = "Click me"
			button.pressed.connect(_button_pressed)
			add_child(button)

		func _button_pressed():
			print("Hello world!")
		
		`csharp`
		public override void _Ready()
		{
			var button = new Button();
			button.Text = "Click me";
			button.Pressed += ButtonPressed;
			AddChild(button);
		}

		private void ButtonPressed()
		{
			GD.Print("Hello world!");
		}
		
		
		See also `BaseButton` which contains common properties and methods associated with this node.
		**Note:** Buttons support multitouch via touch input, allowing multiple buttons to be pressed at the same time. Otherwise, mouse input is used, limiting interaction to one button press at a time.

## 属性

- **`alignment`** `int` = `1` · 枚举 `HorizontalAlignment`
  - 其它属性：getter=get_text_alignment · setter=set_text_alignment
- **`autowrap_mode`** `int` = `0` · 枚举 `TextServer.AutowrapMode`
  - 其它属性：getter=get_autowrap_mode · setter=set_autowrap_mode
- **`autowrap_trim_flags`** `int` = `128` · 枚举 `TextServer.LineBreakFlag` · 位标志
  - 其它属性：getter=get_autowrap_trim_flags · is_bitfield=true · setter=set_autowrap_trim_flags
- **`clip_text`** `bool` = `false`
  - 其它属性：getter=get_clip_text · setter=set_clip_text
- **`expand_icon`** `bool` = `false`
  - 其它属性：getter=is_expand_icon · setter=set_expand_icon
- **`flat`** `bool` = `false`
  - 其它属性：getter=is_flat · setter=set_flat
- **`icon`** `Texture2D`
  - 其它属性：getter=get_button_icon · setter=set_button_icon
- **`icon_alignment`** `int` = `0` · 枚举 `HorizontalAlignment`
  - 其它属性：getter=get_icon_alignment · setter=set_icon_alignment
- **`language`** `String` = `""`
  - 其它属性：getter=get_language · setter=set_language
- **`text`** `String` = `""`
  - 其它属性：getter=get_text · setter=set_text
- **`text_direction`** `int` = `0` · 枚举 `Control.TextDirection`
  - 其它属性：getter=get_text_direction · setter=set_text_direction
- **`text_overrun_behavior`** `int` = `0` · 枚举 `TextServer.OverrunBehavior`
  - 其它属性：getter=get_text_overrun_behavior · setter=set_text_overrun_behavior
- **`vertical_icon_alignment`** `int` = `1` · 枚举 `VerticalAlignment`
  - 其它属性：getter=get_vertical_icon_alignment · setter=set_vertical_icon_alignment

## 主题属性

### `font_color`
- data_type=color · default=Color(0.875, 0.875, 0.875, 1) · type=Color

### `font_disabled_color`
- data_type=color · default=Color(0.875, 0.875, 0.875, 0.5) · type=Color

### `font_focus_color`
- data_type=color · default=Color(0.95, 0.95, 0.95, 1) · type=Color

### `font_hover_color`
- data_type=color · default=Color(0.95, 0.95, 0.95, 1) · type=Color

### `font_hover_pressed_color`
- data_type=color · default=Color(1, 1, 1, 1) · type=Color

### `font_outline_color`
- data_type=color · default=Color(0, 0, 0, 1) · type=Color

### `font_pressed_color`
- data_type=color · default=Color(1, 1, 1, 1) · type=Color

### `icon_disabled_color`
- data_type=color · default=Color(1, 1, 1, 0.4) · type=Color

### `icon_focus_color`
- data_type=color · default=Color(1, 1, 1, 1) · type=Color

### `icon_hover_color`
- data_type=color · default=Color(1, 1, 1, 1) · type=Color

### `icon_hover_pressed_color`
- data_type=color · default=Color(1, 1, 1, 1) · type=Color

### `icon_normal_color`
- data_type=color · default=Color(1, 1, 1, 1) · type=Color

### `icon_pressed_color`
- data_type=color · default=Color(1, 1, 1, 1) · type=Color

### `align_to_largest_stylebox`
- data_type=constant · default=0 · type=int

### `h_separation`
- data_type=constant · default=4 · type=int

### `icon_max_width`
- data_type=constant · default=0 · type=int

### `line_spacing`
- data_type=constant · default=0 · type=int

### `outline_size`
- data_type=constant · default=0 · type=int

### `font`
- data_type=font · type=Font

### `font_size`
- data_type=font_size · type=int

### `icon`
- data_type=icon · type=Texture2D

### `disabled`
- data_type=style · keywords=enabled · type=StyleBox

### `disabled_mirrored`
- data_type=style · type=StyleBox

### `focus`
- data_type=style · type=StyleBox

### `hover`
- data_type=style · type=StyleBox

### `hover_mirrored`
- data_type=style · type=StyleBox

### `hover_pressed`
- data_type=style · type=StyleBox

### `hover_pressed_mirrored`
- data_type=style · type=StyleBox

### `normal`
- data_type=style · type=StyleBox

### `normal_mirrored`
- data_type=style · type=StyleBox

### `pressed`
- data_type=style · type=StyleBox

### `pressed_mirrored`
- data_type=style · type=StyleBox

## 教程链接

- [2D Dodge The Creeps Demo](None)
- [Operating System Testing Demo](None)

