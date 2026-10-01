# InputEventAction

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`InputEventAction` → `InputEvent` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/InputEventAction.md`

**摘要**：An input event type for actions.

## 描述

Contains a generic action which can be targeted from several types of inputs. Actions and their events can be set in the **Input Map** tab in **Project > Project Settings**, or with the `InputMap` class.
		**Note:** Unlike the other `InputEvent` subclasses which map to unique physical events, this virtual one is not emitted by the engine. This class is useful to emit actions manually with `Input.parse_input_event`, which are then received in `Node._input`. To check if a physical event matches an action from the Input Map, use `InputEvent.is_action` and `InputEvent.is_action_pressed`.

## 属性

- **`action`** `StringName` = `&""`
  - 其它属性：getter=get_action · setter=set_action
- **`event_index`** `int` = `-1`
  - 其它属性：getter=get_event_index · setter=set_event_index
- **`pressed`** `bool` = `false`
  - 其它属性：getter=is_pressed · setter=set_pressed
- **`strength`** `float` = `1.0`
  - 其它属性：getter=get_strength · setter=set_strength

## 教程链接

- [Using InputEvent: Actions](None)
- [2D Dodge The Creeps Demo](None)
- [3D Voxel Demo](None)

