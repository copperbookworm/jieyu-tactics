# CallbackTweener

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`CallbackTweener` → `Tweener` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/CallbackTweener.md`

**摘要**：Calls the specified method after optional delay.

## 描述

`CallbackTweener` is used to call a method in a tweening sequence. See `Tween.tween_callback` for more usage information.
		The tweener will finish automatically if the callback's target object is freed.
		**Note:** `Tween.tween_callback` is the only correct way to create `CallbackTweener`. Any `CallbackTweener` created manually will not function correctly.

## 方法

### `set_delay(delay: float) -> CallbackTweener`

Makes the callback call delayed by given time in seconds.
				**Example:** Call `Node.queue_free` after 2 seconds:
				
```gdscript
				var tween = get_tree().create_tween()
				tween.tween_callback(queue_free).set_delay(2)
				
```

