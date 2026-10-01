# EditorPlugin

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`EditorPlugin` → `Node` → `Object`
> 附加属性：api_type=editor
> 自动生成，勿手改。文件：`refs/godot-api/EditorPlugin.md`

**摘要**：Used by the editor to extend its functionality.

## 描述

Plugins are used by the editor to extend functionality. The most common types of plugins are those which edit a given node or resource type, import plugins and export plugins. See also `EditorScript` to add functions to the editor.
		**Note:** Some names in this class contain "left" or "right" (e.g. `DOCK_SLOT_LEFT_UL`). These APIs assume left-to-right layout, and would be backwards when using right-to-left layout. These names are kept for compatibility reasons.

## 方法

### `_apply_changes() -> void`
- 限定：qualifiers=virtual

This method is called when the editor is about to save the project, switch to another tab, etc. It asks the plugin to apply any pending state changes to ensure consistency.
				This is used, for example, in shader editors to let the plugin know that it must apply the shader code being written by the user to the object.

### `_build() -> bool`
- 限定：qualifiers=virtual

This method is called when the editor is about to run the project. The plugin can then perform required operations before the project runs.
				This method must return a boolean. If this method returns `false`, the project will not run. The run is aborted immediately, so this also prevents all other plugins' `_build` methods from running.

### `_clear() -> void`
- 限定：qualifiers=virtual

Clear all the state and reset the object being edited to zero. This ensures your plugin does not keep editing a currently existing node, or a node from the wrong scene.

### `_disable_plugin() -> void`
- 限定：qualifiers=virtual

Called by the engine when the user disables the `EditorPlugin` in the Plugin tab of the project settings window.

### `_edit(object: Object) -> void`
- 限定：qualifiers=virtual

This function is used for plugins that edit specific object types (nodes or resources). It requests the editor to edit the given object.
				`object` can be `null` if the plugin was editing an object, but there is no longer any selected object handled by this plugin. It can be used to cleanup editing state.

### `_enable_plugin() -> void`
- 限定：qualifiers=virtual

Called by the engine when the user enables the `EditorPlugin` in the Plugin tab of the project settings window.

### `_forward_3d_draw_over_viewport(viewport_control: Control) -> void`
- 限定：qualifiers=virtual

Called by the engine when the 3D editor's viewport is updated. `viewport_control` is an overlay on top of the viewport and it can be used for drawing. You can update the viewport manually by calling `update_overlays`.
				`codeblocks`
				`gdscript`
				func _forward_3d_draw_over_viewport(overlay):
					# Draw a circle at the cursor's position.
					overlay.draw_circle(overlay.get_local_mouse_position(), 64, Color.WHITE)

				func _forward_3d_gui_input(camera, event):
					if event is InputEventMouseMotion:
						# Redraw the viewport when the cursor is moved.
						update_overlays()
						return EditorPlugin.AFTER_GUI_INPUT_STOP
					return EditorPlugin.AFTER_GUI_INPUT_PASS
				
				`csharp`
				public override void _Forward3DDrawOverViewport(Control viewportControl)
				{
					// Draw a circle at the cursor's position.
					viewportControl.DrawCircle(viewportControl.GetLocalMousePosition(), 64, Colors.White);
				}

				public override EditorPlugin.AfterGuiInput _Forward3DGuiInput(Camera3D viewportCamera, InputEvent @event)
				{
					if (@event is InputEventMouseMotion)
					{
						// Redraw the viewport when the cursor is moved.
						UpdateOverlays();
						return EditorPlugin.AfterGuiInput.Stop;
					}
					return EditorPlugin.AfterGuiInput.Pass;
				}

### `_forward_3d_force_draw_over_viewport(viewport_control: Control) -> void`
- 限定：qualifiers=virtual

This method is the same as `_forward_3d_draw_over_viewport`, except it draws on top of everything. Useful when you need an extra layer that shows over anything else.
				You need to enable calling of this method by using `set_force_draw_over_forwarding_enabled`.

