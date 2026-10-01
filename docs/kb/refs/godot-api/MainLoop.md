# MainLoop

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`MainLoop` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/MainLoop.md`

**摘要**：Abstract base class for the game's main loop.

## 描述

`MainLoop` is the abstract base class for a Godot project's game loop. It is inherited by `SceneTree`, which is the default game loop implementation used in Godot projects, though it is also possible to write and use one's own `MainLoop` subclass instead of the scene tree.
		Upon the application start, a `MainLoop` implementation must be provided to the OS; otherwise, the application will exit. This happens automatically (and a `SceneTree` is created) unless a `MainLoop` `Script` is provided from the command line (with e.g. `godot -s my_loop.gd`) or the `ProjectSettings.application/run/main_loop_type` project setting is overwritten.
		Here is an example script implementing a simple `MainLoop`:
		`codeblocks`
		`gdscript`
		class_name CustomMainLoop
		extends MainLoop

		var time_elapsed = 0

		func _initialize():
			print("Initialized:")
			print("  Starting time: %s" % str(time_elapsed))

		func _process(delta):
			time_elapsed += delta
			# Return true to end the main loop.
			return Input.get_mouse_button_mask() != 0 || Input.is_key_pressed(KEY_ESCAPE)

		func _finalize():
			print("Finalized:")
			print("  End time: %s" % str(time_elapsed))
		
		`csharp`
		using Godot;

		`GlobalClass`
		public partial class CustomMainLoop : MainLoop
		{
			private double _timeElapsed = 0;

			public override void _Initialize()
			{
				GD.Print("Initialized:");
				GD.Print($"  Starting Time: {_timeElapsed}");
			}

			public override bool _Process(double delta)
			{
				_timeElapsed += delta;
				// Return true to end the main loop.
				return Input.GetMouseButtonMask() != 0 || Input.IsKeyPressed(Key.Escape);
			}

			private void _Finalize()
			{
				GD.Print("Finalized:");
				GD.Print($"  End Time: {_timeElapsed}");
			}
		}

## 方法

### `_finalize() -> void`
- 限定：qualifiers=virtual

Called before the program exits.

### `_initialize() -> void`
- 限定：qualifiers=virtual

Called once during initialization.

### `_physics_process(delta: float) -> bool`
- 限定：qualifiers=virtual

Called each physics tick. `delta` is the logical time between physics ticks in seconds and is equal to `Engine.time_scale` / `Engine.physics_ticks_per_second`. Equivalent to `Node._physics_process`.
				If implemented, the method must return a boolean value. `true` ends the main loop, while `false` lets it proceed to the next step.
				**Note:** `_physics_process` may be called up to `Engine.max_physics_steps_per_frame` times per (idle) frame. This step limit may be reached when the engine is suffering performance issues.
				**Note:** Accumulated `delta` may diverge from real world seconds.

### `_process(delta: float) -> bool`
- 限定：qualifiers=virtual

Called on each idle frame, prior to rendering, and after physics ticks have been processed. `delta` is the time between frames in seconds. Equivalent to `Node._process`.
				If implemented, the method must return a boolean value. `true` ends the main loop, while `false` lets it proceed to the next frame.
				**Note:** When the engine is struggling and the frame rate is lowered, `delta` will increase. When `delta` is increased, it's capped at a maximum of `Engine.time_scale` * `Engine.max_physics_steps_per_frame` / `Engine.physics_ticks_per_second`. As a result, accumulated `delta` may not represent real world time.
				**Note:** When `--fixed-fps` is enabled or the engine is running in Movie Maker mode (see `MovieWriter`), process `delta` will always be the same for every frame, regardless of how much time the frame took to render.
				**Note:** Frame delta may be post-processed by `OS.delta_smoothing` if this is enabled for the project.

## 信号

### `on_request_permissions_result(permission: String, granted: bool)`

Emitted when a user responds to a permission request.

## 常量

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
