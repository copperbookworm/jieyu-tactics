# AudioEffectRecord

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AudioEffectRecord` → `AudioEffect` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AudioEffectRecord.md`

**摘要**：Audio effect used for recording the sound from an audio bus.

## 描述

Allows the user to record the sound from an audio bus into an `AudioStreamWAV`. When used on the Master audio bus, this includes all audio output by Godot.
		Unlike `AudioEffectCapture`, this effect encodes the recording with the given format (8-bit, 16-bit, or compressed) instead of giving access to the raw audio samples.
		Can be used (with an `AudioStreamMicrophone`) to record from a microphone.
		**Note:** `ProjectSettings.audio/driver/enable_input` must be `true` for audio input to work. See also that setting's description for caveats related to permissions and operating system privacy settings.

## 属性

- **`format`** `int` = `1` · 枚举 `AudioStreamWAV.Format`
  - 其它属性：getter=get_format · setter=set_format

## 方法

### `get_recording() -> AudioStreamWAV`
- 限定：qualifiers=const

Returns the recorded sample.

### `is_recording_active() -> bool`
- 限定：qualifiers=const

Returns whether the recording is active or not.

### `set_recording_active(record: bool) -> void`

If `true`, the sound will be recorded. Note that restarting the recording will remove the previously recorded sample.

## 教程链接

- [Recording with microphone](None)
- [Audio Microphone Record Demo](None)