### `_forward_3d_gui_input(viewport_camera: Camera3D, event: InputEvent) -> int`
- 限定：qualifiers=virtual

Called when there is a root node in the current edited scene, `_handles` is implemented, and an `InputEvent` happens in the 3D viewport. The return value decides whether the `InputEvent` is consumed or forwarded to other `EditorPlugin`s. See `AfterGUIInput` for options.
				`codeblocks`
				`gdscript`
				# Prevents the InputEvent from reaching other Editor classes.
				func _forward_3d_gui_input(camera, event):
					return EditorPlugin.AFTER_GUI_INPUT_STOP
				
				`csharp`
				// Prevents the InputEvent from reaching other Editor classes.
				public override EditorPlugin.AfterGuiInput _Forward3DGuiInput(Camera3D camera, InputEvent @event)
				{
					return EditorPlugin.AfterGuiInput.Stop;
				}
				
				
				This method must return `AFTER_GUI_INPUT_PASS` in order to forward the `InputEvent` to other Editor classes.
				`codeblocks`
				`gdscript`
				# Consumes InputEventMouseMotion and forwards other InputEvent types.
				func _forward_3d_gui_input(camera, event):
					return EditorPlugin.AFTER_GUI_INPUT_STOP if event is InputEventMouseMotion else EditorPlugin.AFTER_GUI_INPUT_PASS
				
				`csharp`
				// Consumes InputEventMouseMotion and forwards other InputEvent types.
				public override EditorPlugin.AfterGuiInput _Forward3DGuiInput(Camera3D camera, InputEvent @event)
				{
					return @event is InputEventMouseMotion ? EditorPlugin.AfterGuiInput.Stop : EditorPlugin.AfterGuiInput.Pass;
				}

### `_forward_canvas_draw_over_viewport(viewport_control: Control) -> void`
- 限定：qualifiers=virtual

Called by the engine when the 2D editor's viewport is updated. `viewport_control` is an overlay on top of the viewport and it can be used for drawing. You can update the viewport manually by calling `update_overlays`.
				`codeblocks`
				`gdscript`
				func _forward_canvas_draw_over_viewport(overlay):
					# Draw a circle at the cursor's position.
					overlay.draw_circle(overlay.get_local_mouse_position(), 64, Color.WHITE)

				func _forward_canvas_gui_input(event):
					if event is InputEventMouseMotion:
						# Redraw the viewport when the cursor is moved.
						update_overlays()
						return true
					return false
				
				`csharp`
				public override void _ForwardCanvasDrawOverViewport(Control viewportControl)
				{
					// Draw a circle at the cursor's position.
					viewportControl.DrawCircle(viewportControl.GetLocalMousePosition(), 64, Colors.White);
				}

				public override bool _ForwardCanvasGuiInput(InputEvent @event)
				{
					if (@event is InputEventMouseMotion)
					{
						// Redraw the viewport when the cursor is moved.
						UpdateOverlays();
						return true;
					}
					return false;
				}

### `_forward_canvas_force_draw_over_viewport(viewport_control: Control) -> void`
- 限定：qualifiers=virtual

This method is the same as `_forward_canvas_draw_over_viewport`, except it draws on top of everything. Useful when you need an extra layer that shows over anything else.
				You need to enable calling of this method by using `set_force_draw_over_forwarding_enabled`.

### `_forward_canvas_gui_input(event: InputEvent) -> bool`
- 限定：qualifiers=virtual

