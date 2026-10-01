# Color

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Color`
> 自动生成，勿手改。文件：`refs/godot-api/Color.md`

**摘要**：A color represented in RGBA format.

## 描述

A color represented in RGBA format by a red (`r`), green (`g`), blue (`b`), and alpha (`a`) component. Each component is a 32-bit floating-point value, usually ranging from `0.0` to `1.0`. Some properties (such as `CanvasItem.modulate`) may support values greater than `1.0`, for overbright or HDR (High Dynamic Range) colors.
		Colors can be created in a number of ways: By the various `Color` constructors, by static methods such as `from_hsv`, and by using a name from the set of standardized colors based on X11 color names (https://en.wikipedia.org/wiki/X11_color_names) with the addition of `TRANSPARENT`.
		Color constants cheatsheet (https://raw.githubusercontent.com/godotengine/godot-docs/master/img/color_constants.png)
		Although `Color` may be used to store values of any encoding, the red (`r`), green (`g`), and blue (`b`) properties of `Color` are expected by Godot to be encoded using the nonlinear sRGB transfer function (https://en.wikipedia.org/wiki/SRGB#Transfer_function_(%22gamma%22)) unless otherwise stated. This color encoding is used by many traditional art and web tools, making it easy to match colors between Godot and these tools. Godot uses Rec. ITU-R BT.709 (https://en.wikipedia.org/wiki/Rec._709) color primaries, which are used by the sRGB standard.
		All physical simulation, such as lighting calculations, and colorimetry transformations, such as `get_luminance`, must be performed on linearly encoded values to produce correct results. When performing these calculations, convert `Color` to and from linear encoding using `srgb_to_linear` and `linear_to_srgb`.
		**Note:** In a boolean context, a Color will evaluate to `false` if it is equal to `Color(0, 0, 0, 1)` (opaque black). Otherwise, a Color will always evaluate to `true`.
		**Note:** In C#, color constants are defined in the `Colors` static class instead of `skip-lint`Color. Additionally, named colors use `PascalCase` syntax instead of `UPPER_SNAKE_CASE`. For example, `skip-lint`Color.ALICE_BLUE in GDScript is `skip-lint`Colors.AliceBlue in C#.

## 属性

- **`a`** `float` = `1.0`
  - 其它属性：getter= · setter=
- **`a8`** `int` = `255`
  - 其它属性：getter= · setter=
- **`b`** `float` = `0.0`
  - 其它属性：getter= · setter=
- **`b8`** `int` = `0`
  - 其它属性：getter= · setter=
- **`g`** `float` = `0.0`
  - 其它属性：getter= · setter=
- **`g8`** `int` = `0`
  - 其它属性：getter= · setter=
- **`h`** `float` = `0.0`
  - 其它属性：getter= · setter=
- **`ok_hsl_h`** `float` = `0.0`
  - 其它属性：getter= · setter=
- **`ok_hsl_l`** `float` = `0.0`
  - 其它属性：getter= · setter=
- **`ok_hsl_s`** `float` = `0.0`
  - 其它属性：getter= · setter=
- **`r`** `float` = `0.0`
  - 其它属性：getter= · setter=
- **`r8`** `int` = `0`
  - 其它属性：getter= · setter=
- **`s`** `float` = `0.0`
  - 其它属性：getter= · setter=
- **`v`** `float` = `0.0`
  - 其它属性：getter= · setter=

## 方法

### `blend(over: Color) -> Color`
- 限定：qualifiers=const

Returns a new color resulting from overlaying this color over the given color. In a painting program, you can imagine it as the `over` color painted over this color (including alpha).
				`codeblocks`
				`gdscript`
				var bg = Color(0.0, 1.0, 0.0, 0.5) # Green with alpha of 50%
				var fg = Color(1.0, 0.0, 0.0, 0.5) # Red with alpha of 50%
				var blended_color = bg.blend(fg) # Brown with alpha of 75%
				
				`csharp`
				var bg = new Color(0.0f, 1.0f, 0.0f, 0.5f); // Green with alpha of 50%
				var fg = new Color(1.0f, 0.0f, 0.0f, 0.5f); // Red with alpha of 50%
				Color blendedColor = bg.Blend(fg); // Brown with alpha of 75%

### `clamp(min: Color = Color(0, 0, 0, 0), max: Color = Color(1, 1, 1, 1)) -> Color`
- 限定：qualifiers=const

Returns a new color with all components clamped between the components of `min` and `max`, by running `@GlobalScope.clamp` on each component.

### `darkened(amount: float) -> Color`
- 限定：qualifiers=const

Returns a new color resulting from making this color darker by the specified `amount` (ratio from 0.0 to 1.0). See also `lightened`.
				`codeblocks`
				`gdscript`
				var green = Color(0.0, 1.0, 0.0)
				var darkgreen = green.darkened(0.2) # 20% darker than regular green
				
				`csharp`
				var green = new Color(0.0f, 1.0f, 0.0f);
				Color darkgreen = green.Darkened(0.2f); // 20% darker than regular green

### `from_hsv(h: float, s: float, v: float, alpha: float = 1.0) -> Color`
- 限定：qualifiers=static

Constructs a color from an HSV profile (https://en.wikipedia.org/wiki/HSL_and_HSV). The hue (`h`), saturation (`s`), and value (`v`) are typically between 0.0 and 1.0.
				`codeblocks`
				`gdscript`
				var color = Color.from_hsv(0.58, 0.5, 0.79, 0.8)
				
				`csharp`
				var color = Color.FromHsv(0.58f, 0.5f, 0.79f, 0.8f);

### `from_ok_hsl(h: float, s: float, l: float, alpha: float = 1.0) -> Color`
- 限定：qualifiers=static

Constructs a color from an OK HSL profile (https://bottosson.github.io/posts/colorpicker/). The hue (`h`), saturation (`s`), and lightness (`l`) are typically between 0.0 and 1.0.
				`codeblocks`
				`gdscript`
				var color = Color.from_ok_hsl(0.58, 0.5, 0.79, 0.8)
				
				`csharp`
				var color = Color.FromOkHsl(0.58f, 0.5f, 0.79f, 0.8f);

### `from_rgba8(r8: int, g8: int, b8: int, a8: int = 255) -> Color`
- 限定：qualifiers=static

Returns a `Color` constructed from red (`r8`), green (`g8`), blue (`b8`), and optionally alpha (`a8`) integer channels, each divided by `255.0` for their final value.
				
```gdscript
				var red = Color.from_rgba8(255, 0, 0)             # Same as Color(1, 0, 0).
				var dark_blue = Color.from_rgba8(0, 0, 51)        # Same as Color(0, 0, 0.2).
				var my_color = Color.from_rgba8(306, 255, 0, 102) # Same as Color(1.2, 1, 0, 0.4).
				
