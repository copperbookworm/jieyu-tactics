# VisualShaderNodeIf

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VisualShaderNodeIf` → `VisualShaderNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VisualShaderNodeIf.md`

**摘要**：Outputs a 3D vector based on the result of a floating-point comparison within the visual shader graph.

## 描述

This visual shader node has six input ports:
		- Port **1** and **2** provide the two floating-point numbers `a` and `b` that will be compared.
		- Port **3** is the tolerance, which allows similar floating-point numbers to be considered equal.
		- Ports **4**, **5**, and **6** are the possible outputs, returned if `a == b`, `a > b`, or `a < b` respectively.

