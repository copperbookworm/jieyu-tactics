# AnimationNodeTimeSeek

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AnimationNodeTimeSeek` → `AnimationNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AnimationNodeTimeSeek.md`

**摘要**：A time-seeking animation node used in `AnimationTree`.

## 描述

This animation node can be used to cause a seek command to happen to any sub-children of the animation graph. Use to play an `Animation` from the start or a certain playback position inside the `AnimationNodeBlendTree`.
		After setting the time and changing the animation playback, the time seek node automatically goes into sleep mode on the next process frame by setting its `seek_request` value to `-1.0`.
		`codeblocks`
		`gdscript`
		# Play child animation from the start.
		animation_tree.set("parameters/TimeSeek/seek_request", 0.0)
		# Alternative syntax (same result as above).
		animation_tree["parameters/TimeSeek/seek_request"] = 0.0

		# Play child animation from 12 second timestamp.
		animation_tree.set("parameters/TimeSeek/seek_request", 12.0)
		# Alternative syntax (same result as above).
		animation_tree["parameters/TimeSeek/seek_request"] = 12.0
		
		`csharp`
		// Play child animation from the start.
		animationTree.Set("parameters/TimeSeek/seek_request", 0.0);

		// Play child animation from 12 second timestamp.
		animationTree.Set("parameters/TimeSeek/seek_request", 12.0);

## 属性

- **`explicit_elapse`** `bool` = `true`
  - 其它属性：getter=is_explicit_elapse · setter=set_explicit_elapse

## 教程链接

- [Using AnimationTree](None)

