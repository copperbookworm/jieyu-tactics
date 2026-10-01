# AnimationNodeOneShot

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AnimationNodeOneShot` → `AnimationNodeSync` → `AnimationNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AnimationNodeOneShot.md`

**摘要**：Plays an animation once in an `AnimationNodeBlendTree`.

## 描述

A resource to add to an `AnimationNodeBlendTree`. This animation node will execute a sub-animation and return once it finishes. Blend times for fading in and out can be customized, as well as filters.
		After setting the request and changing the animation playback, the one-shot node automatically clears the request on the next process frame by setting its `request` value to `ONE_SHOT_REQUEST_NONE`.
		`codeblocks`
		`gdscript`
		# Play child animation connected to "shot" port.
		animation_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		# Alternative syntax (same result as above).
		animation_tree["parameters/OneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE

		# Abort child animation connected to "shot" port.
		animation_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
		# Alternative syntax (same result as above).
		animation_tree["parameters/OneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT

		# Abort child animation with fading out connected to "shot" port.
		animation_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FADE_OUT)
		# Alternative syntax (same result as above).
		animation_tree["parameters/OneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FADE_OUT

		# Get current state (read-only).
		animation_tree.get("parameters/OneShot/active")
		# Alternative syntax (same result as above).
		animation_tree["parameters/OneShot/active"]

		# Get current internal state (read-only).
		animation_tree.get("parameters/OneShot/internal_active")
		# Alternative syntax (same result as above).
		animation_tree["parameters/OneShot/internal_active"]
		
		`csharp`
		// Play child animation connected to "shot" port.
		animationTree.Set("parameters/OneShot/request", (int)AnimationNodeOneShot.OneShotRequest.Fire);

		// Abort child animation connected to "shot" port.
		animationTree.Set("parameters/OneShot/request", (int)AnimationNodeOneShot.OneShotRequest.Abort);

		// Abort child animation with fading out connected to "shot" port.
		animationTree.Set("parameters/OneShot/request", (int)AnimationNodeOneShot.OneShotRequest.FadeOut);

		// Get current state (read-only).
		animationTree.Get("parameters/OneShot/active");

		// Get current internal state (read-only).
		animationTree.Get("parameters/OneShot/internal_active");

## 属性

- **`abort_on_reset`** `bool` = `false`
  - 其它属性：getter=is_aborted_on_reset · setter=set_abort_on_reset
- **`autorestart`** `bool` = `false`
  - 其它属性：getter=has_autorestart · setter=set_autorestart
- **`autorestart_delay`** `float` = `1.0`
  - 其它属性：getter=get_autorestart_delay · setter=set_autorestart_delay
- **`autorestart_random_delay`** `float` = `0.0`
  - 其它属性：getter=get_autorestart_random_delay · setter=set_autorestart_random_delay
- **`break_loop_at_end`** `bool` = `false`
  - 其它属性：getter=is_loop_broken_at_end · setter=set_break_loop_at_end
- **`fadein_curve`** `Curve`
  - 其它属性：getter=get_fadein_curve · setter=set_fadein_curve
- **`fadein_time`** `float` = `0.0`
  - 其它属性：getter=get_fadein_time · setter=set_fadein_time
- **`fadeout_curve`** `Curve`
  - 其它属性：getter=get_fadeout_curve · setter=set_fadeout_curve
- **`fadeout_time`** `float` = `0.0`
  - 其它属性：getter=get_fadeout_time · setter=set_fadeout_time
- **`mix_mode`** `int` = `0` · 枚举 `AnimationNodeOneShot.MixMode`
  - 其它属性：getter=get_mix_mode · setter=set_mix_mode

## 枚举

### `OneShotRequest`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ONE_SHOT_REQUEST_NONE` |  |
| `1` | `ONE_SHOT_REQUEST_FIRE` |  |
| `2` | `ONE_SHOT_REQUEST_ABORT` |  |
| `3` | `ONE_SHOT_REQUEST_FADE_OUT` |  |

### `MixMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `MIX_MODE_BLEND` |  |
| `1` | `MIX_MODE_ADD` |  |

## 教程链接

- [Using AnimationTree](None)
- [Third Person Shooter (TPS) Demo](None)

