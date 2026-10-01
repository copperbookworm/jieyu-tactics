# Node

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Node.md`

**摘要**：Base class for all scene objects.

## 描述

Nodes are Godot's building blocks. They can be assigned as the child of another node, resulting in a tree arrangement. A given node can contain any number of nodes as children with the requirement that all siblings (direct children of a node) should have unique names.
		A tree of nodes is called a *scene*. Scenes can be saved to the disk and then instantiated into other scenes. This allows for very high flexibility in the architecture and data model of Godot projects.
		**Scene tree:** The `SceneTree` contains the active tree of nodes. When a node is added to the scene tree, it receives the `NOTIFICATION_ENTER_TREE` notification and its `_enter_tree` callback is triggered. Child nodes are always added *after* their parent node, i.e. the `_enter_tree` callback of a parent node will be triggered before its child's.
		Once all nodes have been added in the scene tree, they receive the `NOTIFICATION_READY` notification and their respective `_ready` callbacks are triggered. For groups of nodes, the `_ready` callback is called in reverse order, starting with the children and moving up to the parent nodes.
		This means that when adding a node to the scene tree, the following order will be used for the callbacks: `_enter_tree` of the parent, `_enter_tree` of the children, `_ready` of the children and finally `_ready` of the parent (recursively for the entire scene tree).
		**Processing:** Nodes can override the "process" state, so that they receive a callback on each frame requesting them to process (do something). Normal processing (callback `_process`, toggled with `set_process`) happens as fast as possible and is dependent on the frame rate, so the processing time *delta* (in seconds) is passed as an argument. Physics processing (callback `_physics_process`, toggled with `set_physics_process`) happens a fixed number of times per second (60 by default) and is useful for code related to the physics engine.
		Nodes can also process input events. When present, the `_input` function will be called for each input that the program receives. In many cases, this can be overkill (unless used for simple projects), and the `_unhandled_input` function might be preferred; it is called when the input event was not handled by anyone else (typically, GUI `Control` nodes), ensuring that the node only receives the events that were meant for it.
		To keep track of the scene hierarchy (especially when instantiating scenes into other scenes), an "owner" can be set for the node with the `owner` property. This keeps track of who instantiated what. This is mostly useful when writing editors and tools, though.
		Finally, when a node is freed with `Object.free` or `queue_free`, it will also free all its children.
		**Groups:** Nodes can be added to as many groups as you want to be easy to manage, you could create groups like "enemies" or "collectables" for example, depending on your game. See `add_to_group`, `is_in_group` and `remove_from_group`. You can then retrieve all nodes in these groups, iterate them and even call methods on groups via the methods on `SceneTree`.
		**Networking with nodes:** After connecting to a server (or making one, see `ENetMultiplayerPeer`), it is possible to use the built-in RPC (remote procedure call) system to communicate over the network. By calling `rpc` with a method name, it will be called locally and in all connected peers (peers = clients and the server that accepts connections). To identify which node receives the RPC call, Godot will use its `NodePath` (make sure node names are the same on all peers). Also, take a look at the high-level networking tutorial and corresponding demos.
		**Note:** The `script` property is part of the `Object` class, not `Node`. It isn't exposed like most properties but does have a setter and getter (see `Object.set_script` and `Object.get_script`).

## 属性

- **`auto_translate_mode`** `int` = `0` · 枚举 `Node.AutoTranslateMode`
  - 其它属性：getter=get_auto_translate_mode · setter=set_auto_translate_mode
- **`editor_description`** `String` = `""`
  - 其它属性：getter=get_editor_description · setter=set_editor_description
- **`multiplayer`** `MultiplayerAPI`
  - 其它属性：getter=get_multiplayer · setter=
- **`name`** `StringName`
  - 其它属性：getter=get_name · setter=set_name
- **`owner`** `Node`
  - 其它属性：getter=get_owner · setter=set_owner
- **`physics_interpolation_mode`** `int` = `0` · 枚举 `Node.PhysicsInterpolationMode`
  - 其它属性：getter=get_physics_interpolation_mode · setter=set_physics_interpolation_mode
- **`process_mode`** `int` = `0` · 枚举 `Node.ProcessMode`
  - 其它属性：getter=get_process_mode · setter=set_process_mode
- **`process_physics_priority`** `int` = `0`
  - 其它属性：getter=get_physics_process_priority · setter=set_physics_process_priority
- **`process_priority`** `int` = `0`
  - 其它属性：getter=get_process_priority · setter=set_process_priority
- **`process_thread_group`** `int` = `0` · 枚举 `Node.ProcessThreadGroup`
  - 其它属性：getter=get_process_thread_group · setter=set_process_thread_group
- **`process_thread_group_order`** `int`
  - 其它属性：getter=get_process_thread_group_order · setter=set_process_thread_group_order
- **`process_thread_messages`** `int` · 枚举 `Node.ProcessThreadMessages` · 位标志
  - 其它属性：getter=get_process_thread_messages · is_bitfield=true · setter=set_process_thread_messages
- **`scene_file_path`** `String`
  - 其它属性：getter=get_scene_file_path · setter=set_scene_file_path
- **`unique_name_in_owner`** `bool` = `false`
  - 其它属性：getter=is_unique_name_in_owner · setter=set_unique_name_in_owner

## 方法

### `_enter_tree() -> void`
- 限定：qualifiers=virtual

Called when the node enters the `SceneTree` (e.g. upon instantiating, scene changing, or after calling `add_child` in a script). If the node has children, its `_enter_tree` callback will be called first, and then that of the children.
				Corresponds to the `NOTIFICATION_ENTER_TREE` notification in `Object._notification`.

### `_exit_tree() -> void`
- 限定：qualifiers=virtual

Called when the node is about to leave the `SceneTree` (e.g. upon freeing, scene changing, or after calling `remove_child` in a script). If the node has children, its `_exit_tree` callback will be called last, after all its children have left the tree.
				Corresponds to the `NOTIFICATION_EXIT_TREE` notification in `Object._notification` and signal `tree_exiting`. To get notified when the node has already left the active tree, connect to the `tree_exited`.

### `_get_accessibility_configuration_warnings() -> PackedStringArray`
- 限定：qualifiers=virtual const

The elements in the array returned from this method are displayed as warnings in the Scene dock if the script that overrides it is a `tool` script, and accessibility warnings are enabled in the editor settings.
				Returning an empty array produces no warnings.

### `_get_configuration_warnings() -> PackedStringArray`
- 限定：qualifiers=virtual const

The elements in the array returned from this method are displayed as warnings in the Scene dock if the script that overrides it is a `tool` script.
				Returning an empty array produces no warnings.
				Call `update_configuration_warnings` when the warnings need to be updated for this node.
				
```gdscript
				@export var energy = 0:
					set(value):
						energy = value
						update_configuration_warnings()

				func _get_configuration_warnings():
					if energy < 0:
						return ["Energy must be 0 or greater."]
					else:
						return []
				
