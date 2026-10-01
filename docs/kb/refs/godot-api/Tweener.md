# Tweener

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Tweener` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Tweener.md`

**摘要**：Abstract class for all Tweeners used by `Tween`.

## 描述

Tweeners are objects that perform a specific animating task, e.g. interpolating a property or calling a method at a given time. A `Tweener` can't be created manually, you need to use a dedicated method from `Tween`.

## 信号

### `finished()`

Emitted when the `Tweener` has just finished its job or became invalid (e.g. due to a freed object).

