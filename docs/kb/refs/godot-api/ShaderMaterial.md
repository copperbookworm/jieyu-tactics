# ShaderMaterial

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ShaderMaterial` → `Material` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/ShaderMaterial.md`

**摘要**：A material defined by a custom `Shader` program and the values of its shader parameters.

## 描述

A material that uses a custom `Shader` program to render visual items (canvas items, meshes, skies, fog), or to process particles. Compared to other materials, `ShaderMaterial` gives deeper control over the generated shader code. For more information, see the shaders documentation index below.
		Multiple `ShaderMaterial`s can use the same shader and configure different values for the shader uniforms.
		**Note:** For performance reasons, the `Resource.changed` signal is only emitted when the `Resource.resource_name` changes. Only in editor, it is also emitted for `shader` changes.

## 属性

- **`shader`** `Shader`
  - 其它属性：getter=get_shader · setter=set_shader

## 方法

### `get_shader_parameter(param: StringName) -> Variant`
- 限定：qualifiers=const

Returns the current value set for this material of a uniform in the shader.

### `set_shader_parameter(param: StringName, value: Variant) -> void`

Changes the value set for this material of a uniform in the shader.
				**Note:** `param` is case-sensitive and must match the name of the uniform in the code exactly (not the capitalized name in the inspector).
				**Note:** Changes to the shader uniform will be effective on all instances using this `ShaderMaterial`. To prevent this, use per-instance uniforms with `CanvasItem.set_instance_shader_parameter`, `GeometryInstance3D.set_instance_shader_parameter` or duplicate the `ShaderMaterial` resource using `Resource.duplicate`. Per-instance uniforms allow for better shader reuse and are therefore faster, so they should be preferred over duplicating the `ShaderMaterial` when possible.

## 教程链接

- [Shaders documentation index](None)

