# TextureButton

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`TextureButton` → `BaseButton` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/TextureButton.md`

**摘要**：Texture-based button. Supports Pressed, Hover, Disabled and Focused states.

## 描述

`TextureButton` has the same functionality as `Button`, except it uses sprites instead of Godot's `Theme` resource. It is faster to create, but it doesn't support localization like more complex `Control`s.
		See also `BaseButton` which contains common properties and methods associated with this node.
		**Note:** Setting a texture for the "normal" state (`texture_normal`) is recommended. If `texture_normal` is not set, the `TextureButton` will still receive input events and be clickable, but the user will not be able to see it unless they activate another one of its states with a texture assigned (e.g., hover over it to show `texture_hover`).

## 属性

- **`flip_h`** `bool` = `false`
  - 其它属性：getter=is_flipped_h · setter=set_flip_h
- **`flip_v`** `bool` = `false`
  - 其它属性：getter=is_flipped_v · setter=set_flip_v
- **`ignore_texture_size`** `bool` = `false`
  - 其它属性：getter=get_ignore_texture_size · setter=set_ignore_texture_size
- **`stretch_mode`** `int` = `2` · 枚举 `TextureButton.StretchMode`
  - 其它属性：getter=get_stretch_mode · setter=set_stretch_mode
- **`texture_click_mask`** `BitMap`
  - 其它属性：getter=get_click_mask · setter=set_click_mask
- **`texture_disabled`** `Texture2D`
  - 其它属性：getter=get_texture_disabled · setter=set_texture_disabled
- **`texture_focused`** `Texture2D`
  - 其它属性：getter=get_texture_focused · setter=set_texture_focused
- **`texture_hover`** `Texture2D`
  - 其它属性：getter=get_texture_hover · setter=set_texture_hover
- **`texture_normal`** `Texture2D`
  - 其它属性：getter=get_texture_normal · setter=set_texture_normal
- **`texture_pressed`** `Texture2D`
  - 其它属性：getter=get_texture_pressed · setter=set_texture_pressed

## 枚举

### `StretchMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `STRETCH_SCALE` |  |
| `1` | `STRETCH_TILE` |  |
| `2` | `STRETCH_KEEP` |  |
| `3` | `STRETCH_KEEP_CENTERED` |  |
| `4` | `STRETCH_KEEP_ASPECT` |  |
| `5` | `STRETCH_KEEP_ASPECT_CENTERED` |  |
| `6` | `STRETCH_KEEP_ASPECT_COVERED` |  |

## 教程链接

- [3D Voxel Demo](None)

