# ResourceImporterCSVTranslation

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ResourceImporterCSVTranslation` → `ResourceImporter` → `RefCounted` → `Object`
> 附加属性：api_type=editor
> 自动生成，勿手改。文件：`refs/godot-api/ResourceImporterCSVTranslation.md`

**摘要**：Imports comma-separated values as `Translation`s.

## 描述

Comma-separated values are a plain text table storage format. The format's simplicity makes it easy to edit in any text editor or spreadsheet software. This makes it a common choice for game localization.
		In the CSV file used for translation, the first column contains string identifiers, and the first row serves as the header. The first column's header can be any value. The remaining headers indicate the locale for that column. Columns whose headers begin with an underscore (`_`) will be ignored.
		**Example CSV file:**
		`lang=text`
		keys,en,es,ja
		GREET,"Hello, friend!","Hola, amigo!",こんにちは
		ASK,How are you?,Cómo está?,元気ですか
		BYE,Goodbye,Adiós,さようなら
		QUOTE,"""Hello"" said the man.","""Hola"" dijo el hombre.",「こんにちは」男は言いました
		
		Although keys in the first column typically use uppercase string identifiers, it is not uncommon to directly use strings appearing in the game as keys. To avoid string ambiguity, you can use a special `?context` column to specify the context to use with `Object.tr`.
		`lang=text`
		en,?context,fr,ja,zh
		Letter,Alphabet,Lettre,字母,字母
		Letter,Message,Courrier,手紙,信件
		
		To set the plural form of a string to use with `Object.tr_n`, add a special `?plural` column. After setting the plural form of the source string in this column, you can add additional rows to provide translations for more plural forms. The first column and all special columns in these plural form rows must be empty.
		Godot includes built-in plural rules for some languages. You can also customize them using a special `?pluralrule` row. See GNU gettext (https://www.gnu.org/software/gettext/manual/html_node/Plural-forms.html) for examples and more info.
		`lang=text`
		en,?plural,fr,ru,zh,_Comment
		?pluralrule,,nplurals=2; plural=(n >= 2);,,,Customize the plural rule for French
		There is %d apple,There are %d apples,Il y a %d pomme,Есть %d яблоко,那里有%d个苹果,
		,,Il y a %d pommes,Есть %d яблока,,
		,,,Есть %d яблок,,

## 属性

- **`compress`** `int` = `1`
  - 其它属性：getter= · setter=
- **`delimiter`** `int` = `0`
  - 其它属性：getter= · setter=
- **`unescape_keys`** `bool` = `false`
  - 其它属性：getter= · setter=
- **`unescape_translations`** `bool` = `true`
  - 其它属性：getter= · setter=

## 教程链接

- [Importing translations](None)

