# ScriptLanguageExtension

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ScriptLanguageExtension` → `ScriptLanguage` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/ScriptLanguageExtension.md`

## 方法

### `_add_global_constant(name: StringName, value: Variant) -> void`
- 限定：qualifiers=virtual required

### `_add_named_global_constant(name: StringName, value: Variant) -> void`
- 限定：qualifiers=virtual required

### `_auto_indent_code(code: String, from_line: int, to_line: int) -> String`
- 限定：qualifiers=virtual required const

### `_can_inherit_from_file() -> bool`
- 限定：qualifiers=virtual required const

### `_can_make_function() -> bool`
- 限定：qualifiers=virtual required const

### `_complete_code(code: String, path: String, owner: Object) -> Dictionary`
- 限定：qualifiers=virtual required const

### `_create_script() -> Object`
- 限定：deprecated=This method is not called by the engine. · qualifiers=virtual const

### `_debug_get_current_stack_info() -> Dictionary[]`
- 限定：qualifiers=virtual required

### `_debug_get_error() -> String`
- 限定：qualifiers=virtual required const

### `_debug_get_globals(max_subitems: int, max_depth: int) -> Dictionary`
- 限定：qualifiers=virtual required

### `_debug_get_stack_level_count() -> int`
- 限定：qualifiers=virtual required const

### `_debug_get_stack_level_function(level: int) -> String`
- 限定：qualifiers=virtual required const

### `_debug_get_stack_level_instance(level: int) -> void*`
- 限定：qualifiers=virtual required

### `_debug_get_stack_level_line(level: int) -> int`
- 限定：qualifiers=virtual required const

### `_debug_get_stack_level_locals(level: int, max_subitems: int, max_depth: int) -> Dictionary`
- 限定：qualifiers=virtual required

### `_debug_get_stack_level_members(level: int, max_subitems: int, max_depth: int) -> Dictionary`
- 限定：qualifiers=virtual required

### `_debug_get_stack_level_source(level: int) -> String`
- 限定：qualifiers=virtual required const

Returns the source associated with a given debug stack position.

### `_debug_parse_stack_level_expression(level: int, expression: String, max_subitems: int, max_depth: int) -> String`
- 限定：qualifiers=virtual required

### `_find_function(function: String, code: String) -> int`
- 限定：qualifiers=virtual required const

Returns the line where the function is defined in the code, or `-1` if the function is not present.

### `_finish() -> void`
- 限定：qualifiers=virtual required

### `_frame() -> void`
- 限定：qualifiers=virtual required

### `_get_built_in_templates(object: StringName) -> Dictionary[]`
- 限定：qualifiers=virtual required const

### `_get_comment_delimiters() -> PackedStringArray`
- 限定：qualifiers=virtual required const

### `_get_doc_comment_delimiters() -> PackedStringArray`
- 限定：qualifiers=virtual const

### `_get_extension() -> String`
- 限定：qualifiers=virtual required const

### `_get_global_class_name(path: String) -> Dictionary`
- 限定：qualifiers=virtual required const

### `_get_name() -> String`
- 限定：qualifiers=virtual required const

### `_get_public_annotations() -> Dictionary[]`
- 限定：qualifiers=virtual required const

### `_get_public_constants() -> Dictionary`
- 限定：qualifiers=virtual required const

### `_get_public_functions() -> Dictionary[]`
- 限定：qualifiers=virtual required const

### `_get_recognized_extensions() -> PackedStringArray`
- 限定：qualifiers=virtual required const

### `_get_reserved_words() -> PackedStringArray`
- 限定：qualifiers=virtual required const

### `_get_string_delimiters() -> PackedStringArray`
- 限定：qualifiers=virtual required const

### `_get_type() -> String`
- 限定：qualifiers=virtual required const

### `_handles_global_class_type(type: String) -> bool`
- 限定：qualifiers=virtual required const

### `_has_named_classes() -> bool`
- 限定：deprecated=This method is not called by the engine. · qualifiers=virtual const

### `_init() -> void`
- 限定：qualifiers=virtual required

### `_is_control_flow_keyword(keyword: String) -> bool`
- 限定：qualifiers=virtual required const

### `_is_using_templates() -> bool`
- 限定：qualifiers=virtual required

### `_lookup_code(code: String, symbol: String, path: String, owner: Object) -> Dictionary`
- 限定：qualifiers=virtual required const

### `_make_function(class_name: String, function_name: String, function_args: PackedStringArray) -> String`
- 限定：qualifiers=virtual required const

