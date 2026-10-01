# EditorToaster

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`EditorToaster` → `HBoxContainer` → `BoxContainer` → `Container` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=editor
> 自动生成，勿手改。文件：`refs/godot-api/EditorToaster.md`

**摘要**：Manages toast notifications within the editor.

## 描述

This object manages the functionality and display of toast notifications within the editor, ensuring immediate and informative alerts are presented to the user.
		**Note:** This class shouldn't be instantiated directly. Instead, access the singleton using `EditorInterface.get_editor_toaster`.

## 方法

### `push_toast(message: String, severity: int = 0, tooltip: String = "") -> void`

Pushes a toast notification to the editor for display.

## 枚举

### `Severity`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SEVERITY_INFO` |  |
| `1` | `SEVERITY_WARNING` |  |
| `2` | `SEVERITY_ERROR` |  |

