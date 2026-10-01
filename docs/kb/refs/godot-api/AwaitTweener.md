# AwaitTweener

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AwaitTweener` → `Tweener` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AwaitTweener.md`

**摘要**：Awaits a specified signal.

## 描述

`AwaitTweener` is used to await a specified signal, allowing asynchronous steps in `Tween` animation. See `Tween.tween_await` for more usage information.
		The `Tweener.finished` signal is emitted when either the awaited signal is received, when timeout is reached, or when the target object is freed.

## 方法

### `set_timeout(timeout: float) -> AwaitTweener`

Sets the maximum time an `AwaitTweener` can wait for the signal. Can be used as a safeguard for signals that may never be emitted. If not specified, the tweener will wait indefinitely.