```

				**Note:** Due to the lower precision of `from_rgba8` compared to the standard `Color` constructor, a color created with `from_rgba8` will generally not be equal to the same color created with the standard `Color` constructor. Use `is_equal_approx` for comparisons to avoid issues with floating-point precision error.

### `from_rgbe9995(rgbe: int) -> Color`
- 限定：qualifiers=static

Decodes a `Color` from an RGBE9995 format integer. See `Image.FORMAT_RGBE9995`.

### `from_string(str: String, default: Color) -> Color`
- 限定：qualifiers=static

Creates a `Color` from the given string, which can be either an HTML color code or a named color (case-insensitive). Returns `default` if the color cannot be inferred from the string.
				If you want to create a color from String in a constant expression, use the equivalent constructor instead (i.e. `Color("color string")`).

### `get_luminance() -> float`
- 限定：qualifiers=const

Returns the light intensity of the color, as a value between 0.0 and 1.0 (inclusive). This is useful when determining light or dark color. Colors with a luminance smaller than 0.5 can be generally considered dark.
				**Note:** `get_luminance` relies on the color using linear encoding to return an accurate relative luminance value. If the color uses the default nonlinear sRGB encoding, use `srgb_to_linear` to convert it to linear encoding first.

### `hex(hex: int) -> Color`
- 限定：keywords=from_rgba32 · qualifiers=static

Returns the `Color` associated with the provided `hex` integer in 32-bit RGBA format (8 bits per channel). This method is the inverse of `to_rgba32`.
				In GDScript and C#, the `int` is best visualized with hexadecimal notation (`"0x"` prefix, making it `"0xRRGGBBAA"`).
				`codeblocks`
				`gdscript`
				var red = Color.hex(0xff0000ff)
				var dark_cyan = Color.hex(0x008b8bff)
				var my_color = Color.hex(0xbbefd2a4)
				
				`csharp`
				var red = new Color(0xff0000ff);
				var dark_cyan = new Color(0x008b8bff);
				var my_color = new Color(0xbbefd2a4);
				
				
				If you want to use hex notation in a constant expression, use the equivalent constructor instead (i.e. `Color(0xRRGGBBAA)`).

### `hex64(hex: int) -> Color`
- 限定：keywords=from_rgba64 · qualifiers=static

Returns the `Color` associated with the provided `hex` integer in 64-bit RGBA format (16 bits per channel). This method is the inverse of `to_rgba64`.
				In GDScript and C#, the `int` is best visualized with hexadecimal notation (`"0x"` prefix, making it `"0xRRRRGGGGBBBBAAAA"`).

### `html(rgba: String) -> Color`
- 限定：qualifiers=static

Returns a new color from `rgba`, an HTML hexadecimal color string. `rgba` is not case-sensitive, and may be prefixed by a hash sign (`#`).
				`rgba` must be a valid three-digit or six-digit hexadecimal color string, and may contain an alpha channel value. If `rgba` does not contain an alpha channel value, an alpha channel value of 1.0 is applied. If `rgba` is invalid, returns an empty color.
				`codeblocks`
				`gdscript`
				var blue = Color.html("#0000ff") # blue is Color(0.0, 0.0, 1.0, 1.0)
				var green = Color.html("#0F0")   # green is Color(0.0, 1.0, 0.0, 1.0)
				var col = Color.html("663399cc") # col is Color(0.4, 0.2, 0.6, 0.8)
				
				`csharp`
				var blue = Color.FromHtml("#0000ff"); // blue is Color(0.0, 0.0, 1.0, 1.0)
				var green = Color.FromHtml("#0F0");   // green is Color(0.0, 1.0, 0.0, 1.0)
				var col = Color.FromHtml("663399cc"); // col is Color(0.4, 0.2, 0.6, 0.8)

