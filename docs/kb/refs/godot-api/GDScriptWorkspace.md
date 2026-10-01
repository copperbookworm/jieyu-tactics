# GDScriptWorkspace

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`GDScriptWorkspace` → `RefCounted` → `Object`
> 附加属性：api_type=editor · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/GDScriptWorkspace.md`

**摘要**：Workspace related language server functionality.

## 描述

Provides language server functionality related to the workspace.

## 方法

### `apply_new_signal(obj: Object, function: String, args: PackedStringArray) -> void`
- 限定：deprecated=Might result in unwanted side effects for connected clients.

### `didDeleteFiles(params: Dictionary) -> void`
- 限定：deprecated=Accessing LSP endpoints directly might lead to unwanted side effects. Connect to the server via TCP, like a regular language server client.

### `generate_script_api(path: String) -> Dictionary`

Returns the interface of the script in a machine-readable format.

### `get_file_path(uri: String) -> String`

Converts a URI to a file path.

### `get_file_uri(path: String) -> String`
- 限定：qualifiers=const

Converts a file path to a URI.

### `parse_local_script(path: String) -> int`
- 限定：deprecated=Might result in unwanted side effects for connected clients.

### `parse_script(path: String, content: String) -> int`
- 限定：deprecated=Might result in unwanted side effects for connected clients.

### `publish_diagnostics(path: String) -> void`
- 限定：deprecated=Might result in unwanted side effects for connected clients.

