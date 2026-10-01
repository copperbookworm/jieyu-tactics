# WorldEnvironment

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`WorldEnvironment` → `Node` → `Object`
> 附加属性：api_type=core · keywords=background, sky
> 自动生成，勿手改。文件：`refs/godot-api/WorldEnvironment.md`

**摘要**：Default environment properties for the entire scene (post-processing effects, lighting and background settings).

## 描述

The `WorldEnvironment` node is used to configure the default `Environment` for the scene.
		The parameters defined in the `WorldEnvironment` can be overridden by an `Environment` node set on the current `Camera3D`. Additionally, only one `WorldEnvironment` may be instantiated in a given scene at a time.
		The `WorldEnvironment` allows the user to specify default lighting parameters (e.g. ambient lighting), various post-processing effects (e.g. SSAO, DOF, Tonemapping), and how to draw the background (e.g. solid color, skybox). Usually, these are added in order to improve the realism/color balance of the scene.

## 属性

- **`camera_attributes`** `CameraAttributes`
  - 其它属性：getter=get_camera_attributes · setter=set_camera_attributes
- **`compositor`** `Compositor`
  - 其它属性：getter=get_compositor · setter=set_compositor
- **`environment`** `Environment`
  - 其它属性：getter=get_environment · setter=set_environment

## 教程链接

- [Environment and post-processing](None)
- [3D Material Testers Demo](None)
- [Third Person Shooter (TPS) Demo](None)

