# OpenXRActionSet

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OpenXRActionSet` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/OpenXRActionSet.md`

**摘要**：Collection of `OpenXRAction` resources that make up an action set.

## 描述

Action sets in OpenXR define a collection of actions that can be activated in unison. This allows games to easily change between different states that require different inputs or need to reinterpret inputs. For instance we could have an action set that is active when a menu is open, an action set that is active when the player is freely walking around and an action set that is active when the player is controlling a vehicle.
		Action sets can contain the same action with the same name, if such action sets are active at the same time the action set with the highest priority defines which binding is active.

## 属性

- **`actions`** `Array` = `[]`
  - 其它属性：getter=get_actions · setter=set_actions
- **`localized_name`** `String` = `""`
  - 其它属性：getter=get_localized_name · setter=set_localized_name
- **`priority`** `int` = `0`
  - 其它属性：getter=get_priority · setter=set_priority

## 方法

### `add_action(action: OpenXRAction) -> void`

Add an action to this action set.

### `get_action_count() -> int`
- 限定：qualifiers=const

Retrieve the number of actions in our action set.

### `remove_action(action: OpenXRAction) -> void`

Remove an action from this action set.

