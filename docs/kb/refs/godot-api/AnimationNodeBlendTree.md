# AnimationNodeBlendTree

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AnimationNodeBlendTree` → `AnimationRootNode` → `AnimationNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AnimationNodeBlendTree.md`

**摘要**：A sub-tree of many type `AnimationNode`s used for complex animations. Used by `AnimationTree`.

## 描述

This animation node may contain a sub-tree of any other type animation nodes, such as `AnimationNodeTransition`, `AnimationNodeBlend2`, `AnimationNodeBlend3`, `AnimationNodeOneShot`, etc. This is one of the most commonly used animation node roots.
		An `AnimationNodeOutput` node named `output` is created by default.

## 属性

- **`graph_offset`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_graph_offset · setter=set_graph_offset

## 方法

### `add_node(name: StringName, node: AnimationNode, position: Vector2 = Vector2(0, 0)) -> void`

Adds an `AnimationNode` at the given `position`. The `name` is used to identify the created sub animation node later.

### `connect_node(input_node: StringName, input_index: int, output_node: StringName) -> void`

Connects the output of an `AnimationNode` as input for another `AnimationNode`, at the input port specified by `input_index`.

### `disconnect_node(input_node: StringName, input_index: int) -> void`

Disconnects the animation node connected to the specified input.

### `get_node(name: StringName) -> AnimationNode`
- 限定：qualifiers=const

Returns the sub animation node with the specified `name`.

### `get_node_list() -> StringName[]`
- 限定：qualifiers=const

Returns a list containing the names of all sub animation nodes in this blend tree.

### `get_node_position(name: StringName) -> Vector2`
- 限定：qualifiers=const

Returns the position of the sub animation node with the specified `name`.

### `has_node(name: StringName) -> bool`
- 限定：qualifiers=const

Returns `true` if a sub animation node with specified `name` exists.

### `remove_node(name: StringName) -> void`

Removes a sub animation node.

### `rename_node(name: StringName, new_name: StringName) -> void`

Changes the name of a sub animation node.

### `set_node_position(name: StringName, position: Vector2) -> void`

Modifies the position of a sub animation node.

## 信号

### `node_changed(node_name: StringName)`

Emitted when the input port information is changed.

## 常量

- **`CONNECTION_OK`** = `0`
- **`CONNECTION_ERROR_NO_INPUT`** = `1`
- **`CONNECTION_ERROR_NO_INPUT_INDEX`** = `2`
- **`CONNECTION_ERROR_NO_OUTPUT`** = `3`
- **`CONNECTION_ERROR_SAME_NODE`** = `4`
- **`CONNECTION_ERROR_CONNECTION_EXISTS`** = `5`
## 教程链接

- [Using AnimationTree](None)

