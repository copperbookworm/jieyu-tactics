# OpenXRInteractionProfile

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OpenXRInteractionProfile` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/OpenXRInteractionProfile.md`

**摘要**：Suggested bindings object for OpenXR.

## 描述

This object stores suggested bindings for an interaction profile. Interaction profiles define the metadata for a tracked XR device such as an XR controller.
		For more information see the interaction profiles info in the OpenXR specification (https://www.khronos.org/registry/OpenXR/specs/1.0/html/xrspec.html#semantic-path-interaction-profiles).

## 属性

- **`binding_modifiers`** `Array` = `[]`
  - 其它属性：getter=get_binding_modifiers · setter=set_binding_modifiers
- **`bindings`** `Array` = `[]`
  - 其它属性：getter=get_bindings · setter=set_bindings
- **`interaction_profile_path`** `String` = `""`
  - 其它属性：getter=get_interaction_profile_path · setter=set_interaction_profile_path

## 方法

### `get_binding(index: int) -> OpenXRIPBinding`
- 限定：qualifiers=const

Retrieve the binding at this index.

### `get_binding_count() -> int`
- 限定：qualifiers=const

Get the number of bindings in this interaction profile.

### `get_binding_modifier(index: int) -> OpenXRIPBindingModifier`
- 限定：qualifiers=const

Get the `OpenXRBindingModifier` at this index.

### `get_binding_modifier_count() -> int`
- 限定：qualifiers=const

Get the number of binding modifiers in this interaction profile.

