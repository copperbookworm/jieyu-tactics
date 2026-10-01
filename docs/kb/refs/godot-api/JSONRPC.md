# JSONRPC

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`JSONRPC` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/JSONRPC.md`

**摘要**：A helper to handle dictionaries which look like JSONRPC documents.

## 描述

JSON-RPC (https://www.jsonrpc.org/) is a standard which wraps a method call in a `JSON` object. The object has a particular structure and identifies which method is called, the parameters to that function, and carries an ID to keep track of responses. This class implements that standard on top of `Dictionary`; you will have to convert between a `Dictionary` and `JSON` with other functions.

## 方法

### `make_notification(method: String, params: Variant) -> Dictionary`

Returns a dictionary in the form of a JSON-RPC notification. Notifications are one-shot messages which do not expect a response.
				- `method`: Name of the method being called.
				- `params`: An array or dictionary of parameters being passed to the method.

### `make_request(method: String, params: Variant, id: Variant) -> Dictionary`

Returns a dictionary in the form of a JSON-RPC request. Requests are sent to a server with the expectation of a response. The ID field is used for the server to specify which exact request it is responding to.
				- `method`: Name of the method being called.
				- `params`: An array or dictionary of parameters being passed to the method.
				- `id`: Uniquely identifies this request. The server is expected to send a response with the same ID.

### `make_response(result: Variant, id: Variant) -> Dictionary`

When a server has received and processed a request, it is expected to send a response. If you did not want a response then you need to have sent a Notification instead.
				- `result`: The return value of the function which was called.
				- `id`: The ID of the request this response is targeted to.

### `make_response_error(code: int, message: String, id: Variant = null) -> Dictionary`
- 限定：qualifiers=const

Creates a response which indicates a previous reply has failed in some way.
				- `code`: The error code corresponding to what kind of error this is. See the `ErrorCode` constants.
				- `message`: A custom message about this error.
				- `id`: The request this error is a response to.

### `process_action(action: Variant, recurse: bool = false) -> Variant`

Given a Dictionary which takes the form of a JSON-RPC request: unpack the request and run it. Methods are resolved by looking at the field called "method" and looking for an equivalently named function in the JSONRPC object. If one is found that method is called.
				To add new supported methods extend the JSONRPC class and call `process_action` on your subclass.
				`action`: The action to be run, as a Dictionary in the form of a JSON-RPC request or notification.

### `process_string(action: String) -> String`

### `set_method(name: String, callback: Callable) -> void`

Registers a callback for the given method name.
				- `name`: The name that clients can use to access the callback.
				- `callback`: The callback which will handle the specified method.

## 枚举

### `ErrorCode`

| 值 | 名称 | 说明 |
|---|---|---|
| `-32700` | `PARSE_ERROR` |  |
| `-32600` | `INVALID_REQUEST` |  |
| `-32601` | `METHOD_NOT_FOUND` |  |
| `-32602` | `INVALID_PARAMS` |  |
| `-32603` | `INTERNAL_ERROR` |  |

