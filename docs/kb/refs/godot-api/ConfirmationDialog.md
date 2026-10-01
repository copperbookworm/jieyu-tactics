# ConfirmationDialog

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ConfirmationDialog` → `AcceptDialog` → `Window` → `Viewport` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/ConfirmationDialog.md`

**摘要**：A dialog used for confirmation of actions.

## 描述

A dialog used for confirmation of actions. This window is similar to `AcceptDialog`, but pressing its Cancel button can have a different outcome from pressing the OK button. The order of the two buttons varies depending on the host OS.
		To get cancel action, you can use:
		`codeblocks`
		`gdscript`
		get_cancel_button().pressed.connect(_on_canceled)
		
		`csharp`
		GetCancelButton().Pressed += OnCanceled;
		
		
		**Note:** `AcceptDialog` is invisible by default. To make it visible, call one of the `popup_*` methods from `Window` on the node, such as `Window.popup_centered_clamped`.

## 属性

- **`cancel_button_text`** `String` = `"Cancel"`
  - 其它属性：getter=get_cancel_button_text · setter=set_cancel_button_text
- **`min_size`** `Vector2i` = `Vector2i(200, 70)`
  - 其它属性：getter=get_min_size · overrides=Window · setter=set_min_size
- **`size`** `Vector2i` = `Vector2i(200, 100)`
  - 其它属性：getter=get_size · overrides=Window · setter=set_size
- **`title`** `String` = `"Please Confirm..."`
  - 其它属性：getter=get_title · overrides=Window · setter=set_title

## 方法

### `get_cancel_button() -> Button`

Returns the cancel button.
				**Warning:** This is a required internal node, removing and freeing it may cause a crash. If you wish to hide it or any of its children, use their `CanvasItem.visible` property.