Called when there is a root node in the current edited scene, `_handles` is implemented, and an `InputEvent` happens in the 2D viewport. If this method returns `true`, `event` is intercepted by this `EditorPlugin`, otherwise `event` is forwarded to other Editor classes.
				`codeblocks`
				`gdscript`
				# Prevents the InputEvent from reaching other Editor classes.
				func _forward_canvas_gui_input(event):
					return true
				
				`csharp`
				// Prevents the InputEvent from reaching other Editor classes.
				public override bool ForwardCanvasGuiInput(InputEvent @event)
				{
					return true;
				}
				
				
				This method must return `false` in order to forward the `InputEvent` to other Editor classes.
				`codeblocks`
				`gdscript`
				# Consumes InputEventMouseMotion and forwards other InputEvent types.
				func _forward_canvas_gui_input(event):
					if (event is InputEventMouseMotion):
						return true
					return false
				
				`csharp`
				// Consumes InputEventMouseMotion and forwards other InputEvent types.
				public override bool _ForwardCanvasGuiInput(InputEvent @event)
				{
					if (@event is InputEventMouseMotion)
					{
						return true;
					}
					return false;
				}

### `_get_breakpoints() -> PackedStringArray`
- 限定：qualifiers=virtual const

This is for editors that edit script-based objects. You can return a list of breakpoints in the format (`script:line`), for example: `res://path_to_script.gd:25`.

### `_get_plugin_icon() -> Texture2D`
- 限定：qualifiers=virtual const

Override this method in your plugin to return a `Texture2D` in order to give it an icon.
				For main screen plugins, this appears at the top of the screen, to the right of the "2D", "3D", "Script", "Game", and "Asset Store" buttons.
				Ideally, the plugin icon should be white with a transparent background and 16×16 pixels in size.
				`codeblocks`
				`gdscript`
				func _get_plugin_icon():
					# You can use a custom icon:
					return preload("res://addons/my_plugin/my_plugin_icon.svg")
					# Or use a built-in icon:
					return EditorInterface.get_editor_theme().get_icon("Node", "EditorIcons")
				
				`csharp`
				public override Texture2D _GetPluginIcon()
				{
					// You can use a custom icon:
					return ResourceLoader.Load<Texture2D>("res://addons/my_plugin/my_plugin_icon.svg");
					// Or use a built-in icon:
					return EditorInterface.Singleton.GetEditorTheme().GetIcon("Node", "EditorIcons");
				}

### `_get_plugin_name() -> String`
- 限定：qualifiers=virtual const

Override this method in your plugin to provide the name of the plugin when displayed in the Godot editor.
				For main screen plugins, this appears at the top of the screen, to the right of the "2D", "3D", "Script", "Game", and "Asset Store" buttons.

### `_get_state() -> Dictionary`
- 限定：qualifiers=virtual const

Override this method to provide a state data you want to be saved, like view position, grid settings, folding, etc. This is used when saving the scene (so state is kept when opening it again) and for switching tabs (so state can be restored when the tab returns). This data is automatically saved for each scene in an `editstate` file in the editor metadata folder. If you want to store global (scene-independent) editor data for your plugin, you can use `_get_window_layout` instead.
				Use `_set_state` to restore your saved state.
				**Note:** This method should not be used to save important settings that should persist with the project.
				**Note:** You must implement `_get_plugin_name` for the state to be stored and restored correctly.
				
```gdscript
				func _get_state():
					var state = { "zoom": zoom, "preferred_color": my_color }
					return state
				
```

### `_get_unsaved_status(for_scene: String) -> String`
- 限定：qualifiers=virtual const

Override this method to provide a custom message that lists unsaved changes. The editor will call this method when exiting or when closing a scene, and display the returned string in a confirmation dialog. Return empty string if the plugin has no unsaved changes.
				When closing a scene, `for_scene` is the path to the scene being closed. You can use it to handle built-in resources in that scene.
				If the user confirms saving, `_save_external_data` will be called, before closing the editor.
				
```gdscript
				func _get_unsaved_status(for_scene):
					if not unsaved:
						return ""

					if for_scene.is_empty():
						return "Save changes in MyCustomPlugin before closing?"
					else:
						return "Scene %s has changes from MyCustomPlugin. Save before closing?" % for_scene.get_file()

				func _save_external_data():
					unsaved = false
				
```

				If the plugin has no scene-specific changes, you can ignore the calls when closing scenes:
				
