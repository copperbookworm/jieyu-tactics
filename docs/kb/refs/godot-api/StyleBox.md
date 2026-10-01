# StyleBox

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`StyleBox` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/StyleBox.md`

**摘要**：Abstract base class for defining stylized boxes for UI elements.

## 描述

`StyleBox` is an abstract base class for drawing stylized boxes for UI elements. It is used for panels, buttons, `LineEdit` backgrounds, `Tree` backgrounds, etc. and also for testing a transparency mask for pointer signals. If mask test fails on a `StyleBox` assigned as mask to a control, clicks and motion signals will go through it to the one below.
		**Note:** For control nodes that have *Theme Properties*, the `focus` `StyleBox` is displayed over the `normal`, `hover` or `pressed` `StyleBox`. This makes the `focus` `StyleBox` more reusable across different nodes.

## 属性

- **`content_margin_bottom`** `float` = `-1.0`
  - 其它属性：getter=get_content_margin · setter=set_content_margin
- **`content_margin_left`** `float` = `-1.0`
  - 其它属性：getter=get_content_margin · setter=set_content_margin
- **`content_margin_right`** `float` = `-1.0`
  - 其它属性：getter=get_content_margin · setter=set_content_margin
- **`content_margin_top`** `float` = `-1.0`
  - 其它属性：getter=get_content_margin · setter=set_content_margin

## 方法

### `_draw(to_canvas_item: RID, rect: Rect2) -> void`
- 限定：qualifiers=virtual required const

### `_get_draw_rect(rect: Rect2) -> Rect2`
- 限定：qualifiers=virtual const

### `_get_minimum_size() -> Vector2`
- 限定：qualifiers=virtual const

Virtual method to be implemented by the user. Returns a custom minimum size that the stylebox must respect when drawing. By default `get_minimum_size` only takes content margins into account. This method can be overridden to add another size restriction. A combination of the default behavior and the output of this method will be used, to account for both sizes.

### `_test_mask(point: Vector2, rect: Rect2) -> bool`
- 限定：qualifiers=virtual const

### `draw(canvas_item: RID, rect: Rect2) -> void`
- 限定：qualifiers=const

Draws this stylebox using a canvas item identified by the given `RID`.
				The `RID` value can either be the result of `CanvasItem.get_canvas_item` called on an existing `CanvasItem`-derived node, or directly from creating a canvas item in the `RenderingServer` with `RenderingServer.canvas_item_create`.

### `get_content_margin(margin: int) -> float`
- 限定：qualifiers=const

Returns the default margin of the specified `Side`.

### `get_current_item_drawn() -> CanvasItem`
- 限定：qualifiers=const

Returns the `CanvasItem` that handles its `CanvasItem.NOTIFICATION_DRAW` or `CanvasItem._draw` callback at this moment.

### `get_margin(margin: int) -> float`
- 限定：qualifiers=const

Returns the content margin offset for the specified `Side`.
				Positive values reduce size inwards, unlike `Control`'s margin values.

### `get_minimum_size() -> Vector2`
- 限定：qualifiers=const

Returns the minimum size that this stylebox can be shrunk to.

### `get_offset() -> Vector2`
- 限定：qualifiers=const

Returns the "offset" of a stylebox. This helper function returns a value equivalent to `Vector2(style.get_margin(MARGIN_LEFT), style.get_margin(MARGIN_TOP))`.

### `set_content_margin(margin: int, offset: float) -> void`

Sets the default value of the specified `Side` to `offset` pixels.

### `set_content_margin_all(offset: float) -> void`

Sets the default margin to `offset` pixels for all sides.

### `test_mask(point: Vector2, rect: Rect2) -> bool`
- 限定：qualifiers=const

Test a position in a rectangle, return whether it passes the mask test.

