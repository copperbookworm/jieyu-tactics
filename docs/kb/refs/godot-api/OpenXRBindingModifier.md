# OpenXRBindingModifier

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OpenXRBindingModifier` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/OpenXRBindingModifier.md`

**摘要**：Binding modifier base class.

## 描述

Binding modifier base class. Subclasses implement various modifiers that alter how an OpenXR runtime processes inputs.

## 方法

### `_get_description() -> String`
- 限定：qualifiers=virtual required const

Return the description of this class that is used for the title bar of the binding modifier editor.

### `_get_ip_modification() -> PackedByteArray`
- 限定：qualifiers=virtual required

Returns the data that is sent to OpenXR when submitting the suggested interacting bindings this modifier is a part of.
				**Note:** This must be data compatible with an `XrBindingModificationBaseHeaderKHR` structure.