```

### `_get_focused_accessibility_element() -> RID`
- 限定：qualifiers=virtual const

Called during accessibility information updates to determine the currently focused sub-element, should return a sub-element RID or the value returned by `get_accessibility_element`.

### `_input(event: InputEvent) -> void`
- 限定：qualifiers=virtual

Called when there is an input event. The input event propagates up through the node tree until a node consumes it.
				It is only called if input processing is enabled, which is done automatically if this method is overridden, and can be toggled with `set_process_input`.
				To consume the input event and stop it propagating further to other nodes, `Viewport.set_input_as_handled` can be called.
				For gameplay input, `_unhandled_input` and `_unhandled_key_input` are usually a better fit as they allow the GUI to intercept the events first.
				**Note:** This method is only called if the node is present in the scene tree (i.e. if it's not an orphan).

### `_physics_process(delta: float) -> void`
- 限定：qualifiers=virtual

Called once on each physics tick, and allows Nodes to synchronize their logic with physics ticks. `delta` is the logical time between physics ticks in seconds and is equal to `Engine.time_scale` / `Engine.physics_ticks_per_second`.
				It is only called if physics processing is enabled for this Node, which is done automatically if this method is overridden, and can be toggled with `set_physics_process`.
				Processing happens in order of `process_physics_priority`, lower priority values are called first. Nodes with the same priority are processed in tree order, or top to bottom as seen in the editor (also known as pre-order traversal).
				Corresponds to the `NOTIFICATION_PHYSICS_PROCESS` notification in `Object._notification`.
				**Note:** This method is only called if the node is present in the scene tree (i.e. if it's not an orphan).
				**Note:** Accumulated `delta` may diverge from real world seconds.

### `_process(delta: float) -> void`
- 限定：qualifiers=virtual

Called on each idle frame, prior to rendering, and after physics ticks have been processed. `delta` is the time between frames in seconds.
				It is only called if processing is enabled for this Node, which is done automatically if this method is overridden, and can be toggled with `set_process`.
				Processing happens in order of `process_priority`, lower priority values are called first. Nodes with the same priority are processed in tree order, or top to bottom as seen in the editor (also known as pre-order traversal).
				Corresponds to the `NOTIFICATION_PROCESS` notification in `Object._notification`.
				**Note:** This method is only called if the node is present in the scene tree (i.e. if it's not an orphan).
				**Note:** When the engine is struggling and the frame rate is lowered, `delta` will increase. When `delta` is increased, it's capped at a maximum of `Engine.time_scale` * `Engine.max_physics_steps_per_frame` / `Engine.physics_ticks_per_second`. As a result, accumulated `delta` may not represent real world time.
				**Note:** When `--fixed-fps` is enabled or the engine is running in Movie Maker mode (see `MovieWriter`), process `delta` will always be the same for every frame, regardless of how much time the frame took to render.
				**Note:** Frame delta may be post-processed by `OS.delta_smoothing` if this is enabled for the project.

### `_ready() -> void`
- 限定：qualifiers=virtual

Called when the node is "ready", i.e. when both the node and its children have entered the scene tree. If the node has children, their `_ready` callbacks get triggered first, and the parent node will receive the ready notification afterwards.
				Corresponds to the `NOTIFICATION_READY` notification in `Object._notification`. See also the `@onready` annotation for variables.
				Usually used for initialization. For even earlier initialization, `Object._init` may be used. See also `_enter_tree`.
				**Note:** This method may be called only once for each node. After removing a node from the scene tree and adding it again, `_ready` will **not** be called a second time. This can be bypassed by requesting another call with `request_ready`, which may be called anywhere before adding the node again.

### `_shortcut_input(event: InputEvent) -> void`
- 限定：qualifiers=virtual

Called when an `InputEventKey`, `InputEventShortcut`, or `InputEventJoypadButton` hasn't been consumed by `_input` or any GUI `Control` item. It is called before `_unhandled_key_input` and `_unhandled_input`. The input event propagates up through the node tree until a node consumes it.
				It is only called if shortcut processing is enabled, which is done automatically if this method is overridden, and can be toggled with `set_process_shortcut_input`.
				To consume the input event and stop it propagating further to other nodes, `Viewport.set_input_as_handled` can be called.
				This method can be used to handle shortcuts. For generic GUI events, use `_input` instead. Gameplay events should usually be handled with either `_unhandled_input` or `_unhandled_key_input`.
				**Note:** This method is only called if the node is present in the scene tree (i.e. if it's not orphan).

### `_unhandled_input(event: InputEvent) -> void`
- 限定：qualifiers=virtual

Called when an `InputEvent` hasn't been consumed by `_input` or any GUI `Control` item. It is called after `_shortcut_input` and after `_unhandled_key_input`. The input event propagates up through the node tree until a node consumes it.
				It is only called if unhandled input processing is enabled, which is done automatically if this method is overridden, and can be toggled with `set_process_unhandled_input`.
				To consume the input event and stop it propagating further to other nodes, `Viewport.set_input_as_handled` can be called.
				For gameplay input, this method is usually a better fit than `_input`, as GUI events need a higher priority. For keyboard shortcuts, consider using `_shortcut_input` instead, as it is called before this method. Finally, to handle keyboard events, consider using `_unhandled_key_input` for performance reasons.
				**Note:** This method is only called if the node is present in the scene tree (i.e. if it's not an orphan).

### `_unhandled_key_input(event: InputEvent) -> void`
- 限定：qualifiers=virtual

Called when an `InputEventKey` hasn't been consumed by `_input` or any GUI `Control` item. It is called after `_shortcut_input` but before `_unhandled_input`. The input event propagates up through the node tree until a node consumes it.
				It is only called if unhandled key input processing is enabled, which is done automatically if this method is overridden, and can be toggled with `set_process_unhandled_key_input`.
				To consume the input event and stop it propagating further to other nodes, `Viewport.set_input_as_handled` can be called.
				This method can be used to handle Unicode character input with Alt, Alt + Ctrl, and Alt + Shift modifiers, after shortcuts were handled.
				For gameplay input, this and `_unhandled_input` are usually a better fit than `_input`, as GUI events should be handled first. This method also performs better than `_unhandled_input`, since unrelated events such as `InputEventMouseMotion` are automatically filtered. For shortcuts, consider using `_shortcut_input` instead.
				**Note:** This method is only called if the node is present in the scene tree (i.e. if it's not an orphan).

### `add_child(node: Node, force_readable_name: bool = false, internal: int = 0) -> void`

Adds a child `node`. Nodes can have any number of children, but every child must have a unique name. Child nodes are automatically deleted when the parent node is deleted, so an entire scene can be removed by deleting its topmost node.
				If `force_readable_name` is `true`, improves the readability of the added `node`. If not named, the `node` is renamed to its type, and if it shares `name` with a sibling, a number is suffixed more appropriately. This operation is very slow. As such, it is recommended leaving this to `false`, which assigns a dummy name featuring `@` in both situations.
				If `internal` is different than `INTERNAL_MODE_DISABLED`, the child will be added as internal node. These nodes are ignored by methods like `get_children`, unless their parameter `include_internal` is `true`. It also prevents these nodes being duplicated with their parent. The intended usage is to hide the internal nodes from the user, so the user won't accidentally delete or modify them. Used by some GUI nodes, e.g. `ColorPicker`.
				**Note:** If `node` already has a parent, this method will fail. Use `remove_child` first to remove `node` from its current parent. For example:
				`codeblocks`
				`gdscript`
				var child_node = get_child(0)
				if child_node.get_parent():
					child_node.get_parent().remove_child(child_node)
				add_child(child_node)
				
				`csharp`
				Node childNode = GetChild(0);
				if (childNode.GetParent() != null)
				{
					childNode.GetParent().RemoveChild(childNode);
				}
				AddChild(childNode);
				
				
				If you need the child node to be added below a specific node in the list of children, use `add_sibling` instead of this method.
				**Note:** If you want a child to be persisted to a `PackedScene`, you must set `owner` in addition to calling `add_child`. This is typically relevant for tool scripts ($DOCS_URL/tutorials/plugins/running_code_in_the_editor.html) and editor plugins ($DOCS_URL/tutorials/plugins/editor/index.html). If `add_child` is called without setting `owner`, the newly added `Node` will not be visible in the scene tree, though it will be visible in the 2D/3D view.

### `add_sibling(sibling: Node, force_readable_name: bool = false) -> void`

Adds a `sibling` node to this node's parent, and moves the added sibling right below this node.
				If `force_readable_name` is `true`, improves the readability of the added `sibling`. If not named, the `sibling` is renamed to its type, and if it shares `name` with a sibling, a number is suffixed more appropriately. This operation is very slow. As such, it is recommended leaving this to `false`, which assigns a dummy name featuring `@` in both situations.
				Use `add_child` instead of this method if you don't need the child node to be added below a specific node in the list of children.
				**Note:** If this node is internal, the added sibling will be internal too (see `add_child`'s `internal` parameter).

### `add_to_group(group: StringName, persistent: bool = false) -> void`

Adds the node to the `group`. Groups can be helpful to organize a subset of nodes, for example `"enemies"` or `"collectables"`. See notes in the description, and the group methods in `SceneTree`.
				If `persistent` is `true`, the group will be stored when saved inside a `PackedScene`. All groups created and displayed in the Groups dock are persistent.
				**Note:** To improve performance, the order of group names is *not* guaranteed and may vary between project runs. Therefore, do not rely on the group order.
				**Note:** `SceneTree`'s group methods will *not* work on this node if not inside the tree (see `is_inside_tree`).

### `atr(message: String, context: StringName = "") -> String`
- 限定：qualifiers=const

Translates a `message`, using the translation catalogs configured in the Project Settings. Further `context` can be specified to help with the translation. Note that most `Control` nodes automatically translate their strings, so this method is mostly useful for formatted strings or custom drawn text.
				This method works the same as `Object.tr`, with the addition of respecting the `auto_translate_mode` state.
				If `Object.can_translate_messages` is `false`, or no translation is available, this method returns the `message` without changes. See `Object.set_message_translation`.
				For detailed examples, see Internationalizing games ($DOCS_URL/tutorials/i18n/internationalizing_games.html).

### `atr_n(message: String, plural_message: StringName, n: int, context: StringName = "") -> String`
- 限定：qualifiers=const

Translates a `message` or `plural_message`, using the translation catalogs configured in the Project Settings. Further `context` can be specified to help with the translation.
				This method works the same as `Object.tr_n`, with the addition of respecting the `auto_translate_mode` state.
				If `Object.can_translate_messages` is `false`, or no translation is available, this method returns `message` or `plural_message`, without changes. See `Object.set_message_translation`.
				The `n` is the number, or amount, of the message's subject. It is used by the translation system to fetch the correct plural form for the current language.
				For detailed examples, see Localization using gettext ($DOCS_URL/tutorials/i18n/localization_using_gettext.html).
				**Note:** Negative and `float` numbers may not properly apply to some countable subjects. It's recommended to handle these cases with `atr`.

### `call_deferred_thread_group(method: StringName) -> Variant`
- 限定：qualifiers=vararg

This function is similar to `Object.call_deferred` except that the call will take place when the node thread group is processed. If the node thread group processes in sub-threads, then the call will be done on that thread, right before `NOTIFICATION_PROCESS` or `NOTIFICATION_PHYSICS_PROCESS`, the `_process` or `_physics_process` or their internal versions are called.

### `call_thread_safe(method: StringName) -> Variant`
- 限定：qualifiers=vararg

This function ensures that the calling of this function will succeed, no matter whether it's being done from a thread or not. If called from a thread that is not allowed to call the function, the call will become deferred. Otherwise, the call will go through directly.

### `can_auto_translate() -> bool`
- 限定：qualifiers=const

Returns `true` if this node can automatically translate messages depending on the current locale. See `auto_translate_mode`, `atr`, and `atr_n`.

### `can_process() -> bool`
- 限定：qualifiers=const

Returns `true` if the node can receive processing notifications and input callbacks (`NOTIFICATION_PROCESS`, `_input`, etc.) from the `SceneTree` and `Viewport`. The returned value depends on `process_mode`:
				- If set to `PROCESS_MODE_PAUSABLE`, returns `true` when the game is processing, i.e. `SceneTree.paused` is `false`;
				- If set to `PROCESS_MODE_WHEN_PAUSED`, returns `true` when the game is paused, i.e. `SceneTree.paused` is `true`;
				- If set to `PROCESS_MODE_ALWAYS`, always returns `true`;
				- If set to `PROCESS_MODE_DISABLED`, always returns `false`;
				- If set to `PROCESS_MODE_INHERIT`, use the parent node's `process_mode` to determine the result.
				If the node is not inside the tree, returns `false` no matter the value of `process_mode`.

### `create_tween() -> Tween`

Creates a new `Tween` and binds it to this node.
				This is the equivalent of doing:
				`codeblocks`
				`gdscript`
				get_tree().create_tween().bind_node(self)
				
				`csharp`
				GetTree().CreateTween().BindNode(this);
				
				
				The Tween will start automatically on the next process frame or physics frame (depending on `Tween.TweenProcessMode`). See `Tween.bind_node` for more info on Tweens bound to nodes.
				**Note:** The method can still be used when the node is not inside `SceneTree`. It can fail in an unlikely case of using a custom `MainLoop`.

### `duplicate(flags: int = 15) -> Node`
- 限定：qualifiers=const

Duplicates the node, returning a new node with all of its properties, signals, groups, and children copied from the original, recursively. The behavior can be tweaked through the `flags` (see `DuplicateFlags`). Internal nodes are not duplicated.
				**Note:** For nodes with a `Script` attached, if `Object._init` has been defined with required parameters, the duplicated node will not have a `Script`.
				**Note:** By default, this method will duplicate only properties marked for serialization (i.e. using `@GlobalScope.PROPERTY_USAGE_STORAGE`, or in GDScript, `@GDScript.@export`). If you want to duplicate all properties, use `DUPLICATE_INTERNAL_STATE`.

### `find_child(pattern: String, recursive: bool = true, owned: bool = true) -> Node`
- 限定：qualifiers=const

Finds the first descendant of this node whose `name` matches `pattern`, returning `null` if no match is found. The matching is done against node names, *not* their paths, through `String.match`. As such, it is case-sensitive, `"*"` matches zero or more characters, and `"?"` matches any single character.
				If `recursive` is `false`, only this node's direct children are checked. Nodes are checked in tree order, so this node's first direct child is checked first, then its own direct children, etc., before moving to the second direct child, and so on. Internal children are also included in the search (see `internal` parameter in `add_child`).
				If `owned` is `true`, only descendants with a valid `owner` node are checked.
				**Note:** This method can be very slow. Consider storing a reference to the found node in a variable. Alternatively, use `get_node` with unique names (see `unique_name_in_owner`).
				**Note:** To find all descendant nodes matching a pattern or a class type, see `find_children`.

### `find_children(pattern: String, type: String = "", recursive: bool = true, owned: bool = true) -> Node[]`
- 限定：qualifiers=const

Finds all descendants of this node whose names match `pattern`, returning an empty `Array` if no match is found. The matching is done against node names, *not* their paths, through `String.match`. As such, it is case-sensitive, `"*"` matches zero or more characters, and `"?"` matches any single character.
				If `type` is not empty, only descendants inheriting from `type` are included (see `Object.is_class`).
				If `recursive` is `false`, only this node's direct children are checked. Nodes are checked in tree order, so this node's first direct child is checked first, then its own direct children, etc., before moving to the second direct child, and so on. Internal children are also included in the search (see `internal` parameter in `add_child`).
				If `owned` is `true`, only descendants with a valid `owner` node are checked.
				**Note:** This method can be very slow. Consider storing references to the found nodes in a variable.
				**Note:** To find a single descendant node matching a pattern, see `find_child`.

### `find_parent(pattern: String) -> Node`
- 限定：qualifiers=const

Finds the first ancestor of this node whose `name` matches `pattern`, returning `null` if no match is found. The matching is done through `String.match`. As such, it is case-sensitive, `"*"` matches zero or more characters, and `"?"` matches any single character. See also `find_child` and `find_children`.
				**Note:** As this method walks upwards in the scene tree, it can be slow in large, deeply nested nodes. Consider storing a reference to the found node in a variable. Alternatively, use `get_node` with unique names (see `unique_name_in_owner`).

### `get_accessibility_element() -> RID`
- 限定：qualifiers=const

Returns main accessibility element RID.
				**Note:** This method should be called only during accessibility information updates (`NOTIFICATION_ACCESSIBILITY_UPDATE`).

### `get_child(idx: int, include_internal: bool = false) -> Node`
- 限定：qualifiers=const

Fetches a child node by its index. Each child node has an index relative to its siblings (see `get_index`). The first child is at index 0. Negative values can also be used to start from the end of the list. This method can be used in combination with `get_child_count` to iterate over this node's children. If no child exists at the given index, this method returns `null` and an error is generated.
				If `include_internal` is `false`, internal children are ignored (see `add_child`'s `internal` parameter).
				
```gdscript
				# Assuming the following are children of this node, in order:
				# First, Middle, Last.

				var a = get_child(0).name  # a is "First"
				var b = get_child(1).name  # b is "Middle"
				var b = get_child(2).name  # b is "Last"
				var c = get_child(-1).name # c is "Last"
				
