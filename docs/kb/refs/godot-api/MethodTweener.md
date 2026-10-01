# MethodTweener

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`MethodTweener` → `Tweener` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/MethodTweener.md`

**摘要**：Interpolates an abstract value and supplies it to a method called over time.

## 描述

`MethodTweener` is similar to a combination of `CallbackTweener` and `PropertyTweener`. It calls a method providing an interpolated value as a parameter. See `Tween.tween_method` for more usage information.
		The tweener will finish automatically if the callback's target object is freed.
		**Note:** `Tween.tween_method` is the only correct way to create `MethodTweener`. Any `MethodTweener` created manually will not function correctly.

## 方法

### `set_delay(delay: float) -> MethodTweener`

Sets the time in seconds after which the `MethodTweener` will start interpolating. By default there's no delay.

### `set_ease(ease: int) -> MethodTweener`

Sets the type of used easing from `Tween.EaseType`. If not set, the default easing is used from the `Tween` that contains this Tweener.

### `set_trans(trans: int) -> MethodTweener`

Sets the type of used transition from `Tween.TransitionType`. If not set, the default transition is used from the `Tween` that contains this Tweener.

