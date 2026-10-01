# InputEventMIDI

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`InputEventMIDI` → `InputEvent` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/InputEventMIDI.md`

**摘要**：Represents a MIDI message from a MIDI device, such as a musical keyboard.

## 描述

InputEventMIDI stores information about messages from MIDI (https://en.wikipedia.org/wiki/MIDI) (Musical Instrument Digital Interface) devices. These may include musical keyboards, synthesizers, and drum machines.
		MIDI messages can be received over a 5-pin MIDI connector or over USB. If your device supports both be sure to check the settings in the device to see which output it is using.
		By default, Godot does not detect MIDI devices. You need to call `OS.open_midi_inputs`, first. You can check which devices are detected with `OS.get_connected_midi_inputs`, and close the connection with `OS.close_midi_inputs`.
		`codeblocks`
		`gdscript`
		func _ready():
			OS.open_midi_inputs()
			print(OS.get_connected_midi_inputs())

		func _input(input_event):
			if input_event is InputEventMIDI:
				_print_midi_info(input_event)

		func _print_midi_info(midi_event):
			print(midi_event)
			print("Channel ", midi_event.channel)
			print("Message ", midi_event.message)
			print("Pitch ", midi_event.pitch)
			print("Velocity ", midi_event.velocity)
			print("Instrument ", midi_event.instrument)
			print("Pressure ", midi_event.pressure)
			print("Controller number: ", midi_event.controller_number)
			print("Controller value: ", midi_event.controller_value)
		
		`csharp`
		public override void _Ready()
		{
			OS.OpenMidiInputs();
			GD.Print(OS.GetConnectedMidiInputs());
		}

		public override void _Input(InputEvent inputEvent)
		{
			if (inputEvent is InputEventMidi midiEvent)
			{
				PrintMIDIInfo(midiEvent);
			}
		}

		private void PrintMIDIInfo(InputEventMidi midiEvent)
		{
			GD.Print(midiEvent);
			GD.Print($"Channel {midiEvent.Channel}");
			GD.Print($"Message {midiEvent.Message}");
			GD.Print($"Pitch {midiEvent.Pitch}");
			GD.Print($"Velocity {midiEvent.Velocity}");
			GD.Print($"Instrument {midiEvent.Instrument}");
			GD.Print($"Pressure {midiEvent.Pressure}");
			GD.Print($"Controller number: {midiEvent.ControllerNumber}");
			GD.Print($"Controller value: {midiEvent.ControllerValue}");
		}
		
		
		**Note:** Godot does not support MIDI output, so there is no way to emit MIDI messages from Godot. Only MIDI input is supported.
		**Note:** On the Web platform, using MIDI input requires a browser permission to be granted first. This permission request is performed when calling `OS.open_midi_inputs`. MIDI input will not work until the user accepts the permission request.

## 属性

- **`channel`** `int` = `0`
  - 其它属性：getter=get_channel · setter=set_channel
- **`controller_number`** `int` = `0`
  - 其它属性：getter=get_controller_number · setter=set_controller_number
- **`controller_value`** `int` = `0`
  - 其它属性：getter=get_controller_value · setter=set_controller_value
- **`instrument`** `int` = `0`
  - 其它属性：getter=get_instrument · setter=set_instrument
- **`message`** `int` = `0` · 枚举 `MIDIMessage`
  - 其它属性：getter=get_message · setter=set_message
- **`pitch`** `int` = `0`
  - 其它属性：getter=get_pitch · setter=set_pitch
- **`pressure`** `int` = `0`
  - 其它属性：getter=get_pressure · setter=set_pressure
- **`velocity`** `int` = `0`
  - 其它属性：getter=get_velocity · setter=set_velocity

## 教程链接

- [MIDI Message Status Byte List](None)
- [Wikipedia General MIDI Instrument List](None)
- [Wikipedia Piano Key Frequencies List](None)

