# Material

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Material` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Material.md`

**摘要**：Virtual base class for applying visual properties to an object, such as color and roughness.

## 描述

`Material` is a base resource used for coloring and shading geometry. All materials inherit from it and almost all `VisualInstance3D` derived nodes carry a `Material`. A few flags and parameters are shared between all material types and are configured here.
		Importantly, you can inherit from `Material` to create your own custom material type in script or in GDExtension.

## 属性

- **`next_pass`** `Material`
  - 其它属性：getter=get_next_pass · setter=set_next_pass
- **`render_priority`** `int`
  - 其它属性：getter=get_render_priority · setter=set_render_priority

## 方法

### `_can_do_next_pass() -> bool`
- 限定：qualifiers=virtual const

Only exposed for the purpose of overriding. You cannot call this function directly. Used internally to determine if `next_pass` should be shown in the editor or not.

### `_can_use_render_priority() -> bool`
- 限定：qualifiers=virtual const

Only exposed for the purpose of overriding. You cannot call this function directly. Used internally to determine if `render_priority` should be shown in the editor or not.

### `_get_shader_mode() -> int`
- 限定：qualifiers=virtual required const

Only exposed for the purpose of overriding. You cannot call this function directly. Used internally by various editor tools.

### `_get_shader_rid() -> RID`
- 限定：qualifiers=virtual required const

Only exposed for the purpose of overriding. You cannot call this function directly. Used internally by various editor tools. Used to access the RID of the `Material`'s `Shader`.

### `create_placeholder() -> Resource`
- 限定：qualifiers=const

Creates a placeholder version of this resource (`PlaceholderMaterial`).

### `inspect_native_shader_code() -> void`

Only available when running in the editor. Opens a popup that visualizes the generated shader code, including all variants and internal shader code. See also `Shader.inspect_native_shader_code`.

## 常量

- **`RENDER_PRIORITY_MAX`** = `127`
- **`RENDER_PRIORITY_MIN`** = `-128`
## 教程链接

- [3D Material Testers Demo](None)
- [Third Person Shooter (TPS) Demo](None)

