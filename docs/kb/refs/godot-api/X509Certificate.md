# X509Certificate

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`X509Certificate` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/X509Certificate.md`

**摘要**：An X509 certificate (e.g. for TLS).

## 描述

The X509Certificate class represents an X509 certificate. Certificates can be loaded and saved like any other `Resource`.
		They can be used as the server certificate in `StreamPeerTLS.accept_stream` (along with the proper `CryptoKey`), and to specify the only certificate that should be accepted when connecting to a TLS server via `StreamPeerTLS.connect_to_stream`.

## 方法

### `load(path: String) -> int`

Loads a certificate from `path` ("*.crt" file).

### `load_from_string(string: String) -> int`

Loads a certificate from the given `string`.

### `save(path: String) -> int`

Saves a certificate to the given `path` (should be a "*.crt" file).

### `save_to_string() -> String`

Returns a string representation of the certificate, or an empty string if the certificate is invalid.

## 教程链接

- [SSL certificates](None)

