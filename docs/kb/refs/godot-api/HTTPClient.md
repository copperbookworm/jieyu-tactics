# HTTPClient

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`HTTPClient` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/HTTPClient.md`

**摘要**：Low-level hyper-text transfer protocol client.

## 描述

Hyper-text transfer protocol client (sometimes called "User Agent"). Used to make HTTP requests to download web content, upload files and other data or to communicate with various services, among other use cases.
		See the `HTTPRequest` node for a higher-level alternative.
		**Note:** This client only needs to connect to a host once (see `connect_to_host`) to send multiple requests. Because of this, methods that take URLs usually take just the part after the host instead of the full URL, as the client is already connected to a host. See `request` for a full example and to get started.
		An `HTTPClient` should be reused between multiple requests or to connect to different hosts instead of creating one client per request. Supports Transport Layer Security (TLS), including server certificate verification. HTTP status codes in the 2xx range indicate success, 3xx redirection (i.e. "try again, but over here"), 4xx something was wrong with the request, and 5xx something went wrong on the server's side.
		For more information on HTTP, see MDN's documentation on HTTP (https://developer.mozilla.org/en-US/docs/Web/HTTP) (or read RFC 2616 (https://tools.ietf.org/html/rfc2616) to get it straight from the source).
		**Note:** When exporting to Android, make sure to enable the `INTERNET` permission in the Android export preset before exporting the project or using one-click deploy. Otherwise, network communication of any kind will be blocked by Android.
		**Note:** It's recommended to use transport encryption (TLS) and to avoid sending sensitive information (such as login credentials) in HTTP GET URL parameters. Consider using HTTP POST requests or HTTP headers for such information instead.
		**Note:** When performing HTTP requests from a project exported to Web, keep in mind the remote server may not allow requests from foreign origins due to CORS (https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS). If you host the server in question, you should modify its backend to allow requests from foreign origins by adding the `Access-Control-Allow-Origin: *` HTTP header.
		**Note:** TLS support is currently limited to TLSv1.2 and TLSv1.3. Attempting to connect to a server that only supports older (insecure) TLS versions will return an error.
		**Warning:** TLS certificate revocation and certificate pinning are currently not supported. Revoked certificates are accepted as long as they are otherwise valid. If this is a concern, you may want to use automatically managed certificates with a short validity period.

## 属性

- **`blocking_mode_enabled`** `bool` = `false`
  - 其它属性：getter=is_blocking_mode_enabled · setter=set_blocking_mode
- **`connection`** `StreamPeer`
  - 其它属性：getter=get_connection · setter=set_connection
- **`read_chunk_size`** `int` = `65536`
  - 其它属性：getter=get_read_chunk_size · setter=set_read_chunk_size

## 方法

### `close() -> void`

Closes the current connection, allowing reuse of this `HTTPClient`.

### `connect_to_host(host: String, port: int = -1, tls_options: TLSOptions = null) -> int`

Connects to a host. This needs to be done before any requests are sent.
				If no `port` is specified (or `-1` is used), it is automatically set to 80 for HTTP and 443 for HTTPS. You can pass the optional `tls_options` parameter to customize the trusted certification authorities, or the common name verification when using HTTPS. See `TLSOptions.client` and `TLSOptions.client_unsafe`.

### `get_response_body_length() -> int`
- 限定：qualifiers=const

Returns the response's body length.
				**Note:** Some Web servers may not send a body length. In this case, the value returned will be `-1`. If using chunked transfer encoding, the body length will also be `-1`.
				**Note:** This function always returns `-1` on the Web platform due to browsers limitations.

### `get_response_code() -> int`
- 限定：qualifiers=const

Returns the response's HTTP status code.

### `get_response_headers() -> PackedStringArray`

Returns the response headers.

### `get_response_headers_as_dictionary() -> Dictionary`

Returns all response headers as a `Dictionary`. Each entry is composed by the header name, and a `String` containing the values separated by `"; "`. The casing is kept the same as the headers were received.
				
```gdscript
				{
					"content-length": 12,
					"Content-Type": "application/json; charset=UTF-8",
				}
				