```gdscript
				func _get_unsaved_status(for_scene):
					if not for_scene.is_empty():
						return ""
				
```

### `_get_window_layout(configuration: ConfigFile) -> void`
- 限定：qualifiers=virtual

Override this method to provide the GUI layout of the plugin or any other data you want to be stored. This is used to save the project's editor layout when `queue_save_layout` is called or the editor layout was changed (for example changing the position of a dock). The data is stored in the `editor_layout.cfg` file in the editor metadata directory.
				Use `_set_window_layout` to restore your saved layout.
				
```gdscript
				func _get_window_layout(configuration):
					configuration.set_value("MyPlugin", "window_position", $Window.position)
					configuration.set_value("MyPlugin", "icon_color", $Icon.modulate)
				
```

### `_handles(object: Object) -> bool`
- 限定：qualifiers=virtual const

Implement this function if your plugin edits a specific type of object (Resource or Node). If you return `true`, then you will get the functions `_edit` and `_make_visible` called when the editor requests them. If you have declared the methods `_forward_canvas_gui_input` and `_forward_3d_gui_input` these will be called too.
				**Note:** Each plugin should handle only one type of objects at a time. If a plugin handles more types of objects and they are edited at the same time, it will result in errors.

### `_has_main_screen() -> bool`
- 限定：qualifiers=virtual const

Returns `true` if this is a main screen editor plugin (it goes in the workspace selector together with **2D**, **3D**, **Script**, **Game**, and **Asset Store**).
				When the plugin's workspace is selected, other main screen plugins will be hidden, but your plugin will not appear automatically. It needs to be added as a child of `EditorInterface.get_editor_main_screen` and made visible inside `_make_visible`.
				Use `_get_plugin_name` and `_get_plugin_icon` to customize the plugin button's appearance.
				
```gdscript
				var plugin_control

				func _enter_tree():
					plugin_control = preload("my_plugin_control.tscn").instantiate()
					EditorInterface.get_editor_main_screen().add_child(plugin_control)
					plugin_control.hide()

				func _has_main_screen():
					return true

				func _make_visible(visible):
					plugin_control.visible = visible

				func _get_plugin_name():
					return "My Super Cool Plugin 3000"

				func _get_plugin_icon():
					return EditorInterface.get_editor_theme().get_icon("Node", "EditorIcons")
				
```

### `_make_visible(visible: bool) -> void`
- 限定：qualifiers=virtual

This function will be called when the editor is requested to become visible. It is used for plugins that edit a specific object type.
				Remember that you have to manage the visibility of all your editor controls manually.

### `_run_scene(scene: String, args: PackedStringArray) -> PackedStringArray`
- 限定：qualifiers=virtual const

This function is called when an individual scene is about to be played in the editor. `args` is a list of command line arguments that will be passed to the new Godot instance, which will be replaced by the list returned by this function.
				
```gdscript
				func _run_scene(scene, args):
					args.append("--an-extra-argument")
					return args
				
```

				**Note:** Text that is printed in this method will not be visible in the editor's Output panel unless `EditorSettings.run/output/always_clear_output_on_play` is `false`.

### `_save_external_data() -> void`
- 限定：qualifiers=virtual

This method is called after the editor saves the project or when it's closed. It asks the plugin to save edited external scenes/resources.

### `_set_state(state: Dictionary) -> void`
- 限定：qualifiers=virtual

Restore the state saved by `_get_state`. This method is called when the current scene tab is changed in the editor.
				**Note:** Your plugin must implement `_get_plugin_name`, otherwise it will not be recognized and this method will not be called.
				
```gdscript
				func _set_state(data):
					zoom = data.get("zoom", 1.0)
					preferred_color = data.get("my_color", Color.WHITE)
				
```

### `_set_window_layout(configuration: ConfigFile) -> void`
- 限定：qualifiers=virtual

