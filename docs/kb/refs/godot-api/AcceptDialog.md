# AcceptDialog

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AcceptDialog` → `Window` → `Viewport` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AcceptDialog.md`

**摘要**：A base dialog used for user notification.

## 描述

The default use of `AcceptDialog` is to allow it to only be accepted or closed, with the same result. However, the `confirmed` and `canceled` signals allow to make the two actions different, and the `add_button` method allows to add custom buttons and actions.
		**Note:** `AcceptDialog` is invisible by default. To make it visible, call one of the `popup_*` methods from `Window` on the node, such as `Window.popup_centered_clamped`.

## 属性

- **`dialog_autowrap`** `bool` = `false`
  - 其它属性：getter=has_autowrap · setter=set_autowrap
- **`dialog_close_on_escape`** `bool` = `true`
  - 其它属性：getter=get_close_on_escape · setter=set_close_on_escape
- **`dialog_hide_on_ok`** `bool` = `true`
  - 其它属性：getter=get_hide_on_ok · setter=set_hide_on_ok
- **`dialog_text`** `String` = `""`
  - 其它属性：getter=get_text · setter=set_text
- **`exclusive`** `bool` = `true`
  - 其它属性：getter=is_exclusive · overrides=Window · setter=set_exclusive
- **`keep_title_visible`** `bool` = `true`
  - 其它属性：getter=get_keep_title_visible · overrides=Window · setter=set_keep_title_visible
- **`maximize_disabled`** `bool` = `true`
  - 其它属性：getter=get_flag · overrides=Window · setter=set_flag
- **`minimize_disabled`** `bool` = `true`
  - 其它属性：getter=get_flag · overrides=Window · setter=set_flag
- **`ok_button_text`** `String` = `""`
  - 其它属性：getter=get_ok_button_text · setter=set_ok_button_text
- **`title`** `String` = `"Alert!"`
  - 其它属性：getter=get_title · overrides=Window · setter=set_title
- **`transient`** `bool` = `true`
  - 其它属性：getter=is_transient · overrides=Window · setter=set_transient
- **`visible`** `bool` = `false`
  - 其它属性：getter=is_visible · overrides=Window · setter=set_visible
- **`wrap_controls`** `bool` = `true`
  - 其它属性：getter=is_wrapping_controls · overrides=Window · setter=set_wrap_controls

## 方法

### `add_button(text: String, right: bool = false, action: String = "") -> Button`

Adds a button with label `text` and a custom `action` to the dialog and returns the created button.
				If `action` is not empty, pressing the button will emit the `custom_action` signal with the specified action string.
				If `true`, `right` will place the button to the right of any sibling buttons.
				You can use `remove_button` method to remove a button created with this method from the dialog.

### `add_cancel_button(name: String) -> Button`

Adds a button with label `name` and a cancel action to the dialog and returns the created button.
				You can use `remove_button` method to remove a button created with this method from the dialog.

### `get_label() -> Label`

Returns the label used for built-in text.
				**Warning:** This is a required internal node, removing and freeing it may cause a crash. If you wish to hide it or any of its children, use their `CanvasItem.visible` property.

### `get_ok_button() -> Button`

Returns the OK `Button` instance.
				**Warning:** This is a required internal node, removing and freeing it may cause a crash. If you wish to hide it or any of its children, use their `CanvasItem.visible` property.

### `register_text_enter(line_edit: LineEdit) -> void`

Registers a `LineEdit` in the dialog. When the enter key is pressed, the dialog will be accepted.

### `remove_button(button: Button) -> void`

Removes the `button` from the dialog. Does NOT free the `button`. The `button` must be a `Button` added with `add_button` or `add_cancel_button` method. After removal, pressing the `button` will no longer emit this dialog's `custom_action` or `canceled` signals.

## 信号

### `canceled()`

Emitted when the dialog is closed or the button created with `add_cancel_button` is pressed.

### `confirmed()`

Emitted when the dialog is accepted, i.e. the OK button is pressed.

### `custom_action(action: StringName)`

Emitted when a custom button with an action is pressed. See `add_button`.

## 主题属性

### `buttons_min_height`
- data_type=constant · default=0 · type=int

### `buttons_min_width`
- data_type=constant · default=0 · type=int

### `buttons_separation`
- data_type=constant · default=10 · type=int

### `panel`
- data_type=style · type=StyleBox

