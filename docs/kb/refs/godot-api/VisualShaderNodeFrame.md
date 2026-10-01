# VisualShaderNodeFrame

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VisualShaderNodeFrame` → `VisualShaderNodeResizableBase` → `VisualShaderNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VisualShaderNodeFrame.md`

**摘要**：A frame other visual shader nodes can be attached to for better organization.

## 描述

A rectangular frame that can be used to group visual shader nodes together to improve organization.
		Nodes attached to the frame will move with it when it is dragged and it can automatically resize to enclose all attached nodes.
		Its title, description and color can be customized.

## 属性

- **`attached_nodes`** `PackedInt32Array` = `PackedInt32Array()`
  - 其它属性：getter=get_attached_nodes · setter=set_attached_nodes
- **`autoshrink`** `bool` = `true`
  - 其它属性：getter=is_autoshrink_enabled · setter=set_autoshrink_enabled
- **`tint_color`** `Color` = `Color(0.3, 0.3, 0.3, 0.75)`
  - 其它属性：getter=get_tint_color · setter=set_tint_color
- **`tint_color_enabled`** `bool` = `false`
  - 其它属性：getter=is_tint_color_enabled · setter=set_tint_color_enabled
- **`title`** `String` = `"Title"`
  - 其它属性：getter=get_title · setter=set_title

## 方法

### `add_attached_node(node: int) -> void`

Adds a node to the list of nodes attached to the frame. Should not be called directly, use the `VisualShader.attach_node_to_frame` method instead.

### `remove_attached_node(node: int) -> void`

Removes a node from the list of nodes attached to the frame. Should not be called directly, use the `VisualShader.detach_node_from_frame` method instead.

