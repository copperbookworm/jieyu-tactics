# OpenXRBindingModifierEditor

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OpenXRBindingModifierEditor` → `PanelContainer` → `Container` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=editor
> 自动生成，勿手改。文件：`refs/godot-api/OpenXRBindingModifierEditor.md`

**摘要**：Binding modifier editor.

## 描述

This is the default binding modifier editor used in the OpenXR action map.

## 方法

### `get_binding_modifier() -> OpenXRBindingModifier`
- 限定：qualifiers=const

Returns the `OpenXRBindingModifier` currently being edited.

### `setup(action_map: OpenXRActionMap, binding_modifier: OpenXRBindingModifier) -> void`

Setup this editor for the provided `action_map` and `binding_modifier`.

## 信号

### `binding_modifier_removed(binding_modifier_editor: Object)`

Signal emitted when the user presses the delete binding modifier button for this modifier.

