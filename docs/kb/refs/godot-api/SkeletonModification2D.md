# SkeletonModification2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`SkeletonModification2D` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/SkeletonModification2D.md`

**摘要**：Base class for resources that operate on `Bone2D`s in a `Skeleton2D`.

## 描述

This resource provides an interface that can be expanded so code that operates on `Bone2D` nodes in a `Skeleton2D` can be mixed and matched together to create complex interactions.
		This is used to provide Godot with a flexible and powerful Inverse Kinematics solution that can be adapted for many different uses.

## 属性

- **`enabled`** `bool` = `true`
  - 其它属性：getter=get_enabled · setter=set_enabled
- **`execution_mode`** `int` = `0`
  - 其它属性：getter=get_execution_mode · setter=set_execution_mode

## 方法

### `_draw_editor_gizmo() -> void`
- 限定：qualifiers=virtual

Used for drawing **editor-only** modification gizmos. This function will only be called in the Godot editor and can be overridden to draw custom gizmos.
				**Note:** You will need to use the Skeleton2D from `SkeletonModificationStack2D.get_skeleton` and it's draw functions, as the `SkeletonModification2D` resource cannot draw on its own.

### `_execute(delta: float) -> void`
- 限定：qualifiers=virtual

Executes the given modification. This is where the modification performs whatever function it is designed to do.

### `_setup_modification(modification_stack: SkeletonModificationStack2D) -> void`
- 限定：qualifiers=virtual

Called when the modification is setup. This is where the modification performs initialization.

### `clamp_angle(angle: float, min: float, max: float, invert: bool) -> float`

Takes an angle and clamps it so it is within the passed-in `min` and `max` range. `invert` will inversely clamp the angle, clamping it to the range outside of the given bounds.

### `get_editor_draw_gizmo() -> bool`
- 限定：qualifiers=const

Returns whether this modification will call `_draw_editor_gizmo` in the Godot editor to draw modification-specific gizmos.

### `get_is_setup() -> bool`
- 限定：qualifiers=const

Returns whether this modification has been successfully setup or not.

### `get_modification_stack() -> SkeletonModificationStack2D`

Returns the `SkeletonModificationStack2D` that this modification is bound to. Through the modification stack, you can access the Skeleton2D the modification is operating on.

### `set_editor_draw_gizmo(draw_gizmo: bool) -> void`

Sets whether this modification will call `_draw_editor_gizmo` in the Godot editor to draw modification-specific gizmos.

### `set_is_setup(is_setup: bool) -> void`

Manually allows you to set the setup state of the modification. This function should only rarely be used, as the `SkeletonModificationStack2D` the modification is bound to should handle setting the modification up.

