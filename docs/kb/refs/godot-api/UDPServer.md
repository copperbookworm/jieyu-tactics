# UDPServer

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`UDPServer` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/UDPServer.md`

**摘要**：Helper class to implement a UDP server.

## 描述

A simple server that opens a UDP socket and returns connected `PacketPeerUDP` upon receiving new packets. See also `PacketPeerUDP.connect_to_host`.
		After starting the server (`listen`), you will need to `poll` it at regular intervals (e.g. inside `Node._process`) for it to process new packets, delivering them to the appropriate `PacketPeerUDP`, and taking new connections.
		Below a small example of how it can be used:
		`codeblocks`
		`gdscript`
		# server_node.gd
		class_name ServerNode
		extends Node

		var server = UDPServer.new()
		var peers = []

		func _ready():
			server.listen(4242)

		func _process(delta):
			server.poll() # Important!
			if server.is_connection_available():
				var peer = server.take_connection()
				var packet = peer.get_packet()
				print("Accepted peer: %s:%s" % [peer.get_packet_ip(), peer.get_packet_port()])
				print("Received data: %s" % [packet.get_string_from_utf8()])
				# Reply so it knows we received the message.
				peer.put_packet(packet)
				# Keep a reference so we can keep contacting the remote peer.
				peers.append(peer)

			for i in range(0, peers.size()):
				pass # Do something with the connected peers.
		
		`csharp`
		// ServerNode.cs
		using Godot;
		using System.Collections.Generic;

		public partial class ServerNode : Node
		{
			private UdpServer _server = new UdpServer();
			private List<PacketPeerUdp> _peers  = new List<PacketPeerUdp>();

			public override void _Ready()
			{
				_server.Listen(4242);
			}

			public override void _Process(double delta)
			{
				_server.Poll(); // Important!
				if (_server.IsConnectionAvailable())
				{
					PacketPeerUdp peer = _server.TakeConnection();
					byte[] packet = peer.GetPacket();
					GD.Print($"Accepted Peer: {peer.GetPacketIP()}:{peer.GetPacketPort()}");
					GD.Print($"Received Data: {packet.GetStringFromUtf8()}");
					// Reply so it knows we received the message.
					peer.PutPacket(packet);
					// Keep a reference so we can keep contacting the remote peer.
					_peers.Add(peer);
				}
				foreach (var peer in _peers)
				{
					// Do something with the peers.
				}
			}
		}
		
		
		`codeblocks`
		`gdscript`
		# client_node.gd
		class_name ClientNode
		extends Node

		var udp = PacketPeerUDP.new()
		var connected = false

		func _ready():
			udp.connect_to_host("127.0.0.1", 4242)

		func _process(delta):
			if !connected:
				# Try to contact server
				udp.put_packet("The answer is... 42!".to_utf8_buffer())
			if udp.get_available_packet_count() > 0:
				print("Connected: %s" % udp.get_packet().get_string_from_utf8())
				connected = true
		
		`csharp`
		// ClientNode.cs
		using Godot;

		public partial class ClientNode : Node
		{
			private PacketPeerUdp _udp = new PacketPeerUdp();
			private bool _connected = false;

			public override void _Ready()
			{
				_udp.ConnectToHost("127.0.0.1", 4242);
			}

			public override void _Process(double delta)
			{
				if (!_connected)
				{
					// Try to contact server
					_udp.PutPacket("The Answer Is..42!".ToUtf8Buffer());
				}
				if (_udp.GetAvailablePacketCount() > 0)
				{
					GD.Print($"Connected: {_udp.GetPacket().GetStringFromUtf8()}");
					_connected = true;
				}
			}
		}

## 属性

- **`max_pending_connections`** `int` = `16`
  - 其它属性：getter=get_max_pending_connections · setter=set_max_pending_connections

## 方法

### `get_local_port() -> int`
- 限定：qualifiers=const

Returns the local port this server is listening to.

### `is_connection_available() -> bool`
- 限定：qualifiers=const

Returns `true` if a packet with a new address/port combination was received on the socket.

### `is_listening() -> bool`
- 限定：qualifiers=const

Returns `true` if the socket is open and listening on a port.

### `listen(port: int, bind_address: String = "*") -> int`

Starts the server by opening a UDP socket listening on the given `port`. You can optionally specify a `bind_address` to only listen for packets sent to that address. See also `PacketPeerUDP.bind`.

### `poll() -> int`

Call this method at regular intervals (e.g. inside `Node._process`) to process new packets. Any packet from a known address/port pair will be delivered to the appropriate `PacketPeerUDP`, while any packet received from an unknown address/port pair will be added as a pending connection (see `is_connection_available` and `take_connection`). The maximum number of pending connections is defined via `max_pending_connections`.

### `stop() -> void`

Stops the server, closing the UDP socket if open. Will close all connected `PacketPeerUDP` accepted via `take_connection` (remote peers will not be notified).

### `take_connection() -> PacketPeerUDP`

Returns the first pending connection (connected to the appropriate address/port). Will return `null` if no new connection is available. See also `is_connection_available`, `PacketPeerUDP.connect_to_host`.

