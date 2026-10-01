# VisualShaderNodeReroute

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VisualShaderNodeReroute` → `VisualShaderNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VisualShaderNodeReroute.md`

**摘要**：A node that allows rerouting a connection within the visual shader graph.

## 描述

Automatically adapts its port type to the type of the incoming connection and ensures valid connections.

## 方法

### `get_port_type() -> int`
- 限定：qualifiers=const

Returns the port type of the reroute node.

