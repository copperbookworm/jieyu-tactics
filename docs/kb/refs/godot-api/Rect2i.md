# Rect2i

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Rect2i`
> 自动生成，勿手改。文件：`refs/godot-api/Rect2i.md`

**摘要**：A 2D axis-aligned bounding box using integer coordinates.

## 描述

The `Rect2i` built-in `Variant` type represents an axis-aligned rectangle in a 2D space, using integer coordinates. It is defined by its `position` and `size`, which are `Vector2i`. Because it does not rotate, it is frequently used for fast overlap tests (see `intersects`).
		For floating-point coordinates, see `Rect2`.
		**Note:** Negative values for `size` are not supported. With negative size, most `Rect2i` methods do not work correctly. Use `abs` to get an equivalent `Rect2i` with a non-negative size.
		**Note:** In a boolean context, a `Rect2i` evaluates to `false` if both `position` and `size` are zero (equal to `Vector2i.ZERO`). Otherwise, it always evaluates to `true`.

## 属性

- **`end`** `Vector2i` = `Vector2i(0, 0)`
  - 其它属性：getter= · setter=
- **`position`** `Vector2i` = `Vector2i(0, 0)`
  - 其它属性：getter= · setter=
- **`size`** `Vector2i` = `Vector2i(0, 0)`
  - 其它属性：getter= · setter=

## 方法

### `abs() -> Rect2i`
- 限定：qualifiers=const

Returns a `Rect2i` equivalent to this rectangle, with its width and height modified to be non-negative values, and with its `position` being the top-left corner of the rectangle.
				`codeblocks`
				`gdscript`
				var rect = Rect2i(25, 25, -100, -50)
				var absolute = rect.abs() # absolute is Rect2i(-75, -25, 100, 50)
				
				`csharp`
				var rect = new Rect2I(25, 25, -100, -50);
				var absolute = rect.Abs(); // absolute is Rect2I(-75, -25, 100, 50)
				
				
				**Note:** It's recommended to use this method when `size` is negative, as most other methods in Godot assume that the `position` is the top-left corner, and the `end` is the bottom-right corner.

### `encloses(b: Rect2i) -> bool`
- 限定：qualifiers=const

Returns `true` if this `Rect2i` completely encloses another one.

### `expand(to: Vector2i) -> Rect2i`
- 限定：qualifiers=const

Returns a copy of this rectangle expanded to align the edges with the given `to` point, if necessary.
				`codeblocks`
				`gdscript`
				var rect = Rect2i(0, 0, 5, 2)

				rect = rect.expand(Vector2i(10, 0)) # rect is Rect2i(0, 0, 10, 2)
				rect = rect.expand(Vector2i(-5, 5)) # rect is Rect2i(-5, 0, 15, 5)
				
				`csharp`
				var rect = new Rect2I(0, 0, 5, 2);

				rect = rect.Expand(new Vector2I(10, 0)); // rect is Rect2I(0, 0, 10, 2)
				rect = rect.Expand(new Vector2I(-5, 5)); // rect is Rect2I(-5, 0, 15, 5)

### `get_area() -> int`
- 限定：qualifiers=const

Returns the rectangle's area. This is equivalent to `size.x * size.y`. See also `has_area`.

### `get_center() -> Vector2i`
- 限定：qualifiers=const

Returns the center point of the rectangle. This is the same as `position + (size / 2)`.
				**Note:** If the `size` is odd, the result will be rounded towards `position`.

### `grow(amount: int) -> Rect2i`
- 限定：qualifiers=const

Returns a copy of this rectangle extended on all sides by the given `amount`. A negative `amount` shrinks the rectangle instead. See also `grow_individual` and `grow_side`.
				`codeblocks`
				`gdscript`
				var a = Rect2i(4, 4, 8, 8).grow(4) # a is Rect2i(0, 0, 16, 16)
				var b = Rect2i(0, 0, 8, 4).grow(2) # b is Rect2i(-2, -2, 12, 8)
				
				`csharp`
				var a = new Rect2I(4, 4, 8, 8).Grow(4); // a is Rect2I(0, 0, 16, 16)
				var b = new Rect2I(0, 0, 8, 4).Grow(2); // b is Rect2I(-2, -2, 12, 8)

### `grow_individual(left: int, top: int, right: int, bottom: int) -> Rect2i`
- 限定：qualifiers=const

Returns a copy of this rectangle with its `left`, `top`, `right`, and `bottom` sides extended by the given amounts. Negative values shrink the sides, instead. See also `grow` and `grow_side`.

### `grow_side(side: int, amount: int) -> Rect2i`
- 限定：qualifiers=const

Returns a copy of this rectangle with its `side` extended by the given `amount` (see `Side` constants). A negative `amount` shrinks the rectangle, instead. See also `grow` and `grow_individual`.

### `has_area() -> bool`
- 限定：qualifiers=const

Returns `true` if this rectangle has positive width and height. See also `get_area`.

### `has_point(point: Vector2i) -> bool`
- 限定：qualifiers=const

Returns `true` if the rectangle contains the given `point`. By convention, points on the right and bottom edges are **not** included.
				**Note:** This method is not reliable for `Rect2i` with a *negative* `size`. Use `abs` first to get a valid rectangle.

### `intersection(b: Rect2i) -> Rect2i`
- 限定：qualifiers=const

Returns the intersection between this rectangle and `b`. If the rectangles do not intersect, returns an empty `Rect2i`.
				`codeblocks`
				`gdscript`
				var a = Rect2i(0, 0, 5, 10)
				var b = Rect2i(2, 0, 8, 4)

				var c = a.intersection(b) # c is Rect2i(2, 0, 3, 4)
				
				`csharp`
				var a = new Rect2I(0, 0, 5, 10);
				var b = new Rect2I(2, 0, 8, 4);

				var c = rect1.Intersection(rect2); // c is Rect2I(2, 0, 3, 4)
				
				
				**Note:** If you only need to know whether two rectangles are overlapping, use `intersects`, instead.

### `intersects(b: Rect2i) -> bool`
- 限定：qualifiers=const

Returns `true` if this rectangle overlaps with the `b` rectangle. The edges of both rectangles are excluded.

### `merge(b: Rect2i) -> Rect2i`
- 限定：qualifiers=const

Returns a `Rect2i` that encloses both this rectangle and `b` around the edges. See also `encloses`.

## 构造函数

### `Rect2i`

Constructs a `Rect2i` with its `position` and `size` set to `Vector2i.ZERO`.

### `Rect2i`

Constructs a `Rect2i` as a copy of the given `Rect2i`.

### `Rect2i`

Constructs a `Rect2i` from a `Rect2`. The floating-point coordinates are truncated.

### `Rect2i`

Constructs a `Rect2i` by `position` and `size`.

### `Rect2i`

Constructs a `Rect2i` by setting its `position` to (`x`, `y`), and its `size` to (`width`, `height`).

## 运算符

### `operator !=`

Returns `true` if the `position` or `size` of both rectangles are not equal.

### `operator ==`

Returns `true` if both `position` and `size` of the rectangles are equal, respectively.

## 教程链接

- [Math documentation index](None)
- [Vector math](None)