Restore the plugin GUI layout and data saved by `_get_window_layout`. This method is called for every plugin on editor startup. Use the provided `configuration` file to read your saved data.
				
```gdscript
				func _set_window_layout(configuration):
					$Window.position = configuration.get_value("MyPlugin", "window_position", Vector2())
					$Icon.modulate = configuration.get_value("MyPlugin", "icon_color", Color.WHITE)
				
```

### `add_autoload_singleton(name: String, path: String) -> void`

Adds a script at `path` to the Autoload list as `name`.

### `add_context_menu_plugin(slot: int, plugin: EditorContextMenuPlugin) -> void`

Adds a plugin to the context menu. `slot` is the context menu where the plugin will be added.
				**Note:** A plugin instance can belong only to a single context menu slot.

### `add_control_to_bottom_panel(control: Control, title: String, shortcut: Shortcut = null) -> Button`
- 限定：deprecated=Use [method add_dock] instead, with [member EditorDock.default_slot] set to [constant DOCK_SLOT_BOTTOM].

Adds a control to the bottom panel (together with Output, Debug, Animation, etc.). Returns a reference to a button that is outside the scene tree. It's up to you to hide/show the button when needed. When your plugin is deactivated, make sure to remove your custom control with `remove_control_from_bottom_panel` and free it with `Node.queue_free`.
				`shortcut` is a shortcut that, when activated, will toggle the bottom panel's visibility. The shortcut object is only set when this control is added to the bottom panel.
				**Note** See the default editor bottom panel shortcuts in the Editor Settings for inspiration. By convention, they all use Alt modifier.

### `add_control_to_container(container: int, control: Control) -> void`

Adds a custom control to a container in the editor UI.
				Please remember that you have to manage the visibility of your custom controls yourself (and likely hide it after adding it).
				When your plugin is deactivated, make sure to remove your custom control with `remove_control_from_container` and free it with `Node.queue_free`.

### `add_control_to_dock(slot: int, control: Control, shortcut: Shortcut = null) -> void`
- 限定：deprecated=Use [method add_dock] instead.

Adds the control to a specific dock slot.
				If the dock is repositioned and as long as the plugin is active, the editor will save the dock position on further sessions.
				When your plugin is deactivated, make sure to remove your custom control with `remove_control_from_docks` and free it with `Node.queue_free`.
				Optionally, you can specify a shortcut parameter. When pressed, this shortcut will open and focus the dock.

### `add_custom_type(type: String, base: String, script: Script, icon: Texture2D) -> void`

Adds a custom type, which will appear in the list of nodes or resources.
				When a given node or resource is selected, the base type will be instantiated (e.g. "Node3D", "Control", "Resource"), then the script will be loaded and set to this object.
				**Note:** The base type is the base engine class which this type's class hierarchy inherits, not any custom type parent classes.
				You can use the virtual method `_handles` to check if your custom object is being edited by checking the script or using the `is` keyword.
				During run-time, this will be a simple object with a script so this function does not need to be called then.
				**Note:** Custom types added this way are not true classes. They are just a helper to create a node with specific script.

### `add_debugger_plugin(script: EditorDebuggerPlugin) -> void`

Adds a `Script` as debugger plugin to the Debugger. The script must extend `EditorDebuggerPlugin`.

### `add_dock(dock: EditorDock) -> void`

Adds a new dock.
				When your plugin is deactivated, make sure to remove your custom dock with `remove_dock` and free it with `Node.queue_free`.

### `add_export_platform(platform: EditorExportPlatform) -> void`

Registers a new `EditorExportPlatform`. Export platforms provides functionality of exporting to the specific platform.

### `add_export_plugin(plugin: EditorExportPlugin) -> void`

Registers a new `EditorExportPlugin`. Export plugins are used to perform tasks when the project is being exported.
				See `add_inspector_plugin` for an example of how to register a plugin.

### `add_import_plugin(importer: EditorImportPlugin, first_priority: bool = false) -> void`

