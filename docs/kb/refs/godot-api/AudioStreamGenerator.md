# AudioStreamGenerator

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AudioStreamGenerator` → `AudioStream` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AudioStreamGenerator.md`

**摘要**：An audio stream with utilities for procedural sound generation.

## 描述

`AudioStreamGenerator` is a type of audio stream that does not play back sounds on its own; instead, it expects a script to generate audio data for it. See also `AudioStreamGeneratorPlayback`.
		Here's a sample on how to use it to generate a sine wave:
		`codeblocks`
		`gdscript`
		var playback # Will hold the AudioStreamGeneratorPlayback.
		@onready var sample_hz = $AudioStreamPlayer.stream.mix_rate
		var pulse_hz = 440.0 # The frequency of the sound wave.
		var phase = 0.0

		func _ready():
			$AudioStreamPlayer.play()
			playback = $AudioStreamPlayer.get_stream_playback()
			fill_buffer()

		func fill_buffer():
			var increment = pulse_hz / sample_hz
			var frames_available = playback.get_frames_available()

			for i in range(frames_available):
				playback.push_frame(Vector2.ONE * sin(phase * TAU))
				phase = fmod(phase + increment, 1.0)
		
		`csharp`
		`Export` public AudioStreamPlayer Player { get; set; }

		private AudioStreamGeneratorPlayback _playback; // Will hold the AudioStreamGeneratorPlayback.
		private float _sampleHz;
		private float _pulseHz = 440.0f; // The frequency of the sound wave.
		private double phase = 0.0;

		public override void _Ready()
		{
			if (Player.Stream is AudioStreamGenerator generator) // Type as a generator to access MixRate.
			{
				_sampleHz = generator.MixRate;
				Player.Play();
				_playback = (AudioStreamGeneratorPlayback)Player.GetStreamPlayback();
				FillBuffer();
			}
		}

		public void FillBuffer()
		{
			float increment = _pulseHz / _sampleHz;
			int framesAvailable = _playback.GetFramesAvailable();

			for (int i = 0; i < framesAvailable; i++)
			{
				_playback.PushFrame(Vector2.One * (float)Mathf.Sin(phase * Mathf.Tau));
				phase = Mathf.PosMod(phase + increment, 1.0);
			}
		}
		
		
		In the example above, the "AudioStreamPlayer" node must use an `AudioStreamGenerator` as its stream. The `fill_buffer` function provides audio data for approximating a sine wave.
		See also `AudioEffectSpectrumAnalyzer` for performing real-time audio spectrum analysis.
		**Note:** Due to performance constraints, this class is best used from C# or from a compiled language via GDExtension. If you still want to use this class from GDScript, consider using a lower `mix_rate` such as 11,025 Hz or 22,050 Hz.

## 属性

- **`buffer_length`** `float` = `0.5`
  - 其它属性：getter=get_buffer_length · setter=set_buffer_length
- **`mix_rate`** `float` = `44100.0`
  - 其它属性：getter=get_mix_rate · setter=set_mix_rate
- **`mix_rate_mode`** `int` = `2` · 枚举 `AudioStreamGenerator.AudioStreamGeneratorMixRate`
  - 其它属性：getter=get_mix_rate_mode · setter=set_mix_rate_mode

## 枚举

### `AudioStreamGeneratorMixRate`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `MIX_RATE_OUTPUT` |  |
| `1` | `MIX_RATE_INPUT` |  |
| `2` | `MIX_RATE_CUSTOM` |  |
| `3` | `MIX_RATE_MAX` |  |

## 教程链接

- [Audio streams](None)
- [Audio Generator Demo](None)

