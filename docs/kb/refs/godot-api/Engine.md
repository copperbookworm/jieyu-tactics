# Engine

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Engine` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Engine.md`

**摘要**：Provides access to engine properties.

## 描述

The `Engine` singleton allows you to query and modify the project's run-time parameters, such as frames per second, time scale, and others. It also stores information about the current build of Godot, such as the current version.

## 属性

- **`max_fps`** `int` = `0`
  - 其它属性：getter=get_max_fps · setter=set_max_fps
- **`max_physics_steps_per_frame`** `int` = `8`
  - 其它属性：getter=get_max_physics_steps_per_frame · setter=set_max_physics_steps_per_frame
- **`physics_jitter_fix`** `float` = `0.5`
  - 其它属性：getter=get_physics_jitter_fix · setter=set_physics_jitter_fix
- **`physics_ticks_per_second`** `int` = `60`
  - 其它属性：getter=get_physics_ticks_per_second · setter=set_physics_ticks_per_second
- **`print_error_messages`** `bool` = `true`
  - 其它属性：getter=is_printing_error_messages · setter=set_print_error_messages
- **`print_to_stdout`** `bool` = `true`
  - 其它属性：getter=is_printing_to_stdout · setter=set_print_to_stdout
- **`time_scale`** `float` = `1.0`
  - 其它属性：getter=get_time_scale · setter=set_time_scale

## 方法

### `capture_script_backtraces(include_variables: bool = false) -> ScriptBacktrace[]`
- 限定：qualifiers=const

Captures and returns backtraces from all registered script languages.
				By default, the returned `ScriptBacktrace` will only contain stack frames in editor builds and debug builds. To enable them for release builds as well, you need to enable `ProjectSettings.debug/settings/gdscript/always_track_call_stacks`.
				If `include_variables` is `true`, the backtrace will also include the names and values of any global variables (e.g. autoload singletons) at the point of the capture, as well as local variables and class member variables at each stack frame. This will however will only be respected when running the game with a debugger attached, like when running the game from the editor. To enable it for export builds as well, you need to enable `ProjectSettings.debug/settings/gdscript/always_track_local_variables`.
				**Warning:** When `include_variables` is `true`, any captured variables can potentially (e.g. with GDScript backtraces) be their actual values, including any object references. This means that storing such a `ScriptBacktrace` will prevent those objects from being deallocated, so it's generally recommended not to do so.

### `get_architecture_name() -> String`
- 限定：qualifiers=const

Returns the name of the CPU architecture the Godot binary was built for. Possible return values include `"x86_64"`, `"x86_32"`, `"arm64"`, `"arm32"`, `"rv64"`, `"ppc64"`, `"loongarch64"`, `"wasm64"`, and `"wasm32"`.
				To detect whether the current build is 64-bit, or the type of architecture, don't use the architecture name. Instead, use `OS.has_feature` to check for the `"64"` feature tag, or tags such as `"x86"` or `"arm"`. See the Feature Tags ($DOCS_URL/tutorials/export/feature_tags.html) documentation for more details.
				**Note:** This method does *not* return the name of the system's CPU architecture (like `OS.get_processor_name`). For example, when running an `x86_32` Godot binary on an `x86_64` system, the returned value will still be `"x86_32"`.

### `get_author_info() -> Dictionary`
- 限定：qualifiers=const

Returns the engine author information as a `Dictionary`, where each entry is an `Array` of strings with the names of notable contributors to the Godot Engine: `lead_developers`, `founders`, `project_managers`, and `developers`.

### `get_copyright_info() -> Dictionary[]`
- 限定：qualifiers=const

Returns an `Array` of dictionaries with copyright information for every component of Godot's source code.
				Every `Dictionary` contains a `name` identifier, and a `parts` array of dictionaries. It describes the component in detail with the following entries:
				- `files` - `Array` of file paths from the source code affected by this component;
				- `copyright` - `Array` of owners of this component;
				- `license` - The license applied to this component (such as "Expat (https://en.wikipedia.org/wiki/MIT_License#Ambiguity_and_variants)" or "CC-BY-4.0 (https://creativecommons.org/licenses/by/4.0/)").

### `get_donor_info() -> Dictionary`
- 限定：qualifiers=const

Returns a `Dictionary` of categorized donor names. Each entry is an `Array` of strings:
				{`platinum_sponsors`, `gold_sponsors`, `silver_sponsors`, `bronze_sponsors`, `mini_sponsors`, `gold_donors`, `silver_donors`, `bronze_donors`}

