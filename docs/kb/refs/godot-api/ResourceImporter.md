# ResourceImporter

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ResourceImporter` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/ResourceImporter.md`

**摘要**：Base class for resource importers.

## 描述

This is the base class for Godot's resource importers. To implement your own resource importers using editor plugins, see `EditorImportPlugin`.

## 方法

### `_get_build_dependencies(path: String) -> PackedStringArray`
- 限定：qualifiers=virtual const

Called when the engine compilation profile editor wants to check what build options an imported resource needs. For example, `ResourceImporterDynamicFont` has a property called `ResourceImporterDynamicFont.multichannel_signed_distance_field`, that depends on the engine to be build with the "msdfgen" module. If that resource happened to be a custom one, it would be handled like this:
				
```gdscript
				func _get_build_dependencies(path):
					var resource = load(path)
					var dependencies = PackedStringArray()

					if resource.multichannel_signed_distance_field:
						dependencies.push_back("module_msdfgen_enabled")

					return dependencies
				
```

## 枚举

### `ImportOrder`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `IMPORT_ORDER_DEFAULT` |  |
| `100` | `IMPORT_ORDER_SCENE` |  |

## 教程链接

- [Import plugins](None)