```

				**Note:** To fetch a node by `NodePath`, use `get_node`.

### `get_child_count(include_internal: bool = false) -> int`
- 限定：qualifiers=const

Returns the number of children of this node.
				If `include_internal` is `false`, internal children are not counted (see `add_child`'s `internal` parameter).

### `get_children(include_internal: bool = false) -> Node[]`
- 限定：qualifiers=const

Returns all children of this node inside an `Array`.
				If `include_internal` is `false`, excludes internal children from the returned array (see `add_child`'s `internal` parameter).

### `get_groups() -> StringName[]`
- 限定：qualifiers=const

Returns an `Array` of group names that the node has been added to.
				**Note:** To improve performance, the order of group names is *not* guaranteed and may vary between project runs. Therefore, do not rely on the group order.
				**Note:** This method may also return some group names starting with an underscore (`_`). These are internally used by the engine. To avoid conflicts, do not use custom groups starting with underscores. To exclude internal groups, see the following code snippet:
				`codeblocks`
				`gdscript`
				# Stores the node's non-internal groups only (as an array of StringNames).
				var non_internal_groups = []
				for group in get_groups():
					if not str(group).begins_with("_"):
						non_internal_groups.push_back(group)
				
				`csharp`
				// Stores the node's non-internal groups only (as a List of StringNames).
				List<string> nonInternalGroups = new List<string>();
				foreach (string group in GetGroups())
				{
					if (!group.BeginsWith("_"))
						nonInternalGroups.Add(group);
				}

### `get_index(include_internal: bool = false) -> int`
- 限定：qualifiers=const

Returns this node's order among its siblings. The first node's index is `0`. See also `get_child`.
				If `include_internal` is `false`, returns the index ignoring internal children. The first, non-internal child will have an index of `0` (see `add_child`'s `internal` parameter).

### `get_last_exclusive_window() -> Window`
- 限定：qualifiers=const

Returns the `Window` that contains this node, or the last exclusive child in a chain of windows starting with the one that contains this node.

### `get_multiplayer_authority() -> int`
- 限定：qualifiers=const

Returns the peer ID of the multiplayer authority for this node. See `set_multiplayer_authority`.

### `get_node(path: NodePath) -> Node`
- 限定：qualifiers=const

Fetches a node. The `NodePath` can either be a relative path (from this node), or an absolute path (from the `SceneTree.root`) to a node. If `path` does not point to a valid node, generates an error and returns `null`. Attempts to access methods on the return value will result in an *"Attempt to call <method> on a null instance."* error.
				**Note:** Fetching by absolute path only works when the node is inside the scene tree (see `is_inside_tree`).
				**Example:** Assume this method is called from the Character node, inside the following tree:
				`lang=text`
				 ┖╴root
				    ┠╴Character (you are here!)
				    ┃  ┠╴Sword
				    ┃  ┖╴Backpack
				    ┃     ┖╴Dagger
				    ┠╴MyGame
				    ┖╴Swamp
				       ┠╴Alligator
				       ┠╴Mosquito
				       ┖╴Goblin
				
				The following calls will return a valid node:
				`codeblocks`
				`gdscript`
				get_node("Sword")
				get_node("Backpack/Dagger")
				get_node("../Swamp/Alligator")
				get_node("/root/MyGame")
				
				`csharp`
				GetNode("Sword");
				GetNode("Backpack/Dagger");
				GetNode("../Swamp/Alligator");
				GetNode("/root/MyGame");

### `get_node_and_resource(path: NodePath) -> Array`

Fetches a node and its most nested resource as specified by the `NodePath`'s subname. Returns an `Array` of size `3` where:
				- Element `0` is the `Node`, or `null` if not found;
				- Element `1` is the subname's last nested `Resource`, or `null` if not found;
				- Element `2` is the remaining `NodePath`, referring to an existing, non-`Resource` property (see `Object.get_indexed`).
				**Example:** Assume that the child's `Sprite2D.texture` has been assigned an `AtlasTexture`:
				`codeblocks`
				`gdscript`
				var a = get_node_and_resource("Area2D/Sprite2D")
				print(a[0].name) # Prints Sprite2D
				print(a[1])      # Prints <null>
				print(a[2])      # Prints ^""

				var b = get_node_and_resource("Area2D/Sprite2D:texture:atlas")
				print(b[0].name)        # Prints Sprite2D
				print(b[1].get_class()) # Prints AtlasTexture
				print(b[2])             # Prints ^""

				var c = get_node_and_resource("Area2D/Sprite2D:texture:atlas:region")
				print(c[0].name)        # Prints Sprite2D
				print(c[1].get_class()) # Prints AtlasTexture
				print(c[2])             # Prints ^":region"
				
				`csharp`
				var a = GetNodeAndResource(NodePath("Area2D/Sprite2D"));
				GD.Print(a[0].Name); // Prints Sprite2D
				GD.Print(a[1]);      // Prints <null>
				GD.Print(a[2]);      // Prints ^"

				var b = GetNodeAndResource(NodePath("Area2D/Sprite2D:texture:atlas"));
				GD.Print(b[0].name);        // Prints Sprite2D
				GD.Print(b[1].get_class()); // Prints AtlasTexture
				GD.Print(b[2]);             // Prints ^""

				var c = GetNodeAndResource(NodePath("Area2D/Sprite2D:texture:atlas:region"));
				GD.Print(c[0].name);        // Prints Sprite2D
				GD.Print(c[1].get_class()); // Prints AtlasTexture
				GD.Print(c[2]);             // Prints ^":region"

### `get_node_or_null(path: NodePath) -> Node`
- 限定：qualifiers=const

Fetches a node by `NodePath`. Similar to `get_node`, but does not generate an error if `path` does not point to a valid node.

### `get_node_rpc_config() -> Variant`
- 限定：qualifiers=const

Returns a `Dictionary` mapping method names to their RPC configuration defined for this node using `rpc_config`.
				**Note:** This method only returns the RPC configuration assigned via `rpc_config`. See `Script.get_rpc_config` to retrieve the RPCs defined by the `Script`.

### `get_orphan_node_ids() -> int[]`
- 限定：qualifiers=static

Returns object IDs of all orphan nodes (nodes outside the `SceneTree`). Used for debugging.
				**Note:** `get_orphan_node_ids` only works in debug builds. When called in a project exported in release mode, `get_orphan_node_ids` will return an empty array.

### `get_parent() -> Node`
- 限定：qualifiers=const

Returns this node's parent node, or `null` if the node doesn't have a parent.

### `get_path() -> NodePath`
- 限定：qualifiers=const

Returns the node's absolute path, relative to the `SceneTree.root`. If the node is not inside the scene tree, this method fails and returns an empty `NodePath`.

### `get_path_to(node: Node, use_unique_path: bool = false) -> NodePath`
- 限定：qualifiers=const

Returns the relative `NodePath` from this node to the specified `node`. Both nodes must be in the same `SceneTree` or scene hierarchy, otherwise this method fails and returns an empty `NodePath`.
				If `use_unique_path` is `true`, returns the shortest path accounting for this node's unique name (see `unique_name_in_owner`).
				**Note:** If you get a relative path which starts from a unique node, the path may be longer than a normal relative path, due to the addition of the unique node's name.

### `get_physics_process_delta_time() -> float`
- 限定：qualifiers=const

Returns the time elapsed (in seconds) since the last physics callback. This value is identical to `_physics_process`'s `delta` parameter, and is often consistent at run-time, unless `Engine.physics_ticks_per_second` is changed. See also `NOTIFICATION_PHYSICS_PROCESS`.
				**Note:** The returned value will be larger than expected if running at a framerate lower than `Engine.physics_ticks_per_second` / `Engine.max_physics_steps_per_frame` FPS. This is done to avoid "spiral of death" scenarios where performance would plummet due to an ever-increasing number of physics steps per frame. This behavior affects both `_process` and `_physics_process`. As a result, avoid using `delta` for time measurements in real-world seconds. Use the `Time` singleton's methods for this purpose instead, such as `Time.get_ticks_usec`.

### `get_process_delta_time() -> float`
- 限定：qualifiers=const

Returns the time elapsed (in seconds) since the last process callback. This value is identical to `_process`'s `delta` parameter, and may vary from frame to frame. See also `NOTIFICATION_PROCESS`.
				**Note:** The returned value will be larger than expected if running at a framerate lower than `Engine.physics_ticks_per_second` / `Engine.max_physics_steps_per_frame` FPS. This is done to avoid "spiral of death" scenarios where performance would plummet due to an ever-increasing number of physics steps per frame. This behavior affects both `_process` and `_physics_process`. As a result, avoid using `delta` for time measurements in real-world seconds. Use the `Time` singleton's methods for this purpose instead, such as `Time.get_ticks_usec`.

### `get_scene_instance_load_placeholder() -> bool`
- 限定：qualifiers=const

Returns `true` if this node is an instance load placeholder. See `InstancePlaceholder` and `set_scene_instance_load_placeholder`.

### `get_tree() -> SceneTree`
- 限定：qualifiers=const

Returns the `SceneTree` that contains this node. If this node is not inside the tree, generates an error and returns `null`. See also `is_inside_tree`.

### `get_tree_string() -> String`

Returns the tree as a `String`. Used mainly for debugging purposes. This version displays the path relative to the current node, and is good for copy/pasting into the `get_node` function. It also can be used in game UI/UX.
				May print, for example:
				`lang=text`
				TheGame
				TheGame/Menu
				TheGame/Menu/Label
				TheGame/Menu/Camera2D
				TheGame/SplashScreen
				TheGame/SplashScreen/Camera2D

### `get_tree_string_pretty() -> String`

Similar to `get_tree_string`, this returns the tree as a `String`. This version displays a more graphical representation similar to what is displayed in the Scene Dock. It is useful for inspecting larger trees.
				May print, for example:
				`lang=text`
				 ┖╴TheGame
				    ┠╴Menu
				    ┃  ┠╴Label
				    ┃  ┖╴Camera2D
				    ┖╴SplashScreen
				       ┖╴Camera2D

### `get_viewport() -> Viewport`
- 限定：qualifiers=const

Returns the node's closest `Viewport` ancestor, if the node is inside the tree. Otherwise, returns `null`.

### `get_window() -> Window`
- 限定：qualifiers=const

Returns the `Window` that contains this node. If the node is in the main window, this is equivalent to getting the root node (`get_tree().get_root()`).

### `has_node(path: NodePath) -> bool`
- 限定：qualifiers=const

Returns `true` if the `path` points to a valid node. See also `get_node`.

### `has_node_and_resource(path: NodePath) -> bool`
- 限定：qualifiers=const

Returns `true` if `path` points to a valid node and its subnames point to a valid `Resource`, e.g. `Area2D/CollisionShape2D:shape`. Properties that are not `Resource` types (such as nodes or other `Variant` types) are not considered. See also `get_node_and_resource`.

### `is_ancestor_of(node: Node) -> bool`
- 限定：qualifiers=const

Returns `true` if the given `node` is a direct or indirect child of this node.

### `is_displayed_folded() -> bool`
- 限定：qualifiers=const

Returns `true` if the node is folded (collapsed) in the Scene dock. This method is intended to be used in editor plugins and tools. See also `set_display_folded`.

### `is_editable_instance(node: Node) -> bool`
- 限定：qualifiers=const

Returns `true` if `node` has editable children enabled relative to this node. This method is intended to be used in editor plugins and tools. See also `set_editable_instance`.

### `is_greater_than(node: Node) -> bool`
- 限定：qualifiers=const

Returns `true` if the given `node` occurs later in the scene hierarchy than this node. A node occurring later is usually processed last.

### `is_in_group(group: StringName) -> bool`
- 限定：qualifiers=const

Returns `true` if this node has been added to the given `group`. See `add_to_group` and `remove_from_group`. See also notes in the description, and the `SceneTree`'s group methods.

### `is_inside_tree() -> bool`
- 限定：qualifiers=const

Returns `true` if this node is currently inside a `SceneTree`. See also `get_tree`.

### `is_multiplayer_authority() -> bool`
- 限定：qualifiers=const

Returns `true` if the local system is the multiplayer authority of this node.

### `is_node_ready() -> bool`
- 限定：qualifiers=const

Returns `true` if the node is ready, i.e. it's inside scene tree and all its children are initialized.
				`request_ready` resets it back to `false`.

### `is_part_of_edited_scene() -> bool`
- 限定：qualifiers=const

Returns `true` if the node is part of the scene currently opened in the editor.

### `is_physics_interpolated() -> bool`
- 限定：qualifiers=const

Returns `true` if physics interpolation is enabled for this node (see `physics_interpolation_mode`).
				**Note:** Interpolation will only be active if both the flag is set **and** physics interpolation is enabled within the `SceneTree`. This can be tested using `is_physics_interpolated_and_enabled`.

### `is_physics_interpolated_and_enabled() -> bool`
- 限定：qualifiers=const

Returns `true` if physics interpolation is enabled (see `physics_interpolation_mode`) **and** enabled in the `SceneTree`.
				This is a convenience version of `is_physics_interpolated` that also checks whether physics interpolation is enabled globally.
				See `SceneTree.physics_interpolation` and `ProjectSettings.physics/common/physics_interpolation`.

### `is_physics_processing() -> bool`
- 限定：qualifiers=const

Returns `true` if physics processing is enabled (see `set_physics_process`).

### `is_physics_processing_internal() -> bool`
- 限定：qualifiers=const

Returns `true` if internal physics processing is enabled (see `set_physics_process_internal`).

### `is_processing() -> bool`
- 限定：qualifiers=const

Returns `true` if processing is enabled (see `set_process`).

### `is_processing_input() -> bool`
- 限定：qualifiers=const

Returns `true` if the node is processing input (see `set_process_input`).

### `is_processing_internal() -> bool`
- 限定：qualifiers=const

Returns `true` if internal processing is enabled (see `set_process_internal`).

### `is_processing_shortcut_input() -> bool`
- 限定：qualifiers=const

Returns `true` if the node is processing shortcuts (see `set_process_shortcut_input`).

### `is_processing_unhandled_input() -> bool`
- 限定：qualifiers=const

Returns `true` if the node is processing unhandled input (see `set_process_unhandled_input`).

### `is_processing_unhandled_key_input() -> bool`
- 限定：qualifiers=const

Returns `true` if the node is processing unhandled key input (see `set_process_unhandled_key_input`).

### `move_child(child_node: Node, to_index: int) -> void`

Moves `child_node` to the given index. A node's index is the order among its siblings. If `to_index` is negative, the index is counted from the end of the list. See also `get_child` and `get_index`.
				**Note:** The processing order of several engine callbacks (`_ready`, `_process`, etc.) and notifications sent through `propagate_notification` is affected by tree order. `CanvasItem` nodes are also rendered in tree order. See also `process_priority`.

### `notify_deferred_thread_group(what: int) -> void`

Similar to `call_deferred_thread_group`, but for notifications.

### `notify_thread_safe(what: int) -> void`

Similar to `call_thread_safe`, but for notifications.

### `print_orphan_nodes() -> void`
- 限定：qualifiers=static

Prints all orphan nodes (nodes outside the `SceneTree`). Useful for debugging.
				**Note:** This method only works in debug builds. It does nothing in a project exported in release mode.

### `print_tree() -> void`

Prints the node and its children to the console, recursively. The node does not have to be inside the tree. This method outputs `NodePath`s relative to this node, and is good for copy/pasting into `get_node`. See also `print_tree_pretty`.
				May print, for example:
				`lang=text`
				.
				Menu
				Menu/Label
				Menu/Camera2D
				SplashScreen
				SplashScreen/Camera2D

### `print_tree_pretty() -> void`

Prints the node and its children to the console, recursively. The node does not have to be inside the tree. Similar to `print_tree`, but the graphical representation looks like what is displayed in the editor's Scene dock. It is useful for inspecting larger trees.
				May print, for example:
				`lang=text`
				 ┖╴TheGame
				    ┠╴Menu
				    ┃  ┠╴Label
				    ┃  ┖╴Camera2D
				    ┖╴SplashScreen
				       ┖╴Camera2D

### `propagate_call(method: StringName, args: Array = [], parent_first: bool = false) -> void`

Calls the given `method` name, passing `args` as arguments, on this node and all of its children, recursively.
				If `parent_first` is `true`, the method is called on this node first, then on all of its children. If `false`, the children's methods are called first.

### `propagate_notification(what: int) -> void`

Calls `Object.notification` with `what` on this node and all of its children, recursively.

### `queue_accessibility_update() -> void`

Queues an accessibility information update for this node.

### `queue_free() -> void`
- 限定：keywords=delete, remove, kill, die

Queues this node to be deleted at the end of the current frame. When deleted, all of its children are deleted as well, and all references to the node and its children become invalid.
				Unlike with `Object.free`, the node is not deleted instantly, and it can still be accessed before deletion. It is also safe to call `queue_free` multiple times. Use `Object.is_queued_for_deletion` to check if the node will be deleted at the end of the frame.
				**Note:** The node will only be freed after all other deferred calls are finished. Using this method is not always the same as calling `Object.free` through `Object.call_deferred`.

### `remove_child(node: Node) -> void`

Removes a child `node`. The `node`, along with its children, are **not** deleted. To delete a node, see `queue_free`.
				**Note:** When this node is inside the tree, this method sets the `owner` of the removed `node` (or its descendants) to `null`, if their `owner` is no longer an ancestor (see `is_ancestor_of`).

### `remove_from_group(group: StringName) -> void`

Removes the node from the given `group`. Does nothing if the node is not in the `group`. See also notes in the description, and the `SceneTree`'s group methods.

### `reparent(new_parent: Node, keep_global_transform: bool = true) -> void`

Changes the parent of this `Node` to the `new_parent`. The node needs to already have a parent. The node's `owner` is preserved if its owner is still reachable from the new location (i.e., the node is still a descendant of the new parent after the operation).
				If `keep_global_transform` is `true`, the node's global transform will be preserved if supported. `Node2D`, `Node3D` and `Control` support this argument (but `Control` keeps only position).
				**Warning:** If `ProjectSettings.physics/common/physics_interpolation` is enabled and reparenting causes a large change in global transform, the object may appear to move from its old position to its new one over the next physics tick. To avoid this, call `reset_physics_interpolation` after reparenting.

### `replace_by(node: Node, keep_groups: bool = false) -> void`

Replaces this node by the given `node`. All children of this node are moved to `node`.
				If `keep_groups` is `true`, the `node` is added to the same groups that the replaced node is in (see `add_to_group`).
				**Warning:** The replaced node is removed from the tree, but it is **not** deleted. To prevent memory leaks, store a reference to the node in a variable, or use `Object.free`.

### `request_ready() -> void`

Requests `_ready` to be called again the next time the node enters the tree. Does **not** immediately call `_ready`.
				**Note:** This method only affects the current node. If the node's children also need to request ready, this method needs to be called for each one of them. When the node and its children enter the tree again, the order of `_ready` callbacks will be the same as normal.

### `reset_physics_interpolation() -> void`

When physics interpolation is active, moving a node to a radically different transform (such as placement within a level) can result in a visible glitch as the object is rendered moving from the old to new position over the physics tick.
				That glitch can be prevented by calling this method, which temporarily disables interpolation until the physics tick is complete.
				The notification `NOTIFICATION_RESET_PHYSICS_INTERPOLATION` will be received by the node and all children recursively.
				**Note:** This function should be called **after** moving the node, rather than before.

### `rpc(method: StringName) -> int`
- 限定：qualifiers=vararg

Sends a remote procedure call request for the given `method` to peers on the network (and locally), sending additional arguments to the method called by the RPC. The call request will only be received by nodes with the same `NodePath`, including the exact same `name`. Behavior depends on the RPC configuration for the given `method` (see `rpc_config` and `@GDScript.@rpc`). By default, methods are not exposed to RPCs.
				May return `OK` if the call is successful, `ERR_INVALID_PARAMETER` if the arguments passed in the `method` do not match, `ERR_UNCONFIGURED` if the node's `multiplayer` cannot be fetched (such as when the node is not inside the tree), `ERR_CONNECTION_ERROR` if `multiplayer`'s connection is not available.
				**Note:** You can only safely use RPCs on clients after you received the `MultiplayerAPI.connected_to_server` signal from the `MultiplayerAPI`. You also need to keep track of the connection state, either by the `MultiplayerAPI` signals like `MultiplayerAPI.server_disconnected` or by checking (`get_multiplayer().peer.get_connection_status() == CONNECTION_CONNECTED`).

### `rpc_config(method: StringName, config: Variant) -> void`

Changes the RPC configuration for the given `method`. `config` should either be `null` to disable the feature (as by default), or a `Dictionary` containing the following entries:
				- `rpc_mode`: see `MultiplayerAPI.RPCMode`;
				- `transfer_mode`: see `MultiplayerPeer.TransferMode`;
				- `call_local`: if `true`, the method will also be called locally;
				- `channel`: an `int` representing the channel to send the RPC on.
				**Note:** In GDScript, this method corresponds to the `@GDScript.@rpc` annotation, with various parameters passed (`@rpc(any)`, `@rpc(authority)`...). See also the high-level multiplayer ($DOCS_URL/tutorials/networking/high_level_multiplayer.html) tutorial.

### `rpc_id(peer_id: int, method: StringName) -> int`
- 限定：qualifiers=vararg

Sends a `rpc` to a specific peer identified by `peer_id` (see `MultiplayerPeer.set_target_peer`).
				May return `OK` if the call is successful, `ERR_INVALID_PARAMETER` if the arguments passed in the `method` do not match, `ERR_UNCONFIGURED` if the node's `multiplayer` cannot be fetched (such as when the node is not inside the tree), `ERR_CONNECTION_ERROR` if `multiplayer`'s connection is not available.

### `set_deferred_thread_group(property: StringName, value: Variant) -> void`

Similar to `call_deferred_thread_group`, but for setting properties.

### `set_display_folded(fold: bool) -> void`

If set to `true`, the node appears folded in the Scene dock. As a result, all of its children are hidden. This method is intended to be used in editor plugins and tools, but it also works in release builds. See also `is_displayed_folded`.

### `set_editable_instance(node: Node, is_editable: bool) -> void`

Set to `true` to allow all nodes owned by `node` to be available, and editable, in the Scene dock, even if their `owner` is not the scene root. This method is intended to be used in editor plugins and tools, but it also works in release builds. See also `is_editable_instance`.

### `set_multiplayer_authority(id: int, recursive: bool = true) -> void`

Sets the node's multiplayer authority to the peer with the given peer `id`. The multiplayer authority is the peer that has authority over the node on the network. Defaults to peer ID 1 (the server). Useful in conjunction with `rpc_config` and the `MultiplayerAPI`.
				If `recursive` is `true`, the given peer is recursively set as the authority for all children of this node.
				**Warning:** This does **not** automatically replicate the new authority to other peers. It is the developer's responsibility to do so. You may replicate the new authority's information using `MultiplayerSpawner.spawn_function`, an RPC, or a `MultiplayerSynchronizer`. Furthermore, the parent's authority does **not** propagate to newly added children.

### `set_physics_process(enable: bool) -> void`

If set to `true`, enables physics (fixed framerate) processing. When a node is being processed, it will receive a `NOTIFICATION_PHYSICS_PROCESS` at a fixed (usually 60 FPS, see `Engine.physics_ticks_per_second` to change) interval (and the `_physics_process` callback will be called if it exists).
				**Note:** If `_physics_process` is overridden, this will be automatically enabled before `_ready` is called.

### `set_physics_process_internal(enable: bool) -> void`

If set to `true`, enables internal physics for this node. Internal physics processing happens in isolation from the normal `_physics_process` calls and is used by some nodes internally to guarantee proper functioning even if the node is paused or physics processing is disabled for scripting (`set_physics_process`).
				**Warning:** Built-in nodes rely on internal processing for their internal logic. Disabling it is unsafe and may lead to unexpected behavior. Use this method if you know what you are doing.

### `set_process(enable: bool) -> void`

If set to `true`, enables processing. When a node is being processed, it will receive a `NOTIFICATION_PROCESS` on every drawn frame (and the `_process` callback will be called if it exists).
				**Note:** If `_process` is overridden, this will be automatically enabled before `_ready` is called.
				**Note:** This method only affects the `_process` callback, i.e. it has no effect on other callbacks like `_physics_process`. If you want to disable all processing for the node, set `process_mode` to `PROCESS_MODE_DISABLED`.

### `set_process_input(enable: bool) -> void`

If set to `true`, enables input processing.
				**Note:** If `_input` is overridden, this will be automatically enabled before `_ready` is called. Input processing is also already enabled for GUI controls, such as `Button` and `TextEdit`.

### `set_process_internal(enable: bool) -> void`

If set to `true`, enables internal processing for this node. Internal processing happens in isolation from the normal `_process` calls and is used by some nodes internally to guarantee proper functioning even if the node is paused or processing is disabled for scripting (`set_process`).
				**Warning:** Built-in nodes rely on internal processing for their internal logic. Disabling it is unsafe and may lead to unexpected behavior. Use this method if you know what you are doing.

### `set_process_shortcut_input(enable: bool) -> void`

If set to `true`, enables shortcut processing for this node.
				**Note:** If `_shortcut_input` is overridden, this will be automatically enabled before `_ready` is called.

### `set_process_unhandled_input(enable: bool) -> void`

If set to `true`, enables unhandled input processing. It enables the node to receive all input that was not previously handled (usually by a `Control`).
				**Note:** If `_unhandled_input` is overridden, this will be automatically enabled before `_ready` is called. Unhandled input processing is also already enabled for GUI controls, such as `Button` and `TextEdit`.

### `set_process_unhandled_key_input(enable: bool) -> void`

If set to `true`, enables unhandled key input processing.
				**Note:** If `_unhandled_key_input` is overridden, this will be automatically enabled before `_ready` is called.

### `set_scene_instance_load_placeholder(load_placeholder: bool) -> void`

If set to `true`, the node becomes an `InstancePlaceholder` when packed and instantiated from a `PackedScene`. See also `get_scene_instance_load_placeholder`.

### `set_thread_safe(property: StringName, value: Variant) -> void`

Similar to `call_thread_safe`, but for setting properties.

### `set_translation_domain_inherited() -> void`

Makes this node inherit the translation domain from its parent node. If this node has no parent, the main translation domain will be used.
				This is the default behavior for all nodes. Calling `Object.set_translation_domain` disables this behavior.

### `update_configuration_warnings() -> void`

Refreshes the warnings displayed for this node in the Scene dock. Use `_get_configuration_warnings` to customize the warning messages to display.

## 信号

### `child_entered_tree(node: Node)`

Emitted when the child `node` enters the `SceneTree`, usually because this node entered the tree (see `tree_entered`), or `add_child` has been called.
				This signal is emitted *after* the child node's own `NOTIFICATION_ENTER_TREE` and `tree_entered`.

### `child_exiting_tree(node: Node)`

Emitted when the child `node` is about to exit the `SceneTree`, usually because this node is exiting the tree (see `tree_exiting`), or because the child `node` is being removed or freed.
				When this signal is received, the child `node` is still accessible inside the tree. This signal is emitted *after* the child node's own `tree_exiting` and `NOTIFICATION_EXIT_TREE`.

### `child_order_changed()`

Emitted when the list of children is changed. This happens when child nodes are added, moved or removed.

### `editor_description_changed(node: Node)`

Emitted when the node's editor description field changed.

### `editor_state_changed()`

Emitted when an attribute of the node that is relevant to the editor is changed. Only emitted in the editor.

### `ready()`

Emitted when the node is considered ready, after `_ready` is called.

### `renamed()`

Emitted when the node's `name` is changed, if the node is inside the tree.

### `replacing_by(node: Node)`

Emitted when this node is being replaced by the `node`, see `replace_by`.
				This signal is emitted *after* `node` has been added as a child of the original parent node, but *before* all original child nodes have been reparented to `node`.

### `tree_entered()`

Emitted when the node enters the tree.
				This signal is emitted *after* the related `NOTIFICATION_ENTER_TREE` notification.

### `tree_exited()`

Emitted after the node exits the tree and is no longer active.
				This signal is emitted *after* the related `NOTIFICATION_EXIT_TREE` notification.

### `tree_exiting()`

Emitted when the node is just about to exit the tree. The node is still valid. As such, this is the right place for de-initialization (or a "destructor", if you will).
				This signal is emitted *after* the node's `_exit_tree`, and *before* the related `NOTIFICATION_EXIT_TREE`.

## 枚举

### `ProcessMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `PROCESS_MODE_INHERIT` |  |
| `1` | `PROCESS_MODE_PAUSABLE` |  |
| `2` | `PROCESS_MODE_WHEN_PAUSED` |  |
| `3` | `PROCESS_MODE_ALWAYS` |  |
| `4` | `PROCESS_MODE_DISABLED` |  |

