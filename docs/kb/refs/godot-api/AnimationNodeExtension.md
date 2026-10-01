# AnimationNodeExtension

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AnimationNodeExtension` → `AnimationNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/AnimationNodeExtension.md`

**摘要**：Base class for extending `AnimationRootNode`s from GDScript, C#, or C++.

## 描述

`AnimationNodeExtension` exposes the APIs of `AnimationRootNode` to allow users to extend it from GDScript, C#, or C++. This class is not meant to be used directly, but to be extended by other classes. It is used to create custom nodes for the `AnimationTree` system.

## 方法

### `_process_animation_node(playback_info: PackedFloat64Array, test_only: bool) -> PackedFloat32Array`
- 限定：qualifiers=virtual required

A version of the `AnimationNode._process` method that is meant to be overridden by custom nodes. It returns a `PackedFloat32Array` with the processed animation data.
				The `PackedFloat64Array` parameter contains the playback information, containing the following values encoded as floating point numbers (in order): playback time and delta, start and end times, whether a seek was requested (encoded as a float greater than `0`), whether the seek request was externally requested (encoded as a float greater than `0`), the current `Animation.LoopedFlag` (encoded as a float), and the current blend weight.
				The function must return a `PackedFloat32Array` of the node's time info, containing the following values (in order): animation length, time position, delta, `Animation.LoopMode` (encoded as a float), whether the animation is about to end (encoded as a float greater than `0`) and whether the animation is infinite (encoded as a float greater than `0`). All values must be included in the returned array.

### `get_remaining_time(node_info: PackedFloat32Array, break_loop: bool) -> float`
- 限定：qualifiers=static

Returns the animation's remaining time for the given node info. For looping animations, it will only return the remaining time if `break_loop` is `true`, a large integer value will be returned otherwise.

### `is_looping(node_info: PackedFloat32Array) -> bool`
- 限定：qualifiers=static

Returns `true` if the animation for the given `node_info` is looping.

