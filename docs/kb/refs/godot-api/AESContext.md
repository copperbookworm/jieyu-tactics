# AESContext

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AESContext` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AESContext.md`

**摘要**：Provides access to AES encryption/decryption of raw data.

## 描述

This class holds the context information required for encryption and decryption operations with AES (Advanced Encryption Standard). Both AES-ECB and AES-CBC modes are supported.
		`codeblocks`
		`gdscript`
		extends Node

		var aes = AESContext.new()

		func _ready():
			var key = "My secret key!!!" # Key must be either 16 or 32 bytes.
			var data = "My secret text!!" # Data size must be multiple of 16 bytes, apply padding if needed.
			# Encrypt ECB
			aes.start(AESContext.MODE_ECB_ENCRYPT, key.to_utf8_buffer())
			var encrypted = aes.update(data.to_utf8_buffer())
			aes.finish()
			# Decrypt ECB
			aes.start(AESContext.MODE_ECB_DECRYPT, key.to_utf8_buffer())
			var decrypted = aes.update(encrypted)
			aes.finish()
			# Check ECB
			assert(decrypted == data.to_utf8_buffer())

			var iv = "My secret iv!!!!" # IV must be of exactly 16 bytes.
			# Encrypt CBC
			aes.start(AESContext.MODE_CBC_ENCRYPT, key.to_utf8_buffer(), iv.to_utf8_buffer())
			encrypted = aes.update(data.to_utf8_buffer())
			aes.finish()
			# Decrypt CBC
			aes.start(AESContext.MODE_CBC_DECRYPT, key.to_utf8_buffer(), iv.to_utf8_buffer())
			decrypted = aes.update(encrypted)
			aes.finish()
			# Check CBC
			assert(decrypted == data.to_utf8_buffer())
		
		`csharp`
		using Godot;
		using System.Diagnostics;

		public partial class MyNode : Node
		{
			private AesContext _aes = new AesContext();

			public override void _Ready()
			{
				string key = "My secret key!!!"; // Key must be either 16 or 32 bytes.
				string data = "My secret text!!"; // Data size must be multiple of 16 bytes, apply padding if needed.
				// Encrypt ECB
				_aes.Start(AesContext.Mode.EcbEncrypt, key.ToUtf8Buffer());
				byte[] encrypted = _aes.Update(data.ToUtf8Buffer());
				_aes.Finish();
				// Decrypt ECB
				_aes.Start(AesContext.Mode.EcbDecrypt, key.ToUtf8Buffer());
				byte[] decrypted = _aes.Update(encrypted);
				_aes.Finish();
				// Check ECB
				Debug.Assert(decrypted == data.ToUtf8Buffer());

				string iv = "My secret iv!!!!"; // IV must be of exactly 16 bytes.
				// Encrypt CBC
				_aes.Start(AesContext.Mode.EcbEncrypt, key.ToUtf8Buffer(), iv.ToUtf8Buffer());
				encrypted = _aes.Update(data.ToUtf8Buffer());
				_aes.Finish();
				// Decrypt CBC
				_aes.Start(AesContext.Mode.EcbDecrypt, key.ToUtf8Buffer(), iv.ToUtf8Buffer());
				decrypted = _aes.Update(encrypted);
				_aes.Finish();
				// Check CBC
				Debug.Assert(decrypted == data.ToUtf8Buffer());
			}
		}

## 方法

### `finish() -> void`

Close this AES context so it can be started again. See `start`.

### `get_iv_state() -> PackedByteArray`

Get the current IV state for this context (IV gets updated when calling `update`). You normally don't need this function.
				**Note:** This function only makes sense when the context is started with `MODE_CBC_ENCRYPT` or `MODE_CBC_DECRYPT`.

### `start(mode: int, key: PackedByteArray, iv: PackedByteArray = PackedByteArray()) -> int`

Start the AES context in the given `mode`. A `key` of either 16 or 32 bytes must always be provided, while an `iv` (initialization vector) of exactly 16 bytes, is only needed when `mode` is either `MODE_CBC_ENCRYPT` or `MODE_CBC_DECRYPT`.

### `update(src: PackedByteArray) -> PackedByteArray`

Run the desired operation for this AES context. Will return a `PackedByteArray` containing the result of encrypting (or decrypting) the given `src`. See `start` for mode of operation.
				**Note:** The size of `src` must be a multiple of 16. Apply some padding if needed.

## 枚举

### `Mode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `MODE_ECB_ENCRYPT` |  |
| `1` | `MODE_ECB_DECRYPT` |  |
| `2` | `MODE_CBC_ENCRYPT` |  |
| `3` | `MODE_CBC_DECRYPT` |  |
| `4` | `MODE_MAX` |  |