```

### `get_status() -> int`
- 限定：qualifiers=const

Returns a `Status` constant. Need to call `poll` in order to get status updates.

### `has_response() -> bool`
- 限定：qualifiers=const

If `true`, this `HTTPClient` has a response available.

### `is_response_chunked() -> bool`
- 限定：qualifiers=const

If `true`, this `HTTPClient` has a response that is chunked.

### `poll() -> int`

This needs to be called in order to have any request processed. Check results with `get_status`.

### `query_string_from_dict(fields: Dictionary) -> String`

Generates a GET/POST application/x-www-form-urlencoded style query string from a provided dictionary, e.g.:
				`codeblocks`
				`gdscript`
				var fields = { "username": "user", "password": "pass" }
				var query_string = http_client.query_string_from_dict(fields)
				# Returns "username=user&password=pass"
				
				`csharp`
				var fields = new Godot.Collections.Dictionary { { "username", "user" }, { "password", "pass" } };
				string queryString = httpClient.QueryStringFromDict(fields);
				// Returns "username=user&password=pass"
				
				
				Furthermore, if a key has a `null` value, only the key itself is added, without equal sign and value. If the value is an array, for each value in it a pair with the same key is added.
				`codeblocks`
				`gdscript`
				var fields = { "single": 123, "not_valued": null, "multiple": [22, 33, 44] }
				var query_string = http_client.query_string_from_dict(fields)
				# Returns "single=123&not_valued&multiple=22&multiple=33&multiple=44"
				
				`csharp`
				var fields = new Godot.Collections.Dictionary
				{
					{ "single", 123 },
					{ "notValued", default },
					{ "multiple", new Godot.Collections.Array { 22, 33, 44 } },
				};
				string queryString = httpClient.QueryStringFromDict(fields);
				// Returns "single=123&not_valued&multiple=22&multiple=33&multiple=44"

### `read_response_body_chunk() -> PackedByteArray`

Reads one chunk from the response.

### `request(method: int, url: String, headers: PackedStringArray, body: String = "") -> int`

Sends an HTTP request to the connected host with the given `method`.
				The URL parameter is usually just the part after the host, so for `https://example.com/index.php`, it is `/index.php`. When sending requests to an HTTP proxy server, it should be an absolute URL. For `HTTPClient.METHOD_OPTIONS` requests, `*` is also allowed. For `HTTPClient.METHOD_CONNECT` requests, it should be the authority component (`host:port`).
				`headers` are HTTP request headers.
				To create a POST request with query strings to push to the server, do:
				`codeblocks`
				`gdscript`
				var fields = { "username": "user", "password": "pass" }
				var query_string = http_client.query_string_from_dict(fields)
				var headers = ["Content-Type: application/x-www-form-urlencoded", "Content-Length: " + str(query_string.length())]
				var result = http_client.request(http_client.METHOD_POST, "/index.php", headers, query_string)
				
				`csharp`
				var fields = new Godot.Collections.Dictionary { { "username", "user" }, { "password", "pass" } };
				string queryString = new HttpClient().QueryStringFromDict(fields);
				string[] headers = ["Content-Type: application/x-www-form-urlencoded", $"Content-Length: {queryString.Length}"];
				var result = new HttpClient().Request(HttpClient.Method.Post, "index.php", headers, queryString);
				
				
				**Note:** The `body` parameter is ignored if `method` is `HTTPClient.METHOD_GET`. This is because GET methods can't contain request data. As a workaround, you can pass request data as a query string in the URL. See `String.uri_encode` for an example.

### `request_raw(method: int, url: String, headers: PackedStringArray, body: PackedByteArray) -> int`

Sends a raw HTTP request to the connected host with the given `method`.
				The URL parameter is usually just the part after the host, so for `https://example.com/index.php`, it is `/index.php`. When sending requests to an HTTP proxy server, it should be an absolute URL. For `HTTPClient.METHOD_OPTIONS` requests, `*` is also allowed. For `HTTPClient.METHOD_CONNECT` requests, it should be the authority component (`host:port`).
				`headers` are HTTP request headers.
				Sends the body data raw, as a byte array and does not encode it in any way.

### `set_http_proxy(host: String, port: int) -> void`

Sets the proxy server for HTTP requests.
				The proxy server is unset if `host` is empty or `port` is -1.

### `set_https_proxy(host: String, port: int) -> void`

Sets the proxy server for HTTPS requests.
				The proxy server is unset if `host` is empty or `port` is -1.

## 枚举

### `Method`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `METHOD_GET` |  |
| `1` | `METHOD_HEAD` |  |
| `2` | `METHOD_POST` |  |
| `3` | `METHOD_PUT` |  |
| `4` | `METHOD_DELETE` |  |
| `5` | `METHOD_OPTIONS` |  |
| `6` | `METHOD_TRACE` |  |
| `7` | `METHOD_CONNECT` |  |
| `8` | `METHOD_PATCH` |  |
| `9` | `METHOD_MAX` |  |

### `Status`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `STATUS_DISCONNECTED` |  |
| `1` | `STATUS_RESOLVING` |  |
| `2` | `STATUS_CANT_RESOLVE` |  |
| `3` | `STATUS_CONNECTING` |  |
| `4` | `STATUS_CANT_CONNECT` |  |
| `5` | `STATUS_CONNECTED` |  |
| `6` | `STATUS_REQUESTING` |  |
| `7` | `STATUS_BODY` |  |
| `8` | `STATUS_CONNECTION_ERROR` |  |
| `9` | `STATUS_TLS_HANDSHAKE_ERROR` |  |

