# OpenXRAction

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OpenXRAction` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/OpenXRAction.md`

**摘要**：An OpenXR action.

## 描述

This resource defines an OpenXR action. Actions can be used both for inputs (buttons, joysticks, triggers, etc.) and outputs (haptics).
		OpenXR performs automatic conversion between action type and input type whenever possible. An analog trigger bound to a boolean action will thus return `false` if the trigger is depressed and `true` if pressed fully.
		Actions are not directly bound to specific devices, instead OpenXR recognizes a limited number of top level paths that identify devices by usage. We can restrict which devices an action can be bound to by these top level paths. For instance an action that should only be used for hand held controllers can have the top level paths "/user/hand/left" and "/user/hand/right" associated with them. See the reserved path section in the OpenXR specification (https://www.khronos.org/registry/OpenXR/specs/1.0/html/xrspec.html#semantic-path-reserved) for more info on the top level paths.
		Note that the name of the resource is used to register the action with.

## 属性

- **`action_type`** `int` = `1` · 枚举 `OpenXRAction.ActionType`
  - 其它属性：getter=get_action_type · setter=set_action_type
- **`localized_name`** `String` = `""`
  - 其它属性：getter=get_localized_name · setter=set_localized_name
- **`toplevel_paths`** `PackedStringArray` = `PackedStringArray()`
  - 其它属性：getter=get_toplevel_paths · setter=set_toplevel_paths

## 枚举

### `ActionType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `OPENXR_ACTION_BOOL` |  |
| `1` | `OPENXR_ACTION_FLOAT` |  |
| `2` | `OPENXR_ACTION_VECTOR2` |  |
| `3` | `OPENXR_ACTION_POSE` |  |

