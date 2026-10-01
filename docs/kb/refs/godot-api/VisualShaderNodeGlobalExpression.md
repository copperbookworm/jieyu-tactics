# VisualShaderNodeGlobalExpression

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VisualShaderNodeGlobalExpression` → `VisualShaderNodeExpression` → `VisualShaderNodeGroupBase` → `VisualShaderNodeResizableBase` → `VisualShaderNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VisualShaderNodeGlobalExpression.md`

**摘要**：A custom global visual shader graph expression written in Godot Shading Language.

## 描述

Custom Godot Shader Language expression, which is placed on top of the generated shader. You can place various function definitions inside to call later in `VisualShaderNodeExpression`s (which are injected in the main shader functions). You can also declare varyings, uniforms and global constants.