Registers a new `EditorImportPlugin`. Import plugins are used to import custom and unsupported assets as a custom `Resource` type.
				If `first_priority` is `true`, the new import plugin is inserted first in the list and takes precedence over pre-existing plugins.
				**Note:** If you want to import custom 3D asset formats use `add_scene_format_importer_plugin` instead.
				See `add_inspector_plugin` for an example of how to register a plugin.

### `add_inspector_plugin(plugin: EditorInspectorPlugin) -> void`

Registers a new `EditorInspectorPlugin`. Inspector plugins are used to extend `EditorInspector` and provide custom configuration tools for your object's properties.
				**Note:** Always use `remove_inspector_plugin` to remove the registered `EditorInspectorPlugin` when your `EditorPlugin` is disabled to prevent leaks and an unexpected behavior.
				`codeblocks`
				`gdscript`
				const MyInspectorPlugin = preload("res://addons/your_addon/path/to/your/script.gd")
				var inspector_plugin = MyInspectorPlugin.new()

				func _enter_tree():
					add_inspector_plugin(inspector_plugin)

				func _exit_tree():
					remove_inspector_plugin(inspector_plugin)

### `add_node_3d_gizmo_plugin(plugin: EditorNode3DGizmoPlugin) -> void`

Registers a new `EditorNode3DGizmoPlugin`. Gizmo plugins are used to add custom gizmos to the 3D preview viewport for a `Node3D`.
				See `add_inspector_plugin` for an example of how to register a plugin.

### `add_resource_conversion_plugin(plugin: EditorResourceConversionPlugin) -> void`

Registers a new `EditorResourceConversionPlugin`. Resource conversion plugins are used to add custom resource converters to the editor inspector.
				See `EditorResourceConversionPlugin` for an example of how to create a resource conversion plugin.

### `add_scene_format_importer_plugin(scene_format_importer: EditorSceneFormatImporter, first_priority: bool = false) -> void`

Registers a new `EditorSceneFormatImporter`. Scene importers are used to import custom 3D asset formats as scenes.
				If `first_priority` is `true`, the new import plugin is inserted first in the list and takes precedence over pre-existing plugins.

### `add_scene_post_import_plugin(scene_import_plugin: EditorScenePostImportPlugin, first_priority: bool = false) -> void`

Add an `EditorScenePostImportPlugin`. These plugins allow customizing the import process of 3D assets by adding new options to the import dialogs.
				If `first_priority` is `true`, the new import plugin is inserted first in the list and takes precedence over pre-existing plugins.

### `add_tool_menu_item(name: String, callable: Callable) -> void`

Adds a custom menu item to **Project > Tools** named `name`. When clicked, the provided `callable` will be called.

### `add_tool_submenu_item(name: String, submenu: PopupMenu) -> void`

Adds a custom `PopupMenu` submenu under **Project > Tools >** `name`. Use `remove_tool_menu_item` on plugin clean up to remove the menu.

### `add_translation_parser_plugin(parser: EditorTranslationParserPlugin) -> void`

Registers a custom translation parser plugin for extracting translatable strings from custom files.

### `add_undo_redo_inspector_hook_callback(callable: Callable) -> void`

Hooks a callback into the undo/redo action creation when a property is modified in the inspector. This allows, for example, to save other properties that may be lost when a given property is modified.
				The callback should have 4 arguments: `Object` `undo_redo`, `Object` `modified_object`, `String` `property` and `Variant` `new_value`. They are, respectively, the `UndoRedo` object used by the inspector, the currently modified object, the name of the modified property and the new value the property is about to take.

### `get_editor_interface() -> EditorInterface`
- 限定：deprecated=[EditorInterface] is a global singleton and can be accessed directly by its name.

Returns the `EditorInterface` singleton instance.

### `get_export_as_menu() -> PopupMenu`

Returns the `PopupMenu` under **Scene > Export As...**.

