# ShaderIncludeDB

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ShaderIncludeDB` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/ShaderIncludeDB.md`

**摘要**：Internal database of built in shader include files.

## 描述

This object contains shader fragments from Godot's internal shaders. These can be used when access to internal uniform buffers and/or internal functions is required for instance when composing compositor effects or compute shaders. Only fragments for the current rendering device are loaded.

## 方法

### `get_built_in_include_file(filename: String) -> String`
- 限定：qualifiers=static

Returns the code for the built-in shader fragment. You can also access this in your shader code through `#include "filename"`.

### `has_built_in_include_file(filename: String) -> bool`
- 限定：qualifiers=static

Returns `true` if an include file with this name exists.

### `list_built_in_include_files() -> PackedStringArray`
- 限定：qualifiers=static

Returns a list of built-in include files that are currently registered.

