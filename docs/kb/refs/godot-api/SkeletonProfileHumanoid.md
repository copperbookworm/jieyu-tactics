# SkeletonProfileHumanoid

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`SkeletonProfileHumanoid` → `SkeletonProfile` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/SkeletonProfileHumanoid.md`

**摘要**：A humanoid `SkeletonProfile` preset.

## 描述

A `SkeletonProfile` as a preset that is optimized for the human form. This exists for standardization, so all parameters are read-only.
		A humanoid skeleton profile contains 56 bones divided into 4 groups: `"Body"`, `"Face"`, `"LeftHand"`, and `"RightHand"`. It is structured as follows:
		`lang=text`
		Root
		└─ Hips
		    ├─ LeftUpperLeg
		    │  └─ LeftLowerLeg
		    │     └─ LeftFoot
		    │        └─ LeftToes
		    ├─ RightUpperLeg
		    │  └─ RightLowerLeg
		    │     └─ RightFoot
		    │        └─ RightToes
		    └─ Spine
		        └─ Chest
		            └─ UpperChest
		                ├─ Neck
		                │   └─ Head
		                │       ├─ Jaw
		                │       ├─ LeftEye
		                │       └─ RightEye
		                ├─ LeftShoulder
		                │  └─ LeftUpperArm
		                │     └─ LeftLowerArm
		                │        └─ LeftHand
		                │           ├─ LeftThumbMetacarpal
		                │           │  └─ LeftThumbProximal
		                │           │    └─ LeftThumbDistal
		                │           ├─ LeftIndexProximal
		                │           │  └─ LeftIndexIntermediate
		                │           │    └─ LeftIndexDistal
		                │           ├─ LeftMiddleProximal
		                │           │  └─ LeftMiddleIntermediate
		                │           │    └─ LeftMiddleDistal
		                │           ├─ LeftRingProximal
		                │           │  └─ LeftRingIntermediate
		                │           │    └─ LeftRingDistal
		                │           └─ LeftLittleProximal
		                │              └─ LeftLittleIntermediate
		                │                └─ LeftLittleDistal
		                └─ RightShoulder
		                   └─ RightUpperArm
		                      └─ RightLowerArm
		                         └─ RightHand
		                            ├─ RightThumbMetacarpal
		                            │  └─ RightThumbProximal
		                            │     └─ RightThumbDistal
		                            ├─ RightIndexProximal
		                            │  └─ RightIndexIntermediate
		                            │     └─ RightIndexDistal
		                            ├─ RightMiddleProximal
		                            │  └─ RightMiddleIntermediate
		                            │     └─ RightMiddleDistal
		                            ├─ RightRingProximal
		                            │  └─ RightRingIntermediate
		                            │     └─ RightRingDistal
		                            └─ RightLittleProximal
		                               └─ RightLittleIntermediate
		                                 └─ RightLittleDistal

## 属性

- **`bone_size`** `int` = `56`
  - 其它属性：getter=get_bone_size · overrides=SkeletonProfile · setter=set_bone_size
- **`group_size`** `int` = `4`
  - 其它属性：getter=get_group_size · overrides=SkeletonProfile · setter=set_group_size
- **`root_bone`** `StringName` = `&"Root"`
  - 其它属性：getter=get_root_bone · overrides=SkeletonProfile · setter=set_root_bone
- **`scale_base_bone`** `StringName` = `&"Hips"`
  - 其它属性：getter=get_scale_base_bone · overrides=SkeletonProfile · setter=set_scale_base_bone

## 教程链接

- [Retargeting 3D Skeletons](None)

