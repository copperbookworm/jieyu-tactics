# TextServerFallback

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`TextServerFallback` → `TextServerExtension` → `TextServer` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/TextServerFallback.md`

**摘要**：A fallback implementation of Godot's text server, without support for BiDi and complex text layout.

## 描述

A fallback implementation of Godot's text server. This fallback is faster than `TextServerAdvanced` for processing a lot of text, but it does not support BiDi and complex text layout.
		**Note:** This text server is not part of official Godot binaries. If you want to use it, compile the engine with the option `module_text_server_fb_enabled=yes`. When building with `TextServerFallback`, consider also disabling `TextServerAdvanced` with `module_text_server_adv_enabled=no` to reduce binary size.