### `_make_template(template: String, class_name: String, base_class_name: String) -> Script`
- 限定：qualifiers=virtual required const

### `_open_in_external_editor(script: Script, line: int, column: int) -> int`
- 限定：qualifiers=virtual required

### `_overrides_external_editor() -> bool`
- 限定：qualifiers=virtual required

### `_preferred_file_name_casing() -> int`
- 限定：qualifiers=virtual const

### `_profiling_get_accumulated_data(info_array: ScriptLanguageExtensionProfilingInfo*, info_max: int) -> int`
- 限定：qualifiers=virtual required

### `_profiling_get_frame_data(info_array: ScriptLanguageExtensionProfilingInfo*, info_max: int) -> int`
- 限定：qualifiers=virtual required

### `_profiling_set_save_native_calls(enable: bool) -> void`
- 限定：qualifiers=virtual required

### `_profiling_start() -> void`
- 限定：qualifiers=virtual required

### `_profiling_stop() -> void`
- 限定：qualifiers=virtual required

### `_reload_all_scripts() -> void`
- 限定：qualifiers=virtual required

### `_reload_scripts(scripts: Array, soft_reload: bool) -> void`
- 限定：qualifiers=virtual required

Reloads all `scripts` from disk and the specifics of how that happens is `ScriptLanguageExtension` specific.

### `_reload_tool_script(script: Script, soft_reload: bool) -> void`
- 限定：qualifiers=virtual required

Reloads the given `script` from disk and the specifics of how that happens is `ScriptLanguageExtension` specific.

### `_remove_named_global_constant(name: StringName) -> void`
- 限定：qualifiers=virtual required

### `_supports_builtin_mode() -> bool`
- 限定：qualifiers=virtual required const

### `_supports_documentation() -> bool`
- 限定：qualifiers=virtual required const

### `_thread_enter() -> void`
- 限定：qualifiers=virtual required

### `_thread_exit() -> void`
- 限定：qualifiers=virtual required

### `_validate(script: String, path: String, validate_functions: bool, validate_errors: bool, validate_warnings: bool, validate_safe_lines: bool) -> Dictionary`
- 限定：qualifiers=virtual required const

### `_validate_path(path: String) -> String`
- 限定：qualifiers=virtual required const

## 枚举

### `LookupResultType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `LOOKUP_RESULT_SCRIPT_LOCATION` |  |
| `1` | `LOOKUP_RESULT_CLASS` |  |
| `2` | `LOOKUP_RESULT_CLASS_CONSTANT` |  |
| `3` | `LOOKUP_RESULT_CLASS_PROPERTY` |  |
| `4` | `LOOKUP_RESULT_CLASS_METHOD` |  |
| `5` | `LOOKUP_RESULT_CLASS_SIGNAL` |  |
| `6` | `LOOKUP_RESULT_CLASS_ENUM` |  |
| `7` | `LOOKUP_RESULT_CLASS_TBD_GLOBALSCOPE` |  |
| `8` | `LOOKUP_RESULT_CLASS_ANNOTATION` |  |
| `9` | `LOOKUP_RESULT_LOCAL_CONSTANT` |  |
| `10` | `LOOKUP_RESULT_LOCAL_VARIABLE` |  |
| `11` | `LOOKUP_RESULT_MAX` |  |

### `CodeCompletionLocation`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `LOCATION_LOCAL` |  |
| `256` | `LOCATION_PARENT_MASK` |  |
| `512` | `LOCATION_OTHER_USER_CODE` |  |
| `1024` | `LOCATION_OTHER` |  |

### `CodeCompletionKind`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `CODE_COMPLETION_KIND_CLASS` |  |
| `1` | `CODE_COMPLETION_KIND_FUNCTION` |  |
| `2` | `CODE_COMPLETION_KIND_SIGNAL` |  |
| `3` | `CODE_COMPLETION_KIND_VARIABLE` |  |
| `4` | `CODE_COMPLETION_KIND_MEMBER` |  |
| `5` | `CODE_COMPLETION_KIND_ENUM` |  |
| `6` | `CODE_COMPLETION_KIND_CONSTANT` |  |
| `7` | `CODE_COMPLETION_KIND_NODE_PATH` |  |
| `8` | `CODE_COMPLETION_KIND_FILE_PATH` |  |
| `9` | `CODE_COMPLETION_KIND_PLAIN_TEXT` |  |
| `10` | `CODE_COMPLETION_KIND_KEYWORD` |  |
| `11` | `CODE_COMPLETION_KIND_MAX` |  |

