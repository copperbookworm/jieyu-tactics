# VisualShaderNodeExpression

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VisualShaderNodeExpression` → `VisualShaderNodeGroupBase` → `VisualShaderNodeResizableBase` → `VisualShaderNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VisualShaderNodeExpression.md`

**摘要**：A custom visual shader graph expression written in Godot Shading Language.

## 描述

Custom Godot Shading Language expression, with a custom number of input and output ports.
		The provided code is directly injected into the graph's matching shader function (`vertex`, `fragment`, or `light`), so it cannot be used to declare functions, varyings, uniforms, or global constants. See `VisualShaderNodeGlobalExpression` for such global definitions.

## 属性

- **`expression`** `String` = `""`
  - 其它属性：getter=get_expression · setter=set_expression

