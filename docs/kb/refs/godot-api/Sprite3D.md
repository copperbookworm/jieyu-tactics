# Sprite3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Sprite3D` → `SpriteBase3D` → `GeometryInstance3D` → `VisualInstance3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Sprite3D.md`

**摘要**：2D sprite node in a 3D world.

## 描述

A node that displays a 2D texture in a 3D environment. The texture displayed can be a region from a larger atlas texture, or a frame from a sprite sheet animation. See also `SpriteBase3D` where properties such as the billboard mode are defined.

## 属性

- **`frame`** `int` = `0`
  - 其它属性：getter=get_frame · setter=set_frame
- **`frame_coords`** `Vector2i` = `Vector2i(0, 0)`
  - 其它属性：getter=get_frame_coords · setter=set_frame_coords
- **`hframes`** `int` = `1`
  - 其它属性：getter=get_hframes · setter=set_hframes
- **`region_enabled`** `bool` = `false`
  - 其它属性：getter=is_region_enabled · setter=set_region_enabled
- **`region_rect`** `Rect2` = `Rect2(0, 0, 0, 0)`
  - 其它属性：getter=get_region_rect · setter=set_region_rect
- **`texture`** `Texture2D`
  - 其它属性：getter=get_texture · setter=set_texture
- **`vframes`** `int` = `1`
  - 其它属性：getter=get_vframes · setter=set_vframes

## 信号

### `frame_changed()`

Emitted when the `frame` changes.

### `texture_changed()`

Emitted when the `texture` changes.

