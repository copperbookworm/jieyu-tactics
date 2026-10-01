# Transform3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Transform3D`
> 自动生成，勿手改。文件：`refs/godot-api/Transform3D.md`

**摘要**：A 3×4 matrix representing a 3D transformation.

## 描述

The `Transform3D` built-in `Variant` type is a 3×4 matrix representing a transformation in 3D space. It contains a `Basis`, which on its own can represent rotation, scale, and shear. Additionally, combined with its own `origin`, the transform can also represent a translation.
		For a general introduction, see the Matrices and transforms ($DOCS_URL/tutorials/math/matrices_and_transforms.html) tutorial.
		**Note:** Godot uses a right-handed coordinate system (https://en.wikipedia.org/wiki/Right-hand_rule), which is a common standard. For directions, the convention for built-in types like `Camera3D` is for -Z to point forward (+X is right, +Y is up, and +Z is back). Other objects may use different direction conventions. For more information, see the 3D asset direction conventions ($DOCS_URL/tutorials/assets_pipeline/importing_3d_scenes/model_export_considerations.html#d-asset-direction-conventions) tutorial.
		**Note:** In a boolean context, a Transform3D will evaluate to `false` if it's equal to `IDENTITY`. Otherwise, a Transform3D will always evaluate to `true`.

## 属性

- **`basis`** `Basis` = `Basis(1, 0, 0, 0, 1, 0, 0, 0, 1)`
  - 其它属性：getter= · setter=
- **`origin`** `Vector3` = `Vector3(0, 0, 0)`
  - 其它属性：getter= · setter=

## 方法

### `affine_inverse() -> Transform3D`
- 限定：qualifiers=const

Returns the inverted version of this transform. Unlike `inverse`, this method works with almost any `basis`, including non-uniform ones, but is slower. See also `Basis.inverse`.
				**Note:** For this method to return correctly, the transform's `basis` needs to have a determinant that is not exactly `0.0` (see `Basis.determinant`).

### `interpolate_with(xform: Transform3D, weight: float) -> Transform3D`
- 限定：qualifiers=const

Returns the result of the linear interpolation between this transform and `xform` by the given `weight`.
				The `weight` should be between `0.0` and `1.0` (inclusive). Values outside this range are allowed and can be used to perform *extrapolation* instead.

### `inverse() -> Transform3D`
- 限定：qualifiers=const

Returns the inverted version of this transform (https://en.wikipedia.org/wiki/Invertible_matrix). See also `Basis.inverse`.
				**Note:** For this method to return correctly, the transform's `basis` needs to be *orthonormal* (see `orthonormalized`). That means the basis should only represent a rotation. If it does not, use `affine_inverse` instead.

### `is_equal_approx(xform: Transform3D) -> bool`
- 限定：qualifiers=const

Returns `true` if this transform and `xform` are approximately equal, by running `@GlobalScope.is_equal_approx` on each component.

### `is_finite() -> bool`
- 限定：qualifiers=const

Returns `true` if this transform is finite, by calling `@GlobalScope.is_finite` on each component.

### `looking_at(target: Vector3, up: Vector3 = Vector3(0, 1, 0), use_model_front: bool = false) -> Transform3D`
- 限定：qualifiers=const

Returns a copy of this transform rotated so that the forward axis (-Z) points towards the `target` position.
				The up axis (+Y) points as close to the `up` vector as possible while staying perpendicular to the forward axis. The resulting transform is orthonormalized. The existing rotation, scale, and skew information from the original transform is discarded. The `target` and `up` vectors cannot be zero, cannot be parallel to each other, and are defined in global/parent space.
				If `use_model_front` is `true`, the +Z axis (asset front) is treated as forward (implies +X is left) and points toward the `target` position. By default, the -Z axis (camera forward) is treated as forward (implies +X is right).

### `orthonormalized() -> Transform3D`
- 限定：qualifiers=const

Returns a copy of this transform with its `basis` orthonormalized. An orthonormal basis is both *orthogonal* (the axes are perpendicular to each other) and *normalized* (the axes have a length of `1.0`), which also means it can only represent a rotation. See also `Basis.orthonormalized`.

### `rotated(axis: Vector3, angle: float) -> Transform3D`
- 限定：qualifiers=const

Returns a copy of this transform rotated around the given `axis` by the given `angle` (in radians).
				The `axis` must be a normalized vector (see `Vector3.normalized`). If `angle` is positive, the basis is rotated counter-clockwise around the axis.
				This method is an optimized version of multiplying the given transform `X` with a corresponding rotation transform `R` from the left, i.e., `R * X`.
				This can be seen as transforming with respect to the global/parent frame.

### `rotated_local(axis: Vector3, angle: float) -> Transform3D`
- 限定：qualifiers=const

Returns a copy of this transform rotated around the given `axis` by the given `angle` (in radians).
				The `axis` must be a normalized vector in the transform's local coordinate system. For example, to rotate around the local X-axis, use `Vector3.RIGHT`.
				This method is an optimized version of multiplying the given transform `X` with a corresponding rotation transform `R` from the right, i.e., `X * R`.
				This can be seen as transforming with respect to the local frame.

### `scaled(scale: Vector3) -> Transform3D`
- 限定：qualifiers=const

Returns a copy of this transform scaled by the given `scale` factor.
				This method is an optimized version of multiplying the given transform `X` with a corresponding scaling transform `S` from the left, i.e., `S * X`.
				This can be seen as transforming with respect to the global/parent frame.

### `scaled_local(scale: Vector3) -> Transform3D`
- 限定：qualifiers=const

Returns a copy of this transform scaled by the given `scale` factor.
				This method is an optimized version of multiplying the given transform `X` with a corresponding scaling transform `S` from the right, i.e., `X * S`.
				This can be seen as transforming with respect to the local frame.

### `translated(offset: Vector3) -> Transform3D`
- 限定：qualifiers=const

Returns a copy of this transform translated by the given `offset`.
				This method is an optimized version of multiplying the given transform `X` with a corresponding translation transform `T` from the left, i.e., `T * X`.
				This can be seen as transforming with respect to the global/parent frame.

### `translated_local(offset: Vector3) -> Transform3D`
- 限定：qualifiers=const

Returns a copy of this transform translated by the given `offset`.
				This method is an optimized version of multiplying the given transform `X` with a corresponding translation transform `T` from the right, i.e., `X * T`.
				This can be seen as transforming with respect to the local frame.

## 常量

- **`IDENTITY`** = `Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0)`
- **`FLIP_X`** = `Transform3D(-1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0)`
- **`FLIP_Y`** = `Transform3D(1, 0, 0, 0, -1, 0, 0, 0, 1, 0, 0, 0)`
- **`FLIP_Z`** = `Transform3D(1, 0, 0, 0, 1, 0, 0, 0, -1, 0, 0, 0)`
## 构造函数

### `Transform3D`

Constructs a `Transform3D` identical to `IDENTITY`.
				**Note:** In C#, this constructs a `Transform3D` with its `origin` and the components of its `basis` set to `Vector3.ZERO`.

### `Transform3D`

Constructs a `Transform3D` as a copy of the given `Transform3D`.

### `Transform3D`

Constructs a `Transform3D` from a `Basis` and `Vector3`.

### `Transform3D`

Constructs a `Transform3D` from a `Projection`. Because `Transform3D` is a 3×4 matrix and `Projection` is a 4×4 matrix, this operation trims the last row of the projection matrix (`from.x.w`, `from.y.w`, `from.z.w`, and `from.w.w` are not included in the new transform).

### `Transform3D`

Constructs a `Transform3D` from four `Vector3` values (also called matrix columns).
				The first three arguments are the `basis`'s axes (`Basis.x`, `Basis.y`, and `Basis.z`).

## 运算符

### `operator !=`

Returns `true` if the components of both transforms are not equal.
				**Note:** Due to floating-point precision errors, consider using `is_equal_approx` instead, which is more reliable.

### `operator *`

Transforms (multiplies) the `AABB` by this transformation matrix.

### `operator *`

Transforms (multiplies) every `Vector3` element of the given `PackedVector3Array` by this transformation matrix.
				On larger arrays, this operation is much faster than transforming each `Vector3` individually.

### `operator *`

Transforms (multiplies) the `Plane` by this transformation matrix.

### `operator *`

Transforms (multiplies) this transform by the `right` transform.
				This is the operation performed between parent and child `Node3D`s.
				**Note:** If you need to only modify one attribute of this transform, consider using one of the following methods, instead:
				- For translation, see `translated` or `translated_local`.
				- For rotation, see `rotated` or `rotated_local`.
				- For scale, see `scaled` or `scaled_local`.

### `operator *`

Transforms (multiplies) the `Vector3` by this transformation matrix.

### `operator *`

Multiplies all components of the `Transform3D` by the given `float`, including the `origin`. This affects the transform's scale uniformly, scaling the `basis`.

### `operator *`

Multiplies all components of the `Transform3D` by the given `int`, including the `origin`. This affects the transform's scale uniformly, scaling the `basis`.

### `operator /`

Divides all components of the `Transform3D` by the given `float`, including the `origin`. This affects the transform's scale uniformly, scaling the `basis`.

### `operator /`

Divides all components of the `Transform3D` by the given `int`, including the `origin`. This affects the transform's scale uniformly, scaling the `basis`.

### `operator ==`

Returns `true` if the components of both transforms are exactly equal.
				**Note:** Due to floating-point precision errors, consider using `is_equal_approx` instead, which is more reliable.

## 教程链接

- [Math documentation index](None)
- [Matrices and transforms](None)
- [Using 3D transforms](None)
- [Matrix Transform Demo](None)
- [3D Platformer Demo](None)
- [2.5D Game Demo](None)

