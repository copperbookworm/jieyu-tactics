# ScriptExtension

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ScriptExtension` → `Script` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/ScriptExtension.md`

## 方法

### `_can_instantiate() -> bool`
- 限定：qualifiers=virtual required const

### `_editor_can_reload_from_file() -> bool`
- 限定：qualifiers=virtual required

### `_get_base_script() -> Script`
- 限定：qualifiers=virtual required const

### `_get_class_icon_path() -> String`
- 限定：qualifiers=virtual const

### `_get_constants() -> Dictionary`
- 限定：qualifiers=virtual required const

### `_get_doc_class_name() -> StringName`
- 限定：qualifiers=virtual required const

### `_get_documentation() -> Dictionary[]`
- 限定：qualifiers=virtual required const

### `_get_global_name() -> StringName`
- 限定：qualifiers=virtual required const

### `_get_instance_base_type() -> StringName`
- 限定：qualifiers=virtual required const

### `_get_language() -> ScriptLanguage`
- 限定：qualifiers=virtual required const

### `_get_member_line(member: StringName) -> int`
- 限定：qualifiers=virtual required const

### `_get_members() -> StringName[]`
- 限定：qualifiers=virtual required const

### `_get_method_info(method: StringName) -> Dictionary`
- 限定：qualifiers=virtual required const

### `_get_property_default_value(property: StringName) -> Variant`
- 限定：qualifiers=virtual required const

### `_get_rpc_config() -> Variant`
- 限定：qualifiers=virtual required const

### `_get_script_method_argument_count(method: StringName) -> Variant`
- 限定：qualifiers=virtual const

Return the expected argument count for the given `method`, or `null` if it can't be determined (which will then fall back to the default behavior).

### `_get_script_method_list() -> Dictionary[]`
- 限定：qualifiers=virtual required const

### `_get_script_property_list() -> Dictionary[]`
- 限定：qualifiers=virtual required const

### `_get_script_signal_list() -> Dictionary[]`
- 限定：qualifiers=virtual required const

### `_get_source_code() -> String`
- 限定：qualifiers=virtual required const

### `_has_method(method: StringName) -> bool`
- 限定：qualifiers=virtual required const

### `_has_property_default_value(property: StringName) -> bool`
- 限定：qualifiers=virtual required const

### `_has_script_signal(signal: StringName) -> bool`
- 限定：qualifiers=virtual required const

### `_has_source_code() -> bool`
- 限定：qualifiers=virtual required const

### `_has_static_method(method: StringName) -> bool`
- 限定：qualifiers=virtual required const

### `_inherits_script(script: Script) -> bool`
- 限定：qualifiers=virtual required const

### `_instance_create(for_object: Object) -> void*`
- 限定：qualifiers=virtual required const

### `_instance_has(object: Object) -> bool`
- 限定：deprecated=This method is not called by the engine. · qualifiers=virtual const

### `_is_abstract() -> bool`
- 限定：qualifiers=virtual const

Returns `true` if the script is an abstract script. Abstract scripts cannot be instantiated directly, instead other scripts should inherit them. Abstract scripts will be either unselectable or hidden in the Create New Node dialog (unselectable if there are non-abstract classes inheriting it, otherwise hidden).

### `_is_placeholder_fallback_enabled() -> bool`
- 限定：qualifiers=virtual required const

### `_is_tool() -> bool`
- 限定：qualifiers=virtual required const

### `_is_valid() -> bool`
- 限定：qualifiers=virtual required const

### `_placeholder_erased(placeholder: void*) -> void`
- 限定：qualifiers=virtual

### `_placeholder_instance_create(for_object: Object) -> void*`
- 限定：qualifiers=virtual required const

### `_reload(keep_state: bool) -> int`
- 限定：qualifiers=virtual required

### `_set_source_code(code: String) -> void`
- 限定：qualifiers=virtual required

### `_update_exports() -> void`
- 限定：qualifiers=virtual required

