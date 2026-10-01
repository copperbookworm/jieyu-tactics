# SceneTreeTimer

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`SceneTreeTimer` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/SceneTreeTimer.md`

**摘要**：One-shot timer.

## 描述

A one-shot timer managed by the scene tree, which emits `timeout` on completion. See also `SceneTree.create_timer`.
		As opposed to `Timer`, it does not require the instantiation of a node. Commonly used to create a one-shot delay timer as in the following example:
		`codeblocks`
		`gdscript`
		func some_function():
			print("Timer started.")
			await get_tree().create_timer(1.0).timeout
			print("Timer ended.")
		
		`csharp`
		public async Task SomeFunction()
		{
			GD.Print("Timer started.");
			await ToSignal(GetTree().CreateTimer(1.0f), SceneTreeTimer.SignalName.Timeout);
			GD.Print("Timer ended.");
		}
		
		
		The timer will be dereferenced after its time elapses. To preserve the timer, you can keep a reference to it. See `RefCounted`.
		**Note:** The timer is processed after all of the nodes in the current frame, i.e. node's `Node._process` method would be called before the timer (or `Node._physics_process` if `process_in_physics` in `SceneTree.create_timer` has been set to `true`).

## 属性

- **`time_left`** `float`
  - 其它属性：getter=get_time_left · setter=set_time_left

## 信号

### `timeout()`

Emitted when the timer reaches 0.