### `get_plugin_version() -> String`
- 限定：qualifiers=const

Provide the version of the plugin declared in the `plugin.cfg` config file.

### `get_script_create_dialog() -> ScriptCreateDialog`

Gets the Editor's dialog used for making scripts.
				**Note:** Users can configure it before use.
				**Warning:** Removing and freeing this node will render a part of the editor useless and may cause a crash.

### `get_undo_redo() -> EditorUndoRedoManager`

Gets the undo/redo object. Most actions in the editor can be undoable, so use this object to make sure this happens when it's worth it.

### `hide_bottom_panel() -> void`

Minimizes the bottom panel.

### `make_bottom_panel_item_visible(item: Control) -> void`

Makes a specific item in the bottom panel visible.

### `queue_save_layout() -> void`

Queue save the project's editor layout.

### `remove_autoload_singleton(name: String) -> void`

Removes an Autoload `name` from the list.

### `remove_context_menu_plugin(plugin: EditorContextMenuPlugin) -> void`

Removes the specified context menu plugin.

### `remove_control_from_bottom_panel(control: Control) -> void`
- 限定：deprecated=Use [method remove_dock] instead.

Removes the control from the bottom panel. You have to manually `Node.queue_free` the control.

### `remove_control_from_container(container: int, control: Control) -> void`

Removes the control from the specified container. You have to manually `Node.queue_free` the control.

### `remove_control_from_docks(control: Control) -> void`
- 限定：deprecated=Use [method remove_dock] instead.

Removes the control from the dock. You have to manually `Node.queue_free` the control.

### `remove_custom_type(type: String) -> void`

Removes a custom type added by `add_custom_type`.

### `remove_debugger_plugin(script: EditorDebuggerPlugin) -> void`

Removes the debugger plugin with given script from the Debugger.

### `remove_dock(dock: EditorDock) -> void`

Removes `dock` from the available docks. You should manually call `Node.queue_free` to free it.

### `remove_export_platform(platform: EditorExportPlatform) -> void`

Removes an export platform registered by `add_export_platform`.

### `remove_export_plugin(plugin: EditorExportPlugin) -> void`

Removes an export plugin registered by `add_export_plugin`.

### `remove_import_plugin(importer: EditorImportPlugin) -> void`

Removes an import plugin registered by `add_import_plugin`.

### `remove_inspector_plugin(plugin: EditorInspectorPlugin) -> void`

Removes an inspector plugin registered by `add_inspector_plugin`.

### `remove_node_3d_gizmo_plugin(plugin: EditorNode3DGizmoPlugin) -> void`

Removes a gizmo plugin registered by `add_node_3d_gizmo_plugin`.

### `remove_resource_conversion_plugin(plugin: EditorResourceConversionPlugin) -> void`

Removes a resource conversion plugin registered by `add_resource_conversion_plugin`.

### `remove_scene_format_importer_plugin(scene_format_importer: EditorSceneFormatImporter) -> void`

Removes a scene format importer registered by `add_scene_format_importer_plugin`.

### `remove_scene_post_import_plugin(scene_import_plugin: EditorScenePostImportPlugin) -> void`

Remove the `EditorScenePostImportPlugin`, added with `add_scene_post_import_plugin`.

### `remove_tool_menu_item(name: String) -> void`

Removes a menu `name` from **Project > Tools**.

### `remove_translation_parser_plugin(parser: EditorTranslationParserPlugin) -> void`

Removes a custom translation parser plugin registered by `add_translation_parser_plugin`.

### `remove_undo_redo_inspector_hook_callback(callable: Callable) -> void`

Removes a callback previously added by `add_undo_redo_inspector_hook_callback`.

### `set_dock_tab_icon(control: Control, icon: Texture2D) -> void`
- 限定：deprecated=Use [member EditorDock.dock_icon] instead.

Sets the tab icon for the given control in a dock slot. Setting to `null` removes the icon.

