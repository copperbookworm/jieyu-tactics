# OpenXRActionMap

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OpenXRActionMap` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/OpenXRActionMap.md`

**摘要**：Collection of `OpenXRActionSet` and `OpenXRInteractionProfile` resources for the OpenXR module.

## 描述

OpenXR uses an action system similar to Godots Input map system to bind inputs and outputs on various types of XR controllers to named actions. OpenXR specifies more detail on these inputs and outputs than Godot supports.
		Another important distinction is that OpenXR offers no control over these bindings. The bindings we register are suggestions, it is up to the XR runtime to offer users the ability to change these bindings. This allows the XR runtime to fill in the gaps if new hardware becomes available.
		The action map therefore needs to be loaded at startup and can't be changed afterwards. This resource is a container for the entire action map.

## 属性

- **`action_sets`** `Array` = `[]`
  - 其它属性：getter=get_action_sets · setter=set_action_sets
- **`interaction_profiles`** `Array` = `[]`
  - 其它属性：getter=get_interaction_profiles · setter=set_interaction_profiles

## 方法

### `add_action_set(action_set: OpenXRActionSet) -> void`

Add an action set.

### `add_interaction_profile(interaction_profile: OpenXRInteractionProfile) -> void`

Add an interaction profile.

### `create_default_action_sets() -> void`

Setup this action set with our default actions.

### `find_action_set(name: String) -> OpenXRActionSet`
- 限定：qualifiers=const

Retrieve an action set by name.

### `find_interaction_profile(name: String) -> OpenXRInteractionProfile`
- 限定：qualifiers=const

Find an interaction profile by its name (path).

### `get_action_set(idx: int) -> OpenXRActionSet`
- 限定：qualifiers=const

Retrieve the action set at this index.

### `get_action_set_count() -> int`
- 限定：qualifiers=const

Retrieve the number of actions sets in our action map.

### `get_interaction_profile(idx: int) -> OpenXRInteractionProfile`
- 限定：qualifiers=const

Get the interaction profile at this index.

### `get_interaction_profile_count() -> int`
- 限定：qualifiers=const

Retrieve the number of interaction profiles in our action map.

### `remove_action_set(action_set: OpenXRActionSet) -> void`

Remove an action set.

### `remove_interaction_profile(interaction_profile: OpenXRInteractionProfile) -> void`

Remove an interaction profile.

