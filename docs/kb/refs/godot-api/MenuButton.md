# MenuButton

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`MenuButton` → `Button` → `BaseButton` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core · keywords=dropdown
> 自动生成，勿手改。文件：`refs/godot-api/MenuButton.md`

**摘要**：A button that brings up a `PopupMenu` when clicked.

## 描述

A button that brings up a `PopupMenu` when clicked. To create new items inside this `PopupMenu`, use `get_popup().add_item("My Item Name")`. You can also create them directly from Godot editor's inspector.
		See also `BaseButton` which contains common properties and methods associated with this node.

## 属性

- **`action_mode`** `int` = `0` · 枚举 `BaseButton.ActionMode`
  - 其它属性：getter=get_action_mode · overrides=BaseButton · setter=set_action_mode
- **`flat`** `bool` = `true`
  - 其它属性：getter=is_flat · overrides=Button · setter=set_flat
- **`focus_mode`** `int` = `3` · 枚举 `Control.FocusMode`
  - 其它属性：getter=get_focus_mode · overrides=Control · setter=set_focus_mode
- **`item_count`** `int` = `0`
  - 其它属性：getter=get_item_count · setter=set_item_count
- **`popup/item_{index}/checkable`** `int` = `0`
  - 其它属性：getter= · setter=
- **`popup/item_{index}/checked`** `bool` = `false`
  - 其它属性：getter= · setter=
- **`popup/item_{index}/disabled`** `bool` = `false`
  - 其它属性：getter= · setter=
- **`popup/item_{index}/icon`** `Texture2D`
  - 其它属性：getter= · setter=
- **`popup/item_{index}/id`** `int` = `0`
  - 其它属性：getter= · setter=
- **`popup/item_{index}/separator`** `bool` = `false`
  - 其它属性：getter= · setter=
- **`popup/item_{index}/text`** `String` = `""`
  - 其它属性：getter= · setter=
- **`switch_on_hover`** `bool` = `false`
  - 其它属性：getter=is_switch_on_hover · setter=set_switch_on_hover
- **`toggle_mode`** `bool` = `true`
  - 其它属性：getter=is_toggle_mode · overrides=BaseButton · setter=set_toggle_mode

## 方法

### `get_popup() -> PopupMenu`
- 限定：qualifiers=const

Returns the `PopupMenu` contained in this button.
				**Warning:** This is a required internal node, removing and freeing it may cause a crash. If you wish to hide it or any of its children, use their `Window.visible` property.

### `set_disable_shortcuts(disabled: bool) -> void`

If `true`, shortcuts are disabled and cannot be used to trigger the button.

### `show_popup() -> void`

Adjusts popup position and sizing for the `MenuButton`, then shows the `PopupMenu`. Prefer this over using `get_popup().popup()`.

## 信号

### `about_to_popup()`

Emitted when the `PopupMenu` of this MenuButton is about to show.

