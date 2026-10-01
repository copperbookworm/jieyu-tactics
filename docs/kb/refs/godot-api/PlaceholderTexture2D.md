# PlaceholderTexture2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`PlaceholderTexture2D` → `Texture2D` → `Texture` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/PlaceholderTexture2D.md`

**摘要**：Placeholder class for a 2-dimensional texture.

## 描述

This class is used when loading a project that uses a `Texture2D` subclass in 2 conditions:
		- When running the project exported in dedicated server mode, only the texture's dimensions are kept (as they may be relied upon for gameplay purposes or positioning of other elements). This allows reducing the exported PCK's size significantly.
		- When this subclass is missing due to using a different engine version or build (e.g. modules disabled).
		**Note:** This is not intended to be used as an actual texture for rendering. It is not guaranteed to work like one in shaders or materials (for example when calculating UV).

## 属性

- **`resource_local_to_scene`** `bool` = `false`
  - 其它属性：getter=is_local_to_scene · overrides=Resource · setter=set_local_to_scene
- **`size`** `Vector2` = `Vector2(1, 1)`
  - 其它属性：getter=get_size · setter=set_size

