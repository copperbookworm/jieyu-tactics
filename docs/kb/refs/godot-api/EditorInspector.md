# EditorInspector

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`EditorInspector` → `ScrollContainer` → `Container` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=editor
> 自动生成，勿手改。文件：`refs/godot-api/EditorInspector.md`

**摘要**：A control used to edit properties of an object.

## 描述

This is the control that implements property editing in the editor's Settings dialogs, the Inspector dock, etc. To get the `EditorInspector` used in the editor's Inspector dock, use `EditorInterface.get_inspector`.
		`EditorInspector` will show properties in the same order as the array returned by `Object.get_property_list`.
		If a property's name is path-like (i.e. if it contains forward slashes), `EditorInspector` will create nested sections for "directories" along the path. For example, if a property is named `highlighting/gdscript/node_path_color`, it will be shown as "Node Path Color" inside the "GDScript" section nested inside the "Highlighting" section.
		If a property has `PROPERTY_USAGE_GROUP` usage, it will group subsequent properties whose name starts with the property's hint string. The group ends when a property does not start with that hint string or when a new group starts. An empty group name effectively ends the current group. `EditorInspector` will create a top-level section for each group. For example, if a property with group usage is named `Collide With` and its hint string is `collide_with_`, a subsequent `collide_with_area` property will be shown as "Area" inside the "Collide With" section. There is also a special case: when the hint string contains the name of a property, that property is grouped too. This is mainly to help grouping properties like `font`, `font_color` and `font_size` (using the hint string `font_`).
		If a property has `PROPERTY_USAGE_SUBGROUP` usage, a subgroup will be created in the same way as a group, and a second-level section will be created for each subgroup.
		**Note:** Unlike sections created from path-like property names, `EditorInspector` won't capitalize the name for sections created from groups. So properties with group usage usually use capitalized names instead of snake_cased names.

## 属性

- **`draw_focus_border`** `bool` = `true`
  - 其它属性：getter=get_draw_focus_border · overrides=ScrollContainer · setter=set_draw_focus_border
- **`focus_mode`** `int` = `2` · 枚举 `Control.FocusMode`
  - 其它属性：getter=get_focus_mode · overrides=Control · setter=set_focus_mode
- **`follow_focus`** `bool` = `true`
  - 其它属性：getter=is_following_focus · overrides=ScrollContainer · setter=set_follow_focus
- **`horizontal_scroll_mode`** `int` = `0` · 枚举 `ScrollContainer.ScrollMode`
  - 其它属性：getter=get_horizontal_scroll_mode · overrides=ScrollContainer · setter=set_horizontal_scroll_mode

## 方法

### `collapse_all_folding() -> void`

Collapses all foldable sections.

### `create_default_inspector(filter_line_edit: LineEdit = null) -> EditorInspector`
- 限定：qualifiers=static

Creates an inspector with the same configuration as the one used in the editor's Inspector dock. When passing a `LineEdit` into `filter_line_edit`, the inspector will filter its properties based on `LineEdit.text` whenever `LineEdit.text_changed` is emitted.

### `edit(object: Object) -> void`

Shows the properties of the given `object` in this inspector for editing. To clear the inspector, call this method with `null`.
				**Note:** If you want to edit an object in the editor's main inspector, use the `edit_*` methods in `EditorInterface` instead.

### `expand_all_folding() -> void`

Expands all foldable sections.

### `expand_revertable() -> void`

Expands only the foldable sections that contain a revertable (i.e. non-default) property.

### `get_edited_object() -> Object`

Returns the object currently selected in this inspector.

### `get_selected_path() -> String`
- 限定：qualifiers=const

Gets the path of the currently selected property.

### `instantiate_property_editor(object: Object, type: int, path: String, hint: int, hint_text: String, usage: int, wide: bool = false) -> EditorProperty`
- 限定：qualifiers=static

Creates a property editor that can be used by plugin UI to edit the specified property of an `object`.

## 信号

### `edited_object_changed()`

Emitted when the object being edited by the inspector has changed.

### `object_id_selected(id: int)`

Emitted when the Edit button of an `Object` has been pressed in the inspector. This is mainly used in the remote scene tree Inspector.

### `property_deleted(property: String)`

Emitted when a property is removed from the inspector.

### `property_edited(property: String)`

Emitted when a property is edited in the inspector.

### `property_keyed(property: String, value: Variant, advance: bool)`

Emitted when a property is keyed in the inspector. Properties can be keyed by clicking the "key" icon next to a property when the Animation panel is toggled.

### `property_selected(property: String)`

Emitted when a property is selected in the inspector.

### `property_toggled(property: String, checked: bool)`

Emitted when a boolean property is toggled in the inspector.
				**Note:** This signal is never emitted if the internal `autoclear` property enabled. Since this property is always enabled in the editor inspector, this signal is never emitted by the editor itself.

### `resource_selected(resource: Resource, path: String)`

Emitted when a resource is selected in the inspector.

### `restart_requested()`

Emitted when a property that requires a restart to be applied is edited in the inspector. This is only used in the Project Settings and Editor Settings.

