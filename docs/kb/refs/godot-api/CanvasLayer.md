# CanvasLayer

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`CanvasLayer` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/CanvasLayer.md`

**摘要**：A node used for independent rendering of objects within a 2D scene.

## 描述

`CanvasItem`-derived nodes that are direct or indirect children of a `CanvasLayer` will be drawn in that layer. The layer is a numeric index that defines the draw order. The default 2D scene renders with index `0`, so a `CanvasLayer` with index `-1` will be drawn below, and a `CanvasLayer` with index `1` will be drawn above. This order will hold regardless of the `CanvasItem.z_index` of the nodes within each layer.
		`CanvasLayer`s can be hidden and they can also optionally follow the viewport. This makes them useful for HUDs like health bar overlays (on layers `1` and higher) or backgrounds (on layers `-1` and lower).
		**Note:** Embedded `Window`s are placed on layer `1024`. `CanvasItem`s on layers `1025` and higher appear in front of embedded windows.
		**Note:** Each `CanvasLayer` is drawn on one specific `Viewport` and cannot be shared between multiple `Viewport`s, see `custom_viewport`. When using multiple `Viewport`s, for example in a split-screen game, you need to create an individual `CanvasLayer` for each `Viewport` you want it to be drawn on.

## 属性

- **`custom_viewport`** `Node`
  - 其它属性：getter=get_custom_viewport · setter=set_custom_viewport
- **`follow_viewport_enabled`** `bool` = `false`
  - 其它属性：getter=is_following_viewport · setter=set_follow_viewport
- **`follow_viewport_scale`** `float` = `1.0`
  - 其它属性：getter=get_follow_viewport_scale · setter=set_follow_viewport_scale
- **`layer`** `int` = `1`
  - 其它属性：getter=get_layer · setter=set_layer
- **`offset`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_offset · setter=set_offset
- **`rotation`** `float` = `0.0`
  - 其它属性：getter=get_rotation · setter=set_rotation
- **`scale`** `Vector2` = `Vector2(1, 1)`
  - 其它属性：getter=get_scale · setter=set_scale
- **`transform`** `Transform2D` = `Transform2D(1, 0, 0, 1, 0, 0)`
  - 其它属性：getter=get_transform · setter=set_transform
- **`visible`** `bool` = `true`
  - 其它属性：getter=is_visible · setter=set_visible

## 方法

### `get_canvas() -> RID`
- 限定：qualifiers=const

Returns the RID of the canvas used by this layer.

### `get_final_transform() -> Transform2D`
- 限定：qualifiers=const

Returns the transform from the `CanvasLayer`s coordinate system to the `Viewport`s coordinate system.

### `hide() -> void`

Hides any `CanvasItem` under this `CanvasLayer`. This is equivalent to setting `visible` to `false`.

### `show() -> void`

Shows any `CanvasItem` under this `CanvasLayer`. This is equivalent to setting `visible` to `true`.

## 信号

### `visibility_changed()`

Emitted when visibility of the layer is changed. See `visible`.

## 教程链接

- [Viewport and canvas transforms](None)
- [Canvas layers](None)
- [2D Dodge The Creeps Demo](None)

