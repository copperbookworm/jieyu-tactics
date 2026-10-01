# Sprite2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Sprite2D` → `Node2D` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Sprite2D.md`

**摘要**：General-purpose sprite node.

## 描述

A node that displays a 2D texture. The texture displayed can be a region from a larger atlas texture, or a frame from a sprite sheet animation.

## 属性

- **`centered`** `bool` = `true`
  - 其它属性：getter=is_centered · setter=set_centered
- **`flip_h`** `bool` = `false`
  - 其它属性：getter=is_flipped_h · setter=set_flip_h
- **`flip_v`** `bool` = `false`
  - 其它属性：getter=is_flipped_v · setter=set_flip_v
- **`frame`** `int` = `0`
  - 其它属性：getter=get_frame · setter=set_frame
- **`frame_coords`** `Vector2i` = `Vector2i(0, 0)`
  - 其它属性：getter=get_frame_coords · setter=set_frame_coords
- **`hframes`** `int` = `1`
  - 其它属性：getter=get_hframes · setter=set_hframes
- **`offset`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_offset · setter=set_offset
- **`region_enabled`** `bool` = `false`
  - 其它属性：getter=is_region_enabled · setter=set_region_enabled
- **`region_filter_clip_enabled`** `bool` = `false`
  - 其它属性：getter=is_region_filter_clip_enabled · setter=set_region_filter_clip_enabled
- **`region_rect`** `Rect2` = `Rect2(0, 0, 0, 0)`
  - 其它属性：getter=get_region_rect · setter=set_region_rect
- **`texture`** `Texture2D`
  - 其它属性：getter=get_texture · setter=set_texture
- **`vframes`** `int` = `1`
  - 其它属性：getter=get_vframes · setter=set_vframes

## 方法

### `get_rect() -> Rect2`
- 限定：qualifiers=const

Returns a `Rect2` representing the Sprite2D's boundary in local coordinates.
				**Example:** Detect if the Sprite2D was clicked:
				`codeblocks`
				`gdscript`
				func _input(event):
					if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
						if get_rect().has_point(to_local(event.position)):
							print("A click!")
				
				`csharp`
				public override void _Input(InputEvent @event)
				{
					if (@event is InputEventMouseButton inputEventMouse)
					{
						if (inputEventMouse.Pressed && inputEventMouse.ButtonIndex == MouseButton.Left)
						{
							if (GetRect().HasPoint(ToLocal(inputEventMouse.Position)))
							{
								GD.Print("A click!");
							}
						}
					}
				}

### `is_pixel_opaque(pos: Vector2) -> bool`
- 限定：qualifiers=const

Returns `true` if the pixel at the given position is opaque, `false` otherwise. Also returns `false` if the given position is out of bounds or this sprite's `texture` is `null`. `pos` is in local coordinates.

## 信号

### `frame_changed()`

Emitted when the `frame` changes.

### `texture_changed()`

Emitted when the `texture` changes.

## 教程链接

- [Instancing Demo](None)

