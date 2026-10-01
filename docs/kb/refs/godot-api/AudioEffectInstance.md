# AudioEffectInstance

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AudioEffectInstance` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AudioEffectInstance.md`

**摘要**：Manipulates the audio it receives for a given effect.

## 描述

An audio effect instance manipulates the audio it receives for a given effect. This instance is automatically created by an `AudioEffect` when it is added to a bus, and should usually not be created directly. If necessary, it can be fetched at run-time with `AudioServer.get_bus_effect_instance`.

## 方法

### `_process(src_buffer: const void*, r_dst_buffer: AudioFrame*, frame_count: int) -> void`
- 限定：qualifiers=virtual required

Called by the `AudioServer` to process this effect. When `_process_silence` is not overridden or it returns `false`, this method is called only when the bus is active.
				**Note:** It is not useful to override this method in GDScript or C#. Only GDExtension can take advantage of it.

### `_process_silence() -> bool`
- 限定：qualifiers=virtual const

Override this method to customize the processing behavior of this effect instance.
				Should return `true` to force the `AudioServer` to always call `_process`, even if the bus has been muted or cannot otherwise be heard.

## 教程链接

- [Audio buses](None)
- [Audio effects](None)

