# OpenXRIPBinding

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OpenXRIPBinding` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/OpenXRIPBinding.md`

**摘要**：Defines a binding between an `OpenXRAction` and an XR input or output.

## 描述

This binding resource binds an `OpenXRAction` to an input or output. As most controllers have left hand and right versions that are handled by the same interaction profile we can specify multiple bindings. For instance an action "Fire" could be bound to both "/user/hand/left/input/trigger" and "/user/hand/right/input/trigger". This would require two binding entries.

## 属性

- **`action`** `OpenXRAction`
  - 其它属性：getter=get_action · setter=set_action
- **`binding_modifiers`** `Array` = `[]`
  - 其它属性：getter=get_binding_modifiers · setter=set_binding_modifiers
- **`binding_path`** `String` = `""`
  - 其它属性：getter=get_binding_path · setter=set_binding_path
- **`paths`** `PackedStringArray`
  - 其它属性：deprecated=Use [member binding_path] instead. · getter=get_paths · setter=set_paths

## 方法

### `add_path(path: String) -> void`
- 限定：deprecated=Binding is for a single path.

Add an input/output path to this binding.

### `get_binding_modifier(index: int) -> OpenXRActionBindingModifier`
- 限定：qualifiers=const

Get the `OpenXRBindingModifier` at this index.

### `get_binding_modifier_count() -> int`
- 限定：qualifiers=const

Get the number of binding modifiers for this binding.

### `get_path_count() -> int`
- 限定：deprecated=Binding is for a single path. · qualifiers=const

Get the number of input/output paths in this binding.

### `has_path(path: String) -> bool`
- 限定：deprecated=Binding is for a single path. · qualifiers=const

Returns `true` if this input/output path is part of this binding.

### `remove_path(path: String) -> void`
- 限定：deprecated=Binding is for a single path.

Removes this input/output path from this binding.

