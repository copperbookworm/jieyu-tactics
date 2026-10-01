# TranslationDomain

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`TranslationDomain` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/TranslationDomain.md`

**摘要**：A self-contained collection of `Translation` resources.

## 描述

`TranslationDomain` is a self-contained collection of `Translation` resources. Translations can be added to or removed from it.
		If you're working with the main translation domain, it is more convenient to use the wrap methods on `TranslationServer`.

## 属性

- **`enabled`** `bool` = `true`
  - 其它属性：getter=is_enabled · setter=set_enabled
- **`pseudolocalization_accents_enabled`** `bool` = `true`
  - 其它属性：getter=is_pseudolocalization_accents_enabled · setter=set_pseudolocalization_accents_enabled
- **`pseudolocalization_double_vowels_enabled`** `bool` = `false`
  - 其它属性：getter=is_pseudolocalization_double_vowels_enabled · setter=set_pseudolocalization_double_vowels_enabled
- **`pseudolocalization_enabled`** `bool` = `false`
  - 其它属性：getter=is_pseudolocalization_enabled · setter=set_pseudolocalization_enabled
- **`pseudolocalization_expansion_ratio`** `float` = `0.0`
  - 其它属性：getter=get_pseudolocalization_expansion_ratio · setter=set_pseudolocalization_expansion_ratio
- **`pseudolocalization_fake_bidi_enabled`** `bool` = `false`
  - 其它属性：getter=is_pseudolocalization_fake_bidi_enabled · setter=set_pseudolocalization_fake_bidi_enabled
- **`pseudolocalization_override_enabled`** `bool` = `false`
  - 其它属性：getter=is_pseudolocalization_override_enabled · setter=set_pseudolocalization_override_enabled
- **`pseudolocalization_prefix`** `String` = `"["`
  - 其它属性：getter=get_pseudolocalization_prefix · setter=set_pseudolocalization_prefix
- **`pseudolocalization_skip_placeholders_enabled`** `bool` = `true`
  - 其它属性：getter=is_pseudolocalization_skip_placeholders_enabled · setter=set_pseudolocalization_skip_placeholders_enabled
- **`pseudolocalization_suffix`** `String` = `"]"`
  - 其它属性：getter=get_pseudolocalization_suffix · setter=set_pseudolocalization_suffix

## 方法

### `add_translation(translation: Translation) -> void`

Adds a translation.

### `clear() -> void`

Removes all translations.

### `find_translations(locale: String, exact: bool) -> Translation[]`
- 限定：qualifiers=const

Returns the `Translation` instances that match `locale` (see `TranslationServer.compare_locales`). If `exact` is `true`, only instances whose locale exactly equals `locale` will be returned.

### `get_locale_override() -> String`
- 限定：qualifiers=const

Returns the locale override of the domain. Returns an empty string if locale override is disabled.

### `get_translation_object(locale: String) -> Translation`
- 限定：deprecated=Use [method find_translations] instead. · qualifiers=const

Returns the `Translation` instance that best matches `locale`. Returns `null` if there are no matches.

### `get_translations() -> Translation[]`
- 限定：qualifiers=const

Returns all available `Translation` instances as added by `add_translation`.

### `has_translation(translation: Translation) -> bool`
- 限定：qualifiers=const

Returns `true` if this translation domain contains the given `translation`.

### `has_translation_for_locale(locale: String, exact: bool) -> bool`
- 限定：qualifiers=const

Returns `true` if there are any `Translation` instances that match `locale` (see `TranslationServer.compare_locales`). If `exact` is `true`, only instances whose locale exactly equals `locale` are considered.

### `pseudolocalize(message: StringName) -> StringName`
- 限定：qualifiers=const

Returns the pseudolocalized string based on the `message` passed in.

### `remove_translation(translation: Translation) -> void`

Removes the given translation.

### `set_locale_override(locale: String) -> void`

Sets the locale override of the domain.
				If `locale` is an empty string, locale override is disabled. Otherwise, `locale` will be standardized to match known locales (e.g. `en-US` would be matched to `en_US`).
				**Note:** Calling this method does not automatically update texts in the scene tree. Please propagate the `MainLoop.NOTIFICATION_TRANSLATION_CHANGED` signal manually.

### `translate(message: StringName, context: StringName = &"") -> StringName`
- 限定：qualifiers=const

Returns the current locale's translation for the given message and context.

### `translate_plural(message: StringName, message_plural: StringName, n: int, context: StringName = &"") -> StringName`
- 限定：qualifiers=const

Returns the current locale's translation for the given message, plural message and context.
				The number `n` is the number or quantity of the plural object. It will be used to guide the translation system to fetch the correct plural form for the selected language.

