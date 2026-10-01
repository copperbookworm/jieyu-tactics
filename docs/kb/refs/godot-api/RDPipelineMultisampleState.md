# RDPipelineMultisampleState

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`RDPipelineMultisampleState` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/RDPipelineMultisampleState.md`

**摘要**：Pipeline multisample state (used by `RenderingDevice`).

## 描述

`RDPipelineMultisampleState` is used to control how multisample or supersample antialiasing is being performed when rendering using `RenderingDevice`.

## 属性

- **`enable_alpha_to_coverage`** `bool` = `false`
  - 其它属性：getter=get_enable_alpha_to_coverage · setter=set_enable_alpha_to_coverage
- **`enable_alpha_to_one`** `bool` = `false`
  - 其它属性：getter=get_enable_alpha_to_one · setter=set_enable_alpha_to_one
- **`enable_sample_shading`** `bool` = `false`
  - 其它属性：getter=get_enable_sample_shading · setter=set_enable_sample_shading
- **`min_sample_shading`** `float` = `0.0`
  - 其它属性：getter=get_min_sample_shading · setter=set_min_sample_shading
- **`sample_count`** `int` = `0` · 枚举 `RenderingDevice.TextureSamples`
  - 其它属性：getter=get_sample_count · setter=set_sample_count
- **`sample_masks`** `int[]` = `[]`
  - 其它属性：getter=get_sample_masks · setter=set_sample_masks

