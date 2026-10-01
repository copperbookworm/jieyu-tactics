# TLSOptions

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`TLSOptions` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/TLSOptions.md`

**摘要**：TLS configuration for clients and servers.

## 描述

TLSOptions abstracts the configuration options for the `StreamPeerTLS` and `PacketPeerDTLS` classes.
		Objects of this class cannot be instantiated directly, and one of the static methods `client`, `client_unsafe`, or `server` should be used instead.
		`codeblocks`
		`gdscript`
		# Create a TLS client configuration which uses our custom trusted CA chain.
		var client_trusted_cas = load("res://my_trusted_cas.crt")
		var client_tls_options = TLSOptions.client(client_trusted_cas)

		# Create a TLS server configuration.
		var server_certs = load("res://my_server_cas.crt")
		var server_key = load("res://my_server_key.key")
		var server_tls_options = TLSOptions.server(server_key, server_certs)

## 方法

### `client(trusted_chain: X509Certificate = null, common_name_override: String = "") -> TLSOptions`
- 限定：qualifiers=static

Creates a TLS client configuration which validates certificates and their common names (fully qualified domain names).
				You can specify a custom `trusted_chain` of certification authorities (the default CA list will be used if `null`), and optionally provide a `common_name_override` if you expect the certificate to have a common name other than the server FQDN.
				**Note:** On the Web platform, TLS verification is always enforced against the CA list of the web browser. This is considered a security feature.

### `client_unsafe(trusted_chain: X509Certificate = null) -> TLSOptions`
- 限定：qualifiers=static

Creates an **unsafe** TLS client configuration where certificate validation is optional. You can optionally provide a valid `trusted_chain`, but the common name of the certificates will never be checked. Using this configuration for purposes other than testing **is not recommended**.
				**Note:** On the Web platform, TLS verification is always enforced against the CA list of the web browser. This is considered a security feature.

### `get_common_name_override() -> String`
- 限定：qualifiers=const

Returns the common name (domain name) override specified when creating with `TLSOptions.client`.

### `get_own_certificate() -> X509Certificate`
- 限定：qualifiers=const

Returns the `X509Certificate` specified when creating with `TLSOptions.server`.

### `get_private_key() -> CryptoKey`
- 限定：qualifiers=const

Returns the `CryptoKey` specified when creating with `TLSOptions.server`.

### `get_trusted_ca_chain() -> X509Certificate`
- 限定：qualifiers=const

Returns the CA `X509Certificate` chain specified when creating with `TLSOptions.client` or `TLSOptions.client_unsafe`.

### `is_server() -> bool`
- 限定：qualifiers=const

Returns `true` if created with `TLSOptions.server`, `false` otherwise.

### `is_unsafe_client() -> bool`
- 限定：qualifiers=const

Returns `true` if created with `TLSOptions.client_unsafe`, `false` otherwise.

### `server(key: CryptoKey, certificate: X509Certificate) -> TLSOptions`
- 限定：qualifiers=static

Creates a TLS server configuration using the provided `key` and `certificate`.
				**Note:** The `certificate` should include the full certificate chain up to the signing CA (certificates file can be concatenated using a general purpose text editor).