### `html_is_valid(color: String) -> bool`
- 限定：qualifiers=static

Returns `true` if `color` is a valid HTML hexadecimal color string. The string must be a hexadecimal value (case-insensitive) of either 3, 4, 6 or 8 digits, and may be prefixed by a hash sign (`#`). This method is identical to `String.is_valid_html_color`.
				`codeblocks`
				`gdscript`
				Color.html_is_valid("#55aaFF")   # Returns true
				Color.html_is_valid("#55AAFF20") # Returns true
				Color.html_is_valid("55AAFF")    # Returns true
				Color.html_is_valid("#F2C")      # Returns true

				Color.html_is_valid("#AABBC")    # Returns false
				Color.html_is_valid("#55aaFF5")  # Returns false
				
				`csharp`
				Color.HtmlIsValid("#55AAFF");   // Returns true
				Color.HtmlIsValid("#55AAFF20"); // Returns true
				Color.HtmlIsValid("55AAFF");    // Returns true
				Color.HtmlIsValid("#F2C");      // Returns true

				Color.HtmlIsValid("#AABBC");    // Returns false
				Color.HtmlIsValid("#55aaFF5");  // Returns false

### `inverted() -> Color`
- 限定：qualifiers=const

Returns the color with its `r`, `g`, and `b` components inverted (`(1 - r, 1 - g, 1 - b, a)`).
				`codeblocks`
				`gdscript`
				var black = Color.WHITE.inverted()
				var color = Color(0.3, 0.4, 0.9)
				var inverted_color = color.inverted() # Equivalent to `Color(0.7, 0.6, 0.1)`
				
				`csharp`
				var black = Colors.White.Inverted();
				var color = new Color(0.3f, 0.4f, 0.9f);
				Color invertedColor = color.Inverted(); // Equivalent to `new Color(0.7f, 0.6f, 0.1f)`

### `is_equal_approx(to: Color) -> bool`
- 限定：qualifiers=const

Returns `true` if this color and `to` are approximately equal, by running `@GlobalScope.is_equal_approx` on each component.

### `lerp(to: Color, weight: float) -> Color`
- 限定：keywords=interpolate · qualifiers=const

Returns the linear interpolation between this color's components and `to`'s components. The interpolation factor `weight` should be between 0.0 and 1.0 (inclusive). See also `@GlobalScope.lerp`.
				`codeblocks`
				`gdscript`
				var red = Color(1.0, 0.0, 0.0)
				var aqua = Color(0.0, 1.0, 0.8)

				red.lerp(aqua, 0.2) # Returns Color(0.8, 0.2, 0.16)
				red.lerp(aqua, 0.5) # Returns Color(0.5, 0.5, 0.4)
				red.lerp(aqua, 1.0) # Returns Color(0.0, 1.0, 0.8)
				
				`csharp`
				var red = new Color(1.0f, 0.0f, 0.0f);
				var aqua = new Color(0.0f, 1.0f, 0.8f);

				red.Lerp(aqua, 0.2f); // Returns Color(0.8f, 0.2f, 0.16f)
				red.Lerp(aqua, 0.5f); // Returns Color(0.5f, 0.5f, 0.4f)
				red.Lerp(aqua, 1.0f); // Returns Color(0.0f, 1.0f, 0.8f)

### `lightened(amount: float) -> Color`
- 限定：qualifiers=const

