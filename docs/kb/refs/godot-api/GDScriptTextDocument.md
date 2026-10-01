# GDScriptTextDocument

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`GDScriptTextDocument` → `RefCounted` → `Object`
> 附加属性：api_type=editor · deprecated=
> 自动生成，勿手改。文件：`refs/godot-api/GDScriptTextDocument.md`

**摘要**：Document related language server functionality.

## 描述

Provides language server functionality related to documents.

## 方法

### `codeLens(params: Dictionary) -> Array`
- 限定：deprecated=Accessing LSP endpoints directly might lead to unwanted side effects. Connect to the server via TCP, like a regular language server client.

### `colorPresentation(params: Dictionary) -> Array`
- 限定：deprecated=Accessing LSP endpoints directly might lead to unwanted side effects. Connect to the server via TCP, like a regular language server client.

### `completion(params: Dictionary) -> Array`
- 限定：deprecated=Accessing LSP endpoints directly might lead to unwanted side effects. Connect to the server via TCP, like a regular language server client.

### `declaration(params: Dictionary) -> Variant`
- 限定：deprecated=Accessing LSP endpoints directly might lead to unwanted side effects. Connect to the server via TCP, like a regular language server client.

### `definition(params: Dictionary) -> Array`
- 限定：deprecated=Accessing LSP endpoints directly might lead to unwanted side effects. Connect to the server via TCP, like a regular language server client.

### `didChange(params: Variant) -> void`
- 限定：deprecated=Accessing LSP endpoints directly might lead to unwanted side effects. Connect to the server via TCP, like a regular language server client.

### `didClose(params: Variant) -> void`
- 限定：deprecated=Accessing LSP endpoints directly might lead to unwanted side effects. Connect to the server via TCP, like a regular language server client.

### `didOpen(params: Variant) -> void`
- 限定：deprecated=Accessing LSP endpoints directly might lead to unwanted side effects. Connect to the server via TCP, like a regular language server client.

### `didSave(params: Variant) -> void`
- 限定：deprecated=Accessing LSP endpoints directly might lead to unwanted side effects. Connect to the server via TCP, like a regular language server client.

### `documentLink(params: Dictionary) -> Array`
- 限定：deprecated=Accessing LSP endpoints directly might lead to unwanted side effects. Connect to the server via TCP, like a regular language server client.

### `documentSymbol(params: Dictionary) -> Array`
- 限定：deprecated=Accessing LSP endpoints directly might lead to unwanted side effects. Connect to the server via TCP, like a regular language server client.

### `foldingRange(params: Dictionary) -> Array`
- 限定：deprecated=Accessing LSP endpoints directly might lead to unwanted side effects. Connect to the server via TCP, like a regular language server client.

### `hover(params: Dictionary) -> Variant`
- 限定：deprecated=Accessing LSP endpoints directly might lead to unwanted side effects. Connect to the server via TCP, like a regular language server client.

### `nativeSymbol(params: Dictionary) -> Variant`
- 限定：deprecated=Accessing LSP endpoints directly might lead to unwanted side effects. Connect to the server via TCP, like a regular language server client.

### `prepareRename(params: Dictionary) -> Variant`
- 限定：deprecated=Accessing LSP endpoints directly might lead to unwanted side effects. Connect to the server via TCP, like a regular language server client.

### `references(params: Dictionary) -> Array`
- 限定：deprecated=Accessing LSP endpoints directly might lead to unwanted side effects. Connect to the server via TCP, like a regular language server client.

### `rename(params: Dictionary) -> Dictionary`
- 限定：deprecated=Accessing LSP endpoints directly might lead to unwanted side effects. Connect to the server via TCP, like a regular language server client.

### `resolve(params: Dictionary) -> Dictionary`
- 限定：deprecated=Accessing LSP endpoints directly might lead to unwanted side effects. Connect to the server via TCP, like a regular language server client.

### `show_native_symbol_in_editor(symbol_id: String) -> void`
- 限定：deprecated=Use [method ScriptEditor.goto_help] instead.

### `signatureHelp(params: Dictionary) -> Variant`
- 限定：deprecated=Accessing LSP endpoints directly might lead to unwanted side effects. Connect to the server via TCP, like a regular language server client.

### `willSaveWaitUntil(params: Variant) -> void`
- 限定：deprecated=Accessing LSP endpoints directly might lead to unwanted side effects. Connect to the server via TCP, like a regular language server client.

