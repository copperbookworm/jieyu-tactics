# SubtweenTweener

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`SubtweenTweener` → `Tweener` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/SubtweenTweener.md`

**摘要**：Runs a `Tween` nested within another `Tween`.

## 描述

`SubtweenTweener` is used to execute a `Tween` as one step in a sequence defined by another `Tween`. See `Tween.tween_subtween` for more usage information.
		**Note:** `Tween.tween_subtween` is the only correct way to create `SubtweenTweener`. Any `SubtweenTweener` created manually will not function correctly.

## 方法

### `set_delay(delay: float) -> SubtweenTweener`

Sets the time in seconds after which the `SubtweenTweener` will start running the subtween. By default there's no delay.

