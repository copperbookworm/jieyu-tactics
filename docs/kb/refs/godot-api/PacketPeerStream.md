# PacketPeerStream

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`PacketPeerStream` → `PacketPeer` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/PacketPeerStream.md`

**摘要**：Wrapper to use a PacketPeer over a StreamPeer.

## 描述

PacketStreamPeer provides a wrapper for working using packets over a stream. This allows for using packet based code with StreamPeers. PacketPeerStream implements a custom protocol over the StreamPeer, so the user should not read or write to the wrapped StreamPeer directly.
		**Note:** When exporting to Android, make sure to enable the `INTERNET` permission in the Android export preset before exporting the project or using one-click deploy. Otherwise, network communication of any kind will be blocked by Android.

## 属性

- **`input_buffer_max_size`** `int` = `65532`
  - 其它属性：getter=get_input_buffer_max_size · setter=set_input_buffer_max_size
- **`output_buffer_max_size`** `int` = `65532`
  - 其它属性：getter=get_output_buffer_max_size · setter=set_output_buffer_max_size
- **`stream_peer`** `StreamPeer`
  - 其它属性：getter=get_stream_peer · setter=set_stream_peer