Returns a new color resulting from making this color lighter by the specified `amount`, which should be a ratio from 0.0 to 1.0. See also `darkened`.
				`codeblocks`
				`gdscript`
				var green = Color(0.0, 1.0, 0.0)
				var light_green = green.lightened(0.2) # 20% lighter than regular green
				
				`csharp`
				var green = new Color(0.0f, 1.0f, 0.0f);
				Color lightGreen = green.Lightened(0.2f); // 20% lighter than regular green

### `linear_to_srgb() -> Color`
- 限定：qualifiers=const

Returns a copy of the color that is encoded using the nonlinear sRGB transfer function (https://en.wikipedia.org/wiki/SRGB). This method requires the original color to use linear encoding. See also `srgb_to_linear` which performs the opposite operation.
				**Note:** The color's alpha channel (`a`) is not affected. The alpha channel is always stored with linear encoding, regardless of the color space of the other color channels.

### `srgb_to_linear() -> Color`
- 限定：qualifiers=const

Returns a copy of the color that uses linear encoding. This method requires the original color to be encoded using the nonlinear sRGB transfer function (https://en.wikipedia.org/wiki/SRGB). See also `linear_to_srgb` which performs the opposite operation.
				**Note:** The color's alpha channel (`a`) is not affected. The alpha channel is always stored with linear encoding, regardless of the color space of the other color channels.

### `to_abgr32() -> int`
- 限定：qualifiers=const

Returns the color converted to a 32-bit integer in ABGR format (each component is 8 bits). ABGR is the reversed version of the default RGBA format.
				`codeblocks`
				`gdscript`
				var color = Color(1, 0.5, 0.2)
				print(color.to_abgr32()) # Prints 4281565439
				
				`csharp`
				var color = new Color(1.0f, 0.5f, 0.2f);
				GD.Print(color.ToAbgr32()); // Prints 4281565439

### `to_abgr64() -> int`
- 限定：qualifiers=const

Returns the color converted to a 64-bit integer in ABGR format (each component is 16 bits). ABGR is the reversed version of the default RGBA format.
				`codeblocks`
				`gdscript`
				var color = Color(1, 0.5, 0.2)
				print(color.to_abgr64()) # Prints -225178692812801
				
				`csharp`
				var color = new Color(1.0f, 0.5f, 0.2f);
				GD.Print(color.ToAbgr64()); // Prints -225178692812801

### `to_argb32() -> int`
- 限定：qualifiers=const

Returns the color converted to a 32-bit integer in ARGB format (each component is 8 bits). ARGB is more compatible with DirectX.
				`codeblocks`
				`gdscript`
				var color = Color(1, 0.5, 0.2)
				print(color.to_argb32()) # Prints 4294934323
				
				`csharp`
				var color = new Color(1.0f, 0.5f, 0.2f);
				GD.Print(color.ToArgb32()); // Prints 4294934323

### `to_argb64() -> int`
- 限定：qualifiers=const

Returns the color converted to a 64-bit integer in ARGB format (each component is 16 bits). ARGB is more compatible with DirectX.
				`codeblocks`
				`gdscript`
				var color = Color(1, 0.5, 0.2)
				print(color.to_argb64()) # Prints -2147470541
				
				`csharp`
				var color = new Color(1.0f, 0.5f, 0.2f);
				GD.Print(color.ToArgb64()); // Prints -2147470541

### `to_html(with_alpha: bool = true) -> String`
- 限定：qualifiers=const

Returns the color converted to an HTML hexadecimal color `String` in RGBA format, without the hash (`#`) prefix.
				Setting `with_alpha` to `false`, excludes alpha from the hexadecimal string, using RGB format instead of RGBA format.
				`codeblocks`
				`gdscript`
				var white = Color(1, 1, 1, 0.5)
				var with_alpha = white.to_html() # Returns "ffffff7f"
				var without_alpha = white.to_html(false) # Returns "ffffff"
				
				`csharp`
				var white = new Color(1, 1, 1, 0.5f);
				string withAlpha = white.ToHtml(); // Returns "ffffff7f"
				string withoutAlpha = white.ToHtml(false); // Returns "ffffff"

### `to_rgba32() -> int`
- 限定：keywords=to_hex · qualifiers=const

Returns the color converted to a 32-bit integer in RGBA format (each component is 8 bits). RGBA is Godot's default format. This method is the inverse of `hex`.
				`codeblocks`
				`gdscript`
				var color = Color(1, 0.5, 0.2)
				print(color.to_rgba32()) # Prints 4286526463
				
				`csharp`
				var color = new Color(1, 0.5f, 0.2f);
				GD.Print(color.ToRgba32()); // Prints 4286526463

### `to_rgba64() -> int`
- 限定：keywords=to_hex64 · qualifiers=const

Returns the color converted to a 64-bit integer in RGBA format (each component is 16 bits). RGBA is Godot's default format. This method is the inverse of `hex64`.
				`codeblocks`
				`gdscript`
				var color = Color(1, 0.5, 0.2)
				print(color.to_rgba64()) # Prints -140736629309441
				
				`csharp`
				var color = new Color(1, 0.5f, 0.2f);
				GD.Print(color.ToRgba64()); // Prints -140736629309441

## 常量

- **`ALICE_BLUE`** = `Color(0.9411765, 0.972549, 1, 1)`
- **`ANTIQUE_WHITE`** = `Color(0.98039216, 0.92156863, 0.84313726, 1)`
- **`AQUA`** = `Color(0, 1, 1, 1)`
- **`AQUAMARINE`** = `Color(0.49803922, 1, 0.83137256, 1)`
- **`AZURE`** = `Color(0.9411765, 1, 1, 1)`
- **`BEIGE`** = `Color(0.9607843, 0.9607843, 0.8627451, 1)`
- **`BISQUE`** = `Color(1, 0.89411765, 0.76862746, 1)`
- **`BLACK`** = `Color(0, 0, 0, 1)`
- **`BLANCHED_ALMOND`** = `Color(1, 0.92156863, 0.8039216, 1)`
- **`BLUE`** = `Color(0, 0, 1, 1)`
- **`BLUE_VIOLET`** = `Color(0.5411765, 0.16862746, 0.8862745, 1)`
- **`BROWN`** = `Color(0.64705884, 0.16470589, 0.16470589, 1)`
- **`BURLYWOOD`** = `Color(0.87058824, 0.72156864, 0.5294118, 1)`
- **`CADET_BLUE`** = `Color(0.37254903, 0.61960787, 0.627451, 1)`
- **`CHARTREUSE`** = `Color(0.49803922, 1, 0, 1)`
- **`CHOCOLATE`** = `Color(0.8235294, 0.4117647, 0.11764706, 1)`
- **`CORAL`** = `Color(1, 0.49803922, 0.3137255, 1)`
- **`CORNFLOWER_BLUE`** = `Color(0.39215687, 0.58431375, 0.92941177, 1)`
- **`CORNSILK`** = `Color(1, 0.972549, 0.8627451, 1)`
- **`CRIMSON`** = `Color(0.8627451, 0.078431375, 0.23529412, 1)`
- **`CYAN`** = `Color(0, 1, 1, 1)`
- **`DARK_BLUE`** = `Color(0, 0, 0.54509807, 1)`
- **`DARK_CYAN`** = `Color(0, 0.54509807, 0.54509807, 1)`
- **`DARK_GOLDENROD`** = `Color(0.72156864, 0.5254902, 0.043137256, 1)`
- **`DARK_GRAY`** = `Color(0.6627451, 0.6627451, 0.6627451, 1)`
- **`DARK_GREEN`** = `Color(0, 0.39215687, 0, 1)`
- **`DARK_KHAKI`** = `Color(0.7411765, 0.7176471, 0.41960785, 1)`
- **`DARK_MAGENTA`** = `Color(0.54509807, 0, 0.54509807, 1)`
- **`DARK_OLIVE_GREEN`** = `Color(0.33333334, 0.41960785, 0.18431373, 1)`
- **`DARK_ORANGE`** = `Color(1, 0.54901963, 0, 1)`
- **`DARK_ORCHID`** = `Color(0.6, 0.19607843, 0.8, 1)`
- **`DARK_RED`** = `Color(0.54509807, 0, 0, 1)`
- **`DARK_SALMON`** = `Color(0.9137255, 0.5882353, 0.47843137, 1)`
- **`DARK_SEA_GREEN`** = `Color(0.56078434, 0.7372549, 0.56078434, 1)`
- **`DARK_SLATE_BLUE`** = `Color(0.28235295, 0.23921569, 0.54509807, 1)`
- **`DARK_SLATE_GRAY`** = `Color(0.18431373, 0.30980393, 0.30980393, 1)`
- **`DARK_TURQUOISE`** = `Color(0, 0.80784315, 0.81960785, 1)`
- **`DARK_VIOLET`** = `Color(0.5803922, 0, 0.827451, 1)`
- **`DEEP_PINK`** = `Color(1, 0.078431375, 0.5764706, 1)`
- **`DEEP_SKY_BLUE`** = `Color(0, 0.7490196, 1, 1)`
- **`DIM_GRAY`** = `Color(0.4117647, 0.4117647, 0.4117647, 1)`
- **`DODGER_BLUE`** = `Color(0.11764706, 0.5647059, 1, 1)`
- **`FIREBRICK`** = `Color(0.69803923, 0.13333334, 0.13333334, 1)`
- **`FLORAL_WHITE`** = `Color(1, 0.98039216, 0.9411765, 1)`
- **`FOREST_GREEN`** = `Color(0.13333334, 0.54509807, 0.13333334, 1)`
- **`FUCHSIA`** = `Color(1, 0, 1, 1)`
- **`GAINSBORO`** = `Color(0.8627451, 0.8627451, 0.8627451, 1)`
- **`GHOST_WHITE`** = `Color(0.972549, 0.972549, 1, 1)`
- **`GOLD`** = `Color(1, 0.84313726, 0, 1)`
- **`GOLDENROD`** = `Color(0.85490197, 0.64705884, 0.1254902, 1)`
- **`GRAY`** = `Color(0.74509805, 0.74509805, 0.74509805, 1)`
- **`GREEN`** = `Color(0, 1, 0, 1)`
- **`GREEN_YELLOW`** = `Color(0.6784314, 1, 0.18431373, 1)`
- **`HONEYDEW`** = `Color(0.9411765, 1, 0.9411765, 1)`
- **`HOT_PINK`** = `Color(1, 0.4117647, 0.7058824, 1)`
- **`INDIAN_RED`** = `Color(0.8039216, 0.36078432, 0.36078432, 1)`
- **`INDIGO`** = `Color(0.29411766, 0, 0.50980395, 1)`
- **`IVORY`** = `Color(1, 1, 0.9411765, 1)`
- **`KHAKI`** = `Color(0.9411765, 0.9019608, 0.54901963, 1)`
- **`LAVENDER`** = `Color(0.9019608, 0.9019608, 0.98039216, 1)`
- **`LAVENDER_BLUSH`** = `Color(1, 0.9411765, 0.9607843, 1)`
- **`LAWN_GREEN`** = `Color(0.4862745, 0.9882353, 0, 1)`
- **`LEMON_CHIFFON`** = `Color(1, 0.98039216, 0.8039216, 1)`
- **`LIGHT_BLUE`** = `Color(0.6784314, 0.84705883, 0.9019608, 1)`
- **`LIGHT_CORAL`** = `Color(0.9411765, 0.5019608, 0.5019608, 1)`
- **`LIGHT_CYAN`** = `Color(0.8784314, 1, 1, 1)`
- **`LIGHT_GOLDENROD`** = `Color(0.98039216, 0.98039216, 0.8235294, 1)`
- **`LIGHT_GRAY`** = `Color(0.827451, 0.827451, 0.827451, 1)`
- **`LIGHT_GREEN`** = `Color(0.5647059, 0.93333334, 0.5647059, 1)`
- **`LIGHT_PINK`** = `Color(1, 0.7137255, 0.75686276, 1)`
- **`LIGHT_SALMON`** = `Color(1, 0.627451, 0.47843137, 1)`
- **`LIGHT_SEA_GREEN`** = `Color(0.1254902, 0.69803923, 0.6666667, 1)`
- **`LIGHT_SKY_BLUE`** = `Color(0.5294118, 0.80784315, 0.98039216, 1)`
- **`LIGHT_SLATE_GRAY`** = `Color(0.46666667, 0.53333336, 0.6, 1)`
- **`LIGHT_STEEL_BLUE`** = `Color(0.6901961, 0.76862746, 0.87058824, 1)`
- **`LIGHT_YELLOW`** = `Color(1, 1, 0.8784314, 1)`
- **`LIME`** = `Color(0, 1, 0, 1)`
- **`LIME_GREEN`** = `Color(0.19607843, 0.8039216, 0.19607843, 1)`
- **`LINEN`** = `Color(0.98039216, 0.9411765, 0.9019608, 1)`
- **`MAGENTA`** = `Color(1, 0, 1, 1)`
- **`MAROON`** = `Color(0.6901961, 0.1882353, 0.3764706, 1)`
- **`MEDIUM_AQUAMARINE`** = `Color(0.4, 0.8039216, 0.6666667, 1)`
- **`MEDIUM_BLUE`** = `Color(0, 0, 0.8039216, 1)`
- **`MEDIUM_ORCHID`** = `Color(0.7294118, 0.33333334, 0.827451, 1)`
- **`MEDIUM_PURPLE`** = `Color(0.5764706, 0.4392157, 0.85882354, 1)`
- **`MEDIUM_SEA_GREEN`** = `Color(0.23529412, 0.7019608, 0.44313726, 1)`
- **`MEDIUM_SLATE_BLUE`** = `Color(0.48235294, 0.40784314, 0.93333334, 1)`
- **`MEDIUM_SPRING_GREEN`** = `Color(0, 0.98039216, 0.6039216, 1)`
- **`MEDIUM_TURQUOISE`** = `Color(0.28235295, 0.81960785, 0.8, 1)`
- **`MEDIUM_VIOLET_RED`** = `Color(0.78039217, 0.08235294, 0.52156866, 1)`
- **`MIDNIGHT_BLUE`** = `Color(0.09803922, 0.09803922, 0.4392157, 1)`
- **`MINT_CREAM`** = `Color(0.9607843, 1, 0.98039216, 1)`
- **`MISTY_ROSE`** = `Color(1, 0.89411765, 0.88235295, 1)`
- **`MOCCASIN`** = `Color(1, 0.89411765, 0.70980394, 1)`
- **`NAVAJO_WHITE`** = `Color(1, 0.87058824, 0.6784314, 1)`
- **`NAVY_BLUE`** = `Color(0, 0, 0.5019608, 1)`
- **`OLD_LACE`** = `Color(0.99215686, 0.9607843, 0.9019608, 1)`
- **`OLIVE`** = `Color(0.5019608, 0.5019608, 0, 1)`
- **`OLIVE_DRAB`** = `Color(0.41960785, 0.5568628, 0.13725491, 1)`
- **`ORANGE`** = `Color(1, 0.64705884, 0, 1)`
- **`ORANGE_RED`** = `Color(1, 0.27058825, 0, 1)`
- **`ORCHID`** = `Color(0.85490197, 0.4392157, 0.8392157, 1)`
- **`PALE_GOLDENROD`** = `Color(0.93333334, 0.9098039, 0.6666667, 1)`
- **`PALE_GREEN`** = `Color(0.59607846, 0.9843137, 0.59607846, 1)`
- **`PALE_TURQUOISE`** = `Color(0.6862745, 0.93333334, 0.93333334, 1)`
- **`PALE_VIOLET_RED`** = `Color(0.85882354, 0.4392157, 0.5764706, 1)`
- **`PAPAYA_WHIP`** = `Color(1, 0.9372549, 0.8352941, 1)`
- **`PEACH_PUFF`** = `Color(1, 0.85490197, 0.7254902, 1)`
- **`PERU`** = `Color(0.8039216, 0.52156866, 0.24705882, 1)`
- **`PINK`** = `Color(1, 0.7529412, 0.79607844, 1)`
- **`PLUM`** = `Color(0.8666667, 0.627451, 0.8666667, 1)`
- **`POWDER_BLUE`** = `Color(0.6901961, 0.8784314, 0.9019608, 1)`
- **`PURPLE`** = `Color(0.627451, 0.1254902, 0.9411765, 1)`
- **`REBECCA_PURPLE`** = `Color(0.4, 0.2, 0.6, 1)`
- **`RED`** = `Color(1, 0, 0, 1)`
- **`ROSY_BROWN`** = `Color(0.7372549, 0.56078434, 0.56078434, 1)`
- **`ROYAL_BLUE`** = `Color(0.25490198, 0.4117647, 0.88235295, 1)`
- **`SADDLE_BROWN`** = `Color(0.54509807, 0.27058825, 0.07450981, 1)`
- **`SALMON`** = `Color(0.98039216, 0.5019608, 0.44705883, 1)`
- **`SANDY_BROWN`** = `Color(0.95686275, 0.6431373, 0.3764706, 1)`
- **`SEA_GREEN`** = `Color(0.18039216, 0.54509807, 0.34117648, 1)`
- **`SEASHELL`** = `Color(1, 0.9607843, 0.93333334, 1)`
- **`SIENNA`** = `Color(0.627451, 0.32156864, 0.1764706, 1)`
- **`SILVER`** = `Color(0.7529412, 0.7529412, 0.7529412, 1)`
- **`SKY_BLUE`** = `Color(0.5294118, 0.80784315, 0.92156863, 1)`
- **`SLATE_BLUE`** = `Color(0.41568628, 0.3529412, 0.8039216, 1)`
- **`SLATE_GRAY`** = `Color(0.4392157, 0.5019608, 0.5647059, 1)`
- **`SNOW`** = `Color(1, 0.98039216, 0.98039216, 1)`
- **`SPRING_GREEN`** = `Color(0, 1, 0.49803922, 1)`
- **`STEEL_BLUE`** = `Color(0.27450982, 0.50980395, 0.7058824, 1)`
- **`TAN`** = `Color(0.8235294, 0.7058824, 0.54901963, 1)`
- **`TEAL`** = `Color(0, 0.5019608, 0.5019608, 1)`
- **`THISTLE`** = `Color(0.84705883, 0.7490196, 0.84705883, 1)`
- **`TOMATO`** = `Color(1, 0.3882353, 0.2784314, 1)`
- **`TRANSPARENT`** = `Color(1, 1, 1, 0)`
- **`TURQUOISE`** = `Color(0.2509804, 0.8784314, 0.8156863, 1)`
- **`VIOLET`** = `Color(0.93333334, 0.50980395, 0.93333334, 1)`
- **`WEB_GRAY`** = `Color(0.5019608, 0.5019608, 0.5019608, 1)`
- **`WEB_GREEN`** = `Color(0, 0.5019608, 0, 1)`
- **`WEB_MAROON`** = `Color(0.5019608, 0, 0, 1)`
- **`WEB_PURPLE`** = `Color(0.5019608, 0, 0.5019608, 1)`
- **`WHEAT`** = `Color(0.9607843, 0.87058824, 0.7019608, 1)`
- **`WHITE`** = `Color(1, 1, 1, 1)`
- **`WHITE_SMOKE`** = `Color(0.9607843, 0.9607843, 0.9607843, 1)`
- **`YELLOW`** = `Color(1, 1, 0, 1)`
- **`YELLOW_GREEN`** = `Color(0.6039216, 0.8039216, 0.19607843, 1)`
## 构造函数

### `Color`

Constructs a default `Color` from opaque black. This is the same as `BLACK`.
				**Note:** In C#, this constructs a `Color` with all of its components set to `0.0` (transparent black).

### `Color`

Constructs a `Color` from the existing color, with `a` set to the given `alpha` value.
				`codeblocks`
				`gdscript`
				var red = Color(Color.RED, 0.2) # 20% opaque red.
				
				`csharp`
				var red = new Color(Colors.Red, 0.2f); // 20% opaque red.

### `Color`

Constructs a `Color` as a copy of the given `Color`.

### `Color`

Constructs a `Color` either from an HTML color code or from a standardized color name. The supported color names are the same as the constants.

### `Color`

Constructs a `Color` either from an HTML color code or from a standardized color name, with `alpha` on the range of 0.0 to 1.0. The supported color names are the same as the constants.

### `Color`

Constructs a `Color` from RGB values, typically between 0.0 and 1.0. `a` is set to 1.0.
				`codeblocks`
				`gdscript`
				var color = Color(0.2, 1.0, 0.7) # Similar to `Color.from_rgba8(51, 255, 178, 255)`
				
				`csharp`
				var color = new Color(0.2f, 1.0f, 0.7f); // Similar to `Color.Color8(51, 255, 178, 255)`

### `Color`

Constructs a `Color` from RGBA values, typically between 0.0 and 1.0.
				`codeblocks`
				`gdscript`
				var color = Color(0.2, 1.0, 0.7, 0.8) # Similar to `Color.from_rgba8(51, 255, 178, 204)`
				
				`csharp`
				var color = new Color(0.2f, 1.0f, 0.7f, 0.8f); // Similar to `Color.Color8(51, 255, 178, 255, 204)`

## 运算符

### `operator !=`

Returns `true` if the colors are not exactly equal.
				**Note:** Due to floating-point precision errors, consider using `is_equal_approx` instead, which is more reliable.

### `operator *`

Multiplies each component of the `Color` by the components of the given `Color`.

### `operator *`

Multiplies each component of the `Color` by the given `float`.

### `operator *`

Multiplies each component of the `Color` by the given `int`.

### `operator +`

Adds each component of the `Color` with the components of the given `Color`.

### `operator -`

Subtracts each component of the `Color` by the components of the given `Color`.

### `operator /`

Divides each component of the `Color` by the components of the given `Color`.

### `operator /`

Divides each component of the `Color` by the given `float`.

### `operator /`

Divides each component of the `Color` by the given `int`.

### `operator ==`

Returns `true` if the colors are exactly equal.
				**Note:** Due to floating-point precision errors, consider using `is_equal_approx` instead, which is more reliable.

### `operator []`

Access color components using their index. `[0]` is equivalent to `r`, `[1]` is equivalent to `g`, `[2]` is equivalent to `b`, and `[3]` is equivalent to `a`.

### `operator unary+`

Returns the same value as if the `+` was not there. Unary `+` does nothing, but sometimes it can make your code more readable.

### `operator unary-`

Inverts the given color. This is equivalent to `Color.WHITE - c` or `Color(1 - c.r, 1 - c.g, 1 - c.b, 1 - c.a)`. Unlike with `inverted`, the `a` component is inverted, too.

## 教程链接

- [2D GD Paint Demo](None)
- [Tween Interpolation Demo](None)
- [GUI Drag And Drop Demo](None)