### `ProcessThreadGroup`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `PROCESS_THREAD_GROUP_INHERIT` |  |
| `1` | `PROCESS_THREAD_GROUP_MAIN_THREAD` |  |
| `2` | `PROCESS_THREAD_GROUP_SUB_THREAD` |  |

### `ProcessThreadMessages`

| 值 | 名称 | 说明 |
|---|---|---|
| `1` | `FLAG_PROCESS_THREAD_MESSAGES` | （位标志） |
| `2` | `FLAG_PROCESS_THREAD_MESSAGES_PHYSICS` | （位标志） |
| `3` | `FLAG_PROCESS_THREAD_MESSAGES_ALL` | （位标志） |

### `PhysicsInterpolationMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `PHYSICS_INTERPOLATION_MODE_INHERIT` |  |
| `1` | `PHYSICS_INTERPOLATION_MODE_ON` |  |
| `2` | `PHYSICS_INTERPOLATION_MODE_OFF` |  |

### `DuplicateFlags`

| 值 | 名称 | 说明 |
|---|---|---|
| `1` | `DUPLICATE_SIGNALS` |  |
| `2` | `DUPLICATE_GROUPS` |  |
| `4` | `DUPLICATE_SCRIPTS` |  |
| `8` | `DUPLICATE_USE_INSTANTIATION` |  |
| `16` | `DUPLICATE_INTERNAL_STATE` |  |
| `15` | `DUPLICATE_DEFAULT` |  |