### `get_frames_drawn() -> int`

Returns the total number of frames drawn since the engine started.
				**Note:** On headless platforms, or if rendering is disabled with `--disable-render-loop` via command line, this method always returns `0`. See also `get_process_frames`.

### `get_frames_per_second() -> float`
- 限定：qualifiers=const

Returns the average frames rendered every second (FPS), also known as the framerate.

### `get_license_info() -> Dictionary`
- 限定：qualifiers=const

Returns a `Dictionary` of licenses used by Godot and included third party components. Each entry is a license name (such as "Expat (https://en.wikipedia.org/wiki/MIT_License#Ambiguity_and_variants)") and its associated text.

### `get_license_text() -> String`
- 限定：qualifiers=const

Returns the full Godot license text.

### `get_main_loop() -> MainLoop`
- 限定：qualifiers=const

Returns the instance of the `MainLoop`. This is usually the main `SceneTree` and is the same as `Node.get_tree`.
				**Note:** The type instantiated as the main loop can changed with `ProjectSettings.application/run/main_loop_type`.

### `get_physics_frames() -> int`
- 限定：qualifiers=const

Returns the total number of frames passed since the engine started. This number is increased every **physics frame**. See also `get_process_frames`.
				This method can be used to run expensive logic less often without relying on a `Timer`:
				`codeblocks`
				`gdscript`
				func _physics_process(_delta):
					if Engine.get_physics_frames() % 2 == 0:
						pass # Run expensive logic only once every 2 physics frames here.
				
				`csharp`
				public override void _PhysicsProcess(double delta)
				{
					base._PhysicsProcess(delta);

					if (Engine.GetPhysicsFrames() % 2 == 0)
					{
						// Run expensive logic only once every 2 physics frames here.
					}
				}

### `get_physics_interpolation_fraction() -> float`
- 限定：qualifiers=const

Returns the fraction through the current physics tick we are at the time of rendering the frame. This can be used to implement fixed timestep interpolation.

### `get_process_frames() -> int`
- 限定：qualifiers=const

Returns the total number of frames passed since the engine started. This number is increased every **process frame**, regardless of whether the render loop is enabled. See also `get_frames_drawn` and `get_physics_frames`.
				This method can be used to run expensive logic less often without relying on a `Timer`:
				`codeblocks`
				`gdscript`
				func _process(_delta):
					if Engine.get_process_frames() % 5 == 0:
						pass # Run expensive logic only once every 5 process (render) frames here.
				
				`csharp`
				public override void _Process(double delta)
				{
					base._Process(delta);

					if (Engine.GetProcessFrames() % 5 == 0)
					{
						// Run expensive logic only once every 5 process (render) frames here.
					}
				}

### `get_script_language(index: int) -> ScriptLanguage`
- 限定：qualifiers=const

Returns an instance of a `ScriptLanguage` with the given `index`.

### `get_script_language_count() -> int`

Returns the number of available script languages. Use with `get_script_language`.

### `get_singleton(name: StringName) -> Object`
- 限定：qualifiers=const

Returns the global singleton with the given `name`, or `null` if it does not exist. Often used for plugins. See also `has_singleton` and `get_singleton_list`.
				**Note:** Global singletons are not the same as autoloaded nodes, which are configurable in the project settings.

### `get_singleton_list() -> PackedStringArray`
- 限定：qualifiers=const

Returns a list of names of all available global singletons. See also `get_singleton`.

### `get_version_info() -> Dictionary`
- 限定：qualifiers=const

Returns the current engine version information as a `Dictionary` containing the following entries:
				- `major` - Major version number as an int;
				- `minor` - Minor version number as an int;
				- `patch` - Patch version number as an int;
				- `hex` - Full version encoded as a hexadecimal int with one byte (2 hex digits) per number (see example below);
				- `status` - Status (such as "beta", "rc1", "rc2", "stable", etc.) as a String;
				- `build` - Build name (e.g. "custom_build") as a String;
				- `hash` - Full Git commit hash as a String;
				- `timestamp` - Holds the Git commit date UNIX timestamp in seconds as an int, or `0` if unavailable;
				- `string` - `major`, `minor`, `patch`, `status`, and `build` in a single String.
				The `hex` value is encoded as follows, from left to right: one byte for the major, one byte for the minor, one byte for the patch version. For example, "3.1.12" would be `0x03010C`.
				**Note:** The `hex` value is still an `int` internally, and printing it will give you its decimal representation, which is not particularly meaningful. Use hexadecimal literals for quick version comparisons from code:
				`codeblocks`
				`gdscript`
				if Engine.get_version_info().hex >= 0x040100:
					pass # Do things specific to version 4.1 or later.
				else:
					pass # Do things specific to versions before 4.1.
				
				`csharp`
				if ((int)Engine.GetVersionInfo()["hex"] >= 0x040100)
				{
					// Do things specific to version 4.1 or later.
				}
				else
				{
					// Do things specific to versions before 4.1.
				}

