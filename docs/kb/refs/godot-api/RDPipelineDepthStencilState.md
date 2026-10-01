# RDPipelineDepthStencilState

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`RDPipelineDepthStencilState` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/RDPipelineDepthStencilState.md`

**摘要**：Pipeline depth/stencil state (used by `RenderingDevice`).

## 描述

`RDPipelineDepthStencilState` controls the way depth and stencil comparisons are performed when sampling those values using `RenderingDevice`.

## 属性

- **`back_op_compare`** `int` = `7` · 枚举 `RenderingDevice.CompareOperator`
  - 其它属性：getter=get_back_op_compare · setter=set_back_op_compare
- **`back_op_compare_mask`** `int` = `0`
  - 其它属性：getter=get_back_op_compare_mask · setter=set_back_op_compare_mask
- **`back_op_depth_fail`** `int` = `1` · 枚举 `RenderingDevice.StencilOperation`
  - 其它属性：getter=get_back_op_depth_fail · setter=set_back_op_depth_fail
- **`back_op_fail`** `int` = `1` · 枚举 `RenderingDevice.StencilOperation`
  - 其它属性：getter=get_back_op_fail · setter=set_back_op_fail
- **`back_op_pass`** `int` = `1` · 枚举 `RenderingDevice.StencilOperation`
  - 其它属性：getter=get_back_op_pass · setter=set_back_op_pass
- **`back_op_reference`** `int` = `0`
  - 其它属性：getter=get_back_op_reference · setter=set_back_op_reference
- **`back_op_write_mask`** `int` = `0`
  - 其它属性：getter=get_back_op_write_mask · setter=set_back_op_write_mask
- **`depth_compare_operator`** `int` = `7` · 枚举 `RenderingDevice.CompareOperator`
  - 其它属性：getter=get_depth_compare_operator · setter=set_depth_compare_operator
- **`depth_range_max`** `float` = `0.0`
  - 其它属性：getter=get_depth_range_max · setter=set_depth_range_max
- **`depth_range_min`** `float` = `0.0`
  - 其它属性：getter=get_depth_range_min · setter=set_depth_range_min
- **`enable_depth_range`** `bool` = `false`
  - 其它属性：getter=get_enable_depth_range · setter=set_enable_depth_range
- **`enable_depth_test`** `bool` = `false`
  - 其它属性：getter=get_enable_depth_test · setter=set_enable_depth_test
- **`enable_depth_write`** `bool` = `false`
  - 其它属性：getter=get_enable_depth_write · setter=set_enable_depth_write
- **`enable_stencil`** `bool` = `false`
  - 其它属性：getter=get_enable_stencil · setter=set_enable_stencil
- **`front_op_compare`** `int` = `7` · 枚举 `RenderingDevice.CompareOperator`
  - 其它属性：getter=get_front_op_compare · setter=set_front_op_compare
- **`front_op_compare_mask`** `int` = `0`
  - 其它属性：getter=get_front_op_compare_mask · setter=set_front_op_compare_mask
- **`front_op_depth_fail`** `int` = `1` · 枚举 `RenderingDevice.StencilOperation`
  - 其它属性：getter=get_front_op_depth_fail · setter=set_front_op_depth_fail
- **`front_op_fail`** `int` = `1` · 枚举 `RenderingDevice.StencilOperation`
  - 其它属性：getter=get_front_op_fail · setter=set_front_op_fail
- **`front_op_pass`** `int` = `1` · 枚举 `RenderingDevice.StencilOperation`
  - 其它属性：getter=get_front_op_pass · setter=set_front_op_pass
- **`front_op_reference`** `int` = `0`
  - 其它属性：getter=get_front_op_reference · setter=set_front_op_reference
- **`front_op_write_mask`** `int` = `0`
  - 其它属性：getter=get_front_op_write_mask · setter=set_front_op_write_mask

