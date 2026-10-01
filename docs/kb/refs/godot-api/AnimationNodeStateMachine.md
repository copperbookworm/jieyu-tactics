# AnimationNodeStateMachine

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AnimationNodeStateMachine` → `AnimationRootNode` → `AnimationNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AnimationNodeStateMachine.md`

**摘要**：A state machine with multiple `AnimationRootNode`s, used by `AnimationTree`.

## 描述

Contains multiple `AnimationRootNode`s representing animation states, connected in a graph. State transitions can be configured to happen automatically or via code, using a shortest-path algorithm. Retrieve the `AnimationNodeStateMachinePlayback` object from the `AnimationTree` node to control it programmatically.
		`codeblocks`
		`gdscript`
		var state_machine = $AnimationTree.get("parameters/playback")
		state_machine.travel("some_state")
		
		`csharp`
		var stateMachine = GetNode<AnimationTree>("AnimationTree").Get("parameters/playback") as AnimationNodeStateMachinePlayback;
		stateMachine.Travel("some_state");

## 属性

- **`allow_transition_to_self`** `bool` = `false`
  - 其它属性：getter=is_allow_transition_to_self · setter=set_allow_transition_to_self
- **`reset_ends`** `bool` = `false`
  - 其它属性：getter=are_ends_reset · setter=set_reset_ends
- **`state_machine_type`** `int` = `0` · 枚举 `AnimationNodeStateMachine.StateMachineType`
  - 其它属性：getter=get_state_machine_type · setter=set_state_machine_type

## 方法

### `add_node(name: StringName, node: AnimationNode, position: Vector2 = Vector2(0, 0)) -> void`

Adds a new animation node to the graph. The `position` is used for display in the editor.

### `add_transition(from: StringName, to: StringName, transition: AnimationNodeStateMachineTransition) -> void`

Adds a transition between the given animation nodes.

### `get_graph_offset() -> Vector2`
- 限定：qualifiers=const

Returns the draw offset of the graph. Used for display in the editor.

### `get_node(name: StringName) -> AnimationNode`
- 限定：qualifiers=const

Returns the animation node with the given name.

### `get_node_list() -> StringName[]`
- 限定：qualifiers=const

Returns a list containing the names of all animation nodes in this state machine.

### `get_node_name(node: AnimationNode) -> StringName`
- 限定：qualifiers=const

Returns the given animation node's name.

### `get_node_position(name: StringName) -> Vector2`
- 限定：qualifiers=const

Returns the given animation node's coordinates. Used for display in the editor.

### `get_transition(idx: int) -> AnimationNodeStateMachineTransition`
- 限定：qualifiers=const

Returns the given transition.

### `get_transition_count() -> int`
- 限定：qualifiers=const

Returns the number of connections in the graph.

### `get_transition_from(idx: int) -> StringName`
- 限定：qualifiers=const

Returns the given transition's start node.

### `get_transition_to(idx: int) -> StringName`
- 限定：qualifiers=const

Returns the given transition's end node.

### `has_node(name: StringName) -> bool`
- 限定：qualifiers=const

Returns `true` if the graph contains the given animation node.

### `has_transition(from: StringName, to: StringName) -> bool`
- 限定：qualifiers=const

Returns `true` if there is a transition between the given animation nodes.

### `remove_node(name: StringName) -> void`

Deletes the given animation node from the graph.

### `remove_transition(from: StringName, to: StringName) -> void`

Deletes the transition between the two specified animation nodes.

### `remove_transition_by_index(idx: int) -> void`

Deletes the given transition by index.

### `rename_node(name: StringName, new_name: StringName) -> void`

Renames the given animation node.

### `replace_node(name: StringName, node: AnimationNode) -> void`

Replaces the given animation node with a new animation node.

### `set_graph_offset(offset: Vector2) -> void`

Sets the draw offset of the graph. Used for display in the editor.

### `set_node_position(name: StringName, position: Vector2) -> void`

Sets the animation node's coordinates. Used for display in the editor.

## 枚举

### `StateMachineType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `STATE_MACHINE_TYPE_ROOT` |  |
| `1` | `STATE_MACHINE_TYPE_NESTED` |  |
| `2` | `STATE_MACHINE_TYPE_GROUPED` |  |

## 教程链接

- [Using AnimationTree](None)