### `get_write_movie_path() -> String`
- 限定：qualifiers=const

Returns the path to the `MovieWriter`'s output file, or an empty string if the engine wasn't started in Movie Maker mode. The default path can be changed in `ProjectSettings.editor/movie_writer/movie_file`.

### `has_singleton(name: StringName) -> bool`
- 限定：qualifiers=const

Returns `true` if a singleton with the given `name` exists in the global scope. See also `get_singleton`.
				`codeblocks`
				`gdscript`
				print(Engine.has_singleton("OS"))          # Prints true
				print(Engine.has_singleton("Engine"))      # Prints true
				print(Engine.has_singleton("AudioServer")) # Prints true
				print(Engine.has_singleton("Unknown"))     # Prints false
				
				`csharp`
				GD.Print(Engine.HasSingleton("OS"));          // Prints True
				GD.Print(Engine.HasSingleton("Engine"));      // Prints True
				GD.Print(Engine.HasSingleton("AudioServer")); // Prints True
				GD.Print(Engine.HasSingleton("Unknown"));     // Prints False
				
				
				**Note:** Global singletons are not the same as autoloaded nodes, which are configurable in the project settings.

### `is_editor_hint() -> bool`
- 限定：qualifiers=const

Returns `true` if the script is currently running inside the editor, otherwise returns `false`. This is useful for `@tool` scripts to conditionally draw editor helpers, or prevent accidentally running "game" code that would affect the scene state while in the editor:
				`codeblocks`
				`gdscript`
				if Engine.is_editor_hint():
					draw_gizmos()
				else:
					simulate_physics()
				
				`csharp`
				if (Engine.IsEditorHint())
					DrawGizmos();
				else
					SimulatePhysics();
				
				
				See Running code in the editor ($DOCS_URL/tutorials/plugins/running_code_in_the_editor.html) in the documentation for more information.
				**Note:** To detect whether the script is running on an editor *build* (such as when pressing F5), use `OS.has_feature` with the `"editor"` argument instead. `OS.has_feature("editor")` evaluate to `true` both when the script is running in the editor and when running the project from the editor, but returns `false` when run from an exported project.

### `is_embedded_in_editor() -> bool`
- 限定：qualifiers=const

Returns `true` if the engine is running embedded in the editor. This is useful to prevent attempting to update window mode or window flags that are not supported when running the project embedded in the editor.

### `is_in_physics_frame() -> bool`
- 限定：qualifiers=const

Returns `true` if the engine is inside the fixed physics process step of the main loop.
				
```gdscript
				func _enter_tree():
					# Depending on when the node is added to the tree,
					# prints either "true" or "false".
					print(Engine.is_in_physics_frame())

				func _process(delta):
					print(Engine.is_in_physics_frame()) # Prints false

				func _physics_process(delta):
					print(Engine.is_in_physics_frame()) # Prints true
				
```

### `register_script_language(language: ScriptLanguage) -> int`

Registers a `ScriptLanguage` instance to be available with `ScriptServer`.
				Returns:
				- `OK` on success;
				- `ERR_UNAVAILABLE` if `ScriptServer` has reached the limit and cannot register any new language;
				- `ERR_ALREADY_EXISTS` if `ScriptServer` already contains a language with similar extension/name/type.

### `register_singleton(name: StringName, instance: Object) -> void`

Registers the given `Object` `instance` as a singleton, available globally under `name`. Useful for plugins.

### `unregister_script_language(language: ScriptLanguage) -> int`

Unregisters the `ScriptLanguage` instance from `ScriptServer`.
				Returns:
				- `OK` on success;
				- `ERR_DOES_NOT_EXIST` if the language is not registered in `ScriptServer`.

### `unregister_singleton(name: StringName) -> void`

Removes the singleton registered under `name`. The singleton object is *not* freed. Only works with user-defined singletons registered with `register_singleton`.

