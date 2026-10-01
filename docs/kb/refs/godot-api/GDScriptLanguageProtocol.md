# GDScriptLanguageProtocol

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`GDScriptLanguageProtocol` → `JSONRPC` → `Object`
> 附加属性：api_type=editor · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/GDScriptLanguageProtocol.md`

**摘要**：GDScript language server.

## 描述

Provides access to certain features that are implemented in the language server.
		**Note:** This class is not a language server client that can be used to access LSP functionality. It only provides access to a limited set of features that is implemented using the same technical foundation as the language server.

## 方法

### `get_text_document() -> GDScriptTextDocument`
- 限定：deprecated=[GDScriptTextDocument] is deprecated.

Returns the language server's `GDScriptTextDocument` instance.

### `get_workspace() -> GDScriptWorkspace`

Returns the language server's `GDScriptWorkspace` instance.

### `initialize(params: Dictionary) -> Variant`
- 限定：deprecated=Accessing LSP endpoints directly might lead to unwanted side effects. Connect to the server via TCP, like a regular language server client.

### `initialized(params: Variant) -> void`
- 限定：deprecated=Accessing LSP endpoints directly might lead to unwanted side effects. Connect to the server via TCP, like a regular language server client.

### `is_initialized() -> bool`
- 限定：qualifiers=const

Returns `true` if the language server was initialized by a language server client, `false` otherwise.

### `is_smart_resolve_enabled() -> bool`
- 限定：qualifiers=const

Returns `true` if the language server is providing the smart resolve feature, `false` otherwise. The feature can be configured through the editor settings.

### `notify_client(method: String, params: Variant = null, client_id: int = -1) -> void`
- 限定：deprecated=Might result in unwanted side effects for connected clients.

### `on_client_connected() -> int`
- 限定：deprecated=Might result in unwanted side effects for connected clients.

### `on_client_disconnected(client_id: int) -> void`
- 限定：deprecated=Might result in unwanted side effects for connected clients.

