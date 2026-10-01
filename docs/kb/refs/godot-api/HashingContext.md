# HashingContext

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`HashingContext` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/HashingContext.md`

**摘要**：Provides functionality for computing cryptographic hashes chunk by chunk.

## 描述

The HashingContext class provides an interface for computing cryptographic hashes over multiple iterations. Useful for computing hashes of big files (so you don't have to load them all in memory), network streams, and data streams in general (so you don't have to hold buffers).
		The `HashType` enum shows the supported hashing algorithms.
		`codeblocks`
		`gdscript`
		const CHUNK_SIZE = 1024

		func hash_file(path):
			# Check that file exists.
			if not FileAccess.file_exists(path):
				return
			# Start an SHA-256 context.
			var ctx = HashingContext.new()
			ctx.start(HashingContext.HASH_SHA256)
			# Open the file to hash.
			var file = FileAccess.open(path, FileAccess.READ)
			# Update the context after reading each chunk.
			while file.get_position() < file.get_length():
				var remaining = file.get_length() - file.get_position()
				ctx.update(file.get_buffer(min(remaining, CHUNK_SIZE)))
			# Get the computed hash.
			var res = ctx.finish()
			# Print the result as hex string and array.
			printt(res.hex_encode(), Array(res))
		
		`csharp`
		public const int ChunkSize = 1024;

		public void HashFile(string path)
		{
			// Check that file exists.
			if (!FileAccess.FileExists(path))
			{
				return;
			}
			// Start an SHA-256 context.
			var ctx = new HashingContext();
			ctx.Start(HashingContext.HashType.Sha256);
			// Open the file to hash.
			using var file = FileAccess.Open(path, FileAccess.ModeFlags.Read);
			// Update the context after reading each chunk.
			while (file.GetPosition() < file.GetLength())
			{
				int remaining = (int)(file.GetLength() - file.GetPosition());
				ctx.Update(file.GetBuffer(Mathf.Min(remaining, ChunkSize)));
			}
			// Get the computed hash.
			byte[] res = ctx.Finish();
			// Print the result as hex string and array.
			GD.PrintT(res.HexEncode(), (Variant)res);
		}

## 方法

### `finish() -> PackedByteArray`

Closes the current context, and return the computed hash.

### `start(type: int) -> int`

Starts a new hash computation of the given `type` (e.g. `HASH_SHA256` to start computation of an SHA-256).

### `update(chunk: PackedByteArray) -> int`

Updates the computation with the given `chunk` of data.

## 枚举

### `HashType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `HASH_MD5` |  |
| `1` | `HASH_SHA1` |  |
| `2` | `HASH_SHA256` |  |

