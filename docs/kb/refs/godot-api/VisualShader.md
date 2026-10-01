# VisualShader

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VisualShader` → `Shader` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VisualShader.md`

**摘要**：A custom shader program with a visual editor.

## 描述

This class provides a graph-like visual editor for creating a `Shader`. Although `VisualShader`s do not require coding, they share the same logic with script shaders. They use `VisualShaderNode`s that can be connected to each other to control the flow of the shader. The visual shader graph is converted to a script shader behind the scenes.

## 属性

- **`graph_offset`** `Vector2`
  - 其它属性：deprecated=This property does nothing and always equals to zero. · getter=get_graph_offset · setter=set_graph_offset

## 方法

### `add_node(type: int, node: VisualShaderNode, position: Vector2, id: int) -> void`

Adds the specified `node` to the shader.

### `add_varying(name: String, mode: int, type: int) -> void`

Adds a new varying value node to the shader.

### `attach_node_to_frame(type: int, id: int, frame: int) -> void`

Attaches the given node to the given frame.

### `can_connect_nodes(type: int, from_node: int, from_port: int, to_node: int, to_port: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the specified nodes and ports can be connected together.

### `connect_nodes(type: int, from_node: int, from_port: int, to_node: int, to_port: int) -> int`

Connects the specified nodes and ports.

### `connect_nodes_forced(type: int, from_node: int, from_port: int, to_node: int, to_port: int) -> void`

Connects the specified nodes and ports, even if they can't be connected. Such connection is invalid and will not function properly.

### `detach_node_from_frame(type: int, id: int) -> void`

Detaches the given node from the frame it is attached to.

### `disconnect_nodes(type: int, from_node: int, from_port: int, to_node: int, to_port: int) -> void`

Connects the specified nodes and ports.

### `get_node(type: int, id: int) -> VisualShaderNode`
- 限定：qualifiers=const

Returns the shader node instance with specified `type` and `id`.

### `get_node_connections(type: int) -> Dictionary[]`
- 限定：qualifiers=const

Returns the list of connected nodes with the specified type.

### `get_node_list(type: int) -> PackedInt32Array`
- 限定：qualifiers=const

Returns the list of all nodes in the shader with the specified type.

### `get_node_position(type: int, id: int) -> Vector2`
- 限定：qualifiers=const

Returns the position of the specified node within the shader graph.

### `get_valid_node_id(type: int) -> int`
- 限定：qualifiers=const

Returns next valid node ID that can be added to the shader graph.

### `has_varying(name: String) -> bool`
- 限定：qualifiers=const

Returns `true` if the shader has a varying with the given `name`.

### `is_node_connection(type: int, from_node: int, from_port: int, to_node: int, to_port: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the specified node and port connection exist.

### `remove_node(type: int, id: int) -> void`

Removes the specified node from the shader.

### `remove_varying(name: String) -> void`

Removes a varying value node with the given `name`. Prints an error if a node with this name is not found.

### `replace_node(type: int, id: int, new_class: StringName) -> void`

Replaces the specified node with a node of new class type.

### `set_mode(mode: int) -> void`

Sets the mode of this shader.

### `set_node_position(type: int, id: int, position: Vector2) -> void`

Sets the position of the specified node.

## 枚举

### `Type`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `TYPE_VERTEX` |  |
| `1` | `TYPE_FRAGMENT` |  |
| `2` | `TYPE_LIGHT` |  |
| `3` | `TYPE_START` |  |
| `4` | `TYPE_PROCESS` |  |
| `5` | `TYPE_COLLIDE` |  |
| `6` | `TYPE_START_CUSTOM` |  |
| `7` | `TYPE_PROCESS_CUSTOM` |  |
| `8` | `TYPE_SKY` |  |
| `9` | `TYPE_FOG` |  |
| `10` | `TYPE_TEXTURE_BLIT` |  |
| `11` | `TYPE_MAX` |  |

### `VaryingMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `VARYING_MODE_VERTEX_TO_FRAG_LIGHT` |  |
| `1` | `VARYING_MODE_FRAG_TO_LIGHT` |  |
| `2` | `VARYING_MODE_MAX` |  |

### `VaryingType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `VARYING_TYPE_FLOAT` |  |
| `1` | `VARYING_TYPE_INT` |  |
| `2` | `VARYING_TYPE_UINT` |  |
| `3` | `VARYING_TYPE_VECTOR_2D` |  |
| `4` | `VARYING_TYPE_VECTOR_3D` |  |
| `5` | `VARYING_TYPE_VECTOR_4D` |  |
| `6` | `VARYING_TYPE_BOOLEAN` |  |
| `7` | `VARYING_TYPE_TRANSFORM` |  |
| `8` | `VARYING_TYPE_MAX` |  |

## 常量

- **`NODE_ID_INVALID`** = `-1`
- **`NODE_ID_OUTPUT`** = `0`
## 教程链接

- [Using VisualShaders](None)

