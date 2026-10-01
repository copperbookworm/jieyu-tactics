# ShaderGlobalsOverride

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ShaderGlobalsOverride` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/ShaderGlobalsOverride.md`

**摘要**：A node used to override global shader parameters' values in a scene.

## 描述

Similar to how a `WorldEnvironment` node can be used to override the environment while a specific scene is loaded, `ShaderGlobalsOverride` can be used to override global shader parameters temporarily. Once the node is removed, the project-wide values for the global shader parameters are restored. See the `RenderingServer` `global_shader_parameter_*` methods for more information.
		**Note:** Only one `ShaderGlobalsOverride` can be used per scene. If there is more than one `ShaderGlobalsOverride` node in the scene tree, only the first node (in tree order) will be taken into account.
		**Note:** All `ShaderGlobalsOverride` nodes are made part of a `"shader_overrides_group"` group when they are added to the scene tree. The currently active `ShaderGlobalsOverride` node also has a `"shader_overrides_group_active"` group added to it. You can use this to check which `ShaderGlobalsOverride` node is currently active.

## 教程链接

- [Shading language](None)

