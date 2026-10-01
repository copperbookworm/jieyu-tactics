# Shader

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Shader` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Shader.md`

**摘要**：A shader implemented in the Godot shading language.

## 描述

A custom shader program implemented in the Godot shading language, saved with the `.gdshader` extension.
		This class is used by a `ShaderMaterial` and allows you to write your own custom behavior for rendering visual items or updating particle information. For a detailed explanation and usage, please see the tutorials linked below.

## 属性

- **`code`** `String` = `""`
  - 其它属性：getter=get_code · setter=set_code

## 方法

### `get_default_texture_parameter(name: StringName, index: int = 0) -> Texture`
- 限定：qualifiers=const

Returns the texture that is set as default for the specified parameter.
				**Note:** `name` must match the name of the uniform in the code exactly.
				**Note:** If the sampler array is used use `index` to access the specified texture.

### `get_mode() -> int`
- 限定：qualifiers=const

Returns the shader mode for the shader.

### `get_shader_uniform_list(get_groups: bool = false) -> Array`

Returns the list of shader uniforms that can be assigned to a `ShaderMaterial`, for use with `ShaderMaterial.set_shader_parameter` and `ShaderMaterial.get_shader_parameter`. The parameters returned are contained in dictionaries in a similar format to the ones returned by `Object.get_property_list`.
				If argument `get_groups` is `true`, parameter grouping hints are also included in the list.

### `inspect_native_shader_code() -> void`

Only available when running in the editor. Opens a popup that visualizes the generated shader code, including all variants and internal shader code. See also `Material.inspect_native_shader_code`.

### `set_default_texture_parameter(name: StringName, texture: Texture, index: int = 0) -> void`

Sets the default texture to be used with a texture uniform. The default is used if a texture is not set in the `ShaderMaterial`.
				**Note:** `name` must match the name of the uniform in the code exactly.
				**Note:** If the sampler array is used use `index` to access the specified texture.

## 枚举

### `Mode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `MODE_SPATIAL` |  |
| `1` | `MODE_CANVAS_ITEM` |  |
| `2` | `MODE_PARTICLES` |  |
| `3` | `MODE_SKY` |  |
| `4` | `MODE_FOG` |  |
| `5` | `MODE_TEXTURE_BLIT` |  |

## 教程链接

- [Shaders documentation index](None)

