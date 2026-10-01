# VisualShaderNode

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VisualShaderNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VisualShaderNode.md`

**摘要**：Base class for `VisualShader` nodes. Not related to scene nodes.

## 描述

Visual shader graphs consist of various nodes. Each node in the graph is a separate object and they are represented as a rectangular boxes with title and a set of properties. Each node also has connection ports that allow to connect it to another nodes and control the flow of the shader.

## 属性

- **`linked_parent_graph_frame`** `int` = `-1`
  - 其它属性：getter=get_frame · setter=set_frame
- **`output_port_for_preview`** `int` = `-1`
  - 其它属性：getter=get_output_port_for_preview · setter=set_output_port_for_preview

## 方法

### `clear_default_input_values() -> void`

Clears the default input ports value.

### `get_default_input_port(type: int) -> int`
- 限定：qualifiers=const

Returns the input port which should be connected by default when this node is created as a result of dragging a connection from an existing node to the empty space on the graph.

### `get_default_input_values() -> Array`
- 限定：qualifiers=const

Returns an `Array` containing default values for all of the input ports of the node in the form `[index0, value0, index1, value1, ...]`.

### `get_input_port_default_value(port: int) -> Variant`
- 限定：qualifiers=const

Returns the default value of the input `port`.

### `remove_input_port_default_value(port: int) -> void`

Removes the default value of the input `port`.

### `set_default_input_values(values: Array) -> void`

Sets the default input ports values using an `Array` of the form `[index0, value0, index1, value1, ...]`. For example: `[0, Vector3(0, 0, 0), 1, Vector3(0, 0, 0)]`.

### `set_input_port_default_value(port: int, value: Variant, prev_value: Variant = null) -> void`

Sets the default `value` for the selected input `port`.

## 枚举

### `PortType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `PORT_TYPE_SCALAR` |  |
| `1` | `PORT_TYPE_SCALAR_INT` |  |
| `2` | `PORT_TYPE_SCALAR_UINT` |  |
| `3` | `PORT_TYPE_VECTOR_2D` |  |
| `4` | `PORT_TYPE_VECTOR_3D` |  |
| `5` | `PORT_TYPE_VECTOR_4D` |  |
| `6` | `PORT_TYPE_BOOLEAN` |  |
| `7` | `PORT_TYPE_TRANSFORM` |  |
| `8` | `PORT_TYPE_SAMPLER` |  |
| `9` | `PORT_TYPE_MAX` |  |

## 教程链接

- [Using VisualShaders](None)

