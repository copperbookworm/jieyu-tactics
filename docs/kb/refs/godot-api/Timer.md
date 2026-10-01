# Timer

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Timer` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Timer.md`

**摘要**：A countdown timer.

## 描述

The `Timer` node is a countdown timer and is the simplest way to handle time-based logic in the engine. When a timer reaches the end of its `wait_time`, it will emit the `timeout` signal.
		After a timer enters the scene tree, it can be manually started with `start`. A timer node is also started automatically if `autostart` is `true`.
		Without requiring much code, a timer node can be added and configured in the editor. The `timeout` signal it emits can also be connected through the Signals dock in the editor:
		
```gdscript
		func _on_timer_timeout():
			print("Time to attack!")
		
```

		**Note:** To create a one-shot timer without instantiating a node, use `SceneTree.create_timer`.
		**Note:** Timers are affected by `Engine.time_scale` unless `ignore_time_scale` is `true`. The higher the time scale, the sooner timers will end. How often a timer processes may depend on the framerate or `Engine.physics_ticks_per_second`.

## 属性

- **`autostart`** `bool` = `false`
  - 其它属性：getter=has_autostart · setter=set_autostart
- **`ignore_time_scale`** `bool` = `false`
  - 其它属性：getter=is_ignoring_time_scale · setter=set_ignore_time_scale
- **`one_shot`** `bool` = `false`
  - 其它属性：getter=is_one_shot · setter=set_one_shot
- **`paused`** `bool`
  - 其它属性：getter=is_paused · setter=set_paused
- **`process_callback`** `int` = `1` · 枚举 `Timer.TimerProcessCallback`
  - 其它属性：getter=get_timer_process_callback · setter=set_timer_process_callback
- **`time_left`** `float`
  - 其它属性：getter=get_time_left · setter=
- **`wait_time`** `float` = `1.0`
  - 其它属性：getter=get_wait_time · setter=set_wait_time

## 方法

### `is_stopped() -> bool`
- 限定：qualifiers=const

Returns `true` if the timer is stopped or has not started.

### `start(time_sec: float = -1) -> void`

Starts the timer, or resets the timer if it was started already. Fails if the timer is not inside the scene tree. If `time_sec` is greater than `0`, this value is used for the `wait_time`.
				**Note:** This method does not resume a paused timer. See `paused`.

### `stop() -> void`

Stops the timer. See also `paused`. Unlike `start`, this can safely be called if the timer is not inside the scene tree.
				**Note:** Calling `stop` does not emit the `timeout` signal, as the timer is not considered to have timed out. If this is desired, use `$Timer.timeout.emit()` after calling `stop` to manually emit the signal.

## 信号

### `timeout()`

Emitted when the timer reaches the end.

## 枚举

### `TimerProcessCallback`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `TIMER_PROCESS_PHYSICS` |  |
| `1` | `TIMER_PROCESS_IDLE` |  |

## 教程链接

- [2D Dodge The Creeps Demo](None)

