# HMACContext

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`HMACContext` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/HMACContext.md`

**摘要**：Used to create an HMAC for a message using a key.

## 描述

The HMACContext class is useful for advanced HMAC use cases, such as streaming the message as it supports creating the message over time rather than providing it all at once.
		`codeblocks`
		`gdscript`
		extends Node
		var ctx = HMACContext.new()

		func _ready():
			var key = "supersecret".to_utf8_buffer()
			var err = ctx.start(HashingContext.HASH_SHA256, key)
			assert(err == OK)
			var msg1 = "this is ".to_utf8_buffer()
			var msg2 = "super duper secret".to_utf8_buffer()
			err = ctx.update(msg1)
			assert(err == OK)
			err = ctx.update(msg2)
			assert(err == OK)
			var hmac = ctx.finish()
			print(hmac.hex_encode())

		
		`csharp`
		using Godot;
		using System.Diagnostics;

		public partial class MyNode : Node
		{
			private HmacContext _ctx = new HmacContext();

			public override void _Ready()
			{
				byte[] key = "supersecret".ToUtf8Buffer();
				Error err = _ctx.Start(HashingContext.HashType.Sha256, key);
				Debug.Assert(err == Error.Ok);
				byte[] msg1 = "this is ".ToUtf8Buffer();
				byte[] msg2 = "super duper secret".ToUtf8Buffer();
				err = _ctx.Update(msg1);
				Debug.Assert(err == Error.Ok);
				err = _ctx.Update(msg2);
				Debug.Assert(err == Error.Ok);
				byte[] hmac = _ctx.Finish();
				GD.Print(hmac.HexEncode());
			}
		}

## 方法

### `finish() -> PackedByteArray`

Returns the resulting HMAC. If the HMAC failed, an empty `PackedByteArray` is returned.

### `start(hash_type: int, key: PackedByteArray) -> int`

Initializes the HMACContext. This method cannot be called again on the same HMACContext until `finish` has been called.

### `update(data: PackedByteArray) -> int`

Updates the message to be HMACed. This can be called multiple times before `finish` is called to append `data` to the message, but cannot be called until `start` has been called.

