# TranslationServer

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`TranslationServer` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/TranslationServer.md`

**摘要**：The server responsible for language translations.

## 描述

The translation server is the API backend that manages all language translations.
		Translations are stored in `TranslationDomain`s, which can be accessed by name. The most commonly used translation domain is the main translation domain. It always exists and can be accessed using an empty `StringName`. The translation server provides wrapper methods for accessing the main translation domain directly, without having to fetch the translation domain first. Custom translation domains are mainly for advanced usages like editor plugins. Names starting with `godot.` are reserved for engine internals.

## 属性

- **`pseudolocalization_enabled`** `bool` = `false`
  - 其它属性：getter=is_pseudolocalization_enabled · setter=set_pseudolocalization_enabled

## 方法

### `add_translation(translation: Translation) -> void`

Adds a translation to the main translation domain.

### `clear() -> void`

Removes all translations from the main translation domain.

### `compare_locales(locale_a: String, locale_b: String) -> int`
- 限定：qualifiers=const

Compares two locales and returns a similarity score between `0` (no match) and `10` (full match).

### `find_translations(locale: String, exact: bool) -> Translation[]`
- 限定：qualifiers=const

Returns the `Translation` instances in the main translation domain that match `locale` (see `compare_locales`). If `exact` is `true`, only instances whose locale exactly equals `locale` will be returned.

### `format_number(number: String, locale: String) -> String`
- 限定：qualifiers=const

Converts a number from Western Arabic (0..9) to the numeral system used in the given `locale`.

### `get_all_countries() -> PackedStringArray`
- 限定：qualifiers=const

Returns an array of known country codes.

### `get_all_languages() -> PackedStringArray`
- 限定：qualifiers=const

Returns array of known language codes.

### `get_all_scripts() -> PackedStringArray`
- 限定：qualifiers=const

Returns an array of known script codes.

### `get_country_name(country: String) -> String`
- 限定：qualifiers=const

Returns a readable country name for the `country` code.

### `get_language_name(language: String) -> String`
- 限定：qualifiers=const

Returns a readable language name for the `language` code.

### `get_loaded_locales() -> PackedStringArray`
- 限定：qualifiers=const

Returns an array of all loaded locales of the project.

### `get_locale() -> String`
- 限定：qualifiers=const

Returns the current locale of the project.
				See also `OS.get_locale` and `OS.get_locale_language` to query the locale of the user system.

### `get_locale_name(locale: String) -> String`
- 限定：qualifiers=const

Returns a locale's language and its variant (e.g. `"en_US"` would return `"English (United States)"`).

### `get_or_add_domain(domain: StringName) -> TranslationDomain`

Returns the translation domain with the specified name. An empty translation domain will be created and added if it does not exist.

### `get_percent_sign(locale: String) -> String`
- 限定：qualifiers=const

Returns the percent sign used in the given `locale`.

### `get_plural_rules(locale: String) -> String`
- 限定：qualifiers=const

Returns the default plural rules for the `locale`.

### `get_script_name(script: String) -> String`
- 限定：qualifiers=const

Returns a readable script name for the `script` code.

### `get_tool_locale() -> String`

Returns the current locale of the editor.
				**Note:** When called from an exported project returns the same value as `get_locale`.

### `get_translation_object(locale: String) -> Translation`
- 限定：deprecated=Use [method find_translations] instead.

Returns the `Translation` instance that best matches `locale` in the main translation domain. Returns `null` if there are no matches.

### `get_translations() -> Translation[]`
- 限定：qualifiers=const

Returns all available `Translation` instances in the main translation domain as added by `add_translation`.

### `has_domain(domain: StringName) -> bool`
- 限定：qualifiers=const

Returns `true` if a translation domain with the specified name exists.

### `has_translation(translation: Translation) -> bool`
- 限定：qualifiers=const

Returns `true` if the main translation domain contains the given `translation`.

### `has_translation_for_locale(locale: String, exact: bool) -> bool`
- 限定：qualifiers=const

Returns `true` if there are any `Translation` instances in the main translation domain that match `locale` (see `compare_locales`). If `exact` is `true`, only instances whose locale exactly equals `locale` are considered.

### `parse_number(number: String, locale: String) -> String`
- 限定：qualifiers=const

Converts `number` from the numeral system used in the given `locale` to Western Arabic (0..9).

### `pseudolocalize(message: StringName) -> StringName`
- 限定：qualifiers=const

Returns the pseudolocalized string based on the `message` passed in.
				**Note:** This method always uses the main translation domain.

### `reload_pseudolocalization() -> void`

Reparses the pseudolocalization options and reloads the translation for the main translation domain.

### `remove_domain(domain: StringName) -> void`

Removes the translation domain with the specified name.
				**Note:** Trying to remove the main translation domain is an error.

### `remove_translation(translation: Translation) -> void`

Removes the given translation from the main translation domain.

### `set_locale(locale: String) -> void`

Sets the locale of the project. The `locale` string will be standardized to match known locales (e.g. `en-US` would be matched to `en_US`).
				If translations have been loaded beforehand for the new locale, they will be applied.

### `standardize_locale(locale: String, add_defaults: bool = false) -> String`
- 限定：qualifiers=const

Returns a `locale` string standardized to match known locales (e.g. `en-US` would be matched to `en_US`). If `add_defaults` is `true`, the locale may have a default script or country added.

### `translate(message: StringName, context: StringName = &"") -> StringName`
- 限定：qualifiers=const

Returns the current locale's translation for the given message and context.
				**Note:** This method always uses the main translation domain.

### `translate_plural(message: StringName, plural_message: StringName, n: int, context: StringName = &"") -> StringName`
- 限定：qualifiers=const

Returns the current locale's translation for the given message, plural message and context.
				The number `n` is the number or quantity of the plural object. It will be used to guide the translation system to fetch the correct plural form for the selected language.
				**Note:** This method always uses the main translation domain.

## 教程链接

- [Internationalizing games](None)
- [Locales](None)

