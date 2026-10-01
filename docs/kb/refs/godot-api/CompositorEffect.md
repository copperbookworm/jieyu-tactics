# CompositorEffect

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`CompositorEffect` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core · experimental=The implementation may change as more of the rendering internals are exposed over time.
> 自动生成，勿手改。文件：`refs/godot-api/CompositorEffect.md`

**摘要**：This resource allows for creating a custom rendering effect.

## 描述

This resource defines a custom rendering effect that can be applied to `Viewport`s through the viewports' `Environment`. You can implement a callback that is called during rendering at a given stage of the rendering pipeline and allows you to insert additional passes. Note that this callback happens on the rendering thread. CompositorEffect is an abstract base class and must be extended to implement specific rendering logic.

## 属性

- **`access_resolved_color`** `bool`
  - 其它属性：getter=get_access_resolved_color · setter=set_access_resolved_color
- **`access_resolved_depth`** `bool`
  - 其它属性：getter=get_access_resolved_depth · setter=set_access_resolved_depth
- **`effect_callback_type`** `int` · 枚举 `CompositorEffect.EffectCallbackType`
  - 其它属性：getter=get_effect_callback_type · setter=set_effect_callback_type
- **`enabled`** `bool`
  - 其它属性：getter=get_enabled · setter=set_enabled
- **`needs_motion_vectors`** `bool`
  - 其它属性：getter=get_needs_motion_vectors · setter=set_needs_motion_vectors
- **`needs_normal_roughness`** `bool`
  - 其它属性：getter=get_needs_normal_roughness · setter=set_needs_normal_roughness
- **`needs_separate_specular`** `bool`
  - 其它属性：getter=get_needs_separate_specular · setter=set_needs_separate_specular

## 方法

### `_render_callback(effect_callback_type: int, render_data: RenderData) -> void`
- 限定：qualifiers=virtual

Implement this function with your custom rendering code. `effect_callback_type` should always match the effect callback type you've specified in `effect_callback_type`. `render_data` provides access to the rendering state, it is only valid during rendering and should not be stored.

## 枚举

### `EffectCallbackType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `EFFECT_CALLBACK_TYPE_PRE_OPAQUE` |  |
| `1` | `EFFECT_CALLBACK_TYPE_POST_OPAQUE` |  |
| `2` | `EFFECT_CALLBACK_TYPE_POST_SKY` |  |
| `3` | `EFFECT_CALLBACK_TYPE_PRE_TRANSPARENT` |  |
| `4` | `EFFECT_CALLBACK_TYPE_POST_TRANSPARENT` |  |
| `5` | `EFFECT_CALLBACK_TYPE_MAX` |  |

## 教程链接

- [The Compositor](None)

