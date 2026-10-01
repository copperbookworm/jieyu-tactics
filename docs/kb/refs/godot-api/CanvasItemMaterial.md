# CanvasItemMaterial

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`CanvasItemMaterial` → `Material` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/CanvasItemMaterial.md`

**摘要**：A material for `CanvasItem`s.

## 描述

`CanvasItemMaterial`s provide a means of modifying the textures associated with a CanvasItem. They specialize in describing blend and lighting behaviors for textures. Use a `ShaderMaterial` to more fully customize a material's interactions with a `CanvasItem`.

## 属性

- **`blend_mode`** `int` = `0` · 枚举 `CanvasItemMaterial.BlendMode`
  - 其它属性：getter=get_blend_mode · setter=set_blend_mode
- **`light_mode`** `int` = `0` · 枚举 `CanvasItemMaterial.LightMode`
  - 其它属性：getter=get_light_mode · setter=set_light_mode
- **`particles_anim_h_frames`** `int`
  - 其它属性：getter=get_particles_anim_h_frames · setter=set_particles_anim_h_frames
- **`particles_anim_loop`** `bool`
  - 其它属性：getter=get_particles_anim_loop · setter=set_particles_anim_loop
- **`particles_anim_v_frames`** `int`
  - 其它属性：getter=get_particles_anim_v_frames · setter=set_particles_anim_v_frames
- **`particles_animation`** `bool` = `false`
  - 其它属性：getter=get_particles_animation · setter=set_particles_animation

## 枚举

### `BlendMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `BLEND_MODE_MIX` |  |
| `1` | `BLEND_MODE_ADD` |  |
| `2` | `BLEND_MODE_SUB` |  |
| `3` | `BLEND_MODE_MUL` |  |
| `4` | `BLEND_MODE_PREMULT_ALPHA` |  |

### `LightMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `LIGHT_MODE_NORMAL` |  |
| `1` | `LIGHT_MODE_UNSHADED` |  |
| `2` | `LIGHT_MODE_LIGHT_ONLY` |  |

