# EditorFileSystemImportFormatSupportQuery

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`EditorFileSystemImportFormatSupportQuery` → `RefCounted` → `Object`
> 附加属性：api_type=editor
> 自动生成，勿手改。文件：`refs/godot-api/EditorFileSystemImportFormatSupportQuery.md`

**摘要**：Used to query and configure import format support.

## 描述

This class is used to query and configure a certain import format. It is used in conjunction with asset format import plugins.

## 方法

### `_get_file_extensions() -> PackedStringArray`
- 限定：qualifiers=virtual required const

Return the file extensions supported.

### `_is_active() -> bool`
- 限定：qualifiers=virtual required const

Return whether this importer is active.

### `_query() -> bool`
- 限定：qualifiers=virtual required const

Query support. Return `false` if import must not continue.

