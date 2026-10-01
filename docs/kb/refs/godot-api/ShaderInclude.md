# ShaderInclude

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ShaderInclude` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/ShaderInclude.md`

**摘要**：A snippet of shader code to be included in a `Shader` with `#include`.

## 描述

A shader include file, saved with the `.gdshaderinc` extension. This class allows you to define a custom shader snippet that can be included in a `Shader` by using the preprocessor directive `#include`, followed by the file path (e.g. `#include "res://shader_lib.gdshaderinc"`). The snippet doesn't have to be a valid shader on its own.

## 属性

- **`code`** `String` = `""`
  - 其它属性：getter=get_code · setter=set_code

## 教程链接

- [Shader preprocessor](None)

