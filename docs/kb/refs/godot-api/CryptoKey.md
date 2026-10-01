# CryptoKey

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`CryptoKey` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/CryptoKey.md`

**摘要**：A cryptographic key (RSA or elliptic-curve).

## 描述

The CryptoKey class represents a cryptographic key. Keys can be loaded and saved like any other `Resource`.
		They can be used to generate a self-signed `X509Certificate` via `Crypto.generate_self_signed_certificate` and as private key in `StreamPeerTLS.accept_stream` along with the appropriate certificate.

## 方法

### `is_public_only() -> bool`
- 限定：qualifiers=const

Returns `true` if this CryptoKey only has the public part, and not the private one.

### `load(path: String, public_only: bool = false) -> int`

Loads a key from `path`. If `public_only` is `true`, only the public key will be loaded.
				**Note:** `path` should be a "*.pub" file if `public_only` is `true`, a "*.key" file otherwise.

### `load_from_string(string_key: String, public_only: bool = false) -> int`

Loads a key from the given `string_key`. If `public_only` is `true`, only the public key will be loaded.

### `save(path: String, public_only: bool = false) -> int`

Saves a key to the given `path`. If `public_only` is `true`, only the public key will be saved.
				**Note:** `path` should be a "*.pub" file if `public_only` is `true`, a "*.key" file otherwise.

### `save_to_string(public_only: bool = false) -> String`

Returns a string containing the key in PEM format. If `public_only` is `true`, only the public key will be included.

## 教程链接

- [SSL certificates](None)

