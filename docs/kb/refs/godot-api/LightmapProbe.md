# LightmapProbe

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`LightmapProbe` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/LightmapProbe.md`

**摘要**：Represents a single manually placed probe for dynamic object lighting with `LightmapGI`.

## 描述

`LightmapProbe` represents the position of a single manually placed probe for dynamic object lighting with `LightmapGI`. Lightmap probes affect the lighting of `GeometryInstance3D`-derived nodes that have their `GeometryInstance3D.gi_mode` set to `GeometryInstance3D.GI_MODE_DYNAMIC`.
		Typically, `LightmapGI` probes are placed automatically by setting `LightmapGI.generate_probes_subdiv` to a value other than `LightmapGI.GENERATE_PROBES_DISABLED`. By creating `LightmapProbe` nodes before baking lightmaps, you can add more probes in specific areas for greater detail, or disable automatic generation and rely only on manually placed probes instead.
		**Note:** `LightmapProbe` nodes that are placed after baking lightmaps are ignored by dynamic objects. You must bake lightmaps again after creating or modifying `LightmapProbe`s for the probes to be effective.

