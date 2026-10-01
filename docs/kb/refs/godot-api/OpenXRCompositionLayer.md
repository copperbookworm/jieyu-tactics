# OpenXRCompositionLayer

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OpenXRCompositionLayer` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/OpenXRCompositionLayer.md`

**摘要**：The parent class of all OpenXR composition layer nodes.

## 描述

Composition layers allow 2D viewports to be displayed inside of the headset by the XR compositor through special projections that retain their quality. This allows for rendering clear text while keeping the layer at a native resolution.
		**Note:** If the OpenXR runtime doesn't support the given composition layer type, a fallback mesh can be generated with a `ViewportTexture`, in order to emulate the composition layer.

## 属性

- **`alpha_blend`** `bool` = `false`
  - 其它属性：getter=get_alpha_blend · setter=set_alpha_blend
- **`android_surface_size`** `Vector2i` = `Vector2i(1024, 1024)`
  - 其它属性：getter=get_android_surface_size · setter=set_android_surface_size
- **`enable_hole_punch`** `bool` = `false`
  - 其它属性：getter=get_enable_hole_punch · setter=set_enable_hole_punch
- **`eye_visibility`** `int` = `0` · 枚举 `OpenXRCompositionLayer.EyeVisibility`
  - 其它属性：getter=get_eye_visibility · setter=set_eye_visibility
- **`layer_viewport`** `SubViewport`
  - 其它属性：getter=get_layer_viewport · setter=set_layer_viewport
- **`protected_content`** `bool` = `false`
  - 其它属性：getter=is_protected_content · setter=set_protected_content
- **`sort_order`** `int` = `1`
  - 其它属性：getter=get_sort_order · setter=set_sort_order
- **`swapchain_state_alpha_swizzle`** `int` = `3` · 枚举 `OpenXRCompositionLayer.Swizzle`
  - 其它属性：getter=get_alpha_swizzle · setter=set_alpha_swizzle
- **`swapchain_state_blue_swizzle`** `int` = `2` · 枚举 `OpenXRCompositionLayer.Swizzle`
  - 其它属性：getter=get_blue_swizzle · setter=set_blue_swizzle
- **`swapchain_state_border_color`** `Color` = `Color(0, 0, 0, 0)`
  - 其它属性：getter=get_border_color · setter=set_border_color
- **`swapchain_state_green_swizzle`** `int` = `1` · 枚举 `OpenXRCompositionLayer.Swizzle`
  - 其它属性：getter=get_green_swizzle · setter=set_green_swizzle
- **`swapchain_state_horizontal_wrap`** `int` = `0` · 枚举 `OpenXRCompositionLayer.Wrap`
  - 其它属性：getter=get_horizontal_wrap · setter=set_horizontal_wrap
- **`swapchain_state_mag_filter`** `int` = `1` · 枚举 `OpenXRCompositionLayer.Filter`
  - 其它属性：getter=get_mag_filter · setter=set_mag_filter
- **`swapchain_state_max_anisotropy`** `float` = `1.0`
  - 其它属性：getter=get_max_anisotropy · setter=set_max_anisotropy
- **`swapchain_state_min_filter`** `int` = `1` · 枚举 `OpenXRCompositionLayer.Filter`
  - 其它属性：getter=get_min_filter · setter=set_min_filter
- **`swapchain_state_mipmap_mode`** `int` = `2` · 枚举 `OpenXRCompositionLayer.MipmapMode`
  - 其它属性：getter=get_mipmap_mode · setter=set_mipmap_mode
- **`swapchain_state_red_swizzle`** `int` = `0` · 枚举 `OpenXRCompositionLayer.Swizzle`
  - 其它属性：getter=get_red_swizzle · setter=set_red_swizzle
- **`swapchain_state_vertical_wrap`** `int` = `0` · 枚举 `OpenXRCompositionLayer.Wrap`
  - 其它属性：getter=get_vertical_wrap · setter=set_vertical_wrap
- **`use_android_surface`** `bool` = `false`
  - 其它属性：getter=get_use_android_surface · setter=set_use_android_surface

## 方法

### `get_android_surface() -> JavaObject`

Returns a `JavaObject` representing an `android.view.Surface` if `use_android_surface` is enabled and OpenXR has created the surface. Otherwise, this will return `null`.
				**Note:** The surface can only be created during an active OpenXR session. So, if `use_android_surface` is enabled outside of an OpenXR session, it won't be created until a new session fully starts.

### `intersects_ray(origin: Vector3, direction: Vector3) -> Vector2`
- 限定：qualifiers=const

Returns UV coordinates where the given ray intersects with the composition layer. `origin` and `direction` must be in global space.
				Returns `Vector2(-1.0, -1.0)` if the ray doesn't intersect.

### `is_natively_supported() -> bool`
- 限定：qualifiers=const

Returns `true` if the OpenXR runtime natively supports this composition layer type.
				**Note:** This will only return an accurate result after the OpenXR session has started.

## 枚举

### `Filter`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `FILTER_NEAREST` |  |
| `1` | `FILTER_LINEAR` |  |
| `2` | `FILTER_CUBIC` |  |

### `MipmapMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `MIPMAP_MODE_DISABLED` |  |
| `1` | `MIPMAP_MODE_NEAREST` |  |
| `2` | `MIPMAP_MODE_LINEAR` |  |

### `Wrap`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `WRAP_CLAMP_TO_BORDER` |  |
| `1` | `WRAP_CLAMP_TO_EDGE` |  |
| `2` | `WRAP_REPEAT` |  |
| `3` | `WRAP_MIRRORED_REPEAT` |  |
| `4` | `WRAP_MIRROR_CLAMP_TO_EDGE` |  |

### `Swizzle`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SWIZZLE_RED` |  |
| `1` | `SWIZZLE_GREEN` |  |
| `2` | `SWIZZLE_BLUE` |  |
| `3` | `SWIZZLE_ALPHA` |  |
| `4` | `SWIZZLE_ZERO` |  |
| `5` | `SWIZZLE_ONE` |  |

### `EyeVisibility`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `EYE_VISIBILITY_BOTH` |  |
| `1` | `EYE_VISIBILITY_LEFT` |  |
| `2` | `EYE_VISIBILITY_RIGHT` |  |

