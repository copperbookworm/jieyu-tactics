# TextServerDummy

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`TextServerDummy` → `TextServerExtension` → `TextServer` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/TextServerDummy.md`

**摘要**：A dummy text server that can't render text or manage fonts.

## 描述

A dummy `TextServer` interface that doesn't do anything. Useful for freeing up memory when rendering text is not needed, as text servers are resource-intensive. It can also be used for performance comparisons in complex GUIs to check the impact of text rendering.
		A dummy text server is always available at the start of a project. Here's how to access it:
		
```gdscript
		var dummy_text_server = TextServerManager.find_interface("Dummy")
		if dummy_text_server != null:
			TextServerManager.set_primary_interface(dummy_text_server)
			# If the other text servers are unneeded, they can be removed:
			for i in TextServerManager.get_interface_count():
				var text_server = TextServerManager.get_interface(i)
				if text_server != dummy_text_server:
					TextServerManager.remove_interface(text_server)
		
```

		The command line argument `--text-driver Dummy` (case-sensitive) can be used to force the "Dummy" `TextServer` on any project.

