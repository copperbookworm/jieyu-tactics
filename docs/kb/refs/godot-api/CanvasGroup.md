# CanvasGroup

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`CanvasGroup` → `Node2D` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/CanvasGroup.md`

**摘要**：Merges several 2D nodes into a single draw operation.

## 描述

Child `CanvasItem` nodes of a `CanvasGroup` are drawn as a single object. It allows to e.g. draw overlapping translucent 2D nodes without causing the overlapping sections to be more opaque than intended (set the `CanvasItem.self_modulate` property on the `CanvasGroup` to achieve this effect).
		**Note:** The `CanvasGroup` uses a custom shader to read from the backbuffer to draw its children. Assigning a `Material` to the `CanvasGroup` overrides the built-in shader. To duplicate the behavior of the built-in shader in a custom `Shader`, use the following:
		
```gdscript
		shader_type canvas_item;
		render_mode unshaded;

		uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

		void fragment() {
			vec4 c = textureLod(screen_texture, SCREEN_UV, 0.0);

			if (c.a > 0.0001) {
				c.rgb /= c.a;
			}

			COLOR *= c;
		}
		
```

		**Note:** Since `CanvasGroup` and `CanvasItem.clip_children` both utilize the backbuffer, children of a `CanvasGroup` who have their `CanvasItem.clip_children` set to anything other than `CanvasItem.CLIP_CHILDREN_DISABLED` will not function correctly.

## 属性

- **`clear_margin`** `float` = `10.0`
  - 其它属性：getter=get_clear_margin · setter=set_clear_margin
- **`fit_margin`** `float` = `10.0`
  - 其它属性：getter=get_fit_margin · setter=set_fit_margin
- **`use_mipmaps`** `bool` = `false`
  - 其它属性：getter=is_using_mipmaps · setter=set_use_mipmaps