### `set_force_draw_over_forwarding_enabled() -> void`

Enables calling of `_forward_canvas_force_draw_over_viewport` for the 2D editor and `_forward_3d_force_draw_over_viewport` for the 3D editor when their viewports are updated. You need to call this method only once and it will work permanently for this plugin.

### `set_input_event_forwarding_always_enabled() -> void`

Use this method if you always want to receive inputs from 3D view screen inside `_forward_3d_gui_input`. It might be especially usable if your plugin will want to use raycast in the scene.

### `update_overlays() -> int`
- 限定：qualifiers=const

Updates the overlays of the 2D and 3D editor viewport. Causes methods `_forward_canvas_draw_over_viewport`, `_forward_canvas_force_draw_over_viewport`, `_forward_3d_draw_over_viewport` and `_forward_3d_force_draw_over_viewport` to be called.

## 信号

### `main_screen_changed(screen_name: String)`

Emitted when user changes the workspace (**2D**, **3D**, **Script**, **Game**, **Asset Store**). Also works with custom screens defined by plugins.

### `project_settings_changed()`

Emitted when any project setting has changed.

### `resource_saved(resource: Resource)`

Emitted when the given `resource` was saved on disc. See also `scene_saved`.

### `scene_changed(scene_root: Node)`

Emitted when the scene is changed in the editor. The argument will return the root node of the scene that has just become active. If this scene is new and empty, the argument will be `null`.

### `scene_closed(filepath: String)`

Emitted when user closes a scene. The argument is a file path to the closed scene.

### `scene_saved(filepath: String)`

Emitted when a scene was saved on disc. The argument is a file path to the saved scene. See also `resource_saved`.

## 枚举

### `CustomControlContainer`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `CONTAINER_TOOLBAR` |  |
| `1` | `CONTAINER_SPATIAL_EDITOR_MENU` |  |
| `2` | `CONTAINER_SPATIAL_EDITOR_SIDE_LEFT` |  |
| `3` | `CONTAINER_SPATIAL_EDITOR_SIDE_RIGHT` |  |
| `4` | `CONTAINER_SPATIAL_EDITOR_BOTTOM` |  |
| `5` | `CONTAINER_CANVAS_EDITOR_MENU` |  |
| `6` | `CONTAINER_CANVAS_EDITOR_SIDE_LEFT` |  |
| `7` | `CONTAINER_CANVAS_EDITOR_SIDE_RIGHT` |  |
| `8` | `CONTAINER_CANVAS_EDITOR_BOTTOM` |  |
| `9` | `CONTAINER_INSPECTOR_BOTTOM` |  |
| `10` | `CONTAINER_PROJECT_SETTING_TAB_LEFT` |  |
| `11` | `CONTAINER_PROJECT_SETTING_TAB_RIGHT` |  |

### `DockSlot`

| 值 | 名称 | 说明 |
|---|---|---|
| `-1` | `DOCK_SLOT_NONE` |  |
| `0` | `DOCK_SLOT_LEFT_UL` |  |
| `1` | `DOCK_SLOT_LEFT_BL` |  |
| `2` | `DOCK_SLOT_LEFT_UR` |  |
| `3` | `DOCK_SLOT_LEFT_BR` |  |
| `4` | `DOCK_SLOT_RIGHT_UL` |  |
| `5` | `DOCK_SLOT_RIGHT_BL` |  |
| `6` | `DOCK_SLOT_RIGHT_UR` |  |
| `7` | `DOCK_SLOT_RIGHT_BR` |  |
| `8` | `DOCK_SLOT_BOTTOM` |  |
| `9` | `DOCK_SLOT_MAX` |  |

### `AfterGUIInput`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `AFTER_GUI_INPUT_PASS` |  |
| `1` | `AFTER_GUI_INPUT_STOP` |  |
| `2` | `AFTER_GUI_INPUT_CUSTOM` |  |

## 教程链接

- [Editor plugins documentation index](None)

