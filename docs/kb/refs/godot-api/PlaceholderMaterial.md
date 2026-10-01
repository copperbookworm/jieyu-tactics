# PlaceholderMaterial

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`PlaceholderMaterial` → `Material` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/PlaceholderMaterial.md`

**摘要**：Placeholder class for a material.

## 描述

This class is used when loading a project that uses a `Material` subclass in 2 conditions:
		- When running the project exported in dedicated server mode, only the texture's dimensions are kept (as they may be relied upon for gameplay purposes or positioning of other elements). This allows reducing the exported PCK's size significantly.
		- When this subclass is missing due to using a different engine version or build (e.g. modules disabled).

