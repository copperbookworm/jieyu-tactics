# RDFramebufferPass

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`RDFramebufferPass` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/RDFramebufferPass.md`

**摘要**：Framebuffer pass attachment description (used by `RenderingDevice`).

## 描述

This class contains the list of attachment descriptions for a framebuffer pass. Each points with an index to a previously supplied list of texture attachments.
		Multipass framebuffers can optimize some configurations in mobile. On desktop, they provide little to no advantage.
		This object is used by `RenderingDevice`.

## 属性

- **`color_attachments`** `PackedInt32Array` = `PackedInt32Array()`
  - 其它属性：getter=get_color_attachments · setter=set_color_attachments
- **`depth_attachment`** `int` = `-1`
  - 其它属性：getter=get_depth_attachment · setter=set_depth_attachment
- **`input_attachments`** `PackedInt32Array` = `PackedInt32Array()`
  - 其它属性：getter=get_input_attachments · setter=set_input_attachments
- **`preserve_attachments`** `PackedInt32Array` = `PackedInt32Array()`
  - 其它属性：getter=get_preserve_attachments · setter=set_preserve_attachments
- **`resolve_attachments`** `PackedInt32Array` = `PackedInt32Array()`
  - 其它属性：getter=get_resolve_attachments · setter=set_resolve_attachments

## 常量

- **`ATTACHMENT_UNUSED`** = `-1`
