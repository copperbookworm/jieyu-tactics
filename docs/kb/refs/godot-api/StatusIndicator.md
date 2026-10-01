# StatusIndicator

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`StatusIndicator` → `Node` → `Object`
> 附加属性：api_type=core · keywords=tray
> 自动生成，勿手改。文件：`refs/godot-api/StatusIndicator.md`

**摘要**：Application status indicator (aka notification area icon). 		**Note:** Status indicator is implemented on macOS and Windows.

## 属性

- **`icon`** `Texture2D`
  - 其它属性：getter=get_icon · setter=set_icon
- **`menu`** `NodePath` = `NodePath("")`
  - 其它属性：getter=get_menu · setter=set_menu
- **`tooltip`** `String` = `""`
  - 其它属性：getter=get_tooltip · setter=set_tooltip
- **`visible`** `bool` = `true`
  - 其它属性：getter=is_visible · setter=set_visible

## 方法

### `get_rect() -> Rect2`
- 限定：qualifiers=const

Returns the status indicator rectangle in screen coordinates. If this status indicator is not visible, returns an empty `Rect2`.

## 信号

### `pressed(mouse_button: int, mouse_position: Vector2i)`

Emitted when the status indicator is pressed.

