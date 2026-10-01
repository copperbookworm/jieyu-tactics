# RDPipelineColorBlendStateAttachment

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`RDPipelineColorBlendStateAttachment` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/RDPipelineColorBlendStateAttachment.md`

**摘要**：Pipeline color blend state attachment (used by `RenderingDevice`).

## 描述

Controls how blending between source and destination fragments is performed when using `RenderingDevice`.
		For reference, this is how common user-facing blend modes are implemented in Godot's 2D renderer:
		**Mix:**
		
```gdscript
		var attachment = RDPipelineColorBlendStateAttachment.new()
		attachment.enable_blend = true
		attachment.color_blend_op = RenderingDevice.BLEND_OP_ADD
		attachment.src_color_blend_factor = RenderingDevice.BLEND_FACTOR_SRC_ALPHA
		attachment.dst_color_blend_factor = RenderingDevice.BLEND_FACTOR_ONE_MINUS_SRC_ALPHA
		attachment.alpha_blend_op = RenderingDevice.BLEND_OP_ADD
		attachment.src_alpha_blend_factor = RenderingDevice.BLEND_FACTOR_ONE
		attachment.dst_alpha_blend_factor = RenderingDevice.BLEND_FACTOR_ONE_MINUS_SRC_ALPHA
		
```

		**Add:**
		
```gdscript
		var attachment = RDPipelineColorBlendStateAttachment.new()
		attachment.enable_blend = true
		attachment.alpha_blend_op = RenderingDevice.BLEND_OP_ADD
		attachment.color_blend_op = RenderingDevice.BLEND_OP_ADD
		attachment.src_color_blend_factor = RenderingDevice.BLEND_FACTOR_SRC_ALPHA
		attachment.dst_color_blend_factor = RenderingDevice.BLEND_FACTOR_ONE
		attachment.src_alpha_blend_factor = RenderingDevice.BLEND_FACTOR_SRC_ALPHA
		attachment.dst_alpha_blend_factor = RenderingDevice.BLEND_FACTOR_ONE
		
```

		**Subtract:**
		
```gdscript
		var attachment = RDPipelineColorBlendStateAttachment.new()
		attachment.enable_blend = true
		attachment.alpha_blend_op = RenderingDevice.BLEND_OP_REVERSE_SUBTRACT
		attachment.color_blend_op = RenderingDevice.BLEND_OP_REVERSE_SUBTRACT
		attachment.src_color_blend_factor = RenderingDevice.BLEND_FACTOR_SRC_ALPHA
		attachment.dst_color_blend_factor = RenderingDevice.BLEND_FACTOR_ONE
		attachment.src_alpha_blend_factor = RenderingDevice.BLEND_FACTOR_SRC_ALPHA
		attachment.dst_alpha_blend_factor = RenderingDevice.BLEND_FACTOR_ONE
		
```

		**Multiply:**
		
```gdscript
		var attachment = RDPipelineColorBlendStateAttachment.new()
		attachment.enable_blend = true
		attachment.alpha_blend_op = RenderingDevice.BLEND_OP_ADD
		attachment.color_blend_op = RenderingDevice.BLEND_OP_ADD
		attachment.src_color_blend_factor = RenderingDevice.BLEND_FACTOR_DST_COLOR
		attachment.dst_color_blend_factor = RenderingDevice.BLEND_FACTOR_ZERO
		attachment.src_alpha_blend_factor = RenderingDevice.BLEND_FACTOR_DST_ALPHA
		attachment.dst_alpha_blend_factor = RenderingDevice.BLEND_FACTOR_ZERO
		
```

		**Pre-multiplied alpha:**
		
```gdscript
		var attachment = RDPipelineColorBlendStateAttachment.new()
		attachment.enable_blend = true
		attachment.alpha_blend_op = RenderingDevice.BLEND_OP_ADD
		attachment.color_blend_op = RenderingDevice.BLEND_OP_ADD
		attachment.src_color_blend_factor = RenderingDevice.BLEND_FACTOR_ONE
		attachment.dst_color_blend_factor = RenderingDevice.BLEND_FACTOR_ONE_MINUS_SRC_ALPHA
		attachment.src_alpha_blend_factor = RenderingDevice.BLEND_FACTOR_ONE
		attachment.dst_alpha_blend_factor = RenderingDevice.BLEND_FACTOR_ONE_MINUS_SRC_ALPHA
		
```

## 属性

- **`alpha_blend_op`** `int` = `0` · 枚举 `RenderingDevice.BlendOperation`
  - 其它属性：getter=get_alpha_blend_op · setter=set_alpha_blend_op
- **`color_blend_op`** `int` = `0` · 枚举 `RenderingDevice.BlendOperation`
  - 其它属性：getter=get_color_blend_op · setter=set_color_blend_op
- **`dst_alpha_blend_factor`** `int` = `0` · 枚举 `RenderingDevice.BlendFactor`
  - 其它属性：getter=get_dst_alpha_blend_factor · setter=set_dst_alpha_blend_factor
- **`dst_color_blend_factor`** `int` = `0` · 枚举 `RenderingDevice.BlendFactor`
  - 其它属性：getter=get_dst_color_blend_factor · setter=set_dst_color_blend_factor
- **`enable_blend`** `bool` = `false`
  - 其它属性：getter=get_enable_blend · setter=set_enable_blend
- **`src_alpha_blend_factor`** `int` = `0` · 枚举 `RenderingDevice.BlendFactor`
  - 其它属性：getter=get_src_alpha_blend_factor · setter=set_src_alpha_blend_factor
- **`src_color_blend_factor`** `int` = `0` · 枚举 `RenderingDevice.BlendFactor`
  - 其它属性：getter=get_src_color_blend_factor · setter=set_src_color_blend_factor
- **`write_a`** `bool` = `true`
  - 其它属性：getter=get_write_a · setter=set_write_a
- **`write_b`** `bool` = `true`
  - 其它属性：getter=get_write_b · setter=set_write_b
- **`write_g`** `bool` = `true`
  - 其它属性：getter=get_write_g · setter=set_write_g
- **`write_r`** `bool` = `true`
  - 其它属性：getter=get_write_r · setter=set_write_r

## 方法

### `set_as_mix() -> void`

Convenience method to perform standard mix blending with straight (non-premultiplied) alpha. This sets `enable_blend` to `true`, `src_color_blend_factor` to `RenderingDevice.BLEND_FACTOR_SRC_ALPHA`, `dst_color_blend_factor` to `RenderingDevice.BLEND_FACTOR_ONE_MINUS_SRC_ALPHA`, `src_alpha_blend_factor` to `RenderingDevice.BLEND_FACTOR_SRC_ALPHA` and `dst_alpha_blend_factor` to `RenderingDevice.BLEND_FACTOR_ONE_MINUS_SRC_ALPHA`.

