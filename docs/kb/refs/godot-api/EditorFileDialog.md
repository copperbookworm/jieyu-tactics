# EditorFileDialog

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`EditorFileDialog` → `FileDialog` → `ConfirmationDialog` → `AcceptDialog` → `Window` → `Viewport` → `Node` → `Object`
> 附加属性：api_type=editor
> 自动生成，勿手改。文件：`refs/godot-api/EditorFileDialog.md`

**摘要**：A modified version of `FileDialog` used by the editor.

## 描述

`EditorFileDialog` is a `FileDialog` tweaked to work in the editor. It automatically handles favorite and recent directory lists, and synchronizes some properties with their corresponding editor settings.
		`EditorFileDialog` will automatically show a native dialog based on the `EditorSettings.interface/editor/appearance/use_native_file_dialogs` editor setting and ignores `FileDialog.use_native_dialog`.
		**Note:** `EditorFileDialog` is invisible by default. To make it visible, call one of the `popup_*` methods from `Window` on the node, such as `Window.popup_centered_clamped`.
		**Note:** On Linux and macOS, sandboxed apps always use native dialogs to access the host file system.

## 属性

- **`disable_overwrite_warning`** `bool` = `false`
  - 其它属性：deprecated=Use [member FileDialog.overwrite_warning_enabled] instead. · getter=is_overwrite_warning_disabled · setter=set_disable_overwrite_warning

## 方法

### `add_side_menu(menu: Control, title: String = "") -> void`
- 限定：deprecated=This feature is no longer supported.

This method is kept for compatibility and does nothing. As an alternative, you can display another dialog after showing the file dialog.