### `InternalMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `INTERNAL_MODE_DISABLED` |  |
| `1` | `INTERNAL_MODE_FRONT` |  |
| `2` | `INTERNAL_MODE_BACK` |  |

### `AutoTranslateMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `AUTO_TRANSLATE_MODE_INHERIT` |  |
| `1` | `AUTO_TRANSLATE_MODE_ALWAYS` |  |
| `2` | `AUTO_TRANSLATE_MODE_DISABLED` |  |

## 常量

- **`NOTIFICATION_ENTER_TREE`** = `10`
- **`NOTIFICATION_EXIT_TREE`** = `11`
- **`NOTIFICATION_MOVED_IN_PARENT`** = `12`
- **`NOTIFICATION_READY`** = `13`
- **`NOTIFICATION_PAUSED`** = `14`
- **`NOTIFICATION_UNPAUSED`** = `15`
- **`NOTIFICATION_PHYSICS_PROCESS`** = `16`
- **`NOTIFICATION_PROCESS`** = `17`
- **`NOTIFICATION_PARENTED`** = `18`
- **`NOTIFICATION_UNPARENTED`** = `19`
- **`NOTIFICATION_SCENE_INSTANTIATED`** = `20`
- **`NOTIFICATION_DRAG_BEGIN`** = `21`
- **`NOTIFICATION_DRAG_END`** = `22`
- **`NOTIFICATION_PATH_RENAMED`** = `23`
- **`NOTIFICATION_CHILD_ORDER_CHANGED`** = `24`
- **`NOTIFICATION_INTERNAL_PROCESS`** = `25`
- **`NOTIFICATION_INTERNAL_PHYSICS_PROCESS`** = `26`
- **`NOTIFICATION_POST_ENTER_TREE`** = `27`
- **`NOTIFICATION_DISABLED`** = `28`
- **`NOTIFICATION_ENABLED`** = `29`
- **`NOTIFICATION_RESET_PHYSICS_INTERPOLATION`** = `2001`
- **`NOTIFICATION_EDITOR_PRE_SAVE`** = `9001`
- **`NOTIFICATION_EDITOR_POST_SAVE`** = `9002`
- **`NOTIFICATION_WM_MOUSE_ENTER`** = `1002`
- **`NOTIFICATION_WM_MOUSE_EXIT`** = `1003`
- **`NOTIFICATION_WM_WINDOW_FOCUS_IN`** = `1004`
- **`NOTIFICATION_WM_WINDOW_FOCUS_OUT`** = `1005`
- **`NOTIFICATION_WM_CLOSE_REQUEST`** = `1006`
- **`NOTIFICATION_WM_GO_BACK_REQUEST`** = `1007`
- **`NOTIFICATION_WM_SIZE_CHANGED`** = `1008`
- **`NOTIFICATION_WM_DPI_CHANGE`** = `1009`
- **`NOTIFICATION_VP_MOUSE_ENTER`** = `1010`
- **`NOTIFICATION_VP_MOUSE_EXIT`** = `1011`
- **`NOTIFICATION_WM_POSITION_CHANGED`** = `1012`
- **`NOTIFICATION_WM_OUTPUT_MAX_LINEAR_VALUE_CHANGED`** = `1013`
- **`NOTIFICATION_OS_MEMORY_WARNING`** = `2009`
- **`NOTIFICATION_TRANSLATION_CHANGED`** = `2010`
- **`NOTIFICATION_WM_ABOUT`** = `2011`
- **`NOTIFICATION_CRASH`** = `2012`
- **`NOTIFICATION_OS_IME_UPDATE`** = `2013`
- **`NOTIFICATION_APPLICATION_RESUMED`** = `2014`
- **`NOTIFICATION_APPLICATION_PAUSED`** = `2015`
- **`NOTIFICATION_APPLICATION_FOCUS_IN`** = `2016`
- **`NOTIFICATION_APPLICATION_FOCUS_OUT`** = `2017`
- **`NOTIFICATION_TEXT_SERVER_CHANGED`** = `2018`
- **`NOTIFICATION_APPLICATION_PIP_MODE_ENTERED`** = `2019`
- **`NOTIFICATION_APPLICATION_PIP_MODE_EXITED`** = `2020`
- **`NOTIFICATION_ACCESSIBILITY_UPDATE`** = `3000`
- **`NOTIFICATION_ACCESSIBILITY_INVALIDATE`** = `3001`
## 教程链接

- [Nodes and scenes](None)
- [All Demos](None)