### `ResponseCode`

| 值 | 名称 | 说明 |
|---|---|---|
| `100` | `RESPONSE_CONTINUE` |  |
| `101` | `RESPONSE_SWITCHING_PROTOCOLS` |  |
| `102` | `RESPONSE_PROCESSING` |  |
| `200` | `RESPONSE_OK` |  |
| `201` | `RESPONSE_CREATED` |  |
| `202` | `RESPONSE_ACCEPTED` |  |
| `203` | `RESPONSE_NON_AUTHORITATIVE_INFORMATION` |  |
| `204` | `RESPONSE_NO_CONTENT` |  |
| `205` | `RESPONSE_RESET_CONTENT` |  |
| `206` | `RESPONSE_PARTIAL_CONTENT` |  |
| `207` | `RESPONSE_MULTI_STATUS` |  |
| `208` | `RESPONSE_ALREADY_REPORTED` |  |
| `226` | `RESPONSE_IM_USED` |  |
| `300` | `RESPONSE_MULTIPLE_CHOICES` |  |
| `301` | `RESPONSE_MOVED_PERMANENTLY` |  |
| `302` | `RESPONSE_FOUND` |  |
| `303` | `RESPONSE_SEE_OTHER` |  |
| `304` | `RESPONSE_NOT_MODIFIED` |  |
| `305` | `RESPONSE_USE_PROXY` |  |
| `306` | `RESPONSE_SWITCH_PROXY` |  |
| `307` | `RESPONSE_TEMPORARY_REDIRECT` |  |
| `308` | `RESPONSE_PERMANENT_REDIRECT` |  |
| `400` | `RESPONSE_BAD_REQUEST` |  |
| `401` | `RESPONSE_UNAUTHORIZED` |  |
| `402` | `RESPONSE_PAYMENT_REQUIRED` |  |
| `403` | `RESPONSE_FORBIDDEN` |  |
| `404` | `RESPONSE_NOT_FOUND` |  |
| `405` | `RESPONSE_METHOD_NOT_ALLOWED` |  |
| `406` | `RESPONSE_NOT_ACCEPTABLE` |  |
| `407` | `RESPONSE_PROXY_AUTHENTICATION_REQUIRED` |  |
| `408` | `RESPONSE_REQUEST_TIMEOUT` |  |
| `409` | `RESPONSE_CONFLICT` |  |
| `410` | `RESPONSE_GONE` |  |
| `411` | `RESPONSE_LENGTH_REQUIRED` |  |
| `412` | `RESPONSE_PRECONDITION_FAILED` |  |
| `413` | `RESPONSE_REQUEST_ENTITY_TOO_LARGE` |  |
| `414` | `RESPONSE_REQUEST_URI_TOO_LONG` |  |
| `415` | `RESPONSE_UNSUPPORTED_MEDIA_TYPE` |  |
| `416` | `RESPONSE_REQUESTED_RANGE_NOT_SATISFIABLE` |  |
| `417` | `RESPONSE_EXPECTATION_FAILED` |  |
| `418` | `RESPONSE_IM_A_TEAPOT` |  |
| `421` | `RESPONSE_MISDIRECTED_REQUEST` |  |
| `422` | `RESPONSE_UNPROCESSABLE_ENTITY` |  |
| `423` | `RESPONSE_LOCKED` |  |
| `424` | `RESPONSE_FAILED_DEPENDENCY` |  |
| `426` | `RESPONSE_UPGRADE_REQUIRED` |  |
| `428` | `RESPONSE_PRECONDITION_REQUIRED` |  |
| `429` | `RESPONSE_TOO_MANY_REQUESTS` |  |
| `431` | `RESPONSE_REQUEST_HEADER_FIELDS_TOO_LARGE` |  |
| `451` | `RESPONSE_UNAVAILABLE_FOR_LEGAL_REASONS` |  |
| `500` | `RESPONSE_INTERNAL_SERVER_ERROR` |  |
| `501` | `RESPONSE_NOT_IMPLEMENTED` |  |
| `502` | `RESPONSE_BAD_GATEWAY` |  |
| `503` | `RESPONSE_SERVICE_UNAVAILABLE` |  |
| `504` | `RESPONSE_GATEWAY_TIMEOUT` |  |
| `505` | `RESPONSE_HTTP_VERSION_NOT_SUPPORTED` |  |
| `506` | `RESPONSE_VARIANT_ALSO_NEGOTIATES` |  |
| `507` | `RESPONSE_INSUFFICIENT_STORAGE` |  |
| `508` | `RESPONSE_LOOP_DETECTED` |  |
| `510` | `RESPONSE_NOT_EXTENDED` |  |
| `511` | `RESPONSE_NETWORK_AUTH_REQUIRED` |  |

## 教程链接

- [HTTP client class](None)
- [TLS certificates](None)

