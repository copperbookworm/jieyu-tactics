# InputEventShortcut

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`InputEventShortcut` → `InputEvent` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/InputEventShortcut.md`

**摘要**：Represents a triggered keyboard `Shortcut`.

## 描述

InputEventShortcut is a special event that can be received in `Node._input`, `Node._shortcut_input`, and `Node._unhandled_input`. It is typically sent by the editor's Command Palette to trigger actions, but can also be sent manually using `Viewport.push_input`.

## 属性

- **`shortcut`** `Shortcut`
  - 其它属性：getter=get_shortcut · setter=set_shortcut

