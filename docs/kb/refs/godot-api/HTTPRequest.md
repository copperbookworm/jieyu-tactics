# HTTPRequest

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`HTTPRequest` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/HTTPRequest.md`

**摘要**：A node with the ability to send HTTP(S) requests.

## 描述

A node with the ability to send HTTP requests. Uses `HTTPClient` internally.
		Can be used to make HTTP requests, i.e. download or upload files or web content via HTTP.
		**Warning:** See the notes and warnings on `HTTPClient` for limitations, especially regarding TLS security.
		**Note:** When exporting to Android, make sure to enable the `INTERNET` permission in the Android export preset before exporting the project or using one-click deploy. Otherwise, network communication of any kind will be blocked by Android.
		**Example:** Contact a REST API and print one of its returned fields:
		`codeblocks`
		`gdscript`
		func _ready():
			# Create an HTTP request node and connect its completion signal.
			var http_request = HTTPRequest.new()
			add_child(http_request)
			http_request.request_completed.connect(self._http_request_completed)

			# Perform a GET request. The URL below returns JSON as of writing.
			var error = http_request.request("https://httpbin.org/get")
			if error != OK:
				push_error("An error occurred in the HTTP request.")

			# Perform a POST request. The URL below returns JSON as of writing.
			# Note: Don't make simultaneous requests using a single HTTPRequest node.
			# The snippet below is provided for reference only.
			var body = JSON.stringify({"name": "Godette"})
			error = http_request.request("https://httpbin.org/post", [], HTTPClient.METHOD_POST, body)
			if error != OK:
				push_error("An error occurred in the HTTP request.")

		# Called when the HTTP request is completed.
		func _http_request_completed(result, response_code, headers, body):
			var json = JSON.new()
			json.parse(body.get_string_from_utf8())
			var response = json.get_data()

			# Will print the user agent string used by the HTTPRequest node (as recognized by httpbin.org).
			print(response.headers["User-Agent"])
		
		`csharp`
		public override void _Ready()
		{
			// Create an HTTP request node and connect its completion signal.
			var httpRequest = new HttpRequest();
			AddChild(httpRequest);
			httpRequest.RequestCompleted += HttpRequestCompleted;

			// Perform a GET request. The URL below returns JSON as of writing.
			Error error = httpRequest.Request("https://httpbin.org/get");
			if (error != Error.Ok)
			{
				GD.PushError("An error occurred in the HTTP request.");
			}

			// Perform a POST request. The URL below returns JSON as of writing.
			// Note: Don't make simultaneous requests using a single HTTPRequest node.
			// The snippet below is provided for reference only.
			string body = Json.Stringify(new Godot.Collections.Dictionary
			{
				{ "name", "Godette" }
			});
			error = httpRequest.Request("https://httpbin.org/post", null, HttpClient.Method.Post, body);
			if (error != Error.Ok)
			{
				GD.PushError("An error occurred in the HTTP request.");
			}
		}

		// Called when the HTTP request is completed.
		private void HttpRequestCompleted(long result, long responseCode, string[] headers, byte[] body)
		{
			var json = new Json();
			json.Parse(body.GetStringFromUtf8());
			var response = json.GetData().AsGodotDictionary();

			// Will print the user agent string used by the HTTPRequest node (as recognized by httpbin.org).
			GD.Print((response["headers"].AsGodotDictionary())["User-Agent"]);
		}
		
		
		**Example:** Load an image using `HTTPRequest` and display it:
		`codeblocks`
		`gdscript`
		func _ready():
			# Create an HTTP request node and connect its completion signal.
			var http_request = HTTPRequest.new()
			add_child(http_request)
			http_request.request_completed.connect(self._http_request_completed)

			# Perform the HTTP request. The URL below returns a PNG image as of writing.
			var error = http_request.request("https://placehold.co/512.png")
			if error != OK:
				push_error("An error occurred in the HTTP request.")

		# Called when the HTTP request is completed.
		func _http_request_completed(result, response_code, headers, body):
			if result != HTTPRequest.RESULT_SUCCESS:
				push_error("Image couldn't be downloaded. Try a different image.")

			var image = Image.new()
			var error = image.load_png_from_buffer(body)
			if error != OK:
				push_error("Couldn't load the image.")

			var texture = ImageTexture.create_from_image(image)

			# Display the image in a TextureRect node.
			var texture_rect = TextureRect.new()
			add_child(texture_rect)
			texture_rect.texture = texture
		
		`csharp`
		public override void _Ready()
		{
			// Create an HTTP request node and connect its completion signal.
			var httpRequest = new HttpRequest();
			AddChild(httpRequest);
			httpRequest.RequestCompleted += HttpRequestCompleted;

			// Perform the HTTP request. The URL below returns a PNG image as of writing.
			Error error = httpRequest.Request("https://placehold.co/512.png");
			if (error != Error.Ok)
			{
				GD.PushError("An error occurred in the HTTP request.");
			}
		}

		// Called when the HTTP request is completed.
		private void HttpRequestCompleted(long result, long responseCode, string[] headers, byte[] body)
		{
			if (result != (long)HttpRequest.Result.Success)
			{
				GD.PushError("Image couldn't be downloaded. Try a different image.");
			}
			var image = new Image();
			Error error = image.LoadPngFromBuffer(body);
			if (error != Error.Ok)
			{
				GD.PushError("Couldn't load the image.");
			}

			var texture = ImageTexture.CreateFromImage(image);

			// Display the image in a TextureRect node.
			var textureRect = new TextureRect();
			AddChild(textureRect);
			textureRect.Texture = texture;
		}
		
		
		**Note:** `HTTPRequest` nodes will automatically handle decompression of response bodies. An `Accept-Encoding` header will be automatically added to each of your requests, unless one is already specified. Any response with a `Content-Encoding: gzip` header will automatically be decompressed and delivered to you as uncompressed bytes.

## 属性

- **`accept_gzip`** `bool` = `true`
  - 其它属性：getter=is_accepting_gzip · setter=set_accept_gzip
- **`body_size_limit`** `int` = `-1`
  - 其它属性：getter=get_body_size_limit · setter=set_body_size_limit
- **`download_chunk_size`** `int` = `65536`
  - 其它属性：getter=get_download_chunk_size · setter=set_download_chunk_size
- **`download_file`** `String` = `""`
  - 其它属性：getter=get_download_file · setter=set_download_file
- **`max_redirects`** `int` = `8`
  - 其它属性：getter=get_max_redirects · setter=set_max_redirects
- **`timeout`** `float` = `0.0`
  - 其它属性：getter=get_timeout · setter=set_timeout
- **`use_threads`** `bool` = `false`
  - 其它属性：getter=is_using_threads · setter=set_use_threads

## 方法

### `cancel_request() -> void`

Cancels the current request.

### `get_body_size() -> int`
- 限定：qualifiers=const

Returns the response body length.
				**Note:** Some Web servers may not send a body length. In this case, the value returned will be `-1`. If using chunked transfer encoding, the body length will also be `-1`.

### `get_downloaded_bytes() -> int`
- 限定：qualifiers=const

Returns the number of bytes this HTTPRequest downloaded.

### `get_http_client_status() -> int`
- 限定：qualifiers=const

Returns the current status of the underlying `HTTPClient`.

### `request(url: String, custom_headers: PackedStringArray = PackedStringArray(), method: int = 0, request_data: String = "") -> int`

Creates request on the underlying `HTTPClient`. If there is no configuration errors, it tries to connect using `HTTPClient.connect_to_host` and passes parameters onto `HTTPClient.request`.
				Returns `OK` if request is successfully created. (Does not imply that the server has responded), `ERR_UNCONFIGURED` if not in the tree, `ERR_BUSY` if still processing previous request, `ERR_INVALID_PARAMETER` if given string is not a valid URL format, or `ERR_CANT_CONNECT` if not using thread and the `HTTPClient` cannot connect to host.
				**Note:** When `method` is `HTTPClient.METHOD_GET`, the payload sent via `request_data` might be ignored by the server or even cause the server to reject the request (check RFC 7231 section 4.3.1 (https://datatracker.ietf.org/doc/html/rfc7231#section-4.3.1) for more details). As a workaround, you can send data as a query string in the URL (see `String.uri_encode` for an example).
				**Note:** It's recommended to use transport encryption (TLS) and to avoid sending sensitive information (such as login credentials) in HTTP GET URL parameters. Consider using HTTP POST requests or HTTP headers for such information instead.

### `request_raw(url: String, custom_headers: PackedStringArray = PackedStringArray(), method: int = 0, request_data_raw: PackedByteArray = PackedByteArray()) -> int`

Creates request on the underlying `HTTPClient` using a raw array of bytes for the request body. If there is no configuration errors, it tries to connect using `HTTPClient.connect_to_host` and passes parameters onto `HTTPClient.request`.
				Returns `OK` if request is successfully created. (Does not imply that the server has responded), `ERR_UNCONFIGURED` if not in the tree, `ERR_BUSY` if still processing previous request, `ERR_INVALID_PARAMETER` if given string is not a valid URL format, or `ERR_CANT_CONNECT` if not using thread and the `HTTPClient` cannot connect to host.

### `set_http_proxy(host: String, port: int) -> void`

Sets the proxy server for HTTP requests.
				The proxy server is unset if `host` is empty or `port` is -1.

### `set_https_proxy(host: String, port: int) -> void`

Sets the proxy server for HTTPS requests.
				The proxy server is unset if `host` is empty or `port` is -1.

### `set_tls_options(client_options: TLSOptions) -> void`

Sets the `TLSOptions` to be used when connecting to an HTTPS server. See `TLSOptions.client`.

## 信号

### `request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray)`

Emitted when a request is completed.

## 枚举

### `Result`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `RESULT_SUCCESS` |  |
| `1` | `RESULT_CHUNKED_BODY_SIZE_MISMATCH` |  |
| `2` | `RESULT_CANT_CONNECT` |  |
| `3` | `RESULT_CANT_RESOLVE` |  |
| `4` | `RESULT_CONNECTION_ERROR` |  |
| `5` | `RESULT_TLS_HANDSHAKE_ERROR` |  |
| `6` | `RESULT_NO_RESPONSE` |  |
| `7` | `RESULT_BODY_SIZE_LIMIT_EXCEEDED` |  |
| `8` | `RESULT_BODY_DECOMPRESS_FAILED` |  |
| `9` | `RESULT_REQUEST_FAILED` |  |
| `10` | `RESULT_DOWNLOAD_FILE_CANT_OPEN` |  |
| `11` | `RESULT_DOWNLOAD_FILE_WRITE_ERROR` |  |
| `12` | `RESULT_REDIRECT_LIMIT_REACHED` |  |
| `13` | `RESULT_TIMEOUT` |  |

## 教程链接

- [Making HTTP requests](None)
- [TLS certificates](None)

