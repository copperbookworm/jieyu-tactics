# Translation

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Translation` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Translation.md`

**摘要**：A language translation that maps a collection of strings to their individual translations.

## 描述

`Translation` maps a collection of strings to their individual translations, and also provides convenience methods for pluralization.
		A `Translation` consists of messages. A message is identified by its context and untranslated string. Unlike gettext (https://www.gnu.org/software/gettext/), using an empty context string in Godot means not using any context.

## 属性

- **`locale`** `String` = `"en"`
  - 其它属性：getter=get_locale · setter=set_locale
- **`plural_rules_override`** `String` = `""`
  - 其它属性：getter=get_plural_rules_override · setter=set_plural_rules_override

## 方法

### `_get_message(src_message: StringName, context: StringName) -> StringName`
- 限定：qualifiers=virtual const

Virtual method to override `get_message`.

### `_get_plural_message(src_message: StringName, src_plural_message: StringName, n: int, context: StringName) -> StringName`
- 限定：qualifiers=virtual const

Virtual method to override `get_plural_message`.

### `add_message(src_message: StringName, xlated_message: StringName, context: StringName = &"") -> void`

Adds a message if nonexistent, followed by its translation.
				An additional context could be used to specify the translation context or differentiate polysemic words.

### `add_plural_message(src_message: StringName, xlated_messages: PackedStringArray, context: StringName = &"") -> void`

Adds a message involving plural translation if nonexistent, followed by its translation.
				An additional context could be used to specify the translation context or differentiate polysemic words.

### `erase_message(src_message: StringName, context: StringName = &"") -> void`

Erases a message.

### `get_message(src_message: StringName, context: StringName = &"") -> StringName`
- 限定：qualifiers=const

Returns a message's translation.

### `get_message_count() -> int`
- 限定：qualifiers=const

Returns the number of existing messages.

### `get_message_list() -> PackedStringArray`
- 限定：qualifiers=const

Returns the keys of all messages, that is, the context and untranslated strings of each message.
				**Note:** If a message does not use a context, the corresponding element is the untranslated string. Otherwise, the corresponding element is the context and untranslated string separated by the EOT character (`U+0004`). This is done for compatibility purposes.
				
```gdscript
				for key in translation.get_message_list():
					var p = key.find("\u0004")
					if p == -1:
						var untranslated = key
						print("Message %s" % untranslated)
					else:
						var context = key.substr(0, p)
						var untranslated = key.substr(p + 1)
						print("Message %s with context %s" % [untranslated, context])
				
```

### `get_plural_message(src_message: StringName, src_plural_message: StringName, n: int, context: StringName = &"") -> StringName`
- 限定：qualifiers=const

Returns a message's translation involving plurals.
				The number `n` is the number or quantity of the plural object. It will be used to guide the translation system to fetch the correct plural form for the selected language.
				**Note:** Plurals are only supported in gettext-based translations (PO) ($DOCS_URL/tutorials/i18n/localization_using_gettext.html), not CSV.

### `get_translated_message_list() -> PackedStringArray`
- 限定：qualifiers=const

Returns all the translated strings.

## 教程链接

- [Internationalizing games](None)
- [Localization using gettext](None)
- [Locales](None)

