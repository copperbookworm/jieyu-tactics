# PackedScene

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`PackedScene` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/PackedScene.md`

**摘要**：An abstraction of a serialized scene.

## 描述

A simplified interface to a scene file. Provides access to operations and checks that can be performed on the scene resource itself.
		Can be used to save a node to a file. When saving, the node as well as all the nodes it owns get saved (see `Node.owner` property).
		**Note:** The node doesn't need to own itself.
		**Example:** Load a saved scene:
		`codeblocks`
		`gdscript`
		# Use load() instead of preload() if the path isn't known at compile-time.
		var scene = preload("res://scene.tscn").instantiate()
		# Add the node as a child of the node the script is attached to.
		add_child(scene)
		
		`csharp`
		// C# has no preload, so you have to always use ResourceLoader.Load<PackedScene>().
		var scene = ResourceLoader.Load<PackedScene>("res://scene.tscn").Instantiate();
		// Add the node as a child of the node the script is attached to.
		AddChild(scene);
		
		
		**Example:** Save a node with different owners. The following example creates 3 objects: `Node2D` (`node`), `RigidBody2D` (`body`) and `CollisionObject2D` (`collision`). `collision` is a child of `body` which is a child of `node`. Only `body` is owned by `node` and `pack` will therefore only save those two nodes, but not `collision`.
		`codeblocks`
		`gdscript`
		# Create the objects.
		var node = Node2D.new()
		var body = RigidBody2D.new()
		var collision = CollisionShape2D.new()

		# Create the object hierarchy.
		body.add_child(collision)
		node.add_child(body)

		# Change owner of `body`, but not of `collision`.
		body.owner = node
		var scene = PackedScene.new()

		# Only `node` and `body` are now packed.
		var result = scene.pack(node)
		if result == OK:
			var error = ResourceSaver.save(scene, "res://path/name.tscn")  # Or "user://..."
			if error != OK:
				push_error("An error occurred while saving the scene to disk.")
		
		`csharp`
		// Create the objects.
		var node = new Node2D();
		var body = new RigidBody2D();
		var collision = new CollisionShape2D();

		// Create the object hierarchy.
		body.AddChild(collision);
		node.AddChild(body);

		// Change owner of `body`, but not of `collision`.
		body.Owner = node;
		var scene = new PackedScene();

		// Only `node` and `body` are now packed.
		Error result = scene.Pack(node);
		if (result == Error.Ok)
		{
			Error error = ResourceSaver.Save(scene, "res://path/name.tscn"); // Or "user://..."
			if (error != Error.Ok)
			{
				GD.PushError("An error occurred while saving the scene to disk.");
			}
		}

## 方法

### `can_instantiate() -> bool`
- 限定：qualifiers=const

Returns `true` if the scene file has nodes.

### `get_state() -> SceneState`
- 限定：qualifiers=const

Returns the `SceneState` representing the scene file contents.

### `instantiate(edit_state: int = 0) -> Node`
- 限定：keywords=create, make, spawn, new · qualifiers=const

Instantiates the scene's node hierarchy. Triggers child scene instantiation(s). Triggers a `Node.NOTIFICATION_SCENE_INSTANTIATED` notification on the root node.

### `pack(path: Node) -> int`

Packs the `path` node, and all owned sub-nodes, into this `PackedScene`. Any existing data will be cleared. See `Node.owner`.

## 枚举

### `GenEditState`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `GEN_EDIT_STATE_DISABLED` |  |
| `1` | `GEN_EDIT_STATE_INSTANCE` |  |
| `2` | `GEN_EDIT_STATE_MAIN` |  |
| `3` | `GEN_EDIT_STATE_MAIN_INHERITED` |  |

## 教程链接

- [2D Role Playing Game (RPG) Demo](None)

