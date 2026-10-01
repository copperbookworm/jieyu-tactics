# GridContainer

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`GridContainer` → `Container` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/GridContainer.md`

**摘要**：A container that arranges its child controls in a grid layout.

## 描述

`GridContainer` arranges its child controls in a grid layout. The number of columns is specified by the `columns` property, whereas the number of rows depends on how many are needed for the child controls. The number of rows and columns is preserved for every size of the container.
		**Note:** `GridContainer` only works with child nodes inheriting from `Control`. It won't rearrange child nodes inheriting from `Node2D`.

## 属性

- **`columns`** `int` = `1`
  - 其它属性：getter=get_columns · setter=set_columns

## 主题属性

### `h_separation`
- data_type=constant · default=4 · type=int

### `v_separation`
- data_type=constant · default=4 · type=int

## 教程链接

- [Using Containers](None)
- [Operating System Testing Demo](None)

