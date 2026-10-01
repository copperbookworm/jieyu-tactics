# Plane

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Plane`
> 自动生成，勿手改。文件：`refs/godot-api/Plane.md`

**摘要**：A plane in Hessian normal form.

## 描述

Represents a normalized plane equation. `normal` is the normal of the plane (a, b, c normalized), and `d` is the distance from the origin to the plane (in the direction of "normal"). "Over" or "Above" the plane is considered the side of the plane towards where the normal is pointing.
		**Note:** In a boolean context, a plane will evaluate to `false` if all its components equal `0`. Otherwise, a plane will always evaluate to `true`.

## 属性

- **`d`** `float` = `0.0`
  - 其它属性：getter= · setter=
- **`normal`** `Vector3` = `Vector3(0, 0, 0)`
  - 其它属性：getter= · setter=
- **`x`** `float` = `0.0`
  - 其它属性：getter= · setter=
- **`y`** `float` = `0.0`
  - 其它属性：getter= · setter=
- **`z`** `float` = `0.0`
  - 其它属性：getter= · setter=

## 方法

### `distance_to(point: Vector3) -> float`
- 限定：qualifiers=const

Returns the shortest distance from the plane to the position `point`. If the point is above the plane, the distance will be positive. If below, the distance will be negative.

### `get_center() -> Vector3`
- 限定：qualifiers=const

Returns the center of the plane.

### `has_point(point: Vector3, tolerance: float = 1e-05) -> bool`
- 限定：qualifiers=const

Returns `true` if `point` is inside the plane. Comparison uses a custom minimum `tolerance` threshold.

### `intersect_3(b: Plane, c: Plane) -> Variant`
- 限定：qualifiers=const

Returns the intersection point of the three planes `b`, `c` and this plane. If no intersection is found, `null` is returned.

### `intersects_ray(from: Vector3, dir: Vector3) -> Variant`
- 限定：qualifiers=const

Returns the intersection point of a ray consisting of the position `from` and the direction normal `dir` with this plane. If no intersection is found, `null` is returned.

### `intersects_segment(from: Vector3, to: Vector3) -> Variant`
- 限定：qualifiers=const

Returns the intersection point of a segment from position `from` to position `to` with this plane. If no intersection is found, `null` is returned.

### `is_equal_approx(to_plane: Plane) -> bool`
- 限定：qualifiers=const

Returns `true` if this plane and `to_plane` are approximately equal, by running `@GlobalScope.is_equal_approx` on each component.

### `is_finite() -> bool`
- 限定：qualifiers=const

Returns `true` if this plane is finite, by calling `@GlobalScope.is_finite` on each component.

### `is_point_over(point: Vector3) -> bool`
- 限定：qualifiers=const

Returns `true` if `point` is located above the plane.

### `normalized() -> Plane`
- 限定：qualifiers=const

Returns a copy of the plane, with normalized `normal` (so it's a unit vector). Returns `Plane(0, 0, 0, 0)` if `normal` can't be normalized (it has zero length).

### `project(point: Vector3) -> Vector3`
- 限定：qualifiers=const

Returns the orthogonal projection of `point` into a point in the plane.

## 常量

- **`PLANE_YZ`** = `Plane(1, 0, 0, 0)`
- **`PLANE_XZ`** = `Plane(0, 1, 0, 0)`
- **`PLANE_XY`** = `Plane(0, 0, 1, 0)`
## 构造函数

### `Plane`

Constructs a default-initialized `Plane` with all components set to `0`.

### `Plane`

Constructs a `Plane` as a copy of the given `Plane`.

### `Plane`

Creates a plane from the four parameters. The three components of the resulting plane's `normal` are `a`, `b` and `c`, and the plane has a distance of `d` from the origin.

### `Plane`

Creates a plane from the normal vector. The plane will intersect the origin.
				The `normal` of the plane must be a unit vector.

### `Plane`

Creates a plane from the normal vector and the plane's distance from the origin.
				The `normal` of the plane must be a unit vector.

### `Plane`

Creates a plane from the normal vector and a point on the plane.
				The `normal` of the plane must be a unit vector.

### `Plane`

Creates a plane from the three points, given in clockwise order.

## 运算符

### `operator !=`

Returns `true` if the planes are not equal.
				**Note:** Due to floating-point precision errors, consider using `is_equal_approx` instead, which is more reliable.

### `operator *`

Inversely transforms (multiplies) the `Plane` by the given `Transform3D` transformation matrix.
				`plane * transform` is equivalent to `transform.affine_inverse() * plane`. See `Transform3D.affine_inverse`.

### `operator ==`

Returns `true` if the planes are exactly equal.
				**Note:** Due to floating-point precision errors, consider using `is_equal_approx` instead, which is more reliable.

### `operator unary+`

Returns the same value as if the `+` was not there. Unary `+` does nothing, but sometimes it can make your code more readable.

### `operator unary-`

Returns the negative value of the `Plane`. This is the same as writing `Plane(-p.normal, -p.d)`. This operation flips the direction of the normal vector and also flips the distance value, resulting in a Plane that is in the same place, but facing the opposite direction.

## 教程链接

- [Math documentation index](None)

