# VehicleBody3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VehicleBody3D` → `RigidBody3D` → `PhysicsBody3D` → `CollisionObject3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VehicleBody3D.md`

**摘要**：A 3D physics body that simulates the behavior of a car.

## 描述

This physics body implements all the physics logic needed to simulate a car. It is based on the raycast vehicle system commonly found in physics engines. Aside from a `CollisionShape3D` for the main body of the vehicle, you must also add a `VehicleWheel3D` node for each wheel. You should also add a `MeshInstance3D` to this node for the 3D model of the vehicle, but this model should generally not include meshes for the wheels. You can control the vehicle by using the `brake`, `engine_force`, and `steering` properties. The position or orientation of this node shouldn't be changed directly.
		**Note:** The local forward for this node is `Vector3.MODEL_FRONT`.
		**Note:** The origin point of your VehicleBody3D will determine the center of gravity of your vehicle. To make the vehicle more grounded, the origin point is usually kept low, moving the `CollisionShape3D` and `MeshInstance3D` upwards.
		**Note:** This class has known issues and isn't designed to provide realistic 3D vehicle physics. If you want advanced vehicle physics, you may have to write your own physics integration using `CharacterBody3D` or `RigidBody3D`.

## 属性

- **`brake`** `float` = `0.0`
  - 其它属性：getter=get_brake · setter=set_brake
- **`engine_force`** `float` = `0.0`
  - 其它属性：getter=get_engine_force · setter=set_engine_force
- **`mass`** `float` = `40.0`
  - 其它属性：getter=get_mass · overrides=RigidBody3D · setter=set_mass
- **`steering`** `float` = `0.0`
  - 其它属性：getter=get_steering · setter=set_steering

## 教程链接

- [Physics introduction](None)
- [Troubleshooting physics issues](None)
- [3D Truck Town Demo](None)

