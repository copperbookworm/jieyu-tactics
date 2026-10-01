# OptimizedTranslation

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OptimizedTranslation` → `Translation` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/OptimizedTranslation.md`

**摘要**：An optimized translation.

## 描述

An optimized translation. Uses real-time compressed translations, which results in very small dictionaries.
		This class does not store the untranslated strings for optimization purposes. Therefore, `Translation.get_message_list` always returns an empty array, and `Translation.get_message_count` always returns `0`.

## 方法

### `generate(from: Translation) -> bool`

Generates and sets an optimized translation from the given `Translation` resource. Returns `true` if successful.
				**Note:** Messages in `from` should not use context or plural forms.
				**Note:** This method is intended to be used in the editor. It does nothing when called from an exported project.

